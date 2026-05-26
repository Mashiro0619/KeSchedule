import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/widgets/course_editor_sheet.dart';

Widget _localizedApp(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('secondary picker ignores rapid duplicate taps', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        CourseEditorSheet(
          periodTimes: buildDefaultPeriodTimes().take(4).toList(),
          totalWeeks: 18,
          dayOfWeek: 1,
        ),
      ),
    );
    await tester.pump();

    final dayPicker = find.widgetWithText(ListTile, 'Day');
    expect(dayPicker, findsOneWidget);

    await tester.tap(dayPicker);
    await tester.tap(dayPicker, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Choose day'), findsOneWidget);

    await tester.tap(find.byType(ChoiceChip).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
