import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/general_schedule_home_screen.dart';
import 'package:sked/screens/settings_page.dart';
import 'package:sked/widgets/general_event_editor_sheet.dart';

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
  Future<String?> filePath() async => 'memory://general-home-test';
}

class _BlockingTimetableStorage implements TimetableStorage {
  _BlockingTimetableStorage(this.data);

  AppData? data;
  int saveCount = 0;
  final Completer<void> firstSaveStarted = Completer<void>();
  final Completer<void> _allowFirstSave = Completer<void>();

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    saveCount += 1;
    this.data = data;
    if (saveCount == 1) {
      firstSaveStarted.complete();
      await _allowFirstSave.future;
    }
  }

  @override
  Future<String?> filePath() async => 'memory://general-home-blocking-test';

  void completeFirstSave() {
    if (!_allowFirstSave.isCompleted) {
      _allowFirstSave.complete();
    }
  }
}

Future<TimetableProvider> _createProvider() async {
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

Future<TimetableProvider> _createProviderWithStorage(
  TimetableStorage storage,
) async {
  final provider = TimetableProvider(
    storage: storage,
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

Future<void> _pumpGeneralScheduleHomeScreen(
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
        home: GeneralScheduleHomeScreen(),
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
  testWidgets('add event entry ignores rapid duplicate taps', (tester) async {
    final provider = await _createProvider();
    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.tap(fab, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(GeneralEventEditorSheet), findsOneWidget);
    expect(find.text('Add event'), findsWidgets);
  });

  testWidgets('settings entry ignores rapid duplicate taps', (tester) async {
    final provider = await _createProvider();
    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final settingsButton = find.byTooltip('Settings');
    expect(settingsButton, findsOneWidget);

    await tester.tap(settingsButton);
    await tester.tap(settingsButton, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(SettingsPage, skipOffstage: false), findsOneWidget);
  });

  testWidgets('calendar manager add ignores rapid duplicate taps', (
    tester,
  ) async {
    final initialData = buildInitialAppData(
      buildDefaultPeriodTimes(),
      localeCode: defaultLocaleCode,
    );
    final storage = _BlockingTimetableStorage(initialData);
    final provider = await _createProviderWithStorage(storage);
    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final calendarsButton = find.byTooltip('Calendars');
    expect(calendarsButton, findsOneWidget);

    await tester.tap(calendarsButton);
    await tester.pumpAndSettle();

    final addCalendarButton = find.byTooltip('Add calendar');
    expect(addCalendarButton, findsOneWidget);

    await tester.tap(addCalendarButton);
    await tester.tap(addCalendarButton, warnIfMissed: false);
    await storage.firstSaveStarted.future;

    expect(storage.saveCount, 1);
    expect(provider.generalSchedules, hasLength(2));

    storage.completeFirstSave();
    await tester.pumpAndSettle();

    expect(storage.saveCount, 1);
    expect(provider.generalSchedules, hasLength(2));
  });
}
