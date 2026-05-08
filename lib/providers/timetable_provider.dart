import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../data/timetable_storage.dart';
import '../l10n/app_locale.dart' as app_locale;
import '../models/school_import_models.dart';
import '../models/timetable_models.dart';

const _colorfulCoursePalette = <int>[
  0xFFE57373,
  0xFFF06292,
  0xFFBA68C8,
  0xFF9575CD,
  0xFF7986CB,
  0xFF64B5F6,
  0xFF4FC3F7,
  0xFF4DD0E1,
  0xFF4DB6AC,
  0xFF81C784,
  0xFFAED581,
  0xFFFFD54F,
  0xFFFFB74D,
  0xFFFF8A65,
  0xFFA1887F,
  0xFF90A4AE,
];

enum AppImportMode { replaceAll, addAll }

String resolveFirstLaunchLocaleCode(Locale? locale) {
  return app_locale.resolveFirstLaunchLocaleCode(locale);
}

String _defaultSystemLocaleCodeResolver() {
  final locales = PlatformDispatcher.instance.locales;
  return app_locale.resolveFirstLaunchLocaleCode(
    locales.isEmpty ? null : locales.first,
  );
}

class TimetableProvider extends ChangeNotifier {
  TimetableProvider({
    TimetableStorage? storage,
    String Function()? systemLocaleCodeResolver,
  }) : _storage = storage ?? TimetableStorage(),
       _systemLocaleCodeResolver =
           systemLocaleCodeResolver ?? _defaultSystemLocaleCodeResolver;

  final TimetableStorage _storage;
  final String Function() _systemLocaleCodeResolver;

  AppData _appData = buildInitialAppData(buildDefaultPeriodTimes());
  int _selectedWeek = 1;
  bool _isLoaded = false;
  bool _isLoading = false;
  String? _storagePath;

  bool get isLoaded => _isLoaded;
  bool get hasTimetables => _appData.timetables.isNotEmpty;
  bool get hasPeriodTimeSets => _appData.periodTimeSets.isNotEmpty;
  List<TimetableData> get timetables => _appData.timetables;
  List<PeriodTimeSet> get periodTimeSets => _appData.periodTimeSets;
  int get selectedWeek => _selectedWeek;
  String? get storagePath => _storagePath;
  bool get closeCoursePopupOnOutsideTap =>
      _appData.closeCoursePopupOnOutsideTap;
  bool get preserveTimetableGaps => _appData.preserveTimetableGaps;
  bool get showPastEndedCourses => _appData.showPastEndedCourses;
  bool get showFutureCourses => _appData.showFutureCourses;
  bool get showTimetableGridLines => _appData.showTimetableGridLines;
  String get localeCode => _appData.localeCode;
  String get themeMode => _appData.themeMode;
  String get themeColorMode => _appData.themeColorMode;
  int get themeSeedColorValue => _appData.themeSeedColorValue;
  String get colorfulCourseTextColorMode =>
      _appData.colorfulCourseTextColorMode;
  Map<String, int> get colorfulUiColorValues => _appData.colorfulUiColorValues;
  Map<String, int> get courseNameColorValues => _appData.courseNameColorValues;
  SchoolImportParserSettings get schoolImportParserSettings =>
      _appData.schoolImportParserSettings;
  String get schoolImportParserSource =>
      _appData.schoolImportParserSettings.source;
  String get customSchoolImportBaseUrl =>
      _appData.schoolImportParserSettings.customBaseUrl;
  String get customSchoolImportApiKey =>
      _appData.schoolImportParserSettings.customApiKey;
  String get customSchoolImportModel =>
      _appData.schoolImportParserSettings.customModel;
  String get customSchoolImportPrompt =>
      _appData.schoolImportParserSettings.customPrompt;
  int get liveCourseOutlineColorValue => _appData.liveCourseOutlineColorValue;
  bool get liveCourseOutlineEnabled => _appData.liveCourseOutlineEnabled;
  bool get liveCourseOutlineFollowTheme => _appData.liveCourseOutlineFollowTheme;
  bool get liveCourseOutlineCustomColorInitialized =>
      _appData.liveCourseOutlineCustomColorInitialized;
  String get liveCourseOutlineMode => _appData.liveCourseOutlineMode;
  double get liveCourseOutlineWidth => _appData.liveCourseOutlineWidth;
  String? get ignoredUpdateVersion => _appData.ignoredUpdateVersion;
  String? get availableUpdateVersion => _appData.availableUpdateVersion;

  // ── Privacy policy (remote-version driven) ──

  String? _remotePrivacyPolicyVersion;

  /// The latest version fetched from the web. Null until the first fetch
  /// succeeds — the app treats null as "nothing to enforce" so the user is
  /// never blocked by a network failure.
  String? get activePrivacyPolicyVersion => _remotePrivacyPolicyVersion;

  String? get acceptedPrivacyPolicyVersion => _appData.privacyPolicyAcceptedVersion;

  DateTime? get privacyPolicyAcceptedAt {
    final value = _appData.privacyPolicyAcceptedAtIso;
    return value == null ? null : DateTime.tryParse(value);
  }

  /// Returns true when there is no remote version to compare against (network
  /// not yet fetched or fetch failed) — the user is never gated by a missing
  /// network response.
  bool get hasAcceptedCurrentPrivacyPolicy {
    if (_remotePrivacyPolicyVersion == null) return true;
    return _appData.privacyPolicyAcceptedVersion == _remotePrivacyPolicyVersion;
  }

  /// For testing only — injects a remote version so consent-gate tests can
  /// run without hitting the network.
  void injectRemotePrivacyPolicyVersion(String version) {
    _remotePrivacyPolicyVersion = version;
  }

  /// Quietly fetches the privacy page and extracts the version from
  /// `<meta name="privacy-policy-version" content="...">`.
  /// On failure (network timeout, parse error, non-200) it silently returns
  /// without changing any state.
  Future<void> fetchRemotePrivacyPolicyVersion() async {
    try {
      final uri = Uri.parse('https://mashiro.tech/classmate/privacy.html');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200) return;
      final body = response.body;
      final match = RegExp(
        r'<meta\s+name="privacy-policy-version"\s+content="([^"]*)"',
      ).firstMatch(body);
      if (match == null) return;
      final version = match.group(1)!.trim();
      if (version.isEmpty) return;
      if (_remotePrivacyPolicyVersion == version) return;
      _remotePrivacyPolicyVersion = version;
      notifyListeners();
    } catch (_) {
      // Network / parse / timeout — silently skip.
    }
  }

  TimetableData? get activeTimetableOrNull {
    if (_appData.timetables.isEmpty) {
      return null;
    }
    for (final item in _appData.timetables) {
      if (item.id == _appData.activeTimetableId) {
        return item;
      }
    }
    return _appData.timetables.first;
  }

  TimetableData get activeTimetable =>
      activeTimetableOrNull ?? _createFallbackTimetable();

  PeriodTimeSet? get activePeriodTimeSetOrNull {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      return _appData.periodTimeSets.isEmpty
          ? null
          : _appData.periodTimeSets.first;
    }
    return periodTimeSetForId(timetable.config.periodTimeSetId);
  }

  PeriodTimeSet get activePeriodTimeSet =>
      activePeriodTimeSetOrNull ?? _createFallbackPeriodTimeSet();

  int _currentWeekForActiveTimetable() {
    final timetable = activeTimetableOrNull;
    return timetable == null ? 1 : currentWeekFor(timetable.config);
  }

  Future<void> load() async {
    // 存储层出问题时先回退到默认数据，别让首页一直卡在启动阶段。
    if (_isLoaded || _isLoading) {
      return;
    }
    _isLoading = true;
    try {
      final fileData = await _storage.load();
      if (fileData != null) {
        _appData = _normalizeImportedAppData(fileData);
      } else {
        _appData = await _buildDefaultAppData();
        await _save();
      }
      _storagePath = await _storage.filePath();
    } catch (_) {
      _appData = await _buildDefaultAppData();
      try {
        _storagePath = await _storage.filePath();
      } catch (_) {
        _storagePath = null;
      }
    } finally {
      _selectedWeek = _currentWeekForActiveTimetable();
      _isLoaded = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  PeriodTimeSet? periodTimeSetForId(String id) {
    for (final item in _appData.periodTimeSets) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  List<TimetableData> timetablesUsingPeriodTimeSet(String periodTimeSetId) {
    return _appData.timetables
        .where((item) => item.config.periodTimeSetId == periodTimeSetId)
        .toList();
  }

  int dailyPeriodsForTimetable(TimetableData timetable) {
    return periodTimeSetForId(
          timetable.config.periodTimeSetId,
        )?.periodTimes.length ??
        1;
  }

  List<CoursePeriodTime> periodTimesForTimetable(TimetableData timetable) {
    return periodTimeSetForId(timetable.config.periodTimeSetId)?.periodTimes ??
        const [];
  }

  Future<void> switchTimetable(String timetableId) async {
    if (_appData.activeTimetableId == timetableId) {
      return;
    }
    if (!_appData.timetables.any((item) => item.id == timetableId)) {
      return;
    }
    _appData = _appData.copyWith(activeTimetableId: timetableId);
    _selectedWeek = currentWeekFor(activeTimetable.config);
    await _saveAndNotify();
  }

  Future<void> setSelectedWeek(int week) async {
    // 当前周只影响界面状态，不单独持久化，避免滑动时频繁写文件。
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      _selectedWeek = 1;
      notifyListeners();
      return;
    }
    final maxWeek = timetable.config.totalWeeks;
    final nextWeek = week.clamp(1, maxWeek);
    if (_selectedWeek == nextWeek) {
      return;
    }
    _selectedWeek = nextWeek;
    notifyListeners();
  }

  Future<void> updateTimetableConfig(TimetableConfig config) async {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      return;
    }
    await updateTimetableConfigFor(timetable.id, config);
  }

  Future<void> updateTimetableConfigFor(
    String timetableId,
    TimetableConfig config,
  ) async {
    TimetableData? timetable;
    for (final item in _appData.timetables) {
      if (item.id == timetableId) {
        timetable = item;
        break;
      }
    }
    if (timetable == null) {
      return;
    }
    final targetTimetable = timetable;
    final normalizedConfig = config.copyWith(
      totalWeeks: normalizeTimetableWeeks(config.totalWeeks),
    );
    final fallbackPeriodTimeSetId =
        periodTimeSetForId(targetTimetable.config.periodTimeSetId)?.id ??
        activePeriodTimeSet.id;
    final periodTimeSetId =
        periodTimeSetForId(normalizedConfig.periodTimeSetId)?.id ??
        fallbackPeriodTimeSetId;
    final updated = _appData.timetables
        .map(
          (item) => item.id == targetTimetable.id
              ? item.copyWith(
                  config: normalizedConfig.copyWith(
                    periodTimeSetId: periodTimeSetId,
                  ),
                )
              : item,
        )
        .toList();
    _appData = _appData.copyWith(timetables: updated);
    if (_appData.activeTimetableId == targetTimetable.id) {
      _selectedWeek = _selectedWeek.clamp(1, normalizedConfig.totalWeeks);
    }
    await _saveAndNotify();
  }

  Future<void> saveCourse(CourseItem course) async {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      return;
    }
    final courses = [...timetable.courses];
    final index = courses.indexWhere((item) => item.id == course.id);
    if (index >= 0) {
      courses[index] = course;
    } else {
      courses.add(course);
    }
    await _replaceActiveTimetable(timetable.copyWith(courses: courses));
  }

  Future<void> deleteCourse(String courseId) async {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      return;
    }
    final courses = timetable.courses
        .where((item) => item.id != courseId)
        .toList();
    final filteredPrefs = Map<String, String>.from(
      _appData.conflictDisplayCourseIds,
    )..removeWhere((_, value) => value == courseId);
    _appData = _appData.copyWith(
      timetables: _appData.timetables
          .map(
            (item) => item.id == timetable.id ? item.copyWith(courses: courses) : item,
          )
          .toList(),
      conflictDisplayCourseIds: filteredPrefs,
    );
    await _saveAndNotify();
  }

  Future<void> addTimetable() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    // 新课表默认复用当前节次时间集，避免立刻多出一份内容相同的副本。
    final fallbackSet =
        activePeriodTimeSetOrNull ?? _createFallbackPeriodTimeSet();
    final timetable = TimetableData(
      id: 'table_$now',
      config: TimetableConfig(
        name: newTimetableName(localeCode: _appData.localeCode),
        startDate: DateTime.now(),
        totalWeeks: 18,
        periodTimeSetId: fallbackSet.id,
      ),
      courses: const [],
    );

    _appData = _appData.copyWith(
      activeTimetableId: timetable.id,
      timetables: [..._appData.timetables, timetable],
    );
    _selectedWeek = 1;
    await _saveAndNotify();
  }

  Future<void> deleteTimetable(String timetableId) async {
    if (!_appData.timetables.any((item) => item.id == timetableId)) {
      return;
    }
    final remaining = _appData.timetables
        .where((item) => item.id != timetableId)
        .toList();
    final nextActiveId =
        remaining.any((item) => item.id == _appData.activeTimetableId)
        ? _appData.activeTimetableId
        : remaining.isEmpty
        ? ''
        : remaining.first.id;
    final remainingCourseIds = remaining
        .expand((item) => item.courses)
        .map((item) => item.id)
        .toSet();
    final filteredPrefs = Map<String, String>.from(
      _appData.conflictDisplayCourseIds,
    )..removeWhere((_, value) => !remainingCourseIds.contains(value));
    _appData = _appData.copyWith(
      activeTimetableId: nextActiveId,
      timetables: remaining,
      conflictDisplayCourseIds: filteredPrefs,
    );
    _selectedWeek = _currentWeekForActiveTimetable();
    await _saveAndNotify();
  }

  Future<PeriodTimeSet> addPeriodTimeSet({
    String? name,
    List<CoursePeriodTime>? periodTimes,
  }) async {
    final existingIds = _appData.periodTimeSets.map((item) => item.id).toSet();
    final nextId = _nextPeriodTimeSetId(existingIds);
    final defaultPeriodTimes = await _loadDefaultPeriodTimes();
    final normalizedTimes = buildPeriodTimesForCount(
      periodTimes == null || periodTimes.isEmpty
          ? defaultPeriodTimes.length
          : periodTimes.length,
      source: periodTimes == null || periodTimes.isEmpty
          ? defaultPeriodTimes
          : periodTimes,
    );
    final nextSet = PeriodTimeSet(
      id: nextId,
      name: (name == null || name.trim().isEmpty)
          ? newPeriodTimeSetName(localeCode: _appData.localeCode)
          : name.trim(),
      periodTimes: normalizedTimes,
    );
    _appData = _appData.copyWith(
      periodTimeSets: [..._appData.periodTimeSets, nextSet],
    );
    await _saveAndNotify();
    return nextSet;
  }

  Future<void> updatePeriodTimeSet(PeriodTimeSet periodTimeSet) async {
    final normalized = _normalizePeriodTimeSet(periodTimeSet);
    final index = _appData.periodTimeSets.indexWhere(
      (item) => item.id == normalized.id,
    );
    if (index < 0) {
      return;
    }
    final updated = [..._appData.periodTimeSets];
    updated[index] = normalized;
    _appData = _appData.copyWith(periodTimeSets: updated);
    await _saveAndNotify();
  }

  Future<void> deletePeriodTimeSet(String periodTimeSetId) async {
    final usingTimetables = timetablesUsingPeriodTimeSet(periodTimeSetId);
    if (usingTimetables.isNotEmpty) {
      throw FormatException(
        periodTimeSetInUseMessage(
          usingTimetables.length,
          localeCode: _appData.localeCode,
        ),
      );
    }
    final remaining = _appData.periodTimeSets
        .where((item) => item.id != periodTimeSetId)
        .toList();
    _appData = _appData.copyWith(periodTimeSets: remaining);
    await _saveAndNotify();
  }

  Future<void> assignPeriodTimeSetToTimetable(
    String timetableId,
    String periodTimeSetId,
  ) async {
    if (periodTimeSetForId(periodTimeSetId) == null) {
      return;
    }
    final updated = _appData.timetables
        .map(
          (item) => item.id == timetableId
              ? item.copyWith(
                  config: item.config.copyWith(
                    periodTimeSetId: periodTimeSetId,
                  ),
                )
              : item,
        )
        .toList();
    _appData = _appData.copyWith(timetables: updated);
    await _saveAndNotify();
  }

  String? displayedCourseIdForConflict(String conflictKey) =>
      _appData.conflictDisplayCourseIds[conflictKey];

  Future<void> setDisplayedCourseForConflict(
    String conflictKey,
    String courseId,
  ) async {
    final updated = Map<String, String>.from(_appData.conflictDisplayCourseIds)
      ..[conflictKey] = courseId;
    _appData = _appData.copyWith(conflictDisplayCourseIds: updated);
    await _saveAndNotify();
  }

  String exportAppDataJson() => encodeAppDataEnvelope(_appData);

  String exportSelectedTimetablesJson(List<String> timetableIds) {
    final selectedIdSet = timetableIds.toSet();
    final selectedTimetables = _appData.timetables
        .where((item) => selectedIdSet.contains(item.id))
        .toList();
    if (selectedTimetables.isEmpty) {
      throw FormatException(
        selectAtLeastOneTimetableMessage(localeCode: _appData.localeCode),
      );
    }
    final periodTimeSetIds = selectedTimetables
        .map((item) => item.config.periodTimeSetId)
        .toSet();
    final linkedSets = _appData.periodTimeSets
        .where((item) => periodTimeSetIds.contains(item.id))
        .toList();
    return encodeTimetableDataEnvelope(
      TimetableExportData(
        timetables: selectedTimetables,
        periodTimeSets: linkedSets,
      ),
    );
  }

  String exportActiveTimetableJson() {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      throw FormatException(
        noExportableTimetableMessage(localeCode: _appData.localeCode),
      );
    }
    return exportSelectedTimetablesJson([timetable.id]);
  }

  String exportActivePeriodTimesJson() =>
      encodePeriodTimesEnvelope(activePeriodTimeSet.periodTimes);

  List<TimetableData> previewImportTimetables(String source) {
    return _decodeImportCandidate(source).timetables;
  }

  Future<int> importSelectedTimetablesJson(
    String source, {
    required List<String> timetableIds,
    required TimetableImportMode mode,
    bool importBundledPeriodTimeSets = true,
    String? targetPeriodTimeSetId,
  }) async {
    final imported = _decodeImportCandidate(source);
    final manualTargetSetId = targetPeriodTimeSetId?.trim() ?? '';
    if (!importBundledPeriodTimeSets) {
      if (manualTargetSetId.isEmpty ||
          periodTimeSetForId(manualTargetSetId) == null) {
        throw FormatException(
          noPeriodTimeAvailableMessage(localeCode: _appData.localeCode),
        );
      }
    }
    final selectedIdSet = timetableIds.toSet();
    final selectedTimetables = imported.timetables
        .where((item) => selectedIdSet.contains(item.id))
        .toList();
    if (selectedTimetables.isEmpty) {
      throw FormatException(
        selectAtLeastOneTimetableMessage(localeCode: _appData.localeCode),
      );
    }

    if (mode == TimetableImportMode.replaceActive) {
      if (selectedTimetables.length != 1) {
        throw FormatException(
          replaceActiveRequiresSingleTimetableMessage(
            localeCode: _appData.localeCode,
          ),
        );
      }
      final current = activeTimetableOrNull;
      if (current == null) {
        throw FormatException(
          noActiveTimetableToReplaceMessage(localeCode: _appData.localeCode),
        );
      }
      final selected = selectedTimetables.first;
      final existingSetIds = _appData.periodTimeSets
          .map((item) => item.id)
          .toSet();
      final shouldReuseExistingSet =
          !importBundledPeriodTimeSets && manualTargetSetId.isNotEmpty;
      final copiedSet = shouldReuseExistingSet
          ? null
          : _copyImportedPeriodTimeSetWithUniqueId(
              imported.periodTimeSets.firstWhere(
                (item) => item.id == selected.config.periodTimeSetId,
                orElse: () => _createFallbackPeriodTimeSet(),
              ),
              existingSetIds,
            );
      final resolvedSetId = shouldReuseExistingSet
          ? manualTargetSetId
          : copiedSet!.id;
      final replaced = selected.copyWith(
        id: current.id,
        config: selected.config.copyWith(periodTimeSetId: resolvedSetId),
      );
      final updatedTimetables = _appData.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final nextPeriodTimeSets = copiedSet == null
          ? _appData.periodTimeSets
          : [..._appData.periodTimeSets, copiedSet];
      _appData = _appData.copyWith(
        activeTimetableId: current.id,
        timetables: updatedTimetables,
        periodTimeSets: nextPeriodTimeSets,
        courseNameColorValues: _buildCourseNameColorValuesForTimetables(
          updatedTimetables,
          existing: _appData.courseNameColorValues,
        ),
      );
      _selectedWeek = currentWeekFor(replaced.config);
      await _saveAndNotify();
      return 1;
    }

    final neededSetIds = selectedTimetables
        .map((item) => item.config.periodTimeSetId)
        .toSet();
    final selectedSets = imported.periodTimeSets
        .where((item) => neededSetIds.contains(item.id))
        .toList();
    final existingSetIds = _appData.periodTimeSets
        .map((item) => item.id)
        .toSet();
    final importedSetIdMap = <String, String>{};
    final appendedSets = importBundledPeriodTimeSets
        ? selectedSets.map((item) {
            final copied = _copyImportedPeriodTimeSetWithUniqueId(
              item,
              existingSetIds,
            );
            importedSetIdMap[item.id] = copied.id;
            return copied;
          }).toList()
        : <PeriodTimeSet>[];

    final existingTimetableIds = _appData.timetables
        .map((item) => item.id)
        .toSet();
    final appendedTimetables = selectedTimetables.map((item) {
      final mappedSetId = importBundledPeriodTimeSets
          ? (importedSetIdMap[item.config.periodTimeSetId] ??
              item.config.periodTimeSetId)
          : manualTargetSetId;
      return _copyImportedTimetableWithUniqueId(
        item.copyWith(
          config: item.config.copyWith(periodTimeSetId: mappedSetId),
        ),
        existingTimetableIds,
      );
    }).toList();

    final nextTimetables = [..._appData.timetables, ...appendedTimetables];
    _appData = _appData.copyWith(
      activeTimetableId: appendedTimetables.isEmpty
          ? _appData.activeTimetableId
          : appendedTimetables.last.id,
      timetables: nextTimetables,
      periodTimeSets: [..._appData.periodTimeSets, ...appendedSets],
      courseNameColorValues: _buildCourseNameColorValuesForTimetables(
        nextTimetables,
        existing: _appData.courseNameColorValues,
      ),
    );
    _selectedWeek = appendedTimetables.isEmpty
        ? _selectedWeek
        : currentWeekFor(appendedTimetables.last.config);
    await _saveAndNotify();
    return appendedTimetables.length;
  }

  Future<int> importAppDataJson(
    String source, {
    required AppImportMode mode,
  }) async {
    final imported = _normalizeImportedAppData(decodeAppDataEnvelope(source));
    if (mode == AppImportMode.replaceAll) {
      _appData = imported;
      _selectedWeek = _currentWeekForActiveTimetable();
      await _saveAndNotify();
      return imported.timetables.length;
    }

    return importSelectedTimetablesJson(
      source,
      timetableIds: imported.timetables.map((item) => item.id).toList(),
      mode: TimetableImportMode.addAsNew,
    );
  }

  Future<String> importTimetableJson(
    String source, {
    required TimetableImportMode mode,
    bool importBundledPeriodTimeSets = true,
    String? targetPeriodTimeSetId,
  }) async {
    final imported = _decodeImportCandidate(source);
    final selected = imported.timetables.first;
    await importSelectedTimetablesJson(
      source,
      timetableIds: [selected.id],
      mode: mode,
      importBundledPeriodTimeSets: importBundledPeriodTimeSets,
      targetPeriodTimeSetId: targetPeriodTimeSetId,
    );
    return selected.config.name;
  }

  Future<void> applySchoolImportRequest(
    SchoolImportApplyRequest request,
  ) async {
    final manualTargetSetId = request.targetPeriodTimeSetId?.trim() ?? '';
    if (!request.importBundledPeriodTimeSet) {
      if (manualTargetSetId.isEmpty || periodTimeSetForId(manualTargetSetId) == null) {
        throw FormatException(
          noPeriodTimeAvailableMessage(localeCode: _appData.localeCode),
        );
      }
    }

    final existingSetIds = _appData.periodTimeSets.map((item) => item.id).toSet();
    final bundledPeriodTimeSet = request.importBundledPeriodTimeSet
        ? _copyImportedPeriodTimeSetWithUniqueId(
            _buildImportedSchoolPeriodTimeSet(request.response),
            existingSetIds,
          )
        : null;
    final resolvedPeriodTimeSet =
        bundledPeriodTimeSet ?? periodTimeSetForId(manualTargetSetId);
    if (resolvedPeriodTimeSet == null) {
      throw FormatException(
        noPeriodTimeAvailableMessage(localeCode: _appData.localeCode),
      );
    }
    final timetable = _buildSchoolImportedTimetable(
      request.response,
      periodTimeSet: resolvedPeriodTimeSet,
    );

    if (request.mode == TimetableImportMode.replaceActive) {
      final current = activeTimetableOrNull;
      if (current == null) {
        throw FormatException(
          noActiveTimetableToReplaceMessage(localeCode: _appData.localeCode),
        );
      }
      final replaced = timetable.copyWith(id: current.id);
      final updatedTimetables = _appData.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final nextPeriodTimeSets = bundledPeriodTimeSet == null
          ? _appData.periodTimeSets
          : [..._appData.periodTimeSets, bundledPeriodTimeSet];
      _appData = _appData.copyWith(
        activeTimetableId: current.id,
        timetables: updatedTimetables,
        periodTimeSets: nextPeriodTimeSets,
        courseNameColorValues: _buildCourseNameColorValuesForTimetables(
          updatedTimetables,
          existing: _appData.courseNameColorValues,
        ),
      );
      _selectedWeek = currentWeekFor(replaced.config);
      await _saveAndNotify();
      return;
    }

    final nextTimetables = [..._appData.timetables, timetable];
    final nextPeriodTimeSets = bundledPeriodTimeSet == null
        ? _appData.periodTimeSets
        : [..._appData.periodTimeSets, bundledPeriodTimeSet];
    _appData = _appData.copyWith(
      activeTimetableId: timetable.id,
      timetables: nextTimetables,
      periodTimeSets: nextPeriodTimeSets,
      courseNameColorValues: _buildCourseNameColorValuesForTimetables(
        nextTimetables,
        existing: _appData.courseNameColorValues,
      ),
    );
    _selectedWeek = currentWeekFor(timetable.config);
    await _saveAndNotify();
  }

  (int, int) _resolveImportedCourseTimeRange(
    List<CoursePeriodTime> periodTimes,
    List<int> periods,
    int startMinutes,
    int endMinutes,
  ) {
    if (startMinutes > 0 && endMinutes > startMinutes) {
      return (startMinutes, endMinutes);
    }
    if (periods.isEmpty || periodTimes.isEmpty) {
      return (startMinutes, endMinutes);
    }

    final matchedSlots = periodTimes
        .where((slot) => periods.contains(slot.index))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    if (matchedSlots.isEmpty) {
      return (startMinutes, endMinutes);
    }

    return (matchedSlots.first.startMinutes, matchedSlots.last.endMinutes);
  }

  PeriodTimeSet _buildImportedSchoolPeriodTimeSet(
    SchoolImportResponse response,
  ) {
    final draft = response.timetable.periodTimeSet;
    final timetableName = response.timetable.name.trim().isEmpty
        ? untitledTimetableName(localeCode: _appData.localeCode)
        : response.timetable.name.trim();
    return PeriodTimeSet(
      id: '',
      name: draft.name.trim().isEmpty
          ? importedPeriodTimeSetName(
              timetableName,
              localeCode: _appData.localeCode,
            )
          : draft.name.trim(),
      periodTimes: draft.periodTimes
          .map(
            (item) => CoursePeriodTime(
              index: item.index,
              startMinutes: item.startMinutes,
              endMinutes: item.endMinutes,
            ),
          )
          .toList(),
    );
  }

  TimetableData _buildSchoolImportedTimetable(
    SchoolImportResponse response, {
    required PeriodTimeSet periodTimeSet,
  }) {
    final draft = response.timetable;
    var courseSeed = DateTime.now().microsecondsSinceEpoch;
    final courses = draft.courses.map((item) {
      final rawStartMinutes = item.startMinutes;
      final rawEndMinutes = item.endMinutes;
      final periods = item.periods.isEmpty
          ? matchPeriodsForTimeRange(
              periodTimeSet.periodTimes,
              rawStartMinutes,
              rawEndMinutes,
            )
          : item.periods;
      final resolvedTimeRange = _resolveImportedCourseTimeRange(
        periodTimeSet.periodTimes,
        periods,
        rawStartMinutes,
        rawEndMinutes,
      );
      final startMinutes = resolvedTimeRange.$1;
      final endMinutes = resolvedTimeRange.$2;
      return CourseItem(
        id: 'school_course_${courseSeed++}',
        name: item.name.trim(),
        teacher: item.teacher.trim(),
        location: item.location.trim(),
        dayOfWeek: normalizeDayOfWeek(item.dayOfWeek),
        semesterWeeks: normalizeSemesterWeeks(item.semesterWeeks),
        periods: periods,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        timeRange: buildTimeRange(startMinutes, endMinutes),
        credit: item.credit,
        remarks: item.remarks.trim(),
        customFields: Map<String, dynamic>.from(item.customFields),
      );
    }).toList();
    final timetableName = draft.name.trim().isEmpty
        ? untitledTimetableName(localeCode: _appData.localeCode)
        : draft.name.trim();
    return TimetableData(
      id: 'school_import_table_${DateTime.now().microsecondsSinceEpoch}',
      config: TimetableConfig(
        name: timetableName,
        startDate: normalizeDateOnly(draft.startDate),
        totalWeeks: normalizeTimetableWeeks(draft.totalWeeks),
        periodTimeSetId: periodTimeSet.id,
      ),
      courses: courses,
    );
  }

  List<CoursePeriodTime> importPeriodTimesJson(String source) {
    final periodTimes = decodePeriodTimesEnvelope(
      source,
      localeCode: _appData.localeCode,
    );
    if (periodTimes.isEmpty) {
      throw FormatException(
        noPeriodTimesInImportMessage(localeCode: _appData.localeCode),
      );
    }
    return List.generate(
      periodTimes.length,
      (index) => periodTimes[index].copyWith(index: index + 1),
    );
  }

  Future<List<CoursePeriodTime>> _loadDefaultPeriodTimes() async {
    try {
      final source = await rootBundle.loadString(defaultPeriodTimesAssetPath);
      return importPeriodTimesJson(source);
    } catch (_) {
      return buildDefaultPeriodTimes();
    }
  }

  Future<AppData> _buildDefaultAppData() async {
    final periodTimes = await _loadDefaultPeriodTimes();
    return _normalizeImportedAppData(
      buildInitialAppData(
        periodTimes,
        localeCode: _systemLocaleCodeResolver(),
      ),
    );
  }

  Future<void> updateCloseCoursePopupOnOutsideTap(bool value) async {
    if (_appData.closeCoursePopupOnOutsideTap == value) {
      return;
    }
    _appData = _appData.copyWith(closeCoursePopupOnOutsideTap: value);
    await _saveAndNotify();
  }

  Future<void> updatePreserveTimetableGaps(bool value) async {
    if (_appData.preserveTimetableGaps == value) {
      return;
    }
    _appData = _appData.copyWith(preserveTimetableGaps: value);
    await _saveAndNotify();
  }

  Future<void> updateShowPastEndedCourses(bool value) async {
    if (_appData.showPastEndedCourses == value) {
      return;
    }
    _appData = _appData.copyWith(showPastEndedCourses: value);
    await _saveAndNotify();
  }

  Future<void> updateShowFutureCourses(bool value) async {
    if (_appData.showFutureCourses == value) {
      return;
    }
    _appData = _appData.copyWith(showFutureCourses: value);
    await _saveAndNotify();
  }

  Future<void> updateShowTimetableGridLines(bool value) async {
    if (_appData.showTimetableGridLines == value) {
      return;
    }
    _appData = _appData.copyWith(showTimetableGridLines: value);
    await _saveAndNotify();
  }

  Future<void> updateLocaleCode(String localeCode) async {
    final normalized = app_locale.normalizeLocaleCode(localeCode);
    if (_appData.localeCode == normalized) {
      return;
    }
    _appData = _appData.copyWith(localeCode: normalized);
    await _saveAndNotify();
  }

  Future<void> updateThemeMode(String themeMode) async {
    final normalized = normalizeThemeMode(themeMode);
    if (_appData.themeMode == normalized) {
      return;
    }
    _appData = _appData.copyWith(themeMode: normalized);
    await _saveAndNotify();
  }

  Future<void> updateThemeSeedColorValue(int colorValue) async {
    if (_appData.themeSeedColorValue == colorValue) {
      return;
    }
    _appData = _appData.copyWith(themeSeedColorValue: colorValue);
    await _saveAndNotify();
  }

  Future<void> updateThemeColorMode(String mode) async {
    final normalized = normalizeThemeColorMode(mode);
    if (_appData.themeColorMode == normalized) {
      return;
    }
    _appData = _appData.copyWith(themeColorMode: normalized);
    await _saveAndNotify();
  }

  Future<void> updateColorfulUiColorValue(String key, int colorValue) async {
    final normalizedKey = key.trim();
    if (normalizedKey.isEmpty) {
      return;
    }
    if (_appData.colorfulUiColorValues[normalizedKey] == colorValue) {
      return;
    }
    final updated = Map<String, int>.from(_appData.colorfulUiColorValues)
      ..[normalizedKey] = colorValue;
    _appData = _appData.copyWith(colorfulUiColorValues: updated);
    await _saveAndNotify();
  }

  Future<void> updateColorfulCourseTextColorMode(String mode) async {
    final normalized = normalizeColorfulCourseTextColorMode(mode);
    if (_appData.colorfulCourseTextColorMode == normalized) {
      return;
    }
    _appData = _appData.copyWith(colorfulCourseTextColorMode: normalized);
    await _saveAndNotify();
  }

  Future<void> updateCourseNameColorValue(String courseName, int colorValue) async {
    final normalizedCourseName = normalizeCourseColorName(courseName);
    if (normalizedCourseName.isEmpty) {
      return;
    }
    if (_appData.courseNameColorValues[normalizedCourseName] == colorValue) {
      return;
    }
    final updated = Map<String, int>.from(_appData.courseNameColorValues)
      ..[normalizedCourseName] = colorValue;
    _appData = _appData.copyWith(courseNameColorValues: updated);
    await _saveAndNotify();
  }

  Future<void> updateSchoolImportParserSource(String source) async {
    final normalized = normalizeSchoolImportParserSource(source);
    if (_appData.schoolImportParserSettings.source == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      schoolImportParserSettings: _appData.schoolImportParserSettings.copyWith(
        source: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportBaseUrl(String value) async {
    final normalized = value.trim();
    if (_appData.schoolImportParserSettings.customBaseUrl == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      schoolImportParserSettings: _appData.schoolImportParserSettings.copyWith(
        customBaseUrl: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportApiKey(String value) async {
    final normalized = value.trim();
    if (_appData.schoolImportParserSettings.customApiKey == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      schoolImportParserSettings: _appData.schoolImportParserSettings.copyWith(
        customApiKey: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportModel(String value) async {
    final normalized = value.trim();
    if (_appData.schoolImportParserSettings.customModel == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      schoolImportParserSettings: _appData.schoolImportParserSettings.copyWith(
        customModel: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportPrompt(String value) async {
    final normalized = value.trim();
    if (_appData.schoolImportParserSettings.customPrompt == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      schoolImportParserSettings: _appData.schoolImportParserSettings.copyWith(
        customPrompt: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateSchoolImportParserSettings(
    SchoolImportParserSettings settings,
  ) async {
    final normalized = settings.copyWith();
    final current = _appData.schoolImportParserSettings;
    if (current.source == normalized.source &&
        current.customBaseUrl == normalized.customBaseUrl &&
        current.customApiKey == normalized.customApiKey &&
        current.customModel == normalized.customModel &&
        current.customPrompt == normalized.customPrompt) {
      return;
    }
    _appData = _appData.copyWith(schoolImportParserSettings: normalized);
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineColorValue(int colorValue) async {
    if (_appData.liveCourseOutlineColorValue == colorValue) {
      return;
    }
    _appData = _appData.copyWith(liveCourseOutlineColorValue: colorValue);
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineEnabled(bool value) async {
    if (_appData.liveCourseOutlineEnabled == value) {
      return;
    }
    _appData = _appData.copyWith(liveCourseOutlineEnabled: value);
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineFollowTheme(bool value) async {
    if (_appData.liveCourseOutlineFollowTheme == value) {
      return;
    }
    _appData = _appData.copyWith(liveCourseOutlineFollowTheme: value);
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineSettings({
    required bool enabled,
    required bool followTheme,
    required int colorValue,
    required bool customColorInitialized,
    required String mode,
    required double width,
  }) async {
    final normalizedWidth = normalizeLiveCourseOutlineWidth(width);
    final normalizedMode = normalizeLiveCourseOutlineMode(mode);
    final nextData = _appData.copyWith(
      liveCourseOutlineEnabled: enabled,
      liveCourseOutlineFollowTheme: followTheme,
      liveCourseOutlineColorValue: colorValue,
      liveCourseOutlineCustomColorInitialized: customColorInitialized,
      liveCourseOutlineMode: normalizedMode,
      liveCourseOutlineWidth: normalizedWidth,
    );
    if (nextData.liveCourseOutlineEnabled == _appData.liveCourseOutlineEnabled &&
        nextData.liveCourseOutlineFollowTheme ==
            _appData.liveCourseOutlineFollowTheme &&
        nextData.liveCourseOutlineColorValue ==
            _appData.liveCourseOutlineColorValue &&
        nextData.liveCourseOutlineCustomColorInitialized ==
            _appData.liveCourseOutlineCustomColorInitialized &&
        nextData.liveCourseOutlineMode == _appData.liveCourseOutlineMode &&
        nextData.liveCourseOutlineWidth == _appData.liveCourseOutlineWidth) {
      return;
    }
    _appData = nextData;
    await _saveAndNotify();
  }

  Future<void> acceptPrivacyPolicyCurrentVersion() async {
    final active = _remotePrivacyPolicyVersion;
    if (active == null) return;
    if (_appData.privacyPolicyAcceptedVersion == active) return;
    _appData = _appData.copyWith(
      privacyPolicyAcceptedVersion: active,
      privacyPolicyAcceptedAtIso: DateTime.now().toIso8601String(),
    );
    await _saveAndNotify();
  }

  Future<void> ignoreUpdateVersion(String version) async {
    final normalized = version.trim();
    if (normalized.isEmpty || _appData.ignoredUpdateVersion == normalized) {
      return;
    }
    _appData = _appData.copyWith(ignoredUpdateVersion: normalized);
    await _saveAndNotify();
  }

  Future<void> updateAvailableUpdateVersion(String? version) async {
    final normalized = version?.trim();
    final nextValue = normalized == null || normalized.isEmpty ? null : normalized;
    if (_appData.availableUpdateVersion == nextValue) {
      return;
    }
    _appData = _appData.copyWith(availableUpdateVersion: nextValue);
    await _saveAndNotify();
  }

  Future<void> _replaceActiveTimetable(TimetableData timetable) async {
    final updated = _appData.timetables
        .map((item) => item.id == timetable.id ? timetable : item)
        .toList();
    _appData = _appData.copyWith(
      timetables: updated,
      courseNameColorValues: _buildCourseNameColorValuesForTimetables(
        updated,
        existing: _appData.courseNameColorValues,
      ),
    );
    await _saveAndNotify();
  }

  Map<String, int> _buildCourseNameColorValuesForTimetables(
    List<TimetableData> timetables, {
    Map<String, int>? existing,
  }) {
    final courseNames = <String>{};
    for (final timetable in timetables) {
      for (final course in timetable.courses) {
        final normalizedName = normalizeCourseColorName(course.name);
        if (normalizedName.isNotEmpty) {
          courseNames.add(normalizedName);
        }
      }
    }

    final result = <String, int>{};
    final usedColors = <int>{};
    for (final entry in (existing ?? const <String, int>{}).entries) {
      final normalizedName = normalizeCourseColorName(entry.key);
      if (normalizedName.isEmpty || !courseNames.contains(normalizedName)) {
        continue;
      }
      final colorValue = entry.value;
      if (usedColors.contains(colorValue) &&
          _colorfulCoursePalette.contains(colorValue)) {
        continue;
      }
      result[normalizedName] = colorValue;
      usedColors.add(colorValue);
    }

    for (final courseName in courseNames.toList()..sort()) {
      if (result.containsKey(courseName)) {
        continue;
      }
      final colorValue = _pickNextCourseColorValue(usedColors);
      result[courseName] = colorValue;
      usedColors.add(colorValue);
    }
    return result;
  }

  int _pickNextCourseColorValue(Set<int> usedColors) {
    for (final colorValue in _colorfulCoursePalette) {
      if (!usedColors.contains(colorValue)) {
        return colorValue;
      }
    }
    return _colorfulCoursePalette[usedColors.length % _colorfulCoursePalette.length];
  }

  AppData _normalizeImportedAppData(AppData data) {
    final normalizedSets = <PeriodTimeSet>[];
    final normalizedSetIds = <String>{};
    for (final item in data.periodTimeSets) {
      final normalized = _normalizePeriodTimeSet(item);
      final nextId =
          normalized.id.trim().isEmpty ||
              normalizedSetIds.contains(normalized.id)
          ? _nextPeriodTimeSetId(normalizedSetIds)
          : normalized.id;
      normalizedSetIds.add(nextId);
      normalizedSets.add(normalized.copyWith(id: nextId));
    }

    final normalizedTimetables = <TimetableData>[];
    for (final item in data.timetables) {
      var periodTimeSetId = item.config.periodTimeSetId.trim();
      if (periodTimeSetId.isEmpty ||
          !normalizedSetIds.contains(periodTimeSetId)) {
        final fallbackSet = _createImportedFallbackPeriodTimeSet(
          item,
          normalizedSetIds,
        );
        normalizedSets.add(fallbackSet);
        normalizedSetIds.add(fallbackSet.id);
        periodTimeSetId = fallbackSet.id;
      }
      normalizedTimetables.add(
        item.copyWith(
          config: item.config.copyWith(
            totalWeeks: normalizeTimetableWeeks(item.config.totalWeeks),
            periodTimeSetId: periodTimeSetId,
          ),
        ),
      );
    }

    final activeId =
        normalizedTimetables.any((item) => item.id == data.activeTimetableId)
        ? data.activeTimetableId
        : normalizedTimetables.isEmpty
        ? ''
        : normalizedTimetables.first.id;
    final remainingCourseIds = normalizedTimetables
        .expand((item) => item.courses)
        .map((item) => item.id)
        .toSet();
    final filteredPrefs = Map<String, String>.from(
      data.conflictDisplayCourseIds,
    )..removeWhere((_, value) => !remainingCourseIds.contains(value));
    return data.copyWith(
      activeTimetableId: activeId,
      timetables: normalizedTimetables,
      periodTimeSets: normalizedSets,
      conflictDisplayCourseIds: filteredPrefs,
      localeCode: app_locale.normalizeLocaleCode(data.localeCode),
      themeColorMode: normalizeThemeColorMode(data.themeColorMode),
      courseNameColorValues: _buildCourseNameColorValuesForTimetables(
        normalizedTimetables,
        existing: data.courseNameColorValues,
      ),
    );
  }

  TimetableExportData _decodeImportCandidate(String source) {
    final envelope = ImportExportEnvelope.decode(source);
    if (envelope.version > importExportVersion) {
      throw FormatException(
        importFileVersionUnsupportedMessage(localeCode: _appData.localeCode),
      );
    }
    switch (envelope.schema) {
      case timetableDataSchema:
        return _normalizeImportedTimetableExport(
          TimetableExportData.fromJson(
            envelope.data,
            localeCode: _appData.localeCode,
          ),
        );
      case appDataSchema:
        final appData = _normalizeImportedAppData(
          AppData.fromJson({
            ...envelope.data,
            'localeCode': _appData.localeCode,
          }),
        );
        return TimetableExportData(
          timetables: appData.timetables,
          periodTimeSets: appData.periodTimeSets,
        );
      default:
        throw FormatException(
          importFileTypeMismatchMessage(localeCode: _appData.localeCode),
        );
    }
  }

  TimetableExportData _normalizeImportedTimetableExport(
    TimetableExportData data,
  ) {
    final normalizedSets = <PeriodTimeSet>[];
    final setIds = <String>{};
    for (final item in data.periodTimeSets) {
      final normalized = _normalizePeriodTimeSet(item);
      final nextId =
          normalized.id.trim().isEmpty || setIds.contains(normalized.id)
          ? _nextPeriodTimeSetId(setIds)
          : normalized.id;
      setIds.add(nextId);
      normalizedSets.add(normalized.copyWith(id: nextId));
    }

    final normalizedTimetables = <TimetableData>[];
    for (final item in data.timetables) {
      var timetable = item.copyWith(
        config: item.config.copyWith(
          totalWeeks: normalizeTimetableWeeks(item.config.totalWeeks),
        ),
      );
      if (normalizedSets.isEmpty ||
          !setIds.contains(timetable.config.periodTimeSetId)) {
        final fallbackSet = _createImportedFallbackPeriodTimeSet(
          timetable,
          setIds,
        );
        normalizedSets.add(fallbackSet);
        setIds.add(fallbackSet.id);
        timetable = timetable.copyWith(
          config: timetable.config.copyWith(periodTimeSetId: fallbackSet.id),
        );
      }
      normalizedTimetables.add(timetable);
    }

    return TimetableExportData(
      timetables: normalizedTimetables,
      periodTimeSets: normalizedSets,
    );
  }

  PeriodTimeSet _createImportedFallbackPeriodTimeSet(
    TimetableData timetable,
    Set<String> existingIds,
  ) {
    final fallbackId = _nextPeriodTimeSetId(existingIds);
    return PeriodTimeSet(
      id: fallbackId,
      name: importedPeriodTimeSetName(
        timetable.config.name,
        localeCode: _appData.localeCode,
      ),
      periodTimes: buildPeriodTimesForCount(10),
    );
  }

  PeriodTimeSet _copyImportedPeriodTimeSetWithUniqueId(
    PeriodTimeSet periodTimeSet,
    Set<String> existingIds,
  ) {
    var nextId = periodTimeSet.id.trim();
    if (nextId.isEmpty || existingIds.contains(nextId)) {
      nextId = _nextPeriodTimeSetId(existingIds);
    }
    existingIds.add(nextId);
    return _normalizePeriodTimeSet(periodTimeSet.copyWith(id: nextId));
  }

  TimetableData _copyImportedTimetableWithUniqueId(
    TimetableData timetable,
    Set<String> existingIds,
  ) {
    var nextId = timetable.id.trim();
    if (nextId.isEmpty || existingIds.contains(nextId)) {
      nextId = _nextImportedTimetableId(existingIds);
    }
    existingIds.add(nextId);
    return timetable.copyWith(id: nextId);
  }

  String _nextImportedTimetableId(Set<String> existingIds) {
    var stamp = DateTime.now().microsecondsSinceEpoch;
    var candidate = 'table_import_$stamp';
    while (existingIds.contains(candidate)) {
      stamp += 1;
      candidate = 'table_import_$stamp';
    }
    return candidate;
  }

  String _nextPeriodTimeSetId(Set<String> existingIds) {
    var stamp = DateTime.now().microsecondsSinceEpoch;
    var candidate = 'period_set_$stamp';
    while (existingIds.contains(candidate)) {
      stamp += 1;
      candidate = 'period_set_$stamp';
    }
    return candidate;
  }

  PeriodTimeSet _normalizePeriodTimeSet(PeriodTimeSet periodTimeSet) {
    final normalizedTimes = buildPeriodTimesForCount(
      periodTimeSet.periodTimes.isEmpty ? 1 : periodTimeSet.periodTimes.length,
      source: periodTimeSet.periodTimes,
    );
    return periodTimeSet.copyWith(
      name: periodTimeSet.name.trim().isEmpty
          ? periodTimeSetFallbackName(localeCode: _appData.localeCode)
          : periodTimeSet.name.trim(),
      periodTimes: normalizedTimes,
    );
  }

  Future<void> _saveAndNotify() async {
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    _appData = _normalizeImportedAppData(_appData);
    await _storage.save(_appData);
  }

  TimetableData _createFallbackTimetable() {
    return TimetableData(
      id: '',
      config: TimetableConfig(
        name: emptyTimetableName(localeCode: _appData.localeCode),
        startDate: DateTime.now(),
        totalWeeks: 1,
        periodTimeSetId: '',
      ),
      courses: const [],
    );
  }

  PeriodTimeSet _createFallbackPeriodTimeSet() {
    return PeriodTimeSet(
      id: '',
      name: defaultPeriodTimeSetName(localeCode: _appData.localeCode),
      periodTimes: const [
        CoursePeriodTime(
          index: 1,
          startMinutes: 8 * 60,
          endMinutes: (8 * 60) + 45,
        ),
      ],
    );
  }
}
