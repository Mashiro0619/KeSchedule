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
