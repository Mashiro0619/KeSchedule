import '../utils/time_utils.dart';
import 'general_event.dart';
import 'general_schedule.dart';

class GeneralEventOccurrence {
  const GeneralEventOccurrence({
    required this.event,
    required this.calendar,
    required this.start,
    required this.end,
    required this.sequence,
  });

  final GeneralEvent event;
  final GeneralSchedule calendar;
  final DateTime start;
  final DateTime end;
  final int sequence;

  String get exceptionDateIso =>
      normalizeDateOnly(start).toIso8601String().split('T').first;

  bool get isAllDay => event.isAllDay;
}

List<GeneralEventOccurrence> expandGeneralOccurrences({
  required Iterable<GeneralSchedule> calendars,
  required DateTime startInclusive,
  required DateTime endExclusive,
  bool onlyVisibleCalendars = true,
}) {
  final results = <GeneralEventOccurrence>[];
  for (final calendar in calendars) {
    if (onlyVisibleCalendars && !calendar.isVisible) {
      continue;
    }
    for (final event in calendar.events) {
      results.addAll(
        expandGeneralEventOccurrences(
          calendar: calendar,
          event: event,
          startInclusive: startInclusive,
          endExclusive: endExclusive,
        ),
      );
    }
  }
  results.sort((a, b) {
    final startCompare = a.start.compareTo(b.start);
    if (startCompare != 0) return startCompare;
    final allDayCompare = (b.isAllDay ? 1 : 0).compareTo(a.isAllDay ? 1 : 0);
    if (allDayCompare != 0) return allDayCompare;
    final endCompare = a.end.compareTo(b.end);
    if (endCompare != 0) return endCompare;
    return a.event.title.compareTo(b.event.title);
  });
  return results;
}

List<GeneralEventOccurrence> expandGeneralEventOccurrences({
  required GeneralSchedule calendar,
  required GeneralEvent event,
  required DateTime startInclusive,
  required DateTime endExclusive,
}) {
  final eventStart = DateTime.tryParse(event.startDateTimeIso);
  final eventEnd = DateTime.tryParse(event.endDateTimeIso);
  if (eventStart == null ||
      eventEnd == null ||
      !endExclusive.isAfter(startInclusive)) {
    return const [];
  }
  final duration = eventEnd.isAfter(eventStart)
      ? eventEnd.difference(eventStart)
      : const Duration(hours: 1);
  final rule = event.recurrenceRule;
  if (!rule.isRepeating) {
    return _overlaps(
          eventStart,
          eventStart.add(duration),
          startInclusive,
          endExclusive,
        )
        ? [
            GeneralEventOccurrence(
              calendar: calendar,
              event: event,
              start: eventStart,
              end: eventStart.add(duration),
              sequence: 0,
            ),
          ]
        : const [];
  }

  final exceptions = event.recurrenceExceptionDateIso.toSet();
  final until = _parseUntil(rule.untilDateIso);
  final maxCount = rule.count == null || rule.count! < 1 ? null : rule.count!;
  final firstCandidateIndex = _firstCandidateIndex(
    eventStart: eventStart,
    rangeStart: startInclusive.subtract(duration),
    rule: rule,
  );
  final results = <GeneralEventOccurrence>[];
  var index = firstCandidateIndex;
  while (true) {
    if (maxCount != null && index >= maxCount) {
      break;
    }
    final occurrenceStart = _addRecurrenceSteps(eventStart, rule, index);
    if (occurrenceStart == null) {
      break;
    }
    if (until != null && normalizeDateOnly(occurrenceStart).isAfter(until)) {
      break;
    }
    final occurrenceEnd = occurrenceStart.add(duration);
    if (!occurrenceStart.isBefore(endExclusive) &&
        !_overlaps(
          occurrenceStart,
          occurrenceEnd,
          startInclusive,
          endExclusive,
        )) {
      break;
    }
    final exceptionKey = normalizeDateOnly(
      occurrenceStart,
    ).toIso8601String().split('T').first;
    if (!exceptions.contains(exceptionKey) &&
        _overlaps(
          occurrenceStart,
          occurrenceEnd,
          startInclusive,
          endExclusive,
        )) {
      results.add(
        GeneralEventOccurrence(
          calendar: calendar,
          event: event,
          start: occurrenceStart,
          end: occurrenceEnd,
          sequence: index,
        ),
      );
    }
    index += 1;
    if (index - firstCandidateIndex > 3700) {
      break;
    }
  }
  return results;
}

bool _overlaps(
  DateTime start,
  DateTime end,
  DateTime startInclusive,
  DateTime endExclusive,
) {
  return end.isAfter(startInclusive) && start.isBefore(endExclusive);
}

DateTime? _parseUntil(String? value) {
  final parsed = DateTime.tryParse(value ?? '');
  return parsed == null ? null : normalizeDateOnly(parsed);
}

int _firstCandidateIndex({
  required DateTime eventStart,
  required DateTime rangeStart,
  required GeneralEventRecurrenceRule rule,
}) {
  if (!rangeStart.isAfter(eventStart)) {
    return 0;
  }
  final interval = rule.normalizedInterval;
  final unit = _effectiveUnit(rule);
  switch (unit) {
    case GeneralEventRecurrenceUnit.day:
      final days = normalizeDateOnly(
        rangeStart,
      ).difference(normalizeDateOnly(eventStart)).inDays;
      return (days ~/ interval).clamp(0, 1 << 30).toInt();
    case GeneralEventRecurrenceUnit.week:
      final days = normalizeDateOnly(
        rangeStart,
      ).difference(normalizeDateOnly(eventStart)).inDays;
      return (days ~/ (7 * interval)).clamp(0, 1 << 30).toInt();
    case GeneralEventRecurrenceUnit.month:
      final months =
          (rangeStart.year - eventStart.year) * 12 +
          (rangeStart.month - eventStart.month);
      return (months ~/ interval).clamp(0, 1 << 30).toInt();
  }
}

GeneralEventRecurrenceUnit _effectiveUnit(GeneralEventRecurrenceRule rule) {
  return switch (rule.type) {
    GeneralEventRecurrence.daily => GeneralEventRecurrenceUnit.day,
    GeneralEventRecurrence.weekly => GeneralEventRecurrenceUnit.week,
    GeneralEventRecurrence.monthly => GeneralEventRecurrenceUnit.month,
    GeneralEventRecurrence.custom => rule.unit,
    GeneralEventRecurrence.none => rule.unit,
  };
}

DateTime? _addRecurrenceSteps(
  DateTime start,
  GeneralEventRecurrenceRule rule,
  int index,
) {
  final interval = rule.normalizedInterval;
  final amount = index * interval;
  return switch (_effectiveUnit(rule)) {
    GeneralEventRecurrenceUnit.day => start.add(Duration(days: amount)),
    GeneralEventRecurrenceUnit.week => start.add(Duration(days: amount * 7)),
    GeneralEventRecurrenceUnit.month => _addMonths(start, amount),
  };
}

DateTime _addMonths(DateTime start, int months) {
  final targetMonthZero = (start.month - 1) + months;
  final year = start.year + (targetMonthZero ~/ 12);
  final month = (targetMonthZero % 12) + 1;
  final day = start.day.clamp(1, _daysInMonth(year, month)).toInt();
  return DateTime(
    year,
    month,
    day,
    start.hour,
    start.minute,
    start.second,
    start.millisecond,
    start.microsecond,
  );
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}
