import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/widgets/general_event_details_sheet.dart';

GeneralEventOccurrence _buildOccurrence() {
  final event = GeneralEvent(
    id: 'event-1',
    calendarId: 'calendar-1',
    title: 'Planning',
    startDateTimeIso: '2026-05-25T09:00:00.000',
    endDateTimeIso: '2026-05-25T10:00:00.000',
  );
  final calendar = GeneralSchedule(
    id: 'calendar-1',
    name: 'Work',
    events: [event],
  );
  return GeneralEventOccurrence(
    event: event,
    calendar: calendar,
    start: DateTime(2026, 5, 25, 9),
    end: DateTime(2026, 5, 25, 10),
    sequence: 0,
  );
}

void main() {
  testWidgets('action buttons ignore rapid duplicate taps', (tester) async {
    final actionCompleter = Completer<void>();
    var duplicateCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GeneralEventDetailsSheet(
            occurrence: _buildOccurrence(),
            onDuplicate: () {
              duplicateCount += 1;
              return actionCompleter.future;
            },
          ),
        ),
      ),
    );

    final duplicateButton = find.widgetWithText(FilledButton, 'Duplicate');
    expect(duplicateButton, findsOneWidget);

    await tester.tap(duplicateButton);
    await tester.tap(duplicateButton, warnIfMissed: false);

    expect(duplicateCount, 1);

    await tester.pump();
    expect(tester.widget<FilledButton>(duplicateButton).onPressed, isNull);

    actionCompleter.complete();
    await tester.pump();

    expect(duplicateCount, 1);
  });
}
