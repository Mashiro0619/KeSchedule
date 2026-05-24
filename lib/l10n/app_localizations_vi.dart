// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Bạn học';

  @override
  String weekLabel(int week) {
    return 'Tuần $week';
  }

  @override
  String get addCourse => 'Thêm khóa học';

  @override
  String get settings => 'Cài đặt';

  @override
  String get multiTimetableSwitch => 'Chuyển đổi lịch trình';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Thời gian biểu hiện tại · $weeks tuần';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Nhấn để chuyển · $weeks tuần';
  }

  @override
  String get editTimetable => 'Chỉnh sửa lịch trình';

  @override
  String get createTimetable => 'Thời gian mới';

  @override
  String get jumpToWeek => 'Nhảy đến tuần';

  @override
  String get timetable => 'Thời gian';

  @override
  String get timetableName => 'Tên lịch trình';

  @override
  String get totalWeeks => 'Tổng số tuần';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get save => 'Lưu';

  @override
  String get deleteTimetableTitle => 'Xóa lịch trình';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Chưa có lịch trình';

  @override
  String get noTimetableMessage =>
      'Tạo một lịch trình hoặc nhập một từ một tệp JSON.';

  @override
  String get importTimetable => 'Nhập lịch trình';

  @override
  String get courseName => 'Tên khóa học';

  @override
  String get location => 'Địa điểm';

  @override
  String get dayOfWeek => 'Ngày';

  @override
  String get semesterWeeks => 'Tuần';

  @override
  String get startTime => 'Thời gian bắt đầu';

  @override
  String get endTime => 'Thời gian kết thúc';

  @override
  String get linkedPeriods => 'Các giai đoạn liên kết';

  @override
  String get linkedPeriodsUnmatched =>
      'Không có thời gian phù hợp với thời gian hiện tại. Nhấn để chọn thủ công.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Thời gian $start-$end';
  }

  @override
  String get teacherName => 'Giáo viên';

  @override
  String get credits => 'Tín dụng';

  @override
  String get remarks => 'Lưu ý';

  @override
  String get customFields => 'Các trường tùy chỉnh';

  @override
  String get customFieldsHint => 'Một cho mỗi dòng, định dạng: khóa: giá trị';

  @override
  String get selectDayOfWeek => 'Chọn ngày';

  @override
  String get selectSemesterWeeks => 'Chọn tuần';

  @override
  String get selectAll => 'Chọn tất cả';

  @override
  String get clear => 'Xóa';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get selectLinkedPeriods => 'Chọn các giai đoạn liên kết';

  @override
  String get addCourseTitle => 'Thêm khóa học';

  @override
  String get editCourseTitle => 'Chỉnh sửa khóa học';

  @override
  String get editCourseTooltip => 'Chỉnh sửa khóa học';

  @override
  String get place => 'Địa điểm';

  @override
  String get time => 'Thời gian';

  @override
  String get notFilled => 'Không điền';

  @override
  String get none => 'Không có';

  @override
  String get conflictCourses => 'Các khóa học xung đột';

  @override
  String get locationNotFilled => 'Vị trí không đầy';

  @override
  String get setAsDisplayed => 'Đặt như được hiển thị';

  @override
  String get editThisCourse => 'Chỉnh sửa khóa học này';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get noTimetableSettings => 'Hiện tại không có lịch trình cho cài đặt.';

  @override
  String get semesterStartDate => 'Ngày bắt đầu học kỳ';

  @override
  String get periodTimeSets => 'Thời gian thiết lập';

  @override
  String get noPeriodTimeAvailable => 'Không có thời gian có sẵn';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count thời gian';
  }

  @override
  String get coursePopupDismissSetting =>
      'Cho phép bên ngoài nhấn để đóng khóa học popup';

  @override
  String get coursePopupDismissSettingHint =>
      'Tắt điều này cũng vô hiệu hóa thanh thải cuộn xuống.';

  @override
  String get preserveTimetableGaps => 'Bảo tồn khoảng trống lịch trình';

  @override
  String get preserveTimetableGapsHint =>
      'Khi nghỉ, các khoảng trống ăn trưa và nghỉ ngơi bị sụp đổ vì vậy các lớp học sau đó di chuyển lên.';

  @override
  String get showPastEndedCourses => 'Hiển thị các khóa học đã kết thúc';

  @override
  String get showPastEndedCoursesHint =>
      'Hiển thị các khóa học đã kết thúc vào tuần hiện tại thực sự với phong cách màu xám nhẹ hơn.';

  @override
  String get showFutureCourses => 'Hiển thị các khóa học tương lai';

  @override
  String get showFutureCoursesHint =>
      'Hiển thị các khóa học không hoạt động trong tuần này nhưng sẽ xuất hiện trong các tuần sau với phong cách xám.';

  @override
  String get timetableDisplaySettings => 'Hiển thị lịch trình và tương tác';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup sa thải, khoảng trống, khóa học màu xám và đường lưới';

  @override
  String get showTimetableGridLines => 'Hiển thị các dòng lưới lịch trình';

  @override
  String get showTimetableGridLinesHint =>
      'Kiểm soát xem các đường lưới ngang và dọc có thể nhìn thấy trong lịch trình hay không.';

  @override
  String get liveCourseOutlineColor => 'Màu sắc phác thảo khóa học';

  @override
  String get liveCourseOutlineColorHint =>
      'Chọn liệu phác thảo có nhắm mục tiêu khóa học hiện tại / tiếp theo hoặc tất cả các khóa học được hiển thị trên trang hiện tại hay không.';

  @override
  String get liveCourseOutlineSettings => 'Khóa học phác thảo';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Cấu hình xem phác thảo có được kích hoạt hay không, nó nhắm mục tiêu gì, liệu nó theo màu chủ đề và màu phác thảo hiệu quả hay không.';

  @override
  String get liveCourseOutlineEnabled => 'Kích hoạt phác thảo';

  @override
  String get liveCourseOutlineFollowTheme => 'Theo chủ đề màu';

  @override
  String get liveCourseOutlineTarget => 'Mục tiêu phác thảo';

  @override
  String get liveCourseOutlineTargetCurrentOrNext =>
      'Khóa học hiện tại/tiếp theo';

  @override
  String get liveCourseOutlineTargetAllDisplayed =>
      'Tất cả các khóa học được hiển thị';

  @override
  String get liveCourseOutlineEffectiveColor => 'Màu sắc hiệu quả';

  @override
  String get liveCourseOutlineCustomColor => 'Màu sắc phác thảo tùy chỉnh';

  @override
  String get liveCourseOutlineWidth => 'Chiều rộng phác thảo';

  @override
  String get outlineWidthUnit => 'phim';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languagePageDescription =>
      'Chọn một trong những ngôn ngữ thực sự có sẵn trong ứng dụng.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Phản ứng API';

  @override
  String get theme => 'Chủ đề';

  @override
  String get themeFollowSystem => 'Hệ thống theo dõi';

  @override
  String get themeLight => 'Ánh sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeColor => 'Màu chủ đề';

  @override
  String get themeColorModeSingle => 'Màu chủ đề đơn';

  @override
  String get themeColorModeColorful => 'Đầy màu sắc';

  @override
  String get themeColorUiColors => 'Màu sắc UI';

  @override
  String get themeColorCourseColors => 'Màu sắc khóa học';

  @override
  String get themeColorPrimary => 'Sơ cấp';

  @override
  String get themeColorSecondary => 'Thứ cấp';

  @override
  String get themeColorTertiary => 'Thứ ba';

  @override
  String get themeColorCourseText => 'Văn bản khóa học';

  @override
  String get themeColorCourseTextAuto => 'Tự động';

  @override
  String get themeColorCourseTextCustom => 'Màu sắc tùy chỉnh';

  @override
  String get themeColorCourseColorsEmpty =>
      'Màu sắc khóa học sẽ được tạo ra sau khi nhập một lịch trình.';

  @override
  String get themeCustomColor => 'Màu sắc tùy chỉnh';

  @override
  String get themeApplyCustomColor => 'Áp dụng màu sắc';

  @override
  String get themeApplySettings => 'Áp dụng cài đặt';

  @override
  String get dataImportExport => 'Nhập khẩu và xuất dữ liệu';

  @override
  String get dataImportExportDesc =>
      'Nhập dữ liệu đầy đủ hoặc lịch trình đơn, hoặc xuất hiện tại / tất cả các lịch trình.';

  @override
  String get openSourceLicenses => 'Giấy phép nguồn mở';

  @override
  String get openSourceLicensesDesc =>
      'Xem giấy phép cho các phụ thuộc Flutter và tài sản biểu tượng ứng dụng được gói.';

  @override
  String get checkForUpdates => 'Kiểm tra cập nhật';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Trang web chính thức / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Đã có phiên bản mới nhất ($version)';
  }

  @override
  String get currentVersionLabel => 'Phiên bản hiện tại';

  @override
  String get newVersionAvailable => 'Cập nhật có sẵn';

  @override
  String get latestVersionLabel => 'Phiên bản mới nhất';

  @override
  String get updateContentLabel => 'Cập nhật chi tiết';

  @override
  String get officialWebsite => 'Trang web chính thức';

  @override
  String get googlePlay => 'Chơi Google';

  @override
  String get cloudDrive => 'Động cơ đám mây';

  @override
  String get ignoreThisVersion => 'Bỏ qua phiên bản này';

  @override
  String get openUpdatesFailed => 'Không thể mở liên kết cập nhật';

  @override
  String get updateCheckFailedTitle => 'Kiểm tra cập nhật không thành công';

  @override
  String get updateCheckFailedMessage =>
      'Không thể nhận được thông tin cập nhật hợp lệ từ bất kỳ nguồn cập nhật nào. Bạn vẫn có thể sử dụng các liên kết dưới đây để cập nhật thủ công.';

  @override
  String get githubRepository => 'Kho lưu trữ GitHub';

  @override
  String get openGithubFailed => 'Không thể mở liên kết kho GitHub';

  @override
  String get selectPeriodTimeSet => 'Chọn thời gian thời gian';

  @override
  String get newItem => 'Mới';

  @override
  String get editPeriodTimeSet => 'Chỉnh sửa thiết lập thời gian giai đoạn';

  @override
  String get importTimetableFiles => 'Nhập lịch trình';

  @override
  String get importTimetableFilesDesc =>
      'Hỗ trợ một hoặc nhiều tệp lịch trình.';

  @override
  String get importTimetableText => 'Nhập lịch trình từ văn bản';

  @override
  String get importTimetableTextDesc =>
      'Dán nội dung JSON lịch trình và nhập nó.';

  @override
  String get shareTimetableFiles => 'Chia sẻ các tập tin lịch trình';

  @override
  String get shareTimetableFilesDesc => 'Chọn một hoặc nhiều lịch trình trước.';

  @override
  String get saveTimetableFiles => 'Lưu các tệp lịch trình';

  @override
  String get saveTimetableFilesDesc => 'Chọn một hoặc nhiều lịch trình trước.';

  @override
  String get exportTimetableText => 'Xuất lịch trình dưới dạng văn bản';

  @override
  String get exportTimetableTextDesc =>
      'Chọn một hoặc nhiều lịch trình, sau đó sao chép nội dung JSON.';

  @override
  String get jsonContent => 'Nội dung JSON';

  @override
  String get pasteJsonContentHint => 'Dán nội dung JSON để nhập.';

  @override
  String get jsonContentEmpty => 'Dán nội dung JSON trước.';

  @override
  String get copyText => 'Sao chép';

  @override
  String get copiedToClipboard => 'Sao chép vào clipboard';

  @override
  String get share => 'Chia sẻ';

  @override
  String get selectTimetablesToExport => 'Chọn lịch trình để xuất khẩu';

  @override
  String get selectTimetablesToImport => 'Chọn lịch trình để nhập';

  @override
  String timetableCourseCount(int count) {
    return ' $count các khóa học';
  }

  @override
  String get importAction => 'Nhập khẩu';

  @override
  String get importTimetableDialogTitle => 'Nhập lịch trình';

  @override
  String get chooseImportMethod => 'Chọn cách nhập khẩu';

  @override
  String get importAsNewTimetable => 'Nhập như lịch trình mới';

  @override
  String get replaceCurrentTimetable => 'Thay thế lịch trình hiện tại';

  @override
  String get importPeriodTimeSetDialogTitle => 'Nhập khẩu thời gian';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Tệp này chứa các tập hợp thời gian giai đoạn đóng gói. Bạn có muốn nhập và liên kết chúng không?';

  @override
  String get importBundledPeriodTimeSets => 'Nhập khẩu và liên kết';

  @override
  String get discardBundledPeriodTimeSets => 'Vứt bỏ các bộ gói';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Không có bộ thời gian giai đoạn hiện có, vì vậy các bộ thời gian giai đoạn đóng gói không thể bị loại bỏ.';

  @override
  String savedToPath(Object path) {
    return 'Lưu vào $path';
  }

  @override
  String get saveCancelled => 'Lưu hủy';

  @override
  String get fileSaveRestrictedTitle => 'Lưu tập tin bị hạn chế';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Hệ thống không thể lưu tệp. Bạn có thể thử lại hoặc sử dụng chia sẻ thay vào đó.';

  @override
  String get retrySave => 'Thử lưu lại';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Bật truy cập tệp trong cài đặt hệ thống, sau đó quay lại và thử xuất lại.';

  @override
  String get openSettings => 'Cài đặt mở';

  @override
  String get browserDownloadRestrictedTitle =>
      'Tải xuống trình duyệt bị hạn chế';

  @override
  String get browserDownloadRestrictedMessage =>
      'Trình duyệt này không hỗ trợ lưu trực tiếp vào tệp cục bộ. Kiểm tra quyền tải xuống trình duyệt hoặc sử dụng chia sẻ tập tin thay vào đó.';

  @override
  String get switchToShare => 'Sử dụng chia sẻ thay vì';

  @override
  String get fileSaveFailedTitle => 'Lưu tập tin không thành công';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Không thể viết vào đường dẫn hiện tại. Thư mục tiêu có thể được bảo vệ, tệp có thể đang được sử dụng hoặc đường dẫn có thể không thể viết được.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Hệ thống không thể lưu tệp. Bạn có thể thử lại, kiểm tra cài đặt hệ thống hoặc sử dụng chia sẻ tệp thay vào đó.';

  @override
  String get retryLater => 'Thử lại sau';

  @override
  String get exportSwitchedToShare => 'Chuyển sang chia sẻ tệp để xuất khẩu';

  @override
  String get saveFailedRetry => 'Lưu thất bại. Vui lòng thử lại sau.';

  @override
  String get importFailedCheckContent =>
      'Nhập không thành công. Xin vui lòng kiểm tra nội dung tập tin.';

  @override
  String get noImportableTimetables =>
      'Không có lịch sử sử dụng được tìm thấy trong tệp nhập khẩu.';

  @override
  String importedTimetablesCount(int count) {
    return 'Nhập $count lịch trình';
  }

  @override
  String get periodTimesTitle => 'Thời gian';

  @override
  String get importExport => 'Nhập khẩu và xuất khẩu';

  @override
  String get importPeriodTemplate => 'Mẫu thời gian nhập khẩu';

  @override
  String get importPeriodTemplateText => 'Nhập mẫu giai đoạn từ văn bản';

  @override
  String get sharePeriodTemplate => 'Mẫu thời gian chia sẻ';

  @override
  String get saveTemplateToFile => 'Lưu mẫu vào tệp';

  @override
  String get exportPeriodTemplateText => 'Xuất mẫu giai đoạn dưới dạng văn bản';

  @override
  String get deletePeriodTimeSet => 'Xóa thiết lập thời gian giai đoạn';

  @override
  String get periodTimeSetName => 'Tên thiết lập thời gian giai đoạn';

  @override
  String get addOnePeriod => 'Thêm thời gian';

  @override
  String periodNumberLabel(int index) {
    return 'Thời gian $index';
  }

  @override
  String get deleteThisPeriod => 'Xóa giai đoạn này';

  @override
  String durationMinutes(int minutes) {
    return 'Thời gian $minutes phút';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Khoảng cách từ $minutes phút trước';
  }

  @override
  String get endTimeMustBeLater =>
      'Thời gian kết thúc phải trễ hơn thời gian bắt đầu';

  @override
  String get periodOverlapPrevious =>
      'Giai đoạn này chồng chéo với giai đoạn trước';

  @override
  String get periodTimesSaved => 'Thời gian tiết kiệm';

  @override
  String get deletePeriodTimeSetTitle => 'Xóa thiết lập thời gian giai đoạn';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'thời gian thời gian hiện tại';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Nhập $count thời gian giai đoạn';
  }

  @override
  String get periodFilePermissionTitle => 'File permission cần thiết';

  @override
  String get androidFilePermissionMessage =>
      'Android export yêu cầu quyền truy cập tệp. Cho phép tiếp tục tiết kiệm.';

  @override
  String get reauthorize => 'Chấp thuận lại';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Giấy phép bị từ chối vĩnh viễn';

  @override
  String get permissionSettingsExportMessage =>
      'Bật truy cập tệp trong cài đặt hệ thống, sau đó quay lại và thử xuất lại.';

  @override
  String get privacyPolicyTitle => 'Chính sách bảo mật';

  @override
  String get privacyPolicyEntryDesc =>
      'Tìm hiểu cách ứng dụng xử lý lưu trữ cục bộ, cấu hình trang web trường, nhập / xuất tệp, phân tích trang web và liên kết bên ngoài.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Phiên bản được chấp nhận: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked là công cụ thời khóa biểu ưu tiên lưu trữ cục bộ. Thời khóa biểu, bộ thời gian và cấu hình trang web trường học chỉ được lưu trên thiết bị hoặc trình duyệt của bạn và không bao giờ được tự động tải lên. Ứng dụng chỉ xử lý dữ liệu khi bạn chủ động kích hoạt các thao tác như nhập, phân tích trang web, chia sẻ hoặc mở liên kết bên ngoài. Chính sách bảo mật đầy đủ có sẵn trực tuyến.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lưu trữ địa phương';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Dữ liệu lịch trình và các cài đặt liên quan được lưu trữ trong một tệp cục bộ có tên Sked_data.json bên trong thư mục tài liệu ứng dụng. Cấu hình trang web trường có thể chỉnh sửa được lưu trữ riêng biệt trong Sked_school_sites.json. Cài đặt phân tích lịch trình tùy chỉnh, bao gồm bất kỳ URL cơ sở tùy chỉnh nào, khóa API và mô hình được chọn, cũng được lưu trữ tại địa phương trong cùng dữ liệu ứng dụng và không được bảo vệ bởi kho thông tin hệ thống. Khi được sử dụng trong trình duyệt, cùng một loại dữ liệu được lưu trữ trong lưu trữ trình duyệt. Ứng dụng không tự động tải dữ liệu cục bộ này lên máy chủ do nhà phát triển kiểm soát.';

  @override
  String get privacyPolicyImportExportTitle => 'Nhập khẩu và xuất khẩu';

  @override
  String get privacyPolicyImportExportBody =>
      'Ứng dụng đọc hoặc viết các tệp JSON lịch trình, các tệp JSON trang web trường học và các tệp mẫu thời gian chỉ khi bạn chọn rõ ràng một tệp hoặc bắt đầu hành động xuất. Nhập các tệp này là một hoạt động cục bộ trừ khi bạn cũng chọn phân tích trang web. Lấy một danh sách mô hình tùy chỉnh cũng là một hành động mạng rõ ràng và chỉ liên hệ với điểm cuối tùy chỉnh mà bạn cấu hình.';

  @override
  String get privacyPolicySharingTitle => 'Chia sẻ';

  @override
  String get privacyPolicySharingBody =>
      'Khi bạn sử dụng chia sẻ rõ ràng, ứng dụng sẽ truyền tệp xuất đến trang chia sẻ hệ thống hoặc ứng dụng mục tiêu bạn chọn. Cách xử lý tập tin đó sau đó phụ thuộc vào ứng dụng hoặc dịch vụ mục tiêu mà bạn đã chọn.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Liên kết bên ngoài';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Khi bạn mở các liên kết bên ngoài như kho GitHub, ứng dụng sẽ chuyển hành động ra trình duyệt của bạn hoặc ứng dụng bên ngoài khác. Xử lý dữ liệu sau thời điểm đó được quản lý bởi bên thứ ba bạn mở.';

  @override
  String get privacyPolicyNoCollectionTitle =>
      'Những gì ứng dụng không thu thập';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Ứng dụng không yêu cầu tài khoản Sked và không cho phép phân tích, nhận dạng quảng cáo hoặc sao lưu đám mây. Nó cũng không cung cấp một trường chuyên dụng để thu thập mật khẩu tài khoản trường học. Nếu bạn đăng nhập vào trang web của trường bên trong ứng dụng, tương tác đó xảy ra trên trang trường bạn đã mở.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Phân tích trang web';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Khi bạn sử dụng trang web trường nhập hoặc dán HTML để phân tích, ứng dụng trước tiên nén nội dung cục bộ, sau đó gửi nội dung trang được gửi, tiêu đề trang tùy chọn và URL, ngôn ngữ ứng dụng hiện tại và nội dung nhắc phân tích đến điểm cuối phân tích được chọn. Nếu bạn sử dụng trình phân tích chính thức, yêu cầu sẽ đến phần sau chính thức được cấu hình của ứng dụng. Nếu bạn kích hoạt một trình phân tích tương thích OpenAI tùy chỉnh, cùng nội dung được gửi trực tiếp đến điểm cuối của bên thứ ba mà bạn cấu hình, và lấy danh sách mô hình cũng yêu cầu cùng điểm cuối đó. Một điểm cuối tùy chỉnh có thể chuyển yêu cầu đến các dịch vụ AI khác theo thiết kế của riêng nhà cung cấp đó. Phần sau chính thức được triển khai hiện giới hạn mỗi tải trọng được gửi lên 300KB, sử dụng thời gian hết cấu hình của nó và cho phép tối đa 5 yêu cầu phân tích mỗi IP mỗi ngày.';

  @override
  String get privacyPolicyUpdatesTitle => 'Cập nhật chính sách';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Phiên bản chính sách bảo mật hiện tại là $version. Nếu một phiên bản mới hơn thay đổi cách xử lý dữ liệu, ứng dụng có thể yêu cầu bạn đọc và đồng ý với chính sách cập nhật một lần nữa.';
  }

  @override
  String get privacyGateTitle =>
      'Vui lòng đồng ý với chính sách bảo mật trước khi sử dụng ứng dụng';

  @override
  String get privacyGateSummaryStorage =>
      'Lịch trình, các bộ thời gian và cấu hình trang web trường chỉ được lưu trữ tại địa phương và không được tự động tải lên máy chủ nhà phát triển.';

  @override
  String get privacyGateSummaryImportExport =>
      'Nhập, xuất và chia sẻ chỉ xảy ra khi bạn bắt đầu chúng một cách rõ ràng; Phân tích trang web chỉ gửi nội dung nén mà bạn gửi đến điểm cuối phân tích được cấu hình của bạn, và bạn có thể xem xét lịch trình phân tích trước khi lưu.';

  @override
  String get privacyGateSummaryUpdates =>
      'Nếu một phiên bản mới hơn thay đổi cách xử lý dữ liệu, ứng dụng có thể yêu cầu bạn xem lại chính sách bảo mật được cập nhật.';

  @override
  String get schoolWebImportEntry => 'Nhập từ trang web trường';

  @override
  String get schoolWebImportEntryDesc =>
      'Nhập trang lịch trình hiện tại từ trang web trường.';

  @override
  String get schoolSitesManageEntry => 'Quản lý trang web trường';

  @override
  String get schoolSitesManageEntryDesc =>
      'Thêm, chỉnh sửa và xóa URL đăng nhập trường, với nhập và xuất JSON.';

  @override
  String get schoolSitesPageTitle => 'Quản lý trang web trường';

  @override
  String get schoolSitesImportJson => 'Nhập JSON trường học';

  @override
  String get schoolSitesShareJson => 'Chia sẻ JSON trường học';

  @override
  String get schoolSitesSaveJson => 'Lưu JSON trường học';

  @override
  String get schoolSitesSaved => 'Trang web trường được lưu';

  @override
  String get schoolSitesImported => 'Các trang web trường học nhập khẩu';

  @override
  String get schoolSitesEmpty => 'Chưa có cấu hình trang web của trường.';

  @override
  String get schoolSitesNameLabel => 'Tên trường';

  @override
  String get schoolSitesLoginUrlLabel => 'Đăng nhập URL';

  @override
  String get schoolSitesAdd => 'Thêm trường';

  @override
  String get schoolSitesEdit => 'Chỉnh sửa trường';

  @override
  String get schoolSitesDeleteTitle => 'Xóa trường';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Điền vào tên trường và URL đăng nhập trước.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Nhập bằng cách dán nội dung trang lịch trình';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Dán mã nguồn hoặc nội dung trang thô chứa thông tin lịch trình bằng tay.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Phân tích lịch trình từ nội dung trang';

  @override
  String get schoolHtmlImportUrlLabel => 'URL nguồn (tùy chọn)';

  @override
  String get schoolHtmlImportTitleLabel => 'Tiêu đề trang (tùy chọn)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Nội dung trang';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Dán mã nguồn hoặc nội dung trang thô chứa thông tin lịch trình ở đây.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Bất kỳ nội dung nào chứa thông tin lịch trình có thể được phân tích và nhập khẩu, không chỉ HTML.';

  @override
  String get schoolHtmlImportCompress => 'Nén nội dung';

  @override
  String get schoolHtmlImportCompressed => 'Nội dung nén';

  @override
  String get schoolHtmlImportCompressFirst => 'Nhấn nội dung trước.';

  @override
  String get schoolHtmlImportSubmit => 'Phân tích và nhập khẩu';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Phân tích có thể mất một thời gian. Xin đợi.';

  @override
  String get schoolHtmlImportEmpty => 'Dán trang HTML trước.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Trở lại trang web';

  @override
  String get schoolWebImportPageTitle => 'Nhập trang web trường học';

  @override
  String get schoolWebImportPreview => 'Nhập xem trước';

  @override
  String schoolWebImportCourseCount(int count) {
    return ' $count các khóa học';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count thời gian';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Tiêu đề trang';

  @override
  String get schoolWebImportParserUsed => 'Phân tích';

  @override
  String get schoolWebImportWarnings => 'Nhập ghi chú';

  @override
  String get schoolWebImportOpenPageHint =>
      'Đăng nhập vào trang web của trường trong ứng dụng, sau đó điều hướng đến trang lịch trình thủ công.';

  @override
  String get schoolWebImportConfigMissing =>
      'Web import backend API chưa được cấu hình.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Nền tảng này chưa hỗ trợ đăng nhập web nhúng. Vui lòng sử dụng một nền tảng với hỗ trợ WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Chọn trường';

  @override
  String get schoolWebImportNoSchools =>
      'Không có cấu hình trường có sẵn. Kiểm tra school_sites.json trước.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Không thể tải cấu hình trường. Kiểm tra định dạng tập tin JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Nhập trang hiện tại';

  @override
  String get schoolWebImportGoBack => 'Trang trước';

  @override
  String get schoolWebImportLoadingPage => 'Đang tải trang…';

  @override
  String get schoolWebImportParsing => 'Phân tích trang hiện tại...';

  @override
  String get schoolWebImportLoadFailed =>
      'Page load không thành công. Xin vui lòng làm mới hoặc thử lại sau.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Page loading đã hết thời gian. Xin vui lòng làm mới và thử lại.';

  @override
  String get schoolWebImportEmptyPage =>
      'Nội dung trang hiện tại trống và chưa thể nhập được.';

  @override
  String get schoolWebImportSuccess => 'Lịch trình web nhập khẩu';

  @override
  String get schoolImportParserSettingsTitle =>
      'Cài đặt trình phân tích lịch trình';

  @override
  String get schoolImportParserSettingsDesc =>
      'Chọn trình phân tích chính thức hoặc một điểm cuối tương thích OpenAI tùy chỉnh.';

  @override
  String get schoolImportParserSourceTitle => 'Nguồn parser';

  @override
  String get schoolImportParserSourceOfficial => 'Phân tích chính thức';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Sử dụng dịch vụ phân tích chính thức tích hợp được cấu hình bởi ứng dụng.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Phân tích chính thức sử dụng phần sau phân tích được cấu hình của ứng dụng và giữ cho dòng chảy nhập khẩu hiện tại không thay đổi.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Tùy chỉnh OpenAI tương thích';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Gửi nội dung trang trực tiếp đến điểm cuối tương thích OpenAI của riêng bạn.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Phân tích tương thích OpenAI tùy chỉnh';

  @override
  String get schoolImportParserCustomPromptTitle => 'Tùy chỉnh nhắc nhở';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Chỉnh sửa built-in parser prompt ở đây. Thay đổi chỉ ảnh hưởng đến trình phân tích tương thích OpenAI tùy chỉnh.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Lời nhắc tích hợp được tải ở đây theo mặc định. Xóa nó để trở lại phiên bản tích hợp.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Đặt lại lời nhắc mặc định';

  @override
  String get schoolImportParserBaseUrl => 'URL cơ sở';

  @override
  String get schoolImportParserApiKey => 'Khóa API';

  @override
  String get schoolImportParserModel => 'Mô hình';

  @override
  String get schoolImportParserFetchModels => 'Lấy danh sách mô hình';

  @override
  String get schoolImportParserFetchingModels => 'Lấy mô hình. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Không có mô hình nào được trả lại bởi điểm cuối.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Lấy các mô hình $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Khóa API tùy chỉnh được lưu trữ trong cài đặt địa phương của ứng dụng bằng văn bản đơn giản dưới triển khai hiện tại. Chỉ sử dụng nó trên thiết bị hoặc môi trường trình duyệt mà bạn tin tưởng.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Cấu hình parser tùy chỉnh không hoàn chỉnh. Điền vào URL cơ sở, khóa API và mô hình trước.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Chính thức';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Phân tích: Tùy chỉnh ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Xem chính sách bảo mật đầy đủ';

  @override
  String get privacyAgreeAndContinue => 'Đồng ý và tiếp tục';

  @override
  String get privacyDecline => 'từ chối';

  @override
  String get privacyDeclineWebHint =>
      'Môi trường trình duyệt này không cho phép ứng dụng đóng trang cho bạn. Nếu bạn không đồng ý, vui lòng tự đóng tab hoặc cửa sổ này.';

  @override
  String get defaultPeriodTimeSetName => 'Thời gian mặc định';

  @override
  String get periodTimeSetFallbackName => 'Thời gian';

  @override
  String get untitledTimetableName => 'Thời gian biểu không có tiêu đề';

  @override
  String get newTimetableName => 'Thời gian mới';

  @override
  String get newPeriodTimeSetName => 'Thiết lập thời gian giai đoạn mới';

  @override
  String get emptyTimetableName => 'Thời gian biểu trống';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name thời gian';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Loại tập tin nhập không phù hợp.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Phiên bản tập tin nhập này chưa được hỗ trợ.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Không có thời gian được tìm thấy trong tệp nhập khẩu.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Xin vui lòng chọn ít nhất một lịch trình.';

  @override
  String get noExportableTimetableMessage =>
      'Không có lịch trình có sẵn để xuất khẩu.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Thay thế lịch trình hiện tại chỉ hỗ trợ chọn một lịch trình.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Không có lịch trình hiện tại để thay thế.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Bộ thời gian giai đoạn này vẫn được sử dụng bởi $count lịch trình (s). Đặt lại trước khi xóa.';
  }

  @override
  String get weekdayMonday => 'Thứ Hai';

  @override
  String get weekdayTuesday => 'Thứ ba';

  @override
  String get weekdayWednesday => 'Thứ Tư';

  @override
  String get weekdayThursday => 'Thứ Năm';

  @override
  String get weekdayFriday => 'Thứ Sáu';

  @override
  String get weekdaySaturday => 'Thứ bảy';

  @override
  String get weekdaySunday => 'Chủ nhật';

  @override
  String get weekdayShortMonday => 'Thứ Hai';

  @override
  String get weekdayShortTuesday => 'Thứ ba';

  @override
  String get weekdayShortWednesday => 'Thứ Tư';

  @override
  String get weekdayShortThursday => 'Thứ Năm';

  @override
  String get weekdayShortFriday => 'Thứ Sáu';

  @override
  String get weekdayShortSaturday => 'Thứ bảy';

  @override
  String get weekdayShortSunday => 'Mặt trời';

  @override
  String get monthJanuary => 'Tháng Jan';

  @override
  String get monthFebruary => 'Tháng Hai';

  @override
  String get monthMarch => 'Tháng 3';

  @override
  String get monthApril => 'Tháng Tư';

  @override
  String get monthMay => 'Tháng Năm';

  @override
  String get monthJune => 'Tháng Sáu';

  @override
  String get monthJuly => 'Tháng Bảy';

  @override
  String get monthAugust => 'Tháng Tám';

  @override
  String get monthSeptember => 'Tháng 9';

  @override
  String get monthOctober => 'Tháng Mười';

  @override
  String get monthNovember => 'Tháng Mười Một';

  @override
  String get monthDecember => 'Tháng Mười Hai';

  @override
  String get semesterWeeksWholeTerm => 'Tất cả học kỳ';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Tuần $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Tuần $value';
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
