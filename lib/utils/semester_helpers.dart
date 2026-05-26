import '../l10n/app_locale.dart';
import '../l10n/app_strings.dart';
import '../models/course_item.dart';
import '../models/timetable_data.dart';
import 'time_utils.dart';

bool matchesSemesterWeek(CourseItem course, int selectedWeek) {
  return course.semesterWeeks.isEmpty ||
      course.semesterWeeks.contains(selectedWeek);
}

String formatDayOfWeekLabel(
  int dayOfWeek, {
  String localeCode = defaultLocaleCode,
}) {
  final normalizedDay = normalizeDayOfWeek(dayOfWeek);
  return AppStrings.forLocaleCode(
    localeCode,
  ).formatDayOfWeekLabel(normalizedDay);
}

String formatWeekdayShortLabel(
  int dayOfWeek, {
  String localeCode = defaultLocaleCode,
}) {
  final normalizedDay = normalizeDayOfWeek(dayOfWeek);
  return AppStrings.forLocaleCode(
    localeCode,
  ).formatWeekdayShortLabel(normalizedDay);
}

String formatMonthLabel(int month, {String localeCode = defaultLocaleCode}) {
  return AppStrings.forLocaleCode(localeCode).formatMonthLabel(month);
}

String formatSemesterWeeksLabel(
  List<int> semesterWeeks, {
  int? totalWeeks,
  String localeCode = defaultLocaleCode,
}) {
  final normalized = normalizeSemesterWeeks(semesterWeeks);
  return AppStrings.forLocaleCode(
    localeCode,
  ).formatSemesterWeeksLabel(normalized, totalWeeks: totalWeeks);
}

List<int> matchPeriodsForTimeRange(
  List<CoursePeriodTime> periodTimes,
  int startMinutes,
  int endMinutes,
) {
  if (periodTimes.isEmpty || startMinutes >= endMinutes) {
    return const [];
  }
  for (var startIndex = 0; startIndex < periodTimes.length; startIndex++) {
    if (periodTimes[startIndex].startMinutes != startMinutes) {
      continue;
    }
    var currentEnd = periodTimes[startIndex].endMinutes;
    final periods = <int>[periodTimes[startIndex].index];
    if (currentEnd == endMinutes) {
      return periods;
    }
    for (
      var endIndex = startIndex + 1;
      endIndex < periodTimes.length;
      endIndex++
    ) {
      currentEnd = periodTimes[endIndex].endMinutes;
      periods.add(periodTimes[endIndex].index);
      if (currentEnd == endMinutes) {
        return periods;
      }
    }
  }
  return const [];
}

int currentWeekFor(TimetableConfig config, {DateTime? now}) {
  final today = startOfWeekMonday(now ?? DateTime.now());
  final semesterWeekStart = startOfWeekMonday(config.startDate);
  final days = today.difference(semesterWeekStart).inDays;
  if (days < 0) {
    return 1;
  }
  final week = (days ~/ 7) + 1;
  if (week > config.totalWeeks) {
    return config.totalWeeks;
  }
  return week;
}

DateTime startOfWeekFor(TimetableConfig config, int week) {
  return startOfWeekMonday(
    normalizeDateOnly(config.startDate).add(Duration(days: (week - 1) * 7)),
  );
}

TimetableLiveCourseTarget? currentOrNextCourseTargetFor({
  required TimetableData timetable,
  required int selectedWeek,
  required int realCurrentWeek,
  required DateTime now,
  String? Function(String conflictKey)? displayedCourseIdForConflict,
}) {
  final today = normalizeDateOnly(now);
  final weekday = normalizeDayOfWeek(today.weekday);
  final nowMinutes = (now.hour * 60) + now.minute;
  final todayTarget = _courseTargetForDay(
    timetable: timetable,
    targetWeek: realCurrentWeek,
    weekday: weekday,
    displayedCourseIdForConflict: displayedCourseIdForConflict,
    nowMinutes: nowMinutes,
  );
  if (todayTarget != null) {
    return todayTarget.week == selectedWeek ? todayTarget : null;
  }

  final tomorrow = today.add(const Duration(days: 1));
  if (!_isDateWithinTimetableRange(timetable.config, tomorrow)) {
    return null;
  }
  final tomorrowWeek = currentWeekFor(timetable.config, now: tomorrow);
  final tomorrowWeekday = normalizeDayOfWeek(tomorrow.weekday);
  final tomorrowTarget = _courseTargetForDay(
    timetable: timetable,
    targetWeek: tomorrowWeek,
    weekday: tomorrowWeekday,
    displayedCourseIdForConflict: displayedCourseIdForConflict,
  );
  if (tomorrowTarget == null) {
    return null;
  }
  return tomorrowTarget.week == selectedWeek ? tomorrowTarget : null;
}

TimetableLiveCourseTarget? _courseTargetForDay({
  required TimetableData timetable,
  required int targetWeek,
  required int weekday,
  required String? Function(String conflictKey)? displayedCourseIdForConflict,
  int? nowMinutes,
}) {
  final dayCourses =
      timetable.courses
          .where(
            (course) =>
                course.dayOfWeek == weekday &&
                matchesSemesterWeek(course, targetWeek),
          )
          .toList()
        ..sort(_compareCoursesByStart);
  if (dayCourses.isEmpty) {
    return null;
  }

  if (nowMinutes != null) {
    final currentCourses = dayCourses
        .where(
          (course) =>
              course.startMinutes <= nowMinutes &&
              nowMinutes < course.endMinutes,
        )
        .toList();
    if (currentCourses.isNotEmpty) {
      return TimetableLiveCourseTarget(
        week: targetWeek,
        weekday: weekday,
        courseId: _resolveDisplayedCourseId(
          timetable.id,
          weekday,
          currentCourses,
          displayedCourseIdForConflict,
        ),
        isCurrentCourse: true,
      );
    }

    final nextStartMinutes = dayCourses
        .where((course) => course.startMinutes > nowMinutes)
        .map((course) => course.startMinutes)
        .fold<int?>(
          null,
          (best, value) => best == null || value < best ? value : best,
        );
    if (nextStartMinutes != null) {
      final nextCourses = dayCourses
          .where((course) => course.startMinutes == nextStartMinutes)
          .toList();
      if (nextCourses.isNotEmpty) {
        return TimetableLiveCourseTarget(
          week: targetWeek,
          weekday: weekday,
          courseId: _resolveDisplayedCourseId(
            timetable.id,
            weekday,
            nextCourses,
            displayedCourseIdForConflict,
          ),
          isCurrentCourse: false,
        );
      }
    }
    return null;
  }

  final firstStartMinutes = dayCourses.first.startMinutes;
  final firstCourses = dayCourses
      .where((course) => course.startMinutes == firstStartMinutes)
      .toList();
  return TimetableLiveCourseTarget(
    week: targetWeek,
    weekday: weekday,
    courseId: _resolveDisplayedCourseId(
      timetable.id,
      weekday,
      firstCourses,
      displayedCourseIdForConflict,
    ),
    isCurrentCourse: false,
  );
}

bool _isDateWithinTimetableRange(TimetableConfig config, DateTime date) {
  final normalizedDate = normalizeDateOnly(date);
  final lastWeekStart = startOfWeekFor(config, config.totalWeeks);
  final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
  return !normalizedDate.isAfter(lastWeekEnd);
}

String _resolveDisplayedCourseId(
  String timetableId,
  int weekday,
  List<CourseItem> courses,
  String? Function(String conflictKey)? displayedCourseIdForConflict,
) {
  final sortedCourses = [...courses]..sort(_compareCoursesByStart);
  if (isFullConflictGroup(sortedCourses)) {
    final conflictKey = buildConflictKeyForCourses(
      timetableId,
      weekday,
      sortedCourses,
    );
    return pickDisplayedCourseForConflict(
      sortedCourses,
      displayedCourseIdForConflict?.call(conflictKey),
    ).id;
  }
  final prioritizedCourses = [...sortedCourses]
    ..sort(compareCoursePaintPriority);
  return prioritizedCourses.first.id;
}

int _compareCoursesByStart(CourseItem a, CourseItem b) {
  final startCompare = a.startMinutes.compareTo(b.startMinutes);
  if (startCompare != 0) {
    return startCompare;
  }
  final endCompare = a.endMinutes.compareTo(b.endMinutes);
  if (endCompare != 0) {
    return endCompare;
  }
  return a.id.compareTo(b.id);
}

bool isFullConflictGroup(List<CourseItem> courses) {
  if (courses.length < 2) {
    return false;
  }
  final first = courses.first;
  final allSameRange = courses.every(
    (item) =>
        item.startMinutes == first.startMinutes &&
        item.endMinutes == first.endMinutes,
  );
  if (allSameRange) {
    return true;
  }
  if (courses.length == 2) {
    return _courseContains(courses[0], courses[1]) ||
        _courseContains(courses[1], courses[0]);
  }
  return false;
}

bool _courseContains(CourseItem outer, CourseItem inner) {
  return outer.startMinutes <= inner.startMinutes &&
      outer.endMinutes >= inner.endMinutes;
}

CourseItem pickDisplayedCourseForConflict(
  List<CourseItem> courses,
  String? displayedCourseId,
) {
  for (final course in courses) {
    if (course.id == displayedCourseId) {
      return course;
    }
  }
  final sorted = [...courses]..sort(_compareDisplayedCourseChoice);
  return sorted.first;
}

int _compareDisplayedCourseChoice(CourseItem a, CourseItem b) {
  final durationCompare = (b.endMinutes - b.startMinutes).compareTo(
    a.endMinutes - a.startMinutes,
  );
  if (durationCompare != 0) {
    return durationCompare;
  }
  final startCompare = b.startMinutes.compareTo(a.startMinutes);
  if (startCompare != 0) {
    return startCompare;
  }
  return a.id.compareTo(b.id);
}

String buildConflictKeyForCourses(
  String timetableId,
  int weekday,
  List<CourseItem> courses,
) {
  final courseIds = courses.map((item) => item.id).toList()..sort();
  final startMinutes = courses
      .map((item) => item.startMinutes)
      .reduce((a, b) => a < b ? a : b);
  final endMinutes = courses
      .map((item) => item.endMinutes)
      .reduce((a, b) => a > b ? a : b);
  return [
    'v2',
    Uri.encodeComponent(timetableId),
    weekday.toString(),
    startMinutes.toString(),
    endMinutes.toString(),
    courseIds.map(Uri.encodeComponent).join(','),
  ].join('|');
}

class ConflictKeyParts {
  const ConflictKeyParts({
    required this.timetableId,
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    required this.courseIds,
  });

  final String timetableId;
  final int weekday;
  final int startMinutes;
  final int endMinutes;
  final Set<String> courseIds;
}

ConflictKeyParts? parseConflictKey(String key) {
  final parts = key.split('|');
  if (parts.length == 6 && parts.first == 'v2') {
    return _parseVersionedConflictKey(parts);
  }
  if (parts.length == 5) {
    return _parseLegacyConflictKey(parts);
  }
  return null;
}

ConflictKeyParts? _parseVersionedConflictKey(List<String> parts) {
  final weekday = int.tryParse(parts[2]);
  final startMinutes = int.tryParse(parts[3]);
  final endMinutes = int.tryParse(parts[4]);
  if (weekday == null || startMinutes == null || endMinutes == null) {
    return null;
  }
  try {
    return ConflictKeyParts(
      timetableId: Uri.decodeComponent(parts[1]),
      weekday: weekday,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      courseIds: parts[5]
          .split(',')
          .where((courseId) => courseId.trim().isNotEmpty)
          .map(Uri.decodeComponent)
          .toSet(),
    );
  } on FormatException {
    return null;
  } on ArgumentError {
    return null;
  }
}

ConflictKeyParts? _parseLegacyConflictKey(List<String> parts) {
  final weekday = int.tryParse(parts[1]);
  final startMinutes = int.tryParse(parts[2]);
  final endMinutes = int.tryParse(parts[3]);
  if (weekday == null || startMinutes == null || endMinutes == null) {
    return null;
  }
  return ConflictKeyParts(
    timetableId: parts[0],
    weekday: weekday,
    startMinutes: startMinutes,
    endMinutes: endMinutes,
    courseIds: parts[4]
        .split(',')
        .where((courseId) => courseId.trim().isNotEmpty)
        .toSet(),
  );
}

int compareCoursePaintPriority(CourseItem a, CourseItem b) {
  final startCompare = a.startMinutes.compareTo(b.startMinutes);
  if (startCompare != 0) {
    return startCompare;
  }
  final durationCompare = (b.endMinutes - b.startMinutes).compareTo(
    a.endMinutes - a.startMinutes,
  );
  if (durationCompare != 0) {
    return durationCompare;
  }
  return a.id.compareTo(b.id);
}
