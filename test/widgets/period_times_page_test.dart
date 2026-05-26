import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/period_times_page.dart';

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
  Future<String?> filePath() async => 'memory://period-times-page-test';
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

Future<void> _pumpPeriodTimesPage(
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
        home: PeriodTimesPage(periodTimeSetId: defaultPeriodTimeSetId),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('time picker ignores rapid duplicate taps', (tester) async {
    final provider = await _createProvider();
    await _pumpPeriodTimesPage(tester, provider);

    final startTimeLabel = find.text('Start time').first;
    final startTimeCell = find
        .ancestor(of: startTimeLabel, matching: find.byType(InkWell))
        .first;
    await tester.tap(startTimeCell);
    await tester.tap(startTimeCell, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(TimePickerDialog), findsOneWidget);

    final l10n = AppLocalizations.of(
      tester.element(find.byType(TimePickerDialog)),
    );
    await tester.tap(
      find.descendant(
        of: find.byType(TimePickerDialog),
        matching: find.widgetWithText(TextButton, l10n.cancel),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TimePickerDialog), findsNothing);
    expect(find.byType(PeriodTimesPage), findsOneWidget);
  });

  testWidgets('file import ignores rapid duplicate menu actions', (
    tester,
  ) async {
    final provider = await _createProvider();
    const channel = MethodChannel(
      'miguelruivo.flutter.plugins.filepicker',
      StandardMethodCodec(),
    );
    final pickerStarted = Completer<void>();
    final pickerResult = Completer<Object?>();
    var pickCalls = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'custom') {
            pickCalls += 1;
            if (!pickerStarted.isCompleted) {
              pickerStarted.complete();
            }
            return pickerResult.future;
          }
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    await _pumpPeriodTimesPage(tester, provider);

    final menuButton = find.byTooltip('Import and export');
    expect(menuButton, findsOneWidget);

    await tester.tap(menuButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import period template'));
    await pickerStarted.future;
    await tester.pumpAndSettle();

    expect(pickCalls, 1);

    await tester.tap(menuButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Import period template'), findsNothing);
    expect(pickCalls, 1);

    pickerResult.complete(null);
    await tester.pumpAndSettle();

    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    expect(find.text('Import period template'), findsOneWidget);
  });
}
