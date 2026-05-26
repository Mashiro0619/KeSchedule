import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/widgets/course_details_sheet.dart';

class _MemoryTimetableStorage implements TimetableStorage {
  _MemoryTimetableStorage(this.data);

  AppData? data;

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    this.data = data;
  }

  @override
  Future<String?> filePath() async => 'memory://course-details-test';
}

CourseItem _course({required String id, required String name}) {
  return CourseItem(
    id: id,
    name: name,
    teacher: '',
    location: 'Room 101',
    dayOfWeek: 1,
    semesterWeeks: const [1],
    periods: const [1, 2],
    startMinutes: 8 * 60,
    endMinutes: 9 * 60 + 40,
    timeRange: buildTimeRange(8 * 60, 9 * 60 + 40),
    credit: 0,
    remarks: '',
    customFields: const {},
  );
}

Future<TimetableProvider> _createProvider() async {
  final periodTimes = buildDefaultPeriodTimes();
  final timetable = TimetableData(
    id: 'table-1',
    config: TimetableConfig(
      name: 'Test timetable',
      startDate: DateTime(2026, 5, 25),
      totalWeeks: 18,
      periodTimeSetId: defaultPeriodTimeSetId,
    ),
    courses: [
      _course(id: 'course-a', name: 'Course A'),
      _course(id: 'course-b', name: 'Course B'),
    ],
  );
  final data = buildInitialAppData(periodTimes, localeCode: defaultLocaleCode)
      .copyWith(
        activeMode: AppMode.student,
        studentMode: StudentModeData(
          activeTimetableId: timetable.id,
          timetables: [timetable],
          periodTimeSets: [
            PeriodTimeSet(
              id: defaultPeriodTimeSetId,
              name: 'Default',
              periodTimes: periodTimes,
            ),
          ],
        ),
      );
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(data),
    systemLocaleCodeResolver: () => defaultLocaleCode,
  );
  await provider.load();
  return provider;
}

void main() {
  testWidgets('conflict action buttons ignore rapid duplicate taps', (
    tester,
  ) async {
    final provider = await _createProvider();
    final actionCompleter = Completer<void>();
    var selectCount = 0;

    await tester.pumpWidget(
      ChangeNotifierProvider<TimetableProvider>.value(
        value: provider,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CourseDetailsSheet(
              courseId: 'course-a',
              weekday: 1,
              conflictKey: null,
              isFullConflict: true,
              onEdit: () {},
              onSelectDisplayedCourse: (_) {
                selectCount += 1;
                return actionCompleter.future;
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final setDisplayedButton = find.widgetWithIcon(
      IconButton,
      Icons.visibility_outlined,
    );
    expect(setDisplayedButton, findsOneWidget);

    await tester.tap(setDisplayedButton);
    await tester.tap(setDisplayedButton, warnIfMissed: false);

    expect(selectCount, 1);

    await tester.pump();
    expect(tester.widget<IconButton>(setDisplayedButton).onPressed, isNull);

    actionCompleter.complete();
    await tester.pump();

    expect(selectCount, 1);
  });

  testWidgets('missing course only notifies once across rebuilds', (
    tester,
  ) async {
    final provider = await _createProvider();
    StateSetter? refreshHost;
    var missingCount = 0;

    await tester.pumpWidget(
      ChangeNotifierProvider<TimetableProvider>.value(
        value: provider,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StatefulBuilder(
            builder: (context, setState) {
              refreshHost = setState;
              return Scaffold(
                body: CourseDetailsSheet(
                  courseId: 'missing-course',
                  weekday: 1,
                  conflictKey: null,
                  isFullConflict: false,
                  onEdit: () {},
                  onMissing: () => missingCount += 1,
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    expect(missingCount, 1);

    refreshHost?.call(() {});
    await tester.pump();
    await tester.pump();

    expect(missingCount, 1);
  });
}
