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
import 'package:sked/screens/timetable_import_flow.dart';

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
  Future<String?> filePath() async => 'memory://timetable-import-flow-test';
}

Future<TimetableProvider> _createProvider() async {
  final periodTimes = buildDefaultPeriodTimes();
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(
      buildInitialAppData(periodTimes, localeCode: defaultLocaleCode).copyWith(
        activeMode: AppMode.student,
        studentMode: StudentModeData(
          activeTimetableId: 'table-1',
          timetables: [
            TimetableData(
              id: 'table-1',
              config: TimetableConfig(
                name: 'Flow test',
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
        ),
      ),
    ),
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

Future<void> _pumpImportButton(
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
                  onPressed: () =>
                      TimetableImportFlow.importTimetables(context, provider),
                  child: const Text('Import'),
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

void main() {
  testWidgets('file import ignores concurrent duplicate calls', (tester) async {
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
      if (!pickerResult.isCompleted) {
        pickerResult.complete(null);
      }
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    await _pumpImportButton(tester, provider);

    final importButton = find.widgetWithText(FilledButton, 'Import');
    expect(importButton, findsOneWidget);

    await tester.tap(importButton);
    await tester.tap(importButton, warnIfMissed: false);
    await pickerStarted.future;
    await tester.pumpAndSettle();

    expect(pickCalls, 1);

    pickerResult.complete(null);
    await tester.pumpAndSettle();
  });
}
