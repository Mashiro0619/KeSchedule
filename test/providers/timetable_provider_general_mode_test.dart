import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/services/general_calendar_ics_service.dart';

class _MemoryTimetableStorage implements TimetableStorage {
  _MemoryTimetableStorage(this.data);

  AppData? data;

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    this.data = data;
  }

  @override
  Future<String?> filePath() async => 'memory://provider-general-test';
}

void main() {
  test('filters occurrences by visible calendars by default', () async {
    final visibleCalendar = GeneralSchedule(
      id: 'visible',
      name: 'Visible',
      events: [
        GeneralEvent(
          id: 'evt_visible',
          calendarId: 'visible',
          title: 'Visible event',
          startDateTimeIso: '2026-05-25T09:00:00.000',
          endDateTimeIso: '2026-05-25T10:00:00.000',
        ),
      ],
    );
    final hiddenCalendar = GeneralSchedule(
      id: 'hidden',
      name: 'Hidden',
      isVisible: false,
      events: [
        GeneralEvent(
          id: 'evt_hidden',
          calendarId: 'hidden',
          title: 'Hidden event',
          startDateTimeIso: '2026-05-25T11:00:00.000',
          endDateTimeIso: '2026-05-25T12:00:00.000',
        ),
      ],
    );
    final provider = TimetableProvider(
      storage: _MemoryTimetableStorage(
        buildInitialAppData(buildDefaultPeriodTimes()).copyWith(
          generalMode: GeneralScheduleData(
            activeScheduleId: 'visible',
            schedules: [visibleCalendar, hiddenCalendar],
            selectedDateIso: '2026-05-25',
          ),
        ),
      ),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );

    await provider.load();
    final visibleOnly = provider.generalOccurrencesForRange(
      startInclusive: DateTime(2026, 5, 25),
      endExclusive: DateTime(2026, 5, 26),
    );
    final allCalendars = provider.generalOccurrencesForRange(
      startInclusive: DateTime(2026, 5, 25),
      endExclusive: DateTime(2026, 5, 26),
      onlyVisibleCalendars: false,
    );

    expect(visibleOnly.map((item) => item.event.id), ['evt_visible']);
    expect(allCalendars.map((item) => item.event.id), [
      'evt_visible',
      'evt_hidden',
    ]);
  });

  test('deleting the last calendar creates a default calendar', () async {
    final provider = TimetableProvider(
      storage: _MemoryTimetableStorage(
        buildInitialAppData(buildDefaultPeriodTimes()),
      ),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );

    await provider.load();
    final onlyCalendarId = provider.activeGeneralSchedule.id;
    await provider.deleteGeneralSchedule(onlyCalendarId);

    expect(provider.generalSchedules, hasLength(1));
    expect(
      provider.activeGeneralSchedule.id,
      provider.generalSchedules.single.id,
    );
    expect(provider.activeGeneralSchedule.events, isEmpty);
  });

  test('duplicates the selected occurrence as a one-time event', () async {
    final initial = buildInitialAppData(buildDefaultPeriodTimes());
    final provider = TimetableProvider(
      storage: _MemoryTimetableStorage(initial),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );

    await provider.load();
    final calendarId = provider.activeGeneralSchedule.id;
    await provider.saveGeneralEvent(
      GeneralEvent(
        id: 'repeat1',
        calendarId: calendarId,
        title: 'Standup',
        startDateTimeIso: '2026-05-18T09:00:00.000',
        endDateTimeIso: '2026-05-18T09:30:00.000',
        recurrenceRule: const GeneralEventRecurrenceRule(
          type: GeneralEventRecurrence.weekly,
          unit: GeneralEventRecurrenceUnit.week,
          count: 4,
        ),
        recurrenceExceptionDateIso: const ['2026-06-01'],
        location: 'Room A',
        notes: 'Bring notes',
        colorValue: 0xFF123456,
        reminders: const [GeneralEventReminder(minutesBefore: 10)],
      ),
    );

    final occurrence = provider
        .generalOccurrencesForRange(
          startInclusive: DateTime(2026, 5, 25),
          endExclusive: DateTime(2026, 5, 26),
        )
        .single;

    final duplicated = await provider.duplicateGeneralOccurrence(occurrence);

    expect(duplicated.id, isNot('repeat1'));
    expect(duplicated.title, 'Standup');
    expect(duplicated.startDateTimeIso, startsWith('2026-05-25T09:00:00'));
    expect(duplicated.endDateTimeIso, startsWith('2026-05-25T09:30:00'));
    expect(duplicated.recurrenceRule.isRepeating, false);
    expect(duplicated.recurrenceExceptionDateIso, isEmpty);
    expect(duplicated.location, 'Room A');
    expect(duplicated.notes, 'Bring notes');
    expect(duplicated.colorValue, 0xFF123456);
    expect(duplicated.reminders.single.minutesBefore, 10);
    expect(duplicated.calendarId, calendarId);

    final sameDay = provider.generalOccurrencesForRange(
      startInclusive: DateTime(2026, 5, 25),
      endExclusive: DateTime(2026, 5, 26),
    );
    expect(sameDay.map((item) => item.event.id), contains(duplicated.id));
    expect(sameDay.map((item) => item.event.id), contains('repeat1'));
  });

  test('dismisses and restores general reminder occurrences', () async {
    final initial = buildInitialAppData(buildDefaultPeriodTimes());
    final provider = TimetableProvider(
      storage: _MemoryTimetableStorage(initial),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );

    await provider.load();
    final calendarId = provider.activeGeneralSchedule.id;
    await provider.saveGeneralEvent(
      GeneralEvent(
        id: 'reminder1',
        calendarId: calendarId,
        title: 'Reminder event',
        startDateTimeIso: '2026-05-25T10:00:00.000',
        endDateTimeIso: '2026-05-25T11:00:00.000',
        reminders: const [GeneralEventReminder(minutesBefore: 10)],
      ),
    );

    final now = DateTime(2026, 5, 25, 9, 55);
    final initialItems = provider.generalReminderItems(now: now);

    expect(initialItems, hasLength(1));
    expect(initialItems.single.status, GeneralReminderStatus.upcoming);

    await provider.dismissGeneralReminder(initialItems.single.occurrence);

    expect(
      provider.isGeneralReminderHandled(initialItems.single.occurrence),
      true,
    );
    expect(provider.generalReminderItems(now: now), isEmpty);

    await provider.restoreGeneralReminder(initialItems.single.occurrence);

    expect(
      provider.isGeneralReminderHandled(initialItems.single.occurrence),
      false,
    );
    expect(provider.generalReminderItems(now: now), hasLength(1));
  });

  test(
    'general reminder items include recent overdue unhandled events',
    () async {
      final initial = buildInitialAppData(buildDefaultPeriodTimes());
      final provider = TimetableProvider(
        storage: _MemoryTimetableStorage(initial),
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );

      await provider.load();
      final calendarId = provider.activeGeneralSchedule.id;
      await provider.saveGeneralEvent(
        GeneralEvent(
          id: 'overdue1',
          calendarId: calendarId,
          title: 'Overdue event',
          startDateTimeIso: '2026-05-25T08:00:00.000',
          endDateTimeIso: '2026-05-25T09:00:00.000',
        ),
      );

      final now = DateTime(2026, 5, 25, 10);
      final items = provider.generalReminderItems(now: now);

      expect(items, hasLength(1));
      expect(items.single.status, GeneralReminderStatus.overdue);
    },
  );

  test('deleting a calendar removes its handled reminder records', () async {
    final schedule = GeneralSchedule(
      id: 'cal1',
      name: 'Work',
      events: [
        GeneralEvent(
          id: 'event1',
          calendarId: 'cal1',
          title: 'Reminder event',
          startDateTimeIso: '2026-05-25T09:00:00.000',
          endDateTimeIso: '2026-05-25T10:00:00.000',
        ),
      ],
    );
    final storage = _MemoryTimetableStorage(
      buildInitialAppData(buildDefaultPeriodTimes()).copyWith(
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [schedule],
          reminderAcknowledgements: const [
            GeneralReminderAcknowledgement(
              occurrenceKey: 'cal1|event1|2026-05-25T09:00:00.000',
              updatedAtIso: '2026-05-25T08:55:00.000',
            ),
          ],
        ),
      ),
    );
    final provider = TimetableProvider(
      storage: storage,
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );

    await provider.load();
    await provider.deleteGeneralSchedule('cal1');

    expect(storage.data!.generalMode.reminderAcknowledgements, isEmpty);
    expect(provider.generalSchedules, hasLength(1));
  });

  test(
    'replacing active calendar clears old handled reminder records',
    () async {
      final active = GeneralSchedule(
        id: 'active',
        name: 'Active',
        events: [
          GeneralEvent(
            id: 'event1',
            calendarId: 'active',
            title: 'Old event',
            startDateTimeIso: '2026-05-25T09:00:00.000',
            endDateTimeIso: '2026-05-25T10:00:00.000',
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );
      final storage = _MemoryTimetableStorage(
        buildInitialAppData(buildDefaultPeriodTimes()).copyWith(
          generalMode: GeneralScheduleData(
            activeScheduleId: 'active',
            schedules: [active],
            reminderAcknowledgements: const [
              GeneralReminderAcknowledgement(
                occurrenceKey: 'active|event1|2026-05-25T09:00:00.000',
                updatedAtIso: '2026-05-25T08:55:00.000',
              ),
            ],
          ),
        ),
      );
      final provider = TimetableProvider(
        storage: storage,
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );
      final source = encodeGeneralScheduleDataEnvelope(
        GeneralScheduleExportData(
          schedules: [
            GeneralSchedule(
              id: 'replacement',
              name: 'Replacement',
              events: [
                GeneralEvent(
                  id: 'event1',
                  calendarId: 'replacement',
                  title: 'Replacement event',
                  startDateTimeIso: '2026-05-25T09:00:00.000',
                  endDateTimeIso: '2026-05-25T10:00:00.000',
                  reminders: const [GeneralEventReminder(minutesBefore: 10)],
                ),
              ],
            ),
          ],
        ),
      );

      await provider.load();
      await provider.importSelectedGeneralSchedulesJson(
        source,
        scheduleIds: const ['replacement'],
        mode: GeneralScheduleImportMode.replaceActive,
      );

      final items = provider.generalReminderItems(
        now: DateTime(2026, 5, 25, 8, 55),
      );
      expect(storage.data!.generalMode.reminderAcknowledgements, isEmpty);
      expect(items, hasLength(1));
      expect(items.single.occurrence.event.title, 'Replacement event');
    },
  );

  test(
    'deleting future recurrence clears future handled reminder records',
    () async {
      final schedule = GeneralSchedule(
        id: 'cal1',
        name: 'Work',
        events: [
          GeneralEvent(
            id: 'repeat1',
            calendarId: 'cal1',
            title: 'Weekly',
            startDateTimeIso: '2026-05-18T09:00:00.000',
            endDateTimeIso: '2026-05-18T10:00:00.000',
            recurrenceRule: const GeneralEventRecurrenceRule(
              type: GeneralEventRecurrence.weekly,
              unit: GeneralEventRecurrenceUnit.week,
              count: 4,
            ),
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );
      final storage = _MemoryTimetableStorage(
        buildInitialAppData(buildDefaultPeriodTimes()).copyWith(
          generalMode: GeneralScheduleData(
            activeScheduleId: 'cal1',
            schedules: [schedule],
            reminderAcknowledgements: const [
              GeneralReminderAcknowledgement(
                occurrenceKey: 'cal1|repeat1|2026-05-18T09:00:00.000',
                updatedAtIso: '2026-05-18T08:55:00.000',
              ),
              GeneralReminderAcknowledgement(
                occurrenceKey: 'cal1|repeat1|2026-05-25T09:00:00.000',
                updatedAtIso: '2026-05-25T08:55:00.000',
              ),
              GeneralReminderAcknowledgement(
                occurrenceKey: 'cal1|repeat1|2026-06-01T09:00:00.000',
                updatedAtIso: '2026-06-01T08:55:00.000',
              ),
            ],
          ),
        ),
      );
      final provider = TimetableProvider(
        storage: storage,
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );

      await provider.load();
      final occurrence = provider
          .generalOccurrencesForRange(
            startInclusive: DateTime(2026, 5, 25),
            endExclusive: DateTime(2026, 5, 26),
          )
          .single;

      await provider.deleteFutureGeneralOccurrences(occurrence);

      expect(
        storage.data!.generalMode.reminderAcknowledgements.map(
          (item) => item.occurrenceKey,
        ),
        [
          buildGeneralOccurrenceKey(
            'cal1',
            'repeat1',
            '2026-05-18T09:00:00.000',
          ),
        ],
      );
    },
  );

  test(
    'general JSON import returns structured result for selected calendars',
    () async {
      final provider = TimetableProvider(
        storage: _MemoryTimetableStorage(
          buildInitialAppData(buildDefaultPeriodTimes()),
        ),
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );
      final source = encodeGeneralScheduleDataEnvelope(
        GeneralScheduleExportData(
          schedules: [
            GeneralSchedule(id: 'import_a', name: 'Import A', events: const []),
            GeneralSchedule(id: 'import_b', name: 'Import B', events: const []),
          ],
        ),
      );

      await provider.load();
      final result = await provider.importSelectedGeneralSchedulesJson(
        source,
        scheduleIds: const ['import_a', 'import_b'],
        mode: GeneralScheduleImportMode.addAsNew,
      );

      expect(result.importedCount, 2);
      expect(result.scheduleNames, ['Import A', 'Import B']);
      expect(result.hasWarnings, false);
      expect(
        provider.generalSchedules.map((item) => item.name),
        contains('Import A'),
      );
      expect(
        provider.generalSchedules.map((item) => item.name),
        contains('Import B'),
      );
    },
  );

  test('general JSON import can replace the active calendar', () async {
    final provider = TimetableProvider(
      storage: _MemoryTimetableStorage(
        buildInitialAppData(buildDefaultPeriodTimes()),
      ),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );
    final source = encodeGeneralScheduleDataEnvelope(
      GeneralScheduleExportData(
        schedules: [
          GeneralSchedule(
            id: 'replacement',
            name: 'Replacement',
            events: [
              GeneralEvent(
                id: 'replacement_event',
                calendarId: 'replacement',
                title: 'Replacement Event',
                startDateTimeIso: '2026-05-25T09:00:00.000',
                endDateTimeIso: '2026-05-25T10:00:00.000',
              ),
            ],
          ),
        ],
      ),
    );

    await provider.load();
    final activeId = provider.activeGeneralSchedule.id;
    final result = await provider.importSelectedGeneralSchedulesJson(
      source,
      scheduleIds: const ['replacement'],
      mode: GeneralScheduleImportMode.replaceActive,
    );

    expect(result.importedCount, 1);
    expect(provider.activeGeneralSchedule.id, activeId);
    expect(provider.activeGeneralSchedule.name, 'Replacement');
    expect(
      provider.activeGeneralSchedule.events.single.title,
      'Replacement Event',
    );
  });

  test(
    'malformed general JSON import fails before mutating calendars',
    () async {
      final provider = TimetableProvider(
        storage: _MemoryTimetableStorage(
          buildInitialAppData(buildDefaultPeriodTimes()),
        ),
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );

      await provider.load();
      final before = provider.generalSchedules.length;

      await expectLater(
        provider.importSelectedGeneralSchedulesJson(
          '{not-json',
          scheduleIds: const ['missing'],
          mode: GeneralScheduleImportMode.addAsNew,
        ),
        throwsFormatException,
      );
      expect(provider.generalSchedules, hasLength(before));
    },
  );

  test(
    'general ICS import returns structured localized-warning data',
    () async {
      final provider = TimetableProvider(
        storage: _MemoryTimetableStorage(
          buildInitialAppData(buildDefaultPeriodTimes()),
        ),
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );
      const source = '''
BEGIN:VCALENDAR
VERSION:2.0
BEGIN:VEVENT
UID:test-warning
DTSTART:20260525T090000
DTEND:20260525T100000
SUMMARY:Imported
X-SKED-UNKNOWN:kept
END:VEVENT
END:VCALENDAR
''';

      await provider.load();
      final result = await provider.importGeneralSchedulesIcs(
        source,
        mode: GeneralScheduleImportMode.addAsNew,
      );

      expect(result.importedCount, 1);
      expect(result.hasWarnings, true);
      expect(
        result.icsWarnings.single.code,
        GeneralCalendarIcsWarningCode.unsupportedFields,
      );
    },
  );

  test(
    'general ICS import failures are localized by provider locale',
    () async {
      final provider = TimetableProvider(
        storage: _MemoryTimetableStorage(
          buildInitialAppData(
            buildDefaultPeriodTimes(),
          ).copyWith(localeCode: 'zh'),
        ),
        systemLocaleCodeResolver: () => 'zh',
      );

      await provider.load();

      expect(
        () => provider.previewImportGeneralSchedulesIcs(
          'BEGIN:VCALENDAR\nEND:VCALENDAR',
        ),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            '导入文件没有日程。',
          ),
        ),
      );
    },
  );

  test(
    'general popup dismiss setting does not mutate student setting',
    () async {
      final initial = buildInitialAppData(buildDefaultPeriodTimes());
      final provider = TimetableProvider(
        storage: _MemoryTimetableStorage(initial),
        systemLocaleCodeResolver: () => defaultLocaleCode,
      );

      await provider.load();
      final studentValue = provider.closeCoursePopupOnOutsideTap;

      await provider.updateGeneralDisplaySettings(
        closeEventPopupOnOutsideTap: false,
      );

      expect(provider.closeGeneralEventPopupOnOutsideTap, false);
      expect(provider.closeCoursePopupOnOutsideTap, studentValue);
    },
  );
}
