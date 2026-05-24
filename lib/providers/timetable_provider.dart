import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/app_repository.dart';
import '../data/timetable_storage.dart';
import '../l10n/app_locale.dart' as app_locale;
import '../models/school_import_models.dart';
import '../models/timetable_models.dart';
import '../services/general_calendar_ics_service.dart';
import '../services/privacy_service.dart';
import '../services/settings_service.dart';

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
    AppRepository? repository,
    String Function()? systemLocaleCodeResolver,
    SettingsService? settingsService,
    PrivacyService? privacyService,
  }) : _repository = repository ??
           AppRepository(storage: storage ?? TimetableStorage()),
       _systemLocaleCodeResolver =
           systemLocaleCodeResolver ?? _defaultSystemLocaleCodeResolver,
       _settings = settingsService ?? const SettingsService(),
       _privacy = privacyService ?? const PrivacyService();

  final AppRepository _repository;
  final String Function() _systemLocaleCodeResolver;
  final SettingsService _settings;
  final PrivacyService _privacy;
  static const _generalIcsService = GeneralCalendarIcsService();

  AppData _appData = buildInitialAppData(buildDefaultPeriodTimes());
  int _selectedWeek = 1;
  bool _isLoaded = false;
  bool _isLoading = false;
  String? _storagePath;

  bool get isLoaded => _isLoaded;
  bool get hasTimetables => _appData.studentMode.timetables.isNotEmpty;
  bool get hasPeriodTimeSets => _appData.studentMode.periodTimeSets.isNotEmpty;
  List<TimetableData> get timetables => _appData.studentMode.timetables;
  List<PeriodTimeSet> get periodTimeSets => _appData.studentMode.periodTimeSets;
  int get selectedWeek => _selectedWeek;
  String? get storagePath => _storagePath;

  /// 上次 [load] 的备份恢复状态。UI 必须根据这个状态给用户提示：
  /// - [RecoveryStatus.restoredFromBackup]：主文件损坏，已从 .bak 恢复。
  /// - [RecoveryStatus.failedBackupRestore]：主文件与 .bak 均损坏，已用空数据。
  RecoveryStatus get lastRecoveryStatus => _repository.lastRecoveryStatus;
  bool get closeCoursePopupOnOutsideTap =>
      _appData.studentMode.closeCoursePopupOnOutsideTap;
  bool get preserveTimetableGaps => _appData.studentMode.preserveTimetableGaps;
  bool get showPastEndedCourses => _appData.studentMode.showPastEndedCourses;
  bool get showFutureCourses => _appData.studentMode.showFutureCourses;
  bool get showTimetableGridLines =>
      _appData.studentMode.showTimetableGridLines;
  String get localeCode => _appData.localeCode;
  String get themeMode => _appData.themeMode;
  String get themeColorMode => _appData.themeColorMode;
  int get themeSeedColorValue => _appData.themeSeedColorValue;
  String get colorfulCourseTextColorMode =>
      _appData.studentMode.colorfulCourseTextColorMode;
  Map<String, int> get colorfulUiColorValues => _appData.colorfulUiColorValues;
  Map<String, int> get courseNameColorValues =>
      _appData.studentMode.courseNameColorValues;
  SchoolImportParserSettings get schoolImportParserSettings =>
      _appData.studentMode.schoolImportParserSettings;
  String get schoolImportParserSource =>
      _appData.studentMode.schoolImportParserSettings.source;
  String get customSchoolImportBaseUrl =>
      _appData.studentMode.schoolImportParserSettings.customBaseUrl;
  String get customSchoolImportApiKey =>
      _appData.studentMode.schoolImportParserSettings.customApiKey;
  String get customSchoolImportModel =>
      _appData.studentMode.schoolImportParserSettings.customModel;
  String get customSchoolImportPrompt =>
      _appData.studentMode.schoolImportParserSettings.customPrompt;
  int get liveCourseOutlineColorValue =>
      _appData.studentMode.liveCourseOutlineColorValue;
  bool get liveCourseOutlineEnabled =>
      _appData.studentMode.liveCourseOutlineEnabled;
  bool get liveCourseOutlineFollowTheme =>
      _appData.studentMode.liveCourseOutlineFollowTheme;
  bool get liveCourseOutlineCustomColorInitialized =>
      _appData.studentMode.liveCourseOutlineCustomColorInitialized;
  String get liveCourseOutlineMode =>
      _appData.studentMode.liveCourseOutlineMode;
  double get liveCourseOutlineWidth =>
      _appData.studentMode.liveCourseOutlineWidth;
  String? get ignoredUpdateVersion => _appData.ignoredUpdateVersion;
  String? get availableUpdateVersion => _appData.availableUpdateVersion;

  // ── App mode ──

  AppMode get activeMode => _appData.activeMode;
  bool get isGeneralMode => _appData.activeMode == AppMode.general;
  bool get isStudentMode => _appData.activeMode == AppMode.student;
  StudentModeData get studentMode => _appData.studentMode;
  GeneralScheduleData get generalMode => _appData.generalMode;

  Future<void> switchMode(AppMode mode) async {
    if (_appData.activeMode == mode) return;
    _appData = _appData.copyWith(activeMode: mode);
    await _saveAndNotify();
  }

  // ── General schedule ──

  List<GeneralSchedule> get generalSchedules => _appData.generalMode.schedules;

  List<GeneralSchedule> get visibleGeneralSchedules =>
      _appData.generalMode.visibleSchedules;

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

  DateTime get selectedGeneralDate {
    return _appData.generalMode.selectedDate;
  }

  Future<void> switchGeneralSchedule(String scheduleId) async {
    final mode = _appData.generalMode;
    if (mode.activeScheduleId == scheduleId) return;
    if (!mode.schedules.any((s) => s.id == scheduleId)) return;
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(activeScheduleId: scheduleId),
    );
    await _saveAndNotify();
  }

  Future<void> addGeneralSchedule({String? name, int? colorValue}) async {
    final mode = _appData.generalMode;
    final schedule = createDefaultGeneralSchedule(
      name: (name != null && name.trim().isNotEmpty)
          ? name.trim()
          : 'My calendar',
      colorValue: colorValue ?? defaultGeneralCalendarColorValue,
    ).copyWith(sortOrder: mode.schedules.length);
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        activeScheduleId: schedule.id,
        schedules: [...mode.schedules, schedule],
      ),
    );
    await _saveAndNotify();
  }

  Future<void> renameGeneralSchedule(String scheduleId, String name) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) return;
    final mode = _appData.generalMode;
    final existing = mode.schedules.firstWhere(
      (s) => s.id == scheduleId,
      orElse: () => mode.activeSchedule,
    );
    final updated = mode.withSchedule(existing.copyWith(name: normalizedName));
    _appData = _appData.copyWith(generalMode: updated);
    await _saveAndNotify();
  }

  Future<void> updateGeneralSchedule(GeneralSchedule schedule) async {
    if (!_appData.generalMode.schedules.any((s) => s.id == schedule.id)) {
      return;
    }
    _appData = _appData.copyWith(
      generalMode: _appData.generalMode.withSchedule(schedule),
    );
    await _saveAndNotify();
  }

  Future<void> updateGeneralScheduleVisibility(
    String scheduleId,
    bool isVisible,
  ) async {
    final mode = _appData.generalMode;
    final existing = mode.schedules.firstWhere(
      (s) => s.id == scheduleId,
      orElse: () => mode.activeSchedule,
    );
    _appData = _appData.copyWith(
      generalMode: mode.withSchedule(existing.copyWith(isVisible: isVisible)),
    );
    await _saveAndNotify();
  }

  Future<void> deleteGeneralSchedule(String scheduleId) async {
    final mode = _appData.generalMode;
    var remaining = mode.schedules.where((s) => s.id != scheduleId).toList();
    if (remaining.isEmpty) {
      remaining = [createDefaultGeneralSchedule()];
    }
    final nextActiveId = remaining.any((s) => s.id == mode.activeScheduleId)
        ? mode.activeScheduleId
        : remaining.first.id;
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        activeScheduleId: nextActiveId,
        schedules: remaining,
        reminderAcknowledgements: mode.reminderAcknowledgements
            .where(
              (item) =>
                  !_reminderKeyContainsSchedule(item.occurrenceKey, scheduleId),
            )
            .toList(),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> setSelectedGeneralDate(DateTime date) async {
    _appData = _appData.copyWith(
      generalMode: _appData.generalMode.copyWith(
        selectedDateIso: date.toIso8601String().split('T').first,
      ),
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
      generalMode: _appData.generalMode.copyWith(
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
    final mode = _appData.generalMode;
    var targetScheduleId = event.calendarId.trim().isEmpty
        ? mode.activeSchedule.id
        : event.calendarId.trim();
    if (!mode.schedules.any((s) => s.id == targetScheduleId)) {
      targetScheduleId = mode.activeSchedule.id;
    }
    final normalized = event.normalized(fallbackCalendarId: targetScheduleId);
    final updatedSchedules = <GeneralSchedule>[];
    var inserted = false;
    for (final schedule in mode.schedules) {
      var events = schedule.events.where((e) => e.id != event.id).toList();
      if (schedule.id == targetScheduleId) {
        events = [...events, normalized]
          ..sort((a, b) => a.startDateTimeIso.compareTo(b.startDateTimeIso));
        inserted = true;
      }
      updatedSchedules.add(schedule.copyWith(events: events));
    }
    if (!inserted) {
      return;
    }
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(schedules: updatedSchedules),
    );
    await _saveAndNotify();
  }

  Future<void> deleteGeneralEvent(String eventId) async {
    final mode = _appData.generalMode;
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        schedules: [
          for (final schedule in mode.schedules)
            schedule.copyWith(
              events: schedule.events.where((e) => e.id != eventId).toList(),
            ),
        ],
        reminderAcknowledgements: mode.reminderAcknowledgements
            .where(
              (item) => !_reminderKeyContainsEvent(item.occurrenceKey, eventId),
            )
            .toList(),
      ),
    );
    await _saveAndNotify();
  }

  Future<GeneralEvent> duplicateGeneralOccurrence(
    GeneralEventOccurrence occurrence,
  ) async {
    final now = DateTime.now().toIso8601String();
    final duplicated = occurrence.event.copyWith(
      id: _nextGeneralEventId(),
      calendarId: occurrence.calendar.id,
      title: occurrence.event.title,
      startDateTimeIso: occurrence.start.toIso8601String(),
      endDateTimeIso: occurrence.end.toIso8601String(),
      recurrenceRule: const GeneralEventRecurrenceRule(),
      recurrenceExceptionDateIso: const [],
      createdAtIso: now,
      updatedAtIso: now,
    );
    await saveGeneralEvent(duplicated);
    return duplicated;
  }

  Future<void> deleteGeneralOccurrence(
    GeneralEventOccurrence occurrence,
  ) async {
    final event = occurrence.event;
    if (!event.recurrenceRule.isRepeating) {
      await deleteGeneralEvent(event.id);
      return;
    }
    final exceptions = {...event.recurrenceExceptionDateIso}
      ..add(occurrence.exceptionDateIso);
    await saveGeneralEvent(
      event.copyWith(recurrenceExceptionDateIso: exceptions.toList()..sort()),
    );
    final mode = _appData.generalMode;
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        reminderAcknowledgements: mode.reminderAcknowledgements
            .where((item) => item.occurrenceKey != occurrence.occurrenceKey)
            .toList(),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> deleteFutureGeneralOccurrences(
    GeneralEventOccurrence occurrence,
  ) async {
    final event = occurrence.event;
    if (!event.recurrenceRule.isRepeating || occurrence.sequence <= 0) {
      await deleteGeneralEvent(event.id);
      return;
    }
    final until = occurrence.start
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    await saveGeneralEvent(
      event.copyWith(
        recurrenceRule: event.recurrenceRule.copyWith(untilDateIso: until),
      ),
    );
    final mode = _appData.generalMode;
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        reminderAcknowledgements: mode.reminderAcknowledgements
            .where(
              (item) => !_reminderKeyMatchesEventAtOrAfter(
                item.occurrenceKey,
                event.id,
                occurrence.start,
              ),
            )
            .toList(),
      ),
    );
    await _saveAndNotify();
  }

  List<GeneralEventOccurrence> generalOccurrencesForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
    bool onlyVisibleCalendars = true,
  }) {
    return generalOccurrencesForQuery(
      GeneralOccurrenceQuery(
        startInclusive: startInclusive,
        endExclusive: endExclusive,
        onlyVisibleCalendars: onlyVisibleCalendars,
      ),
    );
  }

  List<GeneralEventOccurrence> generalOccurrencesForQuery(
    GeneralOccurrenceQuery query,
  ) {
    return expandGeneralOccurrences(
      calendars: _appData.generalMode.schedules,
      startInclusive: query.startInclusive,
      endExclusive: query.endExclusive,
      onlyVisibleCalendars: query.onlyVisibleCalendars,
    ).where(query.matches).toList();
  }

  List<GeneralEventOccurrence> upcomingGeneralOccurrences({
    DateTime? now,
    Duration horizon = const Duration(days: 7),
  }) {
    final anchor = now ?? DateTime.now();
    return generalOccurrencesForQuery(
      GeneralOccurrenceQuery(
        startInclusive: anchor,
        endExclusive: anchor.add(horizon),
      ),
    );
  }

  bool isGeneralReminderHandled(GeneralEventOccurrence occurrence) {
    final key = occurrence.occurrenceKey;
    return _appData.generalMode.reminderAcknowledgements.any(
      (item) => item.occurrenceKey == key && item.isHandled,
    );
  }

  Future<void> dismissGeneralReminder(GeneralEventOccurrence occurrence) async {
    final mode = _appData.generalMode;
    final key = occurrence.occurrenceKey;
    final acknowledgement = GeneralReminderAcknowledgement(
      occurrenceKey: key,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        reminderAcknowledgements: [
          ...mode.reminderAcknowledgements.where(
            (item) => item.occurrenceKey != key,
          ),
          acknowledgement,
        ],
      ),
    );
    await _saveAndNotify();
  }

  Future<void> restoreGeneralReminder(GeneralEventOccurrence occurrence) async {
    final mode = _appData.generalMode;
    _appData = _appData.copyWith(
      generalMode: mode.copyWith(
        reminderAcknowledgements: mode.reminderAcknowledgements
            .where((item) => item.occurrenceKey != occurrence.occurrenceKey)
            .toList(),
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
    final anchor = now ?? DateTime.now();
    final upcoming =
        generalOccurrencesForRange(
              startInclusive: anchor,
              endExclusive: anchor.add(upcomingHorizon),
            )
            .where(
              (occurrence) => occurrenceFilter?.matches(occurrence) ?? true,
            )
            .where((occurrence) => !isGeneralReminderHandled(occurrence))
            .where((occurrence) => _isInReminderWindow(occurrence, anchor))
            .map(
              (occurrence) => GeneralReminderItem(
                occurrence: occurrence,
                status: GeneralReminderStatus.upcoming,
              ),
            );
    final overdue =
        generalOccurrencesForRange(
              startInclusive: anchor.subtract(overdueWindow),
              endExclusive: anchor,
            )
            .where(
              (occurrence) => occurrenceFilter?.matches(occurrence) ?? true,
            )
            .where((occurrence) => !isGeneralReminderHandled(occurrence))
            .where((occurrence) => occurrence.end.isBefore(anchor))
            .map(
              (occurrence) => GeneralReminderItem(
                occurrence: occurrence,
                status: GeneralReminderStatus.overdue,
              ),
            );
    return [...upcoming, ...overdue]..sort((a, b) {
      final statusCompare = a.status.index.compareTo(b.status.index);
      if (statusCompare != 0) return statusCompare;
      return a.occurrence.start.compareTo(b.occurrence.start);
    });
  }

  // ── General schedule import / export ──

  String exportSelectedGeneralSchedulesJson(List<String> scheduleIds) {
    final selectedIdSet = scheduleIds.toSet();
    final selected = _appData.generalMode.schedules
        .where((s) => selectedIdSet.contains(s.id))
        .toList();
    if (selected.isEmpty) {
      throw FormatException(
        selectAtLeastOneScheduleMessage(localeCode: _appData.localeCode),
      );
    }
    return encodeGeneralScheduleDataEnvelope(
      GeneralScheduleExportData(schedules: selected),
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
    final selectedIdSet = scheduleIds.toSet();
    final selected = _appData.generalMode.schedules
        .where((s) => selectedIdSet.contains(s.id))
        .toList();
    if (selected.isEmpty) {
      throw FormatException(
        selectAtLeastOneScheduleMessage(localeCode: _appData.localeCode),
      );
    }
    return _generalIcsService.exportSchedules(selected);
  }

  GeneralCalendarIcsImportResult previewImportGeneralSchedulesIcs(
    String source,
  ) {
    return _importGeneralSchedulesIcsSource(source);
  }

  List<GeneralSchedule> previewImportGeneralSchedules(String source) {
    final decoded = decodeGeneralScheduleDataEnvelope(
      source,
      localeCode: _appData.localeCode,
    );
    if (decoded.schedules.isEmpty) {
      throw FormatException(
        noSchedulesInImportMessage(localeCode: _appData.localeCode),
      );
    }
    return decoded.schedules;
  }

  Future<GeneralScheduleImportResult> importSelectedGeneralSchedulesJson(
    String source, {
    required List<String> scheduleIds,
    required GeneralScheduleImportMode mode,
  }) async {
    final imported = decodeGeneralScheduleDataEnvelope(
      source,
      localeCode: _appData.localeCode,
    );
    final selectedIdSet = scheduleIds.toSet();
    final selected = imported.schedules
        .where((s) => selectedIdSet.contains(s.id))
        .toList();
    if (selected.isEmpty) {
      throw FormatException(
        selectAtLeastOneScheduleMessage(localeCode: _appData.localeCode),
      );
    }

    if (mode == GeneralScheduleImportMode.replaceActive) {
      if (selected.length != 1) {
        throw FormatException(
          replaceActiveRequiresSingleScheduleMessage(
            localeCode: _appData.localeCode,
          ),
        );
      }
      final current = activeGeneralScheduleOrNull;
      if (current == null) {
        throw FormatException(
          noActiveScheduleToReplaceMessage(localeCode: _appData.localeCode),
        );
      }
      final replaced = selected.first.copyWith(id: current.id);
      final nextMode = _appData.generalMode
          .copyWith(
            reminderAcknowledgements: _appData
                .generalMode
                .reminderAcknowledgements
                .where(
                  (item) => !_reminderKeyContainsSchedule(
                    item.occurrenceKey,
                    current.id,
                  ),
                )
                .toList(),
          )
          .withSchedule(replaced);
      _appData = _appData.copyWith(generalMode: nextMode);
      await _saveAndNotify();
      return GeneralScheduleImportResult(
        importedCount: 1,
        scheduleNames: [replaced.name],
      );
    }

    final existingIds = _appData.generalMode.schedules.map((s) => s.id).toSet();
    final appended = <GeneralSchedule>[];
    for (final schedule in selected) {
      var nextId = schedule.id.trim();
      if (nextId.isEmpty || existingIds.contains(nextId)) {
        nextId = _nextImportedScheduleId(existingIds);
      }
      existingIds.add(nextId);
      appended.add(schedule.copyWith(id: nextId));
    }

    final mergedSchedules = [..._appData.generalMode.schedules, ...appended];
    _appData = _appData.copyWith(
      generalMode: _appData.generalMode.copyWith(
        schedules: mergedSchedules,
        activeScheduleId: appended.last.id,
      ),
    );
    await _saveAndNotify();
    return GeneralScheduleImportResult(
      importedCount: appended.length,
      scheduleNames: appended.map((schedule) => schedule.name).toList(),
    );
  }

  Future<GeneralScheduleImportResult> importGeneralSchedulesIcs(
    String source, {
    required GeneralScheduleImportMode mode,
  }) async {
    final imported = _importGeneralSchedulesIcsSource(source);
    if (imported.schedules.isEmpty) {
      throw FormatException(
        noSchedulesInImportMessage(localeCode: _appData.localeCode),
      );
    }

    if (mode == GeneralScheduleImportMode.replaceActive) {
      final current = activeGeneralScheduleOrNull;
      if (current == null) {
        throw FormatException(
          noActiveScheduleToReplaceMessage(localeCode: _appData.localeCode),
        );
      }
      final replaced = imported.schedules.first.copyWith(id: current.id);
      final nextMode = _appData.generalMode
          .copyWith(
            reminderAcknowledgements: _appData
                .generalMode
                .reminderAcknowledgements
                .where(
                  (item) => !_reminderKeyContainsSchedule(
                    item.occurrenceKey,
                    current.id,
                  ),
                )
                .toList(),
          )
          .withSchedule(replaced);
      _appData = _appData.copyWith(generalMode: nextMode);
      await _saveAndNotify();
      return GeneralScheduleImportResult(
        importedCount: 1,
        scheduleNames: [replaced.name],
        icsWarnings: imported.warningItems,
      );
    }

    final existingIds = _appData.generalMode.schedules.map((s) => s.id).toSet();
    final appended = <GeneralSchedule>[];
    for (final schedule in imported.schedules) {
      var nextId = schedule.id.trim();
      if (nextId.isEmpty || existingIds.contains(nextId)) {
        nextId = _nextImportedScheduleId(existingIds);
      }
      existingIds.add(nextId);
      appended.add(schedule.copyWith(id: nextId));
    }
    _appData = _appData.copyWith(
      generalMode: _appData.generalMode.copyWith(
        schedules: [..._appData.generalMode.schedules, ...appended],
        activeScheduleId: appended.last.id,
      ),
    );
    await _saveAndNotify();
    return GeneralScheduleImportResult(
      importedCount: appended.length,
      scheduleNames: appended.map((schedule) => schedule.name).toList(),
      icsWarnings: imported.warningItems,
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

  GeneralCalendarIcsImportResult _importGeneralSchedulesIcsSource(
    String source,
  ) {
    try {
      return _generalIcsService.importSchedules(source);
    } on GeneralCalendarIcsImportException catch (error) {
      throw FormatException(_generalIcsImportErrorMessage(error.code));
    }
  }

  String _generalIcsImportErrorMessage(GeneralCalendarIcsImportErrorCode code) {
    return switch (code) {
      GeneralCalendarIcsImportErrorCode.noEvents ||
      GeneralCalendarIcsImportErrorCode.noImportableEvents =>
        noSchedulesInImportMessage(localeCode: _appData.localeCode),
    };
  }

  String _nextGeneralEventId() {
    final existingIds = _appData.generalMode.schedules
        .expand((schedule) => schedule.events)
        .map((event) => event.id)
        .toSet();
    var stamp = DateTime.now().microsecondsSinceEpoch;
    var candidate = 'evt_$stamp';
    while (existingIds.contains(candidate)) {
      stamp += 1;
      candidate = 'evt_$stamp';
    }
    return candidate;
  }

  bool _reminderKeyContainsSchedule(String occurrenceKey, String scheduleId) {
    final parts = occurrenceKey.split('|');
    return parts.isNotEmpty && parts.first == scheduleId;
  }

  bool _reminderKeyContainsEvent(String occurrenceKey, String eventId) {
    final parts = occurrenceKey.split('|');
    return parts.length >= 2 && parts[1] == eventId;
  }

  bool _reminderKeyMatchesEventAtOrAfter(
    String occurrenceKey,
    String eventId,
    DateTime startInclusive,
  ) {
    final parts = occurrenceKey.split('|');
    if (parts.length < 3 || parts[1] != eventId) {
      return false;
    }
    final start = DateTime.tryParse(parts[2]);
    return start != null && !start.isBefore(startInclusive);
  }

  bool _isInReminderWindow(GeneralEventOccurrence occurrence, DateTime now) {
    if (!now.isBefore(occurrence.start)) {
      return false;
    }
    for (final reminder in occurrence.event.reminders) {
      final reminderAt = occurrence.start.subtract(
        Duration(minutes: reminder.minutesBefore),
      );
      if (!now.isBefore(reminderAt)) {
        return true;
      }
    }
    return false;
  }

  // ── Privacy policy (remote-version driven) ──

  String? _remotePrivacyPolicyVersion;

  /// The latest version fetched from the web. Null until the first fetch
  /// succeeds — the app treats null as "nothing to enforce" so the user is
  /// never blocked by a network failure.
  String? get activePrivacyPolicyVersion => _remotePrivacyPolicyVersion;

  String? get acceptedPrivacyPolicyVersion =>
      _appData.privacyPolicyAcceptedVersion;

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
    final version = await _privacy.fetchCurrentPrivacyPolicyVersion();
    if (version == null || _remotePrivacyPolicyVersion == version) return;
    _remotePrivacyPolicyVersion = version;
    notifyListeners();
  }

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

  PeriodTimeSet? get activePeriodTimeSetOrNull {
    final timetable = activeTimetableOrNull;
    if (timetable == null) {
      return _appData.studentMode.periodTimeSets.isEmpty
          ? null
          : _appData.studentMode.periodTimeSets.first;
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
      final fileData = await _repository.load();
      if (fileData != null) {
        _appData = _normalizeImportedAppData(fileData);
      } else {
        _appData = await _buildDefaultAppData();
        await _save();
      }
      _storagePath = await _repository.filePath();
    } catch (e, st) {
      debugPrint('Storage load failed, using defaults: $e\n$st');
      _appData = await _buildDefaultAppData();
      try {
        _storagePath = await _repository.filePath();
      } catch (e2, st2) {
        debugPrint('Storage path unavailable: $e2\n$st2');
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
    if (_appData.studentMode.activeTimetableId == timetableId) {
      return;
    }
    if (!_appData.studentMode.timetables.any(
      (item) => item.id == timetableId,
    )) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        activeTimetableId: timetableId,
      ),
    );
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
    for (final item in _appData.studentMode.timetables) {
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
    final updated = _appData.studentMode.timetables
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
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(timetables: updated),
    );
    if (_appData.studentMode.activeTimetableId == targetTimetable.id) {
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
      _appData.studentMode.conflictDisplayCourseIds,
    )..removeWhere((_, value) => value == courseId);
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        timetables: _appData.studentMode.timetables
            .map(
              (item) => item.id == timetable.id
                  ? item.copyWith(courses: courses)
                  : item,
            )
            .toList(),
        conflictDisplayCourseIds: filteredPrefs,
      ),
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
      studentMode: _appData.studentMode.copyWith(
        activeTimetableId: timetable.id,
        timetables: [..._appData.studentMode.timetables, timetable],
      ),
    );
    _selectedWeek = 1;
    await _saveAndNotify();
  }

  Future<void> deleteTimetable(String timetableId) async {
    if (!_appData.studentMode.timetables.any(
      (item) => item.id == timetableId,
    )) {
      return;
    }
    final remaining = _appData.studentMode.timetables
        .where((item) => item.id != timetableId)
        .toList();
    final nextActiveId =
        remaining.any(
          (item) => item.id == _appData.studentMode.activeTimetableId,
        )
        ? _appData.studentMode.activeTimetableId
        : remaining.isEmpty
        ? ''
        : remaining.first.id;
    final remainingCourseIds = remaining
        .expand((item) => item.courses)
        .map((item) => item.id)
        .toSet();
    final filteredPrefs = Map<String, String>.from(
      _appData.studentMode.conflictDisplayCourseIds,
    )..removeWhere((_, value) => !remainingCourseIds.contains(value));
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        activeTimetableId: nextActiveId,
        timetables: remaining,
        conflictDisplayCourseIds: filteredPrefs,
      ),
    );
    _selectedWeek = _currentWeekForActiveTimetable();
    await _saveAndNotify();
  }

  Future<PeriodTimeSet> addPeriodTimeSet({
    String? name,
    List<CoursePeriodTime>? periodTimes,
  }) async {
    final existingIds = _appData.studentMode.periodTimeSets
        .map((item) => item.id)
        .toSet();
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
      studentMode: _appData.studentMode.copyWith(
        periodTimeSets: [..._appData.studentMode.periodTimeSets, nextSet],
      ),
    );
    await _saveAndNotify();
    return nextSet;
  }

  Future<void> updatePeriodTimeSet(PeriodTimeSet periodTimeSet) async {
    final normalized = _normalizePeriodTimeSet(periodTimeSet);
    final index = _appData.studentMode.periodTimeSets.indexWhere(
      (item) => item.id == normalized.id,
    );
    if (index < 0) {
      return;
    }
    final updated = [..._appData.studentMode.periodTimeSets];
    updated[index] = normalized;
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(periodTimeSets: updated),
    );
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
    final remaining = _appData.studentMode.periodTimeSets
        .where((item) => item.id != periodTimeSetId)
        .toList();
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(periodTimeSets: remaining),
    );
    await _saveAndNotify();
  }

  Future<void> assignPeriodTimeSetToTimetable(
    String timetableId,
    String periodTimeSetId,
  ) async {
    if (periodTimeSetForId(periodTimeSetId) == null) {
      return;
    }
    final updated = _appData.studentMode.timetables
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
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(timetables: updated),
    );
    await _saveAndNotify();
  }

  String? displayedCourseIdForConflict(String conflictKey) =>
      _appData.studentMode.conflictDisplayCourseIds[conflictKey];

  Future<void> setDisplayedCourseForConflict(
    String conflictKey,
    String courseId,
  ) async {
    final updated = Map<String, String>.from(
      _appData.studentMode.conflictDisplayCourseIds,
    )..[conflictKey] = courseId;
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        conflictDisplayCourseIds: updated,
      ),
    );
    await _saveAndNotify();
  }

  String exportAppDataJson() => encodeAppDataEnvelope(_appData);

  String exportSelectedTimetablesJson(List<String> timetableIds) {
    final selectedIdSet = timetableIds.toSet();
    final selectedTimetables = _appData.studentMode.timetables
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
    final linkedSets = _appData.studentMode.periodTimeSets
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
      final existingSetIds = _appData.studentMode.periodTimeSets
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
      final updatedTimetables = _appData.studentMode.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final nextPeriodTimeSets = copiedSet == null
          ? _appData.studentMode.periodTimeSets
          : [..._appData.studentMode.periodTimeSets, copiedSet];
      _appData = _appData.copyWith(
        studentMode: _appData.studentMode.copyWith(
          activeTimetableId: current.id,
          timetables: updatedTimetables,
          periodTimeSets: nextPeriodTimeSets,
          courseNameColorValues: _buildCourseNameColorValuesForTimetables(
            updatedTimetables,
            existing: _appData.studentMode.courseNameColorValues,
          ),
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
    final existingSetIds = _appData.studentMode.periodTimeSets
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

    final existingTimetableIds = _appData.studentMode.timetables
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

    final nextTimetables = [
      ..._appData.studentMode.timetables,
      ...appendedTimetables,
    ];
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        activeTimetableId: appendedTimetables.isEmpty
            ? _appData.studentMode.activeTimetableId
            : appendedTimetables.last.id,
        timetables: nextTimetables,
        periodTimeSets: [
          ..._appData.studentMode.periodTimeSets,
          ...appendedSets,
        ],
        courseNameColorValues: _buildCourseNameColorValuesForTimetables(
          nextTimetables,
          existing: _appData.studentMode.courseNameColorValues,
        ),
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
      if (manualTargetSetId.isEmpty ||
          periodTimeSetForId(manualTargetSetId) == null) {
        throw FormatException(
          noPeriodTimeAvailableMessage(localeCode: _appData.localeCode),
        );
      }
    }

    final existingSetIds = _appData.studentMode.periodTimeSets
        .map((item) => item.id)
        .toSet();
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
      final updatedTimetables = _appData.studentMode.timetables
          .map((item) => item.id == current.id ? replaced : item)
          .toList();
      final nextPeriodTimeSets = bundledPeriodTimeSet == null
          ? _appData.studentMode.periodTimeSets
          : [..._appData.studentMode.periodTimeSets, bundledPeriodTimeSet];
      _appData = _appData.copyWith(
        studentMode: _appData.studentMode.copyWith(
          activeTimetableId: current.id,
          timetables: updatedTimetables,
          periodTimeSets: nextPeriodTimeSets,
          courseNameColorValues: _buildCourseNameColorValuesForTimetables(
            updatedTimetables,
            existing: _appData.studentMode.courseNameColorValues,
          ),
        ),
      );
      _selectedWeek = currentWeekFor(replaced.config);
      await _saveAndNotify();
      return;
    }

    final nextTimetables = [..._appData.studentMode.timetables, timetable];
    final nextPeriodTimeSets = bundledPeriodTimeSet == null
        ? _appData.studentMode.periodTimeSets
        : [..._appData.studentMode.periodTimeSets, bundledPeriodTimeSet];
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        activeTimetableId: timetable.id,
        timetables: nextTimetables,
        periodTimeSets: nextPeriodTimeSets,
        courseNameColorValues: _buildCourseNameColorValuesForTimetables(
          nextTimetables,
          existing: _appData.studentMode.courseNameColorValues,
        ),
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

    final matchedSlots =
        periodTimes.where((slot) => periods.contains(slot.index)).toList()
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
    } catch (e, st) {
      debugPrint('Failed to load default period times from assets: $e\n$st');
      return buildDefaultPeriodTimes();
    }
  }

  Future<AppData> _buildDefaultAppData() async {
    final periodTimes = await _loadDefaultPeriodTimes();
    return _normalizeImportedAppData(
      buildInitialAppData(periodTimes, localeCode: _systemLocaleCodeResolver()),
    );
  }

  Future<void> updateCloseCoursePopupOnOutsideTap(bool value) async {
    _appData = _settings.updateCloseCoursePopupOnOutsideTap(_appData, value);
    await _saveAndNotify();
  }

  Future<void> updatePreserveTimetableGaps(bool value) async {
    if (_appData.studentMode.preserveTimetableGaps == value) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(preserveTimetableGaps: value),
    );
    await _saveAndNotify();
  }

  Future<void> updateShowPastEndedCourses(bool value) async {
    if (_appData.studentMode.showPastEndedCourses == value) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(showPastEndedCourses: value),
    );
    await _saveAndNotify();
  }

  Future<void> updateShowFutureCourses(bool value) async {
    if (_appData.studentMode.showFutureCourses == value) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(showFutureCourses: value),
    );
    await _saveAndNotify();
  }

  Future<void> updateShowTimetableGridLines(bool value) async {
    if (_appData.studentMode.showTimetableGridLines == value) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(showTimetableGridLines: value),
    );
    await _saveAndNotify();
  }

  Future<void> updateLocaleCode(String localeCode) async {
    _appData = _settings.updateLocaleCode(_appData, localeCode);
    await _saveAndNotify();
  }

  Future<void> updateThemeMode(String themeMode) async {
    _appData = _settings.updateThemeMode(_appData, themeMode);
    await _saveAndNotify();
  }

  Future<void> updateThemeSeedColorValue(int colorValue) async {
    _appData = _settings.updateThemeSeedColorValue(_appData, colorValue);
    await _saveAndNotify();
  }

  Future<void> updateThemeColorMode(String mode) async {
    _appData = _settings.updateThemeColorMode(_appData, mode);
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
    if (_appData.studentMode.colorfulCourseTextColorMode == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        colorfulCourseTextColorMode: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCourseNameColorValue(
    String courseName,
    int colorValue,
  ) async {
    final normalizedCourseName = normalizeCourseColorName(courseName);
    if (normalizedCourseName.isEmpty) {
      return;
    }
    if (_appData.studentMode.courseNameColorValues[normalizedCourseName] ==
        colorValue) {
      return;
    }
    final updated = Map<String, int>.from(
      _appData.studentMode.courseNameColorValues,
    )..[normalizedCourseName] = colorValue;
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        courseNameColorValues: updated,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateSchoolImportParserSource(String source) async {
    final normalized = normalizeSchoolImportParserSource(source);
    if (_appData.studentMode.schoolImportParserSettings.source == normalized) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        schoolImportParserSettings: _appData
            .studentMode
            .schoolImportParserSettings
            .copyWith(source: normalized),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportBaseUrl(String value) async {
    final normalized = value.trim();
    if (_appData.studentMode.schoolImportParserSettings.customBaseUrl ==
        normalized) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        schoolImportParserSettings: _appData
            .studentMode
            .schoolImportParserSettings
            .copyWith(customBaseUrl: normalized),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportApiKey(String value) async {
    final normalized = value.trim();
    if (_appData.studentMode.schoolImportParserSettings.customApiKey ==
        normalized) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        schoolImportParserSettings: _appData
            .studentMode
            .schoolImportParserSettings
            .copyWith(customApiKey: normalized),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportModel(String value) async {
    final normalized = value.trim();
    if (_appData.studentMode.schoolImportParserSettings.customModel ==
        normalized) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        schoolImportParserSettings: _appData
            .studentMode
            .schoolImportParserSettings
            .copyWith(customModel: normalized),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateCustomSchoolImportPrompt(String value) async {
    final normalized = value.trim();
    if (_appData.studentMode.schoolImportParserSettings.customPrompt ==
        normalized) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        schoolImportParserSettings: _appData
            .studentMode
            .schoolImportParserSettings
            .copyWith(customPrompt: normalized),
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateSchoolImportParserSettings(
    SchoolImportParserSettings settings,
  ) async {
    final normalized = settings.copyWith();
    final current = _appData.studentMode.schoolImportParserSettings;
    if (current.source == normalized.source &&
        current.customBaseUrl == normalized.customBaseUrl &&
        current.customApiKey == normalized.customApiKey &&
        current.customModel == normalized.customModel &&
        current.customPrompt == normalized.customPrompt) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        schoolImportParserSettings: normalized,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineColorValue(int colorValue) async {
    if (_appData.studentMode.liveCourseOutlineColorValue == colorValue) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        liveCourseOutlineColorValue: colorValue,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineEnabled(bool value) async {
    if (_appData.studentMode.liveCourseOutlineEnabled == value) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        liveCourseOutlineEnabled: value,
      ),
    );
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineFollowTheme(bool value) async {
    if (_appData.studentMode.liveCourseOutlineFollowTheme == value) {
      return;
    }
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        liveCourseOutlineFollowTheme: value,
      ),
    );
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
      studentMode: _appData.studentMode.copyWith(
        liveCourseOutlineEnabled: enabled,
        liveCourseOutlineFollowTheme: followTheme,
        liveCourseOutlineColorValue: colorValue,
        liveCourseOutlineCustomColorInitialized: customColorInitialized,
        liveCourseOutlineMode: normalizedMode,
        liveCourseOutlineWidth: normalizedWidth,
      ),
    );
    if (nextData.studentMode.liveCourseOutlineEnabled ==
            _appData.studentMode.liveCourseOutlineEnabled &&
        nextData.studentMode.liveCourseOutlineFollowTheme ==
            _appData.studentMode.liveCourseOutlineFollowTheme &&
        nextData.studentMode.liveCourseOutlineColorValue ==
            _appData.studentMode.liveCourseOutlineColorValue &&
        nextData.studentMode.liveCourseOutlineCustomColorInitialized ==
            _appData.studentMode.liveCourseOutlineCustomColorInitialized &&
        nextData.studentMode.liveCourseOutlineMode ==
            _appData.studentMode.liveCourseOutlineMode &&
        nextData.studentMode.liveCourseOutlineWidth ==
            _appData.studentMode.liveCourseOutlineWidth) {
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
    final nextValue = normalized == null || normalized.isEmpty
        ? null
        : normalized;
    if (_appData.availableUpdateVersion == nextValue) {
      return;
    }
    _appData = _appData.copyWith(availableUpdateVersion: nextValue);
    await _saveAndNotify();
  }

  Future<void> _replaceActiveTimetable(TimetableData timetable) async {
    final updated = _appData.studentMode.timetables
        .map((item) => item.id == timetable.id ? timetable : item)
        .toList();
    _appData = _appData.copyWith(
      studentMode: _appData.studentMode.copyWith(
        timetables: updated,
        courseNameColorValues: _buildCourseNameColorValuesForTimetables(
          updated,
          existing: _appData.studentMode.courseNameColorValues,
        ),
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
    return _colorfulCoursePalette[usedColors.length %
        _colorfulCoursePalette.length];
  }

  AppData _normalizeImportedAppData(AppData data) {
    final normalizedSets = <PeriodTimeSet>[];
    final normalizedSetIds = <String>{};
    for (final item in data.studentMode.periodTimeSets) {
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
    for (final item in data.studentMode.timetables) {
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
        courseNameColorValues: _buildCourseNameColorValuesForTimetables(
          normalizedTimetables,
          existing: data.studentMode.courseNameColorValues,
        ),
      ),
      localeCode: app_locale.normalizeLocaleCode(data.localeCode),
      generalMode: data.generalMode.normalized(),
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
          timetables: appData.studentMode.timetables,
          periodTimeSets: appData.studentMode.periodTimeSets,
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
    await _repository.save(_appData);
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
