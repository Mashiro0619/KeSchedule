// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Week $week';
  }

  @override
  String get addCourse => 'Add course';

  @override
  String get settings => 'Settings';

  @override
  String get multiTimetableSwitch => 'Switch timetables';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Current timetable · $weeks weeks';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Tap to switch · $weeks weeks';
  }

  @override
  String get editTimetable => 'Edit timetable';

  @override
  String get createTimetable => 'New timetable';

  @override
  String get jumpToWeek => 'Jump to week';

  @override
  String get timetable => 'Timetable';

  @override
  String get timetableName => 'Timetable name';

  @override
  String get totalWeeks => 'Total weeks';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get deleteTimetableTitle => 'Delete timetable';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'No timetable yet';

  @override
  String get noTimetableMessage =>
      'Create a timetable or import one from a JSON file.';

  @override
  String get importTimetable => 'Import timetable';

  @override
  String get courseName => 'Course name';

  @override
  String get location => 'Location';

  @override
  String get dayOfWeek => 'Day';

  @override
  String get semesterWeeks => 'Weeks';

  @override
  String get startTime => 'Start time';

  @override
  String get endTime => 'End time';

  @override
  String get linkedPeriods => 'Linked periods';

  @override
  String get linkedPeriodsUnmatched =>
      'No periods matched for the current time. Tap to choose manually.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Period $start-$end';
  }

  @override
  String get teacherName => 'Teacher';

  @override
  String get credits => 'Credits';

  @override
  String get remarks => 'Remarks';

  @override
  String get customFields => 'Custom fields';

  @override
  String get customFieldsHint => 'One per line, format: key:value';

  @override
  String get selectDayOfWeek => 'Choose day';

  @override
  String get selectSemesterWeeks => 'Choose weeks';

  @override
  String get selectAll => 'Select all';

  @override
  String get clear => 'Clear';

  @override
  String get confirm => 'Confirm';

  @override
  String get selectLinkedPeriods => 'Choose linked periods';

  @override
  String get addCourseTitle => 'Add course';

  @override
  String get editCourseTitle => 'Edit course';

  @override
  String get editCourseTooltip => 'Edit course';

  @override
  String get place => 'Location';

  @override
  String get time => 'Time';

  @override
  String get notFilled => 'Not filled';

  @override
  String get none => 'None';

  @override
  String get conflictCourses => 'Conflicting courses';

  @override
  String get locationNotFilled => 'Location not filled';

  @override
  String get setAsDisplayed => 'Set as displayed';

  @override
  String get editThisCourse => 'Edit this course';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get noTimetableSettings =>
      'No timetable is currently available for settings.';

  @override
  String get semesterStartDate => 'Semester start date';

  @override
  String get periodTimeSets => 'Period time set';

  @override
  String get noPeriodTimeAvailable => 'No available period time set';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count periods';
  }

  @override
  String get coursePopupDismissSetting =>
      'Allow outside tap to close course popup';

  @override
  String get coursePopupDismissSettingHint =>
      'Turning this off also disables swipe-down dismissal.';

  @override
  String get preserveTimetableGaps => 'Preserve timetable gaps';

  @override
  String get preserveTimetableGapsHint =>
      'When off, lunch and break gaps are collapsed so later classes move upward.';

  @override
  String get showPastEndedCourses => 'Show past-ended courses';

  @override
  String get showPastEndedCoursesHint =>
      'Show courses that have already finished by the real current week with a lighter gray style.';

  @override
  String get showFutureCourses => 'Show future courses';

  @override
  String get showFutureCoursesHint =>
      'Show courses that are not active this week but will appear in later weeks with a gray style.';

  @override
  String get timetableDisplaySettings => 'Timetable display and interaction';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup dismissal, gaps, gray courses, and grid lines';

  @override
  String get showTimetableGridLines => 'Show timetable grid lines';

  @override
  String get showTimetableGridLinesHint =>
      'Control whether horizontal and vertical grid lines are visible in the timetable.';

  @override
  String get liveCourseOutlineColor => 'Course outline color';

  @override
  String get liveCourseOutlineColorHint =>
      'Choose whether outlines target the current/next course or all displayed courses on the current page.';

  @override
  String get liveCourseOutlineSettings => 'Course outline';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Configure whether the outline is enabled, what it targets, whether it follows the theme color, and the effective outline color.';

  @override
  String get liveCourseOutlineEnabled => 'Enable outline';

  @override
  String get liveCourseOutlineFollowTheme => 'Follow theme color';

  @override
  String get liveCourseOutlineTarget => 'Outline target';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Current/next course';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'All displayed courses';

  @override
  String get liveCourseOutlineEffectiveColor => 'Effective color';

  @override
  String get liveCourseOutlineCustomColor => 'Custom outline color';

  @override
  String get liveCourseOutlineWidth => 'Outline width';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Language';

  @override
  String get languagePageDescription =>
      'Choose one of the languages that is truly available in the app.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API response';

  @override
  String get theme => 'Theme';

  @override
  String get themeFollowSystem => 'Follow system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeColor => 'Theme color';

  @override
  String get themeColorModeSingle => 'Single theme color';

  @override
  String get themeColorModeColorful => 'Colorful';

  @override
  String get themeColorUiColors => 'UI colors';

  @override
  String get themeColorCourseColors => 'Course colors';

  @override
  String get themeColorPrimary => 'Primary';

  @override
  String get themeColorSecondary => 'Secondary';

  @override
  String get themeColorTertiary => 'Tertiary';

  @override
  String get themeColorCourseText => 'Course text';

  @override
  String get themeColorCourseTextAuto => 'Auto';

  @override
  String get themeColorCourseTextCustom => 'Custom color';

  @override
  String get themeColorCourseColorsEmpty =>
      'Course colors will be generated after importing a timetable.';

  @override
  String get themeCustomColor => 'Custom color';

  @override
  String get themeApplyCustomColor => 'Apply color';

  @override
  String get themeApplySettings => 'Apply settings';

  @override
  String get dataImportExport => 'Import and export data';

  @override
  String get dataImportExportDesc =>
      'Import full data or single timetables, or export current/all timetables.';

  @override
  String get openSourceLicenses => 'Open-source licenses';

  @override
  String get openSourceLicensesDesc =>
      'View licenses for Flutter dependencies and bundled app icon assets.';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Official website / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Already on the latest version ($version)';
  }

  @override
  String get currentVersionLabel => 'Current version';

  @override
  String get newVersionAvailable => 'Update available';

  @override
  String get latestVersionLabel => 'Latest version';

  @override
  String get updateContentLabel => 'Update details';

  @override
  String get officialWebsite => 'Official website';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Cloud drive';

  @override
  String get ignoreThisVersion => 'Ignore this version';

  @override
  String get openUpdatesFailed => 'Unable to open the update link';

  @override
  String get updateCheckFailedTitle => 'Update check failed';

  @override
  String get updateCheckFailedMessage =>
      'Unable to get valid update information from any update source. You can still use the links below to update manually.';

  @override
  String get githubRepository => 'GitHub repository';

  @override
  String get openGithubFailed => 'Unable to open the GitHub repository link';

  @override
  String get selectPeriodTimeSet => 'Choose period time set';

  @override
  String get newItem => 'New';

  @override
  String get editPeriodTimeSet => 'Edit period time set';

  @override
  String get importTimetableFiles => 'Import timetable';

  @override
  String get importTimetableFilesDesc =>
      'Supports one or multiple timetable files.';

  @override
  String get importTimetableText => 'Import timetable from text';

  @override
  String get importTimetableTextDesc =>
      'Paste timetable JSON content and import it.';

  @override
  String get shareTimetableFiles => 'Share timetable files';

  @override
  String get shareTimetableFilesDesc => 'Choose one or more timetables first.';

  @override
  String get saveTimetableFiles => 'Save timetable files';

  @override
  String get saveTimetableFilesDesc => 'Choose one or more timetables first.';

  @override
  String get exportTimetableText => 'Export timetable as text';

  @override
  String get exportTimetableTextDesc =>
      'Choose one or more timetables, then copy the JSON content.';

  @override
  String get jsonContent => 'JSON content';

  @override
  String get pasteJsonContentHint => 'Paste the JSON content to import.';

  @override
  String get jsonContentEmpty => 'Paste JSON content first.';

  @override
  String get copyText => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get share => 'Share';

  @override
  String get selectTimetablesToExport => 'Choose timetables to export';

  @override
  String get selectTimetablesToImport => 'Choose timetables to import';

  @override
  String timetableCourseCount(int count) {
    return '$count courses';
  }

  @override
  String get importAction => 'Import';

  @override
  String get importTimetableDialogTitle => 'Import timetable';

  @override
  String get chooseImportMethod => 'Choose how to import.';

  @override
  String get importAsNewTimetable => 'Import as new timetable';

  @override
  String get replaceCurrentTimetable => 'Replace current timetable';

  @override
  String get importPeriodTimeSetDialogTitle => 'Import period time sets';

  @override
  String get importPeriodTimeSetDialogBody =>
      'This file contains bundled period time sets. Do you want to import and associate them?';

  @override
  String get importBundledPeriodTimeSets => 'Import and associate';

  @override
  String get discardBundledPeriodTimeSets => 'Discard bundled sets';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'No existing period time set is available, so bundled period time sets cannot be discarded.';

  @override
  String savedToPath(Object path) {
    return 'Saved to $path';
  }

  @override
  String get saveCancelled => 'Save cancelled';

  @override
  String get fileSaveRestrictedTitle => 'File saving restricted';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'The system could not save the file. You can retry or use sharing instead.';

  @override
  String get retrySave => 'Retry save';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Enable file access in system settings, then return and try exporting again.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get browserDownloadRestrictedTitle => 'Browser download restricted';

  @override
  String get browserDownloadRestrictedMessage =>
      'This browser does not support directly saving to a local file. Check browser download permissions or use file sharing instead.';

  @override
  String get switchToShare => 'Use sharing instead';

  @override
  String get fileSaveFailedTitle => 'File save failed';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Unable to write to the current path. The target folder may be protected, the file may be in use, or the path may be unwritable.';

  @override
  String get fileSaveFailedGenericMessage =>
      'The system could not save the file. You can retry, check system settings, or use file sharing instead.';

  @override
  String get retryLater => 'Try again later';

  @override
  String get exportSwitchedToShare => 'Switched to file sharing for export';

  @override
  String get saveFailedRetry => 'Save failed. Please try again later.';

  @override
  String get importFailedCheckContent =>
      'Import failed. Please check the file content.';

  @override
  String get noImportableTimetables =>
      'No usable timetables were found in the imported file.';

  @override
  String importedTimetablesCount(int count) {
    return 'Imported $count timetables';
  }

  @override
  String get periodTimesTitle => 'Period times';

  @override
  String get importExport => 'Import and export';

  @override
  String get importPeriodTemplate => 'Import period template';

  @override
  String get importPeriodTemplateText => 'Import period template from text';

  @override
  String get sharePeriodTemplate => 'Share period template';

  @override
  String get saveTemplateToFile => 'Save template to file';

  @override
  String get exportPeriodTemplateText => 'Export period template as text';

  @override
  String get deletePeriodTimeSet => 'Delete period time set';

  @override
  String get periodTimeSetName => 'Period time set name';

  @override
  String get addOnePeriod => 'Add period';

  @override
  String periodNumberLabel(int index) {
    return 'Period $index';
  }

  @override
  String get deleteThisPeriod => 'Delete this period';

  @override
  String durationMinutes(int minutes) {
    return 'Duration $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Gap from previous $minutes min';
  }

  @override
  String get endTimeMustBeLater => 'End time must be later than start time';

  @override
  String get periodOverlapPrevious => 'This period overlaps the previous one';

  @override
  String get periodTimesSaved => 'Period times saved';

  @override
  String get deletePeriodTimeSetTitle => 'Delete period time set';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'current period time set';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Imported $count period times';
  }

  @override
  String get periodFilePermissionTitle => 'File permission needed';

  @override
  String get androidFilePermissionMessage =>
      'Android export requires file access permission. Grant permission to continue saving.';

  @override
  String get reauthorize => 'Authorize again';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Permission permanently denied';

  @override
  String get permissionSettingsExportMessage =>
      'Enable file access in system settings, then return and try exporting again.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyEntryDesc =>
      'Learn how the app handles local storage, school-site configuration, file import/export, webpage parsing, and external links.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Accepted version: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked is a local-first timetable tool. Timetables, period-time sets, and school-site configuration are stored only on your device or in your browser, and are never automatically uploaded. The app only processes data when you explicitly trigger actions such as import, webpage parsing, sharing, or opening external links. The full privacy policy is available online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Local storage';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Timetable data and related settings are stored in a local file named Sked_data.json inside the app documents directory. Editable school-site configuration is stored separately in Sked_school_sites.json. Custom timetable parser settings, including any custom Base URL, API key, and selected model, are also stored locally in the same app data and are not protected by a system credential vault. When used in a browser, the same kinds of data are stored in browser storage. The app does not automatically upload this local data to a developer-controlled server.';

  @override
  String get privacyPolicyImportExportTitle => 'Import and export';

  @override
  String get privacyPolicyImportExportBody =>
      'The app reads or writes timetable JSON files, school-site JSON files, and period-template files only when you explicitly choose a file or start an export action. Importing these files is a local operation unless you also choose webpage parsing. Fetching a custom model list is also an explicit network action and only contacts the custom endpoint you configured.';

  @override
  String get privacyPolicySharingTitle => 'Sharing';

  @override
  String get privacyPolicySharingBody =>
      'When you explicitly use sharing, the app passes the exported file to the system share sheet or to the target app you choose. How that file is handled afterward depends on the target app or service you selected.';

  @override
  String get privacyPolicyExternalLinksTitle => 'External links';

  @override
  String get privacyPolicyExternalLinksBody =>
      'When you open external links such as the GitHub repository, the app hands the action off to your browser or another external application. Data handling after that point is governed by the third party you open.';

  @override
  String get privacyPolicyNoCollectionTitle => 'What the app does not collect';

  @override
  String get privacyPolicyNoCollectionBody =>
      'The app does not require a Sked account and does not enable analytics, advertising identifiers, or cloud backup. It also does not provide a dedicated field for collecting school account passwords. If you sign in to a school website inside the app, that interaction happens on the school page you opened.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Webpage parsing';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'When you use school webpage import or paste HTML for parsing, the app first compresses the content locally, then sends the submitted page content, optional page title and URL, the current app language, and parser prompt content to the selected parsing endpoint. If you use the official parser, the request goes to the app\'s configured official backend. If you enable a custom OpenAI-compatible parser, the same content is sent directly to the third-party endpoint you configured, and fetching the model list also requests that same endpoint. A custom endpoint may forward the request to other AI services according to that provider\'s own design. The deployed official backend currently limits each submitted payload to 300KB, uses its configured timeout, and allows at most 5 parsing requests per IP per day.';

  @override
  String get privacyPolicyUpdatesTitle => 'Policy updates';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'The current privacy policy version is $version. If a later version changes how data is handled, the app may ask you to read and agree to the updated policy again.';
  }

  @override
  String get privacyGateTitle =>
      'Please agree to the privacy policy before using the app';

  @override
  String get privacyGateSummaryStorage =>
      'Timetables, period-time sets, and school-site configuration are only stored locally and are not automatically uploaded to a developer server.';

  @override
  String get privacyGateSummaryImportExport =>
      'Import, export, and sharing only happen when you explicitly start them; webpage parsing sends only the compressed content you submit to your configured parsing endpoint, and you can review the parsed timetable before saving.';

  @override
  String get privacyGateSummaryUpdates =>
      'If a later version changes how data is handled, the app may ask you to review the updated privacy policy again.';

  @override
  String get schoolWebImportEntry => 'Import from school webpage';

  @override
  String get schoolWebImportEntryDesc =>
      'Import the current timetable page from the school site.';

  @override
  String get schoolSitesManageEntry => 'Manage school sites';

  @override
  String get schoolSitesManageEntryDesc =>
      'Add, edit, and delete school login URLs, with JSON import and export.';

  @override
  String get schoolSitesPageTitle => 'School site management';

  @override
  String get schoolSitesImportJson => 'Import school JSON';

  @override
  String get schoolSitesShareJson => 'Share school JSON';

  @override
  String get schoolSitesSaveJson => 'Save school JSON';

  @override
  String get schoolSitesSaved => 'School sites saved';

  @override
  String get schoolSitesImported => 'School sites imported';

  @override
  String get schoolSitesEmpty => 'No school site configuration yet.';

  @override
  String get schoolSitesNameLabel => 'School name';

  @override
  String get schoolSitesLoginUrlLabel => 'Login URL';

  @override
  String get schoolSitesAdd => 'Add school';

  @override
  String get schoolSitesEdit => 'Edit school';

  @override
  String get schoolSitesDeleteTitle => 'Delete school';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Fill in the school name and login URL first.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Import by pasting timetable page content';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Paste source code or raw page content containing timetable information manually.';

  @override
  String get schoolHtmlImportPageTitle => 'Parse timetable from page content';

  @override
  String get schoolHtmlImportUrlLabel => 'Source URL (optional)';

  @override
  String get schoolHtmlImportTitleLabel => 'Page title (optional)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Page content';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Paste source code or raw page content containing timetable information here.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Any content containing timetable information can be parsed and imported, not just HTML.';

  @override
  String get schoolHtmlImportCompress => 'Compress content';

  @override
  String get schoolHtmlImportCompressed => 'Content compressed';

  @override
  String get schoolHtmlImportCompressFirst => 'Compress the content first.';

  @override
  String get schoolHtmlImportSubmit => 'Parse and import';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsing may take a while. Please wait.';

  @override
  String get schoolHtmlImportEmpty => 'Paste the page HTML first.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Back to webpage';

  @override
  String get schoolWebImportPageTitle => 'School webpage import';

  @override
  String get schoolWebImportPreview => 'Import preview';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count courses';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count periods';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Page title';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Import notes';

  @override
  String get schoolWebImportOpenPageHint =>
      'Sign in to the school site in-app, then navigate to the timetable page manually.';

  @override
  String get schoolWebImportConfigMissing =>
      'Web import backend API is not configured yet.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'This platform does not support embedded web login yet. Please use a platform with WebView support.';

  @override
  String get schoolWebImportSelectSchool => 'Choose school';

  @override
  String get schoolWebImportNoSchools =>
      'No school configuration is available. Check school_sites.json first.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Failed to load school configuration. Check the JSON file format.';

  @override
  String get schoolWebImportImportCurrentPage => 'Import current page';

  @override
  String get schoolWebImportGoBack => 'Previous page';

  @override
  String get schoolWebImportLoadingPage => 'Loading page…';

  @override
  String get schoolWebImportParsing => 'Parsing current page…';

  @override
  String get schoolWebImportLoadFailed =>
      'Page load failed. Please refresh or try again later.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Page loading timed out. Please refresh and try again.';

  @override
  String get schoolWebImportEmptyPage =>
      'The current page content is empty and cannot be imported yet.';

  @override
  String get schoolWebImportSuccess => 'Web timetable imported';

  @override
  String get schoolImportParserSettingsTitle => 'Timetable parser settings';

  @override
  String get schoolImportParserSettingsDesc =>
      'Choose the official parser or a custom OpenAI-compatible endpoint.';

  @override
  String get schoolImportParserSourceTitle => 'Parser source';

  @override
  String get schoolImportParserSourceOfficial => 'Official parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Use the built-in official parsing service configured by the app.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'The official parser uses the app\'s configured parsing backend and keeps the current import flow unchanged.';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'Custom OpenAI-compatible';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Send the page content directly to your own OpenAI-compatible endpoint.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Custom OpenAI-compatible parser';

  @override
  String get schoolImportParserCustomPromptTitle => 'Custom prompt';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Edit the built-in parser prompt here. Changes only affect the custom OpenAI-compatible parser.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'The built-in prompt is loaded here by default. Clear it to fall back to the built-in version.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Reset default prompt';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'Model';

  @override
  String get schoolImportParserFetchModels => 'Fetch model list';

  @override
  String get schoolImportParserFetchingModels => 'Fetching models...';

  @override
  String get schoolImportParserNoModelsFound =>
      'No models were returned by the endpoint.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Fetched $count models';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'The custom API key is stored in the app\'s local settings in plaintext under the current implementation. Only use it on a device or browser environment you trust.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Custom parser configuration is incomplete. Fill in the base URL, API key, and model first.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Official';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: Custom ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'View full privacy policy';

  @override
  String get privacyAgreeAndContinue => 'Agree and continue';

  @override
  String get privacyDecline => 'Decline';

  @override
  String get privacyDeclineWebHint =>
      'This browser environment does not allow the app to close the page for you. If you do not agree, please close this tab or window yourself.';

  @override
  String get defaultPeriodTimeSetName => 'Default periods';

  @override
  String get periodTimeSetFallbackName => 'Period times';

  @override
  String get untitledTimetableName => 'Untitled timetable';

  @override
  String get newTimetableName => 'New timetable';

  @override
  String get newPeriodTimeSetName => 'New period time set';

  @override
  String get emptyTimetableName => 'Empty timetable';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name periods';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Import file type does not match.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'This import file version is not supported yet.';

  @override
  String get noPeriodTimesInImportMessage =>
      'No period times found in the import file.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Please select at least one timetable.';

  @override
  String get noExportableTimetableMessage =>
      'There is no timetable available to export.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Replacing the current timetable only supports selecting one timetable.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'There is no current timetable to replace.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'This period time set is still used by $count timetable(s). Reassign them before deleting.';
  }

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayShortMonday => 'Mon';

  @override
  String get weekdayShortTuesday => 'Tue';

  @override
  String get weekdayShortWednesday => 'Wed';

  @override
  String get weekdayShortThursday => 'Thu';

  @override
  String get weekdayShortFriday => 'Fri';

  @override
  String get weekdayShortSaturday => 'Sat';

  @override
  String get weekdayShortSunday => 'Sun';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'Feb';

  @override
  String get monthMarch => 'Mar';

  @override
  String get monthApril => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'Jul';

  @override
  String get monthAugust => 'Aug';

  @override
  String get monthSeptember => 'Sep';

  @override
  String get monthOctober => 'Oct';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Dec';

  @override
  String get semesterWeeksWholeTerm => 'All semester';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Weeks $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Weeks $value';
  }

  @override
  String get generalSchedule => 'General schedule';

  @override
  String get studentTimetable => 'Student timetable';

  @override
  String get switchMode => 'Switch mode';

  @override
  String get generalScheduleComingSoon => 'General schedule coming soon';

  @override
  String get switchToStudentTimetable => 'Switch to Student timetable';

  @override
  String get mySchedule => 'My schedule';

  @override
  String get today => 'Today';
}
