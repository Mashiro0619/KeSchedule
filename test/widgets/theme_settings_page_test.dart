import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/theme_settings_page.dart';

class _BlockingTimetableStorage implements TimetableStorage {
  _BlockingTimetableStorage(this.data);

  AppData? data;
  Completer<void>? _blockedSave;
  var saveCount = 0;

  void blockNextSave() {
    _blockedSave = Completer<void>();
  }

  void completeSave() {
    final blockedSave = _blockedSave;
    _blockedSave = null;
    blockedSave?.complete();
  }

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    saveCount += 1;
    this.data = data;
    final blockedSave = _blockedSave;
    if (blockedSave != null) {
      await blockedSave.future;
    }
  }

  @override
  Future<String?> filePath() async => 'memory://theme-settings-test';
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

void main() {
  testWidgets('custom color apply is disabled while save is in progress', (
    tester,
  ) async {
    final storage = _BlockingTimetableStorage(
      buildInitialAppData(buildDefaultPeriodTimes()),
    );
    final provider = await _createProvider(storage);
    storage.blockNextSave();

    await tester.pumpWidget(
      ChangeNotifierProvider<TimetableProvider>.value(
        value: provider,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ThemeSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final customColor = find.text('Custom color').last;
    await tester.scrollUntilVisible(customColor, 200);
    await tester.pumpAndSettle();
    await tester.tap(customColor);
    await tester.pumpAndSettle();

    final applyButton = find.widgetWithText(FilledButton, 'Apply color');
    expect(applyButton, findsOneWidget);

    await tester.tap(applyButton);
    await tester.pump();

    expect(storage.saveCount, 1);
    expect(tester.widget<FilledButton>(applyButton).onPressed, isNull);

    await tester.tap(applyButton, warnIfMissed: false);
    await tester.pump();

    expect(storage.saveCount, 1);

    storage.completeSave();
    await tester.pumpAndSettle();

    expect(applyButton, findsNothing);
    expect(storage.saveCount, 1);
  });
}
