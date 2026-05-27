import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/school_import_models.dart';

void main() {
  Map<String, Object?> validCourse() => {
    'name': 'Valid',
    'semesterWeeks': [1],
    'periods': [1],
    'startMinutes': 480,
    'endMinutes': 525,
  };

  group('SchoolImportResponse decoding', () {
    test('filters malformed course and numeric list entries', () {
      final response = SchoolImportResponse.fromJson({
        'ok': true,
        'meta': {
          'warnings': ['kept', null, ''],
        },
        'timetable': {
          'name': 'Imported',
          'startDate': '2026-02-23',
          'periodTimeSet': {
            'periodTimes': [
              {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
              'bad',
              {'index': 2},
            ],
          },
          'courses': [
            {
              'name': 'Valid',
              'semesterWeeks': [3, 1, 'bad', 3, 0, -1, 2.5],
              'periods': [2, 1, null, 2, 0, -1, double.infinity],
            },
            'bad',
            null,
          ],
        },
      });

      expect(response.meta.warnings, ['kept']);
      expect(response.timetable.periodTimeSet.periodTimes, hasLength(1));
      expect(response.timetable.courses, hasLength(1));
      expect(response.timetable.courses.single.semesterWeeks, [1, 3]);
      expect(response.timetable.courses.single.periods, [1, 2]);
    });

    test('uses safe defaults for malformed meta objects', () {
      final response = SchoolImportResponse.fromJson({
        'ok': true,
        'meta': 'bad',
        'timetable': {
          'name': 'Imported',
          'courses': [validCourse()],
        },
      });

      expect(response.meta.sourceUrl, '');
      expect(response.timetable.name, 'Imported');
      expect(response.timetable.courses, hasLength(1));
    });

    test('rejects successful responses without a timetable payload', () {
      expect(
        () => SchoolImportResponse.fromJson({'ok': true}),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Import response format is invalid.',
          ),
        ),
      );
      expect(
        () => SchoolImportResponse.fromJson({'ok': true, 'timetable': 'bad'}),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => SchoolImportResponse.fromJson({
          'ok': 'true',
          'timetable': {'name': 'Imported'},
        }),
        throwsA(isA<FormatException>()),
      );
      for (final courses in [
        null,
        'bad',
        const [],
        const ['bad'],
      ]) {
        final timetable = <String, Object?>{'name': 'Imported'};
        if (courses != null) {
          timetable['courses'] = courses;
        }
        expect(
          () => SchoolImportResponse.fromJson({
            'ok': true,
            'timetable': timetable,
          }),
          throwsA(isA<FormatException>()),
          reason: 'courses=$courses',
        );
      }
    });

    test('rejects invalid start dates instead of rolling them forward', () {
      final response = SchoolImportResponse.fromJson({
        'ok': true,
        'timetable': {
          'name': 'Imported',
          'startDate': '9999-02-31',
          'courses': [validCourse()],
        },
      });

      expect(response.timetable.startDate.year, isNot(9999));
    });

    test('ignores non-finite scalar numbers without throwing', () {
      final response = SchoolImportResponse.fromJson({
        'ok': true,
        'timetable': {
          'name': 'Imported',
          'totalWeeks': double.infinity,
          'courses': [
            {
              ...validCourse(),
              'dayOfWeek': double.infinity,
              'startMinutes': double.infinity,
              'endMinutes': double.infinity,
              'credit': double.infinity,
            },
          ],
        },
      });

      expect(response.timetable.totalWeeks, 18);
      expect(response.timetable.courses.single.dayOfWeek, 1);
      expect(response.timetable.courses.single.startMinutes, 0);
      expect(response.timetable.courses.single.endMinutes, 0);
      expect(response.timetable.courses.single.credit, 0);
    });
  });
}
