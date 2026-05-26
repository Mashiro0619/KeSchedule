import '../l10n/app_locale.dart' as app_locale;
import '../models/school_import_models.dart';
import '../models/timetable_models.dart';
import 'general_calendar_ics_service.dart';
import 'student_timetable_service.dart' as student_timetable;

class GeneralScheduleImportResult {
  const GeneralScheduleImportResult({
    required this.importedCount,
    required this.scheduleNames,
    this.icsWarnings = const [],
  });

  final int importedCount;
  final List<String> scheduleNames;
  final List<GeneralCalendarIcsImportWarning> icsWarnings;

  bool get hasWarnings => icsWarnings.isNotEmpty;
}

class GeneralScheduleImportMutation {
  const GeneralScheduleImportMutation({
    required this.data,
    required this.result,
  });

  final GeneralScheduleData data;
  final GeneralScheduleImportResult result;
}

class StudentTimetableImportMutation {
  const StudentTimetableImportMutation({
    required this.data,
    required this.importedCount,
    this.selectedTimetable,
  });

  final StudentModeData data;
  final int importedCount;
  final TimetableData? selectedTimetable;
}

/// Import/export transformations that are independent from provider state.
///
/// This service intentionally keeps student and general data-transfer semantics
/// separate; general calendars never reuse the student timetable envelope.
class ImportExportService {
  const ImportExportService({
    GeneralCalendarIcsService icsService = const GeneralCalendarIcsService(),
  }) : _icsService = icsService;

  final GeneralCalendarIcsService _icsService;

  String exportAppDataJson(AppData data) => encodeAppDataEnvelope(data);

  String exportSelectedTimetablesJson(
    StudentModeData data,
    List<String> timetableIds, {
    required String localeCode,
  }) {
    final selectedIdSet = timetableIds.toSet();
    final selectedTimetables = data.timetables
        .where((item) => selectedIdSet.contains(item.id))
        .toList();
    if (selectedTimetables.isEmpty) {
      throw FormatException(
        selectAtLeastOneTimetableMessage(localeCode: localeCode),
      );
    }
    final periodTimeSetIds = selectedTimetables
        .map((item) => item.config.periodTimeSetId)
        .toSet();
    final linkedSets = data.periodTimeSets
        .where((item) => periodTimeSetIds.contains(item.id))
        .toList();
    return encodeTimetableDataEnvelope(
      TimetableExportData(
        timetables: selectedTimetables,
        periodTimeSets: linkedSets,
      ),
    );
  }

  String exportPeriodTimesJson(List<CoursePeriodTime> periodTimes) {
    return encodePeriodTimesEnvelope(periodTimes);
  }

  List<CoursePeriodTime> importPeriodTimesJson(
    String source, {
    required String localeCode,
  }) {
    final periodTimes = decodePeriodTimesEnvelope(
      source,
      localeCode: localeCode,
    );
    if (periodTimes.isEmpty) {
      throw FormatException(
        noPeriodTimesInImportMessage(localeCode: localeCode),
      );
    }
    return List.generate(
      periodTimes.length,
      (index) => periodTimes[index].copyWith(index: index + 1),
    );
  }

  List<TimetableData> previewImportTimetables(
    String source, {
    required String localeCode,
  }) {
    return decodeStudentImportCandidate(
      source,
      localeCode: localeCode,
    ).timetables;
  }

  TimetableExportData decodeStudentImportCandidate(
    String source, {
    required String localeCode,
  }) {
    final envelope = ImportExportEnvelope.decode(source);
    if (envelope.version > importExportVersion) {
      throw FormatException(
        importFileVersionUnsupportedMessage(localeCode: localeCode),
      );
    }
    if (isImportExportSchema(envelope.schema, timetableDataSchema)) {
      return normalizeTimetableExportData(
        TimetableExportData.fromJson(envelope.data, localeCode: localeCode),
        localeCode: localeCode,
      );
    }
    if (isImportExportSchema(envelope.schema, appDataSchema)) {
      _ensureStudentImportAppDataShape(envelope.data);
      final appData = normalizeAppData(
        AppData.fromJson({...envelope.data, 'localeCode': localeCode}),
        localeCode: localeCode,
      );
      return TimetableExportData(
        timetables: appData.studentMode.timetables,
        periodTimeSets: appData.studentMode.periodTimeSets,
      );
    }
    throw FormatException(
      importFileTypeMismatchMessage(localeCode: localeCode),
    );
  }

  StudentTimetableImportMutation importSelectedTimetablesJson(
    StudentModeData data,
    String source, {
    required List<String> timetableIds,
    required TimetableImportMode mode,
    required String localeCode,
    bool importBundledPeriodTimeSets = true,
    String? targetPeriodTimeSetId,
  }) {
    final imported = decodeStudentImportCandidate(
      source,
      localeCode: localeCode,
    );
    final manualTargetSetId = targetPeriodTimeSetId?.trim() ?? '';
    if (!importBundledPeriodTimeSets) {
      if (manualTargetSetId.isEmpty ||
          _periodTimeSetForId(data, manualTargetSetId) == null) {
        throw FormatException(
          noPeriodTimeAvailableMessage(localeCode: localeCode),
        );
      }
    }
    final selectedIdSet = timetableIds.toSet();
    final selectedTimetables = imported.timetables
        .where((item) => selectedIdSet.contains(item.id))
        .toList();
    if (selectedTimetables.isEmpty) {
      throw FormatException(
        selectAtLeastOneTimetableMessage(localeCode: localeCode),
      );
    }

    if (mode == TimetableImportMode.replaceActive) {
      if (selectedTimetables.length != 1) {
        throw FormatException(
          replaceActiveRequiresSingleTimetableMessage(localeCode: localeCode),
        );
      }
      final current = _activeTimetable(data);
      if (current == null) {
        throw FormatException(
          noActiveTimetableToReplaceMessage(localeCode: localeCode),
        );
      }
      final selected = selectedTimetables.first;
      final existingSetIds = data.periodTimeSets.map((item) => item.id).toSet();
      final shouldReuseExistingSet =
          !importBundledPeriodTimeSets && manualTargetSetId.isNotEmpty;
      final copiedSet = shouldReuseExistingSet
          ? null
          : _copyImportedPeriodTimeSetWithUniqueId(
              imported.periodTimeSets.firstWhere(
                (item) => item.id == selected.config.periodTimeSetId,
                orElse: () =>
                    _createFallbackPeriodTimeSet(localeCode: localeCode),
              ),
              existingSetIds,
              localeCode: localeCode,
            );
      final resolvedSetId = shouldReuseExistingSet
          ? manualTargetSetId
          : copiedSet!.id;
      final existingCourseIds = _courseIdsForTimetables(
        data.timetables,
        excludingTimetableId: current.id,
      );
      final replaced = _normalizeTimetable(
        selected,
        id: current.id,
        courseIds: existingCourseIds,
        config: selected.config.copyWith(periodTimeSetId: resolvedSetId),
      );
      final updatedTimetables = data.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final filteredPrefs = _filterConflictDisplayCourseIds(
        Map<String, String>.from(data.conflictDisplayCourseIds)..removeWhere(
          (key, _) => _conflictKeyContainsTimetable(key, current.id),
        ),
        updatedTimetables,
      );
      final nextPeriodTimeSets = copiedSet == null
          ? data.periodTimeSets
          : [...data.periodTimeSets, copiedSet];
      return StudentTimetableImportMutation(
        data: data.copyWith(
          activeTimetableId: current.id,
          timetables: updatedTimetables,
          periodTimeSets: nextPeriodTimeSets,
          conflictDisplayCourseIds: filteredPrefs,
          courseNameColorValues: buildCourseNameColorValuesForTimetables(
            updatedTimetables,
            existing: data.courseNameColorValues,
          ),
        ),
        importedCount: 1,
        selectedTimetable: replaced,
      );
    }

    final neededSetIds = selectedTimetables
        .map((item) => item.config.periodTimeSetId)
        .toSet();
    final selectedSets = imported.periodTimeSets
        .where((item) => neededSetIds.contains(item.id))
        .toList();
    final existingSetIds = data.periodTimeSets.map((item) => item.id).toSet();
    final importedSetIdMap = <String, String>{};
    final appendedSets = importBundledPeriodTimeSets
        ? selectedSets.map((item) {
            final copied = _copyImportedPeriodTimeSetWithUniqueId(
              item,
              existingSetIds,
              localeCode: localeCode,
            );
            importedSetIdMap[item.id] = copied.id;
            return copied;
          }).toList()
        : <PeriodTimeSet>[];

    final existingTimetableIds = data.timetables.map((item) => item.id).toSet();
    final existingCourseIds = _courseIdsForTimetables(data.timetables);
    final appendedTimetables = selectedTimetables.map((item) {
      final mappedSetId = importBundledPeriodTimeSets
          ? (importedSetIdMap[item.config.periodTimeSetId] ??
                item.config.periodTimeSetId)
          : manualTargetSetId;
      final copied = _copyImportedTimetableWithUniqueId(
        item.copyWith(
          config: item.config.copyWith(periodTimeSetId: mappedSetId),
        ),
        existingTimetableIds,
      );
      return _normalizeTimetable(
        copied,
        id: copied.id,
        courseIds: existingCourseIds,
        config: copied.config,
      );
    }).toList();

    final nextTimetables = [...data.timetables, ...appendedTimetables];
    return StudentTimetableImportMutation(
      data: data.copyWith(
        activeTimetableId: appendedTimetables.isEmpty
            ? data.activeTimetableId
            : appendedTimetables.last.id,
        timetables: nextTimetables,
        periodTimeSets: [...data.periodTimeSets, ...appendedSets],
        courseNameColorValues: buildCourseNameColorValuesForTimetables(
          nextTimetables,
          existing: data.courseNameColorValues,
        ),
      ),
      importedCount: appendedTimetables.length,
      selectedTimetable: appendedTimetables.isEmpty
          ? null
          : appendedTimetables.last,
    );
  }

  StudentTimetableImportMutation applySchoolImportRequest(
    StudentModeData data,
    SchoolImportApplyRequest request, {
    required String localeCode,
  }) {
    final manualTargetSetId = request.targetPeriodTimeSetId?.trim() ?? '';
    if (!request.importBundledPeriodTimeSet) {
      if (manualTargetSetId.isEmpty ||
          _periodTimeSetForId(data, manualTargetSetId) == null) {
        throw FormatException(
          noPeriodTimeAvailableMessage(localeCode: localeCode),
        );
      }
    }

    final existingSetIds = data.periodTimeSets.map((item) => item.id).toSet();
    final bundledPeriodTimeSet = request.importBundledPeriodTimeSet
        ? _copyImportedPeriodTimeSetWithUniqueId(
            _buildImportedSchoolPeriodTimeSet(
              request.response,
              localeCode: localeCode,
            ),
            existingSetIds,
            localeCode: localeCode,
          )
        : null;
    final resolvedPeriodTimeSet =
        bundledPeriodTimeSet ?? _periodTimeSetForId(data, manualTargetSetId);
    if (resolvedPeriodTimeSet == null) {
      throw FormatException(
        noPeriodTimeAvailableMessage(localeCode: localeCode),
      );
    }
    final timetable = _buildSchoolImportedTimetable(
      request.response,
      periodTimeSet: resolvedPeriodTimeSet,
      localeCode: localeCode,
    );

    if (request.mode == TimetableImportMode.replaceActive) {
      final current = _activeTimetable(data);
      if (current == null) {
        throw FormatException(
          noActiveTimetableToReplaceMessage(localeCode: localeCode),
        );
      }
      final existingCourseIds = _courseIdsForTimetables(
        data.timetables,
        excludingTimetableId: current.id,
      );
      final replaced = _normalizeTimetable(
        timetable,
        id: current.id,
        courseIds: existingCourseIds,
        config: timetable.config,
      );
      final updatedTimetables = data.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final filteredPrefs = _filterConflictDisplayCourseIds(
        Map<String, String>.from(data.conflictDisplayCourseIds)..removeWhere(
          (key, _) => _conflictKeyContainsTimetable(key, current.id),
        ),
        updatedTimetables,
      );
      final nextPeriodTimeSets = bundledPeriodTimeSet == null
          ? data.periodTimeSets
          : [...data.periodTimeSets, bundledPeriodTimeSet];
      return StudentTimetableImportMutation(
        data: data.copyWith(
          activeTimetableId: current.id,
          timetables: updatedTimetables,
          periodTimeSets: nextPeriodTimeSets,
          conflictDisplayCourseIds: filteredPrefs,
          courseNameColorValues: buildCourseNameColorValuesForTimetables(
            updatedTimetables,
            existing: data.courseNameColorValues,
          ),
        ),
        importedCount: 1,
        selectedTimetable: replaced,
      );
    }

    final existingTimetableIds = data.timetables.map((item) => item.id).toSet();
    final existingCourseIds = _courseIdsForTimetables(data.timetables);
    final appendedTimetable = _copyImportedTimetableWithUniqueId(
      timetable,
      existingTimetableIds,
    );
    final normalizedTimetable = _normalizeTimetable(
      appendedTimetable,
      id: appendedTimetable.id,
      courseIds: existingCourseIds,
      config: appendedTimetable.config,
    );
    final nextTimetables = [...data.timetables, normalizedTimetable];
    final nextPeriodTimeSets = bundledPeriodTimeSet == null
        ? data.periodTimeSets
        : [...data.periodTimeSets, bundledPeriodTimeSet];
    return StudentTimetableImportMutation(
      data: data.copyWith(
        activeTimetableId: normalizedTimetable.id,
        timetables: nextTimetables,
        periodTimeSets: nextPeriodTimeSets,
        courseNameColorValues: buildCourseNameColorValuesForTimetables(
          nextTimetables,
          existing: data.courseNameColorValues,
        ),
      ),
      importedCount: 1,
      selectedTimetable: normalizedTimetable,
    );
  }

  AppData normalizeAppData(AppData data, {required String localeCode}) {
    final normalizedSets = <PeriodTimeSet>[];
    final normalizedSetIds = <String>{};
    final periodTimeSetIdMap = <String, String>{};
    for (final item in data.studentMode.periodTimeSets) {
      final normalized = normalizePeriodTimeSet(item, localeCode: localeCode);
      final rawId = normalized.id.trim();
      final nextId = _normalizeUniqueId(
        rawId,
        fallbackPrefix: 'period_set',
        existingIds: normalizedSetIds,
      );
      normalizedSetIds.add(nextId);
      if (rawId.isNotEmpty) {
        periodTimeSetIdMap.putIfAbsent(rawId, () => nextId);
      }
      normalizedSets.add(normalized.copyWith(id: nextId));
    }

    final normalizedTimetables = <TimetableData>[];
    final normalizedTimetableIds = <String>{};
    final normalizedCourseIds = <String>{};
    final requestedActiveTimetableId = data.studentMode.activeTimetableId;
    String? remappedActiveTimetableId;
    for (final item in data.studentMode.timetables) {
      final rawTimetableId = item.id.trim();
      final timetableId = _normalizeUniqueId(
        rawTimetableId,
        fallbackPrefix: 'table',
        existingIds: normalizedTimetableIds,
      );
      normalizedTimetableIds.add(timetableId);
      if (remappedActiveTimetableId == null &&
          _matchesRawId(item.id, requestedActiveTimetableId)) {
        remappedActiveTimetableId = timetableId;
      }

      var periodTimeSetId =
          periodTimeSetIdMap[item.config.periodTimeSetId.trim()] ??
          item.config.periodTimeSetId.trim();
      if (periodTimeSetId.isEmpty ||
          !normalizedSetIds.contains(periodTimeSetId)) {
        final fallbackSet = _createImportedFallbackPeriodTimeSet(
          item,
          normalizedSetIds,
          localeCode: localeCode,
        );
        normalizedSets.add(fallbackSet);
        normalizedSetIds.add(fallbackSet.id);
        periodTimeSetId = fallbackSet.id;
      }
      normalizedTimetables.add(
        _normalizeTimetable(
          item,
          id: timetableId,
          courseIds: normalizedCourseIds,
          config: item.config.copyWith(
            totalWeeks: normalizeTimetableWeeks(item.config.totalWeeks),
            periodTimeSetId: periodTimeSetId,
          ),
        ),
      );
    }

    final requestedActiveId = requestedActiveTimetableId.trim();
    final fallbackActiveId =
        normalizedTimetables.any((item) => item.id == requestedActiveId)
        ? requestedActiveId
        : normalizedTimetables.isEmpty
        ? ''
        : normalizedTimetables.first.id;
    final activeId = remappedActiveTimetableId ?? fallbackActiveId;
    final remainingCourseIds = normalizedTimetables
        .expand((item) => item.courses)
        .map((item) => item.id)
        .toSet();
    final filteredPrefs = _filterConflictDisplayCourseIds(
      Map<String, String>.from(data.studentMode.conflictDisplayCourseIds),
      normalizedTimetables,
    )..removeWhere((_, value) => !remainingCourseIds.contains(value));
    return data.copyWith(
      studentMode: data.studentMode.copyWith(
        activeTimetableId: activeId,
        timetables: normalizedTimetables,
        periodTimeSets: normalizedSets,
        conflictDisplayCourseIds: filteredPrefs,
        courseNameColorValues: buildCourseNameColorValuesForTimetables(
          normalizedTimetables,
          existing: data.studentMode.courseNameColorValues,
        ),
      ),
      localeCode: app_locale.normalizeLocaleCode(data.localeCode),
      generalMode: _normalizeGeneralScheduleData(data.generalMode),
    );
  }

  TimetableExportData normalizeTimetableExportData(
    TimetableExportData data, {
    required String localeCode,
  }) {
    final normalizedSets = <PeriodTimeSet>[];
    final setIds = <String>{};
    final periodTimeSetIdMap = <String, String>{};
    for (final item in data.periodTimeSets) {
      final normalized = normalizePeriodTimeSet(item, localeCode: localeCode);
      final rawId = normalized.id.trim();
      final nextId = _normalizeUniqueId(
        rawId,
        fallbackPrefix: 'period_set',
        existingIds: setIds,
      );
      setIds.add(nextId);
      if (rawId.isNotEmpty) {
        periodTimeSetIdMap.putIfAbsent(rawId, () => nextId);
      }
      normalizedSets.add(normalized.copyWith(id: nextId));
    }

    final normalizedTimetables = <TimetableData>[];
    final timetableIds = <String>{};
    final courseIds = <String>{};
    for (final item in data.timetables) {
      final timetableId = _normalizeUniqueId(
        item.id.trim(),
        fallbackPrefix: 'table',
        existingIds: timetableIds,
      );
      timetableIds.add(timetableId);
      var periodTimeSetId =
          periodTimeSetIdMap[item.config.periodTimeSetId.trim()] ??
          item.config.periodTimeSetId.trim();
      var timetable = item.copyWith(
        id: timetableId,
        config: item.config.copyWith(
          totalWeeks: normalizeTimetableWeeks(item.config.totalWeeks),
          periodTimeSetId: periodTimeSetId,
        ),
      );
      if (normalizedSets.isEmpty ||
          !setIds.contains(timetable.config.periodTimeSetId)) {
        final fallbackSet = _createImportedFallbackPeriodTimeSet(
          timetable,
          setIds,
          localeCode: localeCode,
        );
        normalizedSets.add(fallbackSet);
        setIds.add(fallbackSet.id);
        periodTimeSetId = fallbackSet.id;
        timetable = timetable.copyWith(
          config: timetable.config.copyWith(periodTimeSetId: periodTimeSetId),
        );
      }
      normalizedTimetables.add(
        _normalizeTimetable(
          timetable,
          id: timetable.id,
          courseIds: courseIds,
          config: timetable.config,
        ),
      );
    }

    return TimetableExportData(
      timetables: normalizedTimetables,
      periodTimeSets: normalizedSets,
    );
  }

  PeriodTimeSet normalizePeriodTimeSet(
    PeriodTimeSet periodTimeSet, {
    required String localeCode,
  }) {
    return student_timetable.normalizePeriodTimeSet(
      periodTimeSet,
      localeCode: localeCode,
    );
  }

  Map<String, int> buildCourseNameColorValuesForTimetables(
    List<TimetableData> timetables, {
    Map<String, int>? existing,
  }) {
    return student_timetable.buildStudentCourseNameColorValuesForTimetables(
      timetables,
      existing: existing,
    );
  }

  String exportSelectedGeneralSchedulesJson(
    GeneralScheduleData data,
    List<String> scheduleIds, {
    required String localeCode,
  }) {
    final selected = _selectedSchedules(data, scheduleIds);
    if (selected.isEmpty) {
      throw FormatException(
        selectAtLeastOneScheduleMessage(localeCode: localeCode),
      );
    }
    return encodeGeneralScheduleDataEnvelope(
      GeneralScheduleExportData(schedules: selected),
    );
  }

  String exportSelectedGeneralSchedulesIcs(
    GeneralScheduleData data,
    List<String> scheduleIds, {
    required String localeCode,
  }) {
    final selected = _selectedSchedules(data, scheduleIds);
    if (selected.isEmpty) {
      throw FormatException(
        selectAtLeastOneScheduleMessage(localeCode: localeCode),
      );
    }
    return _icsService.exportSchedules(selected);
  }

  List<GeneralSchedule> previewImportGeneralSchedules(
    String source, {
    required String localeCode,
  }) {
    final decoded = decodeGeneralScheduleDataEnvelope(
      source,
      localeCode: localeCode,
    );
    if (decoded.schedules.isEmpty) {
      throw FormatException(noSchedulesInImportMessage(localeCode: localeCode));
    }
    return decoded.schedules;
  }

  GeneralCalendarIcsImportResult previewImportGeneralSchedulesIcs(
    String source, {
    required String localeCode,
  }) {
    try {
      return _icsService.importSchedules(source);
    } on GeneralCalendarIcsImportException catch (error) {
      throw FormatException(
        _generalIcsImportErrorMessage(error.code, localeCode),
      );
    }
  }

  GeneralScheduleImportMutation importSelectedGeneralSchedulesJson(
    GeneralScheduleData data,
    String source, {
    required List<String> scheduleIds,
    required GeneralScheduleImportMode mode,
    required String localeCode,
  }) {
    final imported = decodeGeneralScheduleDataEnvelope(
      source,
      localeCode: localeCode,
    );
    final selected = _selectImportedSchedules(
      imported.schedules,
      scheduleIds,
      localeCode: localeCode,
    );
    return _mergeGeneralSchedules(
      data,
      selected,
      mode: mode,
      localeCode: localeCode,
    );
  }

  GeneralScheduleImportMutation importGeneralSchedulesIcs(
    GeneralScheduleData data,
    String source, {
    required GeneralScheduleImportMode mode,
    required String localeCode,
  }) {
    final imported = previewImportGeneralSchedulesIcs(
      source,
      localeCode: localeCode,
    );
    if (imported.schedules.isEmpty) {
      throw FormatException(noSchedulesInImportMessage(localeCode: localeCode));
    }
    return _mergeGeneralSchedules(
      data,
      imported.schedules,
      mode: mode,
      localeCode: localeCode,
      icsWarnings: imported.warningItems,
    );
  }

  List<GeneralSchedule> _selectedSchedules(
    GeneralScheduleData data,
    List<String> scheduleIds,
  ) {
    final selectedIdSet = scheduleIds.toSet();
    return data.schedules.where((s) => selectedIdSet.contains(s.id)).toList();
  }

  List<GeneralSchedule> _selectImportedSchedules(
    List<GeneralSchedule> imported,
    List<String> scheduleIds, {
    required String localeCode,
  }) {
    final selectedIdSet = scheduleIds.toSet();
    final selected = imported
        .where((s) => selectedIdSet.contains(s.id))
        .toList();
    if (selected.isEmpty) {
      throw FormatException(
        selectAtLeastOneScheduleMessage(localeCode: localeCode),
      );
    }
    return selected;
  }

  GeneralScheduleImportMutation _mergeGeneralSchedules(
    GeneralScheduleData data,
    List<GeneralSchedule> selected, {
    required GeneralScheduleImportMode mode,
    required String localeCode,
    List<GeneralCalendarIcsImportWarning> icsWarnings = const [],
  }) {
    if (mode == GeneralScheduleImportMode.replaceActive) {
      if (selected.length != 1) {
        throw FormatException(
          replaceActiveRequiresSingleScheduleMessage(localeCode: localeCode),
        );
      }
      final current = data.activeScheduleOrNull;
      if (current == null) {
        throw FormatException(
          noActiveScheduleToReplaceMessage(localeCode: localeCode),
        );
      }
      final existingEventIds = _generalEventIds(
        data.schedules.where((schedule) => schedule.id != current.id),
      );
      final replaced = _sanitizeImportedGeneralSchedule(
        selected.first,
        scheduleId: current.id,
        existingEventIds: existingEventIds,
      );
      final updated = data
          .copyWith(
            reminderAcknowledgements: data.reminderAcknowledgements
                .where(
                  (item) => !_reminderKeyContainsSchedule(
                    item.occurrenceKey,
                    current.id,
                  ),
                )
                .toList(),
          )
          .withSchedule(replaced);
      return GeneralScheduleImportMutation(
        data: updated,
        result: GeneralScheduleImportResult(
          importedCount: 1,
          scheduleNames: [replaced.name],
          icsWarnings: icsWarnings,
        ),
      );
    }

    final existingIds = data.schedules.map((s) => s.id).toSet();
    final existingEventIds = _generalEventIds(data.schedules);
    final appended = <GeneralSchedule>[];
    for (final schedule in selected) {
      var nextId = _sanitizeImportedGeneralId(schedule.id);
      if (nextId.isEmpty || existingIds.contains(nextId)) {
        nextId = _nextImportedScheduleId(existingIds);
      }
      existingIds.add(nextId);
      appended.add(
        _sanitizeImportedGeneralSchedule(
          schedule,
          scheduleId: nextId,
          existingEventIds: existingEventIds,
        ),
      );
    }
    final updated = data.copyWith(
      schedules: [...data.schedules, ...appended],
      activeScheduleId: appended.last.id,
    );
    return GeneralScheduleImportMutation(
      data: updated,
      result: GeneralScheduleImportResult(
        importedCount: appended.length,
        scheduleNames: appended.map((schedule) => schedule.name).toList(),
        icsWarnings: icsWarnings,
      ),
    );
  }

  PeriodTimeSet _copyImportedPeriodTimeSetWithUniqueId(
    PeriodTimeSet periodTimeSet,
    Set<String> existingIds, {
    required String localeCode,
  }) {
    var nextId = periodTimeSet.id.trim();
    if (nextId.isEmpty || existingIds.contains(nextId)) {
      nextId = _nextPeriodTimeSetId(existingIds);
    }
    existingIds.add(nextId);
    return normalizePeriodTimeSet(
      periodTimeSet.copyWith(id: nextId),
      localeCode: localeCode,
    );
  }
}

void _ensureStudentImportAppDataShape(Map<String, dynamic> data) {
  final studentMode = _stringKeyedMap(data['studentMode']);
  if (studentMode == null) {
    return;
  }
  _ensureNonEmptyListHasMapEntries(
    studentMode['timetables'],
    message: 'Timetable JSON format is invalid.',
  );
  _ensureNonEmptyListHasMapEntries(
    studentMode['periodTimeSets'],
    message: 'Timetable JSON format is invalid.',
  );
}

Map<String, dynamic>? _stringKeyedMap(Object? value) {
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

void _ensureNonEmptyListHasMapEntries(
  Object? value, {
  required String message,
}) {
  if (value is! List || value.isEmpty) {
    return;
  }
  final hasMapEntry = value.any((item) {
    final map = _stringKeyedMap(item);
    return map != null && map.isNotEmpty;
  });
  if (!hasMapEntry) {
    throw FormatException(message);
  }
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

TimetableData _normalizeTimetable(
  TimetableData timetable, {
  required String id,
  required Set<String> courseIds,
  required TimetableConfig config,
}) {
  final normalizedCourses = <CourseItem>[];
  for (final course in timetable.courses) {
    final courseId = _normalizeUniqueId(
      course.id.trim(),
      fallbackPrefix: 'course',
      existingIds: courseIds,
    );
    courseIds.add(courseId);
    final periods = course.periods.where((item) => item > 0).toSet().toList()
      ..sort();
    normalizedCourses.add(
      course.copyWith(
        id: courseId,
        dayOfWeek: normalizeDayOfWeek(course.dayOfWeek),
        semesterWeeks: normalizeSemesterWeeks(course.semesterWeeks),
        periods: periods,
        timeRange: buildTimeRange(course.startMinutes, course.endMinutes),
      ),
    );
  }
  return timetable.copyWith(id: id, config: config, courses: normalizedCourses);
}

String _normalizeUniqueId(
  String rawId, {
  required String fallbackPrefix,
  required Set<String> existingIds,
}) {
  final trimmed = rawId.trim();
  if (trimmed.isNotEmpty && !existingIds.contains(trimmed)) {
    return trimmed;
  }
  final base = trimmed.isEmpty ? fallbackPrefix : _copyIdBase(trimmed);
  var candidate = base;
  var suffix = 1;
  while (existingIds.contains(candidate)) {
    candidate = '${base}_${suffix++}';
  }
  return candidate;
}

String _copyIdBase(String id) {
  final match = RegExp(r'^(.*_copy)(?:_\d+)?$').firstMatch(id);
  return match == null ? '${id}_copy' : match.group(1)!;
}

bool _matchesRawId(String rawId, String requestedId) {
  return rawId.trim() == requestedId.trim();
}

Set<String> _courseIdsForTimetables(
  List<TimetableData> timetables, {
  String? excludingTimetableId,
}) {
  return {
    for (final timetable in timetables)
      if (timetable.id != excludingTimetableId)
        for (final course in timetable.courses)
          if (course.id.trim().isNotEmpty) course.id.trim(),
  };
}

bool _conflictKeyContainsTimetable(String conflictKey, String timetableId) {
  final parts = conflictKey.split('|');
  return parts.isNotEmpty && parts.first == timetableId;
}

Map<String, String> _filterConflictDisplayCourseIds(
  Map<String, String> preferences,
  List<TimetableData> timetables,
) {
  final courseIdsByTimetable = <String, Set<String>>{
    for (final timetable in timetables)
      timetable.id: timetable.courses.map((course) => course.id).toSet(),
  };
  preferences.removeWhere((key, value) {
    final parts = key.split('|');
    if (parts.length < 5) {
      return true;
    }
    final timetableCourseIds = courseIdsByTimetable[parts.first];
    if (timetableCourseIds == null || !timetableCourseIds.contains(value)) {
      return true;
    }
    final keyedCourseIds = parts.last
        .split(',')
        .where((courseId) => courseId.trim().isNotEmpty)
        .toSet();
    return keyedCourseIds.isEmpty ||
        keyedCourseIds.any(
          (courseId) => !timetableCourseIds.contains(courseId),
        );
  });
  return preferences;
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

PeriodTimeSet _createImportedFallbackPeriodTimeSet(
  TimetableData timetable,
  Set<String> existingIds, {
  required String localeCode,
}) {
  final fallbackId = _nextPeriodTimeSetId(existingIds);
  return PeriodTimeSet(
    id: fallbackId,
    name: importedPeriodTimeSetName(
      timetable.config.name,
      localeCode: localeCode,
    ),
    periodTimes: buildPeriodTimesForCount(10),
  );
}

PeriodTimeSet _createFallbackPeriodTimeSet({required String localeCode}) {
  return PeriodTimeSet(
    id: '',
    name: defaultPeriodTimeSetName(localeCode: localeCode),
    periodTimes: const [
      CoursePeriodTime(
        index: 1,
        startMinutes: 8 * 60,
        endMinutes: (8 * 60) + 45,
      ),
    ],
  );
}

TimetableData? _activeTimetable(StudentModeData data) {
  for (final item in data.timetables) {
    if (item.id == data.activeTimetableId) {
      return item;
    }
  }
  return null;
}

PeriodTimeSet? _periodTimeSetForId(StudentModeData data, String id) {
  for (final item in data.periodTimeSets) {
    if (item.id == id) {
      return item;
    }
  }
  return null;
}

(int, int) _resolveImportedCourseTimeRange(
  List<CoursePeriodTime> periodTimes,
  List<int> periods,
  int startMinutes,
  int endMinutes,
) {
  final rawRangeKnown = startMinutes != 0 || endMinutes != 0;
  final rawRangeInDay =
      startMinutes >= 0 &&
      startMinutes < 24 * 60 &&
      endMinutes >= 0 &&
      endMinutes < 24 * 60;
  if (rawRangeKnown && rawRangeInDay && endMinutes > startMinutes) {
    return (startMinutes, endMinutes);
  }

  final matchedSlots = _periodTimeSlotsForPeriods(periodTimes, periods);
  if (matchedSlots.isNotEmpty) {
    return (matchedSlots.first.startMinutes, matchedSlots.last.endMinutes);
  }

  if (!rawRangeKnown) {
    return (0, 0);
  }

  final normalizedStart = normalizeMinuteOfDay(startMinutes);
  final normalizedEnd = normalizeMinuteOfDay(endMinutes);
  if (normalizedEnd > normalizedStart) {
    return (normalizedStart, normalizedEnd);
  }

  final repairedEnd = normalizeMinuteOfDay(normalizedStart + 45);
  if (repairedEnd > normalizedStart) {
    return (normalizedStart, repairedEnd);
  }

  if (periodTimes.isNotEmpty) {
    final first = periodTimes.first;
    return (first.startMinutes, first.endMinutes);
  }
  return (0, 0);
}

List<CoursePeriodTime> _periodTimeSlotsForPeriods(
  List<CoursePeriodTime> periodTimes,
  List<int> periods,
) {
  if (periods.isEmpty || periodTimes.isEmpty) {
    return const [];
  }
  final periodSet = periods.toSet();
  return periodTimes.where((slot) => periodSet.contains(slot.index)).toList()
    ..sort((a, b) => a.index.compareTo(b.index));
}

List<int> _normalizeImportedCoursePeriods(
  List<int> periods,
  List<CoursePeriodTime> periodTimes,
) {
  final validIndices = periodTimes.map((slot) => slot.index).toSet();
  final normalized =
      periods
          .where((period) => period > 0)
          .where(
            (period) => validIndices.isEmpty || validIndices.contains(period),
          )
          .toSet()
          .toList()
        ..sort();
  return normalized;
}

PeriodTimeSet _buildImportedSchoolPeriodTimeSet(
  SchoolImportResponse response, {
  required String localeCode,
}) {
  final draft = response.timetable.periodTimeSet;
  final timetableName = response.timetable.name.trim().isEmpty
      ? untitledTimetableName(localeCode: localeCode)
      : response.timetable.name.trim();
  return PeriodTimeSet(
    id: '',
    name: draft.name.trim().isEmpty
        ? importedPeriodTimeSetName(timetableName, localeCode: localeCode)
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
  required String localeCode,
}) {
  final draft = response.timetable;
  var courseSeed = DateTime.now().microsecondsSinceEpoch;
  final courses = draft.courses.map((item) {
    final rawStartMinutes = item.startMinutes;
    final rawEndMinutes = item.endMinutes;
    final explicitPeriods = _normalizeImportedCoursePeriods(
      item.periods,
      periodTimeSet.periodTimes,
    );
    final periods = explicitPeriods.isEmpty
        ? matchPeriodsForTimeRange(
            periodTimeSet.periodTimes,
            rawStartMinutes,
            rawEndMinutes,
          )
        : explicitPeriods;
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
      ? untitledTimetableName(localeCode: localeCode)
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

String _nextImportedScheduleId(Set<String> existingIds) {
  var stamp = DateTime.now().microsecondsSinceEpoch;
  var candidate = 'schedule_import_$stamp';
  while (existingIds.contains(candidate)) {
    stamp += 1;
    candidate = 'schedule_import_$stamp';
  }
  return candidate;
}

GeneralScheduleData _normalizeGeneralScheduleData(GeneralScheduleData data) {
  final normalized = data.normalized();
  final scheduleIds = <String>{};
  final eventIds = <String>{};
  final occurrencePrefixMap = <String, String>{};
  final schedules = <GeneralSchedule>[];
  String? activeScheduleId;

  for (final schedule in normalized.schedules) {
    final rawScheduleId = schedule.id.trim();
    var scheduleId = _sanitizeImportedGeneralId(rawScheduleId);
    if (scheduleId.isEmpty || scheduleIds.contains(scheduleId)) {
      scheduleId = _nextImportedScheduleId(scheduleIds);
    }
    scheduleIds.add(scheduleId);
    if (rawScheduleId == normalized.activeScheduleId) {
      activeScheduleId = scheduleId;
    }

    final events = <GeneralEvent>[];
    for (final event in schedule.events) {
      final rawEventId = event.id.trim();
      var eventId = _sanitizeImportedGeneralId(rawEventId);
      if (eventId.isEmpty || eventIds.contains(eventId)) {
        eventId = _nextImportedGeneralEventId(eventIds);
      }
      eventIds.add(eventId);
      occurrencePrefixMap['$rawScheduleId|$rawEventId|'] =
          '$scheduleId|$eventId|';
      events.add(event.copyWith(id: eventId, calendarId: scheduleId));
    }

    schedules.add(schedule.copyWith(id: scheduleId, events: events));
  }

  final acknowledgements = [
    for (final acknowledgement in normalized.reminderAcknowledgements)
      GeneralReminderAcknowledgement(
        occurrenceKey: _remapGeneralOccurrenceKey(
          acknowledgement.occurrenceKey,
          occurrencePrefixMap,
        ),
        isHandled: acknowledgement.isHandled,
        updatedAtIso: acknowledgement.updatedAtIso,
      ),
  ];

  return normalized.copyWith(
    activeScheduleId: activeScheduleId ?? schedules.first.id,
    schedules: schedules,
    reminderAcknowledgements: acknowledgements,
  );
}

String _remapGeneralOccurrenceKey(
  String occurrenceKey,
  Map<String, String> occurrencePrefixMap,
) {
  for (final entry in occurrencePrefixMap.entries) {
    if (occurrenceKey.startsWith(entry.key)) {
      return '${entry.value}${occurrenceKey.substring(entry.key.length)}';
    }
  }
  return occurrenceKey;
}

Set<String> _generalEventIds(Iterable<GeneralSchedule> schedules) {
  return {
    for (final schedule in schedules)
      for (final event in schedule.events)
        if (event.id.trim().isNotEmpty) event.id.trim(),
  };
}

GeneralSchedule _sanitizeImportedGeneralSchedule(
  GeneralSchedule schedule, {
  required String scheduleId,
  required Set<String> existingEventIds,
}) {
  final events = <GeneralEvent>[];
  for (final event in schedule.events) {
    var eventId = _sanitizeImportedGeneralId(event.id);
    if (eventId.isEmpty || existingEventIds.contains(eventId)) {
      eventId = _nextImportedGeneralEventId(existingEventIds);
    }
    existingEventIds.add(eventId);
    events.add(event.copyWith(id: eventId, calendarId: scheduleId));
  }
  return schedule.copyWith(id: scheduleId, events: events);
}

String _sanitizeImportedGeneralId(String rawId) {
  final source = rawId.trim();
  if (source.isEmpty) {
    return '';
  }
  final safe = source
      .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  if (safe.isEmpty) {
    return '';
  }
  return safe.length > 96 ? safe.substring(0, 96) : safe;
}

String _nextImportedGeneralEventId(Set<String> existingIds) {
  var stamp = DateTime.now().microsecondsSinceEpoch;
  var candidate = 'evt_import_$stamp';
  while (existingIds.contains(candidate)) {
    stamp += 1;
    candidate = 'evt_import_$stamp';
  }
  return candidate;
}

bool _reminderKeyContainsSchedule(String occurrenceKey, String scheduleId) {
  final parts = occurrenceKey.split('|');
  return parts.isNotEmpty && parts.first == scheduleId;
}

String _generalIcsImportErrorMessage(
  GeneralCalendarIcsImportErrorCode code,
  String localeCode,
) {
  return switch (code) {
    GeneralCalendarIcsImportErrorCode.noEvents ||
    GeneralCalendarIcsImportErrorCode.noImportableEvents =>
      noSchedulesInImportMessage(localeCode: localeCode),
  };
}
