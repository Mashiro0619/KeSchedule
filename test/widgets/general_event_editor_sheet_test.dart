import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/widgets/general_event_editor_sheet.dart';

Widget _localizedApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('builds with an empty calendar list', (tester) async {
    await tester.pumpWidget(
      _localizedApp(const GeneralEventEditorSheet(calendars: [])),
    );
    await tester.pump();

    expect(find.byType(GeneralEventEditorSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trims the initial event calendar id', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        GeneralEventEditorSheet(
          calendars: const [
            GeneralSchedule(id: 'work', name: 'Work', events: []),
            GeneralSchedule(id: 'home', name: 'Home', events: []),
          ],
          activeCalendarId: 'work',
          initialEvent: GeneralEvent(
            id: 'event',
            calendarId: ' home ',
            title: 'Dinner',
            startDateTimeIso: '2026-05-25T18:00:00.000',
            endDateTimeIso: '2026-05-25T19:00:00.000',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
  });
}
