// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'Съученик';

  @override
  String weekLabel(int week) {
    return 'Седмица $week';
  }

  @override
  String get addCourse => 'Добавяне на курс';

  @override
  String get settings => 'Настройки';

  @override
  String get multiTimetableSwitch => 'Смяна на графиците';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Текущ график · $weeks седмици';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Докоснете, за да превключите · $weeks седмици';
  }

  @override
  String get editTimetable => 'Редактиране на графика';

  @override
  String get createTimetable => 'Нов график';

  @override
  String get jumpToWeek => 'Прескочи към седмицата';

  @override
  String get timetable => 'Разписание';

  @override
  String get timetableName => 'Име на графика';

  @override
  String get totalWeeks => 'Общо седмици';

  @override
  String get delete => 'Изтриване';

  @override
  String get cancel => 'Отмени';

  @override
  String get save => 'Запазване';

  @override
  String get deleteTimetableTitle => 'Изтриване на графика';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Изтриване на \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Все още няма график';

  @override
  String get noTimetableMessage =>
      'Създайте график или импортирайте един от JSON файл.';

  @override
  String get importTimetable => 'Внос на график';

  @override
  String get courseName => 'Име на курса';

  @override
  String get location => 'Местоположение';

  @override
  String get dayOfWeek => 'Ден';

  @override
  String get semesterWeeks => 'седмици';

  @override
  String get startTime => 'Стартно време';

  @override
  String get endTime => 'Крайно време';

  @override
  String get linkedPeriods => 'Свързани периоди';

  @override
  String get linkedPeriodsUnmatched =>
      'Няма съответстващи периоди за текущото време. Докоснете, за да изберете ръчно.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Период $start-$end';
  }

  @override
  String get teacherName => 'Учител';

  @override
  String get credits => 'Кредити';

  @override
  String get remarks => 'Забележки';

  @override
  String get customFields => 'Персонализирани полета';

  @override
  String get customFieldsHint => 'Един на ред, формат: ключ:стойност';

  @override
  String get selectDayOfWeek => 'Изберете ден';

  @override
  String get selectSemesterWeeks => 'Изберете седмици';

  @override
  String get selectAll => 'Изберете всички';

  @override
  String get clear => 'Изчисти';

  @override
  String get confirm => 'Потвърди';

  @override
  String get selectLinkedPeriods => 'Изберете свързани периоди';

  @override
  String get addCourseTitle => 'Добавяне на курс';

  @override
  String get editCourseTitle => 'Редактиране на курса';

  @override
  String get editCourseTooltip => 'Редактиране на курса';

  @override
  String get place => 'Местоположение';

  @override
  String get time => 'Времето';

  @override
  String get notFilled => 'Не е попълнено';

  @override
  String get none => 'Няма';

  @override
  String get conflictCourses => 'Конфликтни курсове';

  @override
  String get locationNotFilled => 'Местоположение не е попълнено';

  @override
  String get setAsDisplayed => 'Задаване като показано';

  @override
  String get editThisCourse => 'Редактирайте този курс';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get noTimetableSettings =>
      'В момента няма наличен график за настройки.';

  @override
  String get semesterStartDate => 'Дата на начало на семестъра';

  @override
  String get periodTimeSets => 'Период за определяне на времето';

  @override
  String get noPeriodTimeAvailable => 'Няма зададено време за наличен период';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count периоди';
  }

  @override
  String get coursePopupDismissSetting =>
      'Позволи външно докосване за затваряне на изскачащия прозорец на курса';

  @override
  String get coursePopupDismissSettingHint =>
      'Изключването на това също забранява уволнението с плъзгане надолу.';

  @override
  String get preserveTimetableGaps => 'Запазване на празнините в графика';

  @override
  String get preserveTimetableGapsHint =>
      'Когато си почивате, празнините за обяд и почивка се срушават, така че по-късните класове се движат нагоре.';

  @override
  String get showPastEndedCourses => 'Показване на завършени курсове';

  @override
  String get showPastEndedCoursesHint =>
      'Покажи курсове, които вече са завършили от реалната текуща седмица с по-светло сив стил.';

  @override
  String get showFutureCourses => 'Показа бъдещи курсове';

  @override
  String get showFutureCoursesHint =>
      'Показвайте курсове, които не са активни тази седмица, но ще се появят в по-късните седмици с сив стил.';

  @override
  String get timetableDisplaySettings => 'Показване на график и взаимодействие';

  @override
  String get timetableDisplaySettingsDesc =>
      'Отхвърляне на изскачащи прозорци, празнини, сиви курсове и линии на мрежата';

  @override
  String get showTimetableGridLines =>
      'Показване на линиите на мрежата на графика';

  @override
  String get showTimetableGridLinesHint =>
      'Контролирайте дали хоризонталните и вертикалните линии на мрежата са видими в графика.';

  @override
  String get liveCourseOutlineColor => 'Цвят на очертанието на курса';

  @override
  String get liveCourseOutlineColorHint =>
      'Изберете дали очертанията са насочени към текущия/следващия курс или всички показвани курсове на текущата страница.';

  @override
  String get liveCourseOutlineSettings => 'Описание на курса';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Конфигурирайте дали очертанието е активирано, какво насочва, дали следва цвета на темата и ефективния цвят на очертанието.';

  @override
  String get liveCourseOutlineEnabled => 'Включване на очертанието';

  @override
  String get liveCourseOutlineFollowTheme => 'Следвайте цвета на темата';

  @override
  String get liveCourseOutlineTarget => 'Очертаване на целта';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Текущ/следващ курс';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Всички показани курсове';

  @override
  String get liveCourseOutlineEffectiveColor => 'Ефективен цвят';

  @override
  String get liveCourseOutlineCustomColor => 'Персонализиран цвят на контура';

  @override
  String get liveCourseOutlineWidth => 'Ширина на контура';

  @override
  String get outlineWidthUnit => 'ПКС';

  @override
  String get language => 'Език';

  @override
  String get languagePageDescription =>
      'Изберете един от езиците, които наистина са налични в приложението.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'Английски';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Отговор на API';

  @override
  String get theme => 'Тема';

  @override
  String get themeFollowSystem => 'Следвайте системата';

  @override
  String get themeLight => 'Светлината';

  @override
  String get themeDark => 'Тъмно';

  @override
  String get themeColor => 'Цвят на темата';

  @override
  String get themeColorModeSingle => 'Цвят на една тема';

  @override
  String get themeColorModeColorful => 'Цветни';

  @override
  String get themeColorUiColors => 'Цветове на потребителския интерфейс';

  @override
  String get themeColorCourseColors => 'Цветове на курса';

  @override
  String get themeColorPrimary => 'Първичен';

  @override
  String get themeColorSecondary => 'Вторичен';

  @override
  String get themeColorTertiary => 'Третият';

  @override
  String get themeColorCourseText => 'Текст на курса';

  @override
  String get themeColorCourseTextAuto => 'Автоматична';

  @override
  String get themeColorCourseTextCustom => 'Персонализиран цвят';

  @override
  String get themeColorCourseColorsEmpty =>
      'Цветовете на курса ще бъдат генерирани след импортирането на график.';

  @override
  String get themeCustomColor => 'Персонализиран цвят';

  @override
  String get themeApplyCustomColor => 'Прилагане на цвят';

  @override
  String get themeApplySettings => 'Прилагане на настройки';

  @override
  String get dataImportExport => 'Внос и износ на данни';

  @override
  String get dataImportExportDesc =>
      'Импортиране на пълни данни или единични графици или експортиране на текущи/всички графици.';

  @override
  String get openSourceLicenses => 'Лицензи с отворен код';

  @override
  String get openSourceLicensesDesc =>
      'Вижте лицензите за зависимостите на Flutter и активите на иконите на приложенията.';

  @override
  String get checkForUpdates => 'Проверете за актуализации';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Официален сайт / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Вече на най-новата версия ($version)';
  }

  @override
  String get currentVersionLabel => 'Текуща версия';

  @override
  String get newVersionAvailable => 'Актуализация на разположение';

  @override
  String get latestVersionLabel => 'Последна версия';

  @override
  String get updateContentLabel => 'Подробности за актуализацията';

  @override
  String get officialWebsite => 'Официален сайт';

  @override
  String get googlePlay => 'на Google Play';

  @override
  String get cloudDrive => 'Облачно устройство';

  @override
  String get ignoreThisVersion => 'Игнориране на тази версия';

  @override
  String get openUpdatesFailed =>
      'Не може да се отвори връзката за актуализация';

  @override
  String get updateCheckFailedTitle => 'Проверка на актуализацията не успя';

  @override
  String get updateCheckFailedMessage =>
      'Не може да се получи валидна информация за актуализация от който и да е източник на актуализация. Все още можете да използвате връзките по-долу, за да актуализирате ръчно.';

  @override
  String get githubRepository => 'GitHub хранилище';

  @override
  String get openGithubFailed =>
      'Не може да се отвори връзката към хранилището на GitHub';

  @override
  String get selectPeriodTimeSet => 'Изберете определен период от време';

  @override
  String get newItem => 'Нови';

  @override
  String get editPeriodTimeSet => 'Редактиране на зададеното време за периода';

  @override
  String get importTimetableFiles => 'Внос на график';

  @override
  String get importTimetableFilesDesc =>
      'Поддържа един или няколко файла с график.';

  @override
  String get importTimetableText => 'Импортиране на график от текст';

  @override
  String get importTimetableTextDesc =>
      'Поставете JSON съдържанието на графика и го импортирайте.';

  @override
  String get shareTimetableFiles => 'Споделяне на графични файлове';

  @override
  String get shareTimetableFilesDesc =>
      'Първо изберете един или повече графици.';

  @override
  String get saveTimetableFiles => 'Запазване на графични файлове';

  @override
  String get saveTimetableFilesDesc =>
      'Първо изберете един или повече графици.';

  @override
  String get exportTimetableText => 'Експортиране на график като текст';

  @override
  String get exportTimetableTextDesc =>
      'Изберете един или повече графици, след което копирайте съдържанието на JSON.';

  @override
  String get jsonContent => 'JSON съдържание';

  @override
  String get pasteJsonContentHint =>
      'Поставете съдържанието на JSON за импортиране.';

  @override
  String get jsonContentEmpty => 'Първо поставете JSON съдържание.';

  @override
  String get copyText => 'Копиране';

  @override
  String get copiedToClipboard => 'Копиране в клипборда';

  @override
  String get share => 'Споделяне';

  @override
  String get selectTimetablesToExport => 'Изберете графици за експорт';

  @override
  String get selectTimetablesToImport => 'Изберете графици за импортиране';

  @override
  String timetableCourseCount(int count) {
    return '$count курсове';
  }

  @override
  String get importAction => 'Внос';

  @override
  String get importTimetableDialogTitle => 'Внос на график';

  @override
  String get chooseImportMethod => 'Изберете как да импортирате.';

  @override
  String get importAsNewTimetable => 'Импортиране като нов график';

  @override
  String get replaceCurrentTimetable => 'Замени текущия график';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Внос на часови набори за периода';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Този файл съдържа набори от периоди. Искате ли да ги импортирате и свързвате?';

  @override
  String get importBundledPeriodTimeSets => 'Внос и асоцииране';

  @override
  String get discardBundledPeriodTimeSets => 'Изхвърляне на пакетите';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Няма наличен набор от периодични времена, така че пакетите от периодични времена не могат да бъдат изхвърлени.';

  @override
  String savedToPath(Object path) {
    return 'Запазен в $path';
  }

  @override
  String get saveCancelled => 'Запазване отменено';

  @override
  String get fileSaveRestrictedTitle => 'Запазването на файлове е ограничено';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Системата не може да запази файла. Можете да опитате отново или да използвате споделяне вместо това.';

  @override
  String get retrySave => 'Опитайте отново да запишете';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Активирайте достъпа до файлове в системните настройки, след това се върнете и опитайте отново да експортирате.';

  @override
  String get openSettings => 'Отворете настройки';

  @override
  String get browserDownloadRestrictedTitle =>
      'Ограничено изтегляне на браузър';

  @override
  String get browserDownloadRestrictedMessage =>
      'Този браузър не поддържа пряко записване в локален файл. Проверете разрешенията за изтегляне на браузъра или използвайте споделяне на файлове вместо това.';

  @override
  String get switchToShare => 'Използвайте споделяне вместо това';

  @override
  String get fileSaveFailedTitle => 'Записването на файла не успя';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Не може да се запише в текущия път. Целтовата папка може да е защитена, файлът може да се използва или пътят може да не се записва.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Системата не може да запази файла. Можете да опитате отново, да проверите системните настройки или вместо това да използвате споделяне на файлове.';

  @override
  String get retryLater => 'Опитайте отново по-късно';

  @override
  String get exportSwitchedToShare =>
      'Прехвърлено към споделяне на файлове за експорт';

  @override
  String get saveFailedRetry =>
      'Записването се провали. Моля опитайте отново по-късно.';

  @override
  String get importFailedCheckContent =>
      'Импортирането се провали. Моля проверете съдържанието на файла.';

  @override
  String get noImportableTimetables =>
      'В импортирания файл не са намерени използвани графици.';

  @override
  String importedTimetablesCount(int count) {
    return 'Внесени $count графици';
  }

  @override
  String get periodTimesTitle => 'Период време';

  @override
  String get importExport => 'Внос и износ';

  @override
  String get importPeriodTemplate => 'Шаблон за период на внос';

  @override
  String get importPeriodTemplateText =>
      'Импортиране на шаблон за период от текст';

  @override
  String get sharePeriodTemplate => 'Шаблон за период на акции';

  @override
  String get saveTemplateToFile => 'Запазване на шаблона във файл';

  @override
  String get exportPeriodTemplateText =>
      'Експортиране на шаблон за период като текст';

  @override
  String get deletePeriodTimeSet => 'Изтриване на зададеното време за периода';

  @override
  String get periodTimeSetName => 'Име на зададеното време за периода';

  @override
  String get addOnePeriod => 'Добавяне на период';

  @override
  String periodNumberLabel(int index) {
    return 'Период $index';
  }

  @override
  String get deleteThisPeriod => 'Изтрийте този период';

  @override
  String durationMinutes(int minutes) {
    return 'Продължителност $minutes мин';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Разстояние от предишния $minutes мин';
  }

  @override
  String get endTimeMustBeLater =>
      'Крайното време трябва да е по-късно от началното';

  @override
  String get periodOverlapPrevious => 'Този период се припокрива с предишния';

  @override
  String get periodTimesSaved => 'Спасени периоди';

  @override
  String get deletePeriodTimeSetTitle =>
      'Изтриване на зададеното време за периода';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Изтриване на \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'зададено време за текущия период';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Внесени $count периодични времена';
  }

  @override
  String get periodFilePermissionTitle => 'Необходими разрешения за файлове';

  @override
  String get androidFilePermissionMessage =>
      'Експортът на Android изисква разрешение за достъп до файлове. Дайте разрешение да продължите да спестявате.';

  @override
  String get reauthorize => 'Авторизиране отново';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Постоянно отказано разрешение';

  @override
  String get permissionSettingsExportMessage =>
      'Активирайте достъпа до файлове в системните настройки, след това се върнете и опитайте отново да експортирате.';

  @override
  String get privacyPolicyTitle => 'Политика за поверителност';

  @override
  String get privacyPolicyEntryDesc =>
      'Научете как приложението се справя с локалното съхранение, конфигурацията на училището, импорта/експорта на файлове, анализа на уеб страници и външните връзки.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Приета версия: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked е локално-приоритетен инструмент за графици. Графиците, наборите от периоди и конфигурацията на училищния сайт се съхраняват само на вашето устройство или в браузъра ви и никога не се качват автоматично. Приложението обработва данни само когато изрично стартирате действия като импортиране, анализиране на уеб страници, споделяне или отваряне на външни връзки. Пълната политика за поверителност е достъпна онлайн.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Местно съхранение';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Данните за графика и свързаните с тях настройки се съхраняват в локален файл на име Sked_data.json в директорията документи на приложението. Редактируемата конфигурация на училището се съхранява отделно в Sked_school_sites.json. Персонализираните настройки на анализатора на графика, включително всеки персонализиран базов URL адрес, API ключ и избран модел, също се съхраняват локално в същите данни на приложението и не са защитени от трезор за системни данни. Когато се използват в браузър, същите видове данни се съхраняват в съхранението на браузъра. Приложението не качва автоматично тези локални данни на сървър, контролиран от разработчика.';

  @override
  String get privacyPolicyImportExportTitle => 'Внос и износ';

  @override
  String get privacyPolicyImportExportBody =>
      'Приложението чете или записва JSON файлове с график, JSON файлове с училищен сайт и файлове с шаблони за периоди само когато изрично изберете файл или започнете действие за експортиране. Импортирането на тези файлове е локална операция, освен ако не изберете и анализиране на уеб страници. Вземането на списък с персонализирани модели също е изрично мрежово действие и се свързва само с персонализираната крайна точка, която сте конфигурирали.';

  @override
  String get privacyPolicySharingTitle => 'Споделяне';

  @override
  String get privacyPolicySharingBody =>
      'Когато изрично използвате споделяне, приложението предава експортирания файл на листа за споделяне на системата или на избраното от вас целево приложение. Как се обработва този файл след това зависи от избраното от вас целево приложение или услуга.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Външни връзки';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Когато отворите външни връзки като хранилището на GitHub, приложението предава действието на вашия браузър или друго външно приложение. Обработката на данните след този момент се регулира от третата страна, която откривате.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Какво приложението не събира';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Приложението не изисква акаунт за Sked и не позволява анализи, рекламни идентификатори или резервно копиране в облака. Също така не предоставя специално поле за събиране на пароли за училищни акаунти. Ако влезете в училищен уебсайт в приложението, това взаимодействие се случва на страницата на училището, която сте отворили.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Парсиране на уеб страници';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Когато използвате импортиране или поставяне на HTML на училищна уеб страница за анализиране, приложението първо компресира съдържанието локално, след което изпраща предоставеното съдържание на страницата, незадължителното заглавие на страницата и URL адреса, текущия език на приложението и съдържанието на инструкцията за анализиране към избраната крайна точка за анализиране. Ако използвате официалния анализатор, заявката отива в конфигурирания официален бъкенд на приложението. Ако активирате персонализиран анализатор, съвместим с OpenAI, същото съдържание се изпраща директно към крайната точка на трета страна, която сте конфигурирали, а извличането на списъка с модели също изисква същата крайна точка. Персонализирана крайна точка може да препрати заявката на други услуги за изкуствен интелект в съответствие със собствения дизайн на този доставчик. Разположеният официален бъкенд в момента ограничава всеки подаден полезен товар до 300 KB, използва конфигурирания си таймаут и позволява най-много 5 заявки за анализиране на IP на ден.';

  @override
  String get privacyPolicyUpdatesTitle => 'Актуализации на политиката';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Настоящата версия на политиката за поверителност е $version. Ако по-късна версия промени начина, по който се обработват данните, приложението може да ви помоли да прочетете и да се съгласите отново с актуализираната политика.';
  }

  @override
  String get privacyGateTitle =>
      'Моля, съгласете се с политиката за поверителност преди да използвате приложението';

  @override
  String get privacyGateSummaryStorage =>
      'Разписанията, наборите от периоди и конфигурацията на училището се съхраняват само локално и не се качват автоматично на сървър на разработчика.';

  @override
  String get privacyGateSummaryImportExport =>
      'Импортирането, експортирането и споделянето се случват само когато изрично ги стартирате; анализирането на уеб страници изпраща само компресираното съдържание, което изпращате на конфигурираната крайна точка за анализиране, и можете да прегледате анализирания график, преди да го запишете.';

  @override
  String get privacyGateSummaryUpdates =>
      'Ако по-нова версия промени начина, по който се обработват данните, приложението може да ви помоли да прегледате отново актуализираната политика за поверителност.';

  @override
  String get schoolWebImportEntry => 'Импортиране от уебсайта на училището';

  @override
  String get schoolWebImportEntryDesc =>
      'Импортирайте текущата страница с график от сайта на училището.';

  @override
  String get schoolSitesManageEntry => 'Управление на училищните сайтове';

  @override
  String get schoolSitesManageEntryDesc =>
      'Добавяне, редактиране и изтриване на URL адреси за влизане в училище, с импортиране и експортиране на JSON.';

  @override
  String get schoolSitesPageTitle => 'Управление на училището';

  @override
  String get schoolSitesImportJson => 'Импортиране на JSON на училището';

  @override
  String get schoolSitesShareJson => 'Споделяне на училище JSON';

  @override
  String get schoolSitesSaveJson => 'Запазване на училището JSON';

  @override
  String get schoolSitesSaved => 'Спасени училищни сайтове';

  @override
  String get schoolSitesImported => 'Училищни сайтове, внесени';

  @override
  String get schoolSitesEmpty => 'Все още няма конфигурация на училището.';

  @override
  String get schoolSitesNameLabel => 'Име на училището';

  @override
  String get schoolSitesLoginUrlLabel => 'URL за влизане';

  @override
  String get schoolSitesAdd => 'Добавяне на училище';

  @override
  String get schoolSitesEdit => 'Редактиране на училище';

  @override
  String get schoolSitesDeleteTitle => 'Изтриване на училище';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Изтриване на \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Първо попълнете името на училището и URL адреса за влизане.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Импортиране чрез поставяне на съдържанието на страницата на графика';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Поставете изходния код или суровото съдържание на страницата, съдържащо информация за графика ръчно.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Анализиране на графика от съдържанието на страницата';

  @override
  String get schoolHtmlImportUrlLabel => 'URL на източника (незадължително)';

  @override
  String get schoolHtmlImportTitleLabel =>
      'Заглавие на страницата (незадължително)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Съдържание на страницата';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Поставете изходния код или суровото съдържание на страницата, съдържащо информация за графика тук.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Всяко съдържание, съдържащо информация за графика, може да бъде анализирано и импортирано, а не само HTML.';

  @override
  String get schoolHtmlImportCompress => 'Компресиране на съдържанието';

  @override
  String get schoolHtmlImportCompressed => 'Съдържание компресирано';

  @override
  String get schoolHtmlImportCompressFirst =>
      'Първо компресирайте съдържанието.';

  @override
  String get schoolHtmlImportSubmit => 'Анализ и импортиране';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Парсирането може да отнеме известно време. Моля те, изчакай.';

  @override
  String get schoolHtmlImportEmpty => 'Първо поставете HTML страницата.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Обратно към уебсайта';

  @override
  String get schoolWebImportPageTitle => 'Импортиране на училищни уеб страници';

  @override
  String get schoolWebImportPreview => 'Импортиране на предварителен преглед';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count курсове';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count периоди';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Заглавие на страницата';

  @override
  String get schoolWebImportParserUsed => 'Парсер';

  @override
  String get schoolWebImportWarnings => 'Внос на бележки';

  @override
  String get schoolWebImportOpenPageHint =>
      'Влезте в сайта на училището в приложението, след което навигирайте ръчно към страницата с график.';

  @override
  String get schoolWebImportConfigMissing =>
      'API за импортиране на уеб все още не е конфигуриран.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Тази платформа все още не поддържа вградено уеб влизане. Моля, използвайте платформа с поддръжка на WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Изберете училище';

  @override
  String get schoolWebImportNoSchools =>
      'Няма налична конфигурация на училището. Първо проверете school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Грешка при зареждане на конфигурацията на училището. Проверете формата на файла JSON.';

  @override
  String get schoolWebImportImportCurrentPage =>
      'Импортиране на текуща страница';

  @override
  String get schoolWebImportGoBack => 'Предишна страница';

  @override
  String get schoolWebImportLoadingPage => 'Страница се зарежда…';

  @override
  String get schoolWebImportParsing => 'Анализиране на текущата страница...';

  @override
  String get schoolWebImportLoadFailed =>
      'Страницата се зарежда неуспешно. Моля, освежете или опитайте отново по-късно.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Времето за зареждане на страницата изтече. Моля, освежете и опитайте отново.';

  @override
  String get schoolWebImportEmptyPage =>
      'Текущото съдържание на страницата е празно и все още не може да бъде импортирано.';

  @override
  String get schoolWebImportSuccess => 'Внесен уеб график';

  @override
  String get schoolImportParserSettingsTitle =>
      'Настройки на анализатора на графика';

  @override
  String get schoolImportParserSettingsDesc =>
      'Изберете официалния анализатор или персонализирана OpenAI-съвместима крайна точка.';

  @override
  String get schoolImportParserSourceTitle => 'Източник на анализатора';

  @override
  String get schoolImportParserSourceOfficial => 'Официален анализатор';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Използвайте вградената официална услуга за анализиране, конфигурирана от приложението.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Официалният анализатор използва конфигурирания анализиращ бъкенд на приложението и поддържа текущия поток от импорт непроменен.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Персонализиран OpenAI-съвместим';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Изпратете съдържанието на страницата директно на вашата собствена OpenAI-съвместима крайна точка.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Персонализиран OpenAI-съвместим анализатор';

  @override
  String get schoolImportParserCustomPromptTitle =>
      'Персонализирана инструкция';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Редактирайте вградената инструкция за анализиране тук. Промените засягат само персонализирания OpenAI-съвместим анализатор.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Вградената инструкция се зарежда тук по подразбиране. Изчистете го, за да се върнете към вградената версия.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Възстановяване на инструкцията по подразбиране';

  @override
  String get schoolImportParserBaseUrl => 'Базов URL адрес';

  @override
  String get schoolImportParserApiKey => 'API ключ';

  @override
  String get schoolImportParserModel => 'модел';

  @override
  String get schoolImportParserFetchModels => 'Вземи списък с модели';

  @override
  String get schoolImportParserFetchingModels => 'Вземане на модели. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Не са върнати модели от крайната точка.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Взети $count модели';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Персонализираният API ключ се съхранява в локалните настройки на приложението в обикновен текст при текущата реализация. Използвайте го само на устройство или среда за браузър, на която имате доверие.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Персонализираната конфигурация на анализатора е непълна. Първо попълнете базовия URL, API ключа и модела.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Парсер: Официален';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Парсер: Персонализиран ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Вижте пълната политика за поверителност';

  @override
  String get privacyAgreeAndContinue => 'Съгласен и продължи';

  @override
  String get privacyDecline => 'Отхвърли';

  @override
  String get privacyDeclineWebHint =>
      'Тази среда на браузъра не позволява на приложението да затвори страницата за вас. Ако не сте съгласни, моля затворете този раздел или прозорец сами.';

  @override
  String get defaultPeriodTimeSetName => 'Периоди по подразбиране';

  @override
  String get periodTimeSetFallbackName => 'Период време';

  @override
  String get untitledTimetableName => 'Беззаглавен график';

  @override
  String get newTimetableName => 'Нов график';

  @override
  String get newPeriodTimeSetName => 'Нов период от време';

  @override
  String get emptyTimetableName => 'Празен график';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name периоди';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Типът на файла за импортиране не съвпада.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Тази версия на файла за импортиране все още не се поддържа.';

  @override
  String get noPeriodTimesInImportMessage =>
      'В файла за импортиране не са намерени периодични времена.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Моля изберете поне един график.';

  @override
  String get noExportableTimetableMessage => 'Няма график за износ.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Замяната на текущия график поддържа само избора на един график.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Няма актуален график за замена.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Този период от време все още се използва от $count график(и). Препоръчвайте ги преди да ги изтриете.';
  }

  @override
  String get weekdayMonday => 'Понеделник';

  @override
  String get weekdayTuesday => 'Вторник';

  @override
  String get weekdayWednesday => 'сряда';

  @override
  String get weekdayThursday => 'Четвъртък';

  @override
  String get weekdayFriday => 'Петък';

  @override
  String get weekdaySaturday => 'събота';

  @override
  String get weekdaySunday => 'Неделя';

  @override
  String get weekdayShortMonday => 'понеделник';

  @override
  String get weekdayShortTuesday => 'Вторник';

  @override
  String get weekdayShortWednesday => 'сряда';

  @override
  String get weekdayShortThursday => 'Четвъртък';

  @override
  String get weekdayShortFriday => 'Петък';

  @override
  String get weekdayShortSaturday => 'събота';

  @override
  String get weekdayShortSunday => 'Слънцето';

  @override
  String get monthJanuary => 'януари';

  @override
  String get monthFebruary => 'Февруари';

  @override
  String get monthMarch => 'Март';

  @override
  String get monthApril => 'април';

  @override
  String get monthMay => 'май';

  @override
  String get monthJune => 'юни';

  @override
  String get monthJuly => 'юли';

  @override
  String get monthAugust => 'август';

  @override
  String get monthSeptember => 'септември';

  @override
  String get monthOctober => 'октомври';

  @override
  String get monthNovember => 'ноември';

  @override
  String get monthDecember => 'декември';

  @override
  String get semesterWeeksWholeTerm => 'Целият семестър';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Седмици $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Седмици $value';
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
