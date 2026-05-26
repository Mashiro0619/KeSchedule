import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/home_screen.dart';
import 'package:sked/screens/school_sites_page.dart';
import 'package:sked/screens/settings_page.dart';
import 'package:sked/services/privacy_service.dart';
import 'package:sked/widgets/course_editor_sheet.dart';
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
  Future<String?> filePath() async => 'memory://home-timetable-test';
}

class _BlockingTimetableStorage implements TimetableStorage {
  _BlockingTimetableStorage(this.data);

  AppData? data;
  int saveCount = 0;

  final Completer<void> _firstSaveStarted = Completer<void>();
  final Completer<void> _releaseSave = Completer<void>();

  Future<void> get firstSaveStarted => _firstSaveStarted.future;

  void completeSave() {
    if (!_releaseSave.isCompleted) {
      _releaseSave.complete();
    }
  }

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    saveCount += 1;
    this.data = data;
    if (!_firstSaveStarted.isCompleted) {
      _firstSaveStarted.complete();
    }
    await _releaseSave.future;
  }

  @override
  Future<String?> filePath() async => 'memory://blocking-home-timetable-test';
}

class _NoopPrivacyService extends PrivacyService {
  const _NoopPrivacyService();

  @override
  Future<String?> fetchCurrentPrivacyPolicyVersion() async => null;
}

AppData _buildPopulatedStudentData() {
  final periodTimes = buildDefaultPeriodTimes();
  final timetable = TimetableData(
    id: 'table-1',
    config: TimetableConfig(
      name: 'Test timetable',
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

AppData _buildMultiTimetableStudentData() {
  final periodTimes = buildDefaultPeriodTimes();
  final firstTimetable = TimetableData(
    id: 'table-1',
    config: TimetableConfig(
      name: 'First timetable',
      startDate: DateTime(2026, 5, 25),
      totalWeeks: 18,
      periodTimeSetId: defaultPeriodTimeSetId,
    ),
    courses: const [],
  );
  final secondTimetable = TimetableData(
    id: 'table-2',
    config: TimetableConfig(
      name: 'Second timetable',
      startDate: DateTime(2026, 6),
      totalWeeks: 16,
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
      activeTimetableId: firstTimetable.id,
      timetables: [firstTimetable, secondTimetable],
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

Future<TimetableProvider> _createProvider() async {
  final data = _buildPopulatedStudentData();
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(data),
    systemLocaleCodeResolver: () => defaultLocaleCode,
    privacyService: const _NoopPrivacyService(),
  );
  await provider.load();
  return provider;
}

Future<TimetableProvider> _createEmptyProvider(
  _BlockingTimetableStorage storage,
) async {
  final data = buildInitialAppData(
    buildDefaultPeriodTimes(),
    localeCode: defaultLocaleCode,
  ).copyWith(activeMode: AppMode.student);
  storage.data = data;
  final provider = TimetableProvider(
    storage: storage,
    systemLocaleCodeResolver: () => defaultLocaleCode,
    privacyService: const _NoopPrivacyService(),
  );
  await provider.load();
  return provider;
}

Future<void> _pumpHomeScreenWithProvider(
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
        home: HomeScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpHomeScreenHostPage(
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ChangeNotifierProvider<TimetableProvider>.value(
                              value: provider,
                              child: const HomeScreen(),
                            ),
                      ),
                    );
                  },
                  child: const Text('Open home host'),
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

Future<TimetableProvider> _pumpHomeScreen(WidgetTester tester) async {
  final provider = await _createProvider();
  await _pumpHomeScreenWithProvider(tester, provider);
  return provider;
}

Future<void> _pumpRouteTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('privacy consent waits for save before closing', (tester) async {
    final storage = _BlockingTimetableStorage(
      _buildPopulatedStudentData().copyWith(
        privacyPolicyAcceptedVersion: null,
        privacyPolicyAcceptedAtIso: null,
      ),
    );
    final provider = TimetableProvider(
      storage: storage,
      systemLocaleCodeResolver: () => defaultLocaleCode,
      privacyService: const _NoopPrivacyService(),
    );
    await provider.load();
    provider.injectRemotePrivacyPolicyVersion('2026-05-25');

    await _pumpHomeScreenWithProvider(tester, provider);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.text('Please agree to the privacy policy before using the app'),
      findsOneWidget,
    );

    final agreeButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(FilledButton),
    );
    expect(agreeButton, findsOneWidget);

    await tester.tap(agreeButton);
    await storage.firstSaveStarted;
    await tester.pump();

    expect(storage.saveCount, 1);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.widget<FilledButton>(agreeButton).onPressed, isNull);

    await tester.tap(agreeButton, warnIfMissed: false);
    await tester.pump();

    expect(storage.saveCount, 1);
    expect(find.byType(AlertDialog), findsOneWidget);

    storage.completeSave();
    await tester.pumpAndSettle();

    expect(storage.saveCount, 1);
    expect(provider.hasAcceptedCurrentPrivacyPolicy, isTrue);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('start date picker ignores rapid duplicate taps', (tester) async {
    await _pumpHomeScreen(tester);

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit timetable'));
    await tester.pumpAndSettle();

    final startDateTile = find.widgetWithText(ListTile, 'Semester start date');
    expect(startDateTile, findsOneWidget);

    await tester.tap(startDateTile);
    await tester.tap(startDateTile, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.widgetWithText(TextButton, 'Cancel'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsNothing);
    expect(find.text('Test timetable'), findsWidgets);
  });

  testWidgets('add course entry ignores rapid duplicate taps', (tester) async {
    await _pumpHomeScreen(tester);

    final addCourseButton = find.byTooltip('Add course');
    expect(addCourseButton, findsOneWidget);

    await tester.tap(addCourseButton);
    await tester.tap(addCourseButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(CourseEditorSheet), findsOneWidget);
    expect(find.text('Add course'), findsWidgets);
  });

  testWidgets('week picker ignores rapid duplicate title taps', (tester) async {
    await _pumpHomeScreen(tester);

    final weekTitle = find.text('Week 1');
    expect(weekTitle, findsOneWidget);

    await tester.tap(weekTitle);
    await tester.tap(weekTitle, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Jump to week'), findsOneWidget);
  });

  testWidgets('empty state new timetable ignores rapid duplicate taps', (
    tester,
  ) async {
    final storage = _BlockingTimetableStorage(null);
    final provider = await _createEmptyProvider(storage);

    await _pumpHomeScreenWithProvider(tester, provider);

    expect(provider.timetables, isEmpty);
    expect(find.text('No timetable yet'), findsOneWidget);

    final createButton = find.widgetWithText(FilledButton, 'New timetable');
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);
    await tester.tap(createButton, warnIfMissed: false);
    await storage.firstSaveStarted;

    expect(storage.saveCount, 1);
    expect(provider.timetables, hasLength(1));

    storage.completeSave();
    await tester.pumpAndSettle();

    expect(storage.saveCount, 1);
    expect(provider.timetables, hasLength(1));
    expect(find.text('Week 1'), findsOneWidget);
  });

  testWidgets('drawer new timetable ignores rapid duplicate taps', (
    tester,
  ) async {
    final storage = _BlockingTimetableStorage(_buildPopulatedStudentData());
    final provider = TimetableProvider(
      storage: storage,
      systemLocaleCodeResolver: () => defaultLocaleCode,
      privacyService: const _NoopPrivacyService(),
    );
    await provider.load();

    await _pumpHomeScreenWithProvider(tester, provider);

    expect(provider.timetables, hasLength(1));

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    final createButton = find.widgetWithText(FilledButton, 'New timetable');
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);
    await tester.tap(createButton, warnIfMissed: false);
    await storage.firstSaveStarted;

    expect(storage.saveCount, 1);
    expect(provider.timetables, hasLength(2));

    storage.completeSave();
    await tester.pumpAndSettle();

    expect(storage.saveCount, 1);
    expect(provider.timetables, hasLength(2));
  });

  testWidgets('drawer timetable switch ignores rapid duplicate taps', (
    tester,
  ) async {
    final storage = _BlockingTimetableStorage(
      _buildMultiTimetableStudentData(),
    );
    final provider = TimetableProvider(
      storage: storage,
      systemLocaleCodeResolver: () => defaultLocaleCode,
      privacyService: const _NoopPrivacyService(),
    );
    await provider.load();

    await _pumpHomeScreenWithProvider(tester, provider);

    expect(provider.activeTimetable.config.name, 'First timetable');

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    final secondTimetable = find.text('Second timetable');
    expect(secondTimetable, findsOneWidget);

    await tester.tap(secondTimetable);
    await storage.firstSaveStarted;
    await tester.tap(secondTimetable, warnIfMissed: false);

    expect(storage.saveCount, 1);
    expect(provider.activeTimetable.config.name, 'Second timetable');

    storage.completeSave();
    await tester.pumpAndSettle();

    expect(storage.saveCount, 1);
    expect(provider.activeTimetable.config.name, 'Second timetable');
    expect(find.text('Second timetable'), findsOneWidget);
  });

  testWidgets('drawer current timetable tap cannot pop parent route', (
    tester,
  ) async {
    final provider = await _createProvider();
    await _pumpHomeScreenHostPage(tester, provider);

    await tester.tap(find.text('Open home host'));
    await _pumpRouteTransition(tester);

    expect(find.text('Week 1'), findsOneWidget);

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    final currentTimetable = find.text('Test timetable').last;
    expect(currentTimetable, findsOneWidget);

    await tester.tap(currentTimetable);
    await tester.tap(currentTimetable, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Week 1'), findsOneWidget);
    expect(find.text('Open home host'), findsNothing);
    expect(find.text('Open home host', skipOffstage: false), findsOneWidget);
  });

  testWidgets('settings entry ignores rapid duplicate taps', (tester) async {
    await _pumpHomeScreen(tester);

    final settingsButton = find.byTooltip('Settings');
    expect(settingsButton, findsOneWidget);

    await tester.tap(settingsButton);
    await tester.tap(settingsButton, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(SettingsPage, skipOffstage: false), findsOneWidget);
  });

  testWidgets('text import entry ignores rapid duplicate taps', (tester) async {
    final storage = _BlockingTimetableStorage(null);
    final provider = await _createEmptyProvider(storage);

    await _pumpHomeScreenWithProvider(tester, provider);

    final textImportButton = find.widgetWithText(
      OutlinedButton,
      'Import timetable from text',
    );
    expect(textImportButton, findsOneWidget);

    await tester.tap(textImportButton);
    await tester.tap(textImportButton, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(TextImportPage, skipOffstage: false), findsOneWidget);
  });

  testWidgets('school web import entry ignores rapid duplicate taps', (
    tester,
  ) async {
    final storage = _BlockingTimetableStorage(null);
    final provider = await _createEmptyProvider(storage);

    await _pumpHomeScreenWithProvider(tester, provider);

    final webImportButton = find.widgetWithText(
      OutlinedButton,
      'Import from school webpage',
    );
    expect(webImportButton, findsOneWidget);

    await tester.tap(webImportButton);
    await tester.tap(webImportButton, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(find.byType(SchoolSitesPage, skipOffstage: false), findsOneWidget);
  });
}
