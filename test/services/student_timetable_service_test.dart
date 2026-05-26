import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/services/student_timetable_service.dart';

void main() {
  const service = StudentTimetableService();

  CourseItem course({
    String id = 'course1',
    String name = 'Algebra',
    int dayOfWeek = 1,
    List<int> periods = const [1],
    int startMinutes = 8 * 60,
    int endMinutes = (8 * 60) + 45,
  }) {
    return CourseItem(
      id: id,
      name: name,
      teacher: '',
      location: '',
      dayOfWeek: dayOfWeek,
      semesterWeeks: const [1],
      periods: periods,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      timeRange: buildTimeRange(startMinutes, endMinutes),
      credit: 0,
      remarks: '',
      customFields: const {},
    );
  }

  PeriodTimeSet periodSet({
    String id = 'set1',
    String name = 'Set 1',
    List<CoursePeriodTime>? periodTimes,
  }) {
    return PeriodTimeSet(
      id: id,
      name: name,
      periodTimes: periodTimes ?? buildPeriodTimesForCount(2),
    );
  }

  TimetableData timetable({
    String id = 'table1',
    String name = 'Table 1',
    String periodTimeSetId = 'set1',
    int totalWeeks = 18,
    List<CourseItem>? courses,
  }) {
    return TimetableData(
      id: id,
      config: TimetableConfig(
        name: name,
        startDate: DateTime(2026, 2, 23),
        totalWeeks: totalWeeks,
        periodTimeSetId: periodTimeSetId,
      ),
      courses: courses ?? [course()],
    );
  }

  StudentModeData data({
    List<TimetableData>? timetables,
    List<PeriodTimeSet>? periodTimeSets,
    String activeTimetableId = 'table1',
    Map<String, String> conflictDisplayCourseIds = const {},
    Map<String, int> courseNameColorValues = const {},
  }) {
    return StudentModeData(
      activeTimetableId: activeTimetableId,
      timetables: timetables ?? [timetable()],
      periodTimeSets: periodTimeSets ?? [periodSet()],
      conflictDisplayCourseIds: conflictDisplayCourseIds,
      courseNameColorValues: courseNameColorValues,
    );
  }

  group('StudentTimetableService timetables', () {
    test('switches only to an existing timetable', () {
      final source = data(
        timetables: [
          timetable(id: 'table1'),
          timetable(id: 'table2', name: 'Second'),
        ],
      );

      final switched = service.switchTimetable(source, 'table2');
      final missing = service.switchTimetable(source, 'missing');

      expect(switched.activeTimetableId, 'table2');
      expect(identical(missing, source), isTrue);
    });

    test('updates timetable config and falls back to a valid period set', () {
      final source = data(
        timetables: [timetable(id: 'table1', periodTimeSetId: 'set1')],
        periodTimeSets: [
          periodSet(id: 'set1'),
          periodSet(id: 'set2'),
        ],
      );
      final nextConfig = source.timetables.single.config.copyWith(
        totalWeeks: 999,
        periodTimeSetId: 'missing',
      );

      final updated = service.updateTimetableConfig(
        source,
        'table1',
        nextConfig,
        fallbackPeriodTimeSet: periodSet(id: 'set2'),
      );

      expect(updated.timetables.single.config.totalWeeks, maxTimetableWeeks);
      expect(updated.timetables.single.config.periodTimeSetId, 'set1');
    });

    test('adds a new timetable using the current period set', () {
      final source = data(periodTimeSets: [periodSet(id: 'set1')]);
      final now = DateTime(2026, 5, 24, 10);

      final result = service.addTimetable(
        source,
        fallbackPeriodTimeSet: periodSet(id: 'set1'),
        localeCode: defaultLocaleCode,
        now: now,
      );

      expect(result.timetable!.id, 'table_${now.millisecondsSinceEpoch}');
      expect(result.timetable!.config.periodTimeSetId, 'set1');
      expect(result.data.activeTimetableId, result.timetable!.id);
      expect(result.data.timetables, hasLength(2));
    });

    test('deletes a timetable and removes stale conflict choices', () {
      final source = data(
        timetables: [
          timetable(
            id: 'table1',
            courses: [course(id: 'course1', name: 'Algebra')],
          ),
          timetable(
            id: 'table2',
            courses: [course(id: 'course2', name: 'Physics')],
          ),
        ],
        activeTimetableId: 'table2',
        conflictDisplayCourseIds: const {'conflict': 'course2'},
        courseNameColorValues: const {
          'Algebra': 0xFF123456,
          'Physics': 0xFF654321,
        },
      );

      final updated = service.deleteTimetable(source, 'table2');

      expect(updated.activeTimetableId, 'table1');
      expect(updated.timetables.map((item) => item.id), ['table1']);
      expect(updated.conflictDisplayCourseIds, isEmpty);
      expect(updated.courseNameColorValues.keys, ['Algebra']);
    });
  });

  group('StudentTimetableService courses', () {
    test('saves a new course and refreshes course colors', () {
      final source = data(courseNameColorValues: const {'Algebra': 0xFF123456});

      final updated = service.saveCourse(
        source,
        'table1',
        course(id: 'course2', name: 'Physics'),
      );

      expect(updated.timetables.single.courses.map((item) => item.id), [
        'course1',
        'course2',
      ]);
      expect(updated.courseNameColorValues['Algebra'], 0xFF123456);
      expect(updated.courseNameColorValues['Physics'], isNotNull);
    });

    test('deletes a course and removes its conflict selection', () {
      final source = data(
        timetables: [
          timetable(
            courses: [
              course(id: 'course1', name: 'Algebra'),
              course(id: 'course2', name: 'Physics'),
            ],
          ),
        ],
        conflictDisplayCourseIds: const {'conflict': 'course2'},
      );

      final updated = service.deleteCourse(source, 'table1', 'course2');

      expect(updated.timetables.single.courses.map((item) => item.id), [
        'course1',
      ]);
      expect(updated.conflictDisplayCourseIds, isEmpty);
      expect(updated.courseNameColorValues.keys, ['Algebra']);
    });
  });

  group('StudentTimetableService period time sets', () {
    test('adds and normalizes a period time set', () {
      final source = data();

      final result = service.addPeriodTimeSet(
        source,
        localeCode: defaultLocaleCode,
        defaultPeriodTimes: buildPeriodTimesForCount(3),
        name: ' Custom ',
        periodTimes: const [
          CoursePeriodTime(index: 9, startMinutes: 600, endMinutes: 645),
        ],
      );

      expect(result.periodTimeSet!.name, 'Custom');
      expect(result.periodTimeSet!.periodTimes.single.index, 1);
      expect(result.data.periodTimeSets, hasLength(2));
    });

    test('updates an existing period time set', () {
      final source = data();

      final updated = service.updatePeriodTimeSet(
        source,
        const PeriodTimeSet(id: 'set1', name: '', periodTimes: []),
        localeCode: defaultLocaleCode,
      );

      expect(updated.periodTimeSets.single.name, isNotEmpty);
      expect(updated.periodTimeSets.single.periodTimes.single.index, 1);
    });

    test('rejects deleting a period time set that is in use', () {
      final source = data();

      expect(
        () => service.deletePeriodTimeSet(
          source,
          'set1',
          localeCode: defaultLocaleCode,
        ),
        throwsFormatException,
      );
    });

    test('assigns an existing period time set to a timetable', () {
      final source = data(
        periodTimeSets: [
          periodSet(id: 'set1'),
          periodSet(id: 'set2'),
        ],
      );

      final updated = service.assignPeriodTimeSetToTimetable(
        source,
        'table1',
        'set2',
      );

      expect(updated.timetables.single.config.periodTimeSetId, 'set2');
    });
  });

  group('StudentTimetableService conflicts', () {
    test('stores the displayed course choice for a conflict', () {
      final source = data();

      final conflictKey = buildConflictKeyForCourses('table1', 1, [
        course(id: 'course1'),
        course(id: 'course2'),
      ]);
      final updated = service.setDisplayedCourseForConflict(
        source,
        conflictKey,
        'course2',
      );

      expect(updated.conflictDisplayCourseIds[conflictKey], 'course2');
    });

    test('builds parseable conflict keys for ids with separators', () {
      final conflictKey = buildConflictKeyForCourses('table|1', 1, [
        course(id: 'course,1'),
        course(id: 'course|2'),
      ]);
      final parsed = parseConflictKey(conflictKey)!;

      expect(conflictKey, 'v2|table%7C1|1|480|525|course%2C1,course%7C2');
      expect(parsed.timetableId, 'table|1');
      expect(parsed.weekday, 1);
      expect(parsed.startMinutes, 480);
      expect(parsed.endMinutes, 525);
      expect(parsed.courseIds, {'course,1', 'course|2'});
    });

    test('still parses legacy conflict keys', () {
      final parsed = parseConflictKey('table1|1|480|525|course1,course2')!;

      expect(parsed.timetableId, 'table1');
      expect(parsed.courseIds, {'course1', 'course2'});
    });
  });
}
