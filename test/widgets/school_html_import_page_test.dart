import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/screens/school_html_import_page.dart';

Future<AppLocalizations> _pumpAndCaptureL10n(WidgetTester tester) async {
  AppLocalizations? captured;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          captured = AppLocalizations.of(context);
          return const SizedBox();
        },
      ),
    ),
  );
  await tester.pump();
  return captured!;
}

void main() {
  testWidgets('mapSchoolImportApplyError returns FormatException message', (
    tester,
  ) async {
    final l10n = await _pumpAndCaptureL10n(tester);

    expect(
      mapSchoolImportApplyError(const FormatException('bad payload'), l10n),
      'bad payload',
    );
  });

  testWidgets('mapSchoolImportApplyError falls back to localized message for '
      'non-FormatException errors', (tester) async {
    final l10n = await _pumpAndCaptureL10n(tester);

    expect(
      mapSchoolImportApplyError(Exception('boom'), l10n),
      l10n.importFailedCheckContent,
    );
    expect(
      mapSchoolImportApplyError(StateError('bad state'), l10n),
      l10n.importFailedCheckContent,
    );
  });
}
