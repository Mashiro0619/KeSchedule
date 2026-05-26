import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/language_settings_page.dart';

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
  Future<String?> filePath() async => 'memory://language-settings-test';

  void completeFirstSave() {
    if (!_allowFirstSave.isCompleted) {
      _allowFirstSave.complete();
    }
  }
}

Future<TimetableProvider> _createProvider(
  _BlockingTimetableStorage storage,
) async {
  final provider = TimetableProvider(
    storage: storage,
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

Future<void> _pumpHostPage(
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
                        builder: (_) => const LanguageSettingsPage(),
                      ),
                    );
                  },
                  child: const Text('Open language settings'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Future<void> _pumpRouteTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('language selection ignores rapid duplicate taps', (
    tester,
  ) async {
    final storage = _BlockingTimetableStorage(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ),
    );
    final provider = await _createProvider(storage);
    await _pumpHostPage(tester, provider);

    await tester.tap(find.text('Open language settings'));
    await _pumpRouteTransition(tester);

    final germanOption = find.text('Deutsch').last;
    await tester.ensureVisible(germanOption);
    await tester.pumpAndSettle();

    await tester.tap(germanOption);
    await storage.firstSaveStarted.future;

    final japaneseOption = find.text('日本語').last;
    await tester.ensureVisible(japaneseOption);
    await tester.tap(japaneseOption, warnIfMissed: false);
    await tester.pump();

    expect(storage.saveCount, 1);

    storage.completeFirstSave();
    await tester.pumpAndSettle();

    expect(storage.saveCount, 1);
    expect(provider.localeCode, 'de');
    expect(find.text('Open language settings'), findsOneWidget);
    expect(find.byType(LanguageSettingsPage), findsNothing);
  });
}
