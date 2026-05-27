import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/app_repository.dart';
import '../data/timetable_storage.dart';
import '../l10n/app_locale.dart' as app_locale;
import '../models/school_import_models.dart';
import '../models/timetable_models.dart';
import '../services/general_calendar_service.dart';
import '../services/general_calendar_ics_service.dart';
import '../services/general_occurrence_service.dart';
import '../services/import_export_service.dart';
import '../services/privacy_service.dart';
import '../services/settings_service.dart';
import '../services/student_timetable_service.dart' as student_timetable;

part 'timetable_provider_general.dart';
part 'timetable_provider_import_export.dart';
part 'timetable_provider_lifecycle.dart';
part 'timetable_provider_settings.dart';
part 'timetable_provider_student.dart';

const _calendarService = GeneralCalendarService();
const _occurrenceService = GeneralOccurrenceService();
const _importExportService = ImportExportService();
const _studentTimetableService = student_timetable.StudentTimetableService();

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

abstract class _TimetableProviderBase extends ChangeNotifier {
  AppData get _appData;
  set _appData(AppData value);

  int get _selectedWeek;
  set _selectedWeek(int value);

  bool get _isLoaded;
  set _isLoaded(bool value);

  bool get _isLoading;
  set _isLoading(bool value);

  set _storagePath(String? value);

  AppRepository get _repository;
  String Function() get _systemLocaleCodeResolver;
  SettingsService get _settings;
  PrivacyService get _privacy;

  GeneralSchedule? get activeGeneralScheduleOrNull;
  TimetableData? get activeTimetableOrNull;
  PeriodTimeSet? get activePeriodTimeSetOrNull;
  PeriodTimeSet get activePeriodTimeSet;

  int _currentWeekForActiveTimetable();
  Future<List<CoursePeriodTime>> _loadDefaultPeriodTimes();
  Future<AppData> _buildDefaultAppData();
  Future<void> _saveAndNotify();
  Future<void> _save();
}

class TimetableProvider extends _TimetableProviderBase
    with
        _TimetableProviderGeneral,
        _TimetableProviderStudent,
        _TimetableProviderImportExport,
        _TimetableProviderLifecycle,
        _TimetableProviderSettings {
  TimetableProvider({
    TimetableStorage? storage,
    AppRepository? repository,
    String Function()? systemLocaleCodeResolver,
    SettingsService? settingsService,
    PrivacyService? privacyService,
  }) : _repository =
           repository ?? AppRepository(storage: storage ?? TimetableStorage()),
       _systemLocaleCodeResolver =
           systemLocaleCodeResolver ?? _defaultSystemLocaleCodeResolver,
       _settings = settingsService ?? const SettingsService(),
       _privacy = privacyService ?? const PrivacyService();

  @override
  final AppRepository _repository;
  @override
  final String Function() _systemLocaleCodeResolver;
  @override
  final SettingsService _settings;
  @override
  final PrivacyService _privacy;

  @override
  AppData _appData = buildInitialAppData(buildDefaultPeriodTimes());
  @override
  int _selectedWeek = 1;
  @override
  bool _isLoaded = false;
  @override
  bool _isLoading = false;
  @override
  String? _storagePath;

  bool get isLoaded => _isLoaded;
  bool get hasTimetables => _appData.studentMode.timetables.isNotEmpty;
  bool get hasPeriodTimeSets => _appData.studentMode.periodTimeSets.isNotEmpty;
  List<TimetableData> get timetables => _appData.studentMode.timetables;
  List<PeriodTimeSet> get periodTimeSets => _appData.studentMode.periodTimeSets;
  int get selectedWeek => _selectedWeek;
  String? get storagePath => _storagePath;

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

  @override
  Future<void> _saveAndNotify() async {
    final previous = _repository.current;
    try {
      await _save();
    } catch (_) {
      if (previous != null) {
        _appData = previous;
        _selectedWeek = _currentWeekForActiveTimetable();
      }
      rethrow;
    }
    notifyListeners();
  }

  @override
  Future<void> _save() async {
    final normalized = _importExportService.normalizeAppData(
      _appData,
      localeCode: _appData.localeCode,
    );
    await _repository.save(normalized);
    _appData = normalized;
  }
}
