part of 'timetable_provider.dart';

mixin _TimetableProviderImportExport on _TimetableProviderBase {
  String exportSelectedGeneralSchedulesJson(List<String> scheduleIds) {
    return _importExportService.exportSelectedGeneralSchedulesJson(
      _appData.generalMode,
      scheduleIds,
      localeCode: _appData.localeCode,
    );
  }

  String exportActiveGeneralScheduleJson() {
    final active = activeGeneralScheduleOrNull;
    if (active == null) {
      throw FormatException(
        noExportableScheduleMessage(localeCode: _appData.localeCode),
      );
    }
    return exportSelectedGeneralSchedulesJson([active.id]);
  }

  String exportSelectedGeneralSchedulesIcs(List<String> scheduleIds) {
    return _importExportService.exportSelectedGeneralSchedulesIcs(
      _appData.generalMode,
      scheduleIds,
      localeCode: _appData.localeCode,
    );
  }

  GeneralCalendarIcsImportResult previewImportGeneralSchedulesIcs(
    String source,
  ) {
    return _importExportService.previewImportGeneralSchedulesIcs(
      source,
      localeCode: _appData.localeCode,
    );
  }

  List<GeneralSchedule> previewImportGeneralSchedules(String source) {
    return _importExportService.previewImportGeneralSchedules(
      source,
      localeCode: _appData.localeCode,
    );
  }

  Future<GeneralScheduleImportResult> importSelectedGeneralSchedulesJson(
    String source, {
    required List<String> scheduleIds,
    required GeneralScheduleImportMode mode,
  }) async {
    final mutation = _importExportService.importSelectedGeneralSchedulesJson(
      _appData.generalMode,
      source,
      scheduleIds: scheduleIds,
      mode: mode,
      localeCode: _appData.localeCode,
    );
    _appData = _appData.copyWith(generalMode: mutation.data);
    await _saveAndNotify();
    return mutation.result;
  }

  Future<GeneralScheduleImportResult> importGeneralSchedulesIcs(
    String source, {
    required GeneralScheduleImportMode mode,
  }) async {
    final mutation = _importExportService.importGeneralSchedulesIcs(
      _appData.generalMode,
      source,
      mode: mode,
      localeCode: _appData.localeCode,
    );
    _appData = _appData.copyWith(generalMode: mutation.data);
    await _saveAndNotify();
    return mutation.result;
  }

  String exportAppDataJson() =>
      _importExportService.exportAppDataJson(_appData);

  String exportSelectedTimetablesJson(List<String> timetableIds) =>
      _importExportService.exportSelectedTimetablesJson(
        _appData.studentMode,
        timetableIds,
        localeCode: _appData.localeCode,
      );

  String exportActiveTimetableJson() {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      throw FormatException(
        noExportableTimetableMessage(localeCode: _appData.localeCode),
      );
    }
    return exportSelectedTimetablesJson([timetable.id]);
  }

  String exportActivePeriodTimesJson() => _importExportService
      .exportPeriodTimesJson(activePeriodTimeSet.periodTimes);

  List<TimetableData> previewImportTimetables(String source) {
    return _importExportService.previewImportTimetables(
      source,
      localeCode: _appData.localeCode,
    );
  }

  Future<int> importSelectedTimetablesJson(
    String source, {
    required List<String> timetableIds,
    required TimetableImportMode mode,
    bool importBundledPeriodTimeSets = true,
    String? targetPeriodTimeSetId,
  }) async {
    final mutation = _importExportService.importSelectedTimetablesJson(
      _appData.studentMode,
      source,
      timetableIds: timetableIds,
      mode: mode,
      localeCode: _appData.localeCode,
      importBundledPeriodTimeSets: importBundledPeriodTimeSets,
      targetPeriodTimeSetId: targetPeriodTimeSetId,
    );
    _appData = _appData.copyWith(studentMode: mutation.data);
    final selectedTimetable = mutation.selectedTimetable;
    if (selectedTimetable != null) {
      _selectedWeek = currentWeekFor(selectedTimetable.config);
    }
    await _saveAndNotify();
    return mutation.importedCount;
  }

  Future<int> importAppDataJson(
    String source, {
    required AppImportMode mode,
  }) async {
    final imported = _importExportService.normalizeAppData(
      decodeAppDataEnvelope(source, localeCode: _appData.localeCode),
      localeCode: _appData.localeCode,
    );
    if (mode == AppImportMode.replaceAll) {
      _appData = imported;
      _selectedWeek = _currentWeekForActiveTimetable();
      await _saveAndNotify();
      return imported.studentMode.timetables.length;
    }

    return importSelectedTimetablesJson(
      source,
      timetableIds: imported.studentMode.timetables
          .map((item) => item.id)
          .toList(),
      mode: TimetableImportMode.addAsNew,
    );
  }

  Future<String> importTimetableJson(
    String source, {
    required TimetableImportMode mode,
    bool importBundledPeriodTimeSets = true,
    String? targetPeriodTimeSetId,
  }) async {
    final imported = _importExportService.decodeStudentImportCandidate(
      source,
      localeCode: _appData.localeCode,
    );
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
    final mutation = _importExportService.applySchoolImportRequest(
      _appData.studentMode,
      request,
      localeCode: _appData.localeCode,
    );
    _appData = _appData.copyWith(studentMode: mutation.data);
    final selectedTimetable = mutation.selectedTimetable;
    if (selectedTimetable != null) {
      _selectedWeek = currentWeekFor(selectedTimetable.config);
    }
    await _saveAndNotify();
  }

  List<CoursePeriodTime> importPeriodTimesJson(String source) {
    return _importExportService.importPeriodTimesJson(
      source,
      localeCode: _appData.localeCode,
    );
  }

  @override
  Future<List<CoursePeriodTime>> _loadDefaultPeriodTimes() async {
    try {
      final source = await rootBundle.loadString(defaultPeriodTimesAssetPath);
      return importPeriodTimesJson(source);
    } catch (e, st) {
      debugPrint('Failed to load default period times from assets: $e\n$st');
      return buildDefaultPeriodTimes();
    }
  }

  @override
  Future<AppData> _buildDefaultAppData() async {
    final periodTimes = await _loadDefaultPeriodTimes();
    final localeCode = _systemLocaleCodeResolver();
    return _importExportService.normalizeAppData(
      buildInitialAppData(periodTimes, localeCode: localeCode),
      localeCode: localeCode,
    );
  }
}
