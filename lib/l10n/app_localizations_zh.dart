// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return '第 $week 周';
  }

  @override
  String get addCourse => '添加课程';

  @override
  String get settings => '设置';

  @override
  String get multiTimetableSwitch => '多课表切换';

  @override
  String currentTimetableWeeks(int weeks) {
    return '当前课表 · 共 $weeks 周';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return '点击切换 · 共 $weeks 周';
  }

  @override
  String get editTimetable => '编辑课表';

  @override
  String get createTimetable => '新建课表';

  @override
  String get jumpToWeek => '快捷跳转周数';

  @override
  String get timetable => '课表';

  @override
  String get timetableName => '课表名称';

  @override
  String get totalWeeks => '总周数';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get deleteTimetableTitle => '删除课表';

  @override
  String deleteTimetableMessage(Object name) {
    return '确认删除“$name”吗？';
  }

  @override
  String get noTimetableTitle => '当前没有课表';

  @override
  String get noTimetableMessage => '可以新建一个课表，或从 JSON 文件导入已有课表。';

  @override
  String get importTimetable => '导入课表';

  @override
  String get courseName => '课程名称';

  @override
  String get location => '上课地点';

  @override
  String get dayOfWeek => '上课日';

  @override
  String get semesterWeeks => '周次';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get linkedPeriods => '关联节次';

  @override
  String get linkedPeriodsUnmatched => '当前时间未匹配到节次，点此手动选择';

  @override
  String periodRangeLabel(int start, int end) {
    return '第 $start-$end 节';
  }

  @override
  String get teacherName => '老师姓名';

  @override
  String get credits => '学分';

  @override
  String get remarks => '备注';

  @override
  String get customFields => '自定义字段';

  @override
  String get customFieldsHint => '每行一个，格式：键:值';

  @override
  String get selectDayOfWeek => '选择上课日';

  @override
  String get selectSemesterWeeks => '选择周次';

  @override
  String get selectAll => '全选';

  @override
  String get clear => '清空';

  @override
  String get confirm => '确定';

  @override
  String get selectLinkedPeriods => '选择关联节次';

  @override
  String get addCourseTitle => '添加课程';

  @override
  String get editCourseTitle => '编辑课程';

  @override
  String get editCourseTooltip => '编辑课程';

  @override
  String get place => '地点';

  @override
  String get time => '时间';

  @override
  String get notFilled => '未填写';

  @override
  String get none => '无';

  @override
  String get conflictCourses => '冲突课程';

  @override
  String get locationNotFilled => '未填写地点';

  @override
  String get setAsDisplayed => '设为外部显示';

  @override
  String get editThisCourse => '编辑这门课';

  @override
  String get settingsTitle => '设置';

  @override
  String get noTimetableSettings => '当前没有可设置的课表';

  @override
  String get semesterStartDate => '开学日期';

  @override
  String get periodTimeSets => '节次时间集';

  @override
  String get noPeriodTimeAvailable => '暂无可用节次时间';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count 节';
  }

  @override
  String get coursePopupDismissSetting => '允许点击空白处关闭课程弹窗';

  @override
  String get coursePopupDismissSettingHint => '关闭后也会一并禁用下拉手势关闭，避免误触。';

  @override
  String get preserveTimetableGaps => '保留课表空白时间';

  @override
  String get preserveTimetableGapsHint => '关闭后会折叠午休、下课等非上课时间，让后续课程向上拼接。';

  @override
  String get showPastEndedCourses => '显示已结束课程';

  @override
  String get showPastEndedCoursesHint => '显示按真实当前周已结束的课程，并用更浅的灰色区分。';

  @override
  String get showFutureCourses => '显示之后的课程';

  @override
  String get showFutureCoursesHint => '显示当前周不上、但之后周次还会上的课程，并用灰色区分。';

  @override
  String get timetableDisplaySettings => '课表显示与交互';

  @override
  String get timetableDisplaySettingsDesc => '课程弹窗、空白时间、灰色课程与网格线';

  @override
  String get showTimetableGridLines => '显示课表网格线';

  @override
  String get showTimetableGridLinesHint => '控制课表中的横向与纵向网格线是否显示。';

  @override
  String get liveCourseOutlineColor => '课程描边颜色';

  @override
  String get liveCourseOutlineColorHint => '描边目标可选择当前/下一节课程，或当前页所有已显示课程。';

  @override
  String get liveCourseOutlineSettings => '课程描边';

  @override
  String get liveCourseOutlineSettingsHint =>
      '可设置是否开启描边、描边目标、是否跟随主题色，以及当前实际生效的描边颜色。';

  @override
  String get liveCourseOutlineEnabled => '开启课程描边';

  @override
  String get liveCourseOutlineFollowTheme => '跟随主题色';

  @override
  String get liveCourseOutlineTarget => '描边目标';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => '当前/下一节课程';

  @override
  String get liveCourseOutlineTargetAllDisplayed => '当前页全部课程';

  @override
  String get liveCourseOutlineEffectiveColor => '当前生效颜色';

  @override
  String get liveCourseOutlineCustomColor => '自定义描边颜色';

  @override
  String get liveCourseOutlineWidth => '描边宽度';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => '语言';

  @override
  String get languagePageDescription => '请选择应用当前真正支持的语言。';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API 响应';

  @override
  String get theme => '主题';

  @override
  String get themeFollowSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '暗黑';

  @override
  String get themeColor => '主题色';

  @override
  String get themeColorModeSingle => '单调主题色';

  @override
  String get themeColorModeColorful => '五彩缤纷';

  @override
  String get themeColorUiColors => 'UI 配色';

  @override
  String get themeColorCourseColors => '课程颜色';

  @override
  String get themeColorPrimary => '主色';

  @override
  String get themeColorSecondary => '辅色';

  @override
  String get themeColorTertiary => '强调色';

  @override
  String get themeColorCourseText => '课程文字色';

  @override
  String get themeColorCourseTextAuto => '自动配色';

  @override
  String get themeColorCourseTextCustom => '自定义颜色';

  @override
  String get themeColorCourseColorsEmpty => '导入课表后将自动生成课程颜色';

  @override
  String get themeCustomColor => '自定义颜色';

  @override
  String get themeApplyCustomColor => '应用颜色';

  @override
  String get themeApplySettings => '应用设置';

  @override
  String get dataImportExport => '导入导出数据';

  @override
  String get dataImportExportDesc => '导入整包/单课表，或导出当前课表与全部课表';

  @override
  String get openSourceLicenses => '开源许可';

  @override
  String get openSourceLicensesDesc => '查看 Flutter 依赖与应用内置图标资源的许可信息';

  @override
  String get checkForUpdates => '检测更新';

  @override
  String get checkForUpdatesDesc => 'GitHub / 官网 / Google Play / 网盘';

  @override
  String alreadyLatestVersion(Object version) {
    return '当前已是最新版本（$version）';
  }

  @override
  String get currentVersionLabel => '当前版本';

  @override
  String get newVersionAvailable => '有新版本';

  @override
  String get latestVersionLabel => '最新版本';

  @override
  String get updateContentLabel => '更新内容';

  @override
  String get officialWebsite => '官网';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => '网盘';

  @override
  String get ignoreThisVersion => '忽略此版本';

  @override
  String get openUpdatesFailed => '无法打开更新链接';

  @override
  String get updateCheckFailedTitle => '检测更新失败';

  @override
  String get updateCheckFailedMessage => '无法从更新源获取有效版本信息。你仍可通过下方渠道手动获取更新。';

  @override
  String get githubRepository => 'GitHub 仓库';

  @override
  String get openGithubFailed => '无法打开 GitHub 仓库链接';

  @override
  String get selectPeriodTimeSet => '选择节次时间集';

  @override
  String get newItem => '新建';

  @override
  String get editPeriodTimeSet => '编辑节次时间集';

  @override
  String get importTimetableFiles => '导入课表';

  @override
  String get importTimetableFilesDesc => '支持单个或多个课表文件';

  @override
  String get importTimetableText => '从文字导入课表';

  @override
  String get importTimetableTextDesc => '粘贴课表 JSON 内容后导入';

  @override
  String get shareTimetableFiles => '分享课表文件';

  @override
  String get shareTimetableFilesDesc => '先选择一个或多个课表';

  @override
  String get saveTimetableFiles => '保存课表文件';

  @override
  String get saveTimetableFilesDesc => '先选择一个或多个课表';

  @override
  String get exportTimetableText => '导出课表为文字';

  @override
  String get exportTimetableTextDesc => '先选择一个或多个课表，再复制 JSON 内容';

  @override
  String get jsonContent => 'JSON 内容';

  @override
  String get pasteJsonContentHint => '请粘贴要导入的 JSON 内容';

  @override
  String get jsonContentEmpty => '请先粘贴 JSON 内容';

  @override
  String get copyText => '复制';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get share => '分享';

  @override
  String get selectTimetablesToExport => '选择要导出的课表';

  @override
  String get selectTimetablesToImport => '选择要导入的课表';

  @override
  String timetableCourseCount(int count) {
    return '$count 门课程';
  }

  @override
  String get importAction => '导入';

  @override
  String get importTimetableDialogTitle => '导入课表';

  @override
  String get chooseImportMethod => '请选择导入方式';

  @override
  String get importAsNewTimetable => '作为新课表导入';

  @override
  String get replaceCurrentTimetable => '覆盖当前课表';

  @override
  String get importPeriodTimeSetDialogTitle => '导入节次时间集';

  @override
  String get importPeriodTimeSetDialogBody => '检测到文件内包含节次时间集。是否一并导入并关联它们？';

  @override
  String get importBundledPeriodTimeSets => '导入并关联';

  @override
  String get discardBundledPeriodTimeSets => '丢弃内含节次';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      '当前没有可用节次时间集，不能丢弃文件内节次时间集。';

  @override
  String savedToPath(Object path) {
    return '已保存到 $path';
  }

  @override
  String get saveCancelled => '已取消保存';

  @override
  String get fileSaveRestrictedTitle => '文件保存受限';

  @override
  String get fileSaveRestrictedRetryMessage => '当前系统未能完成文件保存。你可以重试，或改用文件分享。';

  @override
  String get retrySave => '重试保存';

  @override
  String get fileSaveRestrictedSettingsMessage => '请在系统设置中打开文件访问权限，然后返回重试导出。';

  @override
  String get openSettings => '打开设置';

  @override
  String get browserDownloadRestrictedTitle => '浏览器下载受限';

  @override
  String get browserDownloadRestrictedMessage =>
      '当前浏览器不支持直接保存到本地文件。你可以检查浏览器下载权限，或改用分享文件。';

  @override
  String get switchToShare => '改用分享';

  @override
  String get fileSaveFailedTitle => '文件保存失败';

  @override
  String get fileSaveFailedWindowsMessage =>
      '无法写入当前路径，可能是目标文件夹受系统保护、文件被占用，或当前路径不可写。';

  @override
  String get fileSaveFailedGenericMessage => '系统未能完成文件保存。你可以重试、检查系统设置，或改用文件分享。';

  @override
  String get retryLater => '稍后再试';

  @override
  String get exportSwitchedToShare => '已改用文件分享导出';

  @override
  String get saveFailedRetry => '保存失败，请稍后重试';

  @override
  String get importFailedCheckContent => '导入失败，请检查文件内容';

  @override
  String get noImportableTimetables => '导入文件中没有可用课表';

  @override
  String importedTimetablesCount(int count) {
    return '已导入 $count 个课表';
  }

  @override
  String get periodTimesTitle => '节次时间';

  @override
  String get importExport => '导入导出';

  @override
  String get importPeriodTemplate => '导入节次模板';

  @override
  String get importPeriodTemplateText => '从文字导入节次模板';

  @override
  String get sharePeriodTemplate => '分享节次模板';

  @override
  String get saveTemplateToFile => '保存模板到文件';

  @override
  String get exportPeriodTemplateText => '导出节次模板为文字';

  @override
  String get deletePeriodTimeSet => '删除节次时间';

  @override
  String get periodTimeSetName => '节次时间名称';

  @override
  String get addOnePeriod => '增加一节';

  @override
  String periodNumberLabel(int index) {
    return '第 $index 节';
  }

  @override
  String get deleteThisPeriod => '删除本节';

  @override
  String durationMinutes(int minutes) {
    return '时长 $minutes 分钟';
  }

  @override
  String gapFromPrevious(int minutes) {
    return '与上一节间隔 $minutes 分钟';
  }

  @override
  String get endTimeMustBeLater => '结束时间必须晚于开始时间';

  @override
  String get periodOverlapPrevious => '当前节次与上一节时间重叠';

  @override
  String get periodTimesSaved => '已保存节次时间';

  @override
  String get deletePeriodTimeSetTitle => '删除节次时间';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return '确认删除“$name”吗？';
  }

  @override
  String get currentPeriodTimeSet => '当前节次时间';

  @override
  String importedPeriodTimesCount(int count) {
    return '已导入 $count 条节次时间';
  }

  @override
  String get periodFilePermissionTitle => '需要文件权限';

  @override
  String get androidFilePermissionMessage => 'Android 导出需要文件访问权限，请授权后继续保存。';

  @override
  String get reauthorize => '重新授权';

  @override
  String get permissionPermanentlyDeniedTitle => '权限已被永久拒绝';

  @override
  String get permissionSettingsExportMessage => '请在系统设置中打开文件访问权限，然后再回来重试导出。';

  @override
  String get privacyPolicyTitle => '隐私政策';

  @override
  String get privacyPolicyEntryDesc => '了解应用如何处理本地存储、学校站点配置、文件导入导出、网页解析和外部链接。';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return '已同意版本：$version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked 为本地优先的课程表工具。课表数据、节次时间集和学校站点配置仅保存在你的设备或浏览器本地，不会自动上传。应用仅在你主动触发导入、网页解析、分享或打开外部链接等操作时才会处理对应内容。完整隐私政策可在线查看。';

  @override
  String get privacyPolicyLocalStorageTitle => '本地存储';

  @override
  String get privacyPolicyLocalStorageBody =>
      '课表数据和相关设置会保存在应用文档目录中的本地文件 Sked_data.json，可编辑的学校站点配置会单独保存在 Sked_school_sites.json。自定义课表解析设置中填写的 Base URL、API 密钥和所选模型也会随同应用数据保存在本地，当前实现不会使用系统安全凭据库进行保护。若在浏览器中使用，同类数据会保存在浏览器本地存储中。应用不会自动把这些本地数据上传到开发者控制的服务器。';

  @override
  String get privacyPolicyImportExportTitle => '导入与导出';

  @override
  String get privacyPolicyImportExportBody =>
      '只有在你主动选择文件或主动执行导出时，应用才会读取或写出 JSON 课表文件、学校站点 JSON 文件和节次模板文件。这些文件的导入导出本身属于本地操作；只有当你进一步选择网页解析时，相关页面内容才会被发送到你配置的解析接口。获取自定义模型列表同样属于你主动触发的联网操作，并且只会请求你填写的自定义接口。';

  @override
  String get privacyPolicySharingTitle => '分享功能';

  @override
  String get privacyPolicySharingBody =>
      '当你主动使用分享功能时，应用会把你选中的导出文件交给系统分享面板或目标应用。后续如何处理该文件，由你选择的目标应用或服务自行决定。';

  @override
  String get privacyPolicyExternalLinksTitle => '外部链接';

  @override
  String get privacyPolicyExternalLinksBody =>
      '当你主动打开 GitHub 仓库等外部链接时，应用会调用系统浏览器或其他外部应用。离开应用后的数据处理将受对应第三方的政策约束。';

  @override
  String get privacyPolicyNoCollectionTitle => '不会收集的内容';

  @override
  String get privacyPolicyNoCollectionBody =>
      '应用不要求你注册 Sked 账号，也不会启用分析统计、广告标识符或云端备份。应用本身也没有专门用于采集学校账号密码的输入字段；如果你在应用内打开的学校网页中登录，该交互发生在你访问的学校页面内。';

  @override
  String get privacyPolicyFutureFeatureTitle => '网页解析';

  @override
  String get privacyPolicyFutureFeatureBody =>
      '当你使用学校网页导入或粘贴 HTML 进行解析时，应用会先在本地压缩内容，再把你提交的页面内容、可选的页面标题与 URL、当前应用语言以及解析提示词发送到当前选择的解析接口。如果你使用官方解析，请求会发往应用配置的官方后端；如果你启用自定义 OpenAI 兼容解析，同样的内容会直接发送到你填写的第三方接口，获取模型列表时也会请求该第三方接口。自定义接口还可能按照其自身设计继续把请求转发给其他 AI 服务。当前官方后端会限制单次提交内容不得大于 300KB，使用其配置的请求超时时间，并按 IP 每天最多解析 5 次。';

  @override
  String get privacyPolicyUpdatesTitle => '政策更新';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return '当前隐私政策版本为 $version。如果后续版本调整了数据处理方式，应用可能会要求你重新阅读并同意更新后的隐私政策。';
  }

  @override
  String get privacyGateTitle => '使用前请先同意隐私政策';

  @override
  String get privacyGateSummaryStorage =>
      '课表、节次时间集和学校站点配置只会保存在本地，不会自动上传到开发者服务器。';

  @override
  String get privacyGateSummaryImportExport =>
      '导入、导出和分享仅在你主动操作时触发；网页解析只会发送你主动提交的压缩后内容，并在保存前让你预览解析结果。';

  @override
  String get privacyGateSummaryUpdates =>
      '如果后续版本调整了数据处理方式，应用可能会要求你重新查看更新后的隐私政策。';

  @override
  String get schoolWebImportEntry => '从学校网页导入';

  @override
  String get schoolWebImportEntryDesc => '进入学校网站后导入当前课表页。';

  @override
  String get schoolSitesManageEntry => '学校站点管理';

  @override
  String get schoolSitesManageEntryDesc => '新增、编辑、删除学校登录地址，并支持 JSON 导入导出。';

  @override
  String get schoolSitesPageTitle => '学校站点管理';

  @override
  String get schoolSitesImportJson => '导入学校 JSON';

  @override
  String get schoolSitesShareJson => '分享学校 JSON';

  @override
  String get schoolSitesSaveJson => '保存学校 JSON';

  @override
  String get schoolSitesSaved => '学校站点已保存';

  @override
  String get schoolSitesImported => '学校站点已导入';

  @override
  String get schoolSitesEmpty => '当前还没有学校站点配置。';

  @override
  String get schoolSitesNameLabel => '学校名称';

  @override
  String get schoolSitesLoginUrlLabel => '登录页链接';

  @override
  String get schoolSitesAdd => '新增学校';

  @override
  String get schoolSitesEdit => '编辑学校';

  @override
  String get schoolSitesDeleteTitle => '删除学校';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return '确认删除“$name”吗？';
  }

  @override
  String get schoolSitesFormInvalid => '请完整填写学校名称和登录页链接。';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry => '粘贴课程表页面内容导入';

  @override
  String get schoolHtmlImportEntryDesc => '手动粘贴包含课程信息的页面源码或原始内容。';

  @override
  String get schoolHtmlImportPageTitle => '解析课表页面内容';

  @override
  String get schoolHtmlImportUrlLabel => '来源 URL（可选）';

  @override
  String get schoolHtmlImportTitleLabel => '页面标题（可选）';

  @override
  String get schoolHtmlImportHtmlLabel => '页面内容';

  @override
  String get schoolHtmlImportHtmlHint => '请粘贴包含课程信息的页面源码或原始内容。';

  @override
  String get schoolHtmlImportNonHtmlHint => '只要内容里包含课程信息，就可以解析导入，不限于 HTML。';

  @override
  String get schoolHtmlImportCompress => '压缩内容';

  @override
  String get schoolHtmlImportCompressed => '内容已压缩';

  @override
  String get schoolHtmlImportCompressFirst => '请先压缩内容。';

  @override
  String get schoolHtmlImportSubmit => '解析并导入';

  @override
  String get schoolHtmlImportParsingMayTakeLong => '解析时间可能较长，请耐心等待。';

  @override
  String get schoolHtmlImportEmpty => '请先粘贴网页 HTML。';

  @override
  String get schoolHtmlImportReturnToWebPage => '返回网页';

  @override
  String get schoolWebImportPageTitle => '学校网页导入';

  @override
  String get schoolWebImportPreview => '导入预览';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count 门课程';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count 节';
  }

  @override
  String get schoolWebImportPageTitleLabel => '页面标题';

  @override
  String get schoolWebImportParserUsed => '解析器';

  @override
  String get schoolWebImportWarnings => '导入提示';

  @override
  String get schoolWebImportOpenPageHint => '请在应用内登录学校网站，并手动切换到课表页。';

  @override
  String get schoolWebImportConfigMissing => '尚未配置网页导入后端接口地址。';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      '当前平台暂不支持内嵌网页登录，请在支持 WebView 的平台上使用。';

  @override
  String get schoolWebImportSelectSchool => '选择学校';

  @override
  String get schoolWebImportNoSchools => '当前没有可用学校配置，请先检查 school_sites.json。';

  @override
  String get schoolWebImportSchoolLoadFailed => '学校配置加载失败，请检查 JSON 文件格式。';

  @override
  String get schoolWebImportImportCurrentPage => '导入当前页';

  @override
  String get schoolWebImportGoBack => '上一页';

  @override
  String get schoolWebImportLoadingPage => '页面加载中…';

  @override
  String get schoolWebImportParsing => '正在解析当前页面…';

  @override
  String get schoolWebImportLoadFailed => '页面加载失败，请刷新后重试。';

  @override
  String get schoolWebImportLoadTimedOut => '页面加载超时，请刷新后重试。';

  @override
  String get schoolWebImportEmptyPage => '当前页面内容为空，暂时无法导入。';

  @override
  String get schoolWebImportSuccess => '网页课表已导入';

  @override
  String get schoolImportParserSettingsTitle => '课表解析设置';

  @override
  String get schoolImportParserSettingsDesc => '选择官方解析，或改用自定义 OpenAI 兼容接口。';

  @override
  String get schoolImportParserSourceTitle => '解析来源';

  @override
  String get schoolImportParserSourceOfficial => '官方解析';

  @override
  String get schoolImportParserSourceOfficialDesc => '使用应用内配置的官方解析服务。';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      '官方解析会继续使用应用当前配置的解析后端，并保持现有导入流程不变。';

  @override
  String get schoolImportParserSourceCustomOpenAi => '自定义 OpenAI 兼容接口';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      '把页面内容直接发送到你自己的 OpenAI 兼容端点。';

  @override
  String get schoolImportParserCustomOpenAi => '自定义 OpenAI 兼容解析';

  @override
  String get schoolImportParserCustomPromptTitle => '自定义提示词';

  @override
  String get schoolImportParserCustomPromptDescription =>
      '可直接在这里修改内置解析提示词，且仅对自定义 OpenAI 兼容接口生效。';

  @override
  String get schoolImportParserCustomPromptHint => '这里默认会载入内置提示词；清空后会回退为内置版本。';

  @override
  String get schoolImportParserResetDefaultPrompt => '重置默认提示词';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API 密钥';

  @override
  String get schoolImportParserModel => '模型名称';

  @override
  String get schoolImportParserFetchModels => '获取模型列表';

  @override
  String get schoolImportParserFetchingModels => '正在获取模型列表...';

  @override
  String get schoolImportParserNoModelsFound => '该端点没有返回任何模型。';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '已获取 $count 个模型';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      '当前实现下，自定义 API 密钥会以明文形式保存在应用本地配置中。请仅在你信任的设备或浏览器环境中使用。';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      '自定义解析配置不完整，请先填写 Base URL、API 密钥和模型名称。';

  @override
  String get schoolImportParserCurrentSourceOfficial => '解析器：官方';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return '解析器：自定义（$model）';
  }

  @override
  String get privacyViewFullPolicy => '查看完整隐私政策';

  @override
  String get privacyAgreeAndContinue => '同意并继续';

  @override
  String get privacyDecline => '不同意';

  @override
  String get privacyDeclineWebHint => '当前浏览器环境无法由应用主动关闭页面。若你不同意，请直接关闭此标签页或窗口。';

  @override
  String get defaultPeriodTimeSetName => '默认节次';

  @override
  String get periodTimeSetFallbackName => '节次时间';

  @override
  String get untitledTimetableName => '未命名课表';

  @override
  String get newTimetableName => '新课表';

  @override
  String get newPeriodTimeSetName => '新节次时间';

  @override
  String get emptyTimetableName => '空课表';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name 节次';
  }

  @override
  String get importFileTypeMismatchMessage => '导入文件类型不匹配';

  @override
  String get importFileVersionUnsupportedMessage => '导入文件版本暂不支持';

  @override
  String get noPeriodTimesInImportMessage => '导入文件中没有节次时间';

  @override
  String get selectAtLeastOneTimetableMessage => '请选择至少一个课表';

  @override
  String get noExportableTimetableMessage => '当前没有可导出的课表';

  @override
  String get replaceActiveRequiresSingleTimetableMessage => '覆盖当前课表时只能选择一个课表';

  @override
  String get noActiveTimetableToReplaceMessage => '当前没有可覆盖的课表';

  @override
  String periodTimeSetInUseMessage(int count) {
    return '该节次时间仍被 $count 个课表使用，请先改关联再删除';
  }

  @override
  String get weekdayMonday => '星期一';

  @override
  String get weekdayTuesday => '星期二';

  @override
  String get weekdayWednesday => '星期三';

  @override
  String get weekdayThursday => '星期四';

  @override
  String get weekdayFriday => '星期五';

  @override
  String get weekdaySaturday => '星期六';

  @override
  String get weekdaySunday => '星期日';

  @override
  String get weekdayShortMonday => '一';

  @override
  String get weekdayShortTuesday => '二';

  @override
  String get weekdayShortWednesday => '三';

  @override
  String get weekdayShortThursday => '四';

  @override
  String get weekdayShortFriday => '五';

  @override
  String get weekdayShortSaturday => '六';

  @override
  String get weekdayShortSunday => '日';

  @override
  String get monthJanuary => '1月';

  @override
  String get monthFebruary => '2月';

  @override
  String get monthMarch => '3月';

  @override
  String get monthApril => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJune => '6月';

  @override
  String get monthJuly => '7月';

  @override
  String get monthAugust => '8月';

  @override
  String get monthSeptember => '9月';

  @override
  String get monthOctober => '10月';

  @override
  String get monthNovember => '11月';

  @override
  String get monthDecember => '12月';

  @override
  String get semesterWeeksWholeTerm => '全学期';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return '第 $start-$end 周';
  }

  @override
  String semesterWeeksList(Object value) {
    return '第 $value 周';
  }

  @override
  String get generalSchedule => '通用日程';

  @override
  String get studentTimetable => '学生课表';

  @override
  String get switchMode => '切换模式';

  @override
  String get generalScheduleComingSoon => '通用日程即将上线';

  @override
  String get switchToStudentTimetable => '切换到学生课表';

  @override
  String get mySchedule => '我的日程';

  @override
  String get today => '今天';

  @override
  String get addEvent => '添加日程';

  @override
  String get editEvent => '编辑日程';

  @override
  String get eventTitle => '日程标题';

  @override
  String get eventTitleRequired => '请输入日程标题';

  @override
  String get eventStartTime => '开始时间';

  @override
  String get eventEndTime => '结束时间';

  @override
  String get eventDate => '日期';

  @override
  String get eventTime => '时间';

  @override
  String get eventNotes => '备注';

  @override
  String get eventColor => '颜色';

  @override
  String get eventRecurrence => '重复';

  @override
  String get recurrenceNone => '不重复';

  @override
  String get recurrenceWeekly => '每周';

  @override
  String get recurrenceEndDate => '结束日期';

  @override
  String get recurrenceNoEndDate => '无结束日期';

  @override
  String get recurrenceSetEndDate => '设置';

  @override
  String get recurrenceChangeEndDate => '更改';

  @override
  String get repeatsWeekly => '每周重复';

  @override
  String recurrenceUntil(Object date) {
    return '截止 $date';
  }

  @override
  String get switchToGeneralSchedule => '切换到通用日程';

  @override
  String get generalDisplaySettings => '通用显示设置';

  @override
  String get generalDisplaySettingsDesc => '通用日程页面的显示开关';

  @override
  String get closePopupOnOutsideTap => '点击外部关闭弹窗';

  @override
  String get showGridLines => '显示网格线';

  @override
  String get generalScheduleImportExport => '日程导入导出';

  @override
  String get generalScheduleImportExportDesc => '导入或分享通用日程';

  @override
  String get importGeneralSchedules => '导入日程';

  @override
  String get importGeneralSchedulesDesc => '从 JSON 文件读取日程';

  @override
  String get shareGeneralSchedules => '分享日程';

  @override
  String get shareGeneralSchedulesDesc => '以 JSON 文件分享日程';

  @override
  String get saveGeneralSchedules => '保存日程';

  @override
  String get saveGeneralSchedulesDesc => '保存为 JSON 文件';

  @override
  String get selectSchedulesToExport => '选择要导出的日程';

  @override
  String get selectSchedulesToImport => '选择要导入的日程';

  @override
  String generalScheduleEventCount(int count) {
    return '事件 $count';
  }

  @override
  String importedSchedulesCount(int count) {
    return '已导入 $count 个日程';
  }

  @override
  String get replaceActiveSchedulePrompt => '用导入的日程替换当前日程？';

  @override
  String get addAsNewSchedule => '新增';

  @override
  String get selectAtLeastOneScheduleMessage => '请至少选择一个日程。';

  @override
  String get noExportableScheduleMessage => '没有可导出的日程。';

  @override
  String get noSchedulesInImportMessage => '导入文件没有日程。';

  @override
  String get replaceActiveRequiresSingleScheduleMessage => '替换当前日程时只能选择一个日程。';

  @override
  String get noActiveScheduleToReplaceMessage => '当前没有可替换的日程。';

  @override
  String get calendars => '日历';

  @override
  String get calendar => '日历';

  @override
  String get viewWeek => '周';

  @override
  String get viewDay => '日';

  @override
  String get viewList => '列表';

  @override
  String get eventDuplicated => '已复制日程';

  @override
  String get searchEvents => '搜索日程';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get filterByColor => '按颜色筛选';

  @override
  String get allColors => '全部颜色';

  @override
  String upcomingEventsCount(int count) {
    return '即将开始 $count';
  }

  @override
  String overdueEventsCount(int count) {
    return '已过期 $count';
  }

  @override
  String get allDay => '全天';

  @override
  String moreEvents(int count) {
    return '+$count 个';
  }

  @override
  String get noMatchingEvents => '无匹配事件';

  @override
  String get noUpcomingEvents => '无即将开始事件';

  @override
  String get addCalendar => '添加日历';

  @override
  String get newCalendar => '新日历';

  @override
  String get hideCalendar => '隐藏日历';

  @override
  String get showCalendar => '显示日历';

  @override
  String get rename => '重命名';

  @override
  String get renameCalendar => '重命名日历';

  @override
  String get name => '名称';

  @override
  String get deleteCalendar => '删除日历';

  @override
  String deleteCalendarMessage(Object name) {
    return '删除“$name”？';
  }

  @override
  String get deleteThisOccurrence => '删除本次';

  @override
  String get deleteFutureOccurrences => '删除后续';

  @override
  String get deleteAllOccurrences => '删除全部';

  @override
  String get duplicateEvent => '复制';

  @override
  String get repeatsDaily => '每天重复';

  @override
  String get repeatsMonthly => '每月重复';

  @override
  String repeatsEvery(int interval, Object unit) {
    return '每 $interval $unit重复';
  }

  @override
  String recurrenceCountTimes(int count) {
    return '$count 次';
  }

  @override
  String get recurrenceDaily => '每天';

  @override
  String get recurrenceMonthly => '每月';

  @override
  String get recurrenceCustom => '自定义';

  @override
  String get recurrenceEvery => '每';

  @override
  String get recurrenceUnit => '单位';

  @override
  String get recurrenceDays => '天';

  @override
  String get recurrenceWeeks => '周';

  @override
  String get recurrenceMonths => '月';

  @override
  String get recurrenceRepeatCount => '重复次数';

  @override
  String get recurrenceNoLimit => '无限制';

  @override
  String get recurrencePositiveNumber => '请输入正数';

  @override
  String get clearEndDate => '清除结束日期';

  @override
  String get pickDate => '选择日期';

  @override
  String get pickTime => '选择时间';

  @override
  String get reminder => '应用内提醒';

  @override
  String get reminderAtStart => '开始时';

  @override
  String reminderMinutesBefore(int minutes) {
    return '提前 $minutes 分钟';
  }

  @override
  String get reminderHourBefore => '提前 1 小时';

  @override
  String get reminderDayBefore => '提前 1 天';

  @override
  String get markReminderHandled => '标记已处理';

  @override
  String get restoreReminder => '恢复应用内提醒';

  @override
  String get reminderHandled => '应用内提醒已标记处理';

  @override
  String get reminderRestored => '应用内提醒已恢复';

  @override
  String get reminderUpcoming => '即将开始';

  @override
  String get reminderOverdue => '已过期';

  @override
  String get showWeekends => '显示周末';

  @override
  String get startHour => '开始小时';

  @override
  String get endHour => '结束小时';

  @override
  String get timeGridDensity => '时间网格密度';

  @override
  String get importJsonFile => '导入 JSON 文件';

  @override
  String get pasteJson => '粘贴 JSON';

  @override
  String get importGeneralSchedulesJsonTextDesc => '从复制的 JSON 导入日历';

  @override
  String get importIcsFile => '导入 ICS 文件';

  @override
  String get importIcsFileDesc => '从 .ics 日历文件读取事件';

  @override
  String get pasteIcs => '粘贴 ICS';

  @override
  String get pasteIcsDesc => '从复制的日历文本导入事件';

  @override
  String get copyJson => '复制 JSON';

  @override
  String get copyJsonDesc => '将选中日历复制为 JSON 文本';

  @override
  String get shareIcs => '分享 ICS';

  @override
  String get shareIcsDesc => '将选中日历分享为 .ics';

  @override
  String get saveIcs => '保存 ICS';

  @override
  String get saveIcsDesc => '将选中日历保存为 .ics';

  @override
  String get copyIcs => '复制 ICS';

  @override
  String get copyIcsDesc => '将选中日历复制为 ICS 文本';

  @override
  String get importIcs => '导入 ICS';

  @override
  String get icsContent => 'ICS 内容';

  @override
  String get pasteIcsContentHint => '在这里粘贴 BEGIN:VCALENDAR 内容';

  @override
  String importIcsPreviewPrompt(int count) {
    return '发现 $count 个事件。要作为新日历导入，还是替换当前日历？';
  }

  @override
  String importedSchedulesWithWarnings(int count, int warningCount) {
    return '已导入 $count 个日程，包含 $warningCount 条提示';
  }

  @override
  String get importWarningSkippedMissingStart => '已跳过缺少开始时间的事件。';

  @override
  String get importWarningSkippedUnsupportedStart => '已跳过开始时间格式不支持的事件。';

  @override
  String get importWarningAdjustedEnd => '已修正结束时间不晚于开始时间的事件。';

  @override
  String importWarningUnsupportedFields(Object fields) {
    return '不支持的 ICS 字段已写入备注：$fields';
  }

  @override
  String importWarningUnsupportedRRuleFrequency(Object frequency) {
    return '已忽略不支持的重复频率：$frequency';
  }

  @override
  String get selectCalendarsToCopyIcs => '选择要复制为 ICS 的日历';

  @override
  String get selectCalendarsToExportIcs => '选择要导出为 ICS 的日历';

  @override
  String get exportIcsText => '导出 ICS 文本';

  @override
  String get exportJsonText => '导出 JSON 文本';

  @override
  String get dataRestoredFromBackupNotice =>
      'App data was restored from the previous backup because the main file failed to load.';

  @override
  String get dataBackupRestoreFailedNotice =>
      'Both the main data file and its backup are damaged. The app is now using a fresh state.';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return '第 $week 週';
  }

  @override
  String get addCourse => '添加課程';

  @override
  String get settings => '設定';

  @override
  String get multiTimetableSwitch => '多課表切換';

  @override
  String currentTimetableWeeks(int weeks) {
    return '當前課表 · 共 $weeks 週';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return '點擊切換 · 共 $weeks 週';
  }

  @override
  String get editTimetable => '編輯課表';

  @override
  String get createTimetable => '新建課表';

  @override
  String get jumpToWeek => '快捷跳轉週數';

  @override
  String get timetable => '課表';

  @override
  String get timetableName => '課表名稱';

  @override
  String get totalWeeks => '總週數';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get deleteTimetableTitle => '刪除課表';

  @override
  String deleteTimetableMessage(Object name) {
    return '確認刪除「$name」嗎？';
  }

  @override
  String get noTimetableTitle => '當前沒有課表';

  @override
  String get noTimetableMessage => '可以新建一個課表，或從 JSON 檔案匯入已有課表。';

  @override
  String get importTimetable => '匯入課表';

  @override
  String get courseName => '課程名稱';

  @override
  String get location => '上課地點';

  @override
  String get dayOfWeek => '上課日';

  @override
  String get semesterWeeks => '週次';

  @override
  String get startTime => '開始時間';

  @override
  String get endTime => '結束時間';

  @override
  String get linkedPeriods => '關聯節次';

  @override
  String get linkedPeriodsUnmatched => '當前時間未匹配到節次，點此手動選擇';

  @override
  String periodRangeLabel(int start, int end) {
    return '第 $start-$end 節';
  }

  @override
  String get teacherName => '老師姓名';

  @override
  String get credits => '學分';

  @override
  String get remarks => '備註';

  @override
  String get customFields => '自訂欄位';

  @override
  String get customFieldsHint => '每行一個，格式：鍵:值';

  @override
  String get selectDayOfWeek => '選擇上課日';

  @override
  String get selectSemesterWeeks => '選擇週次';

  @override
  String get selectAll => '全選';

  @override
  String get clear => '清空';

  @override
  String get confirm => '確定';

  @override
  String get selectLinkedPeriods => '選擇關聯節次';

  @override
  String get addCourseTitle => '添加課程';

  @override
  String get editCourseTitle => '編輯課程';

  @override
  String get editCourseTooltip => '編輯課程';

  @override
  String get place => '地點';

  @override
  String get time => '時間';

  @override
  String get notFilled => '未填寫';

  @override
  String get none => '無';

  @override
  String get conflictCourses => '衝突課程';

  @override
  String get locationNotFilled => '未填寫地點';

  @override
  String get setAsDisplayed => '設為外部顯示';

  @override
  String get editThisCourse => '編輯這門課';

  @override
  String get settingsTitle => '設定';

  @override
  String get noTimetableSettings => '當前沒有可設定的課表';

  @override
  String get semesterStartDate => '開學日期';

  @override
  String get periodTimeSets => '節次時間集';

  @override
  String get noPeriodTimeAvailable => '暫無可用節次時間';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count 節';
  }

  @override
  String get coursePopupDismissSetting => '允許點擊空白處關閉課程彈窗';

  @override
  String get coursePopupDismissSettingHint => '關閉後也會一併停用下拉手勢關閉，避免誤觸。';

  @override
  String get preserveTimetableGaps => '保留課表空白時間';

  @override
  String get preserveTimetableGapsHint => '關閉後會摺疊午休、下課等非上課時間，讓後續課程向上拼接。';

  @override
  String get showPastEndedCourses => '顯示已結束課程';

  @override
  String get showPastEndedCoursesHint => '顯示按真實當前週已結束的課程，並用更淺的灰色區分。';

  @override
  String get showFutureCourses => '顯示之後的課程';

  @override
  String get showFutureCoursesHint => '顯示當前週不上、但之後週次還會上的課程，並用灰色區分。';

  @override
  String get timetableDisplaySettings => '課表顯示與互動';

  @override
  String get timetableDisplaySettingsDesc => '課程彈窗、空白時間、灰色課程與網格線';

  @override
  String get showTimetableGridLines => '顯示課表網格線';

  @override
  String get showTimetableGridLinesHint => '控制課表中的橫向與縱向網格線是否顯示。';

  @override
  String get liveCourseOutlineColor => '課程描邊顏色';

  @override
  String get liveCourseOutlineColorHint => '描邊目標可選擇當前／下一節課程，或當前頁所有已顯示課程。';

  @override
  String get liveCourseOutlineSettings => '課程描邊';

  @override
  String get liveCourseOutlineSettingsHint =>
      '可設定是否開啟描邊、描邊目標、是否跟隨主題色，以及當前實際生效的描邊顏色。';

  @override
  String get liveCourseOutlineEnabled => '開啟課程描邊';

  @override
  String get liveCourseOutlineFollowTheme => '跟隨主題色';

  @override
  String get liveCourseOutlineTarget => '描邊目標';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => '當前／下一節課程';

  @override
  String get liveCourseOutlineTargetAllDisplayed => '當前頁全部課程';

  @override
  String get liveCourseOutlineEffectiveColor => '當前生效顏色';

  @override
  String get liveCourseOutlineCustomColor => '自訂描邊顏色';

  @override
  String get liveCourseOutlineWidth => '描邊寬度';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => '語言';

  @override
  String get languagePageDescription => '請選擇應用當前真正支援的語言。';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API 回應';

  @override
  String get theme => '主題';

  @override
  String get themeFollowSystem => '跟隨系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '暗黑';

  @override
  String get themeColor => '主題色';

  @override
  String get themeColorModeSingle => '單調主題色';

  @override
  String get themeColorModeColorful => '五彩繽紛';

  @override
  String get themeColorUiColors => 'UI 配色';

  @override
  String get themeColorCourseColors => '課程顏色';

  @override
  String get themeColorPrimary => '主色';

  @override
  String get themeColorSecondary => '輔色';

  @override
  String get themeColorTertiary => '強調色';

  @override
  String get themeColorCourseText => '課程文字色';

  @override
  String get themeColorCourseTextAuto => '自動配色';

  @override
  String get themeColorCourseTextCustom => '自訂顏色';

  @override
  String get themeColorCourseColorsEmpty => '匯入課表後將自動生成課程顏色';

  @override
  String get themeCustomColor => '自訂顏色';

  @override
  String get themeApplyCustomColor => '套用顏色';

  @override
  String get themeApplySettings => '套用設定';

  @override
  String get dataImportExport => '匯入匯出資料';

  @override
  String get dataImportExportDesc => '匯入整包／單課表，或匯出當前課表與全部課表';

  @override
  String get openSourceLicenses => '開源授權';

  @override
  String get openSourceLicensesDesc => '查看 Flutter 依賴與應用內建圖示資源的授權資訊';

  @override
  String get checkForUpdates => '檢查更新';

  @override
  String get checkForUpdatesDesc => 'GitHub / 官網 / Google Play / 雲端硬碟';

  @override
  String alreadyLatestVersion(Object version) {
    return '目前已是最新版本（$version）';
  }

  @override
  String get currentVersionLabel => '目前版本';

  @override
  String get newVersionAvailable => '有新版本';

  @override
  String get latestVersionLabel => '最新版本';

  @override
  String get updateContentLabel => '更新內容';

  @override
  String get officialWebsite => '官網';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => '雲端硬碟';

  @override
  String get ignoreThisVersion => '忽略此版本';

  @override
  String get openUpdatesFailed => '無法開啟更新連結';

  @override
  String get updateCheckFailedTitle => '檢查更新失敗';

  @override
  String get updateCheckFailedMessage => '無法從更新來源取得有效版本資訊。你仍可透過下方管道手動取得更新。';

  @override
  String get githubRepository => 'GitHub 倉庫';

  @override
  String get openGithubFailed => '無法開啟 GitHub 倉庫連結';

  @override
  String get selectPeriodTimeSet => '選擇節次時間集';

  @override
  String get newItem => '新建';

  @override
  String get editPeriodTimeSet => '編輯節次時間集';

  @override
  String get importTimetableFiles => '匯入課表';

  @override
  String get importTimetableFilesDesc => '支援單個或多個課表檔案';

  @override
  String get importTimetableText => '從文字匯入課表';

  @override
  String get importTimetableTextDesc => '貼上課表 JSON 內容後匯入';

  @override
  String get shareTimetableFiles => '分享課表檔案';

  @override
  String get shareTimetableFilesDesc => '先選擇一個或多個課表';

  @override
  String get saveTimetableFiles => '儲存課表檔案';

  @override
  String get saveTimetableFilesDesc => '先選擇一個或多個課表';

  @override
  String get exportTimetableText => '匯出課表為文字';

  @override
  String get exportTimetableTextDesc => '先選擇一個或多個課表，再複製 JSON 內容';

  @override
  String get jsonContent => 'JSON 內容';

  @override
  String get pasteJsonContentHint => '請貼上要匯入的 JSON 內容';

  @override
  String get jsonContentEmpty => '請先貼上 JSON 內容';

  @override
  String get copyText => '複製';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get share => '分享';

  @override
  String get selectTimetablesToExport => '選擇要匯出的課表';

  @override
  String get selectTimetablesToImport => '選擇要匯入的課表';

  @override
  String timetableCourseCount(int count) {
    return '$count 門課程';
  }

  @override
  String get importAction => '匯入';

  @override
  String get importTimetableDialogTitle => '匯入課表';

  @override
  String get chooseImportMethod => '請選擇匯入方式';

  @override
  String get importAsNewTimetable => '作為新課表匯入';

  @override
  String get replaceCurrentTimetable => '覆蓋當前課表';

  @override
  String get importPeriodTimeSetDialogTitle => '匯入節次時間集';

  @override
  String get importPeriodTimeSetDialogBody => '偵測到檔案內包含節次時間集。是否一併匯入並關聯它們？';

  @override
  String get importBundledPeriodTimeSets => '匯入並關聯';

  @override
  String get discardBundledPeriodTimeSets => '捨棄內含節次';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      '當前沒有可用節次時間集，不能捨棄檔案內節次時間集。';

  @override
  String savedToPath(Object path) {
    return '已儲存到 $path';
  }

  @override
  String get saveCancelled => '已取消儲存';

  @override
  String get fileSaveRestrictedTitle => '檔案儲存受限';

  @override
  String get fileSaveRestrictedRetryMessage => '目前系統未能完成檔案儲存。你可以重試，或改用檔案分享。';

  @override
  String get retrySave => '重試儲存';

  @override
  String get fileSaveRestrictedSettingsMessage => '請在系統設定中開啟檔案存取權限，然後返回重試匯出。';

  @override
  String get openSettings => '開啟設定';

  @override
  String get browserDownloadRestrictedTitle => '瀏覽器下載受限';

  @override
  String get browserDownloadRestrictedMessage =>
      '目前瀏覽器不支援直接儲存到本機檔案。你可以檢查瀏覽器下載權限，或改用分享檔案。';

  @override
  String get switchToShare => '改用分享';

  @override
  String get fileSaveFailedTitle => '檔案儲存失敗';

  @override
  String get fileSaveFailedWindowsMessage =>
      '無法寫入目前路徑，可能是目標資料夾受系統保護、檔案被佔用，或目前路徑不可寫入。';

  @override
  String get fileSaveFailedGenericMessage => '系統未能完成檔案儲存。你可以重試、檢查系統設定，或改用檔案分享。';

  @override
  String get retryLater => '稍後再試';

  @override
  String get exportSwitchedToShare => '已改用檔案分享匯出';

  @override
  String get saveFailedRetry => '儲存失敗，請稍後重試';

  @override
  String get importFailedCheckContent => '匯入失敗，請檢查檔案內容';

  @override
  String get noImportableTimetables => '匯入檔案中沒有可用課表';

  @override
  String importedTimetablesCount(int count) {
    return '已匯入 $count 個課表';
  }

  @override
  String get periodTimesTitle => '節次時間';

  @override
  String get importExport => '匯入匯出';

  @override
  String get importPeriodTemplate => '匯入節次範本';

  @override
  String get importPeriodTemplateText => '從文字匯入節次範本';

  @override
  String get sharePeriodTemplate => '分享節次範本';

  @override
  String get saveTemplateToFile => '儲存範本到檔案';

  @override
  String get exportPeriodTemplateText => '匯出節次範本為文字';

  @override
  String get deletePeriodTimeSet => '刪除節次時間';

  @override
  String get periodTimeSetName => '節次時間名稱';

  @override
  String get addOnePeriod => '增加一節';

  @override
  String periodNumberLabel(int index) {
    return '第 $index 節';
  }

  @override
  String get deleteThisPeriod => '刪除本節';

  @override
  String durationMinutes(int minutes) {
    return '時長 $minutes 分鐘';
  }

  @override
  String gapFromPrevious(int minutes) {
    return '與上一節間隔 $minutes 分鐘';
  }

  @override
  String get endTimeMustBeLater => '結束時間必須晚於開始時間';

  @override
  String get periodOverlapPrevious => '當前節次與上一節時間重疊';

  @override
  String get periodTimesSaved => '已儲存節次時間';

  @override
  String get deletePeriodTimeSetTitle => '刪除節次時間';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return '確認刪除「$name」嗎？';
  }

  @override
  String get currentPeriodTimeSet => '當前節次時間';

  @override
  String importedPeriodTimesCount(int count) {
    return '已匯入 $count 條節次時間';
  }

  @override
  String get periodFilePermissionTitle => '需要檔案權限';

  @override
  String get androidFilePermissionMessage => 'Android 匯出需要檔案存取權限，請授權後繼續儲存。';

  @override
  String get reauthorize => '重新授權';

  @override
  String get permissionPermanentlyDeniedTitle => '權限已被永久拒絕';

  @override
  String get permissionSettingsExportMessage => '請在系統設定中開啟檔案存取權限，然後再回來重試匯出。';

  @override
  String get privacyPolicyTitle => '隱私政策';

  @override
  String get privacyPolicyEntryDesc => '了解應用如何處理本機儲存、學校站點設定、檔案匯入匯出、網頁解析和外部連結。';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return '已同意版本：$version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked 為本地優先的課程表工具。課表資料、節次時間集和學校站點設定僅保存在你的裝置或瀏覽器本機，不會自動上傳。應用僅在你主動觸發匯入、網頁解析、分享或開啟外部連結等操作時才會處理對應內容。完整隱私政策可於線上查看。';

  @override
  String get privacyPolicyLocalStorageTitle => '本機儲存';

  @override
  String get privacyPolicyLocalStorageBody =>
      '課表資料和相關設定會儲存在應用文件目錄中的本機檔案 Sked_data.json，可編輯的學校站點設定會單獨儲存在 Sked_school_sites.json。自訂課表解析設定中填寫的 Base URL、API 金鑰和所選模型也會隨同應用資料儲存在本機，目前實作不會使用系統安全憑證庫進行保護。若在瀏覽器中使用，同類資料會儲存在瀏覽器本機儲存中。應用不會自動把這些本機資料上傳到開發者控制的伺服器。';

  @override
  String get privacyPolicyImportExportTitle => '匯入與匯出';

  @override
  String get privacyPolicyImportExportBody =>
      '只有在你主動選擇檔案或主動執行匯出時，應用才會讀取或寫出 JSON 課表檔案、學校站點 JSON 檔案和節次範本檔案。這些檔案的匯入匯出本身屬於本機操作；只有當你進一步選擇網頁解析時，相關頁面內容才會被發送到你設定的解析介面。取得自訂模型清單同樣屬於你主動觸發的連網操作，並且只會請求你填寫的自訂介面。';

  @override
  String get privacyPolicySharingTitle => '分享功能';

  @override
  String get privacyPolicySharingBody =>
      '當你主動使用分享功能時，應用會把你選中的匯出檔案交給系統分享面板或目標應用。後續如何處理該檔案，由你選擇的目標應用或服務自行決定。';

  @override
  String get privacyPolicyExternalLinksTitle => '外部連結';

  @override
  String get privacyPolicyExternalLinksBody =>
      '當你主動開啟 GitHub 倉庫等外部連結時，應用會呼叫系統瀏覽器或其他外部應用。離開應用後的資料處理將受對應第三方的政策約束。';

  @override
  String get privacyPolicyNoCollectionTitle => '不會收集的內容';

  @override
  String get privacyPolicyNoCollectionBody =>
      '應用不要求你註冊 Sked 帳號，也不會啟用分析統計、廣告識別碼或雲端備份。應用本身也沒有專門用於收集學校帳號密碼的輸入欄位；如果你在應用內開啟的學校網頁中登入，該互動發生在你造訪的學校頁面內。';

  @override
  String get privacyPolicyFutureFeatureTitle => '網頁解析';

  @override
  String get privacyPolicyFutureFeatureBody =>
      '當你使用學校網頁匯入或貼上 HTML 進行解析時，應用會先在本機壓縮內容，再把你提交的頁面內容、可選的頁面標題與 URL、當前應用語言以及解析提示詞發送到當前選擇的解析介面。如果你使用官方解析，請求會發往應用設定的官方後端；如果你啟用自訂 OpenAI 相容解析，同樣的內容會直接發送到你填寫的第三方介面，取得模型清單時也會請求該第三方介面。自訂介面還可能按照其自身設計繼續把請求轉發給其他 AI 服務。目前官方後端會限制單次提交內容不得大於 300KB，使用其設定的請求逾時時間，並按 IP 每天最多解析 5 次。';

  @override
  String get privacyPolicyUpdatesTitle => '政策更新';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return '目前隱私政策版本為 $version。如果後續版本調整了資料處理方式，應用可能會要求你重新閱讀並同意更新後的隱私政策。';
  }

  @override
  String get privacyGateTitle => '使用前請先同意隱私政策';

  @override
  String get privacyGateSummaryStorage =>
      '課表、節次時間集和學校站點設定只會儲存在本機，不會自動上傳到開發者伺服器。';

  @override
  String get privacyGateSummaryImportExport =>
      '匯入、匯出和分享僅在你主動操作時觸發；網頁解析只會發送你主動提交的壓縮後內容，並在儲存前讓你預覽解析結果。';

  @override
  String get privacyGateSummaryUpdates =>
      '如果後續版本調整了資料處理方式，應用可能會要求你重新查看更新後的隱私政策。';

  @override
  String get schoolWebImportEntry => '從學校網頁匯入';

  @override
  String get schoolWebImportEntryDesc => '進入學校網站後匯入當前課表頁。';

  @override
  String get schoolSitesManageEntry => '學校站點管理';

  @override
  String get schoolSitesManageEntryDesc => '新增、編輯、刪除學校登入地址，並支援 JSON 匯入匯出。';

  @override
  String get schoolSitesPageTitle => '學校站點管理';

  @override
  String get schoolSitesImportJson => '匯入學校 JSON';

  @override
  String get schoolSitesShareJson => '分享學校 JSON';

  @override
  String get schoolSitesSaveJson => '儲存學校 JSON';

  @override
  String get schoolSitesSaved => '學校站點已儲存';

  @override
  String get schoolSitesImported => '學校站點已匯入';

  @override
  String get schoolSitesEmpty => '當前還沒有學校站點設定。';

  @override
  String get schoolSitesNameLabel => '學校名稱';

  @override
  String get schoolSitesLoginUrlLabel => '登入頁連結';

  @override
  String get schoolSitesAdd => '新增學校';

  @override
  String get schoolSitesEdit => '編輯學校';

  @override
  String get schoolSitesDeleteTitle => '刪除學校';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return '確認刪除「$name」嗎？';
  }

  @override
  String get schoolSitesFormInvalid => '請完整填寫學校名稱和登入頁連結。';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry => '貼上課程表頁面內容匯入';

  @override
  String get schoolHtmlImportEntryDesc => '手動貼上包含課程資訊的頁面原始碼或原始內容。';

  @override
  String get schoolHtmlImportPageTitle => '解析課表頁面內容';

  @override
  String get schoolHtmlImportUrlLabel => '來源 URL（可選）';

  @override
  String get schoolHtmlImportTitleLabel => '頁面標題（可選）';

  @override
  String get schoolHtmlImportHtmlLabel => '頁面內容';

  @override
  String get schoolHtmlImportHtmlHint => '請貼上包含課程資訊的頁面原始碼或原始內容。';

  @override
  String get schoolHtmlImportNonHtmlHint => '只要內容裡包含課程資訊，就可以解析匯入，不限於 HTML。';

  @override
  String get schoolHtmlImportCompress => '壓縮內容';

  @override
  String get schoolHtmlImportCompressed => '內容已壓縮';

  @override
  String get schoolHtmlImportCompressFirst => '請先壓縮內容。';

  @override
  String get schoolHtmlImportSubmit => '解析並匯入';

  @override
  String get schoolHtmlImportParsingMayTakeLong => '解析時間可能較長，請耐心等待。';

  @override
  String get schoolHtmlImportEmpty => '請先貼上網頁 HTML。';

  @override
  String get schoolHtmlImportReturnToWebPage => '返回網頁';

  @override
  String get schoolWebImportPageTitle => '學校網頁匯入';

  @override
  String get schoolWebImportPreview => '匯入預覽';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count 門課程';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count 節';
  }

  @override
  String get schoolWebImportPageTitleLabel => '頁面標題';

  @override
  String get schoolWebImportParserUsed => '解析器';

  @override
  String get schoolWebImportWarnings => '匯入提示';

  @override
  String get schoolWebImportOpenPageHint => '請在應用內登入學校網站，並手動切換到課表頁。';

  @override
  String get schoolWebImportConfigMissing => '尚未設定網頁匯入後端介面地址。';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      '當前平台暫不支援內嵌網頁登入，請在支援 WebView 的平台上使用。';

  @override
  String get schoolWebImportSelectSchool => '選擇學校';

  @override
  String get schoolWebImportNoSchools => '當前沒有可用學校設定，請先檢查 school_sites.json。';

  @override
  String get schoolWebImportSchoolLoadFailed => '學校設定載入失敗，請檢查 JSON 檔案格式。';

  @override
  String get schoolWebImportImportCurrentPage => '匯入目前頁面';

  @override
  String get schoolWebImportGoBack => '上一頁';

  @override
  String get schoolWebImportLoadingPage => '頁面載入中…';

  @override
  String get schoolWebImportParsing => '正在解析目前頁面…';

  @override
  String get schoolWebImportLoadFailed => '頁面載入失敗，請重新整理後重試。';

  @override
  String get schoolWebImportLoadTimedOut => '頁面載入逾時，請重新整理後重試。';

  @override
  String get schoolWebImportEmptyPage => '當前頁面內容為空，暫時無法匯入。';

  @override
  String get schoolWebImportSuccess => '網頁課表已匯入';

  @override
  String get schoolImportParserSettingsTitle => '課表解析設定';

  @override
  String get schoolImportParserSettingsDesc => '選擇官方解析，或改用自訂 OpenAI 相容介面。';

  @override
  String get schoolImportParserSourceTitle => '解析來源';

  @override
  String get schoolImportParserSourceOfficial => '官方解析';

  @override
  String get schoolImportParserSourceOfficialDesc => '使用應用內設定的官方解析服務。';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      '官方解析會繼續使用應用當前設定的解析後端，並保持現有匯入流程不變。';

  @override
  String get schoolImportParserSourceCustomOpenAi => '自訂 OpenAI 相容介面';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      '把頁面內容直接發送到你自己的 OpenAI 相容端點。';

  @override
  String get schoolImportParserCustomOpenAi => '自訂 OpenAI 相容解析';

  @override
  String get schoolImportParserCustomPromptTitle => '自訂提示詞';

  @override
  String get schoolImportParserCustomPromptDescription =>
      '可直接在這裡修改內建解析提示詞，且僅對自訂 OpenAI 相容介面生效。';

  @override
  String get schoolImportParserCustomPromptHint => '這裡預設會載入內建提示詞；清空後會回退為內建版本。';

  @override
  String get schoolImportParserResetDefaultPrompt => '重設預設提示詞';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API 金鑰';

  @override
  String get schoolImportParserModel => '模型名稱';

  @override
  String get schoolImportParserFetchModels => '取得模型清單';

  @override
  String get schoolImportParserFetchingModels => '正在取得模型清單...';

  @override
  String get schoolImportParserNoModelsFound => '該端點沒有回傳任何模型。';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '已取得 $count 個模型';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      '目前實作下，自訂 API 金鑰會以明文形式儲存在應用本機設定中。請僅在你信任的裝置或瀏覽器環境中使用。';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      '自訂解析設定不完整，請先填寫 Base URL、API 金鑰和模型名稱。';

  @override
  String get schoolImportParserCurrentSourceOfficial => '解析器：官方';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return '解析器：自訂（$model）';
  }

  @override
  String get privacyViewFullPolicy => '查看完整隱私政策';

  @override
  String get privacyAgreeAndContinue => '同意並繼續';

  @override
  String get privacyDecline => '不同意';

  @override
  String get privacyDeclineWebHint => '目前瀏覽器環境無法由應用主動關閉頁面。若你不同意，請直接關閉此分頁或視窗。';

  @override
  String get defaultPeriodTimeSetName => '預設節次';

  @override
  String get periodTimeSetFallbackName => '節次時間';

  @override
  String get untitledTimetableName => '未命名課表';

  @override
  String get newTimetableName => '新課表';

  @override
  String get newPeriodTimeSetName => '新節次時間';

  @override
  String get emptyTimetableName => '空課表';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name 節次';
  }

  @override
  String get importFileTypeMismatchMessage => '匯入檔案類型不匹配';

  @override
  String get importFileVersionUnsupportedMessage => '匯入檔案版本暫不支援';

  @override
  String get noPeriodTimesInImportMessage => '匯入檔案中沒有節次時間';

  @override
  String get selectAtLeastOneTimetableMessage => '請選擇至少一個課表';

  @override
  String get noExportableTimetableMessage => '當前沒有可匯出的課表';

  @override
  String get replaceActiveRequiresSingleTimetableMessage => '覆蓋當前課表時只能選擇一個課表';

  @override
  String get noActiveTimetableToReplaceMessage => '當前沒有可覆蓋的課表';

  @override
  String periodTimeSetInUseMessage(int count) {
    return '該節次時間仍被 $count 個課表使用，請先改關聯再刪除';
  }

  @override
  String get weekdayMonday => '星期一';

  @override
  String get weekdayTuesday => '星期二';

  @override
  String get weekdayWednesday => '星期三';

  @override
  String get weekdayThursday => '星期四';

  @override
  String get weekdayFriday => '星期五';

  @override
  String get weekdaySaturday => '星期六';

  @override
  String get weekdaySunday => '星期日';

  @override
  String get weekdayShortMonday => '一';

  @override
  String get weekdayShortTuesday => '二';

  @override
  String get weekdayShortWednesday => '三';

  @override
  String get weekdayShortThursday => '四';

  @override
  String get weekdayShortFriday => '五';

  @override
  String get weekdayShortSaturday => '六';

  @override
  String get weekdayShortSunday => '日';

  @override
  String get monthJanuary => '1月';

  @override
  String get monthFebruary => '2月';

  @override
  String get monthMarch => '3月';

  @override
  String get monthApril => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJune => '6月';

  @override
  String get monthJuly => '7月';

  @override
  String get monthAugust => '8月';

  @override
  String get monthSeptember => '9月';

  @override
  String get monthOctober => '10月';

  @override
  String get monthNovember => '11月';

  @override
  String get monthDecember => '12月';

  @override
  String get semesterWeeksWholeTerm => '全學期';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return '第 $start-$end 週';
  }

  @override
  String semesterWeeksList(Object value) {
    return '第 $value 週';
  }

  @override
  String get generalSchedule => '通用日程';

  @override
  String get studentTimetable => '學生課表';

  @override
  String get switchMode => '切換模式';

  @override
  String get generalScheduleComingSoon => '通用日程即將上線';

  @override
  String get switchToStudentTimetable => '切換到學生課表';

  @override
  String get mySchedule => '我的日程';

  @override
  String get today => '今天';

  @override
  String get addEvent => '新增日程';

  @override
  String get editEvent => '編輯日程';

  @override
  String get eventTitle => '標題';

  @override
  String get eventTitleRequired => '請輸入日程標題';

  @override
  String get eventStartTime => '開始時間';

  @override
  String get eventEndTime => '結束時間';

  @override
  String get eventDate => '日期';

  @override
  String get eventTime => '時間';

  @override
  String get eventNotes => '備註';

  @override
  String get eventColor => '顏色';

  @override
  String get eventRecurrence => '重複';

  @override
  String get recurrenceNone => '不重複';

  @override
  String get recurrenceWeekly => '每週';

  @override
  String get recurrenceEndDate => '結束日期';

  @override
  String get recurrenceNoEndDate => '無結束日期';

  @override
  String get recurrenceSetEndDate => '設定';

  @override
  String get recurrenceChangeEndDate => '更改';

  @override
  String get repeatsWeekly => '每週重複';

  @override
  String recurrenceUntil(Object date) {
    return '截止 $date';
  }

  @override
  String get switchToGeneralSchedule => '切換到通用日程';

  @override
  String get generalDisplaySettings => '通用顯示設定';

  @override
  String get generalDisplaySettingsDesc => '通用日程頁面的顯示開關';

  @override
  String get closePopupOnOutsideTap => '點擊外部關閉彈窗';

  @override
  String get showGridLines => '顯示格線';

  @override
  String get generalScheduleImportExport => '日程匯入匯出';

  @override
  String get generalScheduleImportExportDesc => '匯入或分享通用日程';

  @override
  String get importGeneralSchedules => '匯入日程';

  @override
  String get importGeneralSchedulesDesc => '從 JSON 檔案讀取日程';

  @override
  String get shareGeneralSchedules => '分享日程';

  @override
  String get shareGeneralSchedulesDesc => '以 JSON 檔案分享日程';

  @override
  String get saveGeneralSchedules => '儲存日程';

  @override
  String get saveGeneralSchedulesDesc => '儲存為 JSON 檔案';

  @override
  String get selectSchedulesToExport => '選擇要匯出的日程';

  @override
  String get selectSchedulesToImport => '選擇要匯入的日程';

  @override
  String generalScheduleEventCount(int count) {
    return '事件 $count';
  }

  @override
  String importedSchedulesCount(int count) {
    return '已匯入 $count 個日程';
  }

  @override
  String get replaceActiveSchedulePrompt => '用匯入的日程取代目前日程？';

  @override
  String get addAsNewSchedule => '新增';

  @override
  String get selectAtLeastOneScheduleMessage => '請至少選擇一個日程。';

  @override
  String get noExportableScheduleMessage => '沒有可匯出的日程。';

  @override
  String get noSchedulesInImportMessage => '匯入檔案沒有日程。';

  @override
  String get replaceActiveRequiresSingleScheduleMessage => '取代目前日程時只能選擇一個日程。';

  @override
  String get noActiveScheduleToReplaceMessage => '目前沒有可取代的日程。';

  @override
  String get calendars => '日曆';

  @override
  String get calendar => '日曆';

  @override
  String get viewWeek => '週';

  @override
  String get viewDay => '日';

  @override
  String get viewList => '列表';

  @override
  String get eventDuplicated => '已複製日程';

  @override
  String get searchEvents => '搜尋日程';

  @override
  String get clearSearch => '清除搜尋';

  @override
  String get filterByColor => '按顏色篩選';

  @override
  String get allColors => '全部顏色';

  @override
  String upcomingEventsCount(int count) {
    return '即將開始 $count';
  }

  @override
  String overdueEventsCount(int count) {
    return '已逾期 $count';
  }

  @override
  String get allDay => '全天';

  @override
  String moreEvents(int count) {
    return '+$count 個';
  }

  @override
  String get noMatchingEvents => '無匹配事件';

  @override
  String get noUpcomingEvents => '無即將開始事件';

  @override
  String get addCalendar => '新增日曆';

  @override
  String get newCalendar => '新日曆';

  @override
  String get hideCalendar => '隱藏日曆';

  @override
  String get showCalendar => '顯示日曆';

  @override
  String get rename => '重新命名';

  @override
  String get renameCalendar => '重新命名日曆';

  @override
  String get name => '名稱';

  @override
  String get deleteCalendar => '刪除日曆';

  @override
  String deleteCalendarMessage(Object name) {
    return '刪除「$name」？';
  }

  @override
  String get deleteThisOccurrence => '刪除本次';

  @override
  String get deleteFutureOccurrences => '刪除後續';

  @override
  String get deleteAllOccurrences => '刪除全部';

  @override
  String get duplicateEvent => '複製';

  @override
  String get repeatsDaily => '每天重複';

  @override
  String get repeatsMonthly => '每月重複';

  @override
  String repeatsEvery(int interval, Object unit) {
    return '每 $interval $unit重複';
  }

  @override
  String recurrenceCountTimes(int count) {
    return '$count 次';
  }

  @override
  String get recurrenceDaily => '每天';

  @override
  String get recurrenceMonthly => '每月';

  @override
  String get recurrenceCustom => '自訂';

  @override
  String get recurrenceEvery => '每';

  @override
  String get recurrenceUnit => '單位';

  @override
  String get recurrenceDays => '天';

  @override
  String get recurrenceWeeks => '週';

  @override
  String get recurrenceMonths => '月';

  @override
  String get recurrenceRepeatCount => '重複次數';

  @override
  String get recurrenceNoLimit => '無限制';

  @override
  String get recurrencePositiveNumber => '請輸入正數';

  @override
  String get clearEndDate => '清除結束日期';

  @override
  String get pickDate => '選擇日期';

  @override
  String get pickTime => '選擇時間';

  @override
  String get reminder => '應用內提醒';

  @override
  String get reminderAtStart => '開始時';

  @override
  String reminderMinutesBefore(int minutes) {
    return '提前 $minutes 分鐘';
  }

  @override
  String get reminderHourBefore => '提前 1 小時';

  @override
  String get reminderDayBefore => '提前 1 天';

  @override
  String get markReminderHandled => '標記已處理';

  @override
  String get restoreReminder => '恢復應用內提醒';

  @override
  String get reminderHandled => '應用內提醒已標記處理';

  @override
  String get reminderRestored => '應用內提醒已恢復';

  @override
  String get reminderUpcoming => '即將開始';

  @override
  String get reminderOverdue => '已逾期';

  @override
  String get showWeekends => '顯示週末';

  @override
  String get startHour => '開始小時';

  @override
  String get endHour => '結束小時';

  @override
  String get timeGridDensity => '時間格線密度';

  @override
  String get importJsonFile => '匯入 JSON 檔案';

  @override
  String get pasteJson => '貼上 JSON';

  @override
  String get importGeneralSchedulesJsonTextDesc => '從複製的 JSON 匯入日曆';

  @override
  String get importIcsFile => '匯入 ICS 檔案';

  @override
  String get importIcsFileDesc => '從 .ics 日曆檔案讀取事件';

  @override
  String get pasteIcs => '貼上 ICS';

  @override
  String get pasteIcsDesc => '從複製的日曆文字匯入事件';

  @override
  String get copyJson => '複製 JSON';

  @override
  String get copyJsonDesc => '將選取日曆複製為 JSON 文字';

  @override
  String get shareIcs => '分享 ICS';

  @override
  String get shareIcsDesc => '將選取日曆分享為 .ics';

  @override
  String get saveIcs => '儲存 ICS';

  @override
  String get saveIcsDesc => '將選取日曆儲存為 .ics';

  @override
  String get copyIcs => '複製 ICS';

  @override
  String get copyIcsDesc => '將選取日曆複製為 ICS 文字';

  @override
  String get importIcs => '匯入 ICS';

  @override
  String get icsContent => 'ICS 內容';

  @override
  String get pasteIcsContentHint => '在這裡貼上 BEGIN:VCALENDAR 內容';

  @override
  String importIcsPreviewPrompt(int count) {
    return '發現 $count 個事件。要作為新日曆匯入，還是取代目前日曆？';
  }

  @override
  String importedSchedulesWithWarnings(int count, int warningCount) {
    return '已匯入 $count 個日程，包含 $warningCount 條提示';
  }

  @override
  String get importWarningSkippedMissingStart => '已跳過缺少開始時間的事件。';

  @override
  String get importWarningSkippedUnsupportedStart => '已跳過開始時間格式不支援的事件。';

  @override
  String get importWarningAdjustedEnd => '已修正結束時間不晚於開始時間的事件。';

  @override
  String importWarningUnsupportedFields(Object fields) {
    return '不支援的 ICS 欄位已寫入備註：$fields';
  }

  @override
  String importWarningUnsupportedRRuleFrequency(Object frequency) {
    return '已忽略不支援的重複頻率：$frequency';
  }

  @override
  String get selectCalendarsToCopyIcs => '選擇要複製為 ICS 的日曆';

  @override
  String get selectCalendarsToExportIcs => '選擇要匯出為 ICS 的日曆';

  @override
  String get exportIcsText => '匯出 ICS 文字';

  @override
  String get exportJsonText => '匯出 JSON 文字';

  @override
  String get dataRestoredFromBackupNotice =>
      'App data was restored from the previous backup because the main file failed to load.';

  @override
  String get dataBackupRestoreFailedNotice =>
      'Both the main data file and its backup are damaged. The app is now using a fresh state.';
}
