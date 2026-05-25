import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/school_import_models.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/widgets/school_web_import_result_sheet.dart';

class _MemoryTimetableStorage implements TimetableStorage {
  _MemoryTimetableStorage(this.data);

  AppData? data;

  @override
  Future<StorageLoadResult> load() async => StorageLoadResult(
    data: data,
    recoveryStatus: RecoveryStatus.none,
  );

  @override
  Future<void> save(AppData data) async {
    this.data = data;
  }

  @override
  Future<String?> filePath() async => 'memory://sheet-test';
}

SchoolImportResponse _buildResponse() {
  return SchoolImportResponse(
    meta: const SchoolImportMeta(
      sourceUrl: '',
      pageTitle: '',
      parser: '',
      warnings: [],
    ),
    timetable: SchoolImportTimetableDraft(
      name: 'Sample',
      startDate: DateTime(2026, 5, 25),
      totalWeeks: 18,
      periodTimeSet: const ImportedPeriodTimeSetDraft(
        name: '',
        periodTimes: [],
      ),
      courses: const [],
    ),
  );
}

Future<TimetableProvider> _createProvider() async {
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(
      buildInitialAppData(buildDefaultPeriodTimes()),
    ),
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

void main() {
  testWidgets('double-tap on import only emits a single apply request', (
    tester,
  ) async {
    final provider = await _createProvider();
    final periodTimeSets = provider.periodTimeSets;
    expect(periodTimeSets, isNotEmpty);
    final initialPeriodTimeSetId = periodTimeSets.first.id;
    final response = _buildResponse();

    final results = <SchoolImportApplyRequest?>[];
    late String importLabel;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            importLabel = AppLocalizations.of(
              context,
            ).importAsNewTimetable;
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    final outcome =
                        await showModalBottomSheet<SchoolImportApplyRequest>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => SchoolWebImportResultSheet(
                        response: response,
                        canReplaceCurrent: false,
                        periodTimeSets: periodTimeSets,
                        initialPeriodTimeSetId: initialPeriodTimeSetId,
                        provider: provider,
                      ),
                    );
                    results.add(outcome);
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final importButton = find.widgetWithText(OutlinedButton, importLabel);
    expect(importButton, findsOneWidget);
    expect(
      (tester.widget(importButton) as OutlinedButton).onPressed,
      isNotNull,
    );

    await tester.tap(importButton);
    await tester.pump();

    expect(
      (tester.widget(importButton) as OutlinedButton).onPressed,
      isNull,
      reason: 'After first tap, import button must be disabled to block re-entry.',
    );

    await tester.pumpAndSettle();

    expect(results, hasLength(1));
    expect(results.single, isNotNull);
    expect(results.single!.mode, TimetableImportMode.addAsNew);
  });

  testWidgets('cancel button cannot trigger a second pop', (tester) async {
    final provider = await _createProvider();
    final periodTimeSets = provider.periodTimeSets;
    final initialPeriodTimeSetId =
        periodTimeSets.isEmpty ? '' : periodTimeSets.first.id;
    final response = _buildResponse();

    final results = <SchoolImportApplyRequest?>[];
    late String cancelLabel;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            cancelLabel = AppLocalizations.of(context).cancel;
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    final outcome =
                        await showModalBottomSheet<SchoolImportApplyRequest>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => SchoolWebImportResultSheet(
                        response: response,
                        canReplaceCurrent: false,
                        periodTimeSets: periodTimeSets,
                        initialPeriodTimeSetId: initialPeriodTimeSetId,
                        provider: provider,
                      ),
                    );
                    results.add(outcome);
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final cancelButton = find.widgetWithText(TextButton, cancelLabel);
    expect(cancelButton, findsOneWidget);

    await tester.tap(cancelButton);
    await tester.pump();

    expect(
      (tester.widget(cancelButton) as TextButton).onPressed,
      isNull,
      reason: 'Cancel button must be disabled after first tap to block re-entry.',
    );

    await tester.pumpAndSettle();
    expect(results, [isNull]);
  });
}
