import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/services/timetable_json_import_service.dart';

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
  Future<String?> filePath() async => 'memory://timetable-json-import-test';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = TimetableJsonImportService();

  TimetableData timetable({
    String id = 'table1',
    String periodTimeSetId = 'set1',
  }) {
    return TimetableData(
      id: id,
      config: TimetableConfig(
        name: 'Table',
        startDate: DateTime(2026, 2, 23),
        totalWeeks: 18,
        periodTimeSetId: periodTimeSetId,
      ),
      courses: const [],
    );
  }

  PeriodTimeSet periodSet({String id = 'set1'}) {
    return PeriodTimeSet(
      id: id,
      name: 'Periods',
      periodTimes: buildPeriodTimesForCount(2),
    );
  }

  Future<TimetableProvider> provider() async {
    final provider = TimetableProvider(
      storage: _MemoryTimetableStorage(
        buildInitialAppData(
          buildDefaultPeriodTimes(),
          localeCode: defaultLocaleCode,
        ),
      ),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );
    await provider.load();
    return provider;
  }

  test('detects bundled period sets inside full app-data exports', () async {
    final source = encodeAppDataEnvelope(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.student,
        studentMode: StudentModeData(
          activeTimetableId: 'table1',
          timetables: [timetable()],
          periodTimeSets: [periodSet()],
        ),
      ),
    );

    final preview = service.preview(await provider(), source);

    expect(preview.candidates.map((item) => item.id), ['table1']);
    expect(preview.hasBundledPeriodTimeSets, isTrue);
  });

  test('previews empty timetable exports without throwing', () async {
    final source = encodeTimetableDataEnvelope(
      const TimetableExportData(timetables: [], periodTimeSets: []),
    );

    final preview = service.preview(await provider(), source);

    expect(preview.candidates, isEmpty);
    expect(preview.hasBundledPeriodTimeSets, isFalse);
  });

  test(
    'detects bundled periods inside nested legacy timetable exports',
    () async {
      final source = ImportExportEnvelope(
        schema: timetableDataSchema,
        version: importExportVersion,
        data: const {
          'timetable': {
            'id': 'legacy',
            'config': {
              'name': 'Legacy',
              'periodTimeSetId': '',
              'periodTimes': [
                {'index': 3, 'startMinutes': 600, 'endMinutes': 645},
              ],
            },
            'courses': [],
          },
        },
      ).encode();

      final preview = service.preview(await provider(), source);

      expect(preview.candidates.single.id, 'legacy');
      expect(preview.hasBundledPeriodTimeSets, isTrue);
    },
  );
}
