// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'زميل فصل';

  @override
  String weekLabel(int week) {
    return 'الأسبوع $week';
  }

  @override
  String get addCourse => 'إضافة دورة';

  @override
  String get settings => 'إعدادات';

  @override
  String get multiTimetableSwitch => 'تغيير الجداول الزمنية';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'الجدول الزمني الحالي · $weeks أسابيع';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'اضغط لتبديل · $weeks أسابيع';
  }

  @override
  String get editTimetable => 'تعديل الجدول الزمني';

  @override
  String get createTimetable => 'جدول جديد';

  @override
  String get jumpToWeek => 'قفز إلى الأسبوع';

  @override
  String get timetable => 'الجدول الزمني';

  @override
  String get timetableName => 'اسم الجدول الزمني';

  @override
  String get totalWeeks => 'مجموع الأسابيع';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get deleteTimetableTitle => 'حذف الجدول الزمني';

  @override
  String deleteTimetableMessage(Object name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get noTimetableTitle => 'لا جدول زمني بعد';

  @override
  String get noTimetableMessage =>
      'قم بإنشاء جدول زمني أو استيراد واحد من ملف JSON.';

  @override
  String get importTimetable => 'جدول استيراد';

  @override
  String get courseName => 'اسم الدورة';

  @override
  String get location => 'الموقع';

  @override
  String get dayOfWeek => 'يوم';

  @override
  String get semesterWeeks => 'أسابيع';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get endTime => 'وقت النهاية';

  @override
  String get linkedPeriods => 'فترات مرتبطة';

  @override
  String get linkedPeriodsUnmatched =>
      'لا توجد فترات مطابقة للوقت الحالي. اضغط للاختيار يدوياً.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'فترة $start-$end';
  }

  @override
  String get teacherName => 'المعلم';

  @override
  String get credits => 'الائتمانات';

  @override
  String get remarks => 'ملاحظات';

  @override
  String get customFields => 'حقول مخصصة';

  @override
  String get customFieldsHint => 'واحد لكل سطر، تنسيق: مفتاح: قيمة';

  @override
  String get selectDayOfWeek => 'اختر اليوم';

  @override
  String get selectSemesterWeeks => 'اختر الأسابيع';

  @override
  String get selectAll => 'اختر كل';

  @override
  String get clear => 'مسح';

  @override
  String get confirm => 'تأكيد';

  @override
  String get selectLinkedPeriods => 'اختر الفترات المرتبطة';

  @override
  String get addCourseTitle => 'إضافة دورة';

  @override
  String get editCourseTitle => 'تعديل الدورة';

  @override
  String get editCourseTooltip => 'تعديل الدورة';

  @override
  String get place => 'الموقع';

  @override
  String get time => 'الوقت';

  @override
  String get notFilled => 'غير ملء';

  @override
  String get none => 'لا أحد';

  @override
  String get conflictCourses => 'دورات متضاربة';

  @override
  String get locationNotFilled => 'الموقع غير ملء';

  @override
  String get setAsDisplayed => 'تعيين كما يظهر';

  @override
  String get editThisCourse => 'عدل هذه الدورة';

  @override
  String get settingsTitle => 'إعدادات';

  @override
  String get noTimetableSettings => 'لا يوجد جدول زمني متاح حالياً للإعدادات.';

  @override
  String get semesterStartDate => 'تاريخ بداية الفصل الدراسي';

  @override
  String get periodTimeSets => 'فترة زمنية محددة';

  @override
  String get noPeriodTimeAvailable => 'لا يوجد وقت متاح';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count فترات';
  }

  @override
  String get coursePopupDismissSetting =>
      'السماح بالنقر الخارجي لإغلاق الدورة المنبثقة';

  @override
  String get coursePopupDismissSettingHint =>
      'إيقاف تشغيل هذا يعطل أيضًا فصل التمرير للأسفل.';

  @override
  String get preserveTimetableGaps => 'الحفاظ على فجوات الجدول الزمني';

  @override
  String get preserveTimetableGapsHint =>
      'عند التوقف ، تنهار فجوات الغداء والاستراحة حتى تتحرك الفصول اللاحقة للأعلى.';

  @override
  String get showPastEndedCourses => 'عرض الدورات التي انتهت في الماضي';

  @override
  String get showPastEndedCoursesHint =>
      'عرض الدورات التي انتهت بالفعل من قبل الأسبوع الحالي الحقيقي مع أسلوب رمادي أكثر وضوحا.';

  @override
  String get showFutureCourses => 'عرض الدورات المستقبلية';

  @override
  String get showFutureCoursesHint =>
      'عرض الدورات التي ليست نشطة هذا الأسبوع ولكن سوف تظهر في الأسابيع اللاحقة بأسلوب رمادي.';

  @override
  String get timetableDisplaySettings => 'عرض الجدول الزمني والتفاعل';

  @override
  String get timetableDisplaySettingsDesc =>
      'إقالة النافذة المنبثقة والفجوات والدورات الرمادية وخطوط الشبكة';

  @override
  String get showTimetableGridLines => 'أظهر خطوط شبكة الجدول الزمني';

  @override
  String get showTimetableGridLinesHint =>
      'التحكم فيما إذا كانت خطوط الشبكة الأفقية والرأسية مرئية في الجدول الزمني.';

  @override
  String get liveCourseOutlineColor => 'لون مخطط الدورة';

  @override
  String get liveCourseOutlineColorHint =>
      'اختر ما إذا كانت المخططات تستهدف الدورة الحالية / القادمة أو جميع الدورات المعروضة على الصفحة الحالية.';

  @override
  String get liveCourseOutlineSettings => 'مخطط الدورة';

  @override
  String get liveCourseOutlineSettingsHint =>
      'قم بتكوين ما إذا كان المخطط مفعولاً، وماذا يستهدف، وما إذا كان يتبع لون الموضوع، ولون المخطط الفعال.';

  @override
  String get liveCourseOutlineEnabled => 'تمكين المخطط';

  @override
  String get liveCourseOutlineFollowTheme => 'اتبع لون الموضوع';

  @override
  String get liveCourseOutlineTarget => 'الهدف المحدد';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'الدورة الحالية/القادمة';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'جميع الدورات المعروضة';

  @override
  String get liveCourseOutlineEffectiveColor => 'لون فعال';

  @override
  String get liveCourseOutlineCustomColor => 'لون مخطط مخصص';

  @override
  String get liveCourseOutlineWidth => 'عرض المخطط';

  @override
  String get outlineWidthUnit => 'بكس';

  @override
  String get language => 'اللغة';

  @override
  String get languagePageDescription =>
      'اختر واحدة من اللغات المتاحة فعلا في التطبيق.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'استجابة API';

  @override
  String get theme => 'الموضوع';

  @override
  String get themeFollowSystem => 'اتبع النظام';

  @override
  String get themeLight => 'ضوء';

  @override
  String get themeDark => 'مظلمة';

  @override
  String get themeColor => 'لون الموضوع';

  @override
  String get themeColorModeSingle => 'لون موضوع واحد';

  @override
  String get themeColorModeColorful => 'ملونة';

  @override
  String get themeColorUiColors => 'ألوان واجهة المستخدم';

  @override
  String get themeColorCourseColors => 'ألوان الدورة';

  @override
  String get themeColorPrimary => 'الابتدائية';

  @override
  String get themeColorSecondary => 'الثانوية';

  @override
  String get themeColorTertiary => 'الثالث';

  @override
  String get themeColorCourseText => 'نص الدورة';

  @override
  String get themeColorCourseTextAuto => 'السيارات';

  @override
  String get themeColorCourseTextCustom => 'لون مخصص';

  @override
  String get themeColorCourseColorsEmpty =>
      'سيتم إنشاء ألوان الدورة بعد استيراد جدول زمني.';

  @override
  String get themeCustomColor => 'لون مخصص';

  @override
  String get themeApplyCustomColor => 'تطبيق اللون';

  @override
  String get themeApplySettings => 'تطبيق الإعدادات';

  @override
  String get dataImportExport => 'بيانات استيراد وتصدير';

  @override
  String get dataImportExportDesc =>
      'استيراد البيانات الكاملة أو الجداول الزمنية الفردية، أو تصدير الجداول الزمنية الحالية / جميع.';

  @override
  String get openSourceLicenses => 'تراخيص المصدر المفتوح';

  @override
  String get openSourceLicensesDesc =>
      'عرض تراخيص اعتمادات فلتر وأصول رمز التطبيقات المجمعة.';

  @override
  String get checkForUpdates => 'تحقق من التحديثات';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'بالفعل على أحدث إصدار ($version)';
  }

  @override
  String get currentVersionLabel => 'الإصدار الحالي';

  @override
  String get newVersionAvailable => 'تحديث متاح';

  @override
  String get latestVersionLabel => 'أحدث نسخة';

  @override
  String get updateContentLabel => 'تحديث التفاصيل';

  @override
  String get officialWebsite => 'الموقع الرسمي';

  @override
  String get googlePlay => 'جوجل بلاي';

  @override
  String get cloudDrive => 'محرك السحابة';

  @override
  String get ignoreThisVersion => 'تجاهل هذه النسخة';

  @override
  String get openUpdatesFailed => 'لا يمكن فتح رابط التحديث';

  @override
  String get updateCheckFailedTitle => 'فشل فحص التحديث';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'مخزن GitHub';

  @override
  String get openGithubFailed => 'غير قادر على فتح رابط مخزن GitHub';

  @override
  String get selectPeriodTimeSet => 'اختر فترة تعيين الوقت';

  @override
  String get newItem => 'جديد';

  @override
  String get editPeriodTimeSet => 'تعديل تعيين الوقت للفترة';

  @override
  String get importTimetableFiles => 'جدول استيراد';

  @override
  String get importTimetableFilesDesc => 'يدعم ملف جدول زمني واحد أو أكثر.';

  @override
  String get importTimetableText => 'استيراد الجدول الزمني من النص';

  @override
  String get importTimetableTextDesc =>
      'لصق محتوى الجدول الزمني JSON واستيراده.';

  @override
  String get shareTimetableFiles => 'مشاركة ملفات الجدول الزمني';

  @override
  String get shareTimetableFilesDesc => 'اختر جدول زمني واحد أو أكثر أولاً.';

  @override
  String get saveTimetableFiles => 'احفظ ملفات الجدول الزمني';

  @override
  String get saveTimetableFilesDesc => 'اختر جدول زمني واحد أو أكثر أولاً.';

  @override
  String get exportTimetableText => 'تصدير الجدول الزمني كنص';

  @override
  String get exportTimetableTextDesc =>
      'اختر جدول زمني واحد أو أكثر، ثم نسخ محتوى JSON.';

  @override
  String get jsonContent => 'محتوى JSON';

  @override
  String get pasteJsonContentHint => 'لصق محتوى JSON للاستيراد.';

  @override
  String get jsonContentEmpty => 'لصق محتوى JSON أولاً.';

  @override
  String get copyText => 'نسخ';

  @override
  String get copiedToClipboard => 'نسخ إلى لوحة المقاطع';

  @override
  String get share => 'مشاركة';

  @override
  String get selectTimetablesToExport => 'اختر الجداول الزمنية للتصدير';

  @override
  String get selectTimetablesToImport => 'اختر الجداول الزمنية للاستيراد';

  @override
  String timetableCourseCount(int count) {
    return ' $count دورات';
  }

  @override
  String get importAction => 'استيراد';

  @override
  String get importTimetableDialogTitle => 'جدول استيراد';

  @override
  String get chooseImportMethod => 'اختر كيفية الاستيراد.';

  @override
  String get importAsNewTimetable => 'استيراد كجدول جديد';

  @override
  String get replaceCurrentTimetable => 'استبدل الجدول الزمني الحالي';

  @override
  String get importPeriodTimeSetDialogTitle => 'مجموعات الوقت لفترة الاستيراد';

  @override
  String get importPeriodTimeSetDialogBody =>
      'هذا الملف يحتوي على مجموعات زمنية المجموعة. هل تريد استيرادها وربطها؟';

  @override
  String get importBundledPeriodTimeSets => 'استيراد وشركة';

  @override
  String get discardBundledPeriodTimeSets => 'التخلص من المجموعات المجمعة';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'لا توجد مجموعة زمنية موجودة، لذلك لا يمكن التخلص من مجموعات زمنية المجموعة.';

  @override
  String savedToPath(Object path) {
    return 'حفظت على $path';
  }

  @override
  String get saveCancelled => 'حفظ إلغاء';

  @override
  String get fileSaveRestrictedTitle => 'حفظ الملفات مقيد';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'لم يتمكن النظام من حفظ الملف. يمكنك إعادة محاولة أو استخدام المشاركة بدلاً من ذلك.';

  @override
  String get retrySave => 'اعادة محاولة حفظ';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'تمكين الوصول إلى الملفات في إعدادات النظام، ثم العودة ومحاولة التصدير مرة أخرى.';

  @override
  String get openSettings => 'افتح الإعدادات';

  @override
  String get browserDownloadRestrictedTitle => 'تحميل المتصفح مقيد';

  @override
  String get browserDownloadRestrictedMessage =>
      'هذا المتصفح لا يدعم الحفظ مباشرة إلى ملف محلي. تحقق من أذونات تحميل المتصفح أو استخدم مشاركة الملفات بدلاً من ذلك.';

  @override
  String get switchToShare => 'استخدم المشاركة بدلا من ذلك';

  @override
  String get fileSaveFailedTitle => 'فشلت حفظ الملف';

  @override
  String get fileSaveFailedWindowsMessage =>
      'غير قادر على الكتابة إلى المسار الحالي. قد يكون المجلد المستهدف محمياً، أو قد يكون الملف قيد الاستخدام، أو قد يكون المسار غير قابل للكتابة.';

  @override
  String get fileSaveFailedGenericMessage =>
      'لم يتمكن النظام من حفظ الملف. يمكنك إعادة المحاولة أو التحقق من إعدادات النظام أو استخدام مشاركة الملفات بدلاً من ذلك.';

  @override
  String get retryLater => 'حاول مرة أخرى لاحقاً';

  @override
  String get exportSwitchedToShare => 'انتقلت إلى مشاركة الملفات للتصدير';

  @override
  String get saveFailedRetry => 'فشل حفظ. يرجى محاولة مرة أخرى لاحقا.';

  @override
  String get importFailedCheckContent =>
      'فشل الاستيراد. يرجى التحقق من محتوى الملف.';

  @override
  String get noImportableTimetables =>
      'لم يتم العثور على جداول زمنية قابلة للاستخدام في الملف المستورد.';

  @override
  String importedTimetablesCount(int count) {
    return 'الجداول الزمنية المستوردة $count';
  }

  @override
  String get periodTimesTitle => 'أوقات الفترة';

  @override
  String get importExport => 'الاستيراد والتصدير';

  @override
  String get importPeriodTemplate => 'قالب فترة الاستيراد';

  @override
  String get importPeriodTemplateText => 'استيراد قالب الفترة من النص';

  @override
  String get sharePeriodTemplate => 'قالب فترة الأسهم';

  @override
  String get saveTemplateToFile => 'احفظ القالب في الملف';

  @override
  String get exportPeriodTemplateText => 'قالب فترة التصدير كنص';

  @override
  String get deletePeriodTimeSet => 'حذف الفترة الزمنية المحددة';

  @override
  String get periodTimeSetName => 'اسم المجموعة الزمنية للفترة';

  @override
  String get addOnePeriod => 'إضافة فترة';

  @override
  String periodNumberLabel(int index) {
    return 'فترة $index';
  }

  @override
  String get deleteThisPeriod => 'حذف هذه الفترة';

  @override
  String durationMinutes(int minutes) {
    return 'المدة $minutes دقيقة';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'الفجوة من السابق $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'يجب أن يكون وقت النهاية متأخراً عن وقت البدء';

  @override
  String get periodOverlapPrevious => 'هذه الفترة تتداخل مع الفترة السابقة';

  @override
  String get periodTimesSaved => 'أوقات الفترة المحفوظة';

  @override
  String get deletePeriodTimeSetTitle => 'حذف الفترة الزمنية المحددة';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get currentPeriodTimeSet => 'الوقت المحدد للفترة الحالية';

  @override
  String importedPeriodTimesCount(int count) {
    return 'استيراد $count أوقات الفترة';
  }

  @override
  String get periodFilePermissionTitle => 'الإذن المطلوب للملف';

  @override
  String get androidFilePermissionMessage =>
      'تصدير أندرويد يتطلب إذن الوصول إلى الملفات. منح الإذن لمواصلة الادخار.';

  @override
  String get reauthorize => 'تفويض مرة أخرى';

  @override
  String get permissionPermanentlyDeniedTitle => 'رفض الإذن بشكل دائم';

  @override
  String get permissionSettingsExportMessage =>
      'تمكين الوصول إلى الملفات في إعدادات النظام، ثم العودة ومحاولة التصدير مرة أخرى.';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get privacyPolicyEntryDesc =>
      'تعرّف على كيفية تعامل التطبيق مع التخزين المحلي، وتكوين موقع المدرسة، واستيراد/تصدير الملفات، وتحليل صفحات الويب، والروابط الخارجية.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'النسخة المقبولة: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked هو أداة جداول دراسية محلية أولا. يتم تخزين الجداول ومجموعات الفترات الزمنية وتكوين موقع المدرسة فقط على جهازك أو في متصفحك، ولا يتم تحميلها تلقائيا أبدا. يعالج التطبيق البيانات فقط عند بدء إجراءات صريحة مثل الاستيراد أو تحليل صفحات الويب أو المشاركة أو فتح الروابط الخارجية. سياسة الخصوصية الكاملة متاحة على الإنترنت.';

  @override
  String get privacyPolicyLocalStorageTitle => 'تخزين محلي';

  @override
  String get privacyPolicyLocalStorageBody =>
      'يتم تخزين بيانات الجدول الزمني والإعدادات ذات الصلة في ملف محلي اسمه Sked_data.json داخل دليل وثائق التطبيق. يتم تخزين تكوين موقع المدرسة القابل للتحرير بشكل منفصل في Sked_school_sites.json. يتم تخزين إعدادات تحليل الجدول الزمني المخصصة ، بما في ذلك أي عنوان URL قاعدة مخصص ، ومفتاح واجهة برمجة التطبيقات ، والنموذج المحدد ، أيضًا محليًا في نفس بيانات التطبيق ولا يتم حمايتها بواسطة خزنة اعتمادات النظام. عند استخدامها في متصفح، يتم تخزين نفس أنواع البيانات في تخزين المتصفح. لا يرفع التطبيق هذه البيانات المحلية تلقائياً إلى خادم يسيطر عليه المطور.';

  @override
  String get privacyPolicyImportExportTitle => 'الاستيراد والتصدير';

  @override
  String get privacyPolicyImportExportBody =>
      'يقرأ التطبيق أو يكتب ملفات JSON للجدول الزمني وملفات JSON لموقع المدرسة وملفات قالب الفترة فقط عندما تختار ملفاً صراحةً أو تبدأ إجراءً للتصدير. استيراد هذه الملفات عملية محلية ما لم تختار أيضًا تحليل صفحة الويب. إن جلب قائمة نموذج مخصصة هو أيضا إجراء شبكة صريح ويتصل فقط بنقطة النهاية المخصصة التي قمت بتكوينها.';

  @override
  String get privacyPolicySharingTitle => 'المشاركة';

  @override
  String get privacyPolicySharingBody =>
      'عند استخدام المشاركة صراحة، يمر التطبيق الملف المصدر إلى ورقة مشاركة النظام أو إلى التطبيق المستهدف الذي تختاره. تعتمد طريقة التعامل مع هذا الملف بعد ذلك على التطبيق أو الخدمة المستهدفة التي اخترتها.';

  @override
  String get privacyPolicyExternalLinksTitle => 'روابط خارجية';

  @override
  String get privacyPolicyExternalLinksBody =>
      'عندما تفتح روابط خارجية مثل مخزن GitHub، يسلم التطبيق الإجراء إلى متصفحك أو تطبيق خارجي آخر. تحكم معالجة البيانات بعد هذه النقطة الطرف الثالث الذي تفتحه.';

  @override
  String get privacyPolicyNoCollectionTitle => 'ما الذي لا يجمعه التطبيق';

  @override
  String get privacyPolicyNoCollectionBody =>
      'لا يتطلب التطبيق حساب Sked ولا يتيح التحليلات أو معرفات الإعلانات أو النسخ الاحتياطي السحابي. كما أنه لا يوفر حقلا مخصصا لجمع كلمات مرور حساب المدرسة. إذا قمت بتسجيل الدخول إلى موقع مدرسة داخل التطبيق، فإن هذا التفاعل يحدث على صفحة المدرسة التي فتحتها.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'تحليل صفحة الويب';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'عند استخدام استيراد صفحة ويب مدرسة أو لصق HTML للتحليل، يضغط التطبيق المحتوى أولاً محلياً، ثم يرسل محتوى الصفحة المقدمة، وعنوان الصفحة الاختياري وعنوان URL، ولغة التطبيق الحالية، ومحتوى طلب التحليل إلى نقطة نهاية التحليل المحددة. إذا استخدمت المحلل الرسمي، فإن الطلب يذهب إلى النهاية الخلفية الرسمية المكونة للتطبيق. إذا قمت بتشغيل محلل مخصص متوافق مع OpenAI، يتم إرسال نفس المحتوى مباشرة إلى نقطة نهاية الطرف الثالث التي قمت بتكوينها، ويطلب الحصول على قائمة النماذج أيضًا نفس نقطة النهاية. قد ترسل نقطة نهاية مخصصة الطلب إلى خدمات الذكاء الاصطناعي الأخرى وفقًا للتصميم الخاص بهذا المزود. يحد النهاية الخلفية الرسمية المنتشرة حاليًا من كل حمولة مفيدة مقدمة إلى 300 كيلوبايت ، ويستخدم توقيت انتهاء التكوين ، ويسمح بأكثر من 5 طلبات تحليل لكل IP يوميًا.';

  @override
  String get privacyPolicyUpdatesTitle => 'تحديثات السياسة';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'الإصدار الحالي لسياسة الخصوصية هو $version. إذا تغير إصدار لاحق طريقة التعامل مع البيانات، قد يطلب منك التطبيق قراءة السياسة المحدثة والموافقة عليها مرة أخرى.';
  }

  @override
  String get privacyGateTitle =>
      'يرجى الموافقة على سياسة الخصوصية قبل استخدام التطبيق';

  @override
  String get privacyGateSummaryStorage =>
      'يتم تخزين الجداول الزمنية ومجموعات الفترة الزمنية وتكوين موقع المدرسة محليًا فقط ولا يتم تحميلها تلقائيًا إلى خادم المطور.';

  @override
  String get privacyGateSummaryImportExport =>
      'يتم استيراد وتصدير ومشاركة فقط عندما تبدأ بشكل صريح. يرسل تحليل صفحة الويب فقط المحتوى المضغوط الذي ترسله إلى نقطة نهاية التحليل المكونة الخاصة بك، ويمكنك مراجعة الجدول الزمني المحلل قبل حفظه.';

  @override
  String get privacyGateSummaryUpdates =>
      'إذا تغير إصدار لاحق طريقة التعامل مع البيانات، قد يطلب منك التطبيق مراجعة سياسة الخصوصية المحدثة مرة أخرى.';

  @override
  String get schoolWebImportEntry => 'استيراد من صفحة المدرسة';

  @override
  String get schoolWebImportEntryDesc =>
      'استيراد صفحة الجدول الزمني الحالي من موقع المدرسة.';

  @override
  String get schoolSitesManageEntry => 'إدارة مواقع المدارس';

  @override
  String get schoolSitesManageEntryDesc =>
      'إضافة وتحرير وحذف عناوين URL تسجيل الدخول للمدرسة، مع استيراد وتصدير JSON.';

  @override
  String get schoolSitesPageTitle => 'إدارة موقع المدرسة';

  @override
  String get schoolSitesImportJson => 'استيراد مدرسة JSON';

  @override
  String get schoolSitesShareJson => 'شارك مدرسة JSON';

  @override
  String get schoolSitesSaveJson => 'حفظ المدرسة JSON';

  @override
  String get schoolSitesSaved => 'مواقع المدارس المحفوظة';

  @override
  String get schoolSitesImported => 'مواقع المدارس المستوردة';

  @override
  String get schoolSitesEmpty => 'لا يوجد تكوين موقع مدرسة بعد.';

  @override
  String get schoolSitesNameLabel => 'اسم المدرسة';

  @override
  String get schoolSitesLoginUrlLabel => 'عنوان الدخول';

  @override
  String get schoolSitesAdd => 'إضافة مدرسة';

  @override
  String get schoolSitesEdit => 'تعديل المدرسة';

  @override
  String get schoolSitesDeleteTitle => 'حذف المدرسة';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get schoolSitesFormInvalid => 'املأ اسم المدرسة و عنوان الدخول أولاً.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'استيراد عن طريق لصق محتوى صفحة الجدول الزمني';

  @override
  String get schoolHtmlImportEntryDesc =>
      'لصق رمز المصدر أو محتوى الصفحة الخام الذي يحتوي على معلومات الجدول الزمني يدويا.';

  @override
  String get schoolHtmlImportPageTitle => 'تحليل الجدول الزمني من محتوى الصفحة';

  @override
  String get schoolHtmlImportUrlLabel => 'عنوان المصدر (اختياري)';

  @override
  String get schoolHtmlImportTitleLabel => 'عنوان الصفحة (اختياري)';

  @override
  String get schoolHtmlImportHtmlLabel => 'محتوى الصفحة';

  @override
  String get schoolHtmlImportHtmlHint =>
      'لصق رمز المصدر أو محتوى الصفحة الخام الذي يحتوي على معلومات الجدول الزمني هنا.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'يمكن تحليل واستيراد أي محتوى يحتوي على معلومات الجدول الزمني ، وليس فقط HTML.';

  @override
  String get schoolHtmlImportCompress => 'ضغط المحتوى';

  @override
  String get schoolHtmlImportCompressed => 'محتوى مضغوط';

  @override
  String get schoolHtmlImportCompressFirst => 'ضغط المحتوى أولاً.';

  @override
  String get schoolHtmlImportSubmit => 'تحليل واستيراد';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'تحليل قد يستغرق بعض الوقت. أرجوك انتظر';

  @override
  String get schoolHtmlImportEmpty => 'لصق الصفحة HTML أولاً.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'ارجع لصفحة الويب';

  @override
  String get schoolWebImportPageTitle => 'استيراد صفحة ويب المدرسة';

  @override
  String get schoolWebImportPreview => 'استيراد المعاينة';

  @override
  String schoolWebImportCourseCount(int count) {
    return ' $count دورات';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count فترات';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'عنوان الصفحة';

  @override
  String get schoolWebImportParserUsed => 'تحليل';

  @override
  String get schoolWebImportWarnings => 'استيراد الملاحظات';

  @override
  String get schoolWebImportOpenPageHint =>
      'تسجيل الدخول إلى موقع المدرسة داخل التطبيق، ثم تنقل إلى صفحة الجدول الزمني يدويًا.';

  @override
  String get schoolWebImportConfigMissing =>
      'لم يتم تكوين واجهة برمجة التطبيقات الخلفية لاستيراد الويب بعد.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'هذه المنصة لا تدعم تسجيل الدخول على الويب المدمج بعد. يرجى استخدام منصة مع دعم WebView.';

  @override
  String get schoolWebImportSelectSchool => 'اختر المدرسة';

  @override
  String get schoolWebImportNoSchools =>
      'لا يوجد تكوين مدرسة متاح. تحقق من school_sites.json أولاً.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'فشل في تحميل تكوين المدرسة. تحقق من تنسيق ملف JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'استيراد الصفحة الحالية';

  @override
  String get schoolWebImportGoBack => 'الصفحة السابقة';

  @override
  String get schoolWebImportLoadingPage => 'تحميل الصفحة…';

  @override
  String get schoolWebImportParsing => 'تحليل الصفحة الحالية...';

  @override
  String get schoolWebImportLoadFailed =>
      'فشل تحميل الصفحة. يرجى تحديث أو محاولة مرة أخرى في وقت لاحق.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'انتهى وقت تحميل الصفحة. يرجى تحديث ومحاولة مرة أخرى.';

  @override
  String get schoolWebImportEmptyPage =>
      'محتوى الصفحة الحالية فارغ ولا يمكن استيراده بعد.';

  @override
  String get schoolWebImportSuccess => 'الجدول الزمني للويب المستورد';

  @override
  String get schoolImportParserSettingsTitle => 'إعدادات تحليل الجدول الزمني';

  @override
  String get schoolImportParserSettingsDesc =>
      'اختر المحلل الرسمي أو نقطة نهاية مخصصة متوافقة مع OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'مصدر المحلل';

  @override
  String get schoolImportParserSourceOfficial => 'المحلل الرسمي';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'استخدم خدمة التحليل الرسمية المدمجة التي تكوينها التطبيق.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'يستخدم المحلل الرسمي واجهة التحليل الخلفية المكونة للتطبيق ويحافظ على تدفق الاستيراد الحالي دون تغيير.';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'مخصص OpenAI متوافق';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'ارسل محتوى الصفحة مباشرة إلى نقطة النهاية الخاصة بك المتوافقة مع OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi => 'تحليل متوافق مع OpenAI مخصص';

  @override
  String get schoolImportParserCustomPromptTitle => 'طلب مخصص';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'عدل الدعوة المحلل المدمجة هنا. التغييرات تؤثر فقط على المحلل المخصص المتوافق مع OpenAI.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'يتم تحميل الدعوة المدمجة هنا بشكل افتراضي. قم بإزالته لتعود إلى الإصدار المدمج.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'إعادة تعيين الدعوة الافتراضية';

  @override
  String get schoolImportParserBaseUrl => 'عنوان العنوان الأساسي';

  @override
  String get schoolImportParserApiKey => 'مفتاح API';

  @override
  String get schoolImportParserModel => 'نموذج';

  @override
  String get schoolImportParserFetchModels => 'احصل على قائمة النماذج';

  @override
  String get schoolImportParserFetchingModels => 'جلب نماذج. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'لم يتم إرجاع أي نماذج من قبل نقطة النهاية.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'تم الحصول على نماذج $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'يتم تخزين مفتاح واجهة برمجة التطبيقات المخصصة في الإعدادات المحلية للتطبيق في النص العادي تحت التنفيذ الحالي. استخدمه فقط على جهاز أو بيئة متصفح تثق بها.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'تكوين المحلل المخصص غير كامل. املأ عنوان العنوان الأساسي ومفتاح واجهة برمجة التطبيقات والنموذج أولاً.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'تحليل: رسمي';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'تحليل: مخصص ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'عرض سياسة الخصوصية الكاملة';

  @override
  String get privacyAgreeAndContinue => 'موافقة ومواصلة';

  @override
  String get privacyDecline => 'رفض';

  @override
  String get privacyDeclineWebHint =>
      'بيئة المتصفح هذه لا تسمح للتطبيق بإغلاق الصفحة لك. إذا كنت لا توافق، يرجى إغلاق هذا التبويب أو النافذة بنفسك.';

  @override
  String get defaultPeriodTimeSetName => 'الفترات الافتراضية';

  @override
  String get periodTimeSetFallbackName => 'أوقات الفترة';

  @override
  String get untitledTimetableName => 'الجدول الزمني غير المعنون';

  @override
  String get newTimetableName => 'جدول جديد';

  @override
  String get newPeriodTimeSetName => 'تحديد فترة جديدة';

  @override
  String get emptyTimetableName => 'جدول زمني فارغ';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name فترات';
  }

  @override
  String get importFileTypeMismatchMessage => 'نوع الملف المستورد لا يتطابق.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'هذا الإصدار من ملف الاستيراد غير مدعوم بعد.';

  @override
  String get noPeriodTimesInImportMessage =>
      'لم يتم العثور على أوقات فترة في ملف الاستيراد.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'يرجى اختيار جدول زمني واحد على الأقل.';

  @override
  String get noExportableTimetableMessage => 'لا يوجد جدول زمني متاح للتصدير.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'استبدال الجدول الزمني الحالي يدعم اختيار جدول زمني واحد فقط.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'لا يوجد جدول زمني للاستبدال.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'لا تزال هذه المجموعة الزمنية تستخدم في الجدول الزمني $count. إعادة تعيينها قبل حذفها.';
  }

  @override
  String get weekdayMonday => 'الاثنين';

  @override
  String get weekdayTuesday => 'الثلاثاء';

  @override
  String get weekdayWednesday => 'الأربعاء';

  @override
  String get weekdayThursday => 'الخميس';

  @override
  String get weekdayFriday => 'الجمعة';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String get weekdayShortMonday => 'الاثنين';

  @override
  String get weekdayShortTuesday => 'الثلاثاء';

  @override
  String get weekdayShortWednesday => 'الأربعاء';

  @override
  String get weekdayShortThursday => 'الخميس';

  @override
  String get weekdayShortFriday => 'الجمعة';

  @override
  String get weekdayShortSaturday => 'السبت';

  @override
  String get weekdayShortSunday => 'الشمس';

  @override
  String get monthJanuary => 'يناير';

  @override
  String get monthFebruary => 'فبراير';

  @override
  String get monthMarch => 'مارس';

  @override
  String get monthApril => 'أبريل';

  @override
  String get monthMay => 'مايو';

  @override
  String get monthJune => 'يونيو';

  @override
  String get monthJuly => 'يوليو';

  @override
  String get monthAugust => 'أغسطس';

  @override
  String get monthSeptember => 'سبتمبر';

  @override
  String get monthOctober => 'أكتوبر';

  @override
  String get monthNovember => 'نوفمبر';

  @override
  String get monthDecember => 'ديسمبر';

  @override
  String get semesterWeeksWholeTerm => 'كل الفصل الدراسي';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'أسابيع $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'أسابيع $value';
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
