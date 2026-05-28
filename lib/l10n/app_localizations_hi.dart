// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'क्लासमेट';

  @override
  String weekLabel(int week) {
    return 'सप्ताह $week';
  }

  @override
  String get addCourse => 'कोर्स जोड़ें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get multiTimetableSwitch => 'टाइमटेबल बदलें';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'वर्तमान टाइमटेबल · $weeks सप्ताह';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'बदलने के लिए टैप करें · $weeks सप्ताह';
  }

  @override
  String get editTimetable => 'टाइमटेबल संपादित करें';

  @override
  String get createTimetable => 'नया टाइमटेबल';

  @override
  String get jumpToWeek => 'सप्ताह पर जाएँ';

  @override
  String get timetable => 'टाइमटेबल';

  @override
  String get timetableName => 'टाइमटेबल का नाम';

  @override
  String get totalWeeks => 'कुल सप्ताह';

  @override
  String get delete => 'हटाएँ';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get deleteTimetableTitle => 'टाइमटेबल हटाएँ';

  @override
  String deleteTimetableMessage(Object name) {
    return '\"$name\" हटाएँ?';
  }

  @override
  String get noTimetableTitle => 'अभी तक कोई टाइमटेबल नहीं';

  @override
  String get noTimetableMessage =>
      'एक टाइमटेबल बनाएँ या JSON फ़ाइल से आयात करें।';

  @override
  String get importTimetable => 'टाइमटेबल आयात करें';

  @override
  String get courseName => 'कोर्स का नाम';

  @override
  String get location => 'स्थान';

  @override
  String get dayOfWeek => 'दिन';

  @override
  String get semesterWeeks => 'सप्ताह';

  @override
  String get startTime => 'प्रारंभ समय';

  @override
  String get endTime => 'समाप्ति समय';

  @override
  String get linkedPeriods => 'जुड़ी हुई अवधि';

  @override
  String get linkedPeriodsUnmatched =>
      'वर्तमान समय के लिए कोई अवधि मेल नहीं खाई। मैन्युअल रूप से चुनने के लिए टैप करें।';

  @override
  String periodRangeLabel(int start, int end) {
    return 'अवधि $start-$end';
  }

  @override
  String get teacherName => 'शिक्षक';

  @override
  String get credits => 'क्रेडिट';

  @override
  String get remarks => 'टिप्पणियाँ';

  @override
  String get customFields => 'कस्टम फ़ील्ड';

  @override
  String get customFieldsHint => 'प्रति पंक्ति एक, फ़ॉर्मेट: key:value';

  @override
  String get selectDayOfWeek => 'दिन चुनें';

  @override
  String get selectSemesterWeeks => 'सप्ताह चुनें';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get selectLinkedPeriods => 'जुड़ी हुई अवधि चुनें';

  @override
  String get addCourseTitle => 'कोर्स जोड़ें';

  @override
  String get editCourseTitle => 'कोर्स संपादित करें';

  @override
  String get editCourseTooltip => 'कोर्स संपादित करें';

  @override
  String get place => 'स्थान';

  @override
  String get time => 'समय';

  @override
  String get notFilled => 'भरा नहीं गया';

  @override
  String get none => 'कोई नहीं';

  @override
  String get conflictCourses => 'टकराने वाले कोर्स';

  @override
  String get locationNotFilled => 'स्थान भरा नहीं गया';

  @override
  String get setAsDisplayed => 'प्रदर्शित के रूप में सेट करें';

  @override
  String get editThisCourse => 'इस कोर्स को संपादित करें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get noTimetableSettings =>
      'सेटिंग्स के लिए अभी कोई टाइमटेबल उपलब्ध नहीं है।';

  @override
  String get semesterStartDate => 'सेमेस्टर प्रारंभ तिथि';

  @override
  String get periodTimeSets => 'अवधि समय सेट';

  @override
  String get noPeriodTimeAvailable => 'कोई उपलब्ध अवधि समय सेट नहीं';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count अवधि';
  }

  @override
  String get coursePopupDismissSetting =>
      'बाहर टैप करके कोर्स पॉपअप बंद करने दें';

  @override
  String get coursePopupDismissSettingHint =>
      'इसे बंद करने पर स्वाइप-डाउन से बंद करना भी अक्षम हो जाएगा।';

  @override
  String get preserveTimetableGaps => 'टाइमटेबल के अंतराल बनाए रखें';

  @override
  String get preserveTimetableGapsHint =>
      'बंद होने पर लंच और ब्रेक के अंतराल समेट दिए जाएँगे ताकि बाद की कक्षाएँ ऊपर खिसक जाएँ।';

  @override
  String get showPastEndedCourses => 'समाप्त हो चुके कोर्स दिखाएँ';

  @override
  String get showPastEndedCoursesHint =>
      'जो कोर्स वास्तविक वर्तमान सप्ताह तक समाप्त हो चुके हैं, उन्हें हल्के ग्रे रंग में दिखाएँ।';

  @override
  String get showFutureCourses => 'भविष्य के कोर्स दिखाएँ';

  @override
  String get showFutureCoursesHint =>
      'जो कोर्स इस सप्ताह सक्रिय नहीं हैं लेकिन आने वाले सप्ताहों में दिखाई देंगे, उन्हें ग्रे शैली में दिखाएँ।';

  @override
  String get timetableDisplaySettings => 'टाइमटेबल प्रदर्शन और इंटरैक्शन';

  @override
  String get timetableDisplaySettingsDesc =>
      'पॉपअप बंद करना, अंतराल, ग्रे कोर्स और ग्रिड लाइनें';

  @override
  String get showTimetableGridLines => 'टाइमटेबल ग्रिड लाइनें दिखाएँ';

  @override
  String get showTimetableGridLinesHint =>
      'नियंत्रित करें कि टाइमटेबल में क्षैतिज और ऊर्ध्वाधर ग्रिड लाइनें दिखें या नहीं।';

  @override
  String get liveCourseOutlineColor => 'कोर्स आउटलाइन रंग';

  @override
  String get liveCourseOutlineColorHint =>
      'चुनें कि आउटलाइन वर्तमान/अगले कोर्स पर लागू हो या वर्तमान पेज पर दिख रहे सभी कोर्स पर।';

  @override
  String get liveCourseOutlineSettings => 'कोर्स आउटलाइन';

  @override
  String get liveCourseOutlineSettingsHint =>
      'आउटलाइन सक्षम है या नहीं, उसका लक्ष्य क्या है, क्या वह थीम रंग का अनुसरण करती है, और प्रभावी आउटलाइन रंग क्या है, यह कॉन्फ़िगर करें।';

  @override
  String get liveCourseOutlineEnabled => 'आउटलाइन सक्षम करें';

  @override
  String get liveCourseOutlineFollowTheme => 'थीम रंग का अनुसरण करें';

  @override
  String get liveCourseOutlineTarget => 'आउटलाइन लक्ष्य';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'वर्तमान/अगला कोर्स';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'दिख रहे सभी कोर्स';

  @override
  String get liveCourseOutlineEffectiveColor => 'प्रभावी रंग';

  @override
  String get liveCourseOutlineCustomColor => 'कस्टम आउटलाइन रंग';

  @override
  String get liveCourseOutlineWidth => 'आउटलाइन चौड़ाई';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'भाषा';

  @override
  String get languagePageDescription =>
      'ऐप में वास्तव में उपलब्ध भाषाओं में से एक चुनें।';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API प्रतिक्रिया';

  @override
  String get theme => 'थीम';

  @override
  String get themeFollowSystem => 'सिस्टम के अनुसार';

  @override
  String get themeLight => 'हल्की';

  @override
  String get themeDark => 'गहरी';

  @override
  String get themeColor => 'थीम रंग';

  @override
  String get themeColorModeSingle => 'एकल थीम रंग';

  @override
  String get themeColorModeColorful => 'रंगीन';

  @override
  String get themeColorUiColors => 'UI रंग';

  @override
  String get themeColorCourseColors => 'कोर्स रंग';

  @override
  String get themeColorPrimary => 'प्राथमिक';

  @override
  String get themeColorSecondary => 'द्वितीयक';

  @override
  String get themeColorTertiary => 'तृतीयक';

  @override
  String get themeColorCourseText => 'कोर्स पाठ';

  @override
  String get themeColorCourseTextAuto => 'स्वचालित';

  @override
  String get themeColorCourseTextCustom => 'कस्टम रंग';

  @override
  String get themeColorCourseColorsEmpty =>
      'टाइमटेबल आयात करने के बाद कोर्स रंग बनाए जाएँगे।';

  @override
  String get themeCustomColor => 'कस्टम रंग';

  @override
  String get themeApplyCustomColor => 'रंग लागू करें';

  @override
  String get themeApplySettings => 'सेटिंग्स लागू करें';

  @override
  String get dataImportExport => 'डेटा आयात और निर्यात';

  @override
  String get dataImportExportDesc =>
      'पूरा डेटा या अलग-अलग टाइमटेबल आयात करें, या वर्तमान/सभी टाइमटेबल निर्यात करें।';

  @override
  String get openSourceLicenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get openSourceLicensesDesc =>
      'Flutter डिपेंडेंसी और शामिल ऐप आइकन एसेट्स के लाइसेंस देखें।';

  @override
  String get checkForUpdates => 'अपडेट जाँचें';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'आप पहले से नवीनतम संस्करण ($version) पर हैं';
  }

  @override
  String get currentVersionLabel => 'वर्तमान संस्करण';

  @override
  String get newVersionAvailable => 'अपडेट उपलब्ध है';

  @override
  String get latestVersionLabel => 'नवीनतम संस्करण';

  @override
  String get updateContentLabel => 'अपडेट विवरण';

  @override
  String get officialWebsite => 'आधिकारिक वेबसाइट';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'क्लाउड ड्राइव';

  @override
  String get ignoreThisVersion => 'इस संस्करण को अनदेखा करें';

  @override
  String get openUpdatesFailed => 'अपडेट लिंक खोलने में असमर्थ';

  @override
  String get updateCheckFailedTitle => 'अपडेट जाँच विफल';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'GitHub रिपॉज़िटरी';

  @override
  String get openGithubFailed => 'GitHub रिपॉज़िटरी लिंक खोलने में असमर्थ';

  @override
  String get selectPeriodTimeSet => 'अवधि समय सेट चुनें';

  @override
  String get newItem => 'नया';

  @override
  String get editPeriodTimeSet => 'अवधि समय सेट संपादित करें';

  @override
  String get importTimetableFiles => 'टाइमटेबल आयात करें';

  @override
  String get importTimetableFilesDesc =>
      'एक या कई टाइमटेबल फ़ाइलों का समर्थन करता है।';

  @override
  String get importTimetableText => 'पाठ से टाइमटेबल आयात करें';

  @override
  String get importTimetableTextDesc =>
      'टाइमटेबल JSON सामग्री पेस्ट करें और आयात करें।';

  @override
  String get shareTimetableFiles => 'टाइमटेबल फ़ाइलें साझा करें';

  @override
  String get shareTimetableFilesDesc => 'पहले एक या अधिक टाइमटेबल चुनें।';

  @override
  String get saveTimetableFiles => 'टाइमटेबल फ़ाइलें सहेजें';

  @override
  String get saveTimetableFilesDesc => 'पहले एक या अधिक टाइमटेबल चुनें।';

  @override
  String get exportTimetableText => 'टाइमटेबल को पाठ के रूप में निर्यात करें';

  @override
  String get exportTimetableTextDesc =>
      'एक या अधिक टाइमटेबल चुनें, फिर JSON सामग्री कॉपी करें।';

  @override
  String get jsonContent => 'JSON सामग्री';

  @override
  String get pasteJsonContentHint =>
      'आयात करने के लिए JSON सामग्री पेस्ट करें।';

  @override
  String get jsonContentEmpty => 'पहले JSON सामग्री पेस्ट करें।';

  @override
  String get copyText => 'कॉपी करें';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड में कॉपी किया गया';

  @override
  String get share => 'साझा करें';

  @override
  String get selectTimetablesToExport => 'निर्यात करने के लिए टाइमटेबल चुनें';

  @override
  String get selectTimetablesToImport => 'आयात करने के लिए टाइमटेबल चुनें';

  @override
  String timetableCourseCount(int count) {
    return '$count कोर्स';
  }

  @override
  String get importAction => 'आयात करें';

  @override
  String get importTimetableDialogTitle => 'टाइमटेबल आयात करें';

  @override
  String get chooseImportMethod => 'आयात का तरीका चुनें।';

  @override
  String get importAsNewTimetable => 'नए टाइमटेबल के रूप में आयात करें';

  @override
  String get replaceCurrentTimetable => 'वर्तमान टाइमटेबल बदलें';

  @override
  String get importPeriodTimeSetDialogTitle => 'अवधि समय सेट आयात करें';

  @override
  String get importPeriodTimeSetDialogBody =>
      'इस फ़ाइल में शामिल अवधि समय सेट हैं। क्या आप इन्हें आयात करके संबद्ध करना चाहते हैं?';

  @override
  String get importBundledPeriodTimeSets => 'आयात करें और संबद्ध करें';

  @override
  String get discardBundledPeriodTimeSets => 'शामिल सेट छोड़ें';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'कोई मौजूदा अवधि समय सेट उपलब्ध नहीं है, इसलिए शामिल अवधि समय सेटों को छोड़ा नहीं जा सकता।';

  @override
  String savedToPath(Object path) {
    return '$path में सहेजा गया';
  }

  @override
  String get saveCancelled => 'सहेजना रद्द किया गया';

  @override
  String get fileSaveRestrictedTitle => 'फ़ाइल सहेजना सीमित है';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'सिस्टम फ़ाइल सहेज नहीं सका। आप फिर से कोशिश कर सकते हैं या इसकी जगह शेयरिंग का उपयोग कर सकते हैं।';

  @override
  String get retrySave => 'फिर से सहेजें';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'सिस्टम सेटिंग्स में फ़ाइल एक्सेस सक्षम करें, फिर वापस आकर दोबारा निर्यात करें।';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get browserDownloadRestrictedTitle => 'ब्राउज़र डाउनलोड सीमित है';

  @override
  String get browserDownloadRestrictedMessage =>
      'यह ब्राउज़र सीधे स्थानीय फ़ाइल में सहेजने का समर्थन नहीं करता। ब्राउज़र डाउनलोड अनुमतियाँ जाँचें या इसकी जगह फ़ाइल शेयरिंग का उपयोग करें।';

  @override
  String get switchToShare => 'इसके बजाय शेयरिंग उपयोग करें';

  @override
  String get fileSaveFailedTitle => 'फ़ाइल सहेजना विफल';

  @override
  String get fileSaveFailedWindowsMessage =>
      'वर्तमान पथ पर लिखा नहीं जा सका। लक्ष्य फ़ोल्डर संरक्षित हो सकता है, फ़ाइल उपयोग में हो सकती है, या पथ लिखने योग्य नहीं हो सकता।';

  @override
  String get fileSaveFailedGenericMessage =>
      'सिस्टम फ़ाइल सहेज नहीं सका। आप फिर से कोशिश कर सकते हैं, सिस्टम सेटिंग्स जाँच सकते हैं या इसकी जगह फ़ाइल शेयरिंग का उपयोग कर सकते हैं।';

  @override
  String get retryLater => 'बाद में फिर कोशिश करें';

  @override
  String get exportSwitchedToShare =>
      'निर्यात के लिए फ़ाइल शेयरिंग पर स्विच किया गया';

  @override
  String get saveFailedRetry =>
      'सहेजना विफल हुआ। कृपया बाद में फिर कोशिश करें।';

  @override
  String get importFailedCheckContent =>
      'आयात विफल हुआ। कृपया फ़ाइल सामग्री जाँचें।';

  @override
  String get noImportableTimetables =>
      'आयात की गई फ़ाइल में कोई उपयोगी टाइमटेबल नहीं मिला।';

  @override
  String importedTimetablesCount(int count) {
    return '$count टाइमटेबल आयात किए गए';
  }

  @override
  String get periodTimesTitle => 'अवधि समय';

  @override
  String get importExport => 'आयात और निर्यात';

  @override
  String get importPeriodTemplate => 'अवधि टेम्पलेट आयात करें';

  @override
  String get importPeriodTemplateText => 'पाठ से अवधि टेम्पलेट आयात करें';

  @override
  String get sharePeriodTemplate => 'अवधि टेम्पलेट साझा करें';

  @override
  String get saveTemplateToFile => 'टेम्पलेट फ़ाइल में सहेजें';

  @override
  String get exportPeriodTemplateText =>
      'अवधि टेम्पलेट को पाठ के रूप में निर्यात करें';

  @override
  String get deletePeriodTimeSet => 'अवधि समय सेट हटाएँ';

  @override
  String get periodTimeSetName => 'अवधि समय सेट का नाम';

  @override
  String get addOnePeriod => 'अवधि जोड़ें';

  @override
  String periodNumberLabel(int index) {
    return 'अवधि $index';
  }

  @override
  String get deleteThisPeriod => 'इस अवधि को हटाएँ';

  @override
  String durationMinutes(int minutes) {
    return 'अवधि $minutes मिनट';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'पिछली से अंतर $minutes मिनट';
  }

  @override
  String get endTimeMustBeLater =>
      'समाप्ति समय प्रारंभ समय से बाद का होना चाहिए';

  @override
  String get periodOverlapPrevious => 'यह अवधि पिछली अवधि से ओवरलैप करती है';

  @override
  String get periodTimesSaved => 'अवधि समय सहेजे गए';

  @override
  String get deletePeriodTimeSetTitle => 'अवधि समय सेट हटाएँ';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return '\"$name\" हटाएँ?';
  }

  @override
  String get currentPeriodTimeSet => 'वर्तमान अवधि समय सेट';

  @override
  String importedPeriodTimesCount(int count) {
    return '$count अवधि समय आयात किए गए';
  }

  @override
  String get periodFilePermissionTitle => 'फ़ाइल अनुमति आवश्यक है';

  @override
  String get androidFilePermissionMessage =>
      'Android निर्यात के लिए फ़ाइल एक्सेस अनुमति चाहिए। सहेजना जारी रखने के लिए अनुमति दें।';

  @override
  String get reauthorize => 'फिर से अनुमति दें';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'अनुमति स्थायी रूप से अस्वीकृत';

  @override
  String get permissionSettingsExportMessage =>
      'सिस्टम सेटिंग्स में फ़ाइल एक्सेस सक्षम करें, फिर वापस आकर दोबारा निर्यात करें।';

  @override
  String get privacyPolicyTitle => 'गोपनीयता नीति';

  @override
  String get privacyPolicyEntryDesc =>
      'जानें कि ऐप स्थानीय संग्रहण, स्कूल-साइट कॉन्फ़िगरेशन, फ़ाइल आयात/निर्यात, वेबपेज पार्सिंग और बाहरी लिंक को कैसे संभालता है।';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'स्वीकृत संस्करण: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked एक स्थानीय-प्रथम समय सारिणी उपकरण है। समय सारिणी, अवधि-समय सेट और स्कूल-साइट कॉन्फ़िगरेशन केवल आपके डिवाइस या ब्राउज़र में संग्रहीत होते हैं और कभी भी स्वचालित रूप से अपलोड नहीं होते। ऐप केवल तभी डेटा संसाधित करता है जब आप स्पष्ट रूप से आयात, वेबपेज पार्सिंग, साझाकरण या बाहरी लिंक खोलने जैसी कार्रवाइयाँ शुरू करते हैं। पूर्ण गोपनीयता नीति ऑनलाइन उपलब्ध है।';

  @override
  String get privacyPolicyLocalStorageTitle => 'स्थानीय संग्रहण';

  @override
  String get privacyPolicyLocalStorageBody =>
      'टाइमटेबल डेटा और संबंधित सेटिंग्स ऐप दस्तावेज़ निर्देशिका में Sked_data.json नामक स्थानीय फ़ाइल में संग्रहीत होती हैं। संपादन योग्य स्कूल-साइट कॉन्फ़िगरेशन अलग से Sked_school_sites.json में संग्रहीत होती है। कस्टम टाइमटेबल पार्सर सेटिंग्स, जिनमें कोई भी कस्टम Base URL, API key और चयनित मॉडल शामिल हैं, उसी ऐप डेटा में स्थानीय रूप से संग्रहीत रहती हैं और सिस्टम क्रेडेंशियल वॉल्ट से सुरक्षित नहीं होतीं। ब्राउज़र में उपयोग होने पर, इसी प्रकार का डेटा ब्राउज़र स्टोरेज में सहेजा जाता है। ऐप इस स्थानीय डेटा को अपने-आप किसी डेवलपर-नियंत्रित सर्वर पर अपलोड नहीं करता।';

  @override
  String get privacyPolicyImportExportTitle => 'आयात और निर्यात';

  @override
  String get privacyPolicyImportExportBody =>
      'ऐप टाइमटेबल JSON फ़ाइलें, स्कूल-साइट JSON फ़ाइलें और अवधि-टेम्पलेट फ़ाइलें तभी पढ़ता या लिखता है जब आप स्पष्ट रूप से कोई फ़ाइल चुनते हैं या निर्यात क्रिया शुरू करते हैं। इन फ़ाइलों का आयात एक स्थानीय क्रिया है, जब तक कि आप वेबपेज पार्सिंग भी न चुनें। कस्टम मॉडल सूची प्राप्त करना भी एक स्पष्ट नेटवर्क क्रिया है और यह केवल उसी कस्टम एंडपॉइंट से संपर्क करता है जिसे आपने कॉन्फ़िगर किया है।';

  @override
  String get privacyPolicySharingTitle => 'साझाकरण';

  @override
  String get privacyPolicySharingBody =>
      'जब आप स्पष्ट रूप से शेयरिंग का उपयोग करते हैं, तो ऐप निर्यात की गई फ़ाइल को सिस्टम शेयर शीट या आपके चुने गए लक्ष्य ऐप को भेजता है। उसके बाद उस फ़ाइल को कैसे संभाला जाता है, यह आपके चुने गए लक्ष्य ऐप या सेवा पर निर्भर करता है।';

  @override
  String get privacyPolicyExternalLinksTitle => 'बाहरी लिंक';

  @override
  String get privacyPolicyExternalLinksBody =>
      'जब आप GitHub रिपॉज़िटरी जैसे बाहरी लिंक खोलते हैं, तो ऐप उस क्रिया को आपके ब्राउज़र या किसी अन्य बाहरी एप्लिकेशन को सौंप देता है। उसके बाद डेटा प्रबंधन उस तृतीय पक्ष द्वारा नियंत्रित होता है जिसे आप खोलते हैं।';

  @override
  String get privacyPolicyNoCollectionTitle => 'ऐप क्या एकत्र नहीं करता';

  @override
  String get privacyPolicyNoCollectionBody =>
      'ऐप को Sked खाते की आवश्यकता नहीं है और यह एनालिटिक्स, विज्ञापन पहचानकर्ता या क्लाउड बैकअप सक्षम नहीं करता। यह स्कूल खाते के पासवर्ड एकत्र करने के लिए अलग फ़ील्ड भी प्रदान नहीं करता। यदि आप ऐप के अंदर किसी स्कूल वेबसाइट में साइन इन करते हैं, तो वह इंटरैक्शन उसी स्कूल पेज पर होता है जिसे आपने खोला है।';

  @override
  String get privacyPolicyFutureFeatureTitle => 'वेबपेज पार्सिंग';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'जब आप स्कूल वेबपेज आयात का उपयोग करते हैं या पार्सिंग के लिए HTML पेस्ट करते हैं, तो ऐप पहले सामग्री को स्थानीय रूप से संपीड़ित करता है, फिर जमा की गई पेज सामग्री, वैकल्पिक पेज शीर्षक और URL, वर्तमान ऐप भाषा और पार्सर प्रॉम्प्ट सामग्री को चयनित पार्सिंग एंडपॉइंट पर भेजता है। यदि आप आधिकारिक पार्सर का उपयोग करते हैं, तो अनुरोध ऐप के कॉन्फ़िगर किए गए आधिकारिक बैकएंड पर जाता है। यदि आप कस्टम OpenAI-compatible पार्सर सक्षम करते हैं, तो वही सामग्री सीधे आपके कॉन्फ़िगर किए गए तृतीय-पक्ष एंडपॉइंट पर भेजी जाती है, और मॉडल सूची प्राप्त करना भी उसी एंडपॉइंट को अनुरोध भेजता है। कस्टम एंडपॉइंट अपने प्रदाता की डिज़ाइन के अनुसार अनुरोध को अन्य AI सेवाओं तक अग्रेषित कर सकता है। वर्तमान में डिप्लॉय किया गया आधिकारिक बैकएंड प्रत्येक सबमिट किए गए payload को 300KB तक सीमित करता है, अपने कॉन्फ़िगर किए गए timeout का उपयोग करता है, और प्रति IP प्रति दिन अधिकतम 5 पार्सिंग अनुरोधों की अनुमति देता है।';

  @override
  String get privacyPolicyUpdatesTitle => 'नीति अपडेट';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'वर्तमान गोपनीयता नीति संस्करण $version है। यदि किसी बाद के संस्करण में डेटा प्रबंधन का तरीका बदलता है, तो ऐप आपसे अद्यतन नीति को फिर से पढ़ने और स्वीकार करने के लिए कह सकता है।';
  }

  @override
  String get privacyGateTitle =>
      'ऐप का उपयोग करने से पहले कृपया गोपनीयता नीति से सहमत हों';

  @override
  String get privacyGateSummaryStorage =>
      'टाइमटेबल, अवधि-समय सेट और स्कूल-साइट कॉन्फ़िगरेशन केवल स्थानीय रूप से संग्रहीत होते हैं और अपने-आप किसी डेवलपर सर्वर पर अपलोड नहीं होते।';

  @override
  String get privacyGateSummaryImportExport =>
      'आयात, निर्यात और शेयरिंग केवल तभी होते हैं जब आप उन्हें स्पष्ट रूप से शुरू करते हैं; वेबपेज पार्सिंग केवल वही संपीड़ित सामग्री आपके कॉन्फ़िगर किए गए पार्सिंग एंडपॉइंट पर भेजती है जो आप जमा करते हैं, और सहेजने से पहले आप पार्स किए गए टाइमटेबल की समीक्षा कर सकते हैं।';

  @override
  String get privacyGateSummaryUpdates =>
      'यदि किसी बाद के संस्करण में डेटा प्रबंधन का तरीका बदलता है, तो ऐप आपसे अद्यतन गोपनीयता नीति की फिर से समीक्षा करने के लिए कह सकता है।';

  @override
  String get schoolWebImportEntry => 'स्कूल वेबपेज से आयात करें';

  @override
  String get schoolWebImportEntryDesc =>
      'स्कूल साइट के वर्तमान टाइमटेबल पेज को आयात करें।';

  @override
  String get schoolSitesManageEntry => 'स्कूल साइट प्रबंधित करें';

  @override
  String get schoolSitesManageEntryDesc =>
      'स्कूल लॉगिन URL जोड़ें, संपादित करें और हटाएँ, साथ में JSON आयात और निर्यात।';

  @override
  String get schoolSitesPageTitle => 'स्कूल साइट प्रबंधन';

  @override
  String get schoolSitesImportJson => 'स्कूल JSON आयात करें';

  @override
  String get schoolSitesShareJson => 'स्कूल JSON साझा करें';

  @override
  String get schoolSitesSaveJson => 'स्कूल JSON सहेजें';

  @override
  String get schoolSitesSaved => 'स्कूल साइटें सहेजी गईं';

  @override
  String get schoolSitesImported => 'स्कूल साइटें आयात की गईं';

  @override
  String get schoolSitesEmpty => 'अभी तक कोई स्कूल साइट कॉन्फ़िगरेशन नहीं है।';

  @override
  String get schoolSitesNameLabel => 'स्कूल का नाम';

  @override
  String get schoolSitesLoginUrlLabel => 'लॉगिन URL';

  @override
  String get schoolSitesAdd => 'स्कूल जोड़ें';

  @override
  String get schoolSitesEdit => 'स्कूल संपादित करें';

  @override
  String get schoolSitesDeleteTitle => 'स्कूल हटाएँ';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return '\"$name\" हटाएँ?';
  }

  @override
  String get schoolSitesFormInvalid => 'पहले स्कूल का नाम और लॉगिन URL भरें।';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'टाइमटेबल पेज की सामग्री पेस्ट करके आयात करें';

  @override
  String get schoolHtmlImportEntryDesc =>
      'टाइमटेबल जानकारी वाली स्रोत कोड या कच्ची पेज सामग्री मैन्युअल रूप से पेस्ट करें।';

  @override
  String get schoolHtmlImportPageTitle => 'पेज सामग्री से टाइमटेबल पार्स करें';

  @override
  String get schoolHtmlImportUrlLabel => 'स्रोत URL (वैकल्पिक)';

  @override
  String get schoolHtmlImportTitleLabel => 'पेज शीर्षक (वैकल्पिक)';

  @override
  String get schoolHtmlImportHtmlLabel => 'पेज सामग्री';

  @override
  String get schoolHtmlImportHtmlHint =>
      'टाइमटेबल जानकारी वाली स्रोत कोड या कच्ची पेज सामग्री यहाँ पेस्ट करें।';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'केवल HTML ही नहीं, टाइमटेबल जानकारी वाली कोई भी सामग्री पार्स और आयात की जा सकती है।';

  @override
  String get schoolHtmlImportCompress => 'सामग्री संपीड़ित करें';

  @override
  String get schoolHtmlImportCompressed => 'सामग्री संपीड़ित की गई';

  @override
  String get schoolHtmlImportCompressFirst => 'पहले सामग्री संपीड़ित करें।';

  @override
  String get schoolHtmlImportSubmit => 'पार्स करें और आयात करें';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'पार्सिंग में समय लग सकता है। कृपया प्रतीक्षा करें।';

  @override
  String get schoolHtmlImportEmpty => 'पहले पेज HTML पेस्ट करें।';

  @override
  String get schoolHtmlImportReturnToWebPage => 'वेबपेज पर वापस जाएँ';

  @override
  String get schoolWebImportPageTitle => 'स्कूल वेबपेज आयात';

  @override
  String get schoolWebImportPreview => 'आयात पूर्वावलोकन';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count कोर्स';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count अवधि';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'पेज शीर्षक';

  @override
  String get schoolWebImportParserUsed => 'पार्सर';

  @override
  String get schoolWebImportWarnings => 'आयात नोट्स';

  @override
  String get schoolWebImportOpenPageHint =>
      'ऐप के भीतर स्कूल साइट में साइन इन करें, फिर मैन्युअल रूप से टाइमटेबल पेज पर जाएँ।';

  @override
  String get schoolWebImportConfigMissing =>
      'वेब आयात बैकएंड API अभी कॉन्फ़िगर नहीं है।';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'यह प्लेटफ़ॉर्म अभी एम्बेडेड वेब लॉगिन का समर्थन नहीं करता। कृपया WebView समर्थन वाले प्लेटफ़ॉर्म का उपयोग करें।';

  @override
  String get schoolWebImportSelectSchool => 'स्कूल चुनें';

  @override
  String get schoolWebImportNoSchools =>
      'कोई स्कूल कॉन्फ़िगरेशन उपलब्ध नहीं है। पहले school_sites.json जाँचें।';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'स्कूल कॉन्फ़िगरेशन लोड नहीं हो सका। JSON फ़ाइल फ़ॉर्मेट जाँचें।';

  @override
  String get schoolWebImportImportCurrentPage => 'वर्तमान पेज आयात करें';

  @override
  String get schoolWebImportGoBack => 'पिछला पेज';

  @override
  String get schoolWebImportLoadingPage => 'पेज लोड हो रहा है…';

  @override
  String get schoolWebImportParsing => 'वर्तमान पेज पार्स हो रहा है…';

  @override
  String get schoolWebImportLoadFailed =>
      'पेज लोड विफल हुआ। कृपया रीफ़्रेश करें या बाद में फिर प्रयास करें।';

  @override
  String get schoolWebImportLoadTimedOut =>
      'पेज लोड होने में समय समाप्त हो गया। कृपया रीफ़्रेश करें और फिर प्रयास करें।';

  @override
  String get schoolWebImportEmptyPage =>
      'वर्तमान पेज सामग्री खाली है और अभी आयात नहीं की जा सकती।';

  @override
  String get schoolWebImportSuccess => 'वेब टाइमटेबल आयात किया गया';

  @override
  String get schoolImportParserSettingsTitle => 'टाइमटेबल पार्सर सेटिंग्स';

  @override
  String get schoolImportParserSettingsDesc =>
      'आधिकारिक पार्सर या कस्टम OpenAI-compatible एंडपॉइंट चुनें।';

  @override
  String get schoolImportParserSourceTitle => 'पार्सर स्रोत';

  @override
  String get schoolImportParserSourceOfficial => 'आधिकारिक पार्सर';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'ऐप द्वारा कॉन्फ़िगर की गई अंतर्निहित आधिकारिक पार्सिंग सेवा का उपयोग करें।';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'आधिकारिक पार्सर ऐप के कॉन्फ़िगर किए गए पार्सिंग बैकएंड का उपयोग करता है और वर्तमान आयात प्रवाह को अपरिवर्तित रखता है।';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'कस्टम OpenAI-compatible';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'पेज सामग्री सीधे अपने OpenAI-compatible एंडपॉइंट पर भेजें।';

  @override
  String get schoolImportParserCustomOpenAi => 'कस्टम OpenAI-compatible पार्सर';

  @override
  String get schoolImportParserCustomPromptTitle => 'कस्टम प्रॉम्प्ट';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'यहाँ अंतर्निहित पार्सर प्रॉम्प्ट संपादित करें। बदलाव केवल कस्टम OpenAI-compatible पार्सर को प्रभावित करेंगे।';

  @override
  String get schoolImportParserCustomPromptHint =>
      'डिफ़ॉल्ट रूप से यहाँ अंतर्निहित प्रॉम्प्ट लोड होता है। अंतर्निहित संस्करण पर लौटने के लिए इसे साफ़ करें।';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'डिफ़ॉल्ट प्रॉम्प्ट रीसेट करें';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'मॉडल';

  @override
  String get schoolImportParserFetchModels => 'मॉडल सूची प्राप्त करें';

  @override
  String get schoolImportParserFetchingModels =>
      'मॉडल प्राप्त किए जा रहे हैं...';

  @override
  String get schoolImportParserNoModelsFound =>
      'एंडपॉइंट ने कोई मॉडल नहीं लौटाया।';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '$count मॉडल प्राप्त हुए';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'वर्तमान कार्यान्वयन में कस्टम API key ऐप की स्थानीय सेटिंग्स में साधारण पाठ में संग्रहीत होती है। इसे केवल ऐसे डिवाइस या ब्राउज़र वातावरण में उपयोग करें जिस पर आप भरोसा करते हों।';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'कस्टम पार्सर कॉन्फ़िगरेशन अधूरी है। पहले Base URL, API key और मॉडल भरें।';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'पार्सर: आधिकारिक';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'पार्सर: कस्टम ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'पूरी गोपनीयता नीति देखें';

  @override
  String get privacyAgreeAndContinue => 'सहमत हूँ और जारी रखें';

  @override
  String get privacyDecline => 'अस्वीकार करें';

  @override
  String get privacyDeclineWebHint =>
      'यह ब्राउज़र वातावरण ऐप को आपके लिए पेज बंद करने की अनुमति नहीं देता। यदि आप सहमत नहीं हैं, तो कृपया यह टैब या विंडो स्वयं बंद करें।';

  @override
  String get defaultPeriodTimeSetName => 'डिफ़ॉल्ट अवधियाँ';

  @override
  String get periodTimeSetFallbackName => 'अवधि समय';

  @override
  String get untitledTimetableName => 'बिना शीर्षक टाइमटेबल';

  @override
  String get newTimetableName => 'नया टाइमटेबल';

  @override
  String get newPeriodTimeSetName => 'नया अवधि समय सेट';

  @override
  String get emptyTimetableName => 'खाली टाइमटेबल';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name अवधियाँ';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'आयात फ़ाइल प्रकार मेल नहीं खाता।';

  @override
  String get importFileVersionUnsupportedMessage =>
      'यह आयात फ़ाइल संस्करण अभी समर्थित नहीं है।';

  @override
  String get noPeriodTimesInImportMessage =>
      'आयात फ़ाइल में कोई अवधि समय नहीं मिला।';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'कृपया कम से कम एक टाइमटेबल चुनें।';

  @override
  String get noExportableTimetableMessage =>
      'निर्यात के लिए कोई टाइमटेबल उपलब्ध नहीं है।';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'वर्तमान टाइमटेबल बदलने के लिए केवल एक टाइमटेबल का चयन समर्थित है।';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'बदलने के लिए कोई वर्तमान टाइमटेबल नहीं है।';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'यह अवधि समय सेट अभी भी $count टाइमटेबल में उपयोग हो रहा है। हटाने से पहले उन्हें पुनः असाइन करें।';
  }

  @override
  String get weekdayMonday => 'सोमवार';

  @override
  String get weekdayTuesday => 'मंगलवार';

  @override
  String get weekdayWednesday => 'बुधवार';

  @override
  String get weekdayThursday => 'गुरुवार';

  @override
  String get weekdayFriday => 'शुक्रवार';

  @override
  String get weekdaySaturday => 'शनिवार';

  @override
  String get weekdaySunday => 'रविवार';

  @override
  String get weekdayShortMonday => 'सोम';

  @override
  String get weekdayShortTuesday => 'मंगल';

  @override
  String get weekdayShortWednesday => 'बुध';

  @override
  String get weekdayShortThursday => 'गुरु';

  @override
  String get weekdayShortFriday => 'शुक्र';

  @override
  String get weekdayShortSaturday => 'शनि';

  @override
  String get weekdayShortSunday => 'रवि';

  @override
  String get monthJanuary => 'जन';

  @override
  String get monthFebruary => 'फ़र';

  @override
  String get monthMarch => 'मार्च';

  @override
  String get monthApril => 'अप्रै';

  @override
  String get monthMay => 'मई';

  @override
  String get monthJune => 'जून';

  @override
  String get monthJuly => 'जुल';

  @override
  String get monthAugust => 'अग';

  @override
  String get monthSeptember => 'सित';

  @override
  String get monthOctober => 'अक्टू';

  @override
  String get monthNovember => 'नव';

  @override
  String get monthDecember => 'दिस';

  @override
  String get semesterWeeksWholeTerm => 'पूरा सेमेस्टर';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'सप्ताह $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'सप्ताह $value';
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

  @override
  String get addEvent => 'Add event';

  @override
  String get editEvent => 'Edit event';

  @override
  String get eventTitle => 'Title';

  @override
  String get eventTitleRequired => 'Title is required';

  @override
  String get eventStartTime => 'Start time';

  @override
  String get eventEndTime => 'End time';

  @override
  String get eventDate => 'Date';

  @override
  String get eventTime => 'Time';

  @override
  String get eventNotes => 'Notes';

  @override
  String get eventColor => 'Color';

  @override
  String get eventRecurrence => 'Repeat';

  @override
  String get recurrenceNone => 'Does not repeat';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceEndDate => 'End date';

  @override
  String get recurrenceNoEndDate => 'No end date';

  @override
  String get recurrenceSetEndDate => 'Set';

  @override
  String get recurrenceChangeEndDate => 'Change';

  @override
  String get repeatsWeekly => 'Repeats weekly';

  @override
  String recurrenceUntil(Object date) {
    return 'Until $date';
  }

  @override
  String get switchToGeneralSchedule => 'Switch to General schedule';

  @override
  String get generalDisplaySettings => 'General display settings';

  @override
  String get generalDisplaySettingsDesc =>
      'Toggles for the general schedule view';

  @override
  String get closePopupOnOutsideTap => 'Close popup on tap outside';

  @override
  String get showGridLines => 'Show grid lines';

  @override
  String get generalScheduleImportExport => 'Schedule import & export';

  @override
  String get generalScheduleImportExportDesc =>
      'Import or share general schedules';

  @override
  String get importGeneralSchedules => 'Import schedules';

  @override
  String get importGeneralSchedulesDesc => 'Read schedules from a JSON file';

  @override
  String get shareGeneralSchedules => 'Share schedules';

  @override
  String get shareGeneralSchedulesDesc => 'Share schedules as a JSON file';

  @override
  String get saveGeneralSchedules => 'Save schedules';

  @override
  String get saveGeneralSchedulesDesc => 'Save schedules as a JSON file';

  @override
  String get selectSchedulesToExport => 'Select schedules to export';

  @override
  String get selectSchedulesToImport => 'Select schedules to import';

  @override
  String generalScheduleEventCount(int count) {
    return 'Events: $count';
  }

  @override
  String importedSchedulesCount(int count) {
    return 'Imported $count schedules';
  }

  @override
  String get replaceActiveSchedulePrompt =>
      'Replace current schedule with the imported one?';

  @override
  String get addAsNewSchedule => 'Add as new';

  @override
  String get selectAtLeastOneScheduleMessage =>
      'Please select at least one schedule.';

  @override
  String get noExportableScheduleMessage => 'No schedule available to export.';

  @override
  String get noSchedulesInImportMessage => 'Import file contains no schedules.';

  @override
  String get replaceActiveRequiresSingleScheduleMessage =>
      'Choose exactly one schedule to replace the current one.';

  @override
  String get noActiveScheduleToReplaceMessage =>
      'No current schedule to replace.';

  @override
  String get calendars => 'Calendars';

  @override
  String get calendar => 'Calendar';

  @override
  String get viewWeek => 'Week';

  @override
  String get viewDay => 'Day';

  @override
  String get viewList => 'List';

  @override
  String get viewMonth => 'Month';

  @override
  String get eventDuplicated => 'Event duplicated';

  @override
  String get searchEvents => 'Search events';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get filterByColor => 'Filter by color';

  @override
  String get allColors => 'All colors';

  @override
  String upcomingEventsCount(int count) {
    return 'Upcoming $count';
  }

  @override
  String overdueEventsCount(int count) {
    return 'Overdue $count';
  }

  @override
  String get allDay => 'All-day';

  @override
  String moreEvents(int count) {
    return '+$count more';
  }

  @override
  String get noMatchingEvents => 'No matching events';

  @override
  String get noUpcomingEvents => 'No upcoming events';

  @override
  String get addCalendar => 'Add calendar';

  @override
  String get newCalendar => 'New calendar';

  @override
  String get hideCalendar => 'Hide calendar';

  @override
  String get showCalendar => 'Show calendar';

  @override
  String get rename => 'Rename';

  @override
  String get renameCalendar => 'Rename calendar';

  @override
  String get name => 'Name';

  @override
  String get deleteCalendar => 'Delete calendar';

  @override
  String deleteCalendarMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteThisOccurrence => 'Delete this';

  @override
  String get deleteFutureOccurrences => 'Delete future';

  @override
  String get deleteAllOccurrences => 'Delete all';

  @override
  String get duplicateEvent => 'Duplicate';

  @override
  String get repeatsDaily => 'Repeats daily';

  @override
  String get repeatsMonthly => 'Repeats monthly';

  @override
  String repeatsEvery(int interval, Object unit) {
    return 'Repeats every $interval $unit';
  }

  @override
  String recurrenceCountTimes(int count) {
    return '$count times';
  }

  @override
  String get recurrenceDaily => 'Daily';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get recurrenceCustom => 'Custom';

  @override
  String get recurrenceEvery => 'Every';

  @override
  String get recurrenceUnit => 'Unit';

  @override
  String get recurrenceDays => 'Days';

  @override
  String get recurrenceWeeks => 'Weeks';

  @override
  String get recurrenceMonths => 'Months';

  @override
  String get recurrenceRepeatCount => 'Repeat count';

  @override
  String get recurrenceNoLimit => 'No limit';

  @override
  String get recurrencePositiveNumber => 'Enter a positive number';

  @override
  String get clearEndDate => 'Clear end date';

  @override
  String get pickDate => 'Pick date';

  @override
  String get pickTime => 'Pick time';

  @override
  String get reminder => 'In-app reminder';

  @override
  String get reminderAtStart => 'At start';

  @override
  String reminderMinutesBefore(int minutes) {
    return '$minutes min before';
  }

  @override
  String get reminderHourBefore => '1 hour before';

  @override
  String get reminderDayBefore => '1 day before';

  @override
  String get markReminderHandled => 'Mark handled';

  @override
  String get restoreReminder => 'Restore in-app reminder';

  @override
  String get reminderHandled => 'In-app reminder marked handled';

  @override
  String get reminderRestored => 'In-app reminder restored';

  @override
  String get reminderUpcoming => 'Upcoming';

  @override
  String get reminderOverdue => 'Overdue';

  @override
  String get showWeekends => 'Show weekends';

  @override
  String get startHour => 'Start hour';

  @override
  String get endHour => 'End hour';

  @override
  String get timeGridDensity => 'Time grid density';

  @override
  String get importJsonFile => 'Import JSON file';

  @override
  String get pasteJson => 'Paste JSON';

  @override
  String get importGeneralSchedulesJsonTextDesc =>
      'Import calendars from copied JSON';

  @override
  String get importIcsFile => 'Import ICS file';

  @override
  String get importIcsFileDesc => 'Read events from an .ics calendar file';

  @override
  String get pasteIcs => 'Paste ICS';

  @override
  String get pasteIcsDesc => 'Import events from copied calendar text';

  @override
  String get copyJson => 'Copy JSON';

  @override
  String get copyJsonDesc => 'Copy selected calendars as JSON text';

  @override
  String get shareIcs => 'Share ICS';

  @override
  String get shareIcsDesc => 'Share selected calendars as .ics';

  @override
  String get saveIcs => 'Save ICS';

  @override
  String get saveIcsDesc => 'Save selected calendars as .ics';

  @override
  String get copyIcs => 'Copy ICS';

  @override
  String get copyIcsDesc => 'Copy selected calendars as ICS text';

  @override
  String get importIcs => 'Import ICS';

  @override
  String get icsContent => 'ICS content';

  @override
  String get pasteIcsContentHint => 'Paste BEGIN:VCALENDAR content here';

  @override
  String importIcsPreviewPrompt(int count) {
    return 'Found $count events. Import as a new calendar or replace the active calendar?';
  }

  @override
  String importedSchedulesWithWarnings(int count, int warningCount) {
    return 'Imported $count schedules with $warningCount warnings';
  }

  @override
  String get importWarningSkippedMissingStart =>
      'Skipped an event without a start time.';

  @override
  String get importWarningSkippedUnsupportedStart =>
      'Skipped an event with an unsupported start time.';

  @override
  String get importWarningAdjustedEnd =>
      'Adjusted an event whose end time was not after its start.';

  @override
  String importWarningUnsupportedFields(Object fields) {
    return 'Unsupported ICS fields were added to notes: $fields';
  }

  @override
  String importWarningUnsupportedRRuleFrequency(Object frequency) {
    return 'Ignored unsupported repeat frequency: $frequency';
  }

  @override
  String get selectCalendarsToCopyIcs => 'Select calendars to copy as ICS';

  @override
  String get selectCalendarsToExportIcs => 'Select calendars to export as ICS';

  @override
  String get exportIcsText => 'Export ICS text';

  @override
  String get exportJsonText => 'Export JSON text';

  @override
  String get dataRestoredFromBackupNotice =>
      'App data was restored from the previous backup because the main file failed to load.';

  @override
  String get dataBackupRestoreFailedNotice =>
      'Both the main data file and its backup are damaged. The app is now using a fresh state.';
}
