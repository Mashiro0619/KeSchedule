import '../l10n/app_locale.dart';
import '../utils/constants.dart';
import '../utils/localized_names.dart';
import '../utils/time_utils.dart';
import 'course_item.dart';
import 'timetable_data.dart';

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
      source: normalizeSchoolImportParserSource(json['source'] as String?),
      customBaseUrl: (json['customBaseUrl'] as String? ?? '').trim(),
      customApiKey: (json['customApiKey'] as String? ?? '').trim(),
      customModel: (json['customModel'] as String? ?? '').trim(),
      customPrompt: (json['customPrompt'] as String? ?? '').trim(),
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
  return (json['periodTimes'] as List<dynamic>? ?? const <dynamic>[])
      .map((item) =>
          CoursePeriodTime.fromJson(Map<String, dynamic>.from(item as Map)))
      .toList();
}

int _decodeLegacyDailyPeriods(
  Map<String, dynamic> json,
  List<CoursePeriodTime> legacyPeriodTimes,
) {
  return ((json['dailyPeriods'] as num?)?.toInt() ??
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

  factory StudentModeData.fromJson(Map<String, dynamic> json, {
    String localeCode = defaultLocaleCode,
  }) {
    final rawTimetables =
        (json['timetables'] as List<dynamic>? ?? const <dynamic>[])
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
    final rawPeriodTimeSets =
        (json['periodTimeSets'] as List<dynamic>? ?? const <dynamic>[])
            .map((item) => PeriodTimeSet.fromJson(
                  Map<String, dynamic>.from(item as Map),
                  localeCode: localeCode,
                ))
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
      final rawConfig = Map<String, dynamic>.from(
        rawTimetable['config'] as Map? ?? const {},
      );
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

    final activeTimetableId =
        timetables.any((item) => item.id == json['activeTimetableId'])
        ? json['activeTimetableId'] as String
        : timetables.isEmpty
        ? ''
        : timetables.first.id;

    return StudentModeData(
      activeTimetableId: activeTimetableId,
      timetables: timetables,
      periodTimeSets: normalizedSets,
      conflictDisplayCourseIds: Map<String, String>.from(
        json['conflictDisplayCourseIds'] as Map? ?? const {},
      ),
      closeCoursePopupOnOutsideTap:
          json['closeCoursePopupOnOutsideTap'] as bool? ?? true,
      preserveTimetableGaps:
          json['preserveTimetableGaps'] as bool? ?? false,
      showPastEndedCourses:
          json['showPastEndedCourses'] as bool? ?? false,
      showFutureCourses:
          json['showFutureCourses'] as bool? ?? true,
      showTimetableGridLines:
          json['showTimetableGridLines'] as bool? ?? true,
      colorfulCourseTextColorMode: normalizeColorfulCourseTextColorMode(
        json['colorfulCourseTextColorMode'] as String? ??
            defaultColorfulCourseTextColorMode,
      ),
      courseNameColorValues: decodeColorValueMap(
        json['courseNameColorValues'],
      ),
      schoolImportParserSettings: SchoolImportParserSettings.fromJson(
        Map<String, dynamic>.from(
          json['schoolImportParserSettings'] as Map? ?? const {},
        ),
      ),
      liveCourseOutlineColorValue:
          (json['liveCourseOutlineColorValue'] as num?)?.toInt() ??
              defaultLiveCourseOutlineColorValue,
      liveCourseOutlineEnabled:
          json['liveCourseOutlineEnabled'] as bool? ??
              defaultLiveCourseOutlineEnabled,
      liveCourseOutlineFollowTheme:
          json['liveCourseOutlineFollowTheme'] as bool? ??
              defaultLiveCourseOutlineFollowTheme,
      liveCourseOutlineCustomColorInitialized:
          json['liveCourseOutlineCustomColorInitialized'] as bool? ??
              defaultLiveCourseOutlineCustomColorInitialized,
      liveCourseOutlineMode: normalizeLiveCourseOutlineMode(
        json['liveCourseOutlineMode'] as String? ?? defaultLiveCourseOutlineMode,
      ),
      liveCourseOutlineWidth: normalizeLiveCourseOutlineWidth(
        (json['liveCourseOutlineWidth'] as num?)?.toDouble(),
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
      showPastEndedCourses:
          showPastEndedCourses ?? this.showPastEndedCourses,
      showFutureCourses:
          showFutureCourses ?? this.showFutureCourses,
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
