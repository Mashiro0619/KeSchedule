part of 'timetable_provider.dart';

mixin _TimetableProviderSettings on _TimetableProviderBase {
  Future<void> updateCloseCoursePopupOnOutsideTap(bool value) async {
    _appData = _settings.updateCloseCoursePopupOnOutsideTap(_appData, value);
    await _saveAndNotify();
  }

  Future<void> updatePreserveTimetableGaps(bool value) async {
    _appData = _settings.updatePreserveTimetableGaps(_appData, value);
    await _saveAndNotify();
  }

  Future<void> updateShowPastEndedCourses(bool value) async {
    _appData = _settings.updateShowPastEndedCourses(_appData, value);
    await _saveAndNotify();
  }

  Future<void> updateShowFutureCourses(bool value) async {
    _appData = _settings.updateShowFutureCourses(_appData, value);
    await _saveAndNotify();
  }

  Future<void> updateShowTimetableGridLines(bool value) async {
    _appData = _settings.updateShowTimetableGridLines(_appData, value);
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
    _appData = _settings.updateColorfulUiColorValue(_appData, key, colorValue);
    await _saveAndNotify();
  }

  Future<void> updateColorfulCourseTextColorMode(String mode) async {
    _appData = _settings.updateColorfulCourseTextColorMode(_appData, mode);
    await _saveAndNotify();
  }

  Future<void> updateCourseNameColorValue(
    String courseName,
    int colorValue,
  ) async {
    _appData = _settings.updateCourseNameColorValue(
      _appData,
      courseName,
      colorValue,
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
    _appData = _settings.updateSchoolImportParserSettings(_appData, settings);
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineColorValue(int colorValue) async {
    _appData = _settings.updateLiveCourseOutlineColorValue(
      _appData,
      colorValue,
    );
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineEnabled(bool value) async {
    _appData = _settings.updateLiveCourseOutlineEnabled(_appData, value);
    await _saveAndNotify();
  }

  Future<void> updateLiveCourseOutlineFollowTheme(bool value) async {
    _appData = _settings.updateLiveCourseOutlineFollowTheme(_appData, value);
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
    _appData = _settings.updateLiveCourseOutlineSettings(
      _appData,
      enabled: enabled,
      followTheme: followTheme,
      colorValue: colorValue,
      customColorInitialized: customColorInitialized,
      mode: mode,
      width: width,
    );
    await _saveAndNotify();
  }
}
