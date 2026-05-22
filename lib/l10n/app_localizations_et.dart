// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appTitle => 'Klassikaaslane';

  @override
  String weekLabel(int week) {
    return 'Nädal $week';
  }

  @override
  String get addCourse => 'Lisa kursus';

  @override
  String get settings => 'Seaded';

  @override
  String get multiTimetableSwitch => 'Ajavahemite vahetamine';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Praegune ajakava · $weeks nädalad';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Puudutage vahetamiseks · $weeks nädalad';
  }

  @override
  String get editTimetable => 'Ajaplani muutmine';

  @override
  String get createTimetable => 'Uus ajakava';

  @override
  String get jumpToWeek => 'Hüppa nädalale';

  @override
  String get timetable => 'Ajaaeg';

  @override
  String get timetableName => 'Ajarava nimi';

  @override
  String get totalWeeks => 'Nädalad kokku';

  @override
  String get delete => 'Kustuta';

  @override
  String get cancel => 'Tühista';

  @override
  String get save => 'Salvesta';

  @override
  String get deleteTimetableTitle => 'Kustuta ajakava';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Kustutada \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Veel ajakava pole';

  @override
  String get noTimetableMessage =>
      'Looge ajakava või importige üks JSON-failist.';

  @override
  String get importTimetable => 'Importimise ajakava';

  @override
  String get courseName => 'Kursuse nimi';

  @override
  String get location => 'Asukoht';

  @override
  String get dayOfWeek => 'Päev';

  @override
  String get semesterWeeks => 'Nädalad';

  @override
  String get startTime => 'Algusaeg';

  @override
  String get endTime => 'Lõpuaeg';

  @override
  String get linkedPeriods => 'Seotud perioodid';

  @override
  String get linkedPeriodsUnmatched =>
      'Praegune aeg ei vasta perioodidele. Valimiseks puudutage käsitsi.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Periood $start-$end';
  }

  @override
  String get teacherName => 'Õpetaja';

  @override
  String get credits => 'Krediidid';

  @override
  String get remarks => 'Märkused';

  @override
  String get customFields => 'Kohandatud väljad';

  @override
  String get customFieldsHint => 'Üks rida kohta, vorming: key:value';

  @override
  String get selectDayOfWeek => 'Vali päev';

  @override
  String get selectSemesterWeeks => 'Vali nädalad';

  @override
  String get selectAll => 'Vali kõik';

  @override
  String get clear => 'Puhasta';

  @override
  String get confirm => 'Kinnita';

  @override
  String get selectLinkedPeriods => 'Valige seotud perioodid';

  @override
  String get addCourseTitle => 'Lisa kursus';

  @override
  String get editCourseTitle => 'Muuda kursust';

  @override
  String get editCourseTooltip => 'Muuda kursust';

  @override
  String get place => 'Asukoht';

  @override
  String get time => 'Aeg';

  @override
  String get notFilled => 'Mitte täidetud';

  @override
  String get none => 'Ükski';

  @override
  String get conflictCourses => 'Konfliktlikud kursused';

  @override
  String get locationNotFilled => 'Asukoht ei ole täidetud';

  @override
  String get setAsDisplayed => 'Määrake näidatuna';

  @override
  String get editThisCourse => 'Redigeeri seda kursust';

  @override
  String get settingsTitle => 'Seaded';

  @override
  String get noTimetableSettings =>
      'Praegu ei ole seadete jaoks ajakava saadaval.';

  @override
  String get semesterStartDate => 'Semestri alguskuupäev';

  @override
  String get periodTimeSets => 'Perioodi määratud aeg';

  @override
  String get noPeriodTimeAvailable => 'Vabamat perioodi aega ei ole määratud';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count perioodid';
  }

  @override
  String get coursePopupDismissSetting =>
      'Luba väljaspool puudutada kursuse hüpikakna sulgemiseks';

  @override
  String get coursePopupDismissSettingHint =>
      'Selle välja lülitamine keelab ka nihkumise vallandamise.';

  @override
  String get preserveTimetableGaps => 'Ajaplaani puudujääkide säilitamine';

  @override
  String get preserveTimetableGapsHint =>
      'Kui välja, lõuna ja paus lüngad kokku nii hilisemad klassid liikuda üles.';

  @override
  String get showPastEndedCourses => 'Näita möödunud kursusi';

  @override
  String get showPastEndedCoursesHint =>
      'Näita kursusi, mis on juba lõppenud tõelise praeguse nädala heledama halli stiilis.';

  @override
  String get showFutureCourses => 'Näita tulevasi kursusi';

  @override
  String get showFutureCoursesHint =>
      'Näita kursusi, mis ei ole aktiivsed sel nädalal, kuid ilmuvad hilisematel nädalatel halli stiilis.';

  @override
  String get timetableDisplaySettings => 'Ajarava kuvamine ja suhtlemine';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup vallandamine, lüngad, hall kursused ja võrgu jooned';

  @override
  String get showTimetableGridLines => 'Näita ajakava võrgu joone';

  @override
  String get showTimetableGridLinesHint =>
      'Kontrollige, kas ajakavas on nähtavad horisontaalsed ja vertikaalsed võrgujooned.';

  @override
  String get liveCourseOutlineColor => 'Kursuse kontuuri värv';

  @override
  String get liveCourseOutlineColorHint =>
      'Valige, kas kontuurid on suunatud praegusele/järgmisele kursusele või kõigile praegusel lehel kuvatud kursustele.';

  @override
  String get liveCourseOutlineSettings => 'Kursuse ülevaade';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Konfigureerige, kas kontuur on lubatud, mida see suunab, kas see järgib teemavärvi ja efektiivset kontuurivärvi.';

  @override
  String get liveCourseOutlineEnabled => 'Luba kontur';

  @override
  String get liveCourseOutlineFollowTheme => 'Järgi teema värvi';

  @override
  String get liveCourseOutlineTarget => 'Eesmärk';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Praegune/järgmine kursus';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Kõik näidatud kursused';

  @override
  String get liveCourseOutlineEffectiveColor => 'Tõhus värv';

  @override
  String get liveCourseOutlineCustomColor => 'Kohandatud kontuurivärv';

  @override
  String get liveCourseOutlineWidth => 'Kontuuri laius';

  @override
  String get outlineWidthUnit => 'Px';

  @override
  String get language => 'keel';

  @override
  String get languagePageDescription =>
      'Valige üks rakenduses tõeliselt saadaval olevatest keeltest.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'Inglise keel';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API vastus';

  @override
  String get theme => 'Teema';

  @override
  String get themeFollowSystem => 'Jälgi süsteemi';

  @override
  String get themeLight => 'Valgus';

  @override
  String get themeDark => 'Tume';

  @override
  String get themeColor => 'Teemavärv';

  @override
  String get themeColorModeSingle => 'Ühe teema värv';

  @override
  String get themeColorModeColorful => 'Värviline';

  @override
  String get themeColorUiColors => 'UI värvid';

  @override
  String get themeColorCourseColors => 'Kursuse värvid';

  @override
  String get themeColorPrimary => 'esmane';

  @override
  String get themeColorSecondary => 'Sekundaarne';

  @override
  String get themeColorTertiary => 'Tertiaarne';

  @override
  String get themeColorCourseText => 'Kursuse tekst';

  @override
  String get themeColorCourseTextAuto => 'Automaatne';

  @override
  String get themeColorCourseTextCustom => 'Kohandatud värv';

  @override
  String get themeColorCourseColorsEmpty =>
      'Kursuse värvid genereeritakse pärast ajakava importimist.';

  @override
  String get themeCustomColor => 'Kohandatud värv';

  @override
  String get themeApplyCustomColor => 'Värvi rakendamine';

  @override
  String get themeApplySettings => 'Seadete rakendamine';

  @override
  String get dataImportExport => 'Import- ja ekspordiandmed';

  @override
  String get dataImportExportDesc =>
      'Importige täielikud andmed või üksikud ajakavad või eksportige praegused/kõik ajakavad.';

  @override
  String get openSourceLicenses => 'Avatud lähtekoodiga litsentsid';

  @override
  String get openSourceLicensesDesc =>
      'Vaata Flutteri sõltuvuste ja rakenduse ikoonide varude litsentse.';

  @override
  String get checkForUpdates => 'Uuenduste kontrollimine';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Ametlik veebileht / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Juba viimase versiooniga ($version)';
  }

  @override
  String get currentVersionLabel => 'Praegune versioon';

  @override
  String get newVersionAvailable => 'Uuendus saadaval';

  @override
  String get latestVersionLabel => 'Viimane versioon';

  @override
  String get updateContentLabel => 'Uuendamise üksikasjad';

  @override
  String get officialWebsite => 'Ametlik veebileht';

  @override
  String get googlePlay => 'Google Play\'i';

  @override
  String get cloudDrive => 'Pilvekäik';

  @override
  String get ignoreThisVersion => 'Ignoreeri seda versiooni';

  @override
  String get openUpdatesFailed => 'Uuenduslingi avamine nurjus';

  @override
  String get updateCheckFailedTitle => 'Uuenduse kontroll nurjus';

  @override
  String get updateCheckFailedMessage =>
      'Ei saa saada kehtivat värskenduste teavet mis tahes värskendusallikast. Siiski saate kasutada allpool olevaid linke käsitsi värskendamiseks.';

  @override
  String get githubRepository => 'GitHubi hoidlus';

  @override
  String get openGithubFailed => 'GitHubi salvestuse lingi avamine nurjus';

  @override
  String get selectPeriodTimeSet => 'Vali perioodi aeg';

  @override
  String get newItem => 'Uus';

  @override
  String get editPeriodTimeSet => 'Perioodi aja seadistuse muutmine';

  @override
  String get importTimetableFiles => 'Importimise ajakava';

  @override
  String get importTimetableFilesDesc => 'Toetab ühte või mitut ajakavafaili.';

  @override
  String get importTimetableText => 'Ajakaava importimine tekstist';

  @override
  String get importTimetableTextDesc =>
      'Kleebige ajakava JSON sisu ja importige see.';

  @override
  String get shareTimetableFiles => 'Jaga ajakavafaile';

  @override
  String get shareTimetableFilesDesc =>
      'Valige kõigepealt üks või mitu ajakava.';

  @override
  String get saveTimetableFiles => 'Ajakava failide salvestamine';

  @override
  String get saveTimetableFilesDesc =>
      'Valige kõigepealt üks või mitu ajakava.';

  @override
  String get exportTimetableText => 'Ekspordi ajakava tekstina';

  @override
  String get exportTimetableTextDesc =>
      'Valige üks või mitu ajakava ja seejärel kopeerige JSON-sisu.';

  @override
  String get jsonContent => 'JSON sisu';

  @override
  String get pasteJsonContentHint => 'Kleepige impordimiseks JSON-sisu.';

  @override
  String get jsonContentEmpty => 'Esiteks kleebige JSON sisu.';

  @override
  String get copyText => 'Kopeerimine';

  @override
  String get copiedToClipboard => 'Kopeeritud lõikepuhvrisse';

  @override
  String get share => 'Jaga';

  @override
  String get selectTimetablesToExport => 'Valige ekspordimiseks ajakavad';

  @override
  String get selectTimetablesToImport => 'Importimiseks ajakavade valimine';

  @override
  String timetableCourseCount(int count) {
    return '$count kursused';
  }

  @override
  String get importAction => 'Import';

  @override
  String get importTimetableDialogTitle => 'Importimise ajakava';

  @override
  String get chooseImportMethod => 'Valige, kuidas importida.';

  @override
  String get importAsNewTimetable => 'Import uue ajakavana';

  @override
  String get replaceCurrentTimetable => 'Asendada praegune ajakava';

  @override
  String get importPeriodTimeSetDialogTitle => 'Impordiperioodi ajakohad';

  @override
  String get importPeriodTimeSetDialogBody =>
      'See fail sisaldab komplekteeritud perioodi ajaseadmeid. Kas soovite neid importida ja ühendada?';

  @override
  String get importBundledPeriodTimeSets => 'Import ja assotsieerimine';

  @override
  String get discardBundledPeriodTimeSets => 'Visata komplektid ära';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Olemasolevat perioodi aegset ei ole saadaval, seega ei saa paketitud perioodi aegset kõrvaldada.';

  @override
  String savedToPath(Object path) {
    return 'Salvestatud $path';
  }

  @override
  String get saveCancelled => 'Salvestamine tühistatud';

  @override
  String get fileSaveRestrictedTitle => 'Faili salvestamine piiratud';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Süsteem ei suutnud faili salvestada. Selle asemel saate proovida uuesti või kasutada jagamist.';

  @override
  String get retrySave => 'Püüa salvestada uuesti';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Lubage süsteemi seadetes juurdepääs failidele, seejärel tagastage ja proovige uuesti eksportida.';

  @override
  String get openSettings => 'Ava seaded';

  @override
  String get browserDownloadRestrictedTitle =>
      'Brauseri allalaadimine piiratud';

  @override
  String get browserDownloadRestrictedMessage =>
      'See brauser ei toeta otse salvestamist kohalikku faili. Kontrollige brauseri allalaadimise õigusi või kasutage selle asemel failide jagamist.';

  @override
  String get switchToShare => 'Kasutage selle asemel jagamist';

  @override
  String get fileSaveFailedTitle => 'Faili salvestamine nurjus';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Praegusele teele kirjutamine nurjus. Sihtkaust võib olla kaitstud, fail võib olla kasutuses või tee võib olla kirjutamata.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Süsteem ei suutnud faili salvestada. Võite proovida uuesti, kontrollida süsteemi seadeid või selle asemel kasutada failide jagamist.';

  @override
  String get retryLater => 'Proovi hiljem uuesti';

  @override
  String get exportSwitchedToShare =>
      'Eksportimiseks failide jagamisele üles lülitatud';

  @override
  String get saveFailedRetry =>
      'Salvestamine nurjus. Palun proovige hiljem uuesti.';

  @override
  String get importFailedCheckContent =>
      'Importimine nurjus. Palun kontrollige faili sisu.';

  @override
  String get noImportableTimetables =>
      'Imporditud failist ei leitud kasutatavaid ajakavasid.';

  @override
  String importedTimetablesCount(int count) {
    return 'Imporditud $count ajakavad';
  }

  @override
  String get periodTimesTitle => 'Perioodi ajad';

  @override
  String get importExport => 'Import ja eksport';

  @override
  String get importPeriodTemplate => 'Impordiperioodi mall';

  @override
  String get importPeriodTemplateText => 'Perioodi malli importimine tekstist';

  @override
  String get sharePeriodTemplate => 'Osalemisperioodi mall';

  @override
  String get saveTemplateToFile => 'Malli salvestamine faili';

  @override
  String get exportPeriodTemplateText => 'Perioodi malli eksportimine tekstina';

  @override
  String get deletePeriodTimeSet => 'Kustuta perioodi aeg';

  @override
  String get periodTimeSetName => 'Perioodi aja määramise nimi';

  @override
  String get addOnePeriod => 'Lisa periood';

  @override
  String periodNumberLabel(int index) {
    return 'Periood $index';
  }

  @override
  String get deleteThisPeriod => 'Kustuta see periood';

  @override
  String durationMinutes(int minutes) {
    return 'Kestus $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Vahe eelmisest $minutes min';
  }

  @override
  String get endTimeMustBeLater => 'Lõppeaeg peab olema hiljem kui algusaeg';

  @override
  String get periodOverlapPrevious => 'See periood ületab eelmise';

  @override
  String get periodTimesSaved => 'Säästatud perioodiaeg';

  @override
  String get deletePeriodTimeSetTitle => 'Kustuta perioodi aeg';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Kustutada \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'kehtestatud praegune periood';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Imporditud $count perioodi aeg';
  }

  @override
  String get periodFilePermissionTitle => 'Vajalik faililoa';

  @override
  String get androidFilePermissionMessage =>
      'Android eksport nõuab failide juurdepääsu luba. Andke luba jätkata säästmist.';

  @override
  String get reauthorize => 'Autoriseerida uuesti';

  @override
  String get permissionPermanentlyDeniedTitle => 'Luba jäädavalt keelatud';

  @override
  String get permissionSettingsExportMessage =>
      'Lubage süsteemi seadetes juurdepääs failidele, seejärel tagastage ja proovige uuesti eksportida.';

  @override
  String get privacyPolicyTitle => 'Privaatsuspoliitika';

  @override
  String get privacyPolicyEntryDesc =>
      'Uuri, kuidas rakendus käsitleb kohalikku salvestust, kooli saidi konfiguratsiooni, failide importi/eksporti, veebilehtede analüüsi ja välislinke.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Aksepteeritud versioon: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked on lokaalselt töötav tunniplaani tööriist. Tunniplaanid, perioodide komplektid ja kooli saidi konfiguratsioon salvestatakse ainult teie seadmes või brauseris ning neid ei laadita kunagi automaatselt üles. Rakendus töötleb andmeid ainult siis, kui käivitate selgesõnaliselt selliseid toiminguid nagu importimine, veebilehe analüüs, jagamine või väliste linkide avamine. Täielik privaatsuspoliitika on saadaval veebis.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Kohalik ladustamine';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Ajaplaani andmed ja nendega seotud seaded salvestatakse kohalikusse faili nimega Sked_data.json rakenduse dokumentide kataloogis. Kooli saidi redigeeritav konfiguratsioon salvestatakse eraldi Sked_school_sites.jsonis. Kohandatud ajakava parseri seaded, sealhulgas mis tahes kohandatud baas-URL, API-võti ja valitud mudel, salvestatakse samuti kohalikult samades rakendusandmetes ja neid ei kaitse süsteemi usaldusväärsuste turv. Kui seda kasutatakse brauseris, salvestatakse brauseri salvestusse sama tüüpi andmeid. Rakendus ei laadi neid kohalikke andmeid automaatselt üles arendaja kontrollitud serverisse.';

  @override
  String get privacyPolicyImportExportTitle => 'Import ja eksport';

  @override
  String get privacyPolicyImportExportBody =>
      'Rakendus loeb või kirjutab ajakava JSON-faile, kooli saidi JSON-faile ja perioodimallifaile ainult siis, kui olete sõnaselgelt valinud faili või alustanud eksporditegevust. Nende failide importimine on kohalik toiming, kui te ei valiks ka veebilehe analüüsimist. Kohandatud mudeliloendi hankimine on ka selgesõnaline võrgutegevus ja võtab ühendust ainult teie konfigureeritud kohandatud lõpppunktiga.';

  @override
  String get privacyPolicySharingTitle => 'Jagamine';

  @override
  String get privacyPolicySharingBody =>
      'Kui kasutate selgesõnaliselt jagamist, edastab rakendus eksportitud faili süsteemi jagamise lehele või valitud sihrrakendusele. Kuidas seda faili hiljem käsitletakse, sõltub valitud sihrrakendusest või teenusest.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Välislingid';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Kui avate välislinge, näiteks GitHubi hoiu, annab rakendus tegevuse teie brauserile või muule välisele rakendusele. Andmete töötlemist pärast seda punkti reguleerib teie avatud kolmas isik.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Mida rakendus ei kogugi';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Rakendus ei vaja Sked\'i kontot ja ei võimalda analüüsi, reklaamide identifitseerijaid ega pilvevarukoopiat. Samuti ei paku see spetsiaalset väljad koolikonto paroolide kogumiseks. Kui sisse logite rakenduse sees kooli veebisaidile, toimub see suhtlemine kooli lehel, mille avasite.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Veebilehe analüüs';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Kui kasutate kooli veebilehe importimist või kleepimist HTML-i analüüsimiseks, tihendab rakendus sisu kõigepealt kohalikult, seejärel saadab esitatud lehekülje sisu, vabatahtliku lehekülje pealkirja ja URL-i, praeguse rakenduse keele ja analüüsikutse sisu valitud analüüsimise lõpppunkti. Kui kasutate ametlikku parserit, läheb taotlus rakenduse konfigureeritud ametlikule tagaseadmele. Kui lubate kohandatud OpenAI-ga ühilduva parseri, saadetakse sama sisu otse teie konfigureeritud kolmanda osapoole lõpppunkti ja mudeliloendi hankimine nõuab ka sama lõpppunkti. Kohandatud lõppkoht võib taotluse edastada teistele AI-teenustele vastavalt selle pakkuja enda disainile. Kasutatud ametlik tagaseade piirab praegu iga esitatud kasuliku koormuse 300 KB-ni, kasutab selle konfigureeritud ajavahetust ja võimaldab maksimaalselt 5 analüüsitaotlust IP-i kohta päevas.';

  @override
  String get privacyPolicyUpdatesTitle => 'Poliitika uuendused';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Praegune privaatsuspoliitika versioon on $version. Kui uuem versioon muudab andmete töötlemise viisi, võib rakendus paluda teil uuendatud eeskirja uuesti lugeda ja sellega nõustuda.';
  }

  @override
  String get privacyGateTitle =>
      'Palun nõustu privaatsuspoliitikaga enne rakenduse kasutamist';

  @override
  String get privacyGateSummaryStorage =>
      'Ajaplaanid, ajavahemikud ja kooli saidi konfiguratsioon salvestatakse ainult kohalikult ning neid ei laadita automaatselt üles arendaja serverisse.';

  @override
  String get privacyGateSummaryImportExport =>
      'Import, eksport ja jagamine toimuvad ainult siis, kui neid selgesõnaliselt käivitate; Veebilehe analüüsimine saadab ainult teie konfigureeritud analüüsimise lõpppunktile esitatud surutud sisu ja enne salvestamist saate analüüsitud ajakava vaadata.';

  @override
  String get privacyGateSummaryUpdates =>
      'Kui hilisem versioon muudab andmete töötlemise viisi, võib rakendus paluda teil uuendatud privaatsuspoliitikat uuesti vaadata.';

  @override
  String get schoolWebImportEntry => 'Import kooli veebilehelt';

  @override
  String get schoolWebImportEntryDesc =>
      'Importige praegune ajakava lehekülg kooli saidilt.';

  @override
  String get schoolSitesManageEntry => 'Kooli saitide haldamine';

  @override
  String get schoolSitesManageEntryDesc =>
      'Lisage, muuta ja kustutage kooli sisselogimise URL-id, kasutades JSON-impordi ja -eksporti.';

  @override
  String get schoolSitesPageTitle => 'Kooli koha juhtimine';

  @override
  String get schoolSitesImportJson => 'Kooli JSON importimine';

  @override
  String get schoolSitesShareJson => 'Jaga kooli JSON';

  @override
  String get schoolSitesSaveJson => 'Salvesta kooli JSON';

  @override
  String get schoolSitesSaved => 'Kooli saitid salvestatud';

  @override
  String get schoolSitesImported => 'Imporditud koolikohad';

  @override
  String get schoolSitesEmpty => 'Kooli veebilehe konfiguratsioon veel puudub.';

  @override
  String get schoolSitesNameLabel => 'Kooli nimi';

  @override
  String get schoolSitesLoginUrlLabel => 'Logi sisse URL';

  @override
  String get schoolSitesAdd => 'Lisa kool';

  @override
  String get schoolSitesEdit => 'Kooli muutmine';

  @override
  String get schoolSitesDeleteTitle => 'Kooli kustutamine';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Kustutada \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Täitke esimesena kooli nimi ja sisselogimise URL.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry => 'Import ajakava lehekülje sisu kleepides';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Kleebige lähtekood või ajakava teavet sisaldav lehekülje sisu käsitsi.';

  @override
  String get schoolHtmlImportPageTitle => 'Ajakava analüüs lehekülje sisust';

  @override
  String get schoolHtmlImportUrlLabel => 'Allika URL (vabatahtlik)';

  @override
  String get schoolHtmlImportTitleLabel => 'Lehekülje pealkiri (vabatahtlik)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Lehekülje sisu';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Kleebige lähtekood või ajakava teavet sisaldav lehekülje sisu siia.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Iga sisu, mis sisaldab ajakava teavet, saab analüüsida ja impordida, mitte ainult HTML-i.';

  @override
  String get schoolHtmlImportCompress => 'Sisu kompressioon';

  @override
  String get schoolHtmlImportCompressed => 'Sisu surutud';

  @override
  String get schoolHtmlImportCompressFirst => 'Kõigepealt lülitage sisu.';

  @override
  String get schoolHtmlImportSubmit => 'Analüüs ja import';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsimine võib võtta mõnda aega. Palun oota.';

  @override
  String get schoolHtmlImportEmpty => 'Esiteks kleebige lehekülg HTML.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Tagasi veebilehele';

  @override
  String get schoolWebImportPageTitle => 'Kooli veebilehe importimine';

  @override
  String get schoolWebImportPreview => 'Import eelvaate';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count kursused';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count perioodid';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Lehekülje pealkiri';

  @override
  String get schoolWebImportParserUsed => 'Parseri';

  @override
  String get schoolWebImportWarnings => 'Märkide importimine';

  @override
  String get schoolWebImportOpenPageHint =>
      'Logige sisse kooli saidile rakenduses, seejärel liikuge ajakava lehele käsitsi.';

  @override
  String get schoolWebImportConfigMissing =>
      'Veebiimpordi tausta API ei ole veel konfigureeritud.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'See platvorm ei toeta veel sisseehitatud veebi sisselogimist. Palun kasutage platvormi WebView toetusega.';

  @override
  String get schoolWebImportSelectSchool => 'Vali kool';

  @override
  String get schoolWebImportNoSchools =>
      'Kooli konfiguratsioon ei ole saadaval. Kontrollige kõigepealt school_sites.jsoni.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Kooli konfiguratsiooni laadimine nurjus. Kontrollige JSON failivormingut.';

  @override
  String get schoolWebImportImportCurrentPage =>
      'Praeguse lehekülje importimine';

  @override
  String get schoolWebImportGoBack => 'Eelmine lehekülg';

  @override
  String get schoolWebImportLoadingPage => 'Lehekülje laadimine…';

  @override
  String get schoolWebImportParsing => 'Aktiivse lehekülje analüüsimine...';

  @override
  String get schoolWebImportLoadFailed =>
      'Lehekülje laadimine nurjus. Palun värskendage või proovige hiljem uuesti.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Lehekülje laadimise aeg on möödunud. Palun värskendage ja proovige uuesti.';

  @override
  String get schoolWebImportEmptyPage =>
      'Praeguse lehekülje sisu on tühi ja seda ei saa veel importida.';

  @override
  String get schoolWebImportSuccess => 'Veebi ajakava imporditud';

  @override
  String get schoolImportParserSettingsTitle => 'Ajaplaani parseri seaded';

  @override
  String get schoolImportParserSettingsDesc =>
      'Valige ametlik parser või kohandatud OpenAI-ga ühilduv lõpppunkt.';

  @override
  String get schoolImportParserSourceTitle => 'Parseri allikas';

  @override
  String get schoolImportParserSourceOfficial => 'Ametlik parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Kasutage rakenduse konfigureeritud sisseehitatud ametlikku analüüsiteenust.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Ametlik parser kasutab rakenduse konfigureeritud parsimise tausta ja hoiab praeguse impordivoogu muutmata.';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'Custom OpenAI-ga ühilduv';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Saatke lehekülje sisu otse oma OpenAI-ga ühilduvale lõpppunktile.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'OpenAI-ga ühilduv kohandatud parser';

  @override
  String get schoolImportParserCustomPromptTitle => 'Kohandatud kutse';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Siin muuda sisseehitatud parseri kutset. Muutused mõjutavad ainult kohandatud OpenAI-ga ühilduvat parserit.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Sisseehitatud käsk laaditakse siin vaikimisi. Puhastage see, et tagasi sisseehitatud versiooni.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Vaikimisi kutse taastamine';

  @override
  String get schoolImportParserBaseUrl => 'Baas URL';

  @override
  String get schoolImportParserApiKey => 'API võti';

  @override
  String get schoolImportParserModel => 'mudel';

  @override
  String get schoolImportParserFetchModels => 'Mudelite nimekirja hankimine';

  @override
  String get schoolImportParserFetchingModels => 'Kutsu mudeleid. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Ükski mudel ei tagastatud lõpppunktiks.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Toodud $count mudelid';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Kohandatud API võti salvestatakse rakenduse kohalikes seadetes lihttekstis praeguse rakenduse raames. Kasutage seda ainult seadmes või brauseri keskkonnas, mida usaldate.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Kohandatud parseri konfiguratsioon ei ole täielik. Täida esmalt baas URL, API võti ja mudel.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Ametlik';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: kohandatud ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Vaata täielikku privaatsuspoliitikat';

  @override
  String get privacyAgreeAndContinue => 'Nõustu ja jätka';

  @override
  String get privacyDecline => 'Välja lükata';

  @override
  String get privacyDeclineWebHint =>
      'See brauseri keskkond ei võimalda rakendusel teie eest lehekülge sulgeda. Kui te ei nõustu, sulgege see vahekaardi või akna ise.';

  @override
  String get defaultPeriodTimeSetName => 'Vaikimisperioodid';

  @override
  String get periodTimeSetFallbackName => 'Perioodi ajad';

  @override
  String get untitledTimetableName => 'Pealkirjata ajakava';

  @override
  String get newTimetableName => 'Uus ajakava';

  @override
  String get newPeriodTimeSetName => 'Uus perioodi aeg';

  @override
  String get emptyTimetableName => 'Tühi ajakava';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name perioodid';
  }

  @override
  String get importFileTypeMismatchMessage => 'Faili tüüp ei vasta.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Seda impordifaili versiooni ei toetata veel.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Impordifailis ei leitud perioodi aega.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Palun valige vähemalt üks ajakava.';

  @override
  String get noExportableTimetableMessage => 'Ekspordi ajakava puudub.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Praeguse ajakava asendamine toetab ainult ühe ajakava valikut.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Praegust ajakava asendamiseks ei ole.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Seda perioodi ajaseadet kasutab endiselt $count ajakava(d). Andke need enne kustutamist uuesti.';
  }

  @override
  String get weekdayMonday => 'Esmaspäev';

  @override
  String get weekdayTuesday => 'Teisipäev';

  @override
  String get weekdayWednesday => 'Kolmapäev';

  @override
  String get weekdayThursday => 'Neljapäev';

  @override
  String get weekdayFriday => 'Reede';

  @override
  String get weekdaySaturday => 'Laupäev';

  @override
  String get weekdaySunday => 'Pühapäev';

  @override
  String get weekdayShortMonday => 'esmaspäev';

  @override
  String get weekdayShortTuesday => 'Teisipäev';

  @override
  String get weekdayShortWednesday => 'Kolmapäev';

  @override
  String get weekdayShortThursday => 'neljapäev';

  @override
  String get weekdayShortFriday => 'reede';

  @override
  String get weekdayShortSaturday => 'laupäev';

  @override
  String get weekdayShortSunday => 'Päike';

  @override
  String get monthJanuary => 'jaanuar';

  @override
  String get monthFebruary => 'veebruar';

  @override
  String get monthMarch => 'märts';

  @override
  String get monthApril => 'aprill';

  @override
  String get monthMay => 'mai';

  @override
  String get monthJune => 'juuni';

  @override
  String get monthJuly => 'juuli';

  @override
  String get monthAugust => 'august';

  @override
  String get monthSeptember => 'Sept';

  @override
  String get monthOctober => 'oktoober';

  @override
  String get monthNovember => 'veebruar';

  @override
  String get monthDecember => 'detsember';

  @override
  String get semesterWeeksWholeTerm => 'Kõik semestrid';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Nädalad $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Nädalad $value';
  }
}
