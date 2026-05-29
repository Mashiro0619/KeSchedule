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

  String get occurrenceKey =>
      buildGeneralOccurrenceKey(calendar.id, event.id, start.toIso8601String());

  bool get isAllDay => event.isAllDay;
}

class GeneralOccurrenceKeyParts {
  const GeneralOccurrenceKeyParts({
    required this.calendarId,
    required this.eventId,
    required this.startDateTimeIso,
  });

  final String calendarId;
  final String eventId;
  final String startDateTimeIso;
}

String buildGeneralOccurrenceKey(
  String calendarId,
  String eventId,
  String startDateTimeIso,
) {
  return [
    'v2',
    Uri.encodeComponent(calendarId),
    Uri.encodeComponent(eventId),
    Uri.encodeComponent(startDateTimeIso),
  ].join('|');
}

GeneralOccurrenceKeyParts? parseGeneralOccurrenceKey(String key) {
  final parts = key.split('|');
  if (parts.length == 4 && parts.first == 'v2') {
    return _parseVersionedGeneralOccurrenceKey(parts);
  }
  if (parts.length == 3) {
    return GeneralOccurrenceKeyParts(
      calendarId: parts[0],
      eventId: parts[1],
      startDateTimeIso: parts[2],
    );
  }
  return null;
}

bool generalOccurrenceKeyMatches(
  String key, {
  required String calendarId,
  required String eventId,
  required String startDateTimeIso,
}) {
  final parsed = parseGeneralOccurrenceKey(key);
  if (parsed != null) {
    return parsed.calendarId == calendarId &&
        parsed.eventId == eventId &&
        parsed.startDateTimeIso == startDateTimeIso;
  }
  return key == '$calendarId|$eventId|$startDateTimeIso';
}

GeneralOccurrenceKeyParts? _parseVersionedGeneralOccurrenceKey(
  List<String> parts,
) {
  try {
    return GeneralOccurrenceKeyParts(
      calendarId: Uri.decodeComponent(parts[1]),
      eventId: Uri.decodeComponent(parts[2]),
      startDateTimeIso: Uri.decodeComponent(parts[3]),
    );
  } on FormatException {
    return null;
  } on ArgumentError {
    return null;
  }
}

enum GeneralReminderStatus { upcoming, inProgress, overdue }

class GeneralReminderItem {
  const GeneralReminderItem({required this.occurrence, required this.status});

  final GeneralEventOccurrence occurrence;
  final GeneralReminderStatus status;
}

class GeneralOccurrenceQuery {
  const GeneralOccurrenceQuery({
    required this.startInclusive,
    required this.endExclusive,
    this.onlyVisibleCalendars = true,
    this.searchQuery = '',
    this.colorValue,
  });

  final DateTime startInclusive;
  final DateTime endExclusive;
  final bool onlyVisibleCalendars;
  final String searchQuery;
  final int? colorValue;

  bool get hasFilter => searchQuery.trim().isNotEmpty || colorValue != null;

  bool matches(GeneralEventOccurrence occurrence) {
    if (colorValue != null &&
        (occurrence.event.colorValue ?? occurrence.calendar.colorValue) !=
            colorValue) {
      return false;
    }
    final normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }
    return [
      occurrence.event.title,
      occurrence.event.location,
      occurrence.event.notes,
      occurrence.calendar.name,
    ].any((value) => value.toLowerCase().contains(normalizedQuery));
  }
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
  final eventStart = tryParseStrictIsoDateTime(event.startDateTimeIso);
  final eventEnd = tryParseStrictIsoDateTime(event.endDateTimeIso);
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
  return tryParseStrictIsoDate(value);
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
