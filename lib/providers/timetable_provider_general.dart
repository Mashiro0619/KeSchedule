part of 'timetable_provider.dart';

mixin _TimetableProviderGeneral on _TimetableProviderBase {
  List<GeneralSchedule> get generalSchedules => _appData.generalMode.schedules;

  List<GeneralSchedule> get visibleGeneralSchedules =>
      _appData.generalMode.visibleSchedules;

  @override
  GeneralSchedule? get activeGeneralScheduleOrNull =>
      _appData.generalMode.activeScheduleOrNull;

  GeneralSchedule get activeGeneralSchedule =>
      _appData.generalMode.activeSchedule;

  String get generalDefaultView => _appData.generalMode.defaultView;
  bool get generalShowWeekends => _appData.generalMode.showWeekends;
  int get generalDayStartHour => _appData.generalMode.dayStartHour;
  int get generalDayEndHour => _appData.generalMode.dayEndHour;
  int get generalTimeGridMinutes => _appData.generalMode.timeGridMinutes;
  bool get closeGeneralEventPopupOnOutsideTap =>
      _appData.generalMode.closeEventPopupOnOutsideTap;

  DateTime get selectedGeneralDate => _appData.generalMode.selectedDate;

  Future<void> switchGeneralSchedule(String scheduleId) async {
    final next = _calendarService.switchSchedule(
      _appData.generalMode,
      scheduleId,
    );
    if (identical(next, _appData.generalMode)) return;
    _appData = _appData.copyWith(generalMode: next);
    await _saveAndNotify();
  }

  Future<void> addGeneralSchedule({String? name, int? colorValue}) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.addSchedule(
        _appData.generalMode,
        name: name,
        colorValue: colorValue,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> renameGeneralSchedule(String scheduleId, String name) async {
    final next = _calendarService.renameSchedule(
      _appData.generalMode,
      scheduleId,
      name,
    );
    if (identical(next, _appData.generalMode)) return;
    _appData = _appData.copyWith(generalMode: next);
    await _saveAndNotify();
  }

  Future<void> updateGeneralSchedule(GeneralSchedule schedule) async {
    final next = _calendarService.updateSchedule(
      _appData.generalMode,
      schedule,
    );
    if (identical(next, _appData.generalMode)) return;
    _appData = _appData.copyWith(generalMode: next);
    await _saveAndNotify();
  }

  Future<void> updateGeneralScheduleVisibility(
    String scheduleId,
    bool isVisible,
  ) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.updateScheduleVisibility(
        _appData.generalMode,
        scheduleId,
        isVisible,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> deleteGeneralSchedule(String scheduleId) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.deleteSchedule(
        _appData.generalMode,
        scheduleId,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> setSelectedGeneralDate(DateTime date) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.setSelectedDate(_appData.generalMode, date),
    );
    await _saveAndNotify();
  }

  Future<void> updateGeneralDisplaySettings({
    String? defaultView,
    bool? showWeekends,
    int? dayStartHour,
    int? dayEndHour,
    int? timeGridMinutes,
    bool? closeEventPopupOnOutsideTap,
  }) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.updateDisplaySettings(
        _appData.generalMode,
        defaultView: defaultView,
        showWeekends: showWeekends,
        dayStartHour: dayStartHour,
        dayEndHour: dayEndHour,
        timeGridMinutes: timeGridMinutes,
        closeEventPopupOnOutsideTap: closeEventPopupOnOutsideTap,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> saveGeneralEvent(GeneralEvent event) async {
    final next = _calendarService.saveEvent(_appData.generalMode, event);
    if (identical(next, _appData.generalMode)) return;
    _appData = _appData.copyWith(generalMode: next);
    await _saveAndNotify();
  }

  Future<void> deleteGeneralEvent(String eventId) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.deleteEvent(_appData.generalMode, eventId),
    );
    await _saveAndNotify();
  }

  Future<GeneralEvent> duplicateGeneralOccurrence(
    GeneralEventOccurrence occurrence,
  ) async {
    final result = _calendarService.duplicateOccurrence(
      _appData.generalMode,
      occurrence,
    );
    _appData = _appData.copyWith(generalMode: result.data);
    await _saveAndNotify();
    return result.event;
  }

  Future<void> deleteGeneralOccurrence(
    GeneralEventOccurrence occurrence,
  ) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.deleteOccurrence(
        _appData.generalMode,
        occurrence,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> deleteFutureGeneralOccurrences(
    GeneralEventOccurrence occurrence,
  ) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.deleteFutureOccurrences(
        _appData.generalMode,
        occurrence,
      ),
    );
    await _saveAndNotify();
  }

  List<GeneralEventOccurrence> generalOccurrencesForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
    bool onlyVisibleCalendars = true,
  }) {
    return _occurrenceService.occurrencesForRange(
      _appData.generalMode,
      startInclusive: startInclusive,
      endExclusive: endExclusive,
      onlyVisibleCalendars: onlyVisibleCalendars,
    );
  }

  List<GeneralEventOccurrence> generalOccurrencesForQuery(
    GeneralOccurrenceQuery query,
  ) {
    return _occurrenceService.occurrencesForQuery(_appData.generalMode, query);
  }

  List<GeneralEventOccurrence> upcomingGeneralOccurrences({
    DateTime? now,
    Duration horizon = const Duration(days: 7),
  }) {
    return _occurrenceService.upcomingOccurrences(
      _appData.generalMode,
      now: now,
      horizon: horizon,
    );
  }

  bool isGeneralReminderHandled(GeneralEventOccurrence occurrence) {
    return _occurrenceService.isReminderHandled(
      _appData.generalMode,
      occurrence,
    );
  }

  Future<void> dismissGeneralReminder(GeneralEventOccurrence occurrence) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.dismissReminder(
        _appData.generalMode,
        occurrence,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> restoreGeneralReminder(GeneralEventOccurrence occurrence) async {
    _appData = _appData.copyWith(
      generalMode: _calendarService.restoreReminder(
        _appData.generalMode,
        occurrence,
      ),
    );
    await _saveAndNotify();
  }

  List<GeneralReminderItem> generalReminderItems({
    DateTime? now,
    Duration upcomingHorizon = const Duration(hours: 24),
    Duration overdueWindow = const Duration(hours: 24),
    GeneralOccurrenceQuery? occurrenceFilter,
  }) {
    return _occurrenceService.reminderItems(
      _appData.generalMode,
      now: now,
      upcomingHorizon: upcomingHorizon,
      overdueWindow: overdueWindow,
      occurrenceFilter: occurrenceFilter,
    );
  }
}
