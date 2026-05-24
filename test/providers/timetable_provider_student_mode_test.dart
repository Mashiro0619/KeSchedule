import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';

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
  Future<String?> filePath() async => 'memory://provider-student-test';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  CourseItem course({
    String id = 'course1',
    String name = 'Algebra',
    int dayOfWeek = 1,
    List<int> semesterWeeks = const [1],
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
      semesterWeeks: semesterWeeks,
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
    String name = 'Default periods',
    int count = 2,
  }) {
    return PeriodTimeSet(
      id: id,
      name: name,
      periodTimes: buildPeriodTimesForCount(count),
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

  AppData appData({
    String activeTimetableId = 'table1',
    List<TimetableData>? timetables,
    List<PeriodTimeSet>? periodTimeSets,
    Map<String, String> conflictDisplayCourseIds = const {},
    Map<String, int> courseNameColorValues = const {},
    AppMode activeMode = AppMode.student,
  }) {
    return buildInitialAppData(
      buildDefaultPeriodTimes(),
      localeCode: defaultLocaleCode,
    ).copyWith(
      activeMode: activeMode,
      studentMode: StudentModeData(
        activeTimetableId: activeTimetableId,
        timetables: timetables ?? [timetable()],
        periodTimeSets: periodTimeSets ?? [periodSet()],
        conflictDisplayCourseIds: conflictDisplayCourseIds,
        courseNameColorValues: courseNameColorValues,
      ),
    );
  }

  TimetableProvider providerWith(AppData data) {
    return TimetableProvider(
      storage: _MemoryTimetableStorage(data),
      systemLocaleCodeResolver: () => defaultLocaleCode,
    );
  }

  group('TimetableProvider student mode', () {
    test('saves and deletes courses through the facade', () async {
      final provider = providerWith(
        appData(
          timetables: [
            timetable(
              courses: [
                course(id: 'course1', name: 'Algebra'),
                course(id: 'course2', name: 'Physics'),
              ],
            ),
          ],
          conflictDisplayCourseIds: const {
            'table1|1|480|525|course1,course2': 'course2',
          },
          courseNameColorValues: const {
            'Algebra': 0xFF123456,
            'Physics': 0xFF654321,
          },
        ),
      );

      await provider.load();
      await provider.saveCourse(course(id: 'course3', name: 'Chemistry'));

      expect(provider.activeTimetable.courses.map((item) => item.id), [
        'course1',
        'course2',
        'course3',
      ]);
      expect(provider.courseNameColorValues['Algebra'], 0xFF123456);
      expect(provider.courseNameColorValues['Chemistry'], isNotNull);

      await provider.deleteCourse('course2');

      expect(provider.activeTimetable.courses.map((item) => item.id), [
        'course1',
        'course3',
      ]);
      expect(provider.displayedCourseIdForConflict('unused'), isNull);
      expect(provider.studentMode.conflictDisplayCourseIds, isEmpty);
      expect(provider.courseNameColorValues.containsKey('Physics'), isFalse);
    });

    test('switches timetables and clamps selected week', () async {
      final provider = providerWith(
        appData(
          activeTimetableId: 'table1',
          timetables: [
            timetable(id: 'table1', name: 'First', totalWeeks: 18),
            timetable(id: 'table2', name: 'Second', totalWeeks: 4),
          ],
        ),
      );

      await provider.load();
      await provider.switchTimetable('table2');
      await provider.setSelectedWeek(99);

      expect(provider.activeTimetable.id, 'table2');
      expect(provider.selectedWeek, 4);

      await provider.switchTimetable('missing');

      expect(provider.activeTimetable.id, 'table2');
    });

    test('adds, assigns, updates, and protects period time sets', () async {
      final provider = providerWith(
        appData(
          timetables: [
            timetable(id: 'table1', periodTimeSetId: 'set1'),
            timetable(id: 'table2', periodTimeSetId: 'set1'),
          ],
          periodTimeSets: [periodSet(id: 'set1', count: 2)],
        ),
      );

      await provider.load();
      final added = await provider.addPeriodTimeSet(
        name: ' Custom ',
        periodTimes: buildPeriodTimesForCount(3),
      );
      await provider.assignPeriodTimeSetToTimetable('table2', added.id);
      await provider.updatePeriodTimeSet(
        added.copyWith(name: '', periodTimes: const []),
      );

      expect(provider.periodTimeSets, hasLength(2));
      expect(provider.periodTimeSetForId(added.id)!.name, isNotEmpty);
      expect(provider.periodTimeSetForId(added.id)!.periodTimes, hasLength(1));
      expect(
        provider.timetables
            .singleWhere((item) => item.id == 'table2')
            .config
            .periodTimeSetId,
        added.id,
      );
      expect(
        () => provider.deletePeriodTimeSet(added.id),
        throwsFormatException,
      );
    });

    test('stores conflict display choices and removes stale choices', () async {
      final conflictKey = buildConflictKeyForCourses('table1', 1, [
        course(
          id: 'long',
          name: 'Long',
          periods: const [1, 2],
          endMinutes: 570,
        ),
        course(id: 'short', name: 'Short'),
      ]);
      final provider = providerWith(
        appData(
          timetables: [
            timetable(
              courses: [
                course(
                  id: 'long',
                  name: 'Long',
                  periods: const [1, 2],
                  endMinutes: 570,
                ),
                course(id: 'short', name: 'Short'),
              ],
            ),
          ],
        ),
      );

      await provider.load();
      await provider.setDisplayedCourseForConflict(conflictKey, 'short');

      expect(provider.displayedCourseIdForConflict(conflictKey), 'short');

      await provider.deleteCourse('short');

      expect(provider.displayedCourseIdForConflict(conflictKey), isNull);
    });

    test('switching app modes preserves student data', () async {
      final provider = providerWith(appData(activeMode: AppMode.general));

      await provider.load();
      await provider.switchMode(AppMode.student);
      await provider.saveCourse(course(id: 'course2', name: 'Physics'));
      await provider.switchMode(AppMode.general);

      expect(provider.isGeneralMode, isTrue);
      expect(provider.activeTimetable.courses.map((item) => item.id), [
        'course1',
        'course2',
      ]);

      await provider.switchMode(AppMode.student);

      expect(provider.isStudentMode, isTrue);
      expect(provider.activeTimetable.courses.map((item) => item.name), [
        'Algebra',
        'Physics',
      ]);
    });
  });
}
