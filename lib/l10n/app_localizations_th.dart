// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'เพื่อนร่วมเรียน';

  @override
  String weekLabel(int week) {
    return 'สัปดาห์ $week';
  }

  @override
  String get addCourse => 'เพิ่มหลักสูตร';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get multiTimetableSwitch => 'เปลี่ยนตารางเวลา';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'ตารางเวลาปัจจุบัน · $weeks สัปดาห์';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'แตะเพื่อสวิตช์ · $weeks สัปดาห์';
  }

  @override
  String get editTimetable => 'แก้ไขตารางเวลา';

  @override
  String get createTimetable => 'ตารางเวลาใหม่';

  @override
  String get jumpToWeek => 'กระโดดไปสัปดาห์';

  @override
  String get timetable => 'ตารางเวลา';

  @override
  String get timetableName => 'ชื่อตารางเวลา';

  @override
  String get totalWeeks => 'สัปดาห์ทั้งหมด';

  @override
  String get delete => 'ลบ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get deleteTimetableTitle => 'ลบตารางเวลา';

  @override
  String deleteTimetableMessage(Object name) {
    return 'ลบ \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'ยังไม่มีตารางเวลา';

  @override
  String get noTimetableMessage => 'สร้างตารางเวลาหรือนําเข้าจากไฟล์ JSON';

  @override
  String get importTimetable => 'ตารางเวลานําเข้า';

  @override
  String get courseName => 'ชื่อหลักสูตร';

  @override
  String get location => 'สถานที่ตั้ง';

  @override
  String get dayOfWeek => 'วัน';

  @override
  String get semesterWeeks => 'สัปดาห์';

  @override
  String get startTime => 'เวลาเริ่มต้น';

  @override
  String get endTime => 'เวลาสิ้นสุด';

  @override
  String get linkedPeriods => 'ระยะเวลาที่เชื่อมโยง';

  @override
  String get linkedPeriodsUnmatched =>
      'ไม่มีระยะเวลาที่ตรงกับสําหรับเวลาปัจจุบัน แตะเพื่อเลือกด้วยมือ';

  @override
  String periodRangeLabel(int start, int end) {
    return 'ระยะเวลา $start-$end';
  }

  @override
  String get teacherName => 'อาจารย์';

  @override
  String get credits => 'เครดิต';

  @override
  String get remarks => 'ข้อความ';

  @override
  String get customFields => 'ฟิลด์ที่กำหนดเอง';

  @override
  String get customFieldsHint => 'หนึ่งต่อเส้นรูปแบบ: คีย์: ค่า';

  @override
  String get selectDayOfWeek => 'เลือกวัน';

  @override
  String get selectSemesterWeeks => 'เลือกสัปดาห์';

  @override
  String get selectAll => 'เลือกทั้งหมด';

  @override
  String get clear => 'ล้าง';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get selectLinkedPeriods => 'เลือกระยะเวลาที่เชื่อมโยง';

  @override
  String get addCourseTitle => 'เพิ่มหลักสูตร';

  @override
  String get editCourseTitle => 'แก้ไขหลักสูตร';

  @override
  String get editCourseTooltip => 'แก้ไขหลักสูตร';

  @override
  String get place => 'สถานที่ตั้ง';

  @override
  String get time => 'เวลา';

  @override
  String get notFilled => 'ไม่เติม';

  @override
  String get none => 'ไม่มี';

  @override
  String get conflictCourses => 'หลักสูตรที่ขัดแย้ง';

  @override
  String get locationNotFilled => 'สถานที่ไม่เติม';

  @override
  String get setAsDisplayed => 'ตั้งตามที่แสดง';

  @override
  String get editThisCourse => 'แก้ไขหลักสูตรนี้';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get noTimetableSettings => 'ปัจจุบันไม่มีตารางเวลาสำหรับการตั้งค่า';

  @override
  String get semesterStartDate => 'วันเริ่มต้นภาคศึกษา';

  @override
  String get periodTimeSets => 'ระยะเวลาที่กำหนดไว้';

  @override
  String get noPeriodTimeAvailable => 'ไม่มีเวลาที่กำหนดไว้';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count ระยะเวลา';
  }

  @override
  String get coursePopupDismissSetting =>
      'อนุญาตให้แตะด้านนอกเพื่อปิดป๊อปอัปหลักสูตร';

  @override
  String get coursePopupDismissSettingHint =>
      'การปิดนี้ยังปิดการเลื่อนการไล่ลง';

  @override
  String get preserveTimetableGaps => 'รักษาช่องว่างของตารางเวลา';

  @override
  String get preserveTimetableGapsHint =>
      'เมื่อหยุด ช่องว่างอาหารกลางวันและช่องว่างจะล้มลง ดังนั้นเรียนในภายหลังจะย้ายขึ้น';

  @override
  String get showPastEndedCourses => 'แสดงหลักสูตรที่สิ้นสุดในอดีต';

  @override
  String get showPastEndedCoursesHint =>
      'แสดงหลักสูตรที่เสร็จสิ้นแล้วในสัปดาห์ปัจจุบันจริงด้วยสไตล์สีเทาอ่อน';

  @override
  String get showFutureCourses => 'แสดงหลักสูตรในอนาคต';

  @override
  String get showFutureCoursesHint =>
      'แสดงหลักสูตรที่ไม่ได้ใช้งานในสัปดาห์นี้ แต่จะปรากฏในสัปดาห์ต่อมา ด้วยรูปแบบสีเทา';

  @override
  String get timetableDisplaySettings => 'การแสดงตารางและการปฏิสัมพันธ์';

  @override
  String get timetableDisplaySettingsDesc =>
      'การยกเลิกป๊อปอัป, ช่องว่าง, หลักสูตรสีเทา, และบรรทัดตาราง';

  @override
  String get showTimetableGridLines => 'แสดงเส้นทางตารางเวลา';

  @override
  String get showTimetableGridLinesHint =>
      'ควบคุมว่าเส้นทางตารางแนวนอนและแนวตั้งเห็นได้หรือไม่ในตารางเวลา';

  @override
  String get liveCourseOutlineColor => 'สีโครงสร้างหลักสูตร';

  @override
  String get liveCourseOutlineColorHint =>
      'เลือกว่าโครงสร้างเป้าหมายหลักสูตรปัจจุบัน/ต่อไป หรือหลักสูตรทั้งหมดที่แสดงบนหน้าปัจจุบัน';

  @override
  String get liveCourseOutlineSettings => 'รายละเอียดหลักสูตร';

  @override
  String get liveCourseOutlineSettingsHint =>
      'กำหนดค่าถูกเปิดใช้รูปร่างหรือไม่, มันเป้าหมายอะไร, มันติดตามสีหัวข้อ, และสีรูปร่างที่มีประสิทธิภาพหรือไม่.';

  @override
  String get liveCourseOutlineEnabled => 'เปิดใช้งานรูปร่าง';

  @override
  String get liveCourseOutlineFollowTheme => 'ตามสีธีม';

  @override
  String get liveCourseOutlineTarget => 'เป้าหมายร่าง';

  @override
  String get liveCourseOutlineTargetCurrentOrNext =>
      'หลักสูตรปัจจุบัน/หลักสูตรต่อไป';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'หลักสูตรที่แสดงทั้งหมด';

  @override
  String get liveCourseOutlineEffectiveColor => 'สีที่มีประสิทธิภาพ';

  @override
  String get liveCourseOutlineCustomColor => 'สีร่างกายที่กำหนดเอง';

  @override
  String get liveCourseOutlineWidth => 'ความกว้างของรูปร่าง';

  @override
  String get outlineWidthUnit => 'พิกซ์';

  @override
  String get language => 'ภาษา';

  @override
  String get languagePageDescription => 'เลือกหนึ่งในภาษาที่มีอยู่ในแอพจริง ๆ';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'ภาษาไทย';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'การตอบสนอง API';

  @override
  String get theme => 'ธีม';

  @override
  String get themeFollowSystem => 'ติดตามระบบ';

  @override
  String get themeLight => 'แสง';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeColor => 'สีธีม';

  @override
  String get themeColorModeSingle => 'สีธีมเดียว';

  @override
  String get themeColorModeColorful => 'สีสัน';

  @override
  String get themeColorUiColors => 'สี UI';

  @override
  String get themeColorCourseColors => 'สีหลักสูตร';

  @override
  String get themeColorPrimary => 'หลักสูตร';

  @override
  String get themeColorSecondary => 'มัธยม';

  @override
  String get themeColorTertiary => 'ระดับสูง';

  @override
  String get themeColorCourseText => 'ข้อความหลักสูตร';

  @override
  String get themeColorCourseTextAuto => 'อัตโนมัติ';

  @override
  String get themeColorCourseTextCustom => 'สีที่กำหนดเอง';

  @override
  String get themeColorCourseColorsEmpty =>
      'สีหลักสูตรจะถูกสร้างขึ้นหลังจากนำเข้าตลาดเวลา';

  @override
  String get themeCustomColor => 'สีที่กำหนดเอง';

  @override
  String get themeApplyCustomColor => 'ใช้สี';

  @override
  String get themeApplySettings => 'ใช้การตั้งค่า';

  @override
  String get dataImportExport => 'ข้อมูลนำเข้าและส่งออก';

  @override
  String get dataImportExportDesc =>
      'นำเข้าข้อมูลเต็มหรือตารางเวลาเดียว หรือส่งออกตารางเวลาปัจจุบัน/ทั้งหมด';

  @override
  String get openSourceLicenses => 'ใบอนุญาตแหล่งเปิด';

  @override
  String get openSourceLicensesDesc =>
      'ดูใบอนุญาตสําหรับการพึ่งพา Flutter และทรัพย์สินไอคอนแอพที่รวม';

  @override
  String get checkForUpdates => 'ตรวจสอบการอัพเดท';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / เว็บไซต์อย่างเป็นทางการ / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'อยู่ในรุ่นล่าสุดแล้ว ($version)';
  }

  @override
  String get currentVersionLabel => 'รุ่นปัจจุบัน';

  @override
  String get newVersionAvailable => 'มีการอัพเดท';

  @override
  String get latestVersionLabel => 'เวอร์ชันล่าสุด';

  @override
  String get updateContentLabel => 'อัพเดทรายละเอียด';

  @override
  String get officialWebsite => 'เว็บไซต์อย่างเป็นทางการ';

  @override
  String get googlePlay => 'Google เล่น';

  @override
  String get cloudDrive => 'ไดรฟ์คลาวด์';

  @override
  String get ignoreThisVersion => 'ไม่สนใจรุ่นนี้';

  @override
  String get openUpdatesFailed => 'ไม่สามารถเปิดลิงค์การปรับปรุงได้';

  @override
  String get updateCheckFailedTitle => 'การตรวจสอบการอัพเดทล้มเหลว';

  @override
  String get updateCheckFailedMessage =>
      'ไม่สามารถรับข้อมูลอัพเดทที่ถูกต้องจากแหล่งอัพเดทใด ๆ ได้ คุณยังสามารถใช้ลิงค์ด้านล่างเพื่ออัพเดทด้วยมือ';

  @override
  String get githubRepository => 'เก็บข้อมูล GitHub';

  @override
  String get openGithubFailed => 'ไม่สามารถเปิดลิงค์คลังข้อมูล GitHub ได้';

  @override
  String get selectPeriodTimeSet => 'เลือกช่วงเวลา';

  @override
  String get newItem => 'ใหม่';

  @override
  String get editPeriodTimeSet => 'แก้ไขช่วงเวลา';

  @override
  String get importTimetableFiles => 'ตารางเวลานําเข้า';

  @override
  String get importTimetableFilesDesc => 'รองรับไฟล์ตารางเวลาหนึ่งหรือหลายไฟล์';

  @override
  String get importTimetableText => 'นำเข้าตารางเวลาจากข้อความ';

  @override
  String get importTimetableTextDesc => 'วางเนื้อหา JSON ตารางเวลาและนำเข้ามัน';

  @override
  String get shareTimetableFiles => 'แบ่งปันไฟล์ตารางเวลา';

  @override
  String get shareTimetableFilesDesc => 'เลือกตารางเวลาหนึ่งหรือมากกว่าก่อน';

  @override
  String get saveTimetableFiles => 'บันทึกไฟล์ตารางเวลา';

  @override
  String get saveTimetableFilesDesc => 'เลือกตารางเวลาหนึ่งหรือมากกว่าก่อน';

  @override
  String get exportTimetableText => 'ส่งออกตารางเวลาเป็นข้อความ';

  @override
  String get exportTimetableTextDesc =>
      'เลือกตารางเวลาหนึ่งหรือมากกว่า จากนั้นคัดลอกเนื้อหา JSON';

  @override
  String get jsonContent => 'เนื้อหา JSON';

  @override
  String get pasteJsonContentHint => 'วางเนื้อหา JSON เพื่อนําเข้า';

  @override
  String get jsonContentEmpty => 'วางเนื้อหา JSON ก่อน';

  @override
  String get copyText => 'คัดลอก';

  @override
  String get copiedToClipboard => 'คัดลอกไปยังคลิปบอร์ด';

  @override
  String get share => 'แบ่งปัน';

  @override
  String get selectTimetablesToExport => 'เลือกตารางเวลาที่จะส่งออก';

  @override
  String get selectTimetablesToImport => 'เลือกตารางเวลาที่จะนำเข้า';

  @override
  String timetableCourseCount(int count) {
    return '$count หลักสูตร';
  }

  @override
  String get importAction => 'นำเข้า';

  @override
  String get importTimetableDialogTitle => 'ตารางเวลานําเข้า';

  @override
  String get chooseImportMethod => 'เลือกวิธีการนำเข้า';

  @override
  String get importAsNewTimetable => 'นำเข้าเป็นตารางเวลาใหม่';

  @override
  String get replaceCurrentTimetable => 'เปลี่ยนตารางเวลาปัจจุบัน';

  @override
  String get importPeriodTimeSetDialogTitle => 'ชุดเวลาในระยะเวลานําเข้า';

  @override
  String get importPeriodTimeSetDialogBody =>
      'ไฟล์นี้มีชุดเวลาระยะเวลาที่รวม คุณต้องการนำเข้าและเชื่อมโยงมันหรือไม่?';

  @override
  String get importBundledPeriodTimeSets => 'นำเข้าและเกี่ยวข้อง';

  @override
  String get discardBundledPeriodTimeSets => 'ทิ้งชุดที่รวม';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'ไม่มีชุดเวลาช่วงเวลาที่มีอยู่ ดังนั้นชุดเวลาช่วงเวลาที่รวมกันไม่สามารถทิ้งได้';

  @override
  String savedToPath(Object path) {
    return 'บันทึกเป็น $path';
  }

  @override
  String get saveCancelled => 'บันทึกถูกยกเลิก';

  @override
  String get fileSaveRestrictedTitle => 'การบันทึกไฟล์ จำกัด';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'ระบบไม่สามารถบันทึกไฟล์ได้ คุณสามารถลองใหม่หรือใช้การแบ่งปันแทน';

  @override
  String get retrySave => 'พยายามบันทึกอีกครั้ง';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'เปิดใช้งานการเข้าถึงไฟล์ในการตั้งค่าระบบ จากนั้นกลับมาและลองส่งออกอีกครั้ง';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get browserDownloadRestrictedTitle =>
      'การดาวน์โหลดเบราว์เซอร์ถูกจํากัด';

  @override
  String get browserDownloadRestrictedMessage =>
      'เบราว์เซอร์นี้ไม่รองรับการบันทึกโดยตรงไปยังไฟล์ท้องถิ่น ตรวจสอบอนุญาตการดาวน์โหลดเบราว์เซอร์ หรือใช้แชร์ไฟล์แทน';

  @override
  String get switchToShare => 'ใช้แชร์แทน';

  @override
  String get fileSaveFailedTitle => 'บันทึกไฟล์ล้มเหลว';

  @override
  String get fileSaveFailedWindowsMessage =>
      'ไม่สามารถเขียนไปยังเส้นทางปัจจุบันได้ โฟลเดอร์เป้าหมายอาจถูกปกป้อง ไฟล์อาจถูกใช้ หรือเส้นทางอาจไม่สามารถเขียนได้';

  @override
  String get fileSaveFailedGenericMessage =>
      'ระบบไม่สามารถบันทึกไฟล์ได้ คุณสามารถลองอีกครั้ง ตรวจสอบการตั้งค่าระบบ หรือใช้การแบ่งปันไฟล์แทน';

  @override
  String get retryLater => 'ลองอีกครั้งต่อมา';

  @override
  String get exportSwitchedToShare => 'เปลี่ยนไปใช้แบ่งปันไฟล์เพื่อส่งออก';

  @override
  String get saveFailedRetry => 'บันทึกล้มเหลว กรุณาลองอีกครั้งในภายหลัง';

  @override
  String get importFailedCheckContent =>
      'การนำเข้าล้มเหลว กรุณาตรวจสอบเนื้อหาไฟล์';

  @override
  String get noImportableTimetables => 'ไม่พบตารางเวลาที่ใช้ได้ในไฟล์ที่นำเข้า';

  @override
  String importedTimetablesCount(int count) {
    return 'การนำเข้า $count ตารางเวลา';
  }

  @override
  String get periodTimesTitle => 'ระยะเวลา';

  @override
  String get importExport => 'นำเข้าและส่งออก';

  @override
  String get importPeriodTemplate => 'แม่แบบระยะเวลานําเข้า';

  @override
  String get importPeriodTemplateText => 'นำเข้าเทมเพลตช่วงเวลาจากข้อความ';

  @override
  String get sharePeriodTemplate => 'แม่แบบระยะเวลาแบ่งปัน';

  @override
  String get saveTemplateToFile => 'บันทึกเทมเพลตเป็นไฟล์';

  @override
  String get exportPeriodTemplateText => 'ส่งออกแม่แบบระยะเวลาเป็นข้อความ';

  @override
  String get deletePeriodTimeSet => 'ลบช่วงเวลาที่กำหนดไว้';

  @override
  String get periodTimeSetName => 'ชื่อช่วงเวลา';

  @override
  String get addOnePeriod => 'เพิ่มระยะเวลา';

  @override
  String periodNumberLabel(int index) {
    return 'ระยะเวลา $index';
  }

  @override
  String get deleteThisPeriod => 'ลบระยะเวลานี้';

  @override
  String durationMinutes(int minutes) {
    return 'ระยะเวลา $minutes นาที';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'ช่องว่างจากก่อนหน้านี้ $minutes นาที';
  }

  @override
  String get endTimeMustBeLater => 'เวลาสิ้นสุดต้องช้ากว่าเวลาเริ่มต้น';

  @override
  String get periodOverlapPrevious => 'ช่วงเวลานี้ซ้อนกับช่วงเวลาก่อนหน้านี้';

  @override
  String get periodTimesSaved => 'เวลาระยะเวลาที่บันทึก';

  @override
  String get deletePeriodTimeSetTitle => 'ลบช่วงเวลาที่กำหนดไว้';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'ลบ \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'ช่วงเวลาปัจจุบัน';

  @override
  String importedPeriodTimesCount(int count) {
    return 'นำเข้า $count เวลาระยะเวลา';
  }

  @override
  String get periodFilePermissionTitle => 'จำเป็นต้องได้รับอนุญาตไฟล์';

  @override
  String get androidFilePermissionMessage =>
      'การส่งออก Android ต้องได้รับอนุญาตเข้าถึงไฟล์ ให้อนุญาตในการบันทึกต่อ';

  @override
  String get reauthorize => 'อนุญาตอีกครั้ง';

  @override
  String get permissionPermanentlyDeniedTitle => 'อนุญาตถูกปฏิเสธอย่างถาวร';

  @override
  String get permissionSettingsExportMessage =>
      'เปิดใช้งานการเข้าถึงไฟล์ในการตั้งค่าระบบ จากนั้นกลับมาและลองส่งออกอีกครั้ง';

  @override
  String get privacyPolicyTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String get privacyPolicyEntryDesc =>
      'เรียนรู้วิธีการที่แอพจัดการกับการจัดเก็บข้อมูลในท้องถิ่น การตั้งค่าเว็บไซต์โรงเรียน การนําเข้า / ส่งออกไฟล์ การวิเคราะห์หน้าเ';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'รุ่นที่ยอมรับ: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked เป็นเครื่องมือตารางเรียนที่เน้นการทำงานในเครื่องเป็นหลัก ตารางเรียน ชุดเวลา และการกำหนดค่าเว็บไซต์โรงเรียนจะถูกเก็บไว้ในอุปกรณ์หรือเบราว์เซอร์ของคุณเท่านั้น และไม่เคยถูกอัปโหลดโดยอัตโนมัติ แอปจะประมวลผลข้อมูลเฉพาะเมื่อคุณเรียกใช้การกระทำอย่างชัดเจน เช่น การนำเข้า การวิเคราะห์หน้าเว็บ การแชร์ หรือการเปิดลิงก์ภายนอก นโยบายความเป็นส่วนตัวฉบับเต็มมีให้ดูทางออนไลน์';

  @override
  String get privacyPolicyLocalStorageTitle => 'การเก็บข้อมูลในท้องถิ่น';

  @override
  String get privacyPolicyLocalStorageBody =>
      'ข้อมูลตารางและการตั้งค่าที่เกี่ยวข้องจะถูกเก็บไว้ในไฟล์ท้องถิ่นที่ชื่อ Sked_data.json ภายในไดเรคเตอรี่เอกสารแอป การตั้งค่าเว็บไซต์โรงเรียนที่แก้ไขได้ถูกเก็บไว้แยกต่างหากใน Sked_school_sites.json การตั้งค่าเครื่องวิเคราะห์ตารางเวลาที่กำหนดเอง รวมถึง URL ฐาน, คีย์ API และรุ่นที่เลือกที่กำหนดเอง ยังจะถูกเก็บไว้ในท้องถิ่นในข้อมูลแอพเดียวกันและไม่ได้รับการค เมื่อใช้ในเบราว์เซอร์ ข้อมูลประเภทเดียวกันจะถูกเก็บไว้ในที่เก็บเบราว์เซอร์ แอพไม่อัพโหลดข้อมูลท้องถิ่นนี้ไปยังเซิร์ฟเวอร์ที่ควบคุมโดยนักพัฒนาโดยอัตโนมัติ';

  @override
  String get privacyPolicyImportExportTitle => 'นำเข้าและส่งออก';

  @override
  String get privacyPolicyImportExportBody =>
      'แอพอ่านหรือเขียนไฟล์ JSON ตารางเวลา ไฟล์ JSON ของเว็บไซต์โรงเรียน และไฟล์แม่แบบระยะเวลาเท่านั้นเมื่อคุณเลือกไฟล์หรือเริ่มการส่งออกอย่างชัดเจน การนำเข้าไฟล์เหล่านี้เป็นการดำเนินการในท้องถิ่น เว้นแต่คุณยังเลือกการวิเคราะห์หน้าเว็บ การรับรายชื่อแบบจำลองที่กำหนดเองยังเป็นการกระทําเครือข่ายที่ชัดเจน และติดต่อเพียงจุดสิ้นสุดที่กำหนดเองที่คุณกำหนดค่า';

  @override
  String get privacyPolicySharingTitle => 'การแบ่งปัน';

  @override
  String get privacyPolicySharingBody =>
      'เมื่อคุณใช้การแบ่งปันอย่างชัดเจน แอพจะส่งไฟล์ที่ส่งออกไปยังแผ่นแบ่งปันระบบหรือไปยังแอพเป้าหมายที่คุณเลือก วิธีการจัดการไฟล์นั้นหลังจากนั้นขึ้นอยู่กับแอพหรือบริการเป้าหมายที่คุณเลือก';

  @override
  String get privacyPolicyExternalLinksTitle => 'ลิงค์ภายนอก';

  @override
  String get privacyPolicyExternalLinksBody =>
      'เมื่อคุณเปิดลิงค์ภายนอก เช่น GitHub repository แอพจะส่งการกระทําไปยังเบราว์เซอร์ของคุณหรือแอพพลิเคชันภายนอกอื่น การจัดการข้อมูลหลังจากจุดนั้นจะถูกควบคุมโดยบุคคลที่สามที่คุณเปิด';

  @override
  String get privacyPolicyNoCollectionTitle => 'สิ่งที่แอพไม่รวบรวม';

  @override
  String get privacyPolicyNoCollectionBody =>
      'แอพไม่ต้องใช้บัญชี Sked และไม่เปิดใช้งานการวิเคราะห์ ตัวระบุการโฆษณา หรือการสำรองข้อมูลในเมฆ นอกจากนี้ยังไม่ให้สนามที่เฉพาะสำหรับการเก็บรวบรหัสผ่านบัญชีโรงเรียน ถ้าคุณเข้าสู่เว็บไซต์โรงเรียนภายในแอป การปฏิสัมพันธ์นั้นเกิดขึ้นในหน้าโรงเรียนที่คุณเปิด';

  @override
  String get privacyPolicyFutureFeatureTitle => 'การวิเคราะห์หน้าเว็บ';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'เมื่อคุณใช้เว็บไซต์โรงเรียนนำเข้าหรือวาง HTML เพื่อการวิเคราะห์ แอพก่อนจะบีบอัดเนื้อหาในท้องถิ่น จากนั้นส่งเนื้อหาหน้าที่ส่ง ชื่อหน้าและ URL ที่เลือก ภาษาแอพปัจจุบัน และเนื้อ ถ้าคุณใช้เครื่องวิเคราะห์อย่างเป็นทางการ คำขอจะไปยังแอพที่กำหนดค่าอย่างเป็นทางการ ถ้าคุณเปิดใช้งานเครื่องวิเคราะห์ที่เข้ากันได้กับ OpenAI ที่กำหนดเอง เนื้อหาเดียวกันจะถูกส่งไปยังจุดท้ายของบุคคลที่สามที่คุณกำหนดค่า และการเรี จุดท้ายที่กำหนดเองอาจส่งคำขอไปยังบริการ AI อื่น ๆ ตามการออกแบบของผู้ให้บริการนั้นเอง ปัจจุบัน backend ที่ใช้อย่างเป็นทางการ จํากัด payload ที่ส่งไปแต่ละ 300KB ใช้ timeout ที่กำหนดค่า และอนุญาตให้มีการขอวิเคราะห์สูงสุด 5 ครั้งต่อ IP ต';

  @override
  String get privacyPolicyUpdatesTitle => 'การปรับปรุงนโยบาย';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'เวอร์ชั่นโยบายความเป็นส่วนตัวปัจจุบันคือ $version. หากเวอร์ชั่นใหม่เปลี่ยนแปลงวิธีการจัดการข้อมูล แอปอาจขอให้คุณอ่านและยอมรับนโยบายที่ปรับปรุงอีกครั้ง';
  }

  @override
  String get privacyGateTitle => 'โปรดยอมรับนโยบายความเป็นส่วนตัวก่อนใช้แอป';

  @override
  String get privacyGateSummaryStorage =>
      'ตารางเวลา ชุดเวลา และการตั้งค่าเว็บไซต์โรงเรียนจะถูกเก็บไว้ในท้องถิ่นเท่านั้น และไม่ถูกอัพโหลดไปยังเซิร์ฟเวอร์ผู้พัฒนาโดยอัตโนม';

  @override
  String get privacyGateSummaryImportExport =>
      'การนำเข้า การส่งออก และการแบ่งปันเกิดขึ้นเพียงเมื่อคุณเริ่มมันอย่างชัดเจน การวิเคราะห์หน้าเว็บไซต์จะส่งเนื้อหาที่บีบอัดที่คุณส่งไปยังจุดท้ายการวิเคราะห์ที่คุณกำหนดค่า และคุณสามารถตรวจสอบตารางเวลาที่ว';

  @override
  String get privacyGateSummaryUpdates =>
      'หากเวอร์ชั่นใหม่เปลี่ยนแปลงวิธีการจัดการข้อมูล แอปอาจขอให้คุณตรวจสอบนโยบายความเป็นส่วนตัวที่ปรับปรุงอีกครั้ง';

  @override
  String get schoolWebImportEntry => 'นำเข้าจากเว็บไซต์โรงเรียน';

  @override
  String get schoolWebImportEntryDesc =>
      'นำเข้าหน้าเวลาปัจจุบันจากเว็บไซต์โรงเรียน';

  @override
  String get schoolSitesManageEntry => 'จัดการเว็บไซต์โรงเรียน';

  @override
  String get schoolSitesManageEntryDesc =>
      'เพิ่ม แก้ไข และลบ URL การเข้าสู่ระบบโรงเรียนด้วยการนําเข้าและส่งออก JSON';

  @override
  String get schoolSitesPageTitle => 'การจัดการสถานที่โรงเรียน';

  @override
  String get schoolSitesImportJson => 'นำเข้า JSON โรงเรียน';

  @override
  String get schoolSitesShareJson => 'แบ่งปันโรงเรียน JSON';

  @override
  String get schoolSitesSaveJson => 'บันทึก JSON โรงเรียน';

  @override
  String get schoolSitesSaved => 'เว็บไซต์โรงเรียนที่บันทึก';

  @override
  String get schoolSitesImported => 'เว็บไซต์โรงเรียนที่นำเข้า';

  @override
  String get schoolSitesEmpty => 'ยังไม่มีการตั้งค่าเว็บไซต์โรงเรียน';

  @override
  String get schoolSitesNameLabel => 'ชื่อโรงเรียน';

  @override
  String get schoolSitesLoginUrlLabel => 'URL การเข้าสู่ระบบ';

  @override
  String get schoolSitesAdd => 'เพิ่มโรงเรียน';

  @override
  String get schoolSitesEdit => 'แก้ไขโรงเรียน';

  @override
  String get schoolSitesDeleteTitle => 'ลบโรงเรียน';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'ลบ \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'กรอกชื่อโรงเรียนและ URL เข้าสู่ระบบก่อน';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry => 'นำเข้าโดยวางเนื้อหาหน้าตลาดเวลา';

  @override
  String get schoolHtmlImportEntryDesc =>
      'วางรหัสแหล่งหรือเนื้อหาหน้าดิบที่มีข้อมูลตารางเวลาด้วยมือ';

  @override
  String get schoolHtmlImportPageTitle => 'วิเคราะห์ตารางเวลาจากเนื้อหาหน้า';

  @override
  String get schoolHtmlImportUrlLabel => 'URL แหล่ง (ไม่เป็นตัวเลือก)';

  @override
  String get schoolHtmlImportTitleLabel => 'ชื่อหน้า (ตัวเลือก)';

  @override
  String get schoolHtmlImportHtmlLabel => 'เนื้อหาหน้า';

  @override
  String get schoolHtmlImportHtmlHint =>
      'วางรหัสแหล่งหรือเนื้อหาหน้าดิบที่มีข้อมูลตารางเวลาที่นี่';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'เนื้อหาใด ๆ ที่มีข้อมูลตารางเวลาสามารถวิเคราะห์และนำเข้าได้ ไม่ใช่เพียง HTML เท่านั้น';

  @override
  String get schoolHtmlImportCompress => 'บีบอัดเนื้อหา';

  @override
  String get schoolHtmlImportCompressed => 'เนื้อหาที่บีบอัด';

  @override
  String get schoolHtmlImportCompressFirst => 'กดเนื้อหาก่อน';

  @override
  String get schoolHtmlImportSubmit => 'วิเคราะห์และนำเข้า';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'การวิเคราะห์อาจใช้เวลาสักพัก โปรดรอ';

  @override
  String get schoolHtmlImportEmpty => 'วางหน้า HTML ก่อน';

  @override
  String get schoolHtmlImportReturnToWebPage => 'กลับไปที่หน้าเว็บ';

  @override
  String get schoolWebImportPageTitle => 'การนำเข้าเว็บไซต์โรงเรียน';

  @override
  String get schoolWebImportPreview => 'นำเข้าการดูล่วงหน้า';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count หลักสูตร';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count ระยะเวลา';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'ชื่อหน้า';

  @override
  String get schoolWebImportParserUsed => 'เครื่องวิเคราะห์';

  @override
  String get schoolWebImportWarnings => 'นำเข้าบันทึก';

  @override
  String get schoolWebImportOpenPageHint =>
      'เข้าสู่เว็บไซต์โรงเรียนในแอป จากนั้นเดินทางไปยังหน้าตารางเวลาด้วยมือ';

  @override
  String get schoolWebImportConfigMissing =>
      'API การนำเข้าเว็บยังไม่ได้รับการตั้งค่า';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'แพลตฟอร์มนี้ยังไม่รองรับการเข้าสู่ระบบเว็บที่ฝังอยู่ กรุณาใช้แพลตฟอร์มที่รองรับ WebView';

  @override
  String get schoolWebImportSelectSchool => 'เลือกโรงเรียน';

  @override
  String get schoolWebImportNoSchools =>
      'ไม่มีการตั้งค่าโรงเรียน ตรวจสอบ school_sites.json ก่อน';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'ล้มเหลวในการโหลดการตั้งค่าโรงเรียน ตรวจสอบรูปแบบไฟล์ JSON';

  @override
  String get schoolWebImportImportCurrentPage => 'นำเข้าหน้าปัจจุบัน';

  @override
  String get schoolWebImportGoBack => 'หน้าก่อนหน้า';

  @override
  String get schoolWebImportLoadingPage => 'กำลังโหลดหน้า…';

  @override
  String get schoolWebImportParsing => 'การวิเคราะห์หน้าปัจจุบัน...';

  @override
  String get schoolWebImportLoadFailed =>
      'การโหลดหน้าล้มเหลว โปรดปรับปรุงหรือลองอีกครั้งในภายหลัง';

  @override
  String get schoolWebImportLoadTimedOut =>
      'การโหลดหน้าถูกหมดเวลา กรุณาปรับปรุงและลองอีกครั้ง';

  @override
  String get schoolWebImportEmptyPage =>
      'เนื้อหาหน้าปัจจุบันว่างเปล่าและยังไม่สามารถนำเข้าได้';

  @override
  String get schoolWebImportSuccess => 'ตารางเวลาเว็บนำเข้า';

  @override
  String get schoolImportParserSettingsTitle =>
      'การตั้งค่าเครื่องวิเคราะห์ตาราง';

  @override
  String get schoolImportParserSettingsDesc =>
      'เลือกเครื่องวิเคราะห์อย่างเป็นทางการหรือจุดปลายที่เข้ากันได้กับ OpenAI ที่กำหนดเอง';

  @override
  String get schoolImportParserSourceTitle => 'แหล่ง Parser';

  @override
  String get schoolImportParserSourceOfficial =>
      'เครื่องวิเคราะห์อย่างเป็นทางการ';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'ใช้บริการวิเคราะห์อย่างเป็นทางการในตัวที่กำหนดค่าโดยแอป';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'เครื่องวิเคราะห์อย่างเป็นทางการใช้แบกเอนด์วิเคราะห์ที่กำหนดค่าของแอพพลิเคชัน และรักษากระแสการนําเข้าปัจจุบันไม่เปลี่';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'เข้ากันได้กับ OpenAI ที่กำหนดเอง';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'ส่งเนื้อหาหน้าโดยตรงไปยังปลายทางที่เข้ากันได้ OpenAI ของคุณเอง';

  @override
  String get schoolImportParserCustomOpenAi =>
      'เครื่องวิเคราะห์ที่เข้ากันได้กับ OpenAI ที่กำหนดเอง';

  @override
  String get schoolImportParserCustomPromptTitle => 'โปรมป์ตที่กำหนดเอง';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'แก้ไขโปรมปต์การวิเคราะห์ในตัวที่นี่ การเปลี่ยนแปลงมีผลต่อเครื่องวิเคราะห์ที่เข้ากันได้กับ OpenAI ที่กำหนดเองเท่านั้น';

  @override
  String get schoolImportParserCustomPromptHint =>
      'โปรมป์ตในตัวถูกโหลดที่นี่โดยค่าเริ่มต้น ล้างมันเพื่อกลับไปยังรุ่นในตัว';

  @override
  String get schoolImportParserResetDefaultPrompt => 'รีเซ็ตโปรมป์ตค่าเริ่มต้น';

  @override
  String get schoolImportParserBaseUrl => 'URL ฐาน';

  @override
  String get schoolImportParserApiKey => 'คีย์ API';

  @override
  String get schoolImportParserModel => 'แบบ';

  @override
  String get schoolImportParserFetchModels => 'รับรายการรูปแบบ';

  @override
  String get schoolImportParserFetchingModels => 'ไปหารูปแบบ ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'ไม่มีรูปแบบที่ได้รับการคืนโดยจุดสิ้นสุด';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'รุ่นที่รับ $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'คีย์ API ที่กำหนดเองถูกเก็บไว้ในการตั้งค่าท้องถิ่นของแอพในข้อความธรรมดาภายใต้การดําเนินการปัจจุบัน ใช้มันในอุปกรณ์หรือสภาพแวดล้อมเบราว์เซอร์ที่คุณไว้วางใจเท่านั้น';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'การตั้งค่า parser ที่กำหนดเองไม่สมบูรณ์ กรอก URL ฐาน คีย์ API และรูปแบบก่อน';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: เป็นทางการ';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'เครื่องวิเคราะห์: กำหนดเอง ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'ดูนโยบายความเป็นส่วนตัวเต็ม';

  @override
  String get privacyAgreeAndContinue => 'ตกลงและดำเนินการต่อไป';

  @override
  String get privacyDecline => 'ปฏิเสธ';

  @override
  String get privacyDeclineWebHint =>
      'สภาพแวดล้อมเบราว์เซอร์นี้ไม่อนุญาตให้แอพปิดหน้าสำหรับคุณ หากคุณไม่เห็นด้วยโปรดปิดแท็บนี้หรือหน้าต่างด้วยตัวเอง';

  @override
  String get defaultPeriodTimeSetName => 'ระยะเวลาเริ่มต้น';

  @override
  String get periodTimeSetFallbackName => 'ระยะเวลา';

  @override
  String get untitledTimetableName => 'ตารางเวลาที่ไม่มีชื่อ';

  @override
  String get newTimetableName => 'ตารางเวลาใหม่';

  @override
  String get newPeriodTimeSetName => 'กำหนดเวลาใหม่';

  @override
  String get emptyTimetableName => 'ตารางเวลาที่ว่าง';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name ระยะเวลา';
  }

  @override
  String get importFileTypeMismatchMessage => 'ประเภทไฟล์นำเข้าไม่ตรงกัน';

  @override
  String get importFileVersionUnsupportedMessage =>
      'รุ่นไฟล์นำเข้านี้ยังไม่ได้รับการสนับสนุน';

  @override
  String get noPeriodTimesInImportMessage => 'ไม่พบเวลาช่วงเวลาในไฟล์นำเข้า';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'กรุณาเลือกตารางเวลาอย่างน้อย 1 ตาราง';

  @override
  String get noExportableTimetableMessage => 'ไม่มีตารางเวลาในการส่งออก';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'การเปลี่ยนตารางเวลาปัจจุบันสนับสนุนการเลือกตารางเวลาหนึ่งเท่านั้น';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'ไม่มีตารางเวลาปัจจุบันที่จะแทนที่';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'ช่วงเวลานี้ยังคงใช้โดยตารางเวลา $count (s) จัดสรรมันใหม่ก่อนลบ';
  }

  @override
  String get weekdayMonday => 'วันจันทร์';

  @override
  String get weekdayTuesday => 'วันอังคาร';

  @override
  String get weekdayWednesday => 'วันพุธ';

  @override
  String get weekdayThursday => 'วันพฤหัสบดี';

  @override
  String get weekdayFriday => 'วันศุกร์';

  @override
  String get weekdaySaturday => 'วันเสาร์';

  @override
  String get weekdaySunday => 'วันอาทิตย์';

  @override
  String get weekdayShortMonday => 'จันทร์';

  @override
  String get weekdayShortTuesday => 'วันอังคาร';

  @override
  String get weekdayShortWednesday => 'พุธ';

  @override
  String get weekdayShortThursday => 'พฤหัสบดี';

  @override
  String get weekdayShortFriday => 'วันศุกร์';

  @override
  String get weekdayShortSaturday => 'วันเสาร์';

  @override
  String get weekdayShortSunday => 'อาทิตย์';

  @override
  String get monthJanuary => 'มกราคม';

  @override
  String get monthFebruary => 'กุมภาพันธ์';

  @override
  String get monthMarch => 'มีนาคม';

  @override
  String get monthApril => 'เมษายน';

  @override
  String get monthMay => 'พฤษภาคม';

  @override
  String get monthJune => 'มิถุนายน';

  @override
  String get monthJuly => 'กรกฎาคม';

  @override
  String get monthAugust => 'สิงหาคม';

  @override
  String get monthSeptember => 'กันยายน';

  @override
  String get monthOctober => 'ตุลาคม';

  @override
  String get monthNovember => 'พฤศจิกายน';

  @override
  String get monthDecember => 'ธันวาคม';

  @override
  String get semesterWeeksWholeTerm => 'ทั้งภาคศึกษา';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'สัปดาห์ $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'สัปดาห์ $value';
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
  String get reminder => 'Reminder';

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
  String get selectCalendarsToCopyIcs => 'Select calendars to copy as ICS';

  @override
  String get selectCalendarsToExportIcs => 'Select calendars to export as ICS';

  @override
  String get exportIcsText => 'Export ICS text';

  @override
  String get exportJsonText => 'Export JSON text';
}
