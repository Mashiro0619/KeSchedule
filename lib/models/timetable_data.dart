import 'dart:convert';

import '../l10n/app_locale.dart';
import '../utils/localized_names.dart';
import '../utils/time_utils.dart';
import 'course_item.dart';

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  if (value is! Map) {
    return const <String, dynamic>{};
  }
  final result = <String, dynamic>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is String) {
      result[key] = entry.value;
    }
  }
  return result;
}

Map<String, dynamic> _decodeJsonObject(String source) {
  final decoded = jsonDecode(source);
  final object = _asStringKeyedMap(decoded);
  if (decoded is! Map) {
    throw const FormatException('JSON root must be an object.');
  }
  return object;
}

List<dynamic> _listValue(Object? value) {
  return value is List ? value : const <dynamic>[];
}

String _stringValue(Object? value, [String fallback = '']) {
  return value is String ? value : fallback;
}

int? _intValue(Object? value) {
  return value is num ? value.toInt() : null;
}

class TimetableConfig {
  const TimetableConfig({
    required this.name,
    required this.startDate,
    required this.totalWeeks,
    required this.periodTimeSetId,
  });

  final String name;
  final DateTime startDate;
  final int totalWeeks;
  final String periodTimeSetId;

  Map<String, dynamic> toJson() => {
    'name': name,
    'startDate': startDate.toIso8601String(),
    'totalWeeks': totalWeeks,
    'periodTimeSetId': periodTimeSetId,
  };

  factory TimetableConfig.fromJson(
    Map<String, dynamic> json, {
    String localeCode = defaultLocaleCode,
  }) {
    final startDateValue = _stringValue(json['startDate']);
    return TimetableConfig(
      name: _stringValue(
        json['name'],
        untitledTimetableName(localeCode: localeCode),
      ),
      startDate: tryParseStrictIsoDateTime(startDateValue) ?? DateTime.now(),
      totalWeeks: normalizeTimetableWeeks(_intValue(json['totalWeeks'])),
      periodTimeSetId: _stringValue(json['periodTimeSetId']),
    );
  }

  TimetableConfig copyWith({
    String? name,
    DateTime? startDate,
    int? totalWeeks,
    String? periodTimeSetId,
  }) {
    return TimetableConfig(
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      totalWeeks: normalizeTimetableWeeks(totalWeeks ?? this.totalWeeks),
      periodTimeSetId: periodTimeSetId ?? this.periodTimeSetId,
    );
  }
}

class TimetableData {
  const TimetableData({
    required this.id,
    required this.config,
    required this.courses,
  });

  final String id;
  final TimetableConfig config;
  final List<CourseItem> courses;

  Map<String, dynamic> toJson() => {
    'id': id,
    'config': config.toJson(),
    'courses': courses.map((item) => item.toJson()).toList(),
  };

  factory TimetableData.fromJson(
    Map<String, dynamic> json, {
    String localeCode = defaultLocaleCode,
  }) {
    return TimetableData(
      id: _stringValue(json['id']),
      config: TimetableConfig.fromJson(
        _asStringKeyedMap(json['config']),
        localeCode: localeCode,
      ),
      courses: _listValue(json['courses'])
          .map(_asStringKeyedMap)
          .where((item) => item.isNotEmpty)
          .map(CourseItem.fromJson)
          .toList(),
    );
  }

  String encode() => jsonEncode(toJson());

  factory TimetableData.decode(String source) {
    return TimetableData.fromJson(_decodeJsonObject(source));
  }

  TimetableData copyWith({
    String? id,
    TimetableConfig? config,
    List<CourseItem>? courses,
  }) {
    return TimetableData(
      id: id ?? this.id,
      config: config ?? this.config,
      courses: courses ?? this.courses,
    );
  }
}

class TimetableLiveCourseTarget {
  const TimetableLiveCourseTarget({
    required this.week,
    required this.weekday,
    required this.courseId,
    required this.isCurrentCourse,
  });

  final int week;
  final int weekday;
  final String courseId;
  final bool isCurrentCourse;
}

List<CoursePeriodTime> _decodeLegacyPeriodTimes(Map<String, dynamic> json) {
  return _listValue(json['periodTimes'])
      .map(_asStringKeyedMap)
      .where((item) => item.isNotEmpty)
      .map(CoursePeriodTime.fromJson)
      .toList();
}

int _decodeLegacyDailyPeriods(
  Map<String, dynamic> json,
  List<CoursePeriodTime> legacyPeriodTimes,
) {
  return (_intValue(json['dailyPeriods']) ??
          (legacyPeriodTimes.isEmpty ? 10 : legacyPeriodTimes.length))
      .clamp(1, 999);
}

class TimetableExportData {
  const TimetableExportData({
    required this.timetables,
    required this.periodTimeSets,
  });

  final List<TimetableData> timetables;
  final List<PeriodTimeSet> periodTimeSets;

  TimetableData get timetable => timetables.first;

  Map<String, dynamic> toJson() => {
    'timetables': timetables.map((item) => item.toJson()).toList(),
    'periodTimeSets': periodTimeSets.map((item) => item.toJson()).toList(),
  };

  factory TimetableExportData.fromJson(
    Map<String, dynamic> json, {
    String localeCode = defaultLocaleCode,
  }) {
    if (json.containsKey('config') && json.containsKey('courses')) {
      return _legacySingleTimetableExportData(
        Map<String, dynamic>.from(json),
        localeCode: localeCode,
      );
    }

    final rawTimetables = json['timetables'];
    final rawLegacyTimetable = _asStringKeyedMap(json['timetable']);
    final timetables = rawTimetables is List
        ? rawTimetables
              .map(_asStringKeyedMap)
              .where((item) => item.isNotEmpty)
              .map(
                (item) => TimetableData.fromJson(item, localeCode: localeCode),
              )
              .toList()
        : rawLegacyTimetable.isEmpty
        ? <TimetableData>[]
        : [TimetableData.fromJson(rawLegacyTimetable, localeCode: localeCode)];
    if (rawTimetables is List &&
        rawTimetables.isNotEmpty &&
        timetables.isEmpty) {
      throw const FormatException('Timetable JSON format is invalid.');
    }
    final rawPeriodTimeSets = json['periodTimeSets'];
    final decodedPeriodTimeSets = _listValue(rawPeriodTimeSets)
        .map(_asStringKeyedMap)
        .where((item) => item.isNotEmpty)
        .map((item) => PeriodTimeSet.fromJson(item, localeCode: localeCode))
        .toList();
    if (rawPeriodTimeSets is List &&
        rawPeriodTimeSets.isNotEmpty &&
        decodedPeriodTimeSets.isEmpty) {
      throw const FormatException('Timetable JSON format is invalid.');
    }
    if (rawTimetables is! List &&
        rawLegacyTimetable.containsKey('config') &&
        rawLegacyTimetable.containsKey('courses') &&
        decodedPeriodTimeSets.isEmpty) {
      return _legacySingleTimetableExportData(
        rawLegacyTimetable,
        localeCode: localeCode,
      );
    }
    return TimetableExportData(
      timetables: timetables,
      periodTimeSets: decodedPeriodTimeSets,
    );
  }
}

TimetableExportData _legacySingleTimetableExportData(
  Map<String, dynamic> rawTimetable, {
  required String localeCode,
}) {
  final rawConfig = _asStringKeyedMap(rawTimetable['config']);
  final timetable = TimetableData.fromJson(
    rawTimetable,
    localeCode: localeCode,
  );
  final setId = timetable.config.periodTimeSetId.trim().isEmpty
      ? 'imported_period_times'
      : timetable.config.periodTimeSetId;
  final legacyPeriodTimes = _decodeLegacyPeriodTimes(rawConfig);
  final fallbackCount = _decodeLegacyDailyPeriods(rawConfig, legacyPeriodTimes);
  final periodTimeSet = PeriodTimeSet(
    id: setId,
    name: importedPeriodTimeSetName(
      timetable.config.name,
      localeCode: localeCode,
    ),
    periodTimes: buildPeriodTimesForCount(
      legacyPeriodTimes.isEmpty ? fallbackCount : legacyPeriodTimes.length,
      source: legacyPeriodTimes,
    ),
  );
  return TimetableExportData(
    timetables: [
      timetable.copyWith(
        config: timetable.config.copyWith(periodTimeSetId: setId),
      ),
    ],
    periodTimeSets: [periodTimeSet],
  );
}
