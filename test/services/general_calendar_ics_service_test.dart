import 'dart:convert';

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

  test('imports Google-style TZID and RRULE fixture', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Google Inc//Google Calendar 70.9054//EN
BEGIN:VEVENT
UID:google-style
SUMMARY:Team sync
DTSTART;TZID=Asia/Shanghai:20260525T090000
DTEND;TZID=Asia/Shanghai:20260525T100000
RRULE:FREQ=WEEKLY;UNTIL=20260615
LOCATION:Room G
DESCRIPTION:Google exported event
END:VEVENT
END:VCALENDAR
''';

    final imported = service.importSchedules(source);
    final event = imported.schedules.single.events.single;

    expect(event.title, 'Team sync');
    expect(event.startDateTimeIso, startsWith('2026-05-25T09:00:00'));
    expect(event.endDateTimeIso, startsWith('2026-05-25T10:00:00'));
    expect(event.location, 'Room G');
    expect(event.recurrenceRule.type, GeneralEventRecurrence.weekly);
    expect(event.recurrenceRule.untilDateIso, '2026-06-15');
  });

  test('imports Outlook-style escaped text and folded description', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Microsoft Corporation//Outlook 16.0 MIMEDIR//EN
BEGIN:VEVENT
UID:outlook-style
SUMMARY:Planning\\, Review\\; Follow-up
DTSTART:20260525T090000
DTEND:20260525T100000
LOCATION:Room\\, A\\; North
DESCRIPTION:Line one\\nLine two with comma\\, semicolon\\; and backslash \\\\
 continued after folding
END:VEVENT
END:VCALENDAR
''';

    final imported = service.importSchedules(source);
    final event = imported.schedules.single.events.single;

    expect(event.title, 'Planning, Review; Follow-up');
    expect(event.location, 'Room, A; North');
    expect(event.notes, contains('Line one\nLine two'));
    expect(event.notes, contains('backslash \\continued after folding'));
  });

  test('imports Apple-style UTC timed fixture', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Apple Inc.//macOS 15.0//EN
BEGIN:VEVENT
UID:apple-style
SUMMARY:Apple exported event
DTSTART:20260525T010000Z
DTEND:20260525T020000Z
END:VEVENT
END:VCALENDAR
''';

    final imported = service.importSchedules(source);
    final event = imported.schedules.single.events.single;

    expect(event.title, 'Apple exported event');
    expect(DateTime.tryParse(event.startDateTimeIso), isNotNull);
    expect(
      DateTime.parse(
        event.endDateTimeIso,
      ).isAfter(DateTime.parse(event.startDateTimeIso)),
      true,
    );
  });

  test('exports UTF-8 folded lines without splitting multibyte characters', () {
    final longTitle = '项目排期复盘会议' * 12;
    final schedule = GeneralSchedule(
      id: 'cal1',
      name: '工作',
      events: [
        GeneralEvent(
          id: 'evt-utf8',
          calendarId: 'cal1',
          title: longTitle,
          startDateTimeIso: '2026-05-25T09:00:00.000',
          endDateTimeIso: '2026-05-25T10:00:00.000',
          location: '会议室，北区',
          notes: '第一行\n第二行，包含分号；以及反斜杠 \\',
        ),
      ],
    );

    final ics = service.exportSchedules([schedule]);
    for (final line in ics.split('\r\n')) {
      expect(utf8.encode(line).length, lessThanOrEqualTo(74));
    }

    final imported = service.importSchedules(ics);
    final event = imported.schedules.single.events.single;

    expect(event.title, longTitle);
    expect(event.location, '会议室，北区');
    expect(event.notes, contains('第一行\n第二行，包含分号；以及反斜杠 \\'));
  });

  test('malformed ICS without events fails clearly', () {
    expect(
      () => service.importSchedules('BEGIN:VCALENDAR\nEND:VCALENDAR'),
      throwsA(
        isA<GeneralCalendarIcsImportException>().having(
          (error) => error.code,
          'code',
          GeneralCalendarIcsImportErrorCode.noEvents,
        ),
      ),
    );
  });

  test('VEVENT entries without DTSTART fail as no importable events', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:no-start
SUMMARY:No start
END:VEVENT
END:VCALENDAR
''';

    expect(
      () => service.importSchedules(source),
      throwsA(
        isA<GeneralCalendarIcsImportException>().having(
          (error) => error.code,
          'code',
          GeneralCalendarIcsImportErrorCode.noImportableEvents,
        ),
      ),
    );
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

    expect(
      imported.warningItems.single.code,
      GeneralCalendarIcsWarningCode.unsupportedFields,
    );
    expect(imported.warningItems.single.values, ['STATUS']);
    expect(imported.warnings.single, contains('STATUS'));
    expect(event.notes, contains('Unsupported ICS fields ignored: STATUS'));
  });

  test('reports unsupported RRULE parts instead of silently mapping them', () {
    const source = '''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:rrule-parts
SUMMARY:Busy
DTSTART:20260525T090000
DTEND:20260525T100000
RRULE:FREQ=WEEKLY;BYDAY=MO,WE;COUNT=4
END:VEVENT
END:VCALENDAR
''';

    final imported = service.importSchedules(source);
    final event = imported.schedules.single.events.single;
    final warning = imported.warningItems.singleWhere(
      (item) => item.code == GeneralCalendarIcsWarningCode.unsupportedFields,
    );

    expect(event.recurrenceRule.isRepeating, false);
    expect(warning.values, contains('RRULE:BYDAY=MO,WE'));
    expect(
      event.notes,
      contains('Unsupported RRULE parts ignored: BYDAY=MO,WE'),
    );
  });
}
