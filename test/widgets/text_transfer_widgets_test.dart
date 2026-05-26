import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/widgets/text_transfer_widgets.dart';

void main() {
  testWidgets('TextImportPage ignores rapid duplicate submit calls', (
    tester,
  ) async {
    final submitCompleter = Completer<bool>();
    var submitCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TextImportPage(
          title: 'Import text',
          initialContent: '{"ok":true}',
          onSubmit: (_, _) {
            submitCount += 1;
            return submitCompleter.future;
          },
        ),
      ),
    );

    final importButton = find.widgetWithText(FilledButton, 'Import');
    expect(importButton, findsOneWidget);

    await tester.tap(importButton);
    await tester.tap(importButton, warnIfMissed: false);

    expect(submitCount, 1);

    submitCompleter.complete(false);
    await tester.pumpAndSettle();

    expect(submitCount, 1);
    expect(tester.widget<FilledButton>(importButton).onPressed, isNotNull);
  });
}
