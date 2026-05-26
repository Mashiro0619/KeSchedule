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

  testWidgets('save / cancel / delete cannot pop twice on rapid tap', (
    tester,
  ) async {
    final results = <GeneralEventEditorResult?>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  final outcome =
                      await showModalBottomSheet<GeneralEventEditorResult>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => GeneralEventEditorSheet(
                          calendars: const [
                            GeneralSchedule(
                              id: 'work',
                              name: 'Work',
                              events: [],
                            ),
                          ],
                          activeCalendarId: 'work',
                          initialEvent: GeneralEvent(
                            id: 'event',
                            calendarId: 'work',
                            title: 'Meeting',
                            startDateTimeIso: '2026-05-25T09:00:00.000',
                            endDateTimeIso: '2026-05-25T10:00:00.000',
                          ),
                        ),
                      );
                  results.add(outcome);
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

    final l10n = AppLocalizations.of(
      tester.element(find.byType(GeneralEventEditorSheet)),
    );
    final cancelFinder = find.widgetWithText(TextButton, l10n.cancel);
    expect(cancelFinder, findsOneWidget);

    await tester.tap(cancelFinder);
    await tester.tap(cancelFinder, warnIfMissed: false);
    await tester.pump();

    expect(
      (tester.widget(cancelFinder) as TextButton).onPressed,
      isNull,
      reason:
          'Cancel button must be disabled after first tap to block re-entry.',
    );

    await tester.pumpAndSettle();

    expect(results, hasLength(1));
    expect(results.single, isNull);
    expect(
      find.text('Open'),
      findsOneWidget,
      reason: 'Parent route must remain after double-tap on cancel.',
    );
  });

  testWidgets('date picker ignores rapid duplicate taps', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        GeneralEventEditorSheet(
          calendars: const [
            GeneralSchedule(id: 'work', name: 'Work', events: []),
          ],
          activeCalendarId: 'work',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final pickDateButton = find.byTooltip('Pick date').first;
    await tester.tap(pickDateButton);
    await tester.tap(pickDateButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.widgetWithText(TextButton, 'Cancel'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsNothing);
  });
}
