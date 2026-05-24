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
    switch (envelope.schema) {
      case timetableDataSchema:
        return normalizeTimetableExportData(
          TimetableExportData.fromJson(envelope.data, localeCode: localeCode),
          localeCode: localeCode,
        );
      case appDataSchema:
        final appData = normalizeAppData(
          AppData.fromJson({...envelope.data, 'localeCode': localeCode}),
          localeCode: localeCode,
        );
        return TimetableExportData(
          timetables: appData.studentMode.timetables,
          periodTimeSets: appData.studentMode.periodTimeSets,
        );
      default:
        throw FormatException(
          importFileTypeMismatchMessage(localeCode: localeCode),
        );
    }
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
      final replaced = selected.copyWith(
        id: current.id,
        config: selected.config.copyWith(periodTimeSetId: resolvedSetId),
      );
      final updatedTimetables = data.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final nextPeriodTimeSets = copiedSet == null
          ? data.periodTimeSets
          : [...data.periodTimeSets, copiedSet];
      return StudentTimetableImportMutation(
        data: data.copyWith(
          activeTimetableId: current.id,
          timetables: updatedTimetables,
          periodTimeSets: nextPeriodTimeSets,
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
      final replaced = timetable.copyWith(id: current.id);
      final updatedTimetables = data.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final nextPeriodTimeSets = bundledPeriodTimeSet == null
          ? data.periodTimeSets
          : [...data.periodTimeSets, bundledPeriodTimeSet];
      return StudentTimetableImportMutation(
        data: data.copyWith(
          activeTimetableId: current.id,
          timetables: updatedTimetables,
          periodTimeSets: nextPeriodTimeSets,
          courseNameColorValues: buildCourseNameColorValuesForTimetables(
            updatedTimetables,
            existing: data.courseNameColorValues,
          ),
        ),
        importedCount: 1,
        selectedTimetable: replaced,
      );
    }

    final nextTimetables = [...data.timetables, timetable];
    final nextPeriodTimeSets = bundledPeriodTimeSet == null
        ? data.periodTimeSets
        : [...data.periodTimeSets, bundledPeriodTimeSet];
    return StudentTimetableImportMutation(
      data: data.copyWith(
        activeTimetableId: timetable.id,
        timetables: nextTimetables,
        periodTimeSets: nextPeriodTimeSets,
        courseNameColorValues: buildCourseNameColorValuesForTimetables(
          nextTimetables,
          existing: data.courseNameColorValues,
        ),
      ),
      importedCount: 1,
      selectedTimetable: timetable,
    );
  }

  AppData normalizeAppData(AppData data, {required String localeCode}) {
    final normalizedSets = <PeriodTimeSet>[];
    final normalizedSetIds = <String>{};
    for (final item in data.studentMode.periodTimeSets) {
      final normalized = normalizePeriodTimeSet(item, localeCode: localeCode);
      final nextId =
          normalized.id.trim().isEmpty ||
              normalizedSetIds.contains(normalized.id)
          ? _nextPeriodTimeSetId(normalizedSetIds)
          : normalized.id;
      normalizedSetIds.add(nextId);
      normalizedSets.add(normalized.copyWith(id: nextId));
    }

    final normalizedTimetables = <TimetableData>[];
    for (final item in data.studentMode.timetables) {
      var periodTimeSetId = item.config.periodTimeSetId.trim();
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
        item.copyWith(
          config: item.config.copyWith(
            totalWeeks: normalizeTimetableWeeks(item.config.totalWeeks),
            periodTimeSetId: periodTimeSetId,
          ),
        ),
      );
    }

    final activeId =
        normalizedTimetables.any(
          (item) => item.id == data.studentMode.activeTimetableId,
        )
        ? data.studentMode.activeTimetableId
        : normalizedTimetables.isEmpty
        ? ''
        : normalizedTimetables.first.id;
    final remainingCourseIds = normalizedTimetables
        .expand((item) => item.courses)
        .map((item) => item.id)
        .toSet();
    final filteredPrefs = Map<String, String>.from(
      data.studentMode.conflictDisplayCourseIds,
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
      generalMode: data.generalMode.normalized(),
    );
  }

  TimetableExportData normalizeTimetableExportData(
    TimetableExportData data, {
    required String localeCode,
  }) {
    final normalizedSets = <PeriodTimeSet>[];
    final setIds = <String>{};
    for (final item in data.periodTimeSets) {
      final normalized = normalizePeriodTimeSet(item, localeCode: localeCode);
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
          localeCode: localeCode,
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
      final replaced = selected.first.copyWith(id: current.id);
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
    final appended = <GeneralSchedule>[];
    for (final schedule in selected) {
      var nextId = schedule.id.trim();
      if (nextId.isEmpty || existingIds.contains(nextId)) {
        nextId = _nextImportedScheduleId(existingIds);
      }
      existingIds.add(nextId);
      appended.add(schedule.copyWith(id: nextId));
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
  if (startMinutes > 0 && endMinutes > startMinutes) {
    return (startMinutes, endMinutes);
  }
  if (periods.isEmpty || periodTimes.isEmpty) {
    return (startMinutes, endMinutes);
  }

  final matchedSlots =
      periodTimes.where((slot) => periods.contains(slot.index)).toList()
        ..sort((a, b) => a.index.compareTo(b.index));
  if (matchedSlots.isEmpty) {
    return (startMinutes, endMinutes);
  }

  return (matchedSlots.first.startMinutes, matchedSlots.last.endMinutes);
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
