// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Неделя $week';
  }

  @override
  String get addCourse => 'Добавить занятие';

  @override
  String get settings => 'Настройки';

  @override
  String get multiTimetableSwitch => 'Переключить расписания';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Текущее расписание · $weeks нед.';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Нажмите для переключения · $weeks нед.';
  }

  @override
  String get editTimetable => 'Редактировать расписание';

  @override
  String get createTimetable => 'Новое расписание';

  @override
  String get jumpToWeek => 'Перейти к неделе';

  @override
  String get timetable => 'Расписание';

  @override
  String get timetableName => 'Название расписания';

  @override
  String get totalWeeks => 'Всего недель';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get deleteTimetableTitle => 'Удалить расписание';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Расписания пока нет';

  @override
  String get noTimetableMessage =>
      'Создайте расписание или импортируйте его из JSON-файла.';

  @override
  String get importTimetable => 'Импортировать расписание';

  @override
  String get courseName => 'Название предмета';

  @override
  String get location => 'Место';

  @override
  String get dayOfWeek => 'День';

  @override
  String get semesterWeeks => 'Недели';

  @override
  String get startTime => 'Время начала';

  @override
  String get endTime => 'Время окончания';

  @override
  String get linkedPeriods => 'Связанные пары';

  @override
  String get linkedPeriodsUnmatched =>
      'Для текущего времени пары не найдены. Нажмите, чтобы выбрать вручную.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Пара $start-$end';
  }

  @override
  String get teacherName => 'Преподаватель';

  @override
  String get credits => 'Кредиты';

  @override
  String get remarks => 'Примечания';

  @override
  String get customFields => 'Пользовательские поля';

  @override
  String get customFieldsHint => 'По одному в строке, формат: ключ:значение';

  @override
  String get selectDayOfWeek => 'Выберите день';

  @override
  String get selectSemesterWeeks => 'Выберите недели';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get clear => 'Очистить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get selectLinkedPeriods => 'Выберите связанные пары';

  @override
  String get addCourseTitle => 'Добавить занятие';

  @override
  String get editCourseTitle => 'Редактировать занятие';

  @override
  String get editCourseTooltip => 'Редактировать занятие';

  @override
  String get place => 'Место';

  @override
  String get time => 'Время';

  @override
  String get notFilled => 'Не заполнено';

  @override
  String get none => 'Нет';

  @override
  String get conflictCourses => 'Конфликтующие занятия';

  @override
  String get locationNotFilled => 'Место не указано';

  @override
  String get setAsDisplayed => 'Сделать отображаемым';

  @override
  String get editThisCourse => 'Редактировать это занятие';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get noTimetableSettings =>
      'Для настройки сейчас нет доступного расписания.';

  @override
  String get semesterStartDate => 'Дата начала семестра';

  @override
  String get periodTimeSets => 'Набор времени пар';

  @override
  String get noPeriodTimeAvailable => 'Нет доступных наборов времени пар';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count пар';
  }

  @override
  String get coursePopupDismissSetting =>
      'Разрешить закрытие карточки занятия нажатием вне окна';

  @override
  String get coursePopupDismissSettingHint =>
      'При отключении также отключается закрытие свайпом вниз.';

  @override
  String get preserveTimetableGaps => 'Сохранять промежутки в расписании';

  @override
  String get preserveTimetableGapsHint =>
      'Если выключено, обеденные и другие перерывы будут скрыты, а последующие занятия поднимутся вверх.';

  @override
  String get showPastEndedCourses => 'Показывать завершившиеся занятия';

  @override
  String get showPastEndedCoursesHint =>
      'Показывать занятия, которые уже закончились к текущей реальной неделе, в более светло-сером стиле.';

  @override
  String get showFutureCourses => 'Показывать будущие занятия';

  @override
  String get showFutureCoursesHint =>
      'Показывать занятия, которые не активны на этой неделе, но появятся в следующих неделях, в сером стиле.';

  @override
  String get timetableDisplaySettings =>
      'Отображение и взаимодействие с расписанием';

  @override
  String get timetableDisplaySettingsDesc =>
      'Закрытие всплывающих окон, промежутки, серые занятия и линии сетки';

  @override
  String get showTimetableGridLines => 'Показывать линии сетки расписания';

  @override
  String get showTimetableGridLinesHint =>
      'Управляет отображением горизонтальных и вертикальных линий сетки в расписании.';

  @override
  String get liveCourseOutlineColor => 'Цвет обводки занятия';

  @override
  String get liveCourseOutlineColorHint =>
      'Выберите, должна ли обводка применяться к текущему/следующему занятию или ко всем отображаемым занятиям на текущей странице.';

  @override
  String get liveCourseOutlineSettings => 'Обводка занятия';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Настройте включение обводки, цель применения, следование цвету темы и итоговый цвет обводки.';

  @override
  String get liveCourseOutlineEnabled => 'Включить обводку';

  @override
  String get liveCourseOutlineFollowTheme => 'Следовать цвету темы';

  @override
  String get liveCourseOutlineTarget => 'К чему применять обводку';

  @override
  String get liveCourseOutlineTargetCurrentOrNext =>
      'Текущее/следующее занятие';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Все отображаемые занятия';

  @override
  String get liveCourseOutlineEffectiveColor => 'Итоговый цвет';

  @override
  String get liveCourseOutlineCustomColor => 'Пользовательский цвет обводки';

  @override
  String get liveCourseOutlineWidth => 'Толщина обводки';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Язык';

  @override
  String get languagePageDescription =>
      'Выберите один из языков, которые действительно доступны в приложении.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/Sked';

  @override
  String get apiResponseTitle => 'Ответ API';

  @override
  String get theme => 'Тема';

  @override
  String get themeFollowSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeColor => 'Цвет темы';

  @override
  String get themeColorModeSingle => 'Один цвет темы';

  @override
  String get themeColorModeColorful => 'Разноцветная';

  @override
  String get themeColorUiColors => 'Цвета интерфейса';

  @override
  String get themeColorCourseColors => 'Цвета занятий';

  @override
  String get themeColorPrimary => 'Основной';

  @override
  String get themeColorSecondary => 'Дополнительный';

  @override
  String get themeColorTertiary => 'Третичный';

  @override
  String get themeColorCourseText => 'Текст занятия';

  @override
  String get themeColorCourseTextAuto => 'Авто';

  @override
  String get themeColorCourseTextCustom => 'Пользовательский цвет';

  @override
  String get themeColorCourseColorsEmpty =>
      'Цвета занятий будут сгенерированы после импорта расписания.';

  @override
  String get themeCustomColor => 'Пользовательский цвет';

  @override
  String get themeApplyCustomColor => 'Применить цвет';

  @override
  String get themeApplySettings => 'Применить настройки';

  @override
  String get dataImportExport => 'Импорт и экспорт данных';

  @override
  String get dataImportExportDesc =>
      'Импортируйте все данные или отдельные расписания, либо экспортируйте текущее/все расписания.';

  @override
  String get openSourceLicenses => 'Лицензии open source';

  @override
  String get openSourceLicensesDesc =>
      'Просмотр лицензий зависимостей Flutter и включённых ресурсов иконки приложения.';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Уже установлена последняя версия ($version)';
  }

  @override
  String get currentVersionLabel => 'Текущая версия';

  @override
  String get newVersionAvailable => 'Доступно обновление';

  @override
  String get latestVersionLabel => 'Последняя версия';

  @override
  String get updateContentLabel => 'Подробности обновления';

  @override
  String get officialWebsite => 'Официальный сайт';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Облачный диск';

  @override
  String get ignoreThisVersion => 'Игнорировать эту версию';

  @override
  String get openUpdatesFailed => 'Не удалось открыть ссылку на обновление';

  @override
  String get updateCheckFailedTitle => 'Не удалось проверить обновления';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'Репозиторий GitHub';

  @override
  String get openGithubFailed =>
      'Не удалось открыть ссылку на репозиторий GitHub';

  @override
  String get selectPeriodTimeSet => 'Выберите набор времени пар';

  @override
  String get newItem => 'Новый';

  @override
  String get editPeriodTimeSet => 'Редактировать набор времени пар';

  @override
  String get importTimetableFiles => 'Импортировать расписание';

  @override
  String get importTimetableFilesDesc =>
      'Поддерживается один или несколько файлов расписания.';

  @override
  String get importTimetableText => 'Импортировать расписание из текста';

  @override
  String get importTimetableTextDesc =>
      'Вставьте JSON-содержимое расписания и импортируйте его.';

  @override
  String get shareTimetableFiles => 'Поделиться файлами расписания';

  @override
  String get shareTimetableFilesDesc =>
      'Сначала выберите одно или несколько расписаний.';

  @override
  String get saveTimetableFiles => 'Сохранить файлы расписания';

  @override
  String get saveTimetableFilesDesc =>
      'Сначала выберите одно или несколько расписаний.';

  @override
  String get exportTimetableText => 'Экспортировать расписание как текст';

  @override
  String get exportTimetableTextDesc =>
      'Выберите одно или несколько расписаний, затем скопируйте JSON-содержимое.';

  @override
  String get jsonContent => 'JSON-содержимое';

  @override
  String get pasteJsonContentHint => 'Вставьте JSON-содержимое для импорта.';

  @override
  String get jsonContentEmpty => 'Сначала вставьте JSON-содержимое.';

  @override
  String get copyText => 'Копировать';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get share => 'Поделиться';

  @override
  String get selectTimetablesToExport => 'Выберите расписания для экспорта';

  @override
  String get selectTimetablesToImport => 'Выберите расписания для импорта';

  @override
  String timetableCourseCount(int count) {
    return '$count занятий';
  }

  @override
  String get importAction => 'Импортировать';

  @override
  String get importTimetableDialogTitle => 'Импорт расписания';

  @override
  String get chooseImportMethod => 'Выберите способ импорта.';

  @override
  String get importAsNewTimetable => 'Импортировать как новое расписание';

  @override
  String get replaceCurrentTimetable => 'Заменить текущее расписание';

  @override
  String get importPeriodTimeSetDialogTitle => 'Импорт наборов времени пар';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Этот файл содержит встроенные наборы времени пар. Хотите импортировать их и связать с расписанием?';

  @override
  String get importBundledPeriodTimeSets => 'Импортировать и связать';

  @override
  String get discardBundledPeriodTimeSets => 'Отбросить встроенные наборы';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Нет доступного существующего набора времени пар, поэтому встроенные наборы нельзя отбросить.';

  @override
  String savedToPath(Object path) {
    return 'Сохранено в $path';
  }

  @override
  String get saveCancelled => 'Сохранение отменено';

  @override
  String get fileSaveRestrictedTitle => 'Сохранение файла ограничено';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Система не смогла сохранить файл. Вы можете попробовать снова или использовать общий доступ.';

  @override
  String get retrySave => 'Повторить сохранение';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Включите доступ к файлам в настройках системы, затем вернитесь и попробуйте экспортировать снова.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get browserDownloadRestrictedTitle => 'Загрузка в браузере ограничена';

  @override
  String get browserDownloadRestrictedMessage =>
      'Этот браузер не поддерживает прямое сохранение в локальный файл. Проверьте разрешения на загрузку или используйте общий доступ к файлу.';

  @override
  String get switchToShare => 'Использовать общий доступ';

  @override
  String get fileSaveFailedTitle => 'Не удалось сохранить файл';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Не удалось записать в текущий путь. Целевая папка может быть защищена, файл может использоваться или путь может быть недоступен для записи.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Система не смогла сохранить файл. Вы можете повторить попытку, проверить настройки системы или использовать общий доступ к файлу.';

  @override
  String get retryLater => 'Попробовать позже';

  @override
  String get exportSwitchedToShare =>
      'Для экспорта включён общий доступ к файлу';

  @override
  String get saveFailedRetry =>
      'Не удалось сохранить. Пожалуйста, попробуйте позже.';

  @override
  String get importFailedCheckContent =>
      'Импорт не удался. Проверьте содержимое файла.';

  @override
  String get noImportableTimetables =>
      'В импортированном файле не найдено пригодных расписаний.';

  @override
  String importedTimetablesCount(int count) {
    return 'Импортировано расписаний: $count';
  }

  @override
  String get periodTimesTitle => 'Время пар';

  @override
  String get importExport => 'Импорт и экспорт';

  @override
  String get importPeriodTemplate => 'Импортировать шаблон пар';

  @override
  String get importPeriodTemplateText => 'Импортировать шаблон пар из текста';

  @override
  String get sharePeriodTemplate => 'Поделиться шаблоном пар';

  @override
  String get saveTemplateToFile => 'Сохранить шаблон в файл';

  @override
  String get exportPeriodTemplateText => 'Экспортировать шаблон пар как текст';

  @override
  String get deletePeriodTimeSet => 'Удалить набор времени пар';

  @override
  String get periodTimeSetName => 'Название набора времени пар';

  @override
  String get addOnePeriod => 'Добавить пару';

  @override
  String periodNumberLabel(int index) {
    return 'Пара $index';
  }

  @override
  String get deleteThisPeriod => 'Удалить эту пару';

  @override
  String durationMinutes(int minutes) {
    return 'Длительность $minutes мин';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Перерыв от предыдущей $minutes мин';
  }

  @override
  String get endTimeMustBeLater =>
      'Время окончания должно быть позже времени начала';

  @override
  String get periodOverlapPrevious => 'Эта пара пересекается с предыдущей';

  @override
  String get periodTimesSaved => 'Время пар сохранено';

  @override
  String get deletePeriodTimeSetTitle => 'Удалить набор времени пар';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'текущий набор времени пар';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Импортировано времён пар: $count';
  }

  @override
  String get periodFilePermissionTitle =>
      'Требуется разрешение на доступ к файлам';

  @override
  String get androidFilePermissionMessage =>
      'Для экспорта на Android требуется разрешение на доступ к файлам. Предоставьте его, чтобы продолжить сохранение.';

  @override
  String get reauthorize => 'Авторизовать снова';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Разрешение окончательно отклонено';

  @override
  String get permissionSettingsExportMessage =>
      'Включите доступ к файлам в настройках системы, затем вернитесь и попробуйте экспортировать снова.';

  @override
  String get privacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get privacyPolicyEntryDesc =>
      'Узнайте, как приложение обрабатывает локальное хранилище, конфигурацию школьных сайтов, импорт/экспорт файлов, разбор веб-страниц и внешние ссылки.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Принятая версия: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked — это локально-ориентированный инструмент для расписаний. Расписания, наборы времени пар и конфигурация школьных сайтов хранятся только на вашем устройстве или в браузере и никогда не загружаются автоматически. Приложение обрабатывает данные только тогда, когда вы явно запускаете такие действия, как импорт, разбор веб-страниц, общий доступ или открытие внешних ссылок. Полная политика конфиденциальности доступна онлайн.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Локальное хранилище';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Данные расписания и связанные настройки хранятся в локальном файле Sked_data.json в каталоге документов приложения. Редактируемая конфигурация школьных сайтов хранится отдельно в Sked_school_sites.json. Пользовательские настройки парсера расписания, включая Base URL, API key и выбранную модель, также хранятся локально в тех же данных приложения и не защищены системным хранилищем учётных данных. При использовании в браузере данные того же типа сохраняются в хранилище браузера. Приложение не загружает эти локальные данные автоматически на сервер, контролируемый разработчиком.';

  @override
  String get privacyPolicyImportExportTitle => 'Импорт и экспорт';

  @override
  String get privacyPolicyImportExportBody =>
      'Приложение читает или записывает JSON-файлы расписаний, JSON-файлы школьных сайтов и файлы шаблонов пар только тогда, когда вы явно выбираете файл или запускаете экспорт. Импорт этих файлов выполняется локально, если только вы дополнительно не выбираете разбор веб-страницы. Получение списка пользовательских моделей также является явным сетевым действием и обращается только к настроенной вами конечной точке.';

  @override
  String get privacyPolicySharingTitle => 'Общий доступ';

  @override
  String get privacyPolicySharingBody =>
      'Когда вы явно используете общий доступ, приложение передаёт экспортированный файл в системное меню общего доступа или в выбранное вами приложение. Дальнейшая обработка этого файла зависит от выбранного приложения или сервиса.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Внешние ссылки';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Когда вы открываете внешние ссылки, например репозиторий GitHub, приложение передаёт действие вашему браузеру или другому внешнему приложению. Обработка данных после этого регулируется третьей стороной, которую вы открываете.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Что приложение не собирает';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Приложению не требуется учётная запись Sked, и в нём не используются аналитика, рекламные идентификаторы или облачное резервное копирование. Также в нём нет отдельного поля для сбора паролей от школьных учётных записей. Если вы входите на школьный сайт внутри приложения, это взаимодействие происходит на открытой вами школьной странице.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Разбор веб-страниц';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Когда вы используете импорт с веб-страницы школы или вставляете HTML для разбора, приложение сначала локально сжимает содержимое, а затем отправляет на выбранную конечную точку разбора содержимое страницы, необязательные заголовок и URL страницы, текущий язык приложения и содержимое подсказки парсера. Если вы используете официальный парсер, запрос отправляется на настроенный официальный backend приложения. Если вы включаете пользовательский OpenAI-совместимый парсер, то это же содержимое отправляется напрямую на стороннюю конечную точку, которую вы настроили, а получение списка моделей также обращается к этой же точке. Пользовательская конечная точка может перенаправлять запрос другим ИИ-сервисам в соответствии с архитектурой её провайдера. Развёрнутый официальный backend в настоящее время ограничивает каждый отправляемый payload размером 300 КБ, использует свой настроенный тайм-аут и допускает не более 5 запросов на разбор с одного IP-адреса в день.';

  @override
  String get privacyPolicyUpdatesTitle => 'Обновления политики';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Текущая версия политики конфиденциальности — $version. Если в более поздней версии изменится способ обработки данных, приложение может попросить вас снова прочитать и принять обновлённую политику.';
  }

  @override
  String get privacyGateTitle =>
      'Пожалуйста, согласитесь с политикой конфиденциальности перед использованием приложения';

  @override
  String get privacyGateSummaryStorage =>
      'Расписания, наборы времени пар и конфигурация школьных сайтов хранятся только локально и не загружаются автоматически на сервер разработчика.';

  @override
  String get privacyGateSummaryImportExport =>
      'Импорт, экспорт и общий доступ происходят только когда вы явно их запускаете; разбор веб-страниц отправляет только сжатое содержимое, которое вы предоставили, на настроенную вами конечную точку разбора, а перед сохранением вы можете просмотреть распознанное расписание.';

  @override
  String get privacyGateSummaryUpdates =>
      'Если в более поздней версии изменится способ обработки данных, приложение может попросить вас снова ознакомиться с обновлённой политикой конфиденциальности.';

  @override
  String get schoolWebImportEntry => 'Импорт с веб-страницы школы';

  @override
  String get schoolWebImportEntryDesc =>
      'Импортировать текущую страницу расписания с сайта учебного заведения.';

  @override
  String get schoolSitesManageEntry => 'Управление школьными сайтами';

  @override
  String get schoolSitesManageEntryDesc =>
      'Добавление, редактирование и удаление URL-адресов входа, а также импорт и экспорт JSON.';

  @override
  String get schoolSitesPageTitle => 'Управление школьными сайтами';

  @override
  String get schoolSitesImportJson => 'Импортировать школьный JSON';

  @override
  String get schoolSitesShareJson => 'Поделиться школьным JSON';

  @override
  String get schoolSitesSaveJson => 'Сохранить школьный JSON';

  @override
  String get schoolSitesSaved => 'Школьные сайты сохранены';

  @override
  String get schoolSitesImported => 'Школьные сайты импортированы';

  @override
  String get schoolSitesEmpty =>
      'Конфигурация школьных сайтов пока отсутствует.';

  @override
  String get schoolSitesNameLabel => 'Название учебного заведения';

  @override
  String get schoolSitesLoginUrlLabel => 'URL входа';

  @override
  String get schoolSitesAdd => 'Добавить учебное заведение';

  @override
  String get schoolSitesEdit => 'Редактировать учебное заведение';

  @override
  String get schoolSitesDeleteTitle => 'Удалить учебное заведение';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Сначала заполните название учебного заведения и URL входа.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Импорт вставкой содержимого страницы расписания';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Вставьте исходный код или необработанное содержимое страницы с информацией о расписании вручную.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Разобрать расписание из содержимого страницы';

  @override
  String get schoolHtmlImportUrlLabel => 'URL-источник (необязательно)';

  @override
  String get schoolHtmlImportTitleLabel => 'Заголовок страницы (необязательно)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Содержимое страницы';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Вставьте сюда исходный код или необработанное содержимое страницы с информацией о расписании.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Можно разобрать и импортировать любой контент, содержащий информацию о расписании, не только HTML.';

  @override
  String get schoolHtmlImportCompress => 'Сжать содержимое';

  @override
  String get schoolHtmlImportCompressed => 'Содержимое сжато';

  @override
  String get schoolHtmlImportCompressFirst => 'Сначала сожмите содержимое.';

  @override
  String get schoolHtmlImportSubmit => 'Разобрать и импортировать';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Разбор может занять некоторое время. Пожалуйста, подождите.';

  @override
  String get schoolHtmlImportEmpty => 'Сначала вставьте HTML-код страницы.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Назад к веб-странице';

  @override
  String get schoolWebImportPageTitle => 'Импорт с веб-страницы школы';

  @override
  String get schoolWebImportPreview => 'Предпросмотр импорта';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count занятий';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count пар';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Заголовок страницы';

  @override
  String get schoolWebImportParserUsed => 'Парсер';

  @override
  String get schoolWebImportWarnings => 'Примечания к импорту';

  @override
  String get schoolWebImportOpenPageHint =>
      'Войдите на школьный сайт внутри приложения, затем вручную перейдите на страницу расписания.';

  @override
  String get schoolWebImportConfigMissing =>
      'Backend API для веб-импорта ещё не настроен.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Эта платформа пока не поддерживает встроенный вход через веб-интерфейс. Пожалуйста, используйте платформу с поддержкой WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Выберите учебное заведение';

  @override
  String get schoolWebImportNoSchools =>
      'Конфигурация учебных заведений недоступна. Сначала проверьте school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Не удалось загрузить конфигурацию учебных заведений. Проверьте формат JSON-файла.';

  @override
  String get schoolWebImportImportCurrentPage =>
      'Импортировать текущую страницу';

  @override
  String get schoolWebImportGoBack => 'Предыдущая страница';

  @override
  String get schoolWebImportLoadingPage => 'Загрузка страницы…';

  @override
  String get schoolWebImportParsing => 'Разбор текущей страницы…';

  @override
  String get schoolWebImportLoadFailed =>
      'Не удалось загрузить страницу. Пожалуйста, обновите её или попробуйте позже.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Время загрузки страницы истекло. Обновите страницу и попробуйте снова.';

  @override
  String get schoolWebImportEmptyPage =>
      'Содержимое текущей страницы пусто и пока не может быть импортировано.';

  @override
  String get schoolWebImportSuccess => 'Веб-расписание импортировано';

  @override
  String get schoolImportParserSettingsTitle => 'Настройки парсера расписания';

  @override
  String get schoolImportParserSettingsDesc =>
      'Выберите официальный парсер или пользовательскую OpenAI-совместимую конечную точку.';

  @override
  String get schoolImportParserSourceTitle => 'Источник парсера';

  @override
  String get schoolImportParserSourceOfficial => 'Официальный парсер';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Использовать встроенный официальный сервис разбора, настроенный приложением.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Официальный парсер использует настроенный backend разбора приложения и сохраняет текущий процесс импорта без изменений.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Пользовательский OpenAI-совместимый';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Отправлять содержимое страницы напрямую на вашу OpenAI-совместимую конечную точку.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Пользовательский OpenAI-совместимый парсер';

  @override
  String get schoolImportParserCustomPromptTitle =>
      'Пользовательская подсказка';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Здесь можно редактировать встроенную подсказку парсера. Изменения влияют только на пользовательский OpenAI-совместимый парсер.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'По умолчанию здесь загружается встроенная подсказка. Очистите её, чтобы вернуться к встроенной версии.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Сбросить подсказку по умолчанию';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'Модель';

  @override
  String get schoolImportParserFetchModels => 'Получить список моделей';

  @override
  String get schoolImportParserFetchingModels => 'Получение списка моделей...';

  @override
  String get schoolImportParserNoModelsFound =>
      'Конечная точка не вернула ни одной модели.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Получено моделей: $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'В текущей реализации пользовательский API key хранится в локальных настройках приложения в открытом виде. Используйте его только на устройстве или в браузере, которым доверяете.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Конфигурация пользовательского парсера неполная. Сначала заполните Base URL, API key и модель.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Парсер: официальный';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Парсер: пользовательский ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Просмотреть полную политику конфиденциальности';

  @override
  String get privacyAgreeAndContinue => 'Согласиться и продолжить';

  @override
  String get privacyDecline => 'Отклонить';

  @override
  String get privacyDeclineWebHint =>
      'В этой браузерной среде приложение не может закрыть страницу за вас. Если вы не согласны, пожалуйста, закройте эту вкладку или окно самостоятельно.';

  @override
  String get defaultPeriodTimeSetName => 'Пары по умолчанию';

  @override
  String get periodTimeSetFallbackName => 'Время пар';

  @override
  String get untitledTimetableName => 'Расписание без названия';

  @override
  String get newTimetableName => 'Новое расписание';

  @override
  String get newPeriodTimeSetName => 'Новый набор времени пар';

  @override
  String get emptyTimetableName => 'Пустое расписание';

  @override
  String importedPeriodTimeSetName(Object name) {
    return 'Пары $name';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Тип импортируемого файла не совпадает.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Эта версия импортируемого файла пока не поддерживается.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Во входном файле не найдено времени пар.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Пожалуйста, выберите хотя бы одно расписание.';

  @override
  String get noExportableTimetableMessage =>
      'Нет доступных для экспорта расписаний.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Замена текущего расписания поддерживает выбор только одного расписания.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Нет текущего расписания для замены.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Этот набор времени пар всё ещё используется в $count расписании(ях). Перед удалением переназначьте их.';
  }

  @override
  String get weekdayMonday => 'Понедельник';

  @override
  String get weekdayTuesday => 'Вторник';

  @override
  String get weekdayWednesday => 'Среда';

  @override
  String get weekdayThursday => 'Четверг';

  @override
  String get weekdayFriday => 'Пятница';

  @override
  String get weekdaySaturday => 'Суббота';

  @override
  String get weekdaySunday => 'Воскресенье';

  @override
  String get weekdayShortMonday => 'Пн';

  @override
  String get weekdayShortTuesday => 'Вт';

  @override
  String get weekdayShortWednesday => 'Ср';

  @override
  String get weekdayShortThursday => 'Чт';

  @override
  String get weekdayShortFriday => 'Пт';

  @override
  String get weekdayShortSaturday => 'Сб';

  @override
  String get weekdayShortSunday => 'Вс';

  @override
  String get monthJanuary => 'янв.';

  @override
  String get monthFebruary => 'февр.';

  @override
  String get monthMarch => 'мар.';

  @override
  String get monthApril => 'апр.';

  @override
  String get monthMay => 'май';

  @override
  String get monthJune => 'июн.';

  @override
  String get monthJuly => 'июл.';

  @override
  String get monthAugust => 'авг.';

  @override
  String get monthSeptember => 'сент.';

  @override
  String get monthOctober => 'окт.';

  @override
  String get monthNovember => 'нояб.';

  @override
  String get monthDecember => 'дек.';

  @override
  String get semesterWeeksWholeTerm => 'Весь семестр';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Недели $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Недели $value';
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

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String timeGridMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get reminderInProgress => 'In progress';

  @override
  String get deleteCourseTitle => 'Delete course';

  @override
  String get deleteCourseMessage => 'Delete this course?';

  @override
  String get showLunarCalendar => 'Show lunar calendar';

  @override
  String monthDayEvents(int day, int count) {
    return '$day, $count events';
  }
}
