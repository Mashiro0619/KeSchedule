import '../l10n/app_locale.dart';
import '../utils/constants.dart';
import '../utils/localized_names.dart';
import '../utils/time_utils.dart';
import 'course_item.dart';
import 'timetable_data.dart';

Map<String, dynamic>? _asStringKeyedMap(Object? value) {
  if (value is! Map) {
    return null;
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

Map<String, String> _decodeStringMap(Object? value) {
  if (value is! Map) {
    return const {};
  }
  final result = <String, String>{};
  for (final entry in value.entries) {
    final key = entry.key;
    final item = entry.value;
    if (key is String && item is String) {
      result[key] = item;
    }
  }
  return result;
}

int? _tryDecodeInt(Object? value) {
  return value is num ? value.toInt() : null;
}

double? _tryDecodeDouble(Object? value) {
  return value is num ? value.toDouble() : null;
}

bool? _tryDecodeBool(Object? value) {
  return value is bool ? value : null;
}

String _stringValue(Object? value, [String fallback = '']) {
  return value is String ? value : fallback;
}

String? _nullableStringValue(Object? value) {
  return value is String ? value : null;
}

List<dynamic> _listValue(Object? value) {
  return value is List ? value : const <dynamic>[];
}

class SchoolImportParserSettings {
  const SchoolImportParserSettings({
    this.source = defaultSchoolImportParserSource,
    this.customBaseUrl = '',
    this.customApiKey = '',
    this.customModel = '',
    this.customPrompt = '',
  });

  final String source;
  final String customBaseUrl;
  final String customApiKey;
  final String customModel;
  final String customPrompt;

  Map<String, dynamic> toJson() => {
    'source': normalizeSchoolImportParserSource(source),
    'customBaseUrl': customBaseUrl.trim(),
    'customApiKey': customApiKey.trim(),
    'customModel': customModel.trim(),
    'customPrompt': customPrompt.trim(),
  };

  factory SchoolImportParserSettings.fromJson(Map<String, dynamic> json) {
    return SchoolImportParserSettings(
      source: normalizeSchoolImportParserSource(
        _nullableStringValue(json['source']),
      ),
      customBaseUrl: _stringValue(json['customBaseUrl']).trim(),
      customApiKey: _stringValue(json['customApiKey']).trim(),
      customModel: _stringValue(json['customModel']).trim(),
      customPrompt: _stringValue(json['customPrompt']).trim(),
    );
  }

  SchoolImportParserSettings copyWith({
    String? source,
    String? customBaseUrl,
    String? customApiKey,
    String? customModel,
    String? customPrompt,
  }) {
    return SchoolImportParserSettings(
      source: normalizeSchoolImportParserSource(source ?? this.source),
      customBaseUrl: (customBaseUrl ?? this.customBaseUrl).trim(),
      customApiKey: (customApiKey ?? this.customApiKey).trim(),
      customModel: (customModel ?? this.customModel).trim(),
      customPrompt: (customPrompt ?? this.customPrompt).trim(),
    );
  }
}

PeriodTimeSet _normalizePeriodTimeSet(
  PeriodTimeSet periodTimeSet, {
  String localeCode = defaultLocaleCode,
}) {
  final normalizedTimes = buildPeriodTimesForCount(
    periodTimeSet.periodTimes.isEmpty ? 1 : periodTimeSet.periodTimes.length,
    source: periodTimeSet.periodTimes,
  );
  return periodTimeSet.copyWith(
    name: periodTimeSet.name.trim().isEmpty
        ? periodTimeSetFallbackName(localeCode: localeCode)
        : periodTimeSet.name.trim(),
    periodTimes: normalizedTimes,
  );
}

String _nextGeneratedPeriodTimeSetId(Set<String> existingIds) {
  var stamp = DateTime.now().microsecondsSinceEpoch;
  var candidate = 'period_set_$stamp';
  while (existingIds.contains(candidate)) {
    stamp += 1;
    candidate = 'period_set_$stamp';
  }
  return candidate;
}

List<CoursePeriodTime> _decodeLegacyPeriodTimes(Map<String, dynamic> json) {
  return _listValue(json['periodTimes'])
      .map(_asStringKeyedMap)
      .whereType<Map<String, dynamic>>()
      .map(CoursePeriodTime.fromJson)
      .toList();
}

int _decodeLegacyDailyPeriods(
  Map<String, dynamic> json,
  List<CoursePeriodTime> legacyPeriodTimes,
) {
  return (_tryDecodeInt(json['dailyPeriods']) ??
          (legacyPeriodTimes.isEmpty ? 10 : legacyPeriodTimes.length))
      .clamp(1, 999);
}

class StudentModeData {
  const StudentModeData({
    required this.activeTimetableId,
    required this.timetables,
    required this.periodTimeSets,
    this.conflictDisplayCourseIds = const {},
    this.closeCoursePopupOnOutsideTap = true,
    this.preserveTimetableGaps = false,
    this.showPastEndedCourses = false,
    this.showFutureCourses = true,
    this.showTimetableGridLines = true,
    this.colorfulCourseTextColorMode = defaultColorfulCourseTextColorMode,
    this.courseNameColorValues = const {},
    this.schoolImportParserSettings = const SchoolImportParserSettings(),
    this.liveCourseOutlineColorValue = defaultLiveCourseOutlineColorValue,
    this.liveCourseOutlineEnabled = defaultLiveCourseOutlineEnabled,
    this.liveCourseOutlineFollowTheme = defaultLiveCourseOutlineFollowTheme,
    this.liveCourseOutlineCustomColorInitialized =
        defaultLiveCourseOutlineCustomColorInitialized,
    this.liveCourseOutlineMode = defaultLiveCourseOutlineMode,
    this.liveCourseOutlineWidth = defaultLiveCourseOutlineWidth,
  });

  final String activeTimetableId;
  final List<TimetableData> timetables;
  final List<PeriodTimeSet> periodTimeSets;
  final Map<String, String> conflictDisplayCourseIds;
  final bool closeCoursePopupOnOutsideTap;
  final bool preserveTimetableGaps;
  final bool showPastEndedCourses;
  final bool showFutureCourses;
  final bool showTimetableGridLines;
  final String colorfulCourseTextColorMode;
  final Map<String, int> courseNameColorValues;
  final SchoolImportParserSettings schoolImportParserSettings;
  final int liveCourseOutlineColorValue;
  final bool liveCourseOutlineEnabled;
  final bool liveCourseOutlineFollowTheme;
  final bool liveCourseOutlineCustomColorInitialized;
  final String liveCourseOutlineMode;
  final double liveCourseOutlineWidth;

  Map<String, dynamic> toJson() => {
    'activeTimetableId': activeTimetableId,
    'timetables': timetables.map((item) => item.toJson()).toList(),
    'periodTimeSets': periodTimeSets.map((item) => item.toJson()).toList(),
    'conflictDisplayCourseIds': conflictDisplayCourseIds,
    'closeCoursePopupOnOutsideTap': closeCoursePopupOnOutsideTap,
    'preserveTimetableGaps': preserveTimetableGaps,
    'showPastEndedCourses': showPastEndedCourses,
    'showFutureCourses': showFutureCourses,
    'showTimetableGridLines': showTimetableGridLines,
    'colorfulCourseTextColorMode': colorfulCourseTextColorMode,
    'courseNameColorValues': courseNameColorValues,
    'schoolImportParserSettings': schoolImportParserSettings.toJson(),
    'liveCourseOutlineColorValue': liveCourseOutlineColorValue,
    'liveCourseOutlineEnabled': liveCourseOutlineEnabled,
    'liveCourseOutlineFollowTheme': liveCourseOutlineFollowTheme,
    'liveCourseOutlineCustomColorInitialized':
        liveCourseOutlineCustomColorInitialized,
    'liveCourseOutlineMode': liveCourseOutlineMode,
    'liveCourseOutlineWidth': liveCourseOutlineWidth,
  };

  factory StudentModeData.fromJson(
    Map<String, dynamic> json, {
    String localeCode = defaultLocaleCode,
  }) {
    final rawTimetables = _listValue(
      json['timetables'],
    ).map(_asStringKeyedMap).whereType<Map<String, dynamic>>().toList();
    final rawPeriodTimeSets = _listValue(json['periodTimeSets'])
        .map(_asStringKeyedMap)
        .whereType<Map<String, dynamic>>()
        .map((item) => PeriodTimeSet.fromJson(item, localeCode: localeCode))
        .toList();
    final normalizedSets = <PeriodTimeSet>[
      for (final item in rawPeriodTimeSets)
        _normalizePeriodTimeSet(item, localeCode: localeCode),
    ];
    final setIds = normalizedSets
        .map((item) => item.id)
        .where((item) => item.trim().isNotEmpty)
        .toSet();
    final timetables = <TimetableData>[];

    for (final rawTimetable in rawTimetables) {
      final rawConfig = _asStringKeyedMap(rawTimetable['config']) ?? const {};
      var timetable = TimetableData.fromJson(
        rawTimetable,
        localeCode: localeCode,
      );
      var periodTimeSetId = timetable.config.periodTimeSetId.trim();
      if (periodTimeSetId.isEmpty || !setIds.contains(periodTimeSetId)) {
        periodTimeSetId = _nextGeneratedPeriodTimeSetId(setIds);
        final legacyPeriodTimes = _decodeLegacyPeriodTimes(rawConfig);
        final fallbackCount = _decodeLegacyDailyPeriods(
          rawConfig,
          legacyPeriodTimes,
        );
        normalizedSets.add(
          PeriodTimeSet(
            id: periodTimeSetId,
            name: importedPeriodTimeSetName(
              timetable.config.name,
              localeCode: localeCode,
            ),
            periodTimes: buildPeriodTimesForCount(
              legacyPeriodTimes.isEmpty
                  ? fallbackCount
                  : legacyPeriodTimes.length,
              source: legacyPeriodTimes,
            ),
          ),
        );
        setIds.add(periodTimeSetId);
      }
      timetable = timetable.copyWith(
        config: timetable.config.copyWith(periodTimeSetId: periodTimeSetId),
      );
      timetables.add(timetable);
    }

    final activeTimetableIdRaw = _stringValue(json['activeTimetableId']);
    final activeTimetableId =
        timetables.any((item) => item.id == activeTimetableIdRaw)
        ? activeTimetableIdRaw
        : timetables.isEmpty
        ? ''
        : timetables.first.id;

    return StudentModeData(
      activeTimetableId: activeTimetableId,
      timetables: timetables,
      periodTimeSets: normalizedSets,
      conflictDisplayCourseIds: _decodeStringMap(
        json['conflictDisplayCourseIds'],
      ),
      closeCoursePopupOnOutsideTap:
          _tryDecodeBool(json['closeCoursePopupOnOutsideTap']) ?? true,
      preserveTimetableGaps:
          _tryDecodeBool(json['preserveTimetableGaps']) ?? false,
      showPastEndedCourses:
          _tryDecodeBool(json['showPastEndedCourses']) ?? false,
      showFutureCourses: _tryDecodeBool(json['showFutureCourses']) ?? true,
      showTimetableGridLines:
          _tryDecodeBool(json['showTimetableGridLines']) ?? true,
      colorfulCourseTextColorMode: normalizeColorfulCourseTextColorMode(
        _nullableStringValue(json['colorfulCourseTextColorMode']) ??
            defaultColorfulCourseTextColorMode,
      ),
      courseNameColorValues: decodeColorValueMap(json['courseNameColorValues']),
      schoolImportParserSettings: SchoolImportParserSettings.fromJson(
        _asStringKeyedMap(json['schoolImportParserSettings']) ?? const {},
      ),
      liveCourseOutlineColorValue:
          _tryDecodeInt(json['liveCourseOutlineColorValue']) ??
          defaultLiveCourseOutlineColorValue,
      liveCourseOutlineEnabled:
          _tryDecodeBool(json['liveCourseOutlineEnabled']) ??
          defaultLiveCourseOutlineEnabled,
      liveCourseOutlineFollowTheme:
          _tryDecodeBool(json['liveCourseOutlineFollowTheme']) ??
          defaultLiveCourseOutlineFollowTheme,
      liveCourseOutlineCustomColorInitialized:
          _tryDecodeBool(json['liveCourseOutlineCustomColorInitialized']) ??
          defaultLiveCourseOutlineCustomColorInitialized,
      liveCourseOutlineMode: normalizeLiveCourseOutlineMode(
        _nullableStringValue(json['liveCourseOutlineMode']) ??
            defaultLiveCourseOutlineMode,
      ),
      liveCourseOutlineWidth: normalizeLiveCourseOutlineWidth(
        _tryDecodeDouble(json['liveCourseOutlineWidth']),
      ),
    );
  }

  StudentModeData copyWith({
    String? activeTimetableId,
    List<TimetableData>? timetables,
    List<PeriodTimeSet>? periodTimeSets,
    Map<String, String>? conflictDisplayCourseIds,
    bool? closeCoursePopupOnOutsideTap,
    bool? preserveTimetableGaps,
    bool? showPastEndedCourses,
    bool? showFutureCourses,
    bool? showTimetableGridLines,
    String? colorfulCourseTextColorMode,
    Map<String, int>? courseNameColorValues,
    SchoolImportParserSettings? schoolImportParserSettings,
    int? liveCourseOutlineColorValue,
    bool? liveCourseOutlineEnabled,
    bool? liveCourseOutlineFollowTheme,
    bool? liveCourseOutlineCustomColorInitialized,
    String? liveCourseOutlineMode,
    double? liveCourseOutlineWidth,
  }) {
    return StudentModeData(
      activeTimetableId: activeTimetableId ?? this.activeTimetableId,
      timetables: timetables ?? this.timetables,
      periodTimeSets: periodTimeSets ?? this.periodTimeSets,
      conflictDisplayCourseIds:
          conflictDisplayCourseIds ?? this.conflictDisplayCourseIds,
      closeCoursePopupOnOutsideTap:
          closeCoursePopupOnOutsideTap ?? this.closeCoursePopupOnOutsideTap,
      preserveTimetableGaps:
          preserveTimetableGaps ?? this.preserveTimetableGaps,
      showPastEndedCourses: showPastEndedCourses ?? this.showPastEndedCourses,
      showFutureCourses: showFutureCourses ?? this.showFutureCourses,
      showTimetableGridLines:
          showTimetableGridLines ?? this.showTimetableGridLines,
      colorfulCourseTextColorMode: normalizeColorfulCourseTextColorMode(
        colorfulCourseTextColorMode ?? this.colorfulCourseTextColorMode,
      ),
      courseNameColorValues:
          courseNameColorValues ?? this.courseNameColorValues,
      schoolImportParserSettings:
          schoolImportParserSettings ?? this.schoolImportParserSettings,
      liveCourseOutlineColorValue:
          liveCourseOutlineColorValue ?? this.liveCourseOutlineColorValue,
      liveCourseOutlineEnabled:
          liveCourseOutlineEnabled ?? this.liveCourseOutlineEnabled,
      liveCourseOutlineFollowTheme:
          liveCourseOutlineFollowTheme ?? this.liveCourseOutlineFollowTheme,
      liveCourseOutlineCustomColorInitialized:
          liveCourseOutlineCustomColorInitialized ??
          this.liveCourseOutlineCustomColorInitialized,
      liveCourseOutlineMode: normalizeLiveCourseOutlineMode(
        liveCourseOutlineMode ?? this.liveCourseOutlineMode,
      ),
      liveCourseOutlineWidth: normalizeLiveCourseOutlineWidth(
        liveCourseOutlineWidth ?? this.liveCourseOutlineWidth,
      ),
    );
  }
}
