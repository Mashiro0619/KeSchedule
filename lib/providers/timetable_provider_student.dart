part of 'timetable_provider.dart';

mixin _TimetableProviderStudent on _TimetableProviderBase {
  @override
  TimetableData? get activeTimetableOrNull {
    if (_appData.studentMode.timetables.isEmpty) {
      return null;
    }
    for (final item in _appData.studentMode.timetables) {
      if (item.id == _appData.studentMode.activeTimetableId) {
        return item;
      }
    }
    return _appData.studentMode.timetables.first;
  }

  TimetableData get activeTimetable =>
      activeTimetableOrNull ?? _createFallbackTimetable();

  @override
  PeriodTimeSet? get activePeriodTimeSetOrNull {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      return _appData.studentMode.periodTimeSets.isEmpty
          ? null
          : _appData.studentMode.periodTimeSets.first;
    }
    return periodTimeSetForId(timetable.config.periodTimeSetId);
  }

  @override
  PeriodTimeSet get activePeriodTimeSet =>
      activePeriodTimeSetOrNull ?? _createFallbackPeriodTimeSet();

  @override
  int _currentWeekForActiveTimetable() {
    final timetable = activeTimetableOrNull;
    return timetable == null ? 1 : currentWeekFor(timetable.config);
  }

  PeriodTimeSet? periodTimeSetForId(String id) {
    for (final item in _appData.studentMode.periodTimeSets) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  List<TimetableData> timetablesUsingPeriodTimeSet(String periodTimeSetId) {
    return _appData.studentMode.timetables
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
    final next = _studentTimetableService.switchTimetable(
      _appData.studentMode,
      timetableId,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    _selectedWeek = _currentWeekForActiveTimetable();
    await _saveAndNotify();
  }

  Future<void> setSelectedWeek(int week) async {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      _selectedWeek = 1;
      notifyListeners();
      return;
    }
    final nextWeek = _studentTimetableService.resolveSelectedWeek(
      _appData.studentMode,
      week,
      fallbackWeek: _selectedWeek,
    );
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
    final next = _studentTimetableService.updateTimetableConfig(
      _appData.studentMode,
      timetableId,
      config,
      fallbackPeriodTimeSet: activePeriodTimeSet,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    if (_appData.studentMode.activeTimetableId == timetableId) {
      _selectedWeek = _studentTimetableService.resolveSelectedWeek(
        _appData.studentMode,
        _selectedWeek,
        fallbackWeek: _selectedWeek,
      );
    }
    await _saveAndNotify();
  }

  Future<void> saveCourse(CourseItem course) async {
    final next = _studentTimetableService.saveCourse(
      _appData.studentMode,
      _appData.studentMode.activeTimetableId,
      course,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    await _saveAndNotify();
  }

  Future<void> deleteCourse(String courseId) async {
    final next = _studentTimetableService.deleteCourse(
      _appData.studentMode,
      _appData.studentMode.activeTimetableId,
      courseId,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    await _saveAndNotify();
  }

  Future<void> addTimetable() async {
    final now = DateTime.now();
    final result = _studentTimetableService.addTimetable(
      _appData.studentMode,
      fallbackPeriodTimeSet:
          activePeriodTimeSetOrNull ?? _createFallbackPeriodTimeSet(),
      localeCode: _appData.localeCode,
      now: now,
    );
    _appData = _appData.copyWith(studentMode: result.data);
    _selectedWeek = 1;
    await _saveAndNotify();
  }

  Future<void> deleteTimetable(String timetableId) async {
    final next = _studentTimetableService.deleteTimetable(
      _appData.studentMode,
      timetableId,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    _selectedWeek = _currentWeekForActiveTimetable();
    await _saveAndNotify();
  }

  Future<PeriodTimeSet> addPeriodTimeSet({
    String? name,
    List<CoursePeriodTime>? periodTimes,
  }) async {
    final defaultPeriodTimes = periodTimes == null || periodTimes.isEmpty
        ? await _loadDefaultPeriodTimes()
        : const <CoursePeriodTime>[];
    final result = _studentTimetableService.addPeriodTimeSet(
      _appData.studentMode,
      localeCode: _appData.localeCode,
      defaultPeriodTimes: defaultPeriodTimes,
      name: name,
      periodTimes: periodTimes,
    );
    _appData = _appData.copyWith(studentMode: result.data);
    await _saveAndNotify();
    return result.periodTimeSet!;
  }

  Future<void> updatePeriodTimeSet(PeriodTimeSet periodTimeSet) async {
    final next = _studentTimetableService.updatePeriodTimeSet(
      _appData.studentMode,
      periodTimeSet,
      localeCode: _appData.localeCode,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    await _saveAndNotify();
  }

  Future<void> deletePeriodTimeSet(String periodTimeSetId) async {
    final next = _studentTimetableService.deletePeriodTimeSet(
      _appData.studentMode,
      periodTimeSetId,
      localeCode: _appData.localeCode,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    await _saveAndNotify();
  }

  Future<void> assignPeriodTimeSetToTimetable(
    String timetableId,
    String periodTimeSetId,
  ) async {
    final next = _studentTimetableService.assignPeriodTimeSetToTimetable(
      _appData.studentMode,
      timetableId,
      periodTimeSetId,
    );
    if (identical(next, _appData.studentMode)) return;
    _appData = _appData.copyWith(studentMode: next);
    await _saveAndNotify();
  }

  String? displayedCourseIdForConflict(String conflictKey) =>
      _appData.studentMode.conflictDisplayCourseIds[conflictKey];

  Future<void> setDisplayedCourseForConflict(
    String conflictKey,
    String courseId,
  ) async {
    final next = _studentTimetableService.setDisplayedCourseForConflict(
      _appData.studentMode,
      conflictKey,
      courseId,
    );
    _appData = _appData.copyWith(studentMode: next);
    await _saveAndNotify();
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
