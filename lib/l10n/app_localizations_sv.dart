// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Klasskamrat';

  @override
  String weekLabel(int week) {
    return 'Vecka $week';
  }

  @override
  String get addCourse => 'Lägg till kurs';

  @override
  String get settings => 'Inställningar';

  @override
  String get multiTimetableSwitch => 'Byt tidtabeller';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Aktuell tidtabell · $weeks veckor';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Tryck för att växla · $weeks veckor';
  }

  @override
  String get editTimetable => 'Redigera tidtabell';

  @override
  String get createTimetable => 'Ny tidtabell';

  @override
  String get jumpToWeek => 'Hoppa till veckan';

  @override
  String get timetable => 'Tidsplan';

  @override
  String get timetableName => 'Tidsplan namn';

  @override
  String get totalWeeks => 'Totalt veckor';

  @override
  String get delete => 'Ta bort';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Spara';

  @override
  String get deleteTimetableTitle => 'Ta bort tidsplan';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Ta bort \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Ingen tidtabell ännu';

  @override
  String get noTimetableMessage =>
      'Skapa en tidsplan eller importera en från en JSON-fil.';

  @override
  String get importTimetable => 'Importera tidtabell';

  @override
  String get courseName => 'Kursnamn';

  @override
  String get location => 'Läge';

  @override
  String get dayOfWeek => 'dag';

  @override
  String get semesterWeeks => 'veckor';

  @override
  String get startTime => 'Starttid';

  @override
  String get endTime => 'Sluttid';

  @override
  String get linkedPeriods => 'Länkade perioder';

  @override
  String get linkedPeriodsUnmatched =>
      'Inga perioder matchade för aktuell tid. Tryck för att välja manuellt.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Period $start-$end';
  }

  @override
  String get teacherName => 'Lärare';

  @override
  String get credits => 'Krediter';

  @override
  String get remarks => 'Anmärkningar';

  @override
  String get customFields => 'Anpassade fält';

  @override
  String get customFieldsHint => 'En per rad, format: nyckel:värde';

  @override
  String get selectDayOfWeek => 'Välj dag';

  @override
  String get selectSemesterWeeks => 'Välj veckor';

  @override
  String get selectAll => 'Välj alla';

  @override
  String get clear => 'Rensa';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get selectLinkedPeriods => 'Välj länkade perioder';

  @override
  String get addCourseTitle => 'Lägg till kurs';

  @override
  String get editCourseTitle => 'Redigera kurs';

  @override
  String get editCourseTooltip => 'Redigera kurs';

  @override
  String get place => 'Läge';

  @override
  String get time => 'Tid';

  @override
  String get notFilled => 'Inte fyllt';

  @override
  String get none => 'Ingen';

  @override
  String get conflictCourses => 'Konflikterande kurser';

  @override
  String get locationNotFilled => 'Plats inte fyllt';

  @override
  String get setAsDisplayed => 'Ange som visas';

  @override
  String get editThisCourse => 'Redigera denna kurs';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get noTimetableSettings =>
      'Ingen tidsplan finns för närvarande tillgänglig för inställningar.';

  @override
  String get semesterStartDate => 'Startdatum för terminen';

  @override
  String get periodTimeSets => 'Periodisk tidsinställning';

  @override
  String get noPeriodTimeAvailable => 'Ingen tillgänglig tidsperiod';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count perioder';
  }

  @override
  String get coursePopupDismissSetting =>
      'Tillåt att trycka utanför för att stänga kurs popup';

  @override
  String get coursePopupDismissSettingHint =>
      'Om du stänger av detta inaktiverar du också svepningsnedladdning.';

  @override
  String get preserveTimetableGaps => 'Behålla tidstabellsluckor';

  @override
  String get preserveTimetableGapsHint =>
      'När du är av kollapsar lunch- och pausluckor så att senare klasser flyttar uppåt.';

  @override
  String get showPastEndedCourses => 'Visa tidigare avslutade kurser';

  @override
  String get showPastEndedCoursesHint =>
      'Visa kurser som redan har avslutats av den verkliga aktuella veckan med en ljusgrå stil.';

  @override
  String get showFutureCourses => 'Visa framtida kurser';

  @override
  String get showFutureCoursesHint =>
      'Visa kurser som inte är aktiva denna vecka men kommer att visas senare veckor med en grå stil.';

  @override
  String get timetableDisplaySettings => 'Tidsplan visning och interaktion';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup uppsägning, luckor, grå kurser och rutnätlinjer';

  @override
  String get showTimetableGridLines => 'Visa rutnätlinjer i tidtabellen';

  @override
  String get showTimetableGridLinesHint =>
      'Kontrollera om horisontella och vertikala nätlinjer är synliga i schemat.';

  @override
  String get liveCourseOutlineColor => 'Färg på kursen';

  @override
  String get liveCourseOutlineColorHint =>
      'Välj om konturerna riktar sig till nuvarande/nästa kurs eller alla kurser som visas på den aktuella sidan.';

  @override
  String get liveCourseOutlineSettings => 'Kursbeskrivning';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Konfigurera om konturen är aktiverad, vad den riktar sig till, om den följer temafärgen och den effektiva konturfärgen.';

  @override
  String get liveCourseOutlineEnabled => 'Aktivera kontur';

  @override
  String get liveCourseOutlineFollowTheme => 'Följ temafärg';

  @override
  String get liveCourseOutlineTarget => 'Omfattande mål';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Aktuell/nästa kurs';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Alla kurser som visas';

  @override
  String get liveCourseOutlineEffectiveColor => 'Effektiv färg';

  @override
  String get liveCourseOutlineCustomColor => 'Anpassad konturfärg';

  @override
  String get liveCourseOutlineWidth => 'Omrisbredd';

  @override
  String get outlineWidthUnit => 'Px';

  @override
  String get language => 'Språk';

  @override
  String get languagePageDescription =>
      'Välj ett av de språk som verkligen är tillgängliga i appen.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'Svenska';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API-svar';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Följ systemet';

  @override
  String get themeLight => 'Ljus';

  @override
  String get themeDark => 'mörk';

  @override
  String get themeColor => 'Temafärg';

  @override
  String get themeColorModeSingle => 'Färg för ett tema';

  @override
  String get themeColorModeColorful => 'Färgrika';

  @override
  String get themeColorUiColors => 'UI färger';

  @override
  String get themeColorCourseColors => 'Kursfärger';

  @override
  String get themeColorPrimary => 'Primära';

  @override
  String get themeColorSecondary => 'Sekundär';

  @override
  String get themeColorTertiary => 'Tertiär';

  @override
  String get themeColorCourseText => 'Kurstext';

  @override
  String get themeColorCourseTextAuto => 'automatiskt';

  @override
  String get themeColorCourseTextCustom => 'Anpassad färg';

  @override
  String get themeColorCourseColorsEmpty =>
      'Kursfärger genereras efter import av en tidsplan.';

  @override
  String get themeCustomColor => 'Anpassad färg';

  @override
  String get themeApplyCustomColor => 'Använd färg';

  @override
  String get themeApplySettings => 'Använd inställningar';

  @override
  String get dataImportExport => 'Import och export av data';

  @override
  String get dataImportExportDesc =>
      'Importera hela data eller enskilda tidtabeller eller exportera aktuella/alla tidtabeller.';

  @override
  String get openSourceLicenses => 'Licenser med öppen källkod';

  @override
  String get openSourceLicensesDesc =>
      'Visa licenser för Flutter-beroenden och paketerade app-ikontillgångar.';

  @override
  String get checkForUpdates => 'Kontrollera uppdateringar';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Redan på den senaste versionen ($version)';
  }

  @override
  String get currentVersionLabel => 'Aktuell version';

  @override
  String get newVersionAvailable => 'Uppdatering tillgänglig';

  @override
  String get latestVersionLabel => 'Senaste versionen';

  @override
  String get updateContentLabel => 'Uppdatera detaljer';

  @override
  String get officialWebsite => 'Officiell hemsida';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Cloud Drive';

  @override
  String get ignoreThisVersion => 'Ignorera denna version';

  @override
  String get openUpdatesFailed => 'Kan inte öppna uppdateringslänken';

  @override
  String get updateCheckFailedTitle => 'Uppdateringskontroll misslyckades';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'GitHub-arkiv';

  @override
  String get openGithubFailed =>
      'Kan inte öppna länken till GitHub-repositoriet';

  @override
  String get selectPeriodTimeSet => 'Välj tidsinställd period';

  @override
  String get newItem => 'Nya';

  @override
  String get editPeriodTimeSet => 'Redigera tidsinställd period';

  @override
  String get importTimetableFiles => 'Importera tidtabell';

  @override
  String get importTimetableFilesDesc =>
      'Stödjer en eller flera tidstabellfiler.';

  @override
  String get importTimetableText => 'Importera tidsplan från text';

  @override
  String get importTimetableTextDesc =>
      'Klistra in tidstabellen JSON innehåll och importera det.';

  @override
  String get shareTimetableFiles => 'Dela tidstabellfiler';

  @override
  String get shareTimetableFilesDesc =>
      'Välj en eller flera tidtabeller först.';

  @override
  String get saveTimetableFiles => 'Spara tidstabellfiler';

  @override
  String get saveTimetableFilesDesc => 'Välj en eller flera tidtabeller först.';

  @override
  String get exportTimetableText => 'Exportera tidtabell som text';

  @override
  String get exportTimetableTextDesc =>
      'Välj en eller flera tidtabeller och kopiera sedan JSON-innehållet.';

  @override
  String get jsonContent => 'JSON-innehåll';

  @override
  String get pasteJsonContentHint =>
      'Klistra in JSON-innehållet för att importera.';

  @override
  String get jsonContentEmpty => 'Klistra in JSON-innehållet först.';

  @override
  String get copyText => 'Kopiera';

  @override
  String get copiedToClipboard => 'Kopierad till klippstavla';

  @override
  String get share => 'Dela';

  @override
  String get selectTimetablesToExport => 'Välj tidtabeller att exportera';

  @override
  String get selectTimetablesToImport => 'Välj tidtabeller att importera';

  @override
  String timetableCourseCount(int count) {
    return '$count kurser';
  }

  @override
  String get importAction => 'Importera';

  @override
  String get importTimetableDialogTitle => 'Importera tidtabell';

  @override
  String get chooseImportMethod => 'Välj hur du importerar.';

  @override
  String get importAsNewTimetable => 'Importera som ny tidtabell';

  @override
  String get replaceCurrentTimetable => 'Ersätta aktuell tidsplan';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Importera tidsuppsättningar för perioden';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Den här filen innehåller bundlade periodtidsuppsättningar. Vill du importera och associera dem?';

  @override
  String get importBundledPeriodTimeSets => 'Importera och associera';

  @override
  String get discardBundledPeriodTimeSets => 'Kastera bundlade uppsättningar';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Ingen befintlig periodtidsuppsättning är tillgänglig, så bundlade periodtidsuppsättningar kan inte kasseras.';

  @override
  String savedToPath(Object path) {
    return 'Sparad till $path';
  }

  @override
  String get saveCancelled => 'Spara inställd';

  @override
  String get fileSaveRestrictedTitle => 'Filsparning begränsad';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Systemet kunde inte spara filen. Du kan försöka igen eller använda delning istället.';

  @override
  String get retrySave => 'Försök spara igen';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Aktivera filåtkomst i systeminställningarna, gå sedan tillbaka och försök exportera igen.';

  @override
  String get openSettings => 'Öppna inställningar';

  @override
  String get browserDownloadRestrictedTitle =>
      'Nedladdning av webbläsare begränsad';

  @override
  String get browserDownloadRestrictedMessage =>
      'Denna webbläsare stöder inte direkt sparning till en lokal fil. Kontrollera nedladdningsbehörigheter i webbläsaren eller använd fildelning istället.';

  @override
  String get switchToShare => 'Använd delning istället';

  @override
  String get fileSaveFailedTitle => 'Filsparning misslyckades';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Kan inte skriva till aktuell sökväg. Målmappen kan vara skyddad, filen kan vara i användning eller vägen kan inte skrivas.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Systemet kunde inte spara filen. Du kan försöka igen, kontrollera systeminställningarna eller använda fildelning istället.';

  @override
  String get retryLater => 'Försök igen senare';

  @override
  String get exportSwitchedToShare => 'Bytt till fildelning för export';

  @override
  String get saveFailedRetry => 'Sparandet misslyckades. Försök igen senare.';

  @override
  String get importFailedCheckContent =>
      'Importen misslyckades. Kontrollera filens innehåll.';

  @override
  String get noImportableTimetables =>
      'Inga användbara tidtabeller hittades i den importerade filen.';

  @override
  String importedTimetablesCount(int count) {
    return 'Importerade $count tidtabeller';
  }

  @override
  String get periodTimesTitle => 'Periodtider';

  @override
  String get importExport => 'Import och export';

  @override
  String get importPeriodTemplate => 'Importera periodmall';

  @override
  String get importPeriodTemplateText => 'Importera periodmall från text';

  @override
  String get sharePeriodTemplate => 'Mall för aktieperiod';

  @override
  String get saveTemplateToFile => 'Spara mall till fil';

  @override
  String get exportPeriodTemplateText => 'Exportera periodmall som text';

  @override
  String get deletePeriodTimeSet => 'Ta bort tidsinställd period';

  @override
  String get periodTimeSetName => 'Namn på tidsinställning för perioden';

  @override
  String get addOnePeriod => 'Lägg till period';

  @override
  String periodNumberLabel(int index) {
    return 'Period $index';
  }

  @override
  String get deleteThisPeriod => 'Ta bort denna period';

  @override
  String durationMinutes(int minutes) {
    return 'Längd $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Gap från tidigare $minutes min';
  }

  @override
  String get endTimeMustBeLater => 'Sluttid måste vara senare än starttid';

  @override
  String get periodOverlapPrevious => 'Denna period överlappar den föregående';

  @override
  String get periodTimesSaved => 'Sparade periodtider';

  @override
  String get deletePeriodTimeSetTitle => 'Ta bort tidsinställd period';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Ta bort \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'tidsinställning för aktuell period';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Importerade $count periodtider';
  }

  @override
  String get periodFilePermissionTitle => 'Filbehörighet behövs';

  @override
  String get androidFilePermissionMessage =>
      'Android-export kräver filåtkomsttillstånd. Ge tillstånd att fortsätta spara.';

  @override
  String get reauthorize => 'Autorisera igen';

  @override
  String get permissionPermanentlyDeniedTitle => 'Tillstånd förnekat permanent';

  @override
  String get permissionSettingsExportMessage =>
      'Aktivera filåtkomst i systeminställningarna, gå sedan tillbaka och försök exportera igen.';

  @override
  String get privacyPolicyTitle => 'Integritetspolicy';

  @override
  String get privacyPolicyEntryDesc =>
      'Lär dig hur appen hanterar lokal lagring, konfiguration av skolans webbplats, import/export av filer, analys av webbsidor och externa länkar.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Godkänd version: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked är ett lokalt-först schemaverktyg. Scheman, periodtidsuppsättningar och skolwebbplatskonfiguration lagras endast på din enhet eller i din webbläsare och laddas aldrig upp automatiskt. Appen behandlar endast data när du uttryckligen startar åtgärder som import, webbsidoparsning, delning eller öppnande av externa länkar. Den fullständiga integritetspolicyn finns tillgänglig online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lokal förvaring';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Tidstabelldata och relaterade inställningar lagras i en lokal fil som heter Sked_data.json i appens dokumentkatalog. Redigerbar skola-webbplatskonfiguration lagras separat i Sked_school_sites.json. Anpassade inställningar för tidstabellparser, inklusive eventuella anpassade basadresser, API-nycklar och utvalda modeller, lagras också lokalt i samma appdata och skyddas inte av ett systemloginvälv. När den används i en webbläsare lagras samma typer av data i webbläsarens lagring. Appen laddar inte upp dessa lokala data automatiskt till en utvecklarkontrollerad server.';

  @override
  String get privacyPolicyImportExportTitle => 'Import och export';

  @override
  String get privacyPolicyImportExportBody =>
      'Appen läser eller skriver JSON-filer för tidstabeller, JSON-filer för skolor och periodmallar endast när du uttryckligen väljer en fil eller startar en exportåtgärd. Importera dessa filer är en lokal åtgärd om du inte också väljer webbsidoparsing. Att hämta en anpassad modelllista är också en explicit nätverksåtgärd och kontaktar bara den anpassade slutpunkten du konfigurerat.';

  @override
  String get privacyPolicySharingTitle => 'Delning';

  @override
  String get privacyPolicySharingBody =>
      'När du uttryckligen använder delning skickar appen den exporterade filen till systemdelningsbladet eller till den målapp du väljer. Hur filen hanteras senare beror på vilken målapp eller tjänst du väljer.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Externa länkar';

  @override
  String get privacyPolicyExternalLinksBody =>
      'När du öppnar externa länkar som GitHub-repositoriet överlämnar appen åtgärden till din webbläsare eller ett annat externt program. Datahantering efter denna punkt regleras av den tredje part du öppnar.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Vad appen inte samlar in';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Appen kräver inte ett Sked-konto och aktiverar inte analys, annonseringsidentifierare eller molnsäkerhetskopiering. Det tillhandahåller inte heller ett dedikerat fält för att samla in lösenord för skolkonton. Om du loggar in på en skolas webbplats i appen sker den interaktionen på skolans sida du öppnade.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Analysering av webbsidor';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'När du använder skolans webbsida import eller klistra in HTML för tolkning komprimerar appen först innehållet lokalt och skickar sedan det skickade sidinnehållet, valfri sidtitel och webbadress, det aktuella appspråket och innehållet i tolkningsproblemet till den valda tolkningsendpunkten. Om du använder den officiella parsern går begäran till appens konfigurerade officiella backend. Om du aktiverar en anpassad OpenAI-kompatibel parser skickas samma innehåll direkt till den tredjeparts slutpunkt som du konfigurerade, och hämtningen av modelllistan begär också samma slutpunkt. En anpassad slutpunkt kan vidarebefordra förfrågan till andra AI-tjänster enligt leverantörens egen design. Den distribuerade officiella bakgrunden begränsar för närvarande varje skickad nyttolast till 300 KB, använder sin konfigurerade timeout och tillåter högst 5 analysförfrågningar per IP per dag.';

  @override
  String get privacyPolicyUpdatesTitle => 'Uppdateringar av policyn';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Den nuvarande versionen av sekretesspolicyn är $version. Om en senare version ändrar hur data hanteras kan appen be dig att läsa och godkänna den uppdaterade policyn igen.';
  }

  @override
  String get privacyGateTitle =>
      'Vänligen godkänn sekretesspolicyn innan du använder appen';

  @override
  String get privacyGateSummaryStorage =>
      'Tidstabeller, tidsuppsättningar och konfiguration av skolan lagras endast lokalt och laddas inte upp automatiskt till en utvecklarserver.';

  @override
  String get privacyGateSummaryImportExport =>
      'Import, export och delning sker endast när du uttryckligen startar dem. Webbsidoparsning skickar endast det komprimerade innehållet du skickar till din konfigurerade parseringsändpunkt, och du kan granska den parserade tidsplanen innan du sparar.';

  @override
  String get privacyGateSummaryUpdates =>
      'Om en senare version ändrar hur data hanteras kan appen be dig att granska den uppdaterade sekretesspolicyn igen.';

  @override
  String get schoolWebImportEntry => 'Importera från skolans webbsida';

  @override
  String get schoolWebImportEntryDesc =>
      'Importera den aktuella tidtabellsidan från skolans webbplats.';

  @override
  String get schoolSitesManageEntry => 'Hantera skolans webbplatser';

  @override
  String get schoolSitesManageEntryDesc =>
      'Lägg till, redigera och ta bort skolans inloggningsadresser med JSON-import och -export.';

  @override
  String get schoolSitesPageTitle => 'Förvaltning av skolan';

  @override
  String get schoolSitesImportJson => 'Importera skolans JSON';

  @override
  String get schoolSitesShareJson => 'Dela skolan JSON';

  @override
  String get schoolSitesSaveJson => 'Spara skolans JSON';

  @override
  String get schoolSitesSaved => 'Skolansidor sparade';

  @override
  String get schoolSitesImported => 'Importerade skolplatser';

  @override
  String get schoolSitesEmpty => 'Ingen skolkonfiguration ännu.';

  @override
  String get schoolSitesNameLabel => 'Skolans namn';

  @override
  String get schoolSitesLoginUrlLabel => 'Inloggningsadress';

  @override
  String get schoolSitesAdd => 'Lägg till skola';

  @override
  String get schoolSitesEdit => 'Redigera skolan';

  @override
  String get schoolSitesDeleteTitle => 'Ta bort skolan';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Ta bort \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Fyll i skolans namn och inloggningsadress först.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importera genom att klistra in tidstabellsidans innehåll';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Klistra in källkod eller rå sidinnehåll som innehåller tidtabellinformation manuellt.';

  @override
  String get schoolHtmlImportPageTitle => 'Analysera tidsplan från sidinnehåll';

  @override
  String get schoolHtmlImportUrlLabel => 'Källa URL (valfritt)';

  @override
  String get schoolHtmlImportTitleLabel => 'Sidtitel (valfri)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Sidans innehåll';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Klistra in källkod eller rå sidinnehåll som innehåller tidtabellinformation här.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Allt innehåll som innehåller tidtabellinformation kan analyseras och importeras, inte bara HTML.';

  @override
  String get schoolHtmlImportCompress => 'Komprimera innehåll';

  @override
  String get schoolHtmlImportCompressed => 'Komprimerat innehåll';

  @override
  String get schoolHtmlImportCompressFirst => 'Komprimera innehållet först.';

  @override
  String get schoolHtmlImportSubmit => 'Analysera och importera';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsing kan ta ett tag. Vänta lite.';

  @override
  String get schoolHtmlImportEmpty => 'Klistra in HTML-sidan först.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Tillbaka till webbsidan';

  @override
  String get schoolWebImportPageTitle => 'Import av skolans webbsida';

  @override
  String get schoolWebImportPreview => 'Importera förhandsgranskning';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count kurser';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count perioder';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Sidtitel';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Importera anteckningar';

  @override
  String get schoolWebImportOpenPageHint =>
      'Logga in på skolans webbplats i appen och navigera sedan till tidtabellsidan manuellt.';

  @override
  String get schoolWebImportConfigMissing =>
      'Web import backend API är ännu inte konfigurerat.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Denna plattform stöder inte inbäddad webbloggning ännu. Använd en plattform med WebView-stöd.';

  @override
  String get schoolWebImportSelectSchool => 'Välj skola';

  @override
  String get schoolWebImportNoSchools =>
      'Ingen skolkonfiguration är tillgänglig. Kontrollera school_sites.json först.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Misslyckades ladda skolkonfigurationen. Kontrollera filformatet JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importera aktuell sida';

  @override
  String get schoolWebImportGoBack => 'Föregående sida';

  @override
  String get schoolWebImportLoadingPage => 'Laddar sidan…';

  @override
  String get schoolWebImportParsing => 'Tolkar nuvarande sida...';

  @override
  String get schoolWebImportLoadFailed =>
      'Sidladdning misslyckades. Uppdatera eller försök igen senare.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Laddningen av sidan har tagit slut. Vänligen uppdatera och försök igen.';

  @override
  String get schoolWebImportEmptyPage =>
      'Aktuellt innehåll på sidan är tomt och kan inte importeras ännu.';

  @override
  String get schoolWebImportSuccess => 'Webbtidsplan importerad';

  @override
  String get schoolImportParserSettingsTitle => 'Tidsplan parser inställningar';

  @override
  String get schoolImportParserSettingsDesc =>
      'Välj den officiella parsern eller en anpassad OpenAI-kompatibel slutpunkt.';

  @override
  String get schoolImportParserSourceTitle => 'Parserkälla';

  @override
  String get schoolImportParserSourceOfficial => 'Officiell parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Använd den inbyggda officiella analyseringstjänsten som konfigurerats av appen.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Den officiella parsern använder appens konfigurerade parsing backend och håller det aktuella importflödet oförändrat.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Anpassad OpenAI-kompatibel';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Skicka sidinnehållet direkt till din egen OpenAI-kompatibla slutpunkt.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Anpassad OpenAI-kompatibel parser';

  @override
  String get schoolImportParserCustomPromptTitle => 'Anpassad prompt';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Redigera den inbyggda parser prompt här. Ändringar påverkar bara den anpassade OpenAI-kompatibla parsern.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Den inbyggda prompten laddas här som standard. Rensa den för att falla tillbaka till den inbyggda versionen.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Återställ standardprompt';

  @override
  String get schoolImportParserBaseUrl => 'Basadress';

  @override
  String get schoolImportParserApiKey => 'API-nyckel';

  @override
  String get schoolImportParserModel => 'Modell';

  @override
  String get schoolImportParserFetchModels => 'Hämta modelllista';

  @override
  String get schoolImportParserFetchingModels => 'Hämta modeller. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Inga modeller returnerades vid slutpunkten.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Hämtade $count modeller';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Den anpassade API-nyckeln lagras i appens lokala inställningar i klartext under den aktuella implementeringen. Använd den endast på en enhet eller webbläsarmiljö som du litar på.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Anpassad parser konfiguration är ofullständig. Fyll i grundadressen, API-nyckeln och modellen först.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Officiellt';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: Anpassad ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Visa hela sekretesspolicyn';

  @override
  String get privacyAgreeAndContinue => 'Håll med och fortsätt';

  @override
  String get privacyDecline => 'Avfärda';

  @override
  String get privacyDeclineWebHint =>
      'Denna webbläsarmiljö tillåter inte att appen stänger sidan åt dig. Om du inte håller med, stäng den här fliken eller fönstret själv.';

  @override
  String get defaultPeriodTimeSetName => 'Standardperioder';

  @override
  String get periodTimeSetFallbackName => 'Periodtider';

  @override
  String get untitledTimetableName => 'Tidsplan utan titel';

  @override
  String get newTimetableName => 'Ny tidtabell';

  @override
  String get newPeriodTimeSetName => 'Ny tidsinställning';

  @override
  String get emptyTimetableName => 'Tomma tidtabeller';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name perioder';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Importeringsfiltypen matchar inte.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Denna importfilversion stöds ännu inte.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Inga periodtider hittades i importfilen.';

  @override
  String get selectAtLeastOneTimetableMessage => 'Välj minst en tidsplan.';

  @override
  String get noExportableTimetableMessage =>
      'Det finns ingen tidsplan för export.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Att byta ut den aktuella tidtabellen stöder bara att välja en tidtabell.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Det finns ingen tidsplan att ersätta.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Denna tidsinställning används fortfarande av $count tidtabell(er). Omdela dem innan du raderar dem.';
  }

  @override
  String get weekdayMonday => 'måndag';

  @override
  String get weekdayTuesday => 'tisdag';

  @override
  String get weekdayWednesday => 'Onsdag';

  @override
  String get weekdayThursday => 'Torsdag';

  @override
  String get weekdayFriday => 'Fredag';

  @override
  String get weekdaySaturday => 'Lördag';

  @override
  String get weekdaySunday => 'söndag';

  @override
  String get weekdayShortMonday => 'måndag';

  @override
  String get weekdayShortTuesday => 'tisdag';

  @override
  String get weekdayShortWednesday => 'Onsdag';

  @override
  String get weekdayShortThursday => 'torsdag';

  @override
  String get weekdayShortFriday => 'Fr';

  @override
  String get weekdayShortSaturday => 'lördag';

  @override
  String get weekdayShortSunday => 'Solen';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'februari';

  @override
  String get monthMarch => 'mars';

  @override
  String get monthApril => 'apr';

  @override
  String get monthMay => 'maj';

  @override
  String get monthJune => 'juni';

  @override
  String get monthJuly => 'jul';

  @override
  String get monthAugust => 'aug';

  @override
  String get monthSeptember => 'sep';

  @override
  String get monthOctober => 'Okt';

  @override
  String get monthNovember => 'nov';

  @override
  String get monthDecember => 'maj';

  @override
  String get semesterWeeksWholeTerm => 'Hela terminen';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Veckor $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Veckor $value';
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
