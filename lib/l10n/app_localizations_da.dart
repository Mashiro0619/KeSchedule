// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Klassekammerat';

  @override
  String weekLabel(int week) {
    return 'Uge $week';
  }

  @override
  String get addCourse => 'Tilføj kursus';

  @override
  String get settings => 'Indstillinger';

  @override
  String get multiTimetableSwitch => 'Skift tidsplaner';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Nuværende tidsplan · $weeks uger';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Tryk for at skifte · $weeks uger';
  }

  @override
  String get editTimetable => 'Rediger tidsplan';

  @override
  String get createTimetable => 'Ny tidsplan';

  @override
  String get jumpToWeek => 'Hop til ugen';

  @override
  String get timetable => 'Tidsplan';

  @override
  String get timetableName => 'Navn på tidsplan';

  @override
  String get totalWeeks => 'Totalt uger';

  @override
  String get delete => 'Slet';

  @override
  String get cancel => 'Afbryd';

  @override
  String get save => 'Gem';

  @override
  String get deleteTimetableTitle => 'Slet tidsplan';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Slet \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Ingen tidsplan endnu';

  @override
  String get noTimetableMessage =>
      'Opret en tidsplan eller importer en fra en JSON-fil.';

  @override
  String get importTimetable => 'Import tidsplan';

  @override
  String get courseName => 'Kursets navn';

  @override
  String get location => 'Beliggenhed';

  @override
  String get dayOfWeek => 'Dag';

  @override
  String get semesterWeeks => 'uger';

  @override
  String get startTime => 'Starttid';

  @override
  String get endTime => 'Sluttid';

  @override
  String get linkedPeriods => 'Forbundne perioder';

  @override
  String get linkedPeriodsUnmatched =>
      'Ingen perioder matchede for den aktuelle tid. Tryk for at vælge manuelt.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Periode $start-$end';
  }

  @override
  String get teacherName => 'Lærer';

  @override
  String get credits => 'Kreditter';

  @override
  String get remarks => 'Bemærkninger';

  @override
  String get customFields => 'Brugerdefinerede felter';

  @override
  String get customFieldsHint => 'En pr. linje, format: nøgle:værdi';

  @override
  String get selectDayOfWeek => 'Vælg dag';

  @override
  String get selectSemesterWeeks => 'Vælg uger';

  @override
  String get selectAll => 'Vælg alle';

  @override
  String get clear => 'Ryd';

  @override
  String get confirm => 'Bekræft';

  @override
  String get selectLinkedPeriods => 'Vælg tilknyttede perioder';

  @override
  String get addCourseTitle => 'Tilføj kursus';

  @override
  String get editCourseTitle => 'Rediger kursus';

  @override
  String get editCourseTooltip => 'Rediger kursus';

  @override
  String get place => 'Beliggenhed';

  @override
  String get time => 'Tid';

  @override
  String get notFilled => 'Ikke udfyldt';

  @override
  String get none => 'Ingen';

  @override
  String get conflictCourses => 'Konflikterende kurser';

  @override
  String get locationNotFilled => 'Beliggenhed ikke udfyldt';

  @override
  String get setAsDisplayed => 'Sæt som vist';

  @override
  String get editThisCourse => 'Rediger dette kursus';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get noTimetableSettings =>
      'Der er i øjeblikket ingen tidsplan tilgængelig for indstillinger.';

  @override
  String get semesterStartDate => 'Startdato for semestret';

  @override
  String get periodTimeSets => 'Periodetid indstillet';

  @override
  String get noPeriodTimeAvailable => 'Ingen tilgængelig periode tid angivet';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count perioder';
  }

  @override
  String get coursePopupDismissSetting =>
      'Tillad udenfor tryk for at lukke kursus popup';

  @override
  String get coursePopupDismissSettingHint =>
      'Hvis du slår dette fra, deaktiveres også skyde ned afskedigelse.';

  @override
  String get preserveTimetableGaps => 'Bevar tidsplanens huller';

  @override
  String get preserveTimetableGapsHint =>
      'Når du er ude, kollapser frokost og pause huller, så senere klasser bevæger sig opad.';

  @override
  String get showPastEndedCourses => 'Vis tidligere afsluttede kurser';

  @override
  String get showPastEndedCoursesHint =>
      'Vis kurser, der allerede er afsluttet ved den virkelige nuværende uge med en lysegrå stil.';

  @override
  String get showFutureCourses => 'Vis fremtidige kurser';

  @override
  String get showFutureCoursesHint =>
      'Vis kurser, der ikke er aktive i denne uge, men vises i senere uger med en grå stil.';

  @override
  String get timetableDisplaySettings => 'Tidsplan visning og interaktion';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup afskedigelse, huller, grå baner og gitterlinjer';

  @override
  String get showTimetableGridLines => 'Vis tidsplan gitterlinjer';

  @override
  String get showTimetableGridLinesHint =>
      'Kontroller, om vandrette og lodrette gitterlinjer er synlige i tidsplanen.';

  @override
  String get liveCourseOutlineColor => 'Farve på kursus';

  @override
  String get liveCourseOutlineColorHint =>
      'Vælg, om konturerne er rettet mod det aktuelle/næste kursus eller alle de kurser, der vises på den aktuelle side.';

  @override
  String get liveCourseOutlineSettings => 'Kursus oversigt';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Konfigurer, om konturen er aktiveret, hvad den målretter sig mod, om den følger temafarven og den effektive konturfarve.';

  @override
  String get liveCourseOutlineEnabled => 'Aktiver kontur';

  @override
  String get liveCourseOutlineFollowTheme => 'Følg temafarve';

  @override
  String get liveCourseOutlineTarget => 'Skitseret mål';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Aktuelt/næste kursus';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Alle vist kurser';

  @override
  String get liveCourseOutlineEffectiveColor => 'Effektiv farve';

  @override
  String get liveCourseOutlineCustomColor => 'Brugerdefineret konturfarve';

  @override
  String get liveCourseOutlineWidth => 'Omkringsbredde';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Sprog';

  @override
  String get languagePageDescription =>
      'Vælg et af de sprog, der virkelig er tilgængelige i appen.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'engelsk';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API-svar';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Følg systemet';

  @override
  String get themeLight => 'Lys';

  @override
  String get themeDark => 'Mørk';

  @override
  String get themeColor => 'Temafarve';

  @override
  String get themeColorModeSingle => 'Enkelt temafarve';

  @override
  String get themeColorModeColorful => 'Farverige';

  @override
  String get themeColorUiColors => 'UI farver';

  @override
  String get themeColorCourseColors => 'Kursfarver';

  @override
  String get themeColorPrimary => 'Primært';

  @override
  String get themeColorSecondary => 'Sekundær';

  @override
  String get themeColorTertiary => 'Tertiær';

  @override
  String get themeColorCourseText => 'Kursustekst';

  @override
  String get themeColorCourseTextAuto => 'automatisk';

  @override
  String get themeColorCourseTextCustom => 'Brugerdefineret farve';

  @override
  String get themeColorCourseColorsEmpty =>
      'Kursets farver vil blive genereret efter import af en tidsplan.';

  @override
  String get themeCustomColor => 'Brugerdefineret farve';

  @override
  String get themeApplyCustomColor => 'Anvend farve';

  @override
  String get themeApplySettings => 'Anvend indstillinger';

  @override
  String get dataImportExport => 'Import og eksport af data';

  @override
  String get dataImportExportDesc =>
      'Importer fulde data eller enkelte tidsplaner, eller eksporter aktuelle/alle tidsplaner.';

  @override
  String get openSourceLicenses => 'Open source-licenser';

  @override
  String get openSourceLicensesDesc =>
      'Se licenser for Flutter-afhængigheder og bundtede app-ikonaktiver.';

  @override
  String get checkForUpdates => 'Tjek efter opdateringer';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Allerede på den seneste version ($version)';
  }

  @override
  String get currentVersionLabel => 'Aktuel version';

  @override
  String get newVersionAvailable => 'Opdatering tilgængelig';

  @override
  String get latestVersionLabel => 'Seneste version';

  @override
  String get updateContentLabel => 'Opdater detaljer';

  @override
  String get officialWebsite => 'Officiel hjemmeside';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Cloud-drev';

  @override
  String get ignoreThisVersion => 'Ignorer denne version';

  @override
  String get openUpdatesFailed => 'Kunne ikke åbne opdateringslinket';

  @override
  String get updateCheckFailedTitle => 'Opdateringskontrol mislykkedes';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'GitHub-lager';

  @override
  String get openGithubFailed => 'Kan ikke åbne linket til GitHub-repositoriet';

  @override
  String get selectPeriodTimeSet => 'Vælg periode tidsindstilling';

  @override
  String get newItem => 'Nyt';

  @override
  String get editPeriodTimeSet => 'Rediger tidsindstilling for perioden';

  @override
  String get importTimetableFiles => 'Import tidsplan';

  @override
  String get importTimetableFilesDesc =>
      'Understøtter en eller flere tidsplan filer.';

  @override
  String get importTimetableText => 'Importer tidsplan fra tekst';

  @override
  String get importTimetableTextDesc =>
      'Indsæt tidsplan JSON indhold og importere det.';

  @override
  String get shareTimetableFiles => 'Del tidsplan filer';

  @override
  String get shareTimetableFilesDesc => 'Vælg en eller flere tidsplaner først.';

  @override
  String get saveTimetableFiles => 'Gem tidsplan filer';

  @override
  String get saveTimetableFilesDesc => 'Vælg en eller flere tidsplaner først.';

  @override
  String get exportTimetableText => 'Eksporter tidsplan som tekst';

  @override
  String get exportTimetableTextDesc =>
      'Vælg en eller flere tidsplaner, og kopier derefter JSON-indholdet.';

  @override
  String get jsonContent => 'JSON indhold';

  @override
  String get pasteJsonContentHint => 'Indsæt JSON-indholdet for at importere.';

  @override
  String get jsonContentEmpty => 'Indsæt JSON indhold først.';

  @override
  String get copyText => 'Kopier';

  @override
  String get copiedToClipboard => 'Kopieret til udklipstavle';

  @override
  String get share => 'Del';

  @override
  String get selectTimetablesToExport => 'Vælg tidsplaner til eksport';

  @override
  String get selectTimetablesToImport => 'Vælg tidsplaner at importere';

  @override
  String timetableCourseCount(int count) {
    return '$count kurser';
  }

  @override
  String get importAction => 'Import';

  @override
  String get importTimetableDialogTitle => 'Import tidsplan';

  @override
  String get chooseImportMethod => 'Vælg hvordan du importerer.';

  @override
  String get importAsNewTimetable => 'Importer som ny tidsplan';

  @override
  String get replaceCurrentTimetable => 'Erstat nuværende tidsplan';

  @override
  String get importPeriodTimeSetDialogTitle => 'Import periode tidssæt';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Denne fil indeholder bundtede periodetidssæt. Vil du importere og tilknytte dem?';

  @override
  String get importBundledPeriodTimeSets => 'Import og tilknytning';

  @override
  String get discardBundledPeriodTimeSets => 'Kast bundtede sæt';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Der er ingen eksisterende periodetidssæt tilgængelige, så bundtede periodetidssæt kan ikke kasseres.';

  @override
  String savedToPath(Object path) {
    return 'Gemt til $path';
  }

  @override
  String get saveCancelled => 'Gem annulleret';

  @override
  String get fileSaveRestrictedTitle => 'Fillagring begrænset';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Systemet kunne ikke gemme filen. Du kan prøve igen eller bruge deling i stedet.';

  @override
  String get retrySave => 'Prøv at gemme igen';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Aktiver filadgang i systemindstillingerne, vend derefter tilbage og prøv at eksportere igen.';

  @override
  String get openSettings => 'Åbn indstillinger';

  @override
  String get browserDownloadRestrictedTitle => 'Browser download begrænset';

  @override
  String get browserDownloadRestrictedMessage =>
      'Denne browser understøtter ikke direkte gemning til en lokal fil. Kontroller browserens downloadtilladelser eller brug fildeling i stedet.';

  @override
  String get switchToShare => 'Brug deling i stedet';

  @override
  String get fileSaveFailedTitle => 'Fillagring mislykkedes';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Kunne ikke skrive til den aktuelle sti. Målmappen kan være beskyttet, filen kan være i brug, eller stien kan ikke skrives.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Systemet kunne ikke gemme filen. Du kan prøve igen, kontrollere systemindstillingerne eller bruge fildeling i stedet.';

  @override
  String get retryLater => 'Prøv igen senere';

  @override
  String get exportSwitchedToShare => 'Skiftet til fildeling til eksport';

  @override
  String get saveFailedRetry => 'Gemning mislykkedes. Prøv igen senere.';

  @override
  String get importFailedCheckContent =>
      'Import mislykkedes. Kontroller venligst filens indhold.';

  @override
  String get noImportableTimetables =>
      'Der blev ikke fundet nogen brugbare tidsplaner i den importerede fil.';

  @override
  String importedTimetablesCount(int count) {
    return 'Importerede $count tidsplaner';
  }

  @override
  String get periodTimesTitle => 'Periodetider';

  @override
  String get importExport => 'Import og eksport';

  @override
  String get importPeriodTemplate => 'Skabelon til importperiode';

  @override
  String get importPeriodTemplateText => 'Importer periodeskabelon fra tekst';

  @override
  String get sharePeriodTemplate => 'Skabelon til andelsperiode';

  @override
  String get saveTemplateToFile => 'Gem skabelon til fil';

  @override
  String get exportPeriodTemplateText => 'Eksporter periode skabelon som tekst';

  @override
  String get deletePeriodTimeSet => 'Slet tidsindstillingen for perioden';

  @override
  String get periodTimeSetName => 'Periodens tidssæt navn';

  @override
  String get addOnePeriod => 'Tilføj periode';

  @override
  String periodNumberLabel(int index) {
    return 'Periode $index';
  }

  @override
  String get deleteThisPeriod => 'Slet denne periode';

  @override
  String durationMinutes(int minutes) {
    return 'Varighed $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Gap fra tidligere $minutes min';
  }

  @override
  String get endTimeMustBeLater => 'Sluttid skal være senere end starttid';

  @override
  String get periodOverlapPrevious => 'Denne periode overlapper den foregående';

  @override
  String get periodTimesSaved => 'Periodetider gemt';

  @override
  String get deletePeriodTimeSetTitle => 'Slet tidsindstillingen for perioden';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Slet \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'tidsindstilling for den aktuelle periode';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Importeret $count periodetid';
  }

  @override
  String get periodFilePermissionTitle => 'Filtilladelse nødvendig';

  @override
  String get androidFilePermissionMessage =>
      'Android eksport kræver tilladelse til filadgang. Giv tilladelse til at fortsætte med at gemme.';

  @override
  String get reauthorize => 'Godkend igen';

  @override
  String get permissionPermanentlyDeniedTitle => 'Tilladelse nægtet permanent';

  @override
  String get permissionSettingsExportMessage =>
      'Aktiver filadgang i systemindstillingerne, vend derefter tilbage og prøv at eksportere igen.';

  @override
  String get privacyPolicyTitle => 'Privatlivspolitik';

  @override
  String get privacyPolicyEntryDesc =>
      'Lær, hvordan appen håndterer lokal lagring, konfiguration af skolens websted, import/eksport af filer, analysering af websider og eksterne links.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Accepteret version: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked er et lokalt-først skemaværktøj. Skemaer, tidssæt og skolewebstedskonfiguration gemmes kun på din enhed eller i din browser og uploades aldrig automatisk. Appen behandler kun data, når du udtrykkeligt starter handlinger som import, websideanalyse, deling eller åbning af eksterne links. Den fulde fortrolighedspolitik er tilgængelig online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lokal opbevaring';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Tidsplan data og relaterede indstillinger gemmes i en lokal fil ved navn Sked_data.json inde i app dokumenter mappe. Redigerbar skole-site konfiguration gemmes separat i Sked_school_sites.json. Tilpassede tidsplan parser indstillinger, herunder eventuelle tilpassede Base URL, API-nøgle og valgte model, gemmes også lokalt i de samme app data og er ikke beskyttet af en systemlogin vault. Når de bruges i en browser, gemmes de samme typer data i browserlagringen. Appen uploader ikke automatisk disse lokale data til en udviklerkontrolleret server.';

  @override
  String get privacyPolicyImportExportTitle => 'Import og eksport';

  @override
  String get privacyPolicyImportExportBody =>
      'Appen læser eller skriver kun tidsplan JSON-filer, skole-site JSON-filer og periode-skabelon-filer, når du udtrykkeligt vælger en fil eller starter en eksporthandling. Importering af disse filer er en lokal operation, medmindre du også vælger websideanalyse. Hent en brugerdefineret modelliste er også en eksplicit netværkshandling og kontakter kun det brugerdefinerede slutpunkt, du har konfigureret.';

  @override
  String get privacyPolicySharingTitle => 'Deling';

  @override
  String get privacyPolicySharingBody =>
      'Når du udtrykkeligt bruger deling, sender appen den eksporterede fil til systemdelingsarket eller til den målapp, du vælger. Hvordan filen håndteres bagefter afhænger af den målapp eller -tjeneste, du har valgt.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Eksterne links';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Når du åbner eksterne links som f.eks. GitHub-repositoriet, overfører appen handlingen til din browser eller et andet eksternt program. Databehandling efter dette punkt reguleres af den tredjepart, du åbner.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Hvad appen ikke indsamler';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Appen kræver ikke en Sked-konto og aktiverer ikke analyse, reklame-identifikatorer eller sikkerhedskopiering i skyen. Det giver heller ikke et dedikeret felt til indsamling af skolekonto adgangskoder. Hvis du logger på en skole hjemmeside i appen, sker denne interaktion på den skole side, du åbnede.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Analysering af websider';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Når du bruger import eller indsætning af HTML til analysering af skolens webside, komprimerer appen først indholdet lokalt og sender derefter det indsendte sideindhold, valgfri sidetitel og URL, det aktuelle appsprog og indholdet i analyseringsprompten til det valgte analyseringsendepunkt. Hvis du bruger den officielle parser, går anmodningen til appens konfigurerede officielle backend. Hvis du aktiverer en brugerdefineret OpenAI-kompatibel parser, sendes det samme indhold direkte til det tredjeparts slutpunkt, du har konfigureret, og hentelse af modellisten anmoder også om det samme slutpunkt. Et brugerdefineret endepunkt kan videresende anmodningen til andre AI-tjenester i henhold til udbyderens eget design. Den implementerede officielle backend begrænser i øjeblikket hver indsendt nyttelast til 300KB, bruger sin konfigurerede timeout og tillader højst 5 analyseforespørgsler pr. IP om dagen.';

  @override
  String get privacyPolicyUpdatesTitle => 'Opdateringer af politikken';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Den nuværende version af fortrolighedspolitikken er $version. Hvis en senere version ændrer, hvordan data håndteres, kan appen bede dig om at læse og acceptere den opdaterede politik igen.';
  }

  @override
  String get privacyGateTitle =>
      'Godkend venligst fortrolighedspolitikken før du bruger appen';

  @override
  String get privacyGateSummaryStorage =>
      'Tidsplaner, tidssæt og konfiguration af skolens websted gemmes kun lokalt og uploades ikke automatisk til en udviklerserver.';

  @override
  String get privacyGateSummaryImportExport =>
      'Import, eksport og deling sker kun, når du udtrykkeligt starter dem. Websideanalysering sender kun det komprimerede indhold, du sender til dit konfigurerede analyseringsendepunkt, og du kan gennemgå den analyserede tidsplan, før du gemmer den.';

  @override
  String get privacyGateSummaryUpdates =>
      'Hvis en senere version ændrer, hvordan data håndteres, kan appen bede dig om at gennemgå den opdaterede fortrolighedspolitik igen.';

  @override
  String get schoolWebImportEntry => 'Import fra skolens hjemmeside';

  @override
  String get schoolWebImportEntryDesc =>
      'Importer den aktuelle tidsplan side fra skolens websted.';

  @override
  String get schoolSitesManageEntry => 'Administrer skolens websteder';

  @override
  String get schoolSitesManageEntryDesc =>
      'Tilføj, rediger og slet skolens login-URL\'er med JSON-import og -eksport.';

  @override
  String get schoolSitesPageTitle => 'Skolen site management';

  @override
  String get schoolSitesImportJson => 'Importer skole JSON';

  @override
  String get schoolSitesShareJson => 'Del skolen JSON';

  @override
  String get schoolSitesSaveJson => 'Gem skolens JSON';

  @override
  String get schoolSitesSaved => 'Skolens hjemmesider gemt';

  @override
  String get schoolSitesImported => 'Skolepladser importeret';

  @override
  String get schoolSitesEmpty => 'Ingen skole websted konfiguration endnu.';

  @override
  String get schoolSitesNameLabel => 'Skolens navn';

  @override
  String get schoolSitesLoginUrlLabel => 'Indloggingsadresse';

  @override
  String get schoolSitesAdd => 'Tilføj skole';

  @override
  String get schoolSitesEdit => 'Rediger skole';

  @override
  String get schoolSitesDeleteTitle => 'Slet skole';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Slet \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Udfyld skolens navn og login URL først.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importer ved at indsætte tidsplan side indhold';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Indsæt kildekode eller rå sideindhold, der indeholder tidsplaneoplysninger manuelt.';

  @override
  String get schoolHtmlImportPageTitle => 'Analyser tidsplan fra sideindhold';

  @override
  String get schoolHtmlImportUrlLabel => 'Kilde URL (valgfrit)';

  @override
  String get schoolHtmlImportTitleLabel => 'Sidetitel (valgfrit)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Sideindhold';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Indsæt kildekode eller rå sideindhold, der indeholder tidsplan oplysninger her.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Alt indhold, der indeholder tidsplaneoplysninger, kan analyseres og importeres, ikke kun HTML.';

  @override
  String get schoolHtmlImportCompress => 'Komprimer indhold';

  @override
  String get schoolHtmlImportCompressed => 'Indhold komprimeret';

  @override
  String get schoolHtmlImportCompressFirst => 'Komprimer indholdet først.';

  @override
  String get schoolHtmlImportSubmit => 'Analyser og importer';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsing kan tage et stykke tid. Vent venligst.';

  @override
  String get schoolHtmlImportEmpty => 'Indsæt HTML-siden først.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Tilbage til hjemmesiden';

  @override
  String get schoolWebImportPageTitle => 'Import af skolens webside';

  @override
  String get schoolWebImportPreview => 'Importer forhåndsvisning';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count kurser';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count perioder';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Sidetitel';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Importér noter';

  @override
  String get schoolWebImportOpenPageHint =>
      'Log på skolens websted i appen, og naviger derefter manuelt til tidsplanen.';

  @override
  String get schoolWebImportConfigMissing =>
      'Web import backend API er endnu ikke konfigureret.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Denne platform understøtter endnu ikke indlejret weblogin. Brug en platform med WebView-støtte.';

  @override
  String get schoolWebImportSelectSchool => 'Vælg skole';

  @override
  String get schoolWebImportNoSchools =>
      'Der er ingen skolekonfiguration tilgængelig. Tjek school_sites.json først.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Kunne ikke indlæse skolekonfiguration. Tjek JSON-filformatet.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importer nuværende side';

  @override
  String get schoolWebImportGoBack => 'Forrige side';

  @override
  String get schoolWebImportLoadingPage => 'Indlæser side…';

  @override
  String get schoolWebImportParsing => 'Parser den aktuelle side...';

  @override
  String get schoolWebImportLoadFailed =>
      'Indlæsning af siden mislykkedes. Opdater eller prøv igen senere.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Sideindlæsning er tidsudløbet. Opdater og prøv igen.';

  @override
  String get schoolWebImportEmptyPage =>
      'Det aktuelle indhold er tomt og kan endnu ikke importeres.';

  @override
  String get schoolWebImportSuccess => 'Web tidsplan importeret';

  @override
  String get schoolImportParserSettingsTitle => 'Tidsplan parser indstillinger';

  @override
  String get schoolImportParserSettingsDesc =>
      'Vælg den officielle parser eller et brugerdefineret OpenAI-kompatibelt slutpunkt.';

  @override
  String get schoolImportParserSourceTitle => 'Parser kilde';

  @override
  String get schoolImportParserSourceOfficial => 'Officiel parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Brug den indbyggede officielle analysetjeneste, der er konfigureret af appen.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Den officielle parser bruger appens konfigurerede parsing backend og holder den aktuelle importstrøm uændret.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Tilpasset OpenAI-kompatibel';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Send sideindholdet direkte til dit eget OpenAI-kompatible endepunkt.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Tilpasset OpenAI-kompatibel parser';

  @override
  String get schoolImportParserCustomPromptTitle => 'Brugerdefineret prompt';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Rediger den indbyggede parser prompt her. Ændringer påvirker kun den brugerdefinerede OpenAI-kompatible parser.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Den indbyggede prompt indlæses her som standard. Tøm den for at falde tilbage til den indbyggede version.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Nulstil standardprompt';

  @override
  String get schoolImportParserBaseUrl => 'Baseadresse';

  @override
  String get schoolImportParserApiKey => 'API-nøgle';

  @override
  String get schoolImportParserModel => 'Modell';

  @override
  String get schoolImportParserFetchModels => 'Hent modelliste';

  @override
  String get schoolImportParserFetchingModels => 'Henter modeller. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Ingen modeller blev returneret ved slutpunktet.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Hentet $count modeller';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Den brugerdefinerede API-nøgle gemmes i appens lokale indstillinger i plaintext under den aktuelle implementering. Brug det kun på en enhed eller et browsermiljø, du stoler på.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Tilpasset parser konfiguration er ufuldstændig. Udfyld grundlæggende URL, API-nøgle og model først.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Officiel';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: Brugerdefineret ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Se fuld fortrolighedspolitik';

  @override
  String get privacyAgreeAndContinue => 'Enig og fortsæt';

  @override
  String get privacyDecline => 'Afsæt';

  @override
  String get privacyDeclineWebHint =>
      'Dette browsermiljø tillader ikke, at appen lukker siden for dig. Hvis du ikke er enig, luk venligst denne fane eller vinduet selv.';

  @override
  String get defaultPeriodTimeSetName => 'Standardperioder';

  @override
  String get periodTimeSetFallbackName => 'Periodetider';

  @override
  String get untitledTimetableName => 'Tidsplan uden titel';

  @override
  String get newTimetableName => 'Ny tidsplan';

  @override
  String get newPeriodTimeSetName => 'Ny periode tidsindstilling';

  @override
  String get emptyTimetableName => 'Tomme tidsplaner';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name perioder';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Import filtype stemmer ikke overens.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Denne importfilversion understøttes endnu ikke.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Ingen periodetider fundet i importfilen.';

  @override
  String get selectAtLeastOneTimetableMessage => 'Vælg mindst én tidsplan.';

  @override
  String get noExportableTimetableMessage =>
      'Der er ingen tidsplan til eksport.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Erstatning af den aktuelle tidsplan understøtter kun at vælge en tidsplan.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Der er ingen tidsplan til udskiftning.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Dette tidssæt anvendes stadig af $count tidsplan(er). Tildele dem igen, før de slettes.';
  }

  @override
  String get weekdayMonday => 'Mandag';

  @override
  String get weekdayTuesday => 'Tirsdag';

  @override
  String get weekdayWednesday => 'Onsdag';

  @override
  String get weekdayThursday => 'Torsdag';

  @override
  String get weekdayFriday => 'Fredag';

  @override
  String get weekdaySaturday => 'Lørdag';

  @override
  String get weekdaySunday => 'Søndag';

  @override
  String get weekdayShortMonday => 'mandag';

  @override
  String get weekdayShortTuesday => 'tirsdag';

  @override
  String get weekdayShortWednesday => 'Onsdag';

  @override
  String get weekdayShortThursday => 'torsdag';

  @override
  String get weekdayShortFriday => 'fredag';

  @override
  String get weekdayShortSaturday => 'Lørdag';

  @override
  String get weekdayShortSunday => 'Solen';

  @override
  String get monthJanuary => 'januar';

  @override
  String get monthFebruary => 'februar';

  @override
  String get monthMarch => 'marts';

  @override
  String get monthApril => 'Apr';

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
  String get semesterWeeksWholeTerm => 'Hele semestret';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Uger $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Uger $value';
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
