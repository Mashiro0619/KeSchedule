import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sl'),
    Locale('sv'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sked'**
  String get appTitle;

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String weekLabel(int week);

  /// No description provided for @addCourse.
  ///
  /// In en, this message translates to:
  /// **'Add course'**
  String get addCourse;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @multiTimetableSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch timetables'**
  String get multiTimetableSwitch;

  /// No description provided for @currentTimetableWeeks.
  ///
  /// In en, this message translates to:
  /// **'Current timetable · {weeks} weeks'**
  String currentTimetableWeeks(int weeks);

  /// No description provided for @tapToSwitchWeeks.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch · {weeks} weeks'**
  String tapToSwitchWeeks(int weeks);

  /// No description provided for @editTimetable.
  ///
  /// In en, this message translates to:
  /// **'Edit timetable'**
  String get editTimetable;

  /// No description provided for @createTimetable.
  ///
  /// In en, this message translates to:
  /// **'New timetable'**
  String get createTimetable;

  /// No description provided for @jumpToWeek.
  ///
  /// In en, this message translates to:
  /// **'Jump to week'**
  String get jumpToWeek;

  /// No description provided for @timetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetable;

  /// No description provided for @timetableName.
  ///
  /// In en, this message translates to:
  /// **'Timetable name'**
  String get timetableName;

  /// No description provided for @totalWeeks.
  ///
  /// In en, this message translates to:
  /// **'Total weeks'**
  String get totalWeeks;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteTimetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete timetable'**
  String get deleteTimetableTitle;

  /// No description provided for @deleteTimetableMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteTimetableMessage(Object name);

  /// No description provided for @noTimetableTitle.
  ///
  /// In en, this message translates to:
  /// **'No timetable yet'**
  String get noTimetableTitle;

  /// No description provided for @noTimetableMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a timetable or import one from a JSON file.'**
  String get noTimetableMessage;

  /// No description provided for @importTimetable.
  ///
  /// In en, this message translates to:
  /// **'Import timetable'**
  String get importTimetable;

  /// No description provided for @courseName.
  ///
  /// In en, this message translates to:
  /// **'Course name'**
  String get courseName;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @dayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayOfWeek;

  /// No description provided for @semesterWeeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get semesterWeeks;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @linkedPeriods.
  ///
  /// In en, this message translates to:
  /// **'Linked periods'**
  String get linkedPeriods;

  /// No description provided for @linkedPeriodsUnmatched.
  ///
  /// In en, this message translates to:
  /// **'No periods matched for the current time. Tap to choose manually.'**
  String get linkedPeriodsUnmatched;

  /// No description provided for @periodRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Period {start}-{end}'**
  String periodRangeLabel(int start, int end);

  /// No description provided for @teacherName.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacherName;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @customFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get customFields;

  /// No description provided for @customFieldsHint.
  ///
  /// In en, this message translates to:
  /// **'One per line, format: key:value'**
  String get customFieldsHint;

  /// No description provided for @selectDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Choose day'**
  String get selectDayOfWeek;

  /// No description provided for @selectSemesterWeeks.
  ///
  /// In en, this message translates to:
  /// **'Choose weeks'**
  String get selectSemesterWeeks;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectLinkedPeriods.
  ///
  /// In en, this message translates to:
  /// **'Choose linked periods'**
  String get selectLinkedPeriods;

  /// No description provided for @addCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add course'**
  String get addCourseTitle;

  /// No description provided for @editCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit course'**
  String get editCourseTitle;

  /// No description provided for @editCourseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit course'**
  String get editCourseTooltip;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get place;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @notFilled.
  ///
  /// In en, this message translates to:
  /// **'Not filled'**
  String get notFilled;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @conflictCourses.
  ///
  /// In en, this message translates to:
  /// **'Conflicting courses'**
  String get conflictCourses;

  /// No description provided for @locationNotFilled.
  ///
  /// In en, this message translates to:
  /// **'Location not filled'**
  String get locationNotFilled;

  /// No description provided for @setAsDisplayed.
  ///
  /// In en, this message translates to:
  /// **'Set as displayed'**
  String get setAsDisplayed;

  /// No description provided for @editThisCourse.
  ///
  /// In en, this message translates to:
  /// **'Edit this course'**
  String get editThisCourse;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @noTimetableSettings.
  ///
  /// In en, this message translates to:
  /// **'No timetable is currently available for settings.'**
  String get noTimetableSettings;

  /// No description provided for @semesterStartDate.
  ///
  /// In en, this message translates to:
  /// **'Semester start date'**
  String get semesterStartDate;

  /// No description provided for @periodTimeSets.
  ///
  /// In en, this message translates to:
  /// **'Period time set'**
  String get periodTimeSets;

  /// No description provided for @noPeriodTimeAvailable.
  ///
  /// In en, this message translates to:
  /// **'No available period time set'**
  String get noPeriodTimeAvailable;

  /// No description provided for @periodTimeSetSummary.
  ///
  /// In en, this message translates to:
  /// **'{name} · {count} periods'**
  String periodTimeSetSummary(Object name, int count);

  /// No description provided for @coursePopupDismissSetting.
  ///
  /// In en, this message translates to:
  /// **'Allow outside tap to close course popup'**
  String get coursePopupDismissSetting;

  /// No description provided for @coursePopupDismissSettingHint.
  ///
  /// In en, this message translates to:
  /// **'Turning this off also disables swipe-down dismissal.'**
  String get coursePopupDismissSettingHint;

  /// No description provided for @preserveTimetableGaps.
  ///
  /// In en, this message translates to:
  /// **'Preserve timetable gaps'**
  String get preserveTimetableGaps;

  /// No description provided for @preserveTimetableGapsHint.
  ///
  /// In en, this message translates to:
  /// **'When off, lunch and break gaps are collapsed so later classes move upward.'**
  String get preserveTimetableGapsHint;

  /// No description provided for @showPastEndedCourses.
  ///
  /// In en, this message translates to:
  /// **'Show past-ended courses'**
  String get showPastEndedCourses;

  /// No description provided for @showPastEndedCoursesHint.
  ///
  /// In en, this message translates to:
  /// **'Show courses that have already finished by the real current week with a lighter gray style.'**
  String get showPastEndedCoursesHint;

  /// No description provided for @showFutureCourses.
  ///
  /// In en, this message translates to:
  /// **'Show future courses'**
  String get showFutureCourses;

  /// No description provided for @showFutureCoursesHint.
  ///
  /// In en, this message translates to:
  /// **'Show courses that are not active this week but will appear in later weeks with a gray style.'**
  String get showFutureCoursesHint;

  /// No description provided for @timetableDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'Timetable display and interaction'**
  String get timetableDisplaySettings;

  /// No description provided for @timetableDisplaySettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Popup dismissal, gaps, gray courses, and grid lines'**
  String get timetableDisplaySettingsDesc;

  /// No description provided for @showTimetableGridLines.
  ///
  /// In en, this message translates to:
  /// **'Show timetable grid lines'**
  String get showTimetableGridLines;

  /// No description provided for @showTimetableGridLinesHint.
  ///
  /// In en, this message translates to:
  /// **'Control whether horizontal and vertical grid lines are visible in the timetable.'**
  String get showTimetableGridLinesHint;

  /// No description provided for @liveCourseOutlineColor.
  ///
  /// In en, this message translates to:
  /// **'Course outline color'**
  String get liveCourseOutlineColor;

  /// No description provided for @liveCourseOutlineColorHint.
  ///
  /// In en, this message translates to:
  /// **'Choose whether outlines target the current/next course or all displayed courses on the current page.'**
  String get liveCourseOutlineColorHint;

  /// No description provided for @liveCourseOutlineSettings.
  ///
  /// In en, this message translates to:
  /// **'Course outline'**
  String get liveCourseOutlineSettings;

  /// No description provided for @liveCourseOutlineSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Configure whether the outline is enabled, what it targets, whether it follows the theme color, and the effective outline color.'**
  String get liveCourseOutlineSettingsHint;

  /// No description provided for @liveCourseOutlineEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable outline'**
  String get liveCourseOutlineEnabled;

  /// No description provided for @liveCourseOutlineFollowTheme.
  ///
  /// In en, this message translates to:
  /// **'Follow theme color'**
  String get liveCourseOutlineFollowTheme;

  /// No description provided for @liveCourseOutlineTarget.
  ///
  /// In en, this message translates to:
  /// **'Outline target'**
  String get liveCourseOutlineTarget;

  /// No description provided for @liveCourseOutlineTargetCurrentOrNext.
  ///
  /// In en, this message translates to:
  /// **'Current/next course'**
  String get liveCourseOutlineTargetCurrentOrNext;

  /// No description provided for @liveCourseOutlineTargetAllDisplayed.
  ///
  /// In en, this message translates to:
  /// **'All displayed courses'**
  String get liveCourseOutlineTargetAllDisplayed;

  /// No description provided for @liveCourseOutlineEffectiveColor.
  ///
  /// In en, this message translates to:
  /// **'Effective color'**
  String get liveCourseOutlineEffectiveColor;

  /// No description provided for @liveCourseOutlineCustomColor.
  ///
  /// In en, this message translates to:
  /// **'Custom outline color'**
  String get liveCourseOutlineCustomColor;

  /// No description provided for @liveCourseOutlineWidth.
  ///
  /// In en, this message translates to:
  /// **'Outline width'**
  String get liveCourseOutlineWidth;

  /// No description provided for @outlineWidthUnit.
  ///
  /// In en, this message translates to:
  /// **'px'**
  String get outlineWidthUnit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languagePageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the languages that is truly available in the app.'**
  String get languagePageDescription;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @githubRepositoryUrl.
  ///
  /// In en, this message translates to:
  /// **'github.com/Mashiro0619/KeSchedule'**
  String get githubRepositoryUrl;

  /// No description provided for @apiResponseTitle.
  ///
  /// In en, this message translates to:
  /// **'API response'**
  String get apiResponseTitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get themeFollowSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColor;

  /// No description provided for @themeColorModeSingle.
  ///
  /// In en, this message translates to:
  /// **'Single theme color'**
  String get themeColorModeSingle;

  /// No description provided for @themeColorModeColorful.
  ///
  /// In en, this message translates to:
  /// **'Colorful'**
  String get themeColorModeColorful;

  /// No description provided for @themeColorUiColors.
  ///
  /// In en, this message translates to:
  /// **'UI colors'**
  String get themeColorUiColors;

  /// No description provided for @themeColorCourseColors.
  ///
  /// In en, this message translates to:
  /// **'Course colors'**
  String get themeColorCourseColors;

  /// No description provided for @themeColorPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get themeColorPrimary;

  /// No description provided for @themeColorSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get themeColorSecondary;

  /// No description provided for @themeColorTertiary.
  ///
  /// In en, this message translates to:
  /// **'Tertiary'**
  String get themeColorTertiary;

  /// No description provided for @themeColorCourseText.
  ///
  /// In en, this message translates to:
  /// **'Course text'**
  String get themeColorCourseText;

  /// No description provided for @themeColorCourseTextAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeColorCourseTextAuto;

  /// No description provided for @themeColorCourseTextCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get themeColorCourseTextCustom;

  /// No description provided for @themeColorCourseColorsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Course colors will be generated after importing a timetable.'**
  String get themeColorCourseColorsEmpty;

  /// No description provided for @themeCustomColor.
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get themeCustomColor;

  /// No description provided for @themeApplyCustomColor.
  ///
  /// In en, this message translates to:
  /// **'Apply color'**
  String get themeApplyCustomColor;

  /// No description provided for @themeApplySettings.
  ///
  /// In en, this message translates to:
  /// **'Apply settings'**
  String get themeApplySettings;

  /// No description provided for @dataImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import and export data'**
  String get dataImportExport;

  /// No description provided for @dataImportExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Import full data or single timetables, or export current/all timetables.'**
  String get dataImportExportDesc;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get openSourceLicenses;

  /// No description provided for @openSourceLicensesDesc.
  ///
  /// In en, this message translates to:
  /// **'View licenses for Flutter dependencies and bundled app icon assets.'**
  String get openSourceLicensesDesc;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @checkForUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'GitHub / Official website / Google Play / Cloud drive'**
  String get checkForUpdatesDesc;

  /// No description provided for @alreadyLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Already on the latest version ({version})'**
  String alreadyLatestVersion(Object version);

  /// No description provided for @currentVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current version'**
  String get currentVersionLabel;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get newVersionAvailable;

  /// No description provided for @latestVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest version'**
  String get latestVersionLabel;

  /// No description provided for @updateContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Update details'**
  String get updateContentLabel;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get officialWebsite;

  /// No description provided for @googlePlay.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get googlePlay;

  /// No description provided for @cloudDrive.
  ///
  /// In en, this message translates to:
  /// **'Cloud drive'**
  String get cloudDrive;

  /// No description provided for @ignoreThisVersion.
  ///
  /// In en, this message translates to:
  /// **'Ignore this version'**
  String get ignoreThisVersion;

  /// No description provided for @openUpdatesFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the update link'**
  String get openUpdatesFailed;

  /// No description provided for @updateCheckFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Update check failed'**
  String get updateCheckFailedTitle;

  /// No description provided for @updateCheckFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to get valid update information from any update source. You can still use the links below to update manually.'**
  String get updateCheckFailedMessage;

  /// No description provided for @githubRepository.
  ///
  /// In en, this message translates to:
  /// **'GitHub repository'**
  String get githubRepository;

  /// No description provided for @openGithubFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the GitHub repository link'**
  String get openGithubFailed;

  /// No description provided for @selectPeriodTimeSet.
  ///
  /// In en, this message translates to:
  /// **'Choose period time set'**
  String get selectPeriodTimeSet;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newItem;

  /// No description provided for @editPeriodTimeSet.
  ///
  /// In en, this message translates to:
  /// **'Edit period time set'**
  String get editPeriodTimeSet;

  /// No description provided for @importTimetableFiles.
  ///
  /// In en, this message translates to:
  /// **'Import timetable'**
  String get importTimetableFiles;

  /// No description provided for @importTimetableFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Supports one or multiple timetable files.'**
  String get importTimetableFilesDesc;

  /// No description provided for @importTimetableText.
  ///
  /// In en, this message translates to:
  /// **'Import timetable from text'**
  String get importTimetableText;

  /// No description provided for @importTimetableTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste timetable JSON content and import it.'**
  String get importTimetableTextDesc;

  /// No description provided for @shareTimetableFiles.
  ///
  /// In en, this message translates to:
  /// **'Share timetable files'**
  String get shareTimetableFiles;

  /// No description provided for @shareTimetableFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more timetables first.'**
  String get shareTimetableFilesDesc;

  /// No description provided for @saveTimetableFiles.
  ///
  /// In en, this message translates to:
  /// **'Save timetable files'**
  String get saveTimetableFiles;

  /// No description provided for @saveTimetableFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more timetables first.'**
  String get saveTimetableFilesDesc;

  /// No description provided for @exportTimetableText.
  ///
  /// In en, this message translates to:
  /// **'Export timetable as text'**
  String get exportTimetableText;

  /// No description provided for @exportTimetableTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more timetables, then copy the JSON content.'**
  String get exportTimetableTextDesc;

  /// No description provided for @jsonContent.
  ///
  /// In en, this message translates to:
  /// **'JSON content'**
  String get jsonContent;

  /// No description provided for @pasteJsonContentHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the JSON content to import.'**
  String get pasteJsonContentHint;

  /// No description provided for @jsonContentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Paste JSON content first.'**
  String get jsonContentEmpty;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyText;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @selectTimetablesToExport.
  ///
  /// In en, this message translates to:
  /// **'Choose timetables to export'**
  String get selectTimetablesToExport;

  /// No description provided for @selectTimetablesToImport.
  ///
  /// In en, this message translates to:
  /// **'Choose timetables to import'**
  String get selectTimetablesToImport;

  /// No description provided for @timetableCourseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String timetableCourseCount(int count);

  /// No description provided for @importAction.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importAction;

  /// No description provided for @importTimetableDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import timetable'**
  String get importTimetableDialogTitle;

  /// No description provided for @chooseImportMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how to import.'**
  String get chooseImportMethod;

  /// No description provided for @importAsNewTimetable.
  ///
  /// In en, this message translates to:
  /// **'Import as new timetable'**
  String get importAsNewTimetable;

  /// No description provided for @replaceCurrentTimetable.
  ///
  /// In en, this message translates to:
  /// **'Replace current timetable'**
  String get replaceCurrentTimetable;

  /// No description provided for @importPeriodTimeSetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import period time sets'**
  String get importPeriodTimeSetDialogTitle;

  /// No description provided for @importPeriodTimeSetDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This file contains bundled period time sets. Do you want to import and associate them?'**
  String get importPeriodTimeSetDialogBody;

  /// No description provided for @importBundledPeriodTimeSets.
  ///
  /// In en, this message translates to:
  /// **'Import and associate'**
  String get importBundledPeriodTimeSets;

  /// No description provided for @discardBundledPeriodTimeSets.
  ///
  /// In en, this message translates to:
  /// **'Discard bundled sets'**
  String get discardBundledPeriodTimeSets;

  /// No description provided for @importDiscardPeriodTimeSetUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No existing period time set is available, so bundled period time sets cannot be discarded.'**
  String get importDiscardPeriodTimeSetUnavailable;

  /// No description provided for @savedToPath.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String savedToPath(Object path);

  /// No description provided for @saveCancelled.
  ///
  /// In en, this message translates to:
  /// **'Save cancelled'**
  String get saveCancelled;

  /// No description provided for @fileSaveRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'File saving restricted'**
  String get fileSaveRestrictedTitle;

  /// No description provided for @fileSaveRestrictedRetryMessage.
  ///
  /// In en, this message translates to:
  /// **'The system could not save the file. You can retry or use sharing instead.'**
  String get fileSaveRestrictedRetryMessage;

  /// No description provided for @retrySave.
  ///
  /// In en, this message translates to:
  /// **'Retry save'**
  String get retrySave;

  /// No description provided for @fileSaveRestrictedSettingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable file access in system settings, then return and try exporting again.'**
  String get fileSaveRestrictedSettingsMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @browserDownloadRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Browser download restricted'**
  String get browserDownloadRestrictedTitle;

  /// No description provided for @browserDownloadRestrictedMessage.
  ///
  /// In en, this message translates to:
  /// **'This browser does not support directly saving to a local file. Check browser download permissions or use file sharing instead.'**
  String get browserDownloadRestrictedMessage;

  /// No description provided for @switchToShare.
  ///
  /// In en, this message translates to:
  /// **'Use sharing instead'**
  String get switchToShare;

  /// No description provided for @fileSaveFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'File save failed'**
  String get fileSaveFailedTitle;

  /// No description provided for @fileSaveFailedWindowsMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to write to the current path. The target folder may be protected, the file may be in use, or the path may be unwritable.'**
  String get fileSaveFailedWindowsMessage;

  /// No description provided for @fileSaveFailedGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'The system could not save the file. You can retry, check system settings, or use file sharing instead.'**
  String get fileSaveFailedGenericMessage;

  /// No description provided for @retryLater.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get retryLater;

  /// No description provided for @exportSwitchedToShare.
  ///
  /// In en, this message translates to:
  /// **'Switched to file sharing for export'**
  String get exportSwitchedToShare;

  /// No description provided for @saveFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Save failed. Please try again later.'**
  String get saveFailedRetry;

  /// No description provided for @importFailedCheckContent.
  ///
  /// In en, this message translates to:
  /// **'Import failed. Please check the file content.'**
  String get importFailedCheckContent;

  /// No description provided for @noImportableTimetables.
  ///
  /// In en, this message translates to:
  /// **'No usable timetables were found in the imported file.'**
  String get noImportableTimetables;

  /// No description provided for @importedTimetablesCount.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} timetables'**
  String importedTimetablesCount(int count);

  /// No description provided for @periodTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Period times'**
  String get periodTimesTitle;

  /// No description provided for @importExport.
  ///
  /// In en, this message translates to:
  /// **'Import and export'**
  String get importExport;

  /// No description provided for @importPeriodTemplate.
  ///
  /// In en, this message translates to:
  /// **'Import period template'**
  String get importPeriodTemplate;

  /// No description provided for @importPeriodTemplateText.
  ///
  /// In en, this message translates to:
  /// **'Import period template from text'**
  String get importPeriodTemplateText;

  /// No description provided for @sharePeriodTemplate.
  ///
  /// In en, this message translates to:
  /// **'Share period template'**
  String get sharePeriodTemplate;

  /// No description provided for @saveTemplateToFile.
  ///
  /// In en, this message translates to:
  /// **'Save template to file'**
  String get saveTemplateToFile;

  /// No description provided for @exportPeriodTemplateText.
  ///
  /// In en, this message translates to:
  /// **'Export period template as text'**
  String get exportPeriodTemplateText;

  /// No description provided for @deletePeriodTimeSet.
  ///
  /// In en, this message translates to:
  /// **'Delete period time set'**
  String get deletePeriodTimeSet;

  /// No description provided for @periodTimeSetName.
  ///
  /// In en, this message translates to:
  /// **'Period time set name'**
  String get periodTimeSetName;

  /// No description provided for @addOnePeriod.
  ///
  /// In en, this message translates to:
  /// **'Add period'**
  String get addOnePeriod;

  /// No description provided for @periodNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Period {index}'**
  String periodNumberLabel(int index);

  /// No description provided for @deleteThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'Delete this period'**
  String get deleteThisPeriod;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration {minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @gapFromPrevious.
  ///
  /// In en, this message translates to:
  /// **'Gap from previous {minutes} min'**
  String gapFromPrevious(int minutes);

  /// No description provided for @endTimeMustBeLater.
  ///
  /// In en, this message translates to:
  /// **'End time must be later than start time'**
  String get endTimeMustBeLater;

  /// No description provided for @periodOverlapPrevious.
  ///
  /// In en, this message translates to:
  /// **'This period overlaps the previous one'**
  String get periodOverlapPrevious;

  /// No description provided for @periodTimesSaved.
  ///
  /// In en, this message translates to:
  /// **'Period times saved'**
  String get periodTimesSaved;

  /// No description provided for @deletePeriodTimeSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete period time set'**
  String get deletePeriodTimeSetTitle;

  /// No description provided for @deletePeriodTimeSetMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deletePeriodTimeSetMessage(Object name);

  /// No description provided for @currentPeriodTimeSet.
  ///
  /// In en, this message translates to:
  /// **'current period time set'**
  String get currentPeriodTimeSet;

  /// No description provided for @importedPeriodTimesCount.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} period times'**
  String importedPeriodTimesCount(int count);

  /// No description provided for @periodFilePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'File permission needed'**
  String get periodFilePermissionTitle;

  /// No description provided for @androidFilePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Android export requires file access permission. Grant permission to continue saving.'**
  String get androidFilePermissionMessage;

  /// No description provided for @reauthorize.
  ///
  /// In en, this message translates to:
  /// **'Authorize again'**
  String get reauthorize;

  /// No description provided for @permissionPermanentlyDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission permanently denied'**
  String get permissionPermanentlyDeniedTitle;

  /// No description provided for @permissionSettingsExportMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable file access in system settings, then return and try exporting again.'**
  String get permissionSettingsExportMessage;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn how the app handles local storage, school-site configuration, file import/export, webpage parsing, and external links.'**
  String get privacyPolicyEntryDesc;

  /// No description provided for @privacyPolicyAcceptedVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Accepted version: {version}'**
  String privacyPolicyAcceptedVersionLabel(Object version);

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'Sked is a local-first timetable tool. Timetables, period-time sets, and school-site configuration are stored only on your device or in your browser, and are never automatically uploaded. The app only processes data when you explicitly trigger actions such as import, webpage parsing, sharing, or opening external links. The full privacy policy is available online.'**
  String get privacyPolicyIntro;

  /// No description provided for @privacyPolicyLocalStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get privacyPolicyLocalStorageTitle;

  /// No description provided for @privacyPolicyLocalStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Timetable data and related settings are stored in a local file named Sked_data.json inside the app documents directory. Editable school-site configuration is stored separately in Sked_school_sites.json. Custom timetable parser settings, including any custom Base URL, API key, and selected model, are also stored locally in the same app data and are not protected by a system credential vault. When used in a browser, the same kinds of data are stored in browser storage. The app does not automatically upload this local data to a developer-controlled server.'**
  String get privacyPolicyLocalStorageBody;

  /// No description provided for @privacyPolicyImportExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import and export'**
  String get privacyPolicyImportExportTitle;

  /// No description provided for @privacyPolicyImportExportBody.
  ///
  /// In en, this message translates to:
  /// **'The app reads or writes timetable JSON files, school-site JSON files, and period-template files only when you explicitly choose a file or start an export action. Importing these files is a local operation unless you also choose webpage parsing. Fetching a custom model list is also an explicit network action and only contacts the custom endpoint you configured.'**
  String get privacyPolicyImportExportBody;

  /// No description provided for @privacyPolicySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get privacyPolicySharingTitle;

  /// No description provided for @privacyPolicySharingBody.
  ///
  /// In en, this message translates to:
  /// **'When you explicitly use sharing, the app passes the exported file to the system share sheet or to the target app you choose. How that file is handled afterward depends on the target app or service you selected.'**
  String get privacyPolicySharingBody;

  /// No description provided for @privacyPolicyExternalLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'External links'**
  String get privacyPolicyExternalLinksTitle;

  /// No description provided for @privacyPolicyExternalLinksBody.
  ///
  /// In en, this message translates to:
  /// **'When you open external links such as the GitHub repository, the app hands the action off to your browser or another external application. Data handling after that point is governed by the third party you open.'**
  String get privacyPolicyExternalLinksBody;

  /// No description provided for @privacyPolicyNoCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'What the app does not collect'**
  String get privacyPolicyNoCollectionTitle;

  /// No description provided for @privacyPolicyNoCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'The app does not require a Sked account and does not enable analytics, advertising identifiers, or cloud backup. It also does not provide a dedicated field for collecting school account passwords. If you sign in to a school website inside the app, that interaction happens on the school page you opened.'**
  String get privacyPolicyNoCollectionBody;

  /// No description provided for @privacyPolicyFutureFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Webpage parsing'**
  String get privacyPolicyFutureFeatureTitle;

  /// No description provided for @privacyPolicyFutureFeatureBody.
  ///
  /// In en, this message translates to:
  /// **'When you use school webpage import or paste HTML for parsing, the app first compresses the content locally, then sends the submitted page content, optional page title and URL, the current app language, and parser prompt content to the selected parsing endpoint. If you use the official parser, the request goes to the app\'s configured official backend. If you enable a custom OpenAI-compatible parser, the same content is sent directly to the third-party endpoint you configured, and fetching the model list also requests that same endpoint. A custom endpoint may forward the request to other AI services according to that provider\'s own design. The deployed official backend currently limits each submitted payload to 300KB, uses its configured timeout, and allows at most 5 parsing requests per IP per day.'**
  String get privacyPolicyFutureFeatureBody;

  /// No description provided for @privacyPolicyUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Policy updates'**
  String get privacyPolicyUpdatesTitle;

  /// No description provided for @privacyPolicyUpdatesBody.
  ///
  /// In en, this message translates to:
  /// **'The current privacy policy version is {version}. If a later version changes how data is handled, the app may ask you to read and agree to the updated policy again.'**
  String privacyPolicyUpdatesBody(Object version);

  /// No description provided for @privacyGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the privacy policy before using the app'**
  String get privacyGateTitle;

  /// No description provided for @privacyGateSummaryStorage.
  ///
  /// In en, this message translates to:
  /// **'Timetables, period-time sets, and school-site configuration are only stored locally and are not automatically uploaded to a developer server.'**
  String get privacyGateSummaryStorage;

  /// No description provided for @privacyGateSummaryImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import, export, and sharing only happen when you explicitly start them; webpage parsing sends only the compressed content you submit to your configured parsing endpoint, and you can review the parsed timetable before saving.'**
  String get privacyGateSummaryImportExport;

  /// No description provided for @privacyGateSummaryUpdates.
  ///
  /// In en, this message translates to:
  /// **'If a later version changes how data is handled, the app may ask you to review the updated privacy policy again.'**
  String get privacyGateSummaryUpdates;

  /// No description provided for @schoolWebImportEntry.
  ///
  /// In en, this message translates to:
  /// **'Import from school webpage'**
  String get schoolWebImportEntry;

  /// No description provided for @schoolWebImportEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Import the current timetable page from the school site.'**
  String get schoolWebImportEntryDesc;

  /// No description provided for @schoolSitesManageEntry.
  ///
  /// In en, this message translates to:
  /// **'Manage school sites'**
  String get schoolSitesManageEntry;

  /// No description provided for @schoolSitesManageEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, and delete school login URLs, with JSON import and export.'**
  String get schoolSitesManageEntryDesc;

  /// No description provided for @schoolSitesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'School site management'**
  String get schoolSitesPageTitle;

  /// No description provided for @schoolSitesImportJson.
  ///
  /// In en, this message translates to:
  /// **'Import school JSON'**
  String get schoolSitesImportJson;

  /// No description provided for @schoolSitesShareJson.
  ///
  /// In en, this message translates to:
  /// **'Share school JSON'**
  String get schoolSitesShareJson;

  /// No description provided for @schoolSitesSaveJson.
  ///
  /// In en, this message translates to:
  /// **'Save school JSON'**
  String get schoolSitesSaveJson;

  /// No description provided for @schoolSitesSaved.
  ///
  /// In en, this message translates to:
  /// **'School sites saved'**
  String get schoolSitesSaved;

  /// No description provided for @schoolSitesImported.
  ///
  /// In en, this message translates to:
  /// **'School sites imported'**
  String get schoolSitesImported;

  /// No description provided for @schoolSitesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No school site configuration yet.'**
  String get schoolSitesEmpty;

  /// No description provided for @schoolSitesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'School name'**
  String get schoolSitesNameLabel;

  /// No description provided for @schoolSitesLoginUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Login URL'**
  String get schoolSitesLoginUrlLabel;

  /// No description provided for @schoolSitesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add school'**
  String get schoolSitesAdd;

  /// No description provided for @schoolSitesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit school'**
  String get schoolSitesEdit;

  /// No description provided for @schoolSitesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete school'**
  String get schoolSitesDeleteTitle;

  /// No description provided for @schoolSitesDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String schoolSitesDeleteMessage(Object name);

  /// No description provided for @schoolSitesFormInvalid.
  ///
  /// In en, this message translates to:
  /// **'Fill in the school name and login URL first.'**
  String get schoolSitesFormInvalid;

  /// No description provided for @schoolSitesJsonFileName.
  ///
  /// In en, this message translates to:
  /// **'Sked_school_sites.json'**
  String get schoolSitesJsonFileName;

  /// No description provided for @schoolHtmlImportEntry.
  ///
  /// In en, this message translates to:
  /// **'Import by pasting timetable page content'**
  String get schoolHtmlImportEntry;

  /// No description provided for @schoolHtmlImportEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste source code or raw page content containing timetable information manually.'**
  String get schoolHtmlImportEntryDesc;

  /// No description provided for @schoolHtmlImportPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Parse timetable from page content'**
  String get schoolHtmlImportPageTitle;

  /// No description provided for @schoolHtmlImportUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Source URL (optional)'**
  String get schoolHtmlImportUrlLabel;

  /// No description provided for @schoolHtmlImportTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Page title (optional)'**
  String get schoolHtmlImportTitleLabel;

  /// No description provided for @schoolHtmlImportHtmlLabel.
  ///
  /// In en, this message translates to:
  /// **'Page content'**
  String get schoolHtmlImportHtmlLabel;

  /// No description provided for @schoolHtmlImportHtmlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste source code or raw page content containing timetable information here.'**
  String get schoolHtmlImportHtmlHint;

  /// No description provided for @schoolHtmlImportNonHtmlHint.
  ///
  /// In en, this message translates to:
  /// **'Any content containing timetable information can be parsed and imported, not just HTML.'**
  String get schoolHtmlImportNonHtmlHint;

  /// No description provided for @schoolHtmlImportCompress.
  ///
  /// In en, this message translates to:
  /// **'Compress content'**
  String get schoolHtmlImportCompress;

  /// No description provided for @schoolHtmlImportCompressed.
  ///
  /// In en, this message translates to:
  /// **'Content compressed'**
  String get schoolHtmlImportCompressed;

  /// No description provided for @schoolHtmlImportCompressFirst.
  ///
  /// In en, this message translates to:
  /// **'Compress the content first.'**
  String get schoolHtmlImportCompressFirst;

  /// No description provided for @schoolHtmlImportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Parse and import'**
  String get schoolHtmlImportSubmit;

  /// No description provided for @schoolHtmlImportParsingMayTakeLong.
  ///
  /// In en, this message translates to:
  /// **'Parsing may take a while. Please wait.'**
  String get schoolHtmlImportParsingMayTakeLong;

  /// No description provided for @schoolHtmlImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Paste the page HTML first.'**
  String get schoolHtmlImportEmpty;

  /// No description provided for @schoolHtmlImportReturnToWebPage.
  ///
  /// In en, this message translates to:
  /// **'Back to webpage'**
  String get schoolHtmlImportReturnToWebPage;

  /// No description provided for @schoolWebImportPageTitle.
  ///
  /// In en, this message translates to:
  /// **'School webpage import'**
  String get schoolWebImportPageTitle;

  /// No description provided for @schoolWebImportPreview.
  ///
  /// In en, this message translates to:
  /// **'Import preview'**
  String get schoolWebImportPreview;

  /// No description provided for @schoolWebImportCourseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String schoolWebImportCourseCount(int count);

  /// No description provided for @schoolWebImportPeriodCount.
  ///
  /// In en, this message translates to:
  /// **'{count} periods'**
  String schoolWebImportPeriodCount(int count);

  /// No description provided for @schoolWebImportPageTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Page title'**
  String get schoolWebImportPageTitleLabel;

  /// No description provided for @schoolWebImportParserUsed.
  ///
  /// In en, this message translates to:
  /// **'Parser'**
  String get schoolWebImportParserUsed;

  /// No description provided for @schoolWebImportWarnings.
  ///
  /// In en, this message translates to:
  /// **'Import notes'**
  String get schoolWebImportWarnings;

  /// No description provided for @schoolWebImportOpenPageHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the school site in-app, then navigate to the timetable page manually.'**
  String get schoolWebImportOpenPageHint;

  /// No description provided for @schoolWebImportConfigMissing.
  ///
  /// In en, this message translates to:
  /// **'Web import backend API is not configured yet.'**
  String get schoolWebImportConfigMissing;

  /// No description provided for @schoolWebImportUnsupportedPlatform.
  ///
  /// In en, this message translates to:
  /// **'This platform does not support embedded web login yet. Please use a platform with WebView support.'**
  String get schoolWebImportUnsupportedPlatform;

  /// No description provided for @schoolWebImportSelectSchool.
  ///
  /// In en, this message translates to:
  /// **'Choose school'**
  String get schoolWebImportSelectSchool;

  /// No description provided for @schoolWebImportNoSchools.
  ///
  /// In en, this message translates to:
  /// **'No school configuration is available. Check school_sites.json first.'**
  String get schoolWebImportNoSchools;

  /// No description provided for @schoolWebImportSchoolLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load school configuration. Check the JSON file format.'**
  String get schoolWebImportSchoolLoadFailed;

  /// No description provided for @schoolWebImportImportCurrentPage.
  ///
  /// In en, this message translates to:
  /// **'Import current page'**
  String get schoolWebImportImportCurrentPage;

  /// No description provided for @schoolWebImportGoBack.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get schoolWebImportGoBack;

  /// No description provided for @schoolWebImportLoadingPage.
  ///
  /// In en, this message translates to:
  /// **'Loading page…'**
  String get schoolWebImportLoadingPage;

  /// No description provided for @schoolWebImportParsing.
  ///
  /// In en, this message translates to:
  /// **'Parsing current page…'**
  String get schoolWebImportParsing;

  /// No description provided for @schoolWebImportLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Page load failed. Please refresh or try again later.'**
  String get schoolWebImportLoadFailed;

  /// No description provided for @schoolWebImportLoadTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Page loading timed out. Please refresh and try again.'**
  String get schoolWebImportLoadTimedOut;

  /// No description provided for @schoolWebImportEmptyPage.
  ///
  /// In en, this message translates to:
  /// **'The current page content is empty and cannot be imported yet.'**
  String get schoolWebImportEmptyPage;

  /// No description provided for @schoolWebImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Web timetable imported'**
  String get schoolWebImportSuccess;

  /// No description provided for @schoolImportParserSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetable parser settings'**
  String get schoolImportParserSettingsTitle;

  /// No description provided for @schoolImportParserSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the official parser or a custom OpenAI-compatible endpoint.'**
  String get schoolImportParserSettingsDesc;

  /// No description provided for @schoolImportParserSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Parser source'**
  String get schoolImportParserSourceTitle;

  /// No description provided for @schoolImportParserSourceOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official parser'**
  String get schoolImportParserSourceOfficial;

  /// No description provided for @schoolImportParserSourceOfficialDesc.
  ///
  /// In en, this message translates to:
  /// **'Use the built-in official parsing service configured by the app.'**
  String get schoolImportParserSourceOfficialDesc;

  /// No description provided for @schoolImportParserSourceOfficialInfo.
  ///
  /// In en, this message translates to:
  /// **'The official parser uses the app\'s configured parsing backend and keeps the current import flow unchanged.'**
  String get schoolImportParserSourceOfficialInfo;

  /// No description provided for @schoolImportParserSourceCustomOpenAi.
  ///
  /// In en, this message translates to:
  /// **'Custom OpenAI-compatible'**
  String get schoolImportParserSourceCustomOpenAi;

  /// No description provided for @schoolImportParserSourceCustomOpenAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Send the page content directly to your own OpenAI-compatible endpoint.'**
  String get schoolImportParserSourceCustomOpenAiDesc;

  /// No description provided for @schoolImportParserCustomOpenAi.
  ///
  /// In en, this message translates to:
  /// **'Custom OpenAI-compatible parser'**
  String get schoolImportParserCustomOpenAi;

  /// No description provided for @schoolImportParserCustomPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom prompt'**
  String get schoolImportParserCustomPromptTitle;

  /// No description provided for @schoolImportParserCustomPromptDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit the built-in parser prompt here. Changes only affect the custom OpenAI-compatible parser.'**
  String get schoolImportParserCustomPromptDescription;

  /// No description provided for @schoolImportParserCustomPromptHint.
  ///
  /// In en, this message translates to:
  /// **'The built-in prompt is loaded here by default. Clear it to fall back to the built-in version.'**
  String get schoolImportParserCustomPromptHint;

  /// No description provided for @schoolImportParserResetDefaultPrompt.
  ///
  /// In en, this message translates to:
  /// **'Reset default prompt'**
  String get schoolImportParserResetDefaultPrompt;

  /// No description provided for @schoolImportParserBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get schoolImportParserBaseUrl;

  /// No description provided for @schoolImportParserApiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get schoolImportParserApiKey;

  /// No description provided for @schoolImportParserModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get schoolImportParserModel;

  /// No description provided for @schoolImportParserFetchModels.
  ///
  /// In en, this message translates to:
  /// **'Fetch model list'**
  String get schoolImportParserFetchModels;

  /// No description provided for @schoolImportParserFetchingModels.
  ///
  /// In en, this message translates to:
  /// **'Fetching models...'**
  String get schoolImportParserFetchingModels;

  /// No description provided for @schoolImportParserNoModelsFound.
  ///
  /// In en, this message translates to:
  /// **'No models were returned by the endpoint.'**
  String get schoolImportParserNoModelsFound;

  /// No description provided for @schoolImportParserModelsFetched.
  ///
  /// In en, this message translates to:
  /// **'Fetched {count} models'**
  String schoolImportParserModelsFetched(int count);

  /// No description provided for @schoolImportParserPlaintextWarning.
  ///
  /// In en, this message translates to:
  /// **'The custom API key is stored in the app\'s local settings in plaintext under the current implementation. Only use it on a device or browser environment you trust.'**
  String get schoolImportParserPlaintextWarning;

  /// No description provided for @schoolImportParserCustomConfigIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Custom parser configuration is incomplete. Fill in the base URL, API key, and model first.'**
  String get schoolImportParserCustomConfigIncomplete;

  /// No description provided for @schoolImportParserCurrentSourceOfficial.
  ///
  /// In en, this message translates to:
  /// **'Parser: Official'**
  String get schoolImportParserCurrentSourceOfficial;

  /// No description provided for @schoolImportParserCurrentSourceCustom.
  ///
  /// In en, this message translates to:
  /// **'Parser: Custom ({model})'**
  String schoolImportParserCurrentSourceCustom(Object model);

  /// No description provided for @privacyViewFullPolicy.
  ///
  /// In en, this message translates to:
  /// **'View full privacy policy'**
  String get privacyViewFullPolicy;

  /// No description provided for @privacyAgreeAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Agree and continue'**
  String get privacyAgreeAndContinue;

  /// No description provided for @privacyDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get privacyDecline;

  /// No description provided for @privacyDeclineWebHint.
  ///
  /// In en, this message translates to:
  /// **'This browser environment does not allow the app to close the page for you. If you do not agree, please close this tab or window yourself.'**
  String get privacyDeclineWebHint;

  /// No description provided for @defaultPeriodTimeSetName.
  ///
  /// In en, this message translates to:
  /// **'Default periods'**
  String get defaultPeriodTimeSetName;

  /// No description provided for @periodTimeSetFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Period times'**
  String get periodTimeSetFallbackName;

  /// No description provided for @untitledTimetableName.
  ///
  /// In en, this message translates to:
  /// **'Untitled timetable'**
  String get untitledTimetableName;

  /// No description provided for @newTimetableName.
  ///
  /// In en, this message translates to:
  /// **'New timetable'**
  String get newTimetableName;

  /// No description provided for @newPeriodTimeSetName.
  ///
  /// In en, this message translates to:
  /// **'New period time set'**
  String get newPeriodTimeSetName;

  /// No description provided for @emptyTimetableName.
  ///
  /// In en, this message translates to:
  /// **'Empty timetable'**
  String get emptyTimetableName;

  /// Fallback period time set name generated from an imported timetable name.
  ///
  /// In en, this message translates to:
  /// **'{name} periods'**
  String importedPeriodTimeSetName(Object name);

  /// No description provided for @importFileTypeMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Import file type does not match.'**
  String get importFileTypeMismatchMessage;

  /// No description provided for @importFileVersionUnsupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'This import file version is not supported yet.'**
  String get importFileVersionUnsupportedMessage;

  /// No description provided for @noPeriodTimesInImportMessage.
  ///
  /// In en, this message translates to:
  /// **'No period times found in the import file.'**
  String get noPeriodTimesInImportMessage;

  /// No description provided for @selectAtLeastOneTimetableMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one timetable.'**
  String get selectAtLeastOneTimetableMessage;

  /// No description provided for @noExportableTimetableMessage.
  ///
  /// In en, this message translates to:
  /// **'There is no timetable available to export.'**
  String get noExportableTimetableMessage;

  /// No description provided for @replaceActiveRequiresSingleTimetableMessage.
  ///
  /// In en, this message translates to:
  /// **'Replacing the current timetable only supports selecting one timetable.'**
  String get replaceActiveRequiresSingleTimetableMessage;

  /// No description provided for @noActiveTimetableToReplaceMessage.
  ///
  /// In en, this message translates to:
  /// **'There is no current timetable to replace.'**
  String get noActiveTimetableToReplaceMessage;

  /// No description provided for @periodTimeSetInUseMessage.
  ///
  /// In en, this message translates to:
  /// **'This period time set is still used by {count} timetable(s). Reassign them before deleting.'**
  String periodTimeSetInUseMessage(int count);

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @weekdayShortMonday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayShortMonday;

  /// No description provided for @weekdayShortTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayShortTuesday;

  /// No description provided for @weekdayShortWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayShortWednesday;

  /// No description provided for @weekdayShortThursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayShortThursday;

  /// No description provided for @weekdayShortFriday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayShortFriday;

  /// No description provided for @weekdayShortSaturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdayShortSaturday;

  /// No description provided for @weekdayShortSunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdayShortSunday;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDecember;

  /// No description provided for @semesterWeeksWholeTerm.
  ///
  /// In en, this message translates to:
  /// **'All semester'**
  String get semesterWeeksWholeTerm;

  /// No description provided for @semesterWeeksRange.
  ///
  /// In en, this message translates to:
  /// **'Weeks {start}-{end}'**
  String semesterWeeksRange(Object start, Object end);

  /// No description provided for @semesterWeeksList.
  ///
  /// In en, this message translates to:
  /// **'Weeks {value}'**
  String semesterWeeksList(Object value);

  /// No description provided for @generalSchedule.
  ///
  /// In en, this message translates to:
  /// **'General schedule'**
  String get generalSchedule;

  /// No description provided for @studentTimetable.
  ///
  /// In en, this message translates to:
  /// **'Student timetable'**
  String get studentTimetable;

  /// No description provided for @switchMode.
  ///
  /// In en, this message translates to:
  /// **'Switch mode'**
  String get switchMode;

  /// No description provided for @generalScheduleComingSoon.
  ///
  /// In en, this message translates to:
  /// **'General schedule coming soon'**
  String get generalScheduleComingSoon;

  /// No description provided for @switchToStudentTimetable.
  ///
  /// In en, this message translates to:
  /// **'Switch to Student timetable'**
  String get switchToStudentTimetable;

  /// No description provided for @mySchedule.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get mySchedule;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get addEvent;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get editEvent;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitle;

  /// No description provided for @eventTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get eventTitleRequired;

  /// No description provided for @eventStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get eventStartTime;

  /// No description provided for @eventEndTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get eventEndTime;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDate;

  /// No description provided for @eventTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get eventTime;

  /// No description provided for @eventNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get eventNotes;

  /// No description provided for @eventColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get eventColor;

  /// No description provided for @eventRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get eventRecurrence;

  /// No description provided for @recurrenceNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get recurrenceNone;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get recurrenceEndDate;

  /// No description provided for @recurrenceNoEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get recurrenceNoEndDate;

  /// No description provided for @recurrenceSetEndDate.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get recurrenceSetEndDate;

  /// No description provided for @recurrenceChangeEndDate.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get recurrenceChangeEndDate;

  /// No description provided for @repeatsWeekly.
  ///
  /// In en, this message translates to:
  /// **'Repeats weekly'**
  String get repeatsWeekly;

  /// No description provided for @recurrenceUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String recurrenceUntil(Object date);

  /// No description provided for @switchToGeneralSchedule.
  ///
  /// In en, this message translates to:
  /// **'Switch to General schedule'**
  String get switchToGeneralSchedule;

  /// No description provided for @generalDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'General display settings'**
  String get generalDisplaySettings;

  /// No description provided for @generalDisplaySettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggles for the general schedule view'**
  String get generalDisplaySettingsDesc;

  /// No description provided for @closePopupOnOutsideTap.
  ///
  /// In en, this message translates to:
  /// **'Close popup on tap outside'**
  String get closePopupOnOutsideTap;

  /// No description provided for @showGridLines.
  ///
  /// In en, this message translates to:
  /// **'Show grid lines'**
  String get showGridLines;

  /// No description provided for @generalScheduleImportExport.
  ///
  /// In en, this message translates to:
  /// **'Schedule import & export'**
  String get generalScheduleImportExport;

  /// No description provided for @generalScheduleImportExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Import or share general schedules'**
  String get generalScheduleImportExportDesc;

  /// No description provided for @importGeneralSchedules.
  ///
  /// In en, this message translates to:
  /// **'Import schedules'**
  String get importGeneralSchedules;

  /// No description provided for @importGeneralSchedulesDesc.
  ///
  /// In en, this message translates to:
  /// **'Read schedules from a JSON file'**
  String get importGeneralSchedulesDesc;

  /// No description provided for @shareGeneralSchedules.
  ///
  /// In en, this message translates to:
  /// **'Share schedules'**
  String get shareGeneralSchedules;

  /// No description provided for @shareGeneralSchedulesDesc.
  ///
  /// In en, this message translates to:
  /// **'Share schedules as a JSON file'**
  String get shareGeneralSchedulesDesc;

  /// No description provided for @saveGeneralSchedules.
  ///
  /// In en, this message translates to:
  /// **'Save schedules'**
  String get saveGeneralSchedules;

  /// No description provided for @saveGeneralSchedulesDesc.
  ///
  /// In en, this message translates to:
  /// **'Save schedules as a JSON file'**
  String get saveGeneralSchedulesDesc;

  /// No description provided for @selectSchedulesToExport.
  ///
  /// In en, this message translates to:
  /// **'Select schedules to export'**
  String get selectSchedulesToExport;

  /// No description provided for @selectSchedulesToImport.
  ///
  /// In en, this message translates to:
  /// **'Select schedules to import'**
  String get selectSchedulesToImport;

  /// No description provided for @generalScheduleEventCount.
  ///
  /// In en, this message translates to:
  /// **'Events: {count}'**
  String generalScheduleEventCount(int count);

  /// No description provided for @importedSchedulesCount.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} schedules'**
  String importedSchedulesCount(int count);

  /// No description provided for @replaceActiveSchedulePrompt.
  ///
  /// In en, this message translates to:
  /// **'Replace current schedule with the imported one?'**
  String get replaceActiveSchedulePrompt;

  /// No description provided for @addAsNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add as new'**
  String get addAsNewSchedule;

  /// No description provided for @selectAtLeastOneScheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one schedule.'**
  String get selectAtLeastOneScheduleMessage;

  /// No description provided for @noExportableScheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'No schedule available to export.'**
  String get noExportableScheduleMessage;

  /// No description provided for @noSchedulesInImportMessage.
  ///
  /// In en, this message translates to:
  /// **'Import file contains no schedules.'**
  String get noSchedulesInImportMessage;

  /// No description provided for @replaceActiveRequiresSingleScheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose exactly one schedule to replace the current one.'**
  String get replaceActiveRequiresSingleScheduleMessage;

  /// No description provided for @noActiveScheduleToReplaceMessage.
  ///
  /// In en, this message translates to:
  /// **'No current schedule to replace.'**
  String get noActiveScheduleToReplaceMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bg',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'hi',
    'hu',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sl',
    'sv',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
