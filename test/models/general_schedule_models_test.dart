import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/timetable_models.dart';

void main() {
  group('AppMode', () {
    test('general value is "general"', () {
      expect(AppMode.general.value, 'general');
    });

    test('student value is "student"', () {
      expect(AppMode.student.value, 'student');
    });

    test('parseAppMode parses valid values', () {
      expect(parseAppMode('general'), AppMode.general);
      expect(parseAppMode('student'), AppMode.student);
    });

    test('parseAppMode defaults to general for null', () {
      expect(parseAppMode(null), AppMode.general);
    });

    test('parseAppMode defaults to general for unknown value', () {
      expect(parseAppMode('unknown'), AppMode.general);
    });
  });

  group('GeneralEvent', () {
    test('one-time event JSON round-trip', () {
      final event = GeneralEvent(
        id: 'evt1',
        title: 'Meeting',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
        location: 'Room A',
        notes: 'Bring laptop',
        colorValue: 0xFF123456,
        createdAtIso: '2026-05-20T12:00:00.000',
        updatedAtIso: '2026-05-20T12:00:00.000',
      );

      final json = event.toJson();
      final decoded = GeneralEvent.fromJson(json);

      expect(decoded.id, 'evt1');
      expect(decoded.title, 'Meeting');
      expect(decoded.startDateTimeIso, '2026-05-22T09:00:00.000');
      expect(decoded.endDateTimeIso, '2026-05-22T10:00:00.000');
      expect(decoded.recurrence, GeneralEventRecurrence.none);
      expect(decoded.recurrenceEndDateIso, isNull);
      expect(decoded.location, 'Room A');
      expect(decoded.notes, 'Bring laptop');
      expect(decoded.colorValue, 0xFF123456);
      expect(decoded.createdAtIso, '2026-05-20T12:00:00.000');
      expect(decoded.updatedAtIso, '2026-05-20T12:00:00.000');
    });

    test('weekly event JSON round-trip', () {
      final event = GeneralEvent(
        id: 'evt2',
        title: 'Weekly Standup',
        startDateTimeIso: '2026-05-18T09:00:00.000',
        endDateTimeIso: '2026-05-18T09:30:00.000',
        recurrence: GeneralEventRecurrence.weekly,
        recurrenceEndDateIso: '2026-07-31T00:00:00.000',
        location: 'Office',
        notes: '',
      );

      final json = event.toJson();
      final decoded = GeneralEvent.fromJson(json);

      expect(decoded.recurrence, GeneralEventRecurrence.weekly);
      expect(decoded.recurrenceEndDateIso, '2026-07-31T00:00:00.000');
      expect(decoded.title, 'Weekly Standup');
    });

    test('monthly recurrence is supported', () {
      final json = {
        'id': 'evt3',
        'title': 'Test',
        'start': '2026-05-22T09:00:00.000',
        'end': '2026-05-22T10:00:00.000',
        'recurrence': 'monthly',
      };
      final decoded = GeneralEvent.fromJson(json);

      expect(decoded.recurrence, GeneralEventRecurrence.monthly);
    });

    test('missing optional fields get defaults', () {
      final json = {
        'id': 'evt4',
        'title': '',
        'start': '2026-05-22T09:00:00.000',
        'end': '2026-05-22T10:00:00.000',
      };
      final decoded = GeneralEvent.fromJson(json);

      expect(decoded.title, '');
      expect(decoded.recurrence, GeneralEventRecurrence.none);
      expect(decoded.recurrenceEndDateIso, isNull);
      expect(decoded.location, '');
      expect(decoded.notes, '');
      expect(decoded.colorValue, isNull);
      expect(decoded.createdAtIso, isNull);
      expect(decoded.updatedAtIso, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final original = GeneralEvent(
        id: 'evt5',
        title: 'Original',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
        location: 'Old',
        notes: 'Old notes',
      );

      final updated = original.copyWith(title: 'Updated');

      expect(updated.id, 'evt5');
      expect(updated.title, 'Updated');
      expect(updated.startDateTimeIso, '2026-05-22T09:00:00.000');
      expect(updated.location, 'Old');
    });

    test('copyWith can set recurrence', () {
      final original = GeneralEvent(
        id: 'evt6',
        title: 'Original',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
      );

      final updated = original.copyWith(
        recurrence: GeneralEventRecurrence.weekly,
        recurrenceEndDateIso: '2026-07-31T00:00:00.000',
      );

      expect(updated.recurrence, GeneralEventRecurrence.weekly);
      expect(updated.recurrenceEndDateIso, '2026-07-31T00:00:00.000');
    });

    test('copyWith can explicitly clear nullable event fields', () {
      final original = GeneralEvent(
        id: 'nullable',
        title: 'Nullable',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.weekly,
          untilDateIso: '2026-06-30',
          count: 5,
        ),
        colorValue: 0xFF123456,
        createdAtIso: '2026-05-20T12:00:00.000',
        updatedAtIso: '2026-05-21T12:00:00.000',
      );

      final updated = original.copyWith(
        recurrenceEndDateIso: null,
        colorValue: null,
        createdAtIso: null,
        updatedAtIso: null,
      );

      expect(updated.recurrenceRule.type, GeneralEventRecurrence.weekly);
      expect(updated.recurrenceEndDateIso, isNull);
      expect(updated.recurrenceRule.count, 5);
      expect(updated.colorValue, isNull);
      expect(updated.createdAtIso, isNull);
      expect(updated.updatedAtIso, isNull);
    });

    test('recurrence rule copyWith can explicitly clear nullable fields', () {
      const original = GeneralEventRecurrenceRule(
        type: GeneralEventRecurrence.weekly,
        untilDateIso: '2026-06-30',
        count: 8,
      );

      final updated = original.copyWith(untilDateIso: null, count: null);

      expect(updated.type, GeneralEventRecurrence.weekly);
      expect(updated.untilDateIso, isNull);
      expect(updated.count, isNull);
    });

    test('toJson does not serialize null values unnecessarily', () {
      final event = GeneralEvent(
        id: 'evt7',
        title: 'Minimal',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
      );

      final json = event.toJson();

      expect(json['id'], 'evt7');
      expect(json.containsKey('recurrenceEndDate'), false);
    });

    test('fromJson filters malformed reminders', () {
      final event = GeneralEvent.fromJson({
        'id': 'evt_reminders',
        'title': 'Reminder',
        'start': '2026-05-22T09:00:00.000',
        'end': '2026-05-22T10:00:00.000',
        'reminders': [
          {'minutesBefore': 10},
          'bad',
          null,
        ],
      });

      expect(event.reminders, hasLength(1));
      expect(event.reminders.single.minutesBefore, 10);
    });

    test('normalized rejects invalid event dates instead of rolling', () {
      final event = GeneralEvent(
        id: 'bad_date',
        title: 'Bad date',
        startDateTimeIso: '9999-02-31T09:00:00',
        endDateTimeIso: '9999-02-31T10:00:00',
      ).normalized(fallbackCalendarId: 'cal');

      expect(event.startDateTimeIso, isNot(startsWith('9999-03-03')));
      expect(DateTime.parse(event.startDateTimeIso).year, isNot(9999));
    });
  });

  group('GeneralSchedule', () {
    test('JSON round-trip with events', () {
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work Schedule',
        events: [
          GeneralEvent(
            id: 'evt1',
            title: 'Meeting',
            startDateTimeIso: '2026-05-22T09:00:00.000',
            endDateTimeIso: '2026-05-22T10:00:00.000',
          ),
        ],
      );

      final json = schedule.toJson();
      final decoded = GeneralSchedule.fromJson(json);

      expect(decoded.id, 'sched1');
      expect(decoded.name, 'Work Schedule');
      expect(decoded.events.length, 1);
      expect(decoded.events.first.title, 'Meeting');
    });

    test('empty events list round-trips', () {
      final schedule = GeneralSchedule(
        id: 'sched2',
        name: 'Empty',
        events: const [],
      );

      final json = schedule.toJson();
      final decoded = GeneralSchedule.fromJson(json);

      expect(decoded.events, isEmpty);
    });

    test('missing name uses default', () {
      final schedule = GeneralSchedule.fromJson({'id': 'sched3', 'events': []});

      expect(schedule.name, isNotEmpty);
    });

    test('copyWith preserves unchanged fields', () {
      final original = GeneralSchedule(
        id: 'sched4',
        name: 'Original',
        events: const [],
      );

      final updated = original.copyWith(name: 'Renamed');

      expect(updated.id, 'sched4');
      expect(updated.name, 'Renamed');
      expect(updated.events, isEmpty);
    });

    test(
      'copyWith updates owned event calendar ids when schedule id changes',
      () {
        final owned = GeneralEvent(
          id: 'owned',
          calendarId: 'old',
          title: 'Owned',
          startDateTimeIso: '2026-05-22T09:00:00.000',
          endDateTimeIso: '2026-05-22T10:00:00.000',
        );
        final emptyCalendar = owned.copyWith(id: 'empty', calendarId: '');
        final external = owned.copyWith(id: 'external', calendarId: 'other');
        final schedule = GeneralSchedule(
          id: 'old',
          name: 'Original',
          events: [owned, emptyCalendar, external],
        );

        final updated = schedule.copyWith(id: 'new');

        expect(updated.events[0].calendarId, 'new');
        expect(updated.events[1].calendarId, 'new');
        expect(updated.events[2].calendarId, 'other');
      },
    );

    test('fromJson filters malformed events', () {
      final schedule = GeneralSchedule.fromJson({
        'id': 'sched_bad_events',
        'name': 'Work',
        'events': [
          {
            'id': 'evt_valid',
            'title': 'Valid',
            'start': '2026-05-22T09:00:00.000',
            'end': '2026-05-22T10:00:00.000',
          },
          'bad',
          null,
        ],
      });

      expect(schedule.events, hasLength(1));
      expect(schedule.events.single.id, 'evt_valid');
      expect(schedule.events.single.calendarId, 'sched_bad_events');
    });
  });

  group('GeneralScheduleData', () {
    test('JSON round-trip with data', () {
      final data = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'My Schedule', events: const []),
        ],
        selectedDateIso: '2026-05-22',
      );

      final json = data.toJson();
      final decoded = GeneralScheduleData.fromJson(json);

      expect(decoded.activeScheduleId, 'sched1');
      expect(decoded.schedules.length, 1);
      expect(decoded.selectedDateIso, '2026-05-22');
      expect(decoded.closeEventPopupOnOutsideTap, true);
    });

    test('general popup dismiss setting round-trips independently', () {
      final data = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'My Schedule', events: const []),
        ],
        closeEventPopupOnOutsideTap: false,
      );

      final decoded = GeneralScheduleData.fromJson(data.toJson());

      expect(decoded.closeEventPopupOnOutsideTap, false);
    });

    test('reminder acknowledgements round-trip with schema version 3', () {
      final data = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'My Schedule', events: const []),
        ],
        reminderAcknowledgements: const [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'sched1|event1|2026-05-25T09:00:00.000',
            updatedAtIso: '2026-05-25T08:55:00.000',
          ),
        ],
      );

      final json = data.toJson();
      final decoded = GeneralScheduleData.fromJson(json);

      expect(json['schemaVersion'], generalScheduleSchemaVersion);
      expect(decoded.reminderAcknowledgements, hasLength(1));
      expect(
        decoded.reminderAcknowledgements.single.occurrenceKey,
        'sched1|event1|2026-05-25T09:00:00.000',
      );
      expect(decoded.reminderAcknowledgements.single.isHandled, true);
    });

    test(
      'schema version 2 data defaults to empty reminder acknowledgements',
      () {
        final decoded = GeneralScheduleData.fromJson({
          'schemaVersion': 2,
          'activeScheduleId': 'sched1',
          'schedules': [
            {'id': 'sched1', 'name': 'My Schedule', 'events': <Object>[]},
          ],
        });

        expect(decoded.schedules.single.id, 'sched1');
        expect(decoded.reminderAcknowledgements, isEmpty);
      },
    );

    test('fromJson rejects future schemaVersion', () {
      expect(
        () => GeneralScheduleData.fromJson({
          'schemaVersion': generalScheduleSchemaVersion + 1,
          'activeScheduleId': 'sched1',
          'schedules': [
            {'id': 'sched1', 'name': 'My Schedule', 'events': <Object>[]},
          ],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('fromJson rejects future schemaVersion encoded as a string', () {
      expect(
        () => GeneralScheduleData.fromJson({
          'schemaVersion': '${generalScheduleSchemaVersion + 1}',
          'activeScheduleId': 'sched1',
          'schedules': [
            {'id': 'sched1', 'name': 'My Schedule', 'events': <Object>[]},
          ],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('missing activeScheduleId defaults to first schedule', () {
      final data = GeneralScheduleData(
        activeScheduleId: '',
        schedules: [
          GeneralSchedule(id: 'schedA', name: 'A', events: const []),
          GeneralSchedule(id: 'schedB', name: 'B', events: const []),
        ],
      );

      expect(data.activeSchedule.id, 'schedA');
    });

    test('empty schedules list creates default schedule', () {
      final json = <String, dynamic>{'selectedDateIso': '2026-05-22'};
      final decoded = GeneralScheduleData.fromJson(json);

      expect(decoded.schedules, isNotEmpty);
      expect(decoded.schedules.first.name, isNotEmpty);
    });

    test('copyWith preserves unchanged fields', () {
      final original = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'First', events: const []),
        ],
        selectedDateIso: '2026-05-22',
      );

      final updated = original.copyWith(selectedDateIso: '2026-05-29');

      expect(updated.activeScheduleId, 'sched1');
      expect(updated.selectedDateIso, '2026-05-29');
    });

    test('fromJson rejects invalid selected dates instead of rolling', () {
      final decoded = GeneralScheduleData.fromJson({
        'schemaVersion': generalScheduleSchemaVersion,
        'activeScheduleId': 'sched1',
        'selectedDateIso': '9999-02-31',
        'schedules': [
          {'id': 'sched1', 'name': 'My Schedule', 'events': <Object>[]},
        ],
      });

      expect(decoded.selectedDateIso, isNot('9999-03-03'));
      expect(decoded.selectedDate.year, isNot(9999));
    });

    test(
      'copyWith can explicitly clear selected date to normalized fallback',
      () {
        final original = GeneralScheduleData(
          activeScheduleId: 'sched1',
          schedules: [
            GeneralSchedule(id: 'sched1', name: 'First', events: const []),
          ],
          selectedDateIso: '2026-05-22',
        );

        final updated = original.copyWith(selectedDateIso: null);

        expect(updated.selectedDateIso, isNot('2026-05-22'));
        expect(DateTime.tryParse(updated.selectedDateIso ?? ''), isNotNull);
      },
    );

    test('copyWith replaces nullable reminder acknowledgement list', () {
      final original = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'First', events: const []),
        ],
        reminderAcknowledgements: const [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'sched1|old|2026-05-25T09:00:00.000',
            updatedAtIso: '2026-05-25T08:55:00.000',
          ),
        ],
      );

      final updated = original.copyWith(
        reminderAcknowledgements: const [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'sched1|new|2026-05-25T09:00:00.000',
            isHandled: false,
            updatedAtIso: '2026-05-25T08:56:00.000',
          ),
        ],
      );

      expect(updated.reminderAcknowledgements, hasLength(1));
      expect(
        updated.reminderAcknowledgements.single.occurrenceKey,
        contains('new'),
      );
      expect(updated.reminderAcknowledgements.single.isHandled, false);
    });

    test('normalized de-duplicates reminder acknowledgements by key', () {
      final data = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'First', events: const []),
        ],
        reminderAcknowledgements: const [
          GeneralReminderAcknowledgement(
            occurrenceKey: 'sched1|event|2026-05-25T09:00:00.000',
            updatedAtIso: '2026-05-25T08:55:00.000',
          ),
          GeneralReminderAcknowledgement(
            occurrenceKey: 'sched1|event|2026-05-25T09:00:00.000',
            isHandled: false,
            updatedAtIso: '2026-05-25T08:56:00.000',
          ),
          GeneralReminderAcknowledgement(
            occurrenceKey: '',
            updatedAtIso: '2026-05-25T08:57:00.000',
          ),
        ],
      );

      final normalized = data.normalized();

      expect(normalized.reminderAcknowledgements, hasLength(1));
      expect(normalized.reminderAcknowledgements.single.isHandled, false);
      expect(
        normalized.reminderAcknowledgements.single.updatedAtIso,
        '2026-05-25T08:56:00.000',
      );
    });

    test('withSchedule replaces schedule by id', () {
      final original = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'Old', events: const []),
        ],
      );

      final updated = original.withSchedule(
        GeneralSchedule(id: 'sched1', name: 'New', events: const []),
      );

      expect(updated.schedules.first.name, 'New');
    });

    test('withSchedule adds new schedule', () {
      final original = GeneralScheduleData(
        activeScheduleId: 'sched1',
        schedules: [
          GeneralSchedule(id: 'sched1', name: 'First', events: const []),
        ],
      );

      final updated = original.withSchedule(
        GeneralSchedule(id: 'sched2', name: 'Second', events: const []),
      );

      expect(updated.schedules.length, 2);
    });

    test('normalized data makes schedule and event ids unique', () {
      final data = GeneralScheduleData(
        activeScheduleId: 'dup',
        schedules: [
          GeneralSchedule(
            id: 'dup',
            name: 'First',
            events: [
              GeneralEvent(
                id: 'evt',
                calendarId: 'dup',
                title: 'First event',
                startDateTimeIso: '2026-05-22T09:00:00.000',
                endDateTimeIso: '2026-05-22T10:00:00.000',
              ),
            ],
          ),
          GeneralSchedule(
            id: 'dup',
            name: 'Second',
            events: [
              GeneralEvent(
                id: 'evt',
                calendarId: 'dup',
                title: 'Second event',
                startDateTimeIso: '2026-05-23T09:00:00.000',
                endDateTimeIso: '2026-05-23T10:00:00.000',
              ),
            ],
          ),
        ],
      );

      final normalized = data.normalized();
      final scheduleIds = normalized.schedules.map((s) => s.id).toSet();
      final eventIds = normalized.schedules
          .expand((s) => s.events)
          .map((e) => e.id)
          .toSet();

      expect(scheduleIds.length, 2);
      expect(eventIds.length, 2);
      for (final schedule in normalized.schedules) {
        expect(schedule.events.single.calendarId, schedule.id);
      }
    });

    test('fromJson filters malformed schedules and acknowledgements', () {
      final decoded = GeneralScheduleData.fromJson({
        'schemaVersion': generalScheduleSchemaVersion,
        'activeScheduleId': 'sched1',
        'schedules': [
          {
            'id': 'sched1',
            'name': 'Valid',
            'events': [
              {
                'id': 'evt1',
                'title': 'Event',
                'start': '2026-05-22T09:00:00.000',
                'end': '2026-05-22T10:00:00.000',
              },
              42,
            ],
          },
          'bad',
        ],
        'reminderAcknowledgements': [
          {
            'occurrenceKey': 'sched1|evt1|2026-05-22T09:00:00.000',
            'updatedAt': '2026-05-22T08:55:00.000',
          },
          'bad',
        ],
      });

      expect(decoded.schedules, hasLength(1));
      expect(decoded.schedules.single.events, hasLength(1));
      expect(decoded.reminderAcknowledgements, hasLength(1));
    });
  });

  group('GeneralEventOccurrence', () {
    test('holds reference to source event and computed dates', () {
      final event = GeneralEvent(
        id: 'evt1',
        calendarId: 'sched1',
        title: 'Meeting',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
      );
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work',
        events: [event],
      );

      final occurrence = GeneralEventOccurrence(
        event: event,
        calendar: schedule,
        start: DateTime(2026, 5, 22, 9, 0),
        end: DateTime(2026, 5, 22, 10, 0),
        sequence: 0,
      );

      expect(occurrence.event.id, 'evt1');
      expect(occurrence.calendar.id, 'sched1');
      expect(occurrence.start.hour, 9);
      expect(occurrence.end.hour, 10);
    });

    test('expands daily recurrence with count', () {
      final event = GeneralEvent(
        id: 'daily',
        calendarId: 'sched1',
        title: 'Daily',
        startDateTimeIso: '2026-05-20T09:00:00.000',
        endDateTimeIso: '2026-05-20T09:30:00.000',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.daily,
          unit: GeneralEventRecurrenceUnit.day,
          count: 3,
        ),
      );
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work',
        events: [event],
      );

      final occurrences = expandGeneralEventOccurrences(
        calendar: schedule,
        event: event,
        startInclusive: DateTime(2026, 5, 20),
        endExclusive: DateTime(2026, 5, 25),
      );

      expect(occurrences.map((item) => item.start.day), [20, 21, 22]);
    });

    test('expands monthly recurrence from month end safely', () {
      final event = GeneralEvent(
        id: 'monthly',
        calendarId: 'sched1',
        title: 'Monthly',
        startDateTimeIso: '2026-01-31T09:00:00.000',
        endDateTimeIso: '2026-01-31T10:00:00.000',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.monthly,
          unit: GeneralEventRecurrenceUnit.month,
          count: 3,
        ),
      );
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work',
        events: [event],
      );

      final occurrences = expandGeneralEventOccurrences(
        calendar: schedule,
        event: event,
        startInclusive: DateTime(2026, 1, 1),
        endExclusive: DateTime(2026, 4, 1),
      );

      expect(occurrences.map((item) => [item.start.month, item.start.day]), [
        [1, 31],
        [2, 28],
        [3, 31],
      ]);
    });

    test('expands custom interval recurrence and skips exceptions', () {
      final event = GeneralEvent(
        id: 'custom',
        calendarId: 'sched1',
        title: 'Custom',
        startDateTimeIso: '2026-05-20T09:00:00.000',
        endDateTimeIso: '2026-05-20T10:00:00.000',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.custom,
          unit: GeneralEventRecurrenceUnit.day,
          interval: 2,
          count: 4,
        ),
        recurrenceExceptionDateIso: const ['2026-05-22'],
      );
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work',
        events: [event],
      );

      final occurrences = expandGeneralEventOccurrences(
        calendar: schedule,
        event: event,
        startInclusive: DateTime(2026, 5, 20),
        endExclusive: DateTime(2026, 5, 30),
      );

      expect(occurrences.map((item) => item.start.day), [20, 24, 26]);
    });

    test('far future recurrence query starts near visible range', () {
      final event = GeneralEvent(
        id: 'future',
        calendarId: 'sched1',
        title: 'Future',
        startDateTimeIso: '2020-01-01T09:00:00.000',
        endDateTimeIso: '2020-01-01T10:00:00.000',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.daily,
          unit: GeneralEventRecurrenceUnit.day,
        ),
      );
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work',
        events: [event],
      );

      final occurrences = expandGeneralEventOccurrences(
        calendar: schedule,
        event: event,
        startInclusive: DateTime(2026, 5, 20),
        endExclusive: DateTime(2026, 5, 22),
      );

      expect(occurrences, hasLength(2));
      expect(occurrences.first.start, DateTime(2026, 5, 20, 9));
    });
  });
}
