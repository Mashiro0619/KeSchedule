import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/general_event.dart';
import 'package:sked/models/general_event_occurrence.dart';
import 'package:sked/models/general_schedule.dart';
import 'package:sked/models/general_schedule_data.dart';
import 'package:sked/services/general_occurrence_service.dart';

void main() {
  const service = GeneralOccurrenceService();

  GeneralEvent buildEvent({
    required String id,
    required String title,
    required DateTime start,
    Duration duration = const Duration(hours: 1),
    List<GeneralEventReminder> reminders = const [],
    int? colorValue,
    String location = '',
  }) {
    return GeneralEvent(
      id: id,
      calendarId: 'cal',
      title: title,
      location: location,
      startDateTimeIso: start.toIso8601String(),
      endDateTimeIso: start.add(duration).toIso8601String(),
      reminders: reminders,
      colorValue: colorValue,
    );
  }

  GeneralScheduleData buildData({
    List<GeneralEvent> events = const [],
    bool calendarVisible = true,
    List<GeneralReminderAcknowledgement> acknowledgements = const [],
  }) {
    return GeneralScheduleData(
      activeScheduleId: 'cal',
      schedules: [
        GeneralSchedule(
          id: 'cal',
          name: 'Work',
          events: events,
          isVisible: calendarVisible,
        ),
      ],
      reminderAcknowledgements: acknowledgements,
    );
  }

  group('GeneralOccurrenceService.occurrencesForQuery', () {
    test('filters by query.colorValue', () {
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'Red',
            start: DateTime(2026, 5, 24, 10),
            colorValue: 0xFFFF0000,
          ),
          buildEvent(
            id: 'b',
            title: 'Blue',
            start: DateTime(2026, 5, 24, 11),
            colorValue: 0xFF0000FF,
          ),
        ],
      );

      final query = GeneralOccurrenceQuery(
        startInclusive: DateTime(2026, 5, 24),
        endExclusive: DateTime(2026, 5, 25),
        colorValue: 0xFFFF0000,
      );

      final results = service.occurrencesForQuery(data, query);

      expect(results, hasLength(1));
      expect(results.single.event.id, equals('a'));
    });

    test('filters by query.searchQuery against title/location/calendar', () {
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'Standup',
            start: DateTime(2026, 5, 24, 10),
            location: 'Room A',
          ),
          buildEvent(
            id: 'b',
            title: 'Lunch',
            start: DateTime(2026, 5, 24, 12),
            location: 'Cafeteria',
          ),
        ],
      );
      final query = GeneralOccurrenceQuery(
        startInclusive: DateTime(2026, 5, 24),
        endExclusive: DateTime(2026, 5, 25),
        searchQuery: 'cafe',
      );

      final results = service.occurrencesForQuery(data, query);

      expect(results.map((o) => o.event.id), equals(['b']));
    });

    test('honors onlyVisibleCalendars=false', () {
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'Hidden',
            start: DateTime(2026, 5, 24, 10),
          ),
        ],
        calendarVisible: false,
      );
      final visibleQuery = GeneralOccurrenceQuery(
        startInclusive: DateTime(2026, 5, 24),
        endExclusive: DateTime(2026, 5, 25),
      );
      final allQuery = GeneralOccurrenceQuery(
        startInclusive: DateTime(2026, 5, 24),
        endExclusive: DateTime(2026, 5, 25),
        onlyVisibleCalendars: false,
      );

      expect(service.occurrencesForQuery(data, visibleQuery), isEmpty);
      expect(service.occurrencesForQuery(data, allQuery), hasLength(1));
    });
  });

  group('GeneralOccurrenceService.isReminderHandled', () {
    test('matches versioned acknowledgement keys with encoded ids', () {
      final start = DateTime(2026, 5, 24, 10);
      final event = buildEvent(
        id: 'a|1',
        title: 'x',
        start: start,
      ).copyWith(calendarId: 'cal|main');
      final calendar = GeneralSchedule(
        id: 'cal|main',
        name: 'Work',
        events: [event],
      );
      final occurrenceKey = buildGeneralOccurrenceKey(
        'cal|main',
        'a|1',
        start.toIso8601String(),
      );
      final data = GeneralScheduleData(
        activeScheduleId: 'cal|main',
        schedules: [calendar],
        reminderAcknowledgements: [
          GeneralReminderAcknowledgement(
            occurrenceKey: occurrenceKey,
            updatedAtIso: DateTime.now().toIso8601String(),
          ),
        ],
      );
      final occurrence = service
          .occurrencesForQuery(
            data,
            GeneralOccurrenceQuery(
              startInclusive: DateTime(2026, 5, 24),
              endExclusive: DateTime(2026, 5, 25),
            ),
          )
          .single;
      final parsed = parseGeneralOccurrenceKey(occurrenceKey)!;

      expect(occurrenceKey, 'v2|cal%7Cmain|a%7C1|2026-05-24T10%3A00%3A00.000');
      expect(parsed.calendarId, 'cal|main');
      expect(parsed.eventId, 'a|1');
      expect(service.isReminderHandled(data, occurrence), isTrue);
    });

    test('still matches legacy acknowledgement keys', () {
      final start = DateTime(2026, 5, 24, 10);
      final event = buildEvent(
        id: 'a|1',
        title: 'x',
        start: start,
      ).copyWith(calendarId: 'cal|main');
      final calendar = GeneralSchedule(
        id: 'cal|main',
        name: 'Work',
        events: [event],
      );
      final data = GeneralScheduleData(
        activeScheduleId: 'cal|main',
        schedules: [calendar],
        reminderAcknowledgements: [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'cal|main|a|1|${start.toIso8601String()}',
            updatedAtIso: DateTime.now().toIso8601String(),
          ),
        ],
      );
      final occurrence = service
          .occurrencesForQuery(
            data,
            GeneralOccurrenceQuery(
              startInclusive: DateTime(2026, 5, 24),
              endExclusive: DateTime(2026, 5, 25),
            ),
          )
          .single;

      expect(service.isReminderHandled(data, occurrence), isTrue);
    });

    test('returns true when acknowledgement is marked handled for the key', () {
      final start = DateTime(2026, 5, 24, 10);
      final event = buildEvent(id: 'a', title: 'x', start: start);
      final data = buildData(
        events: [event],
        acknowledgements: [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'cal|a|${start.toIso8601String()}',
            updatedAtIso: DateTime.now().toIso8601String(),
          ),
        ],
      );

      final occurrences = service.occurrencesForQuery(
        data,
        GeneralOccurrenceQuery(
          startInclusive: DateTime(2026, 5, 24),
          endExclusive: DateTime(2026, 5, 25),
        ),
      );

      expect(occurrences, hasLength(1));
      expect(service.isReminderHandled(data, occurrences.single), isTrue);
    });

    test('returns false when no acknowledgement for the key', () {
      final start = DateTime(2026, 5, 24, 10);
      final event = buildEvent(id: 'a', title: 'x', start: start);
      final data = buildData(events: [event]);

      final occurrence = service
          .occurrencesForQuery(
            data,
            GeneralOccurrenceQuery(
              startInclusive: DateTime(2026, 5, 24),
              endExclusive: DateTime(2026, 5, 25),
            ),
          )
          .single;

      expect(service.isReminderHandled(data, occurrence), isFalse);
    });
  });

  group('GeneralOccurrenceService.isInReminderWindow', () {
    test('returns true when now is within reminder offset before start', () {
      final start = DateTime(2026, 5, 24, 10);
      final event = buildEvent(
        id: 'a',
        title: 'x',
        start: start,
        reminders: const [GeneralEventReminder(minutesBefore: 10)],
      );
      final occurrence = GeneralEventOccurrence(
        event: event,
        calendar: GeneralSchedule(id: 'cal', name: 'c', events: const []),
        start: start,
        end: start.add(const Duration(hours: 1)),
        sequence: 0,
      );

      // 5 min before start: inside the 10-min window.
      final now = start.subtract(const Duration(minutes: 5));
      expect(service.isInReminderWindow(occurrence, now), isTrue);

      // 15 min before start: outside the 10-min window.
      final earlier = start.subtract(const Duration(minutes: 15));
      expect(service.isInReminderWindow(occurrence, earlier), isFalse);

      // After start: never in reminder window (we'd be overdue, not upcoming).
      final after = start.add(const Duration(minutes: 1));
      expect(service.isInReminderWindow(occurrence, after), isFalse);
    });

    test('returns false when event has no reminders', () {
      final start = DateTime(2026, 5, 24, 10);
      final event = buildEvent(id: 'a', title: 'x', start: start);
      final occurrence = GeneralEventOccurrence(
        event: event,
        calendar: GeneralSchedule(id: 'cal', name: 'c', events: const []),
        start: start,
        end: start.add(const Duration(hours: 1)),
        sequence: 0,
      );

      expect(
        service.isInReminderWindow(
          occurrence,
          start.subtract(const Duration(minutes: 5)),
        ),
        isFalse,
      );
    });
  });

  group('GeneralOccurrenceService.reminderItems', () {
    test('classifies as upcoming when within reminder window before start', () {
      final now = DateTime(2026, 5, 24, 9, 55);
      final start = DateTime(2026, 5, 24, 10);
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'soon',
            start: start,
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );

      final items = service.reminderItems(data, now: now);

      expect(items, hasLength(1));
      expect(items.single.status, equals(GeneralReminderStatus.upcoming));
    });

    test('classifies as overdue when event ended before now', () {
      final now = DateTime(2026, 5, 24, 12);
      final start = DateTime(2026, 5, 24, 10);
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'past',
            start: start,
            // 1h duration -> ended at 11:00, now is 12:00.
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );

      final items = service.reminderItems(data, now: now);

      expect(items, hasLength(1));
      expect(items.single.status, equals(GeneralReminderStatus.overdue));
    });

    test('classifies as in progress when event has started but not ended', () {
      final now = DateTime(2026, 5, 24, 10, 30);
      final start = DateTime(2026, 5, 24, 10);
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'current',
            start: start,
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );

      final items = service.reminderItems(data, now: now);

      expect(items, hasLength(1));
      expect(items.single.status, equals(GeneralReminderStatus.inProgress));
    });

    test('classifies as in progress when event starts exactly now', () {
      final now = DateTime(2026, 5, 24, 10);
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'current',
            start: now,
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );

      final items = service.reminderItems(data, now: now);

      expect(items, hasLength(1));
      expect(items.single.status, equals(GeneralReminderStatus.inProgress));
    });

    test('does not classify as in progress when event ends exactly now', () {
      final now = DateTime(2026, 5, 24, 11);
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'finished',
            start: DateTime(2026, 5, 24, 10),
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );

      expect(service.reminderItems(data, now: now), isEmpty);
    });

    test('excludes occurrences already marked handled', () {
      final now = DateTime(2026, 5, 24, 9, 55);
      final start = DateTime(2026, 5, 24, 10);
      final data = buildData(
        events: [
          buildEvent(
            id: 'a',
            title: 'x',
            start: start,
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
        acknowledgements: [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'cal|a|${start.toIso8601String()}',
            updatedAtIso: now.toIso8601String(),
          ),
        ],
      );

      expect(service.reminderItems(data, now: now), isEmpty);
    });
  });
}
