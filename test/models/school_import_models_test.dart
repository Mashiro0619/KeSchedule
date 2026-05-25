import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/school_import_models.dart';

void main() {
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
              'semesterWeeks': [1, 'bad', 3],
              'periods': [1, null, 2],
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

    test('treats malformed timetable and meta objects as empty objects', () {
      final response = SchoolImportResponse.fromJson({
        'ok': true,
        'meta': 'bad',
        'timetable': 'bad',
      });

      expect(response.meta.sourceUrl, '');
      expect(response.timetable.name, '');
      expect(response.timetable.courses, isEmpty);
    });

    test('rejects invalid start dates instead of rolling them forward', () {
      final response = SchoolImportResponse.fromJson({
        'ok': true,
        'timetable': {'name': 'Imported', 'startDate': '9999-02-31'},
      });

      expect(response.timetable.startDate.year, isNot(9999));
    });
  });
}
