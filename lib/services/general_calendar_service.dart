import '../models/general_event.dart';
import '../models/general_event_occurrence.dart';
import '../models/general_schedule.dart';
import '../models/general_schedule_data.dart';
import '../utils/time_utils.dart';

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
    final existing = _scheduleById(data, scheduleId);
    if (existing == null) return data;
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
    final existing = _scheduleById(data, scheduleId);
    if (existing == null) return data;
    return data.withSchedule(existing.copyWith(isVisible: isVisible));
  }

  GeneralScheduleData deleteSchedule(
    GeneralScheduleData data,
    String scheduleId,
  ) {
    final deletedSchedule = _scheduleById(data, scheduleId);
    if (deletedSchedule == null) {
      return data;
    }
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
            (item) => !_reminderKeyBelongsToSchedule(
              item.occurrenceKey,
              deletedSchedule,
            ),
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

  GeneralScheduleData saveEvent(
    GeneralScheduleData data,
    GeneralEvent event, {
    bool preserveEventReminderAcknowledgements = false,
  }) {
    final base = data.schedules.isEmpty ? data.normalized() : data;
    final existing = _eventLocationById(base, event.id);
    var targetScheduleId = event.calendarId.trim().isEmpty
        ? base.activeSchedule.id
        : event.calendarId.trim();
    if (!base.schedules.any((s) => s.id == targetScheduleId)) {
      targetScheduleId = base.activeSchedule.id;
    }
    final normalized = event
        .copyWith(calendarId: targetScheduleId)
        .normalized(fallbackCalendarId: targetScheduleId);
    final updatedSchedules = <GeneralSchedule>[];
    var inserted = false;
    for (final schedule in base.schedules) {
      var events = schedule.events.where((e) => e.id != event.id).toList();
      if (schedule.id == targetScheduleId) {
        events = [...events, normalized]
          ..sort((a, b) => a.startDateTimeIso.compareTo(b.startDateTimeIso));
        inserted = true;
      }
      updatedSchedules.add(schedule.copyWith(events: events));
    }
    if (!inserted) return data;
    final reminderAcknowledgements =
        !preserveEventReminderAcknowledgements &&
            existing != null &&
            _eventOccurrenceIdentityChanged(
              existing.schedule,
              existing.event,
              targetScheduleId,
              normalized,
            )
        ? base.reminderAcknowledgements
              .where(
                (item) => !_reminderKeyMatchesEventInSchedule(
                  item.occurrenceKey,
                  existing.schedule.id,
                  existing.event.id,
                ),
              )
              .toList()
        : base.reminderAcknowledgements;
    return base.copyWith(
      schedules: updatedSchedules,
      reminderAcknowledgements: reminderAcknowledgements,
    );
  }

  GeneralScheduleData deleteEvent(GeneralScheduleData data, String eventId) {
    final deletedLocations = <({GeneralSchedule schedule, GeneralEvent event})>[
      for (final schedule in data.schedules)
        for (final event in schedule.events)
          if (event.id == eventId) (schedule: schedule, event: event),
    ];
    if (deletedLocations.isEmpty) {
      return data;
    }
    return data.copyWith(
      schedules: [
        for (final schedule in data.schedules)
          schedule.copyWith(
            events: schedule.events.where((e) => e.id != eventId).toList(),
          ),
      ],
      reminderAcknowledgements: data.reminderAcknowledgements
          .where(
            (item) => !deletedLocations.any(
              (location) => _reminderKeyMatchesEventInSchedule(
                item.occurrenceKey,
                location.schedule.id,
                location.event.id,
              ),
            ),
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
          .where(
            (item) =>
                !_reminderKeyMatchesOccurrence(item.occurrenceKey, occurrence),
          )
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
      preserveEventReminderAcknowledgements: true,
    );
    return updated.copyWith(
      reminderAcknowledgements: updated.reminderAcknowledgements
          .where(
            (item) => !_reminderKeyMatchesEventAtOrAfter(
              item.occurrenceKey,
              occurrence.calendar.id,
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
          (item) =>
              !_reminderKeyMatchesOccurrence(item.occurrenceKey, occurrence),
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
          .where(
            (item) =>
                !_reminderKeyMatchesOccurrence(item.occurrenceKey, occurrence),
          )
          .toList(),
    );
  }
}

GeneralSchedule? _scheduleById(GeneralScheduleData data, String scheduleId) {
  for (final schedule in data.schedules) {
    if (schedule.id == scheduleId) {
      return schedule;
    }
  }
  return null;
}

({GeneralSchedule schedule, GeneralEvent event})? _eventLocationById(
  GeneralScheduleData data,
  String eventId,
) {
  if (eventId.trim().isEmpty) {
    return null;
  }
  for (final schedule in data.schedules) {
    for (final event in schedule.events) {
      if (event.id == eventId) {
        return (schedule: schedule, event: event);
      }
    }
  }
  return null;
}

bool _eventOccurrenceIdentityChanged(
  GeneralSchedule oldSchedule,
  GeneralEvent oldEvent,
  String newScheduleId,
  GeneralEvent newEvent,
) {
  return oldSchedule.id != newScheduleId ||
      oldEvent.startDateTimeIso != newEvent.startDateTimeIso ||
      !_recurrenceRulesEqual(
        oldEvent.recurrenceRule,
        newEvent.recurrenceRule,
      ) ||
      !_remindersEqual(oldEvent.reminders, newEvent.reminders);
}

bool _recurrenceRulesEqual(
  GeneralEventRecurrenceRule a,
  GeneralEventRecurrenceRule b,
) {
  return a.type == b.type &&
      a.normalizedInterval == b.normalizedInterval &&
      a.unit == b.unit &&
      a.untilDateIso == b.untilDateIso &&
      a.count == b.count;
}

bool _remindersEqual(
  List<GeneralEventReminder> a,
  List<GeneralEventReminder> b,
) {
  final aMinutes = a.map((item) => item.minutesBefore).toList()..sort();
  final bMinutes = b.map((item) => item.minutesBefore).toList()..sort();
  if (aMinutes.length != bMinutes.length) {
    return false;
  }
  for (var i = 0; i < aMinutes.length; i++) {
    if (aMinutes[i] != bMinutes[i]) {
      return false;
    }
  }
  return true;
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

bool _reminderKeyBelongsToSchedule(
  String occurrenceKey,
  GeneralSchedule schedule,
) {
  final parsed = parseGeneralOccurrenceKey(occurrenceKey);
  if (parsed != null) {
    return parsed.calendarId == schedule.id;
  }
  for (final event in schedule.events) {
    if (_reminderKeyMatchesEventInSchedule(
      occurrenceKey,
      schedule.id,
      event.id,
    )) {
      return true;
    }
  }
  final parts = occurrenceKey.split('|');
  return parts.length == 3 && parts.first == schedule.id;
}

bool _reminderKeyMatchesEventInSchedule(
  String occurrenceKey,
  String scheduleId,
  String eventId,
) {
  final parsed = parseGeneralOccurrenceKey(occurrenceKey);
  if (parsed != null) {
    return parsed.calendarId == scheduleId && parsed.eventId == eventId;
  }
  return _legacyReminderKeyStart(
        occurrenceKey,
        scheduleId: scheduleId,
        eventId: eventId,
      ) !=
      null;
}

bool _reminderKeyMatchesEventAtOrAfter(
  String occurrenceKey,
  String scheduleId,
  String eventId,
  DateTime startInclusive,
) {
  final parsed = parseGeneralOccurrenceKey(occurrenceKey);
  if (parsed != null) {
    if (parsed.calendarId != scheduleId || parsed.eventId != eventId) {
      return false;
    }
    final start = tryParseStrictIsoDateTime(parsed.startDateTimeIso);
    return start != null && !start.isBefore(startInclusive);
  }
  final start = _legacyReminderKeyStart(
    occurrenceKey,
    scheduleId: scheduleId,
    eventId: eventId,
  );
  return start != null && !start.isBefore(startInclusive);
}

bool _reminderKeyMatchesOccurrence(
  String occurrenceKey,
  GeneralEventOccurrence occurrence,
) {
  return generalOccurrenceKeyMatches(
    occurrenceKey,
    calendarId: occurrence.calendar.id,
    eventId: occurrence.event.id,
    startDateTimeIso: occurrence.start.toIso8601String(),
  );
}

DateTime? _legacyReminderKeyStart(
  String occurrenceKey, {
  required String scheduleId,
  required String eventId,
}) {
  final prefix = '$scheduleId|$eventId|';
  if (!occurrenceKey.startsWith(prefix)) {
    return null;
  }
  return tryParseStrictIsoDateTime(occurrenceKey.substring(prefix.length));
}
