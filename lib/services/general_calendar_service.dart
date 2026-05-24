import '../models/general_event.dart';
import '../models/general_event_occurrence.dart';
import '../models/general_schedule.dart';
import '../models/general_schedule_data.dart';

class GeneralEventMutationResult {
  const GeneralEventMutationResult({required this.data, required this.event});

  final GeneralScheduleData data;
  final GeneralEvent event;
}

/// Pure mutation helpers for general-mode calendars and events.
///
/// The provider owns persistence and notifyListeners calls; this service only returns
/// the next [GeneralScheduleData] tree.
class GeneralCalendarService {
  const GeneralCalendarService();

  GeneralScheduleData switchSchedule(
    GeneralScheduleData data,
    String scheduleId,
  ) {
    if (data.activeScheduleId == scheduleId) return data;
    if (!data.schedules.any((s) => s.id == scheduleId)) return data;
    return data.copyWith(activeScheduleId: scheduleId);
  }

  GeneralScheduleData addSchedule(
    GeneralScheduleData data, {
    String? name,
    int? colorValue,
  }) {
    final schedule = createDefaultGeneralSchedule(
      name: (name != null && name.trim().isNotEmpty)
          ? name.trim()
          : 'My calendar',
      colorValue: colorValue ?? defaultGeneralCalendarColorValue,
    ).copyWith(sortOrder: data.schedules.length);
    return data.copyWith(
      activeScheduleId: schedule.id,
      schedules: [...data.schedules, schedule],
    );
  }

  GeneralScheduleData renameSchedule(
    GeneralScheduleData data,
    String scheduleId,
    String name,
  ) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) return data;
    final existing = data.schedules.firstWhere(
      (s) => s.id == scheduleId,
      orElse: () => data.activeSchedule,
    );
    return data.withSchedule(existing.copyWith(name: normalizedName));
  }

  GeneralScheduleData updateSchedule(
    GeneralScheduleData data,
    GeneralSchedule schedule,
  ) {
    if (!data.schedules.any((s) => s.id == schedule.id)) return data;
    return data.withSchedule(schedule);
  }

  GeneralScheduleData updateScheduleVisibility(
    GeneralScheduleData data,
    String scheduleId,
    bool isVisible,
  ) {
    final existing = data.schedules.firstWhere(
      (s) => s.id == scheduleId,
      orElse: () => data.activeSchedule,
    );
    return data.withSchedule(existing.copyWith(isVisible: isVisible));
  }

  GeneralScheduleData deleteSchedule(
    GeneralScheduleData data,
    String scheduleId,
  ) {
    var remaining = data.schedules.where((s) => s.id != scheduleId).toList();
    if (remaining.isEmpty) {
      remaining = [createDefaultGeneralSchedule()];
    }
    final nextActiveId = remaining.any((s) => s.id == data.activeScheduleId)
        ? data.activeScheduleId
        : remaining.first.id;
    return data.copyWith(
      activeScheduleId: nextActiveId,
      schedules: remaining,
      reminderAcknowledgements: data.reminderAcknowledgements
          .where(
            (item) =>
                !_reminderKeyContainsSchedule(item.occurrenceKey, scheduleId),
          )
          .toList(),
    );
  }

  GeneralScheduleData setSelectedDate(GeneralScheduleData data, DateTime date) {
    return data.copyWith(
      selectedDateIso: date.toIso8601String().split('T').first,
    );
  }

  GeneralScheduleData updateDisplaySettings(
    GeneralScheduleData data, {
    String? defaultView,
    bool? showWeekends,
    int? dayStartHour,
    int? dayEndHour,
    int? timeGridMinutes,
    bool? closeEventPopupOnOutsideTap,
  }) {
    return data.copyWith(
      defaultView: defaultView,
      showWeekends: showWeekends,
      dayStartHour: dayStartHour,
      dayEndHour: dayEndHour,
      timeGridMinutes: timeGridMinutes,
      closeEventPopupOnOutsideTap: closeEventPopupOnOutsideTap,
    );
  }

  GeneralScheduleData saveEvent(GeneralScheduleData data, GeneralEvent event) {
    var targetScheduleId = event.calendarId.trim().isEmpty
        ? data.activeSchedule.id
        : event.calendarId.trim();
    if (!data.schedules.any((s) => s.id == targetScheduleId)) {
      targetScheduleId = data.activeSchedule.id;
    }
    final normalized = event.normalized(fallbackCalendarId: targetScheduleId);
    final updatedSchedules = <GeneralSchedule>[];
    var inserted = false;
    for (final schedule in data.schedules) {
      var events = schedule.events.where((e) => e.id != event.id).toList();
      if (schedule.id == targetScheduleId) {
        events = [...events, normalized]
          ..sort((a, b) => a.startDateTimeIso.compareTo(b.startDateTimeIso));
        inserted = true;
      }
      updatedSchedules.add(schedule.copyWith(events: events));
    }
    if (!inserted) return data;
    return data.copyWith(schedules: updatedSchedules);
  }

  GeneralScheduleData deleteEvent(GeneralScheduleData data, String eventId) {
    return data.copyWith(
      schedules: [
        for (final schedule in data.schedules)
          schedule.copyWith(
            events: schedule.events.where((e) => e.id != eventId).toList(),
          ),
      ],
      reminderAcknowledgements: data.reminderAcknowledgements
          .where(
            (item) => !_reminderKeyContainsEvent(item.occurrenceKey, eventId),
          )
          .toList(),
    );
  }

  GeneralEventMutationResult duplicateOccurrence(
    GeneralScheduleData data,
    GeneralEventOccurrence occurrence, {
    DateTime? now,
  }) {
    final timestamp = (now ?? DateTime.now()).toIso8601String();
    final duplicated = occurrence.event.copyWith(
      id: _nextEventId(data),
      calendarId: occurrence.calendar.id,
      title: occurrence.event.title,
      startDateTimeIso: occurrence.start.toIso8601String(),
      endDateTimeIso: occurrence.end.toIso8601String(),
      recurrenceRule: const GeneralEventRecurrenceRule(),
      recurrenceExceptionDateIso: const [],
      createdAtIso: timestamp,
      updatedAtIso: timestamp,
    );
    return GeneralEventMutationResult(
      data: saveEvent(data, duplicated),
      event: duplicated,
    );
  }

  GeneralScheduleData deleteOccurrence(
    GeneralScheduleData data,
    GeneralEventOccurrence occurrence,
  ) {
    final event = occurrence.event;
    if (!event.recurrenceRule.isRepeating) {
      return deleteEvent(data, event.id);
    }
    final exceptions = {...event.recurrenceExceptionDateIso}
      ..add(occurrence.exceptionDateIso);
    final withException = saveEvent(
      data,
      event.copyWith(recurrenceExceptionDateIso: exceptions.toList()..sort()),
    );
    return withException.copyWith(
      reminderAcknowledgements: withException.reminderAcknowledgements
          .where((item) => item.occurrenceKey != occurrence.occurrenceKey)
          .toList(),
    );
  }

  GeneralScheduleData deleteFutureOccurrences(
    GeneralScheduleData data,
    GeneralEventOccurrence occurrence,
  ) {
    final event = occurrence.event;
    if (!event.recurrenceRule.isRepeating || occurrence.sequence <= 0) {
      return deleteEvent(data, event.id);
    }
    final until = occurrence.start
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    final updated = saveEvent(
      data,
      event.copyWith(
        recurrenceRule: event.recurrenceRule.copyWith(untilDateIso: until),
      ),
    );
    return updated.copyWith(
      reminderAcknowledgements: updated.reminderAcknowledgements
          .where(
            (item) => !_reminderKeyMatchesEventAtOrAfter(
              item.occurrenceKey,
              event.id,
              occurrence.start,
            ),
          )
          .toList(),
    );
  }

  GeneralScheduleData dismissReminder(
    GeneralScheduleData data,
    GeneralEventOccurrence occurrence, {
    DateTime? now,
  }) {
    final key = occurrence.occurrenceKey;
    final acknowledgement = GeneralReminderAcknowledgement(
      occurrenceKey: key,
      updatedAtIso: (now ?? DateTime.now()).toIso8601String(),
    );
    return data.copyWith(
      reminderAcknowledgements: [
        ...data.reminderAcknowledgements.where(
          (item) => item.occurrenceKey != key,
        ),
        acknowledgement,
      ],
    );
  }

  GeneralScheduleData restoreReminder(
    GeneralScheduleData data,
    GeneralEventOccurrence occurrence,
  ) {
    return data.copyWith(
      reminderAcknowledgements: data.reminderAcknowledgements
          .where((item) => item.occurrenceKey != occurrence.occurrenceKey)
          .toList(),
    );
  }
}

String _nextEventId(GeneralScheduleData data) {
  final existingIds = data.schedules
      .expand((schedule) => schedule.events)
      .map((event) => event.id)
      .toSet();
  var stamp = DateTime.now().microsecondsSinceEpoch;
  var candidate = 'evt_$stamp';
  while (existingIds.contains(candidate)) {
    stamp += 1;
    candidate = 'evt_$stamp';
  }
  return candidate;
}

bool _reminderKeyContainsSchedule(String occurrenceKey, String scheduleId) {
  final parts = occurrenceKey.split('|');
  return parts.isNotEmpty && parts.first == scheduleId;
}

bool _reminderKeyContainsEvent(String occurrenceKey, String eventId) {
  final parts = occurrenceKey.split('|');
  return parts.length >= 2 && parts[1] == eventId;
}

bool _reminderKeyMatchesEventAtOrAfter(
  String occurrenceKey,
  String eventId,
  DateTime startInclusive,
) {
  final parts = occurrenceKey.split('|');
  if (parts.length < 3 || parts[1] != eventId) {
    return false;
  }
  final start = DateTime.tryParse(parts[2]);
  return start != null && !start.isBefore(startInclusive);
}
