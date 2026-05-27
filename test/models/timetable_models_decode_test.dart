import 'package:flutter_test/flutter_test.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';

void main() {
  group('student timetable model decoding', () {
    test('CourseItem filters invalid numeric list entries', () {
      final course = CourseItem.fromJson({
        'id': 'course1',
        'name': 'Robust Course',
        'weekdays': ['bad', 3],
        'semesterWeeks': [1, 'bad', 2.9, null],
        'periods': ['bad', 1, 3],
      });

      expect(course.dayOfWeek, 3);
      expect(course.semesterWeeks, [1, 2]);
      expect(course.periods, [1, 3]);
    });

    test('CourseItem normalizes malformed time ranges safely', () {
      final negative = CourseItem.fromJson({
        'id': 'negative',
        'startMinutes': -20,
        'endMinutes': -1,
      });
      final overflow = CourseItem.fromJson({
        'id': 'overflow',
        'startMinutes': 2000,
        'endMinutes': 3000,
      });
      final unknown = CourseItem.fromJson({
        'id': 'unknown',
        'startMinutes': 0,
        'endMinutes': 0,
      });

      expect(negative.startMinutes, 0);
      expect(negative.endMinutes, 45);
      expect(overflow.startMinutes, 8 * 60);
      expect(overflow.endMinutes, (8 * 60) + 45);
      expect(unknown.startMinutes, 0);
      expect(unknown.endMinutes, 0);
    });

    test('CourseItem ignores non-finite scalar and list numbers', () {
      final course = CourseItem.fromJson({
        'id': 'non-finite',
        'dayOfWeek': double.infinity,
        'weekdays': [double.infinity, 2],
        'semesterWeeks': [1, double.infinity],
        'periods': [1, double.infinity],
        'startMinutes': double.infinity,
        'endMinutes': double.infinity,
        'credit': double.infinity,
      });

      expect(course.dayOfWeek, 2);
      expect(course.semesterWeeks, [1]);
      expect(course.periods, [1]);
      expect(course.startMinutes, 8 * 60);
      expect(course.endMinutes, (8 * 60) + 45);
      expect(course.credit, 0);
    });

    test('PeriodTimeSet filters invalid period time entries', () {
      final set = PeriodTimeSet.fromJson({
        'id': 'set1',
        'name': 'Set',
        'periodTimes': [
          {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
          'bad',
          null,
        ],
      });

      expect(set.periodTimes, hasLength(1));
      expect(set.periodTimes.single.index, 1);
    });

    test('PeriodTimeSet normalizes malformed period time ranges', () {
      final set = PeriodTimeSet.fromJson({
        'id': 'set1',
        'name': 'Set',
        'periodTimes': [
          {'index': 1, 'startMinutes': -1, 'endMinutes': -1},
          {'index': 2, 'startMinutes': 1500, 'endMinutes': 1600},
        ],
      });

      expect(set.periodTimes.map((item) => item.startMinutes), [0, 480]);
      expect(set.periodTimes.map((item) => item.endMinutes), [45, 525]);
    });

    test('buildPeriodTimesForCount normalizes malformed source slots', () {
      final result = buildPeriodTimesForCount(
        2,
        source: const [
          CoursePeriodTime(index: 9, startMinutes: -10, endMinutes: -1),
          CoursePeriodTime(index: 10, startMinutes: 2000, endMinutes: 2000),
        ],
      );

      expect(result.map((item) => item.index), [1, 2]);
      expect(result.first.startMinutes, 0);
      expect(result.first.endMinutes, 45);
      expect(
        result.last.startMinutes,
        buildDefaultPeriodTimes()[1].startMinutes,
      );
      expect(result.last.endMinutes, buildDefaultPeriodTimes()[1].endMinutes);
    });

    test('TimetableData filters invalid course entries', () {
      final timetable = TimetableData.fromJson({
        'id': 'table1',
        'config': {'name': 'Table', 'periodTimeSetId': 'set1'},
        'courses': [
          {'id': 'course1', 'name': 'Valid'},
          'bad',
          null,
        ],
      });

      expect(timetable.courses, hasLength(1));
      expect(timetable.courses.single.id, 'course1');
    });

    test(
      'TimetableConfig rejects invalid calendar dates instead of rolling',
      () {
        final timetable = TimetableData.fromJson({
          'id': 'table1',
          'config': {
            'name': 'Table',
            'startDate': '9999-02-31',
            'periodTimeSetId': 'set1',
          },
        });

        expect(timetable.config.startDate.year, isNot(9999));
      },
    );

    test('TimetableExportData does not invent a timetable from empty data', () {
      final empty = TimetableExportData.fromJson(
        const {},
        localeCode: defaultLocaleCode,
      );
      final malformedLegacy = TimetableExportData.fromJson(const {
        'timetable': 'bad',
      }, localeCode: defaultLocaleCode);
      final legacy = TimetableExportData.fromJson(const {
        'timetable': {
          'id': 'legacy',
          'config': {'name': 'Legacy', 'periodTimeSetId': 'set1'},
        },
      }, localeCode: defaultLocaleCode);

      expect(empty.timetables, isEmpty);
      expect(malformedLegacy.timetables, isEmpty);
      expect(legacy.timetables.single.id, 'legacy');
    });

    test('TimetableExportData restores nested legacy timetable periods', () {
      final decoded = TimetableExportData.fromJson(const {
        'timetable': {
          'id': 'legacy',
          'config': {
            'name': 'Legacy',
            'periodTimeSetId': '',
            'periodTimes': [
              {'index': 7, 'startMinutes': 600, 'endMinutes': 645},
              {'index': 9, 'startMinutes': 700, 'endMinutes': 745},
            ],
          },
          'courses': [],
        },
      }, localeCode: defaultLocaleCode);

      expect(decoded.timetables.single.config.periodTimeSetId, isNotEmpty);
      expect(decoded.periodTimeSets, hasLength(1));
      expect(
        decoded.periodTimeSets.single.periodTimes.map((item) {
          return (item.index, item.startMinutes, item.endMinutes);
        }),
        [(1, 600, 645), (2, 700, 745)],
      );
    });

    test('StudentModeData filters invalid timetables and period sets', () {
      final data = StudentModeData.fromJson({
        'activeTimetableId': 'table1',
        'periodTimeSets': [
          {
            'id': 'set1',
            'name': 'Set',
            'periodTimes': [
              {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
              'bad',
            ],
          },
          'bad',
        ],
        'timetables': [
          {
            'id': 'table1',
            'config': {'name': 'Table', 'periodTimeSetId': 'set1'},
            'courses': [
              {
                'id': 'course1',
                'periods': [1, 'bad'],
              },
              42,
            ],
          },
          'bad',
        ],
      }, localeCode: defaultLocaleCode);

      expect(data.periodTimeSets, hasLength(1));
      expect(data.periodTimeSets.single.periodTimes, hasLength(1));
      expect(data.timetables, hasLength(1));
      expect(data.timetables.single.courses, hasLength(1));
      expect(data.timetables.single.courses.single.periods, [1]);
    });

    test('StudentModeData ignores malformed settings and color values', () {
      final data = StudentModeData.fromJson({
        'activeTimetableId': 42,
        'periodTimeSets': [
          {'id': 'set1', 'name': 'Set', 'periodTimes': 'bad'},
        ],
        'timetables': [
          {
            'id': 'table1',
            'config': {'name': 'Table', 'periodTimeSetId': 'set1'},
          },
        ],
        'conflictDisplayCourseIds': {
          'valid-key': 'course1',
          'bad-value': 42,
          42: 'bad-key',
        },
        'courseNameColorValues': {'Algebra': 0xFF123456, 'Bad': 'not-a-color'},
        'schoolImportParserSettings': {
          'source': 42,
          'customBaseUrl': 42,
          'customApiKey': null,
          'customModel': ['bad'],
          'customPrompt': {'bad': true},
        },
        'colorfulCourseTextColorMode': 42,
        'liveCourseOutlineMode': 42,
        'liveCourseOutlineWidth': 'wide',
      }, localeCode: defaultLocaleCode);

      expect(data.activeTimetableId, 'table1');
      expect(data.conflictDisplayCourseIds, {'valid-key': 'course1'});
      expect(data.courseNameColorValues, {'Algebra': 0xFF123456});
      expect(data.schoolImportParserSettings.source, 'official');
      expect(data.schoolImportParserSettings.customBaseUrl, '');
      expect(data.liveCourseOutlineWidth, defaultLiveCourseOutlineWidth);
    });
  });
}
