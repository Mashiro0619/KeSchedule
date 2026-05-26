import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/settings_page.dart';
import 'package:sked/screens/theme_settings_page.dart';
import 'package:sked/services/privacy_service.dart';
import 'package:sked/widgets/text_transfer_widgets.dart';

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
  Future<String?> filePath() async => 'memory://settings-test';
}

class _NoopPrivacyService extends PrivacyService {
  const _NoopPrivacyService();

  @override
  Future<String?> fetchCurrentPrivacyPolicyVersion() async => null;
}

AppData _buildStudentData() {
  final periodTimes = buildDefaultPeriodTimes();
  final timetable = TimetableData(
    id: 'table-1',
    config: TimetableConfig(
      name: 'Settings timetable',
      startDate: DateTime(2026, 5, 25),
      totalWeeks: 18,
      periodTimeSetId: defaultPeriodTimeSetId,
    ),
    courses: const [],
  );
  return buildInitialAppData(
    periodTimes,
    localeCode: defaultLocaleCode,
  ).copyWith(
    activeMode: AppMode.student,
    studentMode: StudentModeData(
      activeTimetableId: timetable.id,
      timetables: [timetable],
      periodTimeSets: [
        PeriodTimeSet(
          id: defaultPeriodTimeSetId,
          name: 'Default',
          periodTimes: periodTimes,
        ),
      ],
    ),
  );
}

AppData _buildGeneralData() {
  return buildInitialAppData(
    buildDefaultPeriodTimes(),
    localeCode: defaultLocaleCode,
  ).copyWith(activeMode: AppMode.general);
}

Future<TimetableProvider> _createProvider(AppData data) async {
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(data),
    systemLocaleCodeResolver: () => defaultLocaleCode,
    privacyService: const _NoopPrivacyService(),
  );
  await provider.load();
  return provider;
}

Future<void> _pumpSettingsPage(
  WidgetTester tester,
  TimetableProvider provider,
) async {
  PackageInfo.setMockInitialValues(
    appName: 'Sked',
    packageName: 'com.example.sked',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );
  await tester.pumpWidget(
    ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpSettingsHostPage(
  WidgetTester tester,
  TimetableProvider provider,
) async {
  PackageInfo.setMockInitialValues(
    appName: 'Sked',
    packageName: 'com.example.sked',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );
  await tester.pumpWidget(
    ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ChangeNotifierProvider<TimetableProvider>.value(
                              value: provider,
                              child: const SettingsPage(),
                            ),
                      ),
                    );
                  },
                  child: const Text('Open settings host'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpRouteTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('theme settings entry ignores rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider(_buildStudentData());
    await _pumpSettingsPage(tester, provider);

    final themeTile = find.text('Theme');
    expect(themeTile, findsOneWidget);

    await tester.tap(themeTile);
    await tester.tap(themeTile, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(ThemeSettingsPage, skipOffstage: false), findsOneWidget);
  });

  testWidgets('student import/export actions ignore rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider(_buildStudentData());
    await _pumpSettingsPage(tester, provider);

    final importExportTile = find.text('Import and export data');
    expect(importExportTile, findsOneWidget);

    await tester.tap(importExportTile);
    await tester.tap(importExportTile, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Import timetable'), findsOneWidget);
  });

  testWidgets('student data sheet action ignores rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider(_buildStudentData());
    await _pumpSettingsHostPage(tester, provider);

    await tester.tap(find.text('Open settings host'));
    await _pumpRouteTransition(tester);

    final importExportTile = find.text('Import and export data');
    expect(importExportTile, findsOneWidget);

    await tester.tap(importExportTile);
    await tester.pumpAndSettle();

    final importTextAction = find.text('Import timetable from text');
    expect(importTextAction, findsOneWidget);

    await tester.tap(importTextAction);
    await tester.tap(importTextAction, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(TextImportPage), findsOneWidget);
    expect(find.byType(TextImportPage, skipOffstage: false), findsOneWidget);
    expect(find.text('Open settings host'), findsNothing);
    expect(
      find.text('Open settings host', skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('general import/export actions ignore rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider(_buildGeneralData());
    await _pumpSettingsPage(tester, provider);

    final importExportTile = find.text('Schedule import & export');
    expect(importExportTile, findsOneWidget);

    await tester.tap(importExportTile);
    await tester.tap(importExportTile, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Import JSON file'), findsOneWidget);
  });

  testWidgets('general data sheet action ignores rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider(_buildGeneralData());
    await _pumpSettingsHostPage(tester, provider);

    await tester.tap(find.text('Open settings host'));
    await _pumpRouteTransition(tester);

    final importExportTile = find.text('Schedule import & export');
    expect(importExportTile, findsOneWidget);

    await tester.tap(importExportTile);
    await tester.pumpAndSettle();

    final pasteJsonAction = find.text('Paste JSON');
    expect(pasteJsonAction, findsOneWidget);

    await tester.tap(pasteJsonAction);
    await tester.tap(pasteJsonAction, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(TextImportPage), findsOneWidget);
    expect(find.byType(TextImportPage, skipOffstage: false), findsOneWidget);
    expect(find.text('Open settings host'), findsNothing);
    expect(
      find.text('Open settings host', skipOffstage: false),
      findsOneWidget,
    );
  });
}
