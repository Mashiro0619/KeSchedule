import 'package:flutter/material.dart';

import '../models/course_item.dart';
import 'constants.dart';

Color deriveLiveCourseOutlineColorFromSeed(Color seedColor) {
  final hsl = HSLColor.fromColor(seedColor);
  final lightness = (hsl.lightness - 0.11).clamp(0.20, 0.74).toDouble();
  final saturation = (hsl.saturation + 0.08).clamp(0.12, 1.0).toDouble();
  return hsl.withLightness(lightness).withSaturation(saturation).toColor();
}

double normalizeLiveCourseOutlineWidth(double? width) {
  return (width ?? defaultLiveCourseOutlineWidth)
      .clamp(minLiveCourseOutlineWidth, maxLiveCourseOutlineWidth)
      .toDouble();
}

String normalizeLiveCourseOutlineMode(String? mode) {
  switch (mode) {
    case liveCourseOutlineModeAllDisplayed:
      return liveCourseOutlineModeAllDisplayed;
    case liveCourseOutlineModeCurrentOrNext:
    default:
      return liveCourseOutlineModeCurrentOrNext;
  }
}

String normalizeColorfulCourseTextColorMode(String? mode) {
  switch (mode) {
    case colorfulCourseTextColorModeCustom:
      return colorfulCourseTextColorModeCustom;
    case colorfulCourseTextColorModeAuto:
    default:
      return colorfulCourseTextColorModeAuto;
  }
}

int normalizeMinuteOfDay(int? minutes, {int fallback = 0}) {
  return (minutes ?? fallback).clamp(0, (24 * 60) - 1).toInt();
}

String formatMinutes(int minutes) {
  final normalized = normalizeMinuteOfDay(minutes);
  final hour = (normalized ~/ 60).toString().padLeft(2, '0');
  final minute = (normalized % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}

int normalizeTimetableWeeks(int? totalWeeks) {
  return (totalWeeks ?? 18).clamp(1, maxTimetableWeeks);
}

DateTime normalizeDateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime? tryParseStrictIsoDateTime(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})(?:[T ](\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{1,6}))?)?)?(Z|[+-]\d{2}:?\d{2})?$',
  ).firstMatch(trimmed);
  if (match == null) {
    return null;
  }

  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final hour = int.parse(match.group(4) ?? '0');
  final minute = int.parse(match.group(5) ?? '0');
  final second = int.parse(match.group(6) ?? '0');
  if (!_isValidDateTimeParts(
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
  )) {
    return null;
  }
  return DateTime.tryParse(trimmed);
}

DateTime? tryParseStrictIsoDate(String? value) {
  final parsed = tryParseStrictIsoDateTime(value);
  return parsed == null ? null : normalizeDateOnly(parsed);
}

bool _isValidDateTimeParts({
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  required int second,
}) {
  if (year < 1 ||
      year > 9999 ||
      month < 1 ||
      month > 12 ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59 ||
      second < 0 ||
      second > 59) {
    return false;
  }
  return day >= 1 && day <= DateTime(year, month + 1, 0).day;
}

DateTime startOfWeekMonday(DateTime date) {
  final normalized = normalizeDateOnly(date);
  return normalized.subtract(
    Duration(days: normalized.weekday - DateTime.monday),
  );
}

DateTime startOfWeekSunday(DateTime date) {
  final normalized = normalizeDateOnly(date);
  return normalized.subtract(Duration(days: normalized.weekday % 7));
}

String buildTimeRange(int startMinutes, int endMinutes) {
  return '${formatMinutes(startMinutes)} - ${formatMinutes(endMinutes)}';
}

int normalizeDayOfWeek(int? dayOfWeek) {
  final value = dayOfWeek ?? 1;
  return value.clamp(1, 7);
}

String normalizeThemeMode(String? themeMode) {
  switch (themeMode) {
    case 'dark':
      return 'dark';
    case 'system':
      return 'system';
    case 'light':
      return 'light';
    default:
      return defaultThemeMode;
  }
}

String normalizeThemeColorMode(String? themeColorMode) {
  switch (themeColorMode) {
    case themeColorModeColorful:
      return themeColorModeColorful;
    case themeColorModeSingle:
    default:
      return themeColorModeSingle;
  }
}

String normalizeSchoolImportParserSource(String? source) {
  switch (source) {
    case schoolImportParserSourceCustomOpenAi:
      return schoolImportParserSourceCustomOpenAi;
    case schoolImportParserSourceOfficial:
    default:
      return schoolImportParserSourceOfficial;
  }
}

String normalizeCourseColorName(String? courseName) {
  return courseName?.trim() ?? '';
}

Map<String, int> decodeColorValueMap(dynamic value) {
  if (value is! Map) {
    return const {};
  }
  final result = <String, int>{};
  value.forEach((key, item) {
    final normalizedKey = '$key'.trim();
    final colorValue = item is num ? item.toInt() : null;
    if (normalizedKey.isEmpty || colorValue == null) {
      return;
    }
    result[normalizedKey] = colorValue;
  });
  return result;
}

List<int> normalizeSemesterWeeks(List<int> semesterWeeks) {
  final normalized = semesterWeeks.where((week) => week > 0).toSet().toList()
    ..sort();
  return normalized;
}

List<int> buildAllSemesterWeeks(int totalWeeks) {
  final safeTotalWeeks = normalizeTimetableWeeks(totalWeeks);
  return List.generate(safeTotalWeeks, (index) => index + 1);
}

// Period time construction

List<CoursePeriodTime> buildDefaultPeriodTimes() {
  const slots = <List<int>>[
    [8, 0, 8, 45],
    [8, 55, 9, 40],
    [10, 0, 10, 45],
    [10, 55, 11, 40],
    [14, 0, 14, 45],
    [14, 55, 15, 40],
    [16, 0, 16, 45],
    [16, 55, 17, 40],
    [19, 0, 19, 45],
    [19, 55, 20, 40],
    [20, 50, 21, 35],
    [21, 40, 22, 25],
  ];

  return List.generate(slots.length, (index) {
    final slot = slots[index];
    return CoursePeriodTime(
      index: index + 1,
      startMinutes: slot[0] * 60 + slot[1],
      endMinutes: slot[2] * 60 + slot[3],
    );
  });
}

List<CoursePeriodTime> buildPeriodTimesForCount(
  int count, {
  List<CoursePeriodTime>? source,
}) {
  final safeCount = count < 1 ? 1 : count;
  final defaults = buildDefaultPeriodTimes();
  final seed = (source == null || source.isEmpty)
      ? <CoursePeriodTime>[]
      : List.generate(
          source.length,
          (index) => _normalizePeriodTime(
            source[index],
            fallback: index < defaults.length ? defaults[index] : null,
          ).copyWith(index: index + 1),
        );
  final result = <CoursePeriodTime>[];

  for (var index = 0; index < safeCount; index++) {
    if (index < seed.length) {
      result.add(seed[index].copyWith(index: index + 1));
      continue;
    }
    if (index < defaults.length) {
      result.add(defaults[index].copyWith(index: index + 1));
      continue;
    }
    result.add(_buildNextPeriodTime(result, index + 1));
  }

  return result;
}

CoursePeriodTime _normalizePeriodTime(
  CoursePeriodTime period, {
  CoursePeriodTime? fallback,
}) {
  final fallbackStart = fallback?.startMinutes ?? 8 * 60;
  final fallbackEnd = fallback?.endMinutes ?? (8 * 60) + 45;
  final startMinutes = normalizeMinuteOfDay(
    period.startMinutes,
    fallback: fallbackStart,
  );
  final endMinutes = normalizeMinuteOfDay(
    period.endMinutes,
    fallback: fallbackEnd,
  );
  if (endMinutes > startMinutes) {
    return period.copyWith(startMinutes: startMinutes, endMinutes: endMinutes);
  }
  final repairedEnd = normalizeMinuteOfDay(
    startMinutes + 45,
    fallback: fallbackEnd,
  );
  if (repairedEnd > startMinutes) {
    return period.copyWith(startMinutes: startMinutes, endMinutes: repairedEnd);
  }
  return period.copyWith(startMinutes: fallbackStart, endMinutes: fallbackEnd);
}

CoursePeriodTime _buildNextPeriodTime(
  List<CoursePeriodTime> existing,
  int index,
) {
  if (existing.isEmpty) {
    return const CoursePeriodTime(
      index: 1,
      startMinutes: 8 * 60,
      endMinutes: (8 * 60) + 45,
    );
  }
  final last = existing.last;
  final previous = existing.length > 1 ? existing[existing.length - 2] : null;
  final duration = last.endMinutes > last.startMinutes
      ? last.endMinutes - last.startMinutes
      : 45;
  final gap = previous == null
      ? 10
      : (last.startMinutes - previous.endMinutes).clamp(0, 120);
  final startMinutes = last.endMinutes + gap;
  return CoursePeriodTime(
    index: index,
    startMinutes: startMinutes,
    endMinutes: startMinutes + duration,
  );
}

// Forward declaration — CoursePeriodTime will be defined in course_item.dart;
// the models barrel resolves this via re-export order.
// These functions are used by course_item.dart and timetable_data.dart.
// Since Flutter resolves imports at the library level, the barrel file
// ensures all symbols are available.
