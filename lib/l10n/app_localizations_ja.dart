// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Classmate';

  @override
  String weekLabel(int week) {
    return '第$week週';
  }

  @override
  String get addCourse => '授業を追加';

  @override
  String get settings => '設定';

  @override
  String get multiTimetableSwitch => '時間割を切り替え';

  @override
  String currentTimetableWeeks(int weeks) {
    return '現在の時間割 · $weeks週';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'タップして切り替え · $weeks週';
  }

  @override
  String get editTimetable => '時間割を編集';

  @override
  String get createTimetable => '新しい時間割';

  @override
  String get jumpToWeek => '週へ移動';

  @override
  String get timetable => '時間割';

  @override
  String get timetableName => '時間割名';

  @override
  String get totalWeeks => '総週数';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get deleteTimetableTitle => '時間割を削除';

  @override
  String deleteTimetableMessage(Object name) {
    return '\"$name\"を削除しますか？';
  }

  @override
  String get noTimetableTitle => '時間割がありません';

  @override
  String get noTimetableMessage => '時間割を作成するか、JSONファイルからインポートしてください。';

  @override
  String get importTimetable => '時間割をインポート';

  @override
  String get courseName => '授業名';

  @override
  String get location => '場所';

  @override
  String get dayOfWeek => '曜日';

  @override
  String get semesterWeeks => '週';

  @override
  String get startTime => '開始時刻';

  @override
  String get endTime => '終了時刻';

  @override
  String get linkedPeriods => '連携時限';

  @override
  String get linkedPeriodsUnmatched => '現在の時刻に一致する時限がありません。手動で選択してください。';

  @override
  String periodRangeLabel(int start, int end) {
    return '$start〜$end限';
  }

  @override
  String get teacherName => '担当教員';

  @override
  String get credits => '単位数';

  @override
  String get remarks => '備考';

  @override
  String get customFields => 'カスタム項目';

  @override
  String get customFieldsHint => '1行に1件、形式: key:value';

  @override
  String get selectDayOfWeek => '曜日を選択';

  @override
  String get selectSemesterWeeks => '週を選択';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get clear => 'クリア';

  @override
  String get confirm => '確認';

  @override
  String get selectLinkedPeriods => '連携時限を選択';

  @override
  String get addCourseTitle => '授業を追加';

  @override
  String get editCourseTitle => '授業を編集';

  @override
  String get editCourseTooltip => '授業を編集';

  @override
  String get place => '場所';

  @override
  String get time => '時間';

  @override
  String get notFilled => '未入力';

  @override
  String get none => 'なし';

  @override
  String get conflictCourses => '重複している授業';

  @override
  String get locationNotFilled => '場所が未入力です';

  @override
  String get setAsDisplayed => '表示中として設定';

  @override
  String get editThisCourse => 'この授業を編集';

  @override
  String get settingsTitle => '設定';

  @override
  String get noTimetableSettings => '設定できる時間割が現在ありません。';

  @override
  String get semesterStartDate => '学期開始日';

  @override
  String get periodTimeSets => '時限時間セット';

  @override
  String get noPeriodTimeAvailable => '利用可能な時限時間セットがありません';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count時限';
  }

  @override
  String get coursePopupDismissSetting => '外側をタップして授業ポップアップを閉じる';

  @override
  String get coursePopupDismissSettingHint => 'オフにすると、下にスワイプして閉じる操作も無効になります。';

  @override
  String get preserveTimetableGaps => '時間割の空き時間を保持';

  @override
  String get preserveTimetableGapsHint =>
      'オフにすると、昼休みや休憩の空白が詰められ、後ろの授業が上に移動します。';

  @override
  String get showPastEndedCourses => '終了済みの授業を表示';

  @override
  String get showPastEndedCoursesHint => '実際の現在週ですでに終了している授業を、より薄いグレーで表示します。';

  @override
  String get showFutureCourses => '今後の授業を表示';

  @override
  String get showFutureCoursesHint => '今週は開講していないが後の週に表示される授業を、グレーで表示します。';

  @override
  String get timetableDisplaySettings => '時間割の表示と操作';

  @override
  String get timetableDisplaySettingsDesc => 'ポップアップの閉じ方、空き時間、グレー表示の授業、グリッド線';

  @override
  String get showTimetableGridLines => '時間割のグリッド線を表示';

  @override
  String get showTimetableGridLinesHint => '時間割の横線・縦線を表示するかどうかを設定します。';

  @override
  String get liveCourseOutlineColor => '授業の枠線色';

  @override
  String get liveCourseOutlineColorHint =>
      '枠線の対象を現在/次の授業にするか、このページに表示中のすべての授業にするかを選びます。';

  @override
  String get liveCourseOutlineSettings => '授業の枠線';

  @override
  String get liveCourseOutlineSettingsHint =>
      '枠線を有効にするか、対象、テーマ色に合わせるか、実際の枠線色を設定します。';

  @override
  String get liveCourseOutlineEnabled => '枠線を有効化';

  @override
  String get liveCourseOutlineFollowTheme => 'テーマ色に合わせる';

  @override
  String get liveCourseOutlineTarget => '枠線の対象';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => '現在/次の授業';

  @override
  String get liveCourseOutlineTargetAllDisplayed => '表示中のすべての授業';

  @override
  String get liveCourseOutlineEffectiveColor => '適用中の色';

  @override
  String get liveCourseOutlineCustomColor => 'カスタム枠線色';

  @override
  String get liveCourseOutlineWidth => '枠線の太さ';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => '言語';

  @override
  String get languagePageDescription => 'アプリで実際に利用できる言語を選択してください。';

  @override
  String get languageChinese => '中国語';

  @override
  String get languageEnglish => '英語';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/classmate';

  @override
  String get apiResponseTitle => 'APIレスポンス';

  @override
  String get theme => 'テーマ';

  @override
  String get themeFollowSystem => 'システムに合わせる';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeColor => 'テーマカラー';

  @override
  String get themeColorModeSingle => '単色テーマカラー';

  @override
  String get themeColorModeColorful => 'カラフル';

  @override
  String get themeColorUiColors => 'UIカラー';

  @override
  String get themeColorCourseColors => '授業カラー';

  @override
  String get themeColorPrimary => 'プライマリ';

  @override
  String get themeColorSecondary => 'セカンダリ';

  @override
  String get themeColorTertiary => 'ターシャリ';

  @override
  String get themeColorCourseText => '授業テキスト';

  @override
  String get themeColorCourseTextAuto => '自動';

  @override
  String get themeColorCourseTextCustom => 'カスタム色';

  @override
  String get themeColorCourseColorsEmpty => '時間割をインポートすると授業カラーが生成されます。';

  @override
  String get themeCustomColor => 'カスタム色';

  @override
  String get themeApplyCustomColor => '色を適用';

  @override
  String get themeApplySettings => '設定を適用';

  @override
  String get dataImportExport => 'データのインポートとエクスポート';

  @override
  String get dataImportExportDesc =>
      '全データまたは単一の時間割をインポート、または現在/すべての時間割をエクスポートします。';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get openSourceLicensesDesc => 'Flutter依存関係と同梱アプリアイコン素材のライセンスを表示します。';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get checkForUpdatesDesc => 'GitHub / 公式サイト / Google Play / クラウドドライブ';

  @override
  String alreadyLatestVersion(Object version) {
    return 'すでに最新バージョンです ($version)';
  }

  @override
  String get currentVersionLabel => '現在のバージョン';

  @override
  String get newVersionAvailable => 'アップデートがあります';

  @override
  String get latestVersionLabel => '最新バージョン';

  @override
  String get updateContentLabel => '更新内容';

  @override
  String get officialWebsite => '公式サイト';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'クラウドドライブ';

  @override
  String get ignoreThisVersion => 'このバージョンを無視';

  @override
  String get openUpdatesFailed => 'アップデートリンクを開けませんでした';

  @override
  String get updateCheckFailedTitle => 'アップデート確認に失敗しました';

  @override
  String get updateCheckFailedMessage =>
      'どの更新元からも有効な更新情報を取得できませんでした。以下のリンクから手動で更新することはできます。';

  @override
  String get githubRepository => 'GitHubリポジトリ';

  @override
  String get openGithubFailed => 'GitHubリポジトリのリンクを開けませんでした';

  @override
  String get selectPeriodTimeSet => '時限時間セットを選択';

  @override
  String get newItem => '新規';

  @override
  String get editPeriodTimeSet => '時限時間セットを編集';

  @override
  String get importTimetableFiles => '時間割をインポート';

  @override
  String get importTimetableFilesDesc => '1つまたは複数の時間割ファイルに対応しています。';

  @override
  String get importTimetableText => 'テキストから時間割をインポート';

  @override
  String get importTimetableTextDesc => '時間割JSONの内容を貼り付けてインポートします。';

  @override
  String get shareTimetableFiles => '時間割ファイルを共有';

  @override
  String get shareTimetableFilesDesc => '先に1つ以上の時間割を選択してください。';

  @override
  String get saveTimetableFiles => '時間割ファイルを保存';

  @override
  String get saveTimetableFilesDesc => '先に1つ以上の時間割を選択してください。';

  @override
  String get exportTimetableText => '時間割をテキストでエクスポート';

  @override
  String get exportTimetableTextDesc => '1つ以上の時間割を選択してから、JSON内容をコピーします。';

  @override
  String get jsonContent => 'JSON内容';

  @override
  String get pasteJsonContentHint => 'インポートするJSON内容を貼り付けてください。';

  @override
  String get jsonContentEmpty => '先にJSON内容を貼り付けてください。';

  @override
  String get copyText => 'コピー';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get share => '共有';

  @override
  String get selectTimetablesToExport => 'エクスポートする時間割を選択';

  @override
  String get selectTimetablesToImport => 'インポートする時間割を選択';

  @override
  String timetableCourseCount(int count) {
    return '$count件の授業';
  }

  @override
  String get importAction => 'インポート';

  @override
  String get importTimetableDialogTitle => '時間割をインポート';

  @override
  String get chooseImportMethod => 'インポート方法を選択してください。';

  @override
  String get importAsNewTimetable => '新しい時間割としてインポート';

  @override
  String get replaceCurrentTimetable => '現在の時間割を置き換え';

  @override
  String get importPeriodTimeSetDialogTitle => '時限時間セットをインポート';

  @override
  String get importPeriodTimeSetDialogBody =>
      'このファイルには同梱の時限時間セットが含まれています。インポートして関連付けますか？';

  @override
  String get importBundledPeriodTimeSets => 'インポートして関連付け';

  @override
  String get discardBundledPeriodTimeSets => '同梱セットを破棄';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      '既存の時限時間セットがないため、同梱の時限時間セットを破棄できません。';

  @override
  String savedToPath(Object path) {
    return '$path に保存しました';
  }

  @override
  String get saveCancelled => '保存をキャンセルしました';

  @override
  String get fileSaveRestrictedTitle => 'ファイル保存が制限されています';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'システムがファイルを保存できませんでした。再試行するか、代わりに共有を使用してください。';

  @override
  String get retrySave => 'もう一度保存';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'システム設定でファイルアクセスを有効にしてから戻り、再度エクスポートしてください。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get browserDownloadRestrictedTitle => 'ブラウザでのダウンロードが制限されています';

  @override
  String get browserDownloadRestrictedMessage =>
      'このブラウザではローカルファイルへ直接保存できません。ブラウザのダウンロード権限を確認するか、代わりにファイル共有を使用してください。';

  @override
  String get switchToShare => '代わりに共有を使う';

  @override
  String get fileSaveFailedTitle => 'ファイルの保存に失敗しました';

  @override
  String get fileSaveFailedWindowsMessage =>
      '現在のパスに書き込めません。保存先フォルダーが保護されているか、ファイルが使用中か、パスに書き込み権限がない可能性があります。';

  @override
  String get fileSaveFailedGenericMessage =>
      'システムがファイルを保存できませんでした。再試行するか、システム設定を確認するか、代わりにファイル共有を使用してください。';

  @override
  String get retryLater => '後でもう一度試す';

  @override
  String get exportSwitchedToShare => 'エクスポートはファイル共有に切り替えられました';

  @override
  String get saveFailedRetry => '保存に失敗しました。後でもう一度お試しください。';

  @override
  String get importFailedCheckContent => 'インポートに失敗しました。ファイル内容を確認してください。';

  @override
  String get noImportableTimetables => 'インポートしたファイルに使用可能な時間割が見つかりませんでした。';

  @override
  String importedTimetablesCount(int count) {
    return '$count件の時間割をインポートしました';
  }

  @override
  String get periodTimesTitle => '時限時間';

  @override
  String get importExport => 'インポートとエクスポート';

  @override
  String get importPeriodTemplate => '時限テンプレートをインポート';

  @override
  String get importPeriodTemplateText => 'テキストから時限テンプレートをインポート';

  @override
  String get sharePeriodTemplate => '時限テンプレートを共有';

  @override
  String get saveTemplateToFile => 'テンプレートをファイルに保存';

  @override
  String get exportPeriodTemplateText => '時限テンプレートをテキストでエクスポート';

  @override
  String get deletePeriodTimeSet => '時限時間セットを削除';

  @override
  String get periodTimeSetName => '時限時間セット名';

  @override
  String get addOnePeriod => '時限を追加';

  @override
  String periodNumberLabel(int index) {
    return '第$index時限';
  }

  @override
  String get deleteThisPeriod => 'この時限を削除';

  @override
  String durationMinutes(int minutes) {
    return '長さ $minutes分';
  }

  @override
  String gapFromPrevious(int minutes) {
    return '前の時限からの間隔 $minutes分';
  }

  @override
  String get endTimeMustBeLater => '終了時刻は開始時刻より後である必要があります';

  @override
  String get periodOverlapPrevious => 'この時限は前の時限と重なっています';

  @override
  String get periodTimesSaved => '時限時間を保存しました';

  @override
  String get deletePeriodTimeSetTitle => '時限時間セットを削除';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return '\"$name\"を削除しますか？';
  }

  @override
  String get currentPeriodTimeSet => '現在の時限時間セット';

  @override
  String importedPeriodTimesCount(int count) {
    return '$count件の時限時間をインポートしました';
  }

  @override
  String get periodFilePermissionTitle => 'ファイル権限が必要です';

  @override
  String get androidFilePermissionMessage =>
      'Androidでのエクスポートにはファイルアクセス権限が必要です。保存を続けるには権限を許可してください。';

  @override
  String get reauthorize => '再許可';

  @override
  String get permissionPermanentlyDeniedTitle => '権限が恒久的に拒否されました';

  @override
  String get permissionSettingsExportMessage =>
      'システム設定でファイルアクセスを有効にしてから戻り、再度エクスポートしてください。';

  @override
  String get privacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get privacyPolicyEntryDesc =>
      'アプリがローカル保存、学校サイト設定、ファイルのインポート/エクスポート、Webページ解析、外部リンクをどのように扱うかを確認できます。';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return '同意済みバージョン: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Classmate はローカル優先の時間割ツールです。時間割、時限時間セット、学校サイト設定はお使いの端末またはブラウザ内にのみ保存され、自動的にアップロードされることはありません。アプリは、インポート、ウェブページ解析、共有、外部リンクの起動など、あなたが明示的に操作を行った場合にのみデータを処理します。完全なプライバシーポリシーはオンラインで確認できます。';

  @override
  String get privacyPolicyLocalStorageTitle => 'ローカル保存';

  @override
  String get privacyPolicyLocalStorageBody =>
      '時間割データと関連設定は、アプリのドキュメントディレクトリ内の classmate_data.json というローカルファイルに保存されます。編集可能な学校サイト設定は classmate_school_sites.json に別保存されます。カスタム時間割パーサー設定（カスタム Base URL、API key、選択したモデルを含む）も同じアプリデータ内にローカル保存され、システムの資格情報保管庫では保護されません。ブラウザで使用する場合も、同種のデータはブラウザストレージに保存されます。アプリがこのローカルデータを開発者管理のサーバーへ自動アップロードすることはありません。';

  @override
  String get privacyPolicyImportExportTitle => 'インポートとエクスポート';

  @override
  String get privacyPolicyImportExportBody =>
      'アプリが時間割JSONファイル、学校サイトJSONファイル、時限テンプレートファイルを読み書きするのは、あなたが明示的にファイルを選択するか、エクスポート操作を開始した場合のみです。これらのファイルのインポートは、Webページ解析も選択しない限りローカル処理です。カスタムモデル一覧の取得も明示的なネットワーク操作であり、設定したカスタムエンドポイントのみに接続します。';

  @override
  String get privacyPolicySharingTitle => '共有';

  @override
  String get privacyPolicySharingBody =>
      '共有機能を明示的に使用した場合、アプリはエクスポートしたファイルをシステムの共有シート、またはあなたが選択した対象アプリへ渡します。その後のファイルの取り扱いは、選択した対象アプリまたはサービスに依存します。';

  @override
  String get privacyPolicyExternalLinksTitle => '外部リンク';

  @override
  String get privacyPolicyExternalLinksBody =>
      'GitHub リポジトリなどの外部リンクを開くと、アプリはその操作をブラウザまたは他の外部アプリに引き渡します。その後のデータの取り扱いは、開いた第三者によって決まります。';

  @override
  String get privacyPolicyNoCollectionTitle => 'アプリが収集しないもの';

  @override
  String get privacyPolicyNoCollectionBody =>
      'アプリは Classmate アカウントを必要とせず、分析、広告識別子、クラウドバックアップも有効にしません。また、学校アカウントのパスワードを収集する専用入力欄も提供しません。アプリ内で学校サイトにログインする場合、その操作はあなたが開いた学校ページ上で行われます。';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Webページ解析';

  @override
  String get privacyPolicyFutureFeatureBody =>
      '学校Webページからのインポート、またはHTMLを貼り付けて解析する場合、アプリはまず内容をローカルで圧縮し、その後、送信したページ内容、任意のページタイトルとURL、現在のアプリ言語、パーサープロンプト内容を選択中の解析エンドポイントへ送信します。公式パーサーを使う場合、リクエストはアプリで設定された公式バックエンドへ送られます。カスタムの OpenAI 互換パーサーを有効にすると、同じ内容が設定したサードパーティ製エンドポイントへ直接送信され、モデル一覧の取得も同じエンドポイントに対して行われます。カスタムエンドポイントは、その提供元の設計に応じて他のAIサービスへ転送する場合があります。現在デプロイされている公式バックエンドでは、送信ペイロードは 300KB まで、設定されたタイムアウトを使用し、IPごとに1日最大5回まで解析リクエストを許可しています。';

  @override
  String get privacyPolicyUpdatesTitle => 'ポリシーの更新';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return '現在のプライバシーポリシーのバージョンは $version です。今後のバージョンでデータの取り扱い方法が変わる場合、更新後のポリシーの再確認と再同意をお願いすることがあります。';
  }

  @override
  String get privacyGateTitle => 'アプリを使用する前にプライバシーポリシーへ同意してください';

  @override
  String get privacyGateSummaryStorage =>
      '時間割、時限時間セット、学校サイト設定はローカルにのみ保存され、開発者サーバーへ自動アップロードされません。';

  @override
  String get privacyGateSummaryImportExport =>
      'インポート、エクスポート、共有は、あなたが明示的に開始した場合にのみ行われます。Webページ解析では、送信した圧縮済み内容のみが設定した解析エンドポイントへ送られ、保存前に解析結果の時間割を確認できます。';

  @override
  String get privacyGateSummaryUpdates =>
      '今後のバージョンでデータの取り扱いが変わる場合、更新後のプライバシーポリシーの再確認をお願いすることがあります。';

  @override
  String get schoolWebImportEntry => '学校Webページからインポート';

  @override
  String get schoolWebImportEntryDesc => '学校サイト上の現在の時間割ページをインポートします。';

  @override
  String get schoolSitesManageEntry => '学校サイトを管理';

  @override
  String get schoolSitesManageEntryDesc =>
      '学校ログインURLの追加・編集・削除を行い、JSONのインポート/エクスポートにも対応します。';

  @override
  String get schoolSitesPageTitle => '学校サイト管理';

  @override
  String get schoolSitesImportJson => '学校JSONをインポート';

  @override
  String get schoolSitesShareJson => '学校JSONを共有';

  @override
  String get schoolSitesSaveJson => '学校JSONを保存';

  @override
  String get schoolSitesSaved => '学校サイトを保存しました';

  @override
  String get schoolSitesImported => '学校サイトをインポートしました';

  @override
  String get schoolSitesEmpty => '学校サイト設定はまだありません。';

  @override
  String get schoolSitesNameLabel => '学校名';

  @override
  String get schoolSitesLoginUrlLabel => 'ログインURL';

  @override
  String get schoolSitesAdd => '学校を追加';

  @override
  String get schoolSitesEdit => '学校を編集';

  @override
  String get schoolSitesDeleteTitle => '学校を削除';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return '\"$name\"を削除しますか？';
  }

  @override
  String get schoolSitesFormInvalid => '先に学校名とログインURLを入力してください。';

  @override
  String get schoolSitesJsonFileName => 'classmate_school_sites.json';

  @override
  String get schoolHtmlImportEntry => '時間割ページ内容を貼り付けてインポート';

  @override
  String get schoolHtmlImportEntryDesc =>
      '時間割情報を含むソースコードまたはページの生データを手動で貼り付けます。';

  @override
  String get schoolHtmlImportPageTitle => 'ページ内容から時間割を解析';

  @override
  String get schoolHtmlImportUrlLabel => '元のURL（任意）';

  @override
  String get schoolHtmlImportTitleLabel => 'ページタイトル（任意）';

  @override
  String get schoolHtmlImportHtmlLabel => 'ページ内容';

  @override
  String get schoolHtmlImportHtmlHint =>
      '時間割情報を含むソースコードまたはページの生データをここに貼り付けてください。';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'HTMLに限らず、時間割情報を含む内容であれば解析してインポートできます。';

  @override
  String get schoolHtmlImportCompress => '内容を圧縮';

  @override
  String get schoolHtmlImportCompressed => '内容を圧縮しました';

  @override
  String get schoolHtmlImportCompressFirst => '先に内容を圧縮してください。';

  @override
  String get schoolHtmlImportSubmit => '解析してインポート';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      '解析には時間がかかる場合があります。しばらくお待ちください。';

  @override
  String get schoolHtmlImportEmpty => '先にページHTMLを貼り付けてください。';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Webページに戻る';

  @override
  String get schoolWebImportPageTitle => '学校Webページのインポート';

  @override
  String get schoolWebImportPreview => 'インポートプレビュー';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count件の授業';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count時限';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'ページタイトル';

  @override
  String get schoolWebImportParserUsed => 'パーサー';

  @override
  String get schoolWebImportWarnings => 'インポート時の注意';

  @override
  String get schoolWebImportOpenPageHint =>
      'アプリ内で学校サイトにログインし、その後手動で時間割ページへ移動してください。';

  @override
  String get schoolWebImportConfigMissing => 'Webインポート用バックエンドAPIがまだ設定されていません。';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'このプラットフォームでは、埋め込みWebログインはまだサポートされていません。WebView対応のプラットフォームを使用してください。';

  @override
  String get schoolWebImportSelectSchool => '学校を選択';

  @override
  String get schoolWebImportNoSchools =>
      '学校設定がありません。まず school_sites.json を確認してください。';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      '学校設定の読み込みに失敗しました。JSONファイル形式を確認してください。';

  @override
  String get schoolWebImportImportCurrentPage => '現在のページをインポート';

  @override
  String get schoolWebImportGoBack => '前のページ';

  @override
  String get schoolWebImportLoadingPage => 'ページを読み込み中…';

  @override
  String get schoolWebImportParsing => '現在のページを解析中…';

  @override
  String get schoolWebImportLoadFailed =>
      'ページの読み込みに失敗しました。更新するか、しばらくしてからもう一度お試しください。';

  @override
  String get schoolWebImportLoadTimedOut => 'ページ読み込みがタイムアウトしました。更新して再度お試しください。';

  @override
  String get schoolWebImportEmptyPage => '現在のページ内容が空のため、まだインポートできません。';

  @override
  String get schoolWebImportSuccess => 'Web時間割をインポートしました';

  @override
  String get schoolImportParserSettingsTitle => '時間割パーサー設定';

  @override
  String get schoolImportParserSettingsDesc =>
      '公式パーサー、またはカスタムの OpenAI 互換エンドポイントを選択します。';

  @override
  String get schoolImportParserSourceTitle => 'パーサーの提供元';

  @override
  String get schoolImportParserSourceOfficial => '公式パーサー';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'アプリで設定された組み込みの公式解析サービスを使用します。';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      '公式パーサーはアプリで設定された解析バックエンドを使い、現在のインポートフローを変更しません。';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'カスタム OpenAI 互換';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'ページ内容を自分の OpenAI 互換エンドポイントへ直接送信します。';

  @override
  String get schoolImportParserCustomOpenAi => 'カスタム OpenAI 互換パーサー';

  @override
  String get schoolImportParserCustomPromptTitle => 'カスタムプロンプト';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'ここで組み込みパーサープロンプトを編集できます。変更はカスタム OpenAI 互換パーサーにのみ適用されます。';

  @override
  String get schoolImportParserCustomPromptHint =>
      'ここには既定で組み込みプロンプトが読み込まれます。空にすると組み込み版に戻ります。';

  @override
  String get schoolImportParserResetDefaultPrompt => '既定のプロンプトに戻す';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'モデル';

  @override
  String get schoolImportParserFetchModels => 'モデル一覧を取得';

  @override
  String get schoolImportParserFetchingModels => 'モデルを取得中...';

  @override
  String get schoolImportParserNoModelsFound => 'エンドポイントからモデルが返されませんでした。';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '$count件のモデルを取得しました';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      '現在の実装では、カスタム API key はアプリのローカル設定に平文で保存されます。信頼できる端末またはブラウザ環境でのみ使用してください。';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'カスタムパーサー設定が未完了です。先に Base URL、API key、モデルを入力してください。';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'パーサー: 公式';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'パーサー: カスタム ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'プライバシーポリシー全文を見る';

  @override
  String get privacyAgreeAndContinue => '同意して続行';

  @override
  String get privacyDecline => '同意しない';

  @override
  String get privacyDeclineWebHint =>
      'このブラウザ環境では、アプリがページを自動で閉じることはできません。同意しない場合は、このタブまたはウィンドウを自分で閉じてください。';

  @override
  String get defaultPeriodTimeSetName => 'デフォルト時限';

  @override
  String get periodTimeSetFallbackName => '時限時間';

  @override
  String get untitledTimetableName => '無題の時間割';

  @override
  String get newTimetableName => '新しい時間割';

  @override
  String get newPeriodTimeSetName => '新しい時限時間セット';

  @override
  String get emptyTimetableName => '空の時間割';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name の時限';
  }

  @override
  String get importFileTypeMismatchMessage => 'インポートするファイルの種類が一致しません。';

  @override
  String get importFileVersionUnsupportedMessage =>
      'このインポートファイルのバージョンにはまだ対応していません。';

  @override
  String get noPeriodTimesInImportMessage => 'インポートファイルに時限時間が見つかりませんでした。';

  @override
  String get selectAtLeastOneTimetableMessage => '少なくとも1つの時間割を選択してください。';

  @override
  String get noExportableTimetableMessage => 'エクスポートできる時間割がありません。';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      '現在の時間割の置き換えでは、1つの時間割のみ選択できます。';

  @override
  String get noActiveTimetableToReplaceMessage => '置き換える現在の時間割がありません。';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'この時限時間セットはまだ $count 件の時間割で使用されています。削除する前に別のセットへ割り当て直してください。';
  }

  @override
  String get weekdayMonday => '月曜日';

  @override
  String get weekdayTuesday => '火曜日';

  @override
  String get weekdayWednesday => '水曜日';

  @override
  String get weekdayThursday => '木曜日';

  @override
  String get weekdayFriday => '金曜日';

  @override
  String get weekdaySaturday => '土曜日';

  @override
  String get weekdaySunday => '日曜日';

  @override
  String get weekdayShortMonday => '月';

  @override
  String get weekdayShortTuesday => '火';

  @override
  String get weekdayShortWednesday => '水';

  @override
  String get weekdayShortThursday => '木';

  @override
  String get weekdayShortFriday => '金';

  @override
  String get weekdayShortSaturday => '土';

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
  String get semesterWeeksWholeTerm => '学期全体';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return '第$start〜$end週';
  }

  @override
  String semesterWeeksList(Object value) {
    return '第$value週';
  }
}
