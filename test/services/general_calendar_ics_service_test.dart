import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/services/general_calendar_ics_service.dart';

void main() {
  const service = GeneralCalendarIcsService();

  test('exports and imports a recurring timed event', () {
    final schedule = GeneralSchedule(
      id: 'cal1',
      name: 'Work',
      events: [
        GeneralEvent(
          id: 'evt1',
          calendarId: 'cal1',
          title: 'Planning, Review',
          startDateTimeIso: '2026-05-25T09:00:00.000',
          endDateTimeIso: '2026-05-25T10:30:00.000',
          recurrenceRule: const GeneralEventRecurrenceRule(
            type: GeneralEventRecurrence.weekly,
            interval: 1,
            unit: GeneralEventRecurrenceUnit.week,
            count: 3,
          ),
          location: 'Room A',
          notes: r'Path C:\Temp, keep; literal \n',
        ),
      ],
    );

    final ics = service.exportSchedules([schedule]);
    final imported = service.importSchedules(ics);
    final event = imported.schedules.single.events.single;

    expect(ics, contains('BEGIN:VCALENDAR'));
    expect(ics, contains('RRULE:FREQ=WEEKLY;COUNT=3'));
    expect(event.title, 'Planning, Review');
    expect(event.location, 'Room A');
    expect(event.notes, contains(r'Path C:\Temp, keep; literal \n'));
    expect(event.notes, contains('Calendar: Work'));
    expect(event.recurrenceRule.type, GeneralEventRecurrence.weekly);
    expect(event.recurrenceRule.count, 3);
    expect(event.isAllDay, false);
  });

  test('imports all-day date ranges as exclusive end dates', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:all-day-1
SUMMARY:Conference
DTSTART;VALUE=DATE:20260524
DTEND;VALUE=DATE:20260526
END:VEVENT
END:VCALENDAR
''';

    final imported = service.importSchedules(source);
    final event = imported.schedules.single.events.single;

    expect(event.isAllDay, true);
    expect(event.startDateTimeIso, startsWith('2026-05-24'));
    expect(event.endDateTimeIso, startsWith('2026-05-26'));
  });

  test('reports unsupported ICS fields as warnings and notes', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:unsupported-1
SUMMARY:Busy
DTSTART:20260524T090000
DTEND:20260524T100000
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR
''';

    final imported = service.importSchedules(source);
    final event = imported.schedules.single.events.single;

    expect(imported.warnings.single, contains('STATUS'));
    expect(event.notes, contains('Unsupported ICS fields ignored: STATUS'));
  });
}
