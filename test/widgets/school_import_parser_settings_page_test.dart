import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/school_import_parser_settings_page.dart';
import 'package:sked/services/school_import_api.dart';

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
  Future<String?> filePath() async => 'memory://parser-settings-test';
}

class _BlockingSchoolImportApi extends SchoolImportApi {
  final completer = Completer<List<String>>();
  var callCount = 0;

  @override
  Future<List<String>> fetchCustomModels({
    required String baseUrl,
    required String apiKey,
  }) {
    callCount += 1;
    return completer.future;
  }
}

Future<TimetableProvider> _createProvider() async {
  final periodTimes = buildDefaultPeriodTimes();
  final data = buildInitialAppData(periodTimes, localeCode: defaultLocaleCode)
      .copyWith(
        studentMode: StudentModeData(
          activeTimetableId: 'table-1',
          timetables: [
            TimetableData(
              id: 'table-1',
              config: TimetableConfig(
                name: 'Parser settings timetable',
                startDate: DateTime(2026, 5, 25),
                totalWeeks: 18,
                periodTimeSetId: defaultPeriodTimeSetId,
              ),
              courses: const [],
            ),
          ],
          periodTimeSets: [
            PeriodTimeSet(
              id: defaultPeriodTimeSetId,
              name: 'Default',
              periodTimes: periodTimes,
            ),
          ],
          schoolImportParserSettings: const SchoolImportParserSettings(
            source: schoolImportParserSourceCustomOpenAi,
            customBaseUrl: 'https://api.example.com/v1',
            customApiKey: 'sk-test',
          ),
        ),
      );
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(data),
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

Future<void> _pumpPage(
  WidgetTester tester,
  TimetableProvider provider,
  SchoolImportApi api,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SchoolImportParserSettingsPage(api: api),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('fetch model list ignores rapid duplicate taps', (tester) async {
    final provider = await _createProvider();
    final api = _BlockingSchoolImportApi();
    await _pumpPage(tester, provider, api);

    final fetchButton = find.text('Fetch model list');
    expect(fetchButton, findsOneWidget);
    await tester.ensureVisible(fetchButton);
    await tester.pumpAndSettle();

    await tester.tap(fetchButton);
    await tester.tap(fetchButton, warnIfMissed: false);

    expect(api.callCount, 1);

    await tester.pump();
    expect(find.text('Fetching models...'), findsOneWidget);

    api.completer.complete(['model-a']);
    await tester.pumpAndSettle();

    expect(api.callCount, 1);
    expect(find.text('model-a'), findsOneWidget);
  });
}
