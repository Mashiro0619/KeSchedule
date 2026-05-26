import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/school_import_models.dart';
import 'package:sked/services/school_import_api.dart';
import 'package:sked/widgets/school_import_stream_dialog.dart';

SchoolImportResponse _buildResponse() {
  return SchoolImportResponse(
    meta: const SchoolImportMeta(
      sourceUrl: '',
      pageTitle: '',
      parser: 'test',
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

void main() {
  testWidgets('done confirm cannot pop the parent route on rapid tap', (
    tester,
  ) async {
    final controller = StreamController<SchoolImportStreamEvent>();
    final response = _buildResponse();
    final results = <SchoolImportResponse?>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                unawaited(
                  showDialog<SchoolImportResponse>(
                    context: context,
                    builder: (_) =>
                        SchoolImportStreamDialog(stream: controller.stream),
                  ).then(results.add),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    controller.add(ParseDone(response: response));
    await tester.pump();

    final confirmButton = find.byType(FilledButton);
    expect(confirmButton, findsOneWidget);
    expect(tester.widget<FilledButton>(confirmButton).onPressed, isNotNull);

    await tester.tap(confirmButton);
    await tester.tap(confirmButton, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(results, [same(response)]);
    expect(find.text('Open'), findsOneWidget);

    unawaited(controller.close());
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
