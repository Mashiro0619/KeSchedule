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

    test('unknown recurrence defaults to none', () {
      final json = {
        'id': 'evt3',
        'title': 'Test',
        'start': '2026-05-22T09:00:00.000',
        'end': '2026-05-22T10:00:00.000',
        'recurrence': 'monthly',
      };
      final decoded = GeneralEvent.fromJson(json);

      expect(decoded.recurrence, GeneralEventRecurrence.none);
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
        schedules: const [],
        selectedDateIso: '2026-05-22',
      );

      final updated = original.copyWith(selectedDateIso: '2026-05-29');

      expect(updated.activeScheduleId, 'sched1');
      expect(updated.selectedDateIso, '2026-05-29');
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
  });

  group('GeneralEventOccurrence', () {
    test('holds reference to source event and computed dates', () {
      final event = GeneralEvent(
        id: 'evt1',
        title: 'Meeting',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
      );

      final occurrence = GeneralEventOccurrence(
        event: event,
        start: DateTime(2026, 5, 22, 9, 0),
        end: DateTime(2026, 5, 22, 10, 0),
      );

      expect(occurrence.event.id, 'evt1');
      expect(occurrence.start.hour, 9);
      expect(occurrence.end.hour, 10);
    });
  });
}
