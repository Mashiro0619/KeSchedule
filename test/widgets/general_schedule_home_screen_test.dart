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

Future<TimetableProvider> _createGeneralProvider(AppData data) async {
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(data),
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
  TimetableProvider provider, {
  ThemeData? theme,
}) async {
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
        locale: appLocaleFromCode(provider.localeCode),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: theme,
        home: const GeneralScheduleHomeScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpRouteTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

const _generalWeekPagerKey = ValueKey<String>('general-week-pager');
const _generalDayPagerKey = ValueKey<String>('general-day-pager');
const _generalDayWeekPickerPagerKey = ValueKey<String>(
  'general-day-week-picker-pager',
);
const _generalDayPickerSelectionIndicatorKey = ValueKey<String>(
  'general-day-picker-selection-indicator',
);

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

  testWidgets('week view swipes horizontally to change week', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewWeek,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    await tester.fling(
      find.byKey(_generalWeekPagerKey),
      const Offset(-700, 0),
      1000,
    );
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 23);
    expect(find.byType(GeneralEventEditorSheet), findsNothing);
  });

  testWidgets('week view keeps selected day visible when weekends are hidden', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-20',
          defaultView: generalViewWeek,
          showWeekends: false,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 22);
    expect(find.text('22'), findsWidgets);
    expect(find.text('20'), findsNothing);
    expect(find.text('21'), findsNothing);

    await tester.fling(
      find.byKey(_generalWeekPagerKey),
      const Offset(-700, 0),
      1000,
    );
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 29);
    expect(find.text('29'), findsWidgets);
    expect(find.text('27'), findsNothing);
    expect(find.text('28'), findsNothing);
  });

  testWidgets('day view normalizes hidden weekend selection to visible day', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-21',
          defaultView: generalViewDay,
          showWeekends: false,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 22);
    expect(find.text('22'), findsWidgets);
    expect(find.text('20'), findsNothing);
    expect(find.text('21'), findsNothing);
  });

  testWidgets('week and day views show month rail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-05-25',
          defaultView: generalViewWeek,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(find.text('5月'), findsWidgets);

    await tester.tap(find.text('Day'));
    await tester.pumpAndSettle();

    expect(find.text('5月'), findsWidgets);
  });

  testWidgets('week view month rail label is centered', (tester) async {
    await tester.binding.setSurfaceSize(const Size(496, 1052));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-07-20',
          defaultView: generalViewWeek,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final labelBox = tester.getRect(find.text('7月').first);
    expect(labelBox.center.dx, closeTo(26, 1));
  });

  testWidgets('general schedule home hides search and filter controls', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-05-25',
          defaultView: generalViewWeek,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(find.text('Search events'), findsNothing);
    expect(find.byTooltip('Filter by color'), findsNothing);
  });

  testWidgets('day view selects a day from the week strip', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewDay,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    await tester.tap(find.text('18').first);
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 18);
  });

  testWidgets('day view swipes the week strip to change week', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewDay,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    await tester.fling(
      find.byKey(_generalDayWeekPickerPagerKey),
      const Offset(-700, 0),
      1000,
    );
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 23);
  });

  testWidgets('day view swipes horizontally to change day', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewDay,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    await tester.fling(
      find.byKey(_generalDayPagerKey),
      const Offset(-700, 0),
      1000,
    );
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 17);
  });

  testWidgets('day view picker selection follows horizontal drag progress', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewDay,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final indicator = find.byKey(_generalDayPickerSelectionIndicatorKey);
    expect(indicator, findsOneWidget);
    final initialLeft = tester.getTopLeft(indicator).dx;

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_generalDayPagerKey)),
    );
    await gesture.moveBy(const Offset(-40, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-240, 0));
    await tester.pump(const Duration(milliseconds: 16));

    expect(tester.getTopLeft(indicator).dx, greaterThan(initialLeft));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('day view picker selection wraps during cross-week drag', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-21',
          defaultView: generalViewDay,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final indicator = find.byKey(_generalDayPickerSelectionIndicatorKey);
    expect(indicator, findsOneWidget);
    final initialLeft = tester.getTopLeft(indicator).dx;

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_generalDayPagerKey)),
    );
    await gesture.moveBy(const Offset(-40, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-520, 0));
    await tester.pump(const Duration(milliseconds: 16));

    expect(tester.getTopLeft(indicator).dx, lessThan(initialLeft));

    await gesture.up();
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 22);
  });

  testWidgets('day view skips weekends when weekends are hidden', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-19',
          defaultView: generalViewDay,
          showWeekends: false,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    await tester.fling(
      find.byKey(_generalDayPagerKey),
      const Offset(-700, 0),
      1000,
    );
    await tester.pumpAndSettle();

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 22);
    expect(find.text('22'), findsWidgets);
    expect(find.text('20'), findsNothing);
    expect(find.text('21'), findsNothing);
  });

  testWidgets('month view trims trailing calendar weeks', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-01-15',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(find.text('1'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('month view omits weekend cells when weekends are hidden', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-15',
          defaultView: generalViewMonth,
          showWeekends: false,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(find.text('6'), findsNothing);
    expect(find.text('7'), findsNothing);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
  });

  testWidgets('month view normalizes hidden weekend selection to visible day', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-21',
          defaultView: generalViewMonth,
          showWeekends: false,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(provider.selectedGeneralDate.year, 2026);
    expect(provider.selectedGeneralDate.month, 6);
    expect(provider.selectedGeneralDate.day, 22);
    expect(find.text('22'), findsWidgets);
    expect(find.text('21'), findsNothing);
  });

  testWidgets('month view keeps selected day agenda', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [
        GeneralEvent(
          id: 'evt1',
          calendarId: 'cal1',
          title: 'Dentist',
          startDateTimeIso: '2026-06-15T09:00:00.000',
          endDateTimeIso: '2026-06-15T10:00:00.000',
        ),
        GeneralEvent(
          id: 'evt2',
          calendarId: 'cal1',
          title: 'Review',
          startDateTimeIso: '2026-06-15T11:00:00.000',
          endDateTimeIso: '2026-06-15T12:00:00.000',
        ),
      ],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-15',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(find.text('Dentist'), findsWidgets);
    expect(find.text('Review'), findsWidgets);
  });

  testWidgets('month view does not show all-day exclusive end date', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [
        GeneralEvent(
          id: 'evt1',
          calendarId: 'cal1',
          title: 'Conference',
          startDateTimeIso: '2026-06-15T00:00:00.000',
          endDateTimeIso: '2026-06-16T00:00:00.000',
          isAllDay: true,
        ),
      ],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(find.text('Conference'), findsNothing);

    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    expect(find.text('Conference'), findsWidgets);
  });

  testWidgets('month view empty agenda add opens editor on selected date', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-15',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    final addButtons = find.byTooltip('Add event');
    expect(addButtons, findsWidgets);
    await tester.tap(addButtons.last);
    await tester.pumpAndSettle();

    expect(find.byType(GeneralEventEditorSheet), findsOneWidget);
  });

  testWidgets('month view fits narrow mobile height without overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(496, 1052));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(tester.takeException(), isNull);
    expect(find.text('June 2026'), findsWidgets);
    expect(find.text('No upcoming events'), findsWidgets);
  });

  testWidgets('month view fits wide short height without overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1125, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-07-15',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(tester.takeException(), isNull);
    expect(find.text('July 2026'), findsWidgets);
    expect(find.text('31'), findsOneWidget);
  });

  testWidgets('month view shows lunar labels on Android phone width', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(496, 1052));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(buildDefaultPeriodTimes(), localeCode: 'zh').copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(tester.takeException(), isNull);
    expect(find.text('芒种'), findsOneWidget);
    expect(find.text('端午节'), findsOneWidget);
    expect(find.text('夏至'), findsOneWidget);
  });

  testWidgets('month view lunar special labels follow theme colors', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(496, 1052));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const festivalColor = Color(0xFF2255CC);
    const solarTermColor = Color(0xFF8844CC);
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: festivalColor,
      ).copyWith(primary: festivalColor, tertiary: solarTermColor),
    );
    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(buildDefaultPeriodTimes(), localeCode: 'zh').copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider, theme: theme);

    final festival = tester.widget<Text>(find.text('端午节'));
    final solarTerm = tester.widget<Text>(find.text('芒种'));

    expect(festival.style?.color, festivalColor);
    expect(solarTerm.style?.color, solarTermColor);
  });

  testWidgets('month view shows lunar labels for traditional Chinese locale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(496, 1052));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final calendar = const GeneralSchedule(
      id: 'cal1',
      name: 'Calendar',
      events: [],
    );
    final provider = await _createGeneralProvider(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: 'zh-Hant',
      ).copyWith(
        activeMode: AppMode.general,
        generalMode: GeneralScheduleData(
          activeScheduleId: 'cal1',
          schedules: [calendar],
          selectedDateIso: '2026-06-16',
          defaultView: generalViewMonth,
        ),
      ),
    );

    await _pumpGeneralScheduleHomeScreen(tester, provider);

    expect(tester.takeException(), isNull);
    expect(find.text('芒种'), findsOneWidget);
    expect(find.text('端午节'), findsOneWidget);
    expect(find.text('夏至'), findsOneWidget);
  });
}
