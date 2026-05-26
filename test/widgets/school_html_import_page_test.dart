import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/school_html_import_page.dart';
import 'package:sked/screens/school_import_parser_settings_page.dart';
import 'package:sked/services/privacy_service.dart';

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
  Future<String?> filePath() async => 'memory://school-html-import-test';
}

class _NoopPrivacyService extends PrivacyService {
  const _NoopPrivacyService();

  @override
  Future<String?> fetchCurrentPrivacyPolicyVersion() async => null;
}

AppData _buildConfiguredCustomParserData() {
  final baseData = buildInitialAppData(
    buildDefaultPeriodTimes(),
    localeCode: defaultLocaleCode,
  );
  return baseData.copyWith(
    activeMode: AppMode.student,
    studentMode: baseData.studentMode.copyWith(
      schoolImportParserSettings: const SchoolImportParserSettings(
        source: schoolImportParserSourceCustomOpenAi,
        customBaseUrl: 'https://api.example.com/v1',
        customApiKey: 'sk-test',
        customModel: 'gpt-4.1-mini',
      ),
    ),
  );
}

Future<TimetableProvider> _createProvider() async {
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(_buildConfiguredCustomParserData()),
    systemLocaleCodeResolver: () => defaultLocaleCode,
    privacyService: const _NoopPrivacyService(),
  );
  await provider.load();
  return provider;
}

Future<AppLocalizations> _pumpAndCaptureL10n(WidgetTester tester) async {
  AppLocalizations? captured;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          captured = AppLocalizations.of(context);
          return const SizedBox();
        },
      ),
    ),
  );
  await tester.pump();
  return captured!;
}

Future<void> _pumpSchoolHtmlImportPage(
  WidgetTester tester,
  TimetableProvider provider,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SchoolHtmlImportPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpSchoolHtmlImportPageHost(
  WidgetTester tester,
  TimetableProvider provider,
) async {
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SchoolHtmlImportPage(
                        showReturnToWebPageButton: true,
                      ),
                    ),
                  ),
                  child: const Text('Open import page'),
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
  testWidgets('mapSchoolImportApplyError returns FormatException message', (
    tester,
  ) async {
    final l10n = await _pumpAndCaptureL10n(tester);

    expect(
      mapSchoolImportApplyError(const FormatException('bad payload'), l10n),
      'bad payload',
    );
  });

  testWidgets('mapSchoolImportApplyError falls back to localized message for '
      'non-FormatException errors', (tester) async {
    final l10n = await _pumpAndCaptureL10n(tester);

    expect(
      mapSchoolImportApplyError(Exception('boom'), l10n),
      l10n.importFailedCheckContent,
    );
    expect(
      mapSchoolImportApplyError(StateError('bad state'), l10n),
      l10n.importFailedCheckContent,
    );
  });

  testWidgets('parser settings entry ignores rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider();
    await _pumpSchoolHtmlImportPage(tester, provider);

    final parserSettingsTile = find.text('Timetable parser settings');
    expect(parserSettingsTile, findsOneWidget);

    await tester.tap(parserSettingsTile);
    await tester.tap(parserSettingsTile, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(
      find.byType(SchoolImportParserSettingsPage, skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('return to webpage button cannot pop the parent route twice', (
    tester,
  ) async {
    final provider = await _createProvider();
    await _pumpSchoolHtmlImportPageHost(tester, provider);

    final openButton = find.widgetWithText(FilledButton, 'Open import page');
    expect(openButton, findsOneWidget);

    await tester.tap(openButton);
    await _pumpRouteTransition(tester);

    final returnButton = find.widgetWithText(TextButton, 'Back to webpage');
    expect(returnButton, findsOneWidget);

    await tester.tap(returnButton);
    await tester.tap(returnButton, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(SchoolHtmlImportPage), findsNothing);
    expect(openButton, findsOneWidget);
  });
}
