import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/general_event.dart';
import 'package:sked/models/general_event_occurrence.dart';
import 'package:sked/models/general_schedule.dart';
import 'package:sked/models/general_schedule_data.dart';
import 'package:sked/services/general_calendar_service.dart';

void main() {
  const service = GeneralCalendarService();

  GeneralScheduleData buildData({
    List<GeneralSchedule>? schedules,
    String activeScheduleId = 'cal',
    List<GeneralReminderAcknowledgement> acknowledgements = const [],
  }) {
    final resolvedSchedules =
        schedules ??
        [const GeneralSchedule(id: 'cal', name: 'Work', events: [])];
    return GeneralScheduleData(
      activeScheduleId: activeScheduleId,
      schedules: resolvedSchedules,
      reminderAcknowledgements: acknowledgements,
    );
  }

  GeneralEvent buildEvent({
    String id = 'event',
    String calendarId = 'cal',
    String title = 'Event',
    DateTime? start,
    Duration duration = const Duration(hours: 1),
    GeneralEventRecurrenceRule recurrenceRule =
        const GeneralEventRecurrenceRule(),
    List<String> exceptions = const [],
    List<GeneralEventReminder> reminders = const [],
  }) {
    final resolvedStart = start ?? DateTime(2026, 5, 25, 9);
    return GeneralEvent(
      id: id,
      calendarId: calendarId,
      title: title,
      startDateTimeIso: resolvedStart.toIso8601String(),
      endDateTimeIso: resolvedStart.add(duration).toIso8601String(),
      recurrenceRule: recurrenceRule,
      recurrenceExceptionDateIso: exceptions,
      location: 'Room A',
      notes: 'Bring notes',
      colorValue: 0xFF123456,
      reminders: reminders,
    );
  }

  GeneralEventOccurrence buildOccurrence({
    required GeneralEvent event,
    required GeneralSchedule calendar,
    required DateTime start,
    int sequence = 0,
  }) {
    return GeneralEventOccurrence(
      event: event,
      calendar: calendar,
      start: start,
      end: start.add(const Duration(hours: 1)),
      sequence: sequence,
    );
  }

  group('GeneralCalendarService schedules', () {
    test('switches active schedule only when id exists', () {
      final data = buildData(
        schedules: const [
          GeneralSchedule(id: 'cal', name: 'Work', events: []),
          GeneralSchedule(id: 'home', name: 'Home', events: []),
        ],
      );

      final switched = service.switchSchedule(data, 'home');
      final missing = service.switchSchedule(data, 'missing');

      expect(switched.activeScheduleId, 'home');
      expect(identical(missing, data), isTrue);
    });

    test('deletes the last schedule by creating a default replacement', () {
      final data = buildData(
        acknowledgements: const [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'cal|event|2026-05-25T09:00:00.000',
            updatedAtIso: '2026-05-25T08:55:00.000',
          ),
        ],
      );

      final updated = service.deleteSchedule(data, 'cal');

      expect(updated.schedules, hasLength(1));
      expect(updated.activeScheduleId, updated.schedules.single.id);
      expect(updated.schedules.single.events, isEmpty);
      expect(updated.reminderAcknowledgements, isEmpty);
    });
  });

  group('GeneralCalendarService events', () {
    test(
      'saves an event into the active schedule when calendar id is missing',
      () {
        final data = buildData();
        final event = buildEvent(calendarId: '');

        final updated = service.saveEvent(data, event);

        expect(updated.activeSchedule.events, hasLength(1));
        expect(updated.activeSchedule.events.single.calendarId, 'cal');
        expect(updated.activeSchedule.events.single.title, 'Event');
      },
    );

    test('deletes an event and removes its handled reminder records', () {
      final event = buildEvent();
      final data = buildData(
        schedules: [
          GeneralSchedule(id: 'cal', name: 'Work', events: [event]),
        ],
        acknowledgements: const [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'cal|event|2026-05-25T09:00:00.000',
            updatedAtIso: '2026-05-25T08:55:00.000',
          ),
        ],
      );

      final updated = service.deleteEvent(data, 'event');

      expect(updated.activeSchedule.events, isEmpty);
      expect(updated.reminderAcknowledgements, isEmpty);
    });

    test('duplicates an occurrence as a one-time event', () {
      final event = buildEvent(
        id: 'repeat',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.weekly,
          unit: GeneralEventRecurrenceUnit.week,
          count: 4,
        ),
        exceptions: const ['2026-06-01'],
        reminders: const [GeneralEventReminder(minutesBefore: 10)],
      );
      final calendar = GeneralSchedule(
        id: 'cal',
        name: 'Work',
        events: [event],
      );
      final data = buildData(schedules: [calendar]);
      final occurrence = buildOccurrence(
        event: event,
        calendar: calendar,
        start: DateTime(2026, 5, 25, 9),
        sequence: 1,
      );

      final result = service.duplicateOccurrence(
        data,
        occurrence,
        now: DateTime(2026, 5, 24, 12),
      );

      expect(result.event.id, isNot('repeat'));
      expect(result.event.startDateTimeIso, startsWith('2026-05-25T09:00:00'));
      expect(result.event.recurrenceRule.isRepeating, isFalse);
      expect(result.event.recurrenceExceptionDateIso, isEmpty);
      expect(result.event.location, 'Room A');
      expect(result.event.notes, 'Bring notes');
      expect(result.event.colorValue, 0xFF123456);
      expect(result.event.reminders.single.minutesBefore, 10);
      expect(
        result.data.activeSchedule.events.map((item) => item.id),
        contains(result.event.id),
      );
    });

    test(
      'deleting one recurring occurrence adds an exception and clears key',
      () {
        final event = buildEvent(
          id: 'repeat',
          recurrenceRule: const GeneralEventRecurrenceRule(
            type: GeneralEventRecurrence.weekly,
            unit: GeneralEventRecurrenceUnit.week,
            count: 4,
          ),
        );
        final calendar = GeneralSchedule(
          id: 'cal',
          name: 'Work',
          events: [event],
        );
        final occurrence = buildOccurrence(
          event: event,
          calendar: calendar,
          start: DateTime(2026, 5, 25, 9),
          sequence: 1,
        );
        final data = buildData(
          schedules: [calendar],
          acknowledgements: [
            GeneralReminderAcknowledgement(
              occurrenceKey: occurrence.occurrenceKey,
              updatedAtIso: '2026-05-25T08:55:00.000',
            ),
          ],
        );

        final updated = service.deleteOccurrence(data, occurrence);
        final updatedEvent = updated.activeSchedule.events.single;

        expect(updatedEvent.recurrenceExceptionDateIso, ['2026-05-25']);
        expect(updated.reminderAcknowledgements, isEmpty);
      },
    );

    test(
      'deleting future recurring occurrences trims rule and future keys',
      () {
        final event = buildEvent(
          id: 'repeat',
          recurrenceRule: const GeneralEventRecurrenceRule(
            type: GeneralEventRecurrence.weekly,
            unit: GeneralEventRecurrenceUnit.week,
            count: 4,
          ),
        );
        final calendar = GeneralSchedule(
          id: 'cal',
          name: 'Work',
          events: [event],
        );
        final occurrence = buildOccurrence(
          event: event,
          calendar: calendar,
          start: DateTime(2026, 5, 25, 9),
          sequence: 1,
        );
        final data = buildData(
          schedules: [calendar],
          acknowledgements: const [
            GeneralReminderAcknowledgement(
              occurrenceKey: 'cal|repeat|2026-05-18T09:00:00.000',
              updatedAtIso: '2026-05-18T08:55:00.000',
            ),
            GeneralReminderAcknowledgement(
              occurrenceKey: 'cal|repeat|2026-05-25T09:00:00.000',
              updatedAtIso: '2026-05-25T08:55:00.000',
            ),
            GeneralReminderAcknowledgement(
              occurrenceKey: 'cal|repeat|2026-06-01T09:00:00.000',
              updatedAtIso: '2026-06-01T08:55:00.000',
            ),
          ],
        );

        final updated = service.deleteFutureOccurrences(data, occurrence);

        expect(
          updated.activeSchedule.events.single.recurrenceRule.untilDateIso,
          '2026-05-24',
        );
        expect(
          updated.reminderAcknowledgements.map((item) => item.occurrenceKey),
          ['cal|repeat|2026-05-18T09:00:00.000'],
        );
      },
    );
  });

  group('GeneralCalendarService reminders', () {
    test('dismisses and restores one occurrence reminder', () {
      final event = buildEvent();
      final calendar = GeneralSchedule(
        id: 'cal',
        name: 'Work',
        events: [event],
      );
      final occurrence = buildOccurrence(
        event: event,
        calendar: calendar,
        start: DateTime(2026, 5, 25, 9),
      );
      final data = buildData(schedules: [calendar]);

      final dismissed = service.dismissReminder(
        data,
        occurrence,
        now: DateTime(2026, 5, 25, 8, 55),
      );
      final restored = service.restoreReminder(dismissed, occurrence);

      expect(dismissed.reminderAcknowledgements, hasLength(1));
      expect(
        dismissed.reminderAcknowledgements.single.occurrenceKey,
        occurrence.occurrenceKey,
      );
      expect(restored.reminderAcknowledgements, isEmpty);
    });
  });
}
