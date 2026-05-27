import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/widgets/period_time_set_picker_dialog.dart';

class _MemoryTimetableStorage implements TimetableStorage {
  _MemoryTimetableStorage(this.data);

  AppData? data;
  Completer<void>? saveGate;

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    if (saveGate != null) {
      await saveGate!.future;
    }
    this.data = data;
  }

  @override
  Future<String?> filePath() async => 'memory://period-picker-test';
}

Future<TimetableProvider> _createProvider({
  _MemoryTimetableStorage? storage,
}) async {
  final provider = TimetableProvider(
    storage:
        storage ??
        _MemoryTimetableStorage(buildInitialAppData(buildDefaultPeriodTimes())),
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

void main() {
  testWidgets('cancel button cannot pop twice when tapped rapidly', (
    tester,
  ) async {
    final provider = await _createProvider();
    final results = <String?>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  final result = await showPeriodTimeSetPickerDialog(
                    context,
                    provider: provider,
                    selectedPeriodTimeSetId: '',
                  );
                  results.add(result);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final cancelText = AppLocalizations.of(
      tester.element(find.byType(AlertDialog)),
    ).cancel;
    final cancelFinder = find.widgetWithText(TextButton, cancelText);
    expect(cancelFinder, findsOneWidget);

    await tester.tap(cancelFinder);
    await tester.tap(cancelFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(results, [isNull]);
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      find.text('Open'),
      findsOneWidget,
      reason:
          'Underlying screen must still be present after double-tap on cancel.',
    );
  });

  testWidgets('item.onTap cannot pop twice when tapped rapidly', (
    tester,
  ) async {
    final provider = await _createProvider();
    final initialId = provider.periodTimeSets.first.id;
    final results = <String?>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  final result = await showPeriodTimeSetPickerDialog(
                    context,
                    provider: provider,
                    selectedPeriodTimeSetId: '',
                  );
                  results.add(result);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final tileFinder = find.byType(ListTile).first;
    await tester.tap(tileFinder);
    await tester.tap(tileFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(results, [initialId]);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });

  testWidgets('barrier does not dismiss while creating period set', (
    tester,
  ) async {
    final saveGate = Completer<void>();
    final storage = _MemoryTimetableStorage(
      buildInitialAppData(buildDefaultPeriodTimes()),
    )..saveGate = saveGate;
    final provider = await _createProvider(storage: storage);
    final results = <String?>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  final result = await showPeriodTimeSetPickerDialog(
                    context,
                    provider: provider,
                    selectedPeriodTimeSetId: '',
                  );
                  results.add(result);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final newText = AppLocalizations.of(
      tester.element(find.byType(AlertDialog)),
    ).newItem;
    await tester.tap(find.widgetWithText(TextButton, newText));
    await tester.pump();

    await tester.tapAt(const Offset(4, 4));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(results, isEmpty);

    saveGate.complete();
    await tester.pumpAndSettle();
  });
}
