import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';

class _MemoryTimetableStorage implements TimetableStorage {
  _MemoryTimetableStorage(this.data);

  AppData? data;

  @override
  Future<AppData?> load() async => data;

  @override
  Future<void> save(AppData data) async {
    this.data = data;
  }

  @override
  Future<String?> filePath() async => 'memory://provider-general-test';
}

void main() {
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
    expect(duplicated.title, 'Standup copy');
    expect(duplicated.startDateTimeIso, startsWith('2026-05-25T09:00:00'));
    expect(duplicated.endDateTimeIso, startsWith('2026-05-25T09:30:00'));
    expect(duplicated.recurrenceRule.isRepeating, false);

    final sameDay = provider.generalOccurrencesForRange(
      startInclusive: DateTime(2026, 5, 25),
      endExclusive: DateTime(2026, 5, 26),
    );
    expect(sameDay.map((item) => item.event.id), contains(duplicated.id));
    expect(sameDay.map((item) => item.event.id), contains('repeat1'));
  });

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
