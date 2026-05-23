// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Spoluučedník';

  @override
  String weekLabel(int week) {
    return 'Týden $week';
  }

  @override
  String get addCourse => 'Přidat kurz';

  @override
  String get settings => 'Nastavení';

  @override
  String get multiTimetableSwitch => 'Přepnout rozvrhy';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Aktuální jízdní řád · $weeks týdny';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Klepnutím přepněte · $weeks týdny';
  }

  @override
  String get editTimetable => 'Upravit rozvrh';

  @override
  String get createTimetable => 'Nový rozvrh';

  @override
  String get jumpToWeek => 'Skočit na týden';

  @override
  String get timetable => 'Rozvrh';

  @override
  String get timetableName => 'Název jízdního řádu';

  @override
  String get totalWeeks => 'Celkem týdny';

  @override
  String get delete => 'Odstranit';

  @override
  String get cancel => 'Zrušit';

  @override
  String get save => 'Uložit';

  @override
  String get deleteTimetableTitle => 'Smazat rozvrh';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Smazat \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Zatím žádný časový rozvrh';

  @override
  String get noTimetableMessage =>
      'Vytvořte plán nebo importujte z souboru JSON.';

  @override
  String get importTimetable => 'Importovat rozvrh';

  @override
  String get courseName => 'Název kurzu';

  @override
  String get location => 'Umístění';

  @override
  String get dayOfWeek => 'Den';

  @override
  String get semesterWeeks => 'Týdny';

  @override
  String get startTime => 'Čas zahájení';

  @override
  String get endTime => 'Konečný čas';

  @override
  String get linkedPeriods => 'Související období';

  @override
  String get linkedPeriodsUnmatched =>
      'Žádné období není odpovídající aktuálnímu času. Klepnutím vyberte ručně.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Období $start-$end';
  }

  @override
  String get teacherName => 'Učitel';

  @override
  String get credits => 'Kredity';

  @override
  String get remarks => 'Poznámky';

  @override
  String get customFields => 'Vlastní pole';

  @override
  String get customFieldsHint => 'Jeden na řádek, formát: klíč:hodnota';

  @override
  String get selectDayOfWeek => 'Vyberte si den';

  @override
  String get selectSemesterWeeks => 'Vyberte si týdny';

  @override
  String get selectAll => 'Vyberte všechny';

  @override
  String get clear => 'Vymazat';

  @override
  String get confirm => 'Potvrdit';

  @override
  String get selectLinkedPeriods => 'Vyberte propojená období';

  @override
  String get addCourseTitle => 'Přidat kurz';

  @override
  String get editCourseTitle => 'Upravit kurz';

  @override
  String get editCourseTooltip => 'Upravit kurz';

  @override
  String get place => 'Umístění';

  @override
  String get time => 'Čas';

  @override
  String get notFilled => 'Neplněno';

  @override
  String get none => 'Žádný';

  @override
  String get conflictCourses => 'Konfliktní kurzy';

  @override
  String get locationNotFilled => 'Umístění není vyplněno';

  @override
  String get setAsDisplayed => 'Nastavit jako zobrazené';

  @override
  String get editThisCourse => 'Upravit tento kurz';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get noTimetableSettings =>
      'V současné době není k dispozici žádný časový rozvrh pro nastavení.';

  @override
  String get semesterStartDate => 'Datum zahájení semestru';

  @override
  String get periodTimeSets => 'Nastavení časového období';

  @override
  String get noPeriodTimeAvailable => 'Není nastaven žádný čas';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count období';
  }

  @override
  String get coursePopupDismissSetting =>
      'Povolit vnější klepnutí pro zavření vyskakovacího okna kurzu';

  @override
  String get coursePopupDismissSettingHint =>
      'Vypnutí této funkce také zakáže propuštění posunutím dolů.';

  @override
  String get preserveTimetableGaps => 'Zachování mezer v rozvrhu';

  @override
  String get preserveTimetableGapsHint =>
      'Když je volno, oběd a přestávka mezery se zhroutí, takže pozdější třídy pohybovat nahoru.';

  @override
  String get showPastEndedCourses => 'Zobrazit minulé kurzy';

  @override
  String get showPastEndedCoursesHint =>
      'Zobrazte kurzy, které již skončily skutečným aktuálním týdnem ve světlejším šedem stylu.';

  @override
  String get showFutureCourses => 'Zobrazit budoucí kurzy';

  @override
  String get showFutureCoursesHint =>
      'Zobrazit kurzy, které nejsou aktivní tento týden, ale budou se objevovat v následujících týdnech s šedým stylem.';

  @override
  String get timetableDisplaySettings => 'Zobrazení a interakce rozvrhu';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup propuštění, mezery, šedé kurzy a mřížkové čáry';

  @override
  String get showTimetableGridLines => 'Zobrazit řádky mřížky rozvrhu';

  @override
  String get showTimetableGridLinesHint =>
      'Ovládejte, zda jsou v rozvrhu viditelné vodorovné a svislé čáry mřížky.';

  @override
  String get liveCourseOutlineColor => 'Barva obrysu kurzu';

  @override
  String get liveCourseOutlineColorHint =>
      'Zvolte, zda se obrysy zaměřují na aktuální/další kurz nebo na všechny kurzy zobrazené na aktuální stránce.';

  @override
  String get liveCourseOutlineSettings => 'Náčrt kurzu';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Nastavte, zda je obris povolen, na co se zaměřuje, zda sleduje barvu tématu a efektivní barvu obrisu.';

  @override
  String get liveCourseOutlineEnabled => 'Povolit obrys';

  @override
  String get liveCourseOutlineFollowTheme => 'Sledujte barvu tématu';

  @override
  String get liveCourseOutlineTarget => 'Návrh cíle';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Aktuální/příští kurz';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Všechny zobrazené kurzy';

  @override
  String get liveCourseOutlineEffectiveColor => 'Efektivní barva';

  @override
  String get liveCourseOutlineCustomColor => 'Vlastní barva obrysu';

  @override
  String get liveCourseOutlineWidth => 'Šířka obrysu';

  @override
  String get outlineWidthUnit => 'Px';

  @override
  String get language => 'Jazyk';

  @override
  String get languagePageDescription =>
      'Vyberte si jeden z jazyků, který je opravdu k dispozici v aplikaci.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'angličtina';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Odpověď API';

  @override
  String get theme => 'Téma';

  @override
  String get themeFollowSystem => 'Sledujte systém';

  @override
  String get themeLight => 'Světlo';

  @override
  String get themeDark => 'Temná';

  @override
  String get themeColor => 'Barva tématu';

  @override
  String get themeColorModeSingle => 'Barva jednoho tématu';

  @override
  String get themeColorModeColorful => 'Barevné';

  @override
  String get themeColorUiColors => 'Barvy uživatelského rozhraní';

  @override
  String get themeColorCourseColors => 'Barvy kurzu';

  @override
  String get themeColorPrimary => 'Primární';

  @override
  String get themeColorSecondary => 'Sekundární';

  @override
  String get themeColorTertiary => 'Terciární';

  @override
  String get themeColorCourseText => 'Text kurzu';

  @override
  String get themeColorCourseTextAuto => 'automatické';

  @override
  String get themeColorCourseTextCustom => 'Vlastní barva';

  @override
  String get themeColorCourseColorsEmpty =>
      'Barvy kurzu budou generovány po importu rozvrhu.';

  @override
  String get themeCustomColor => 'Vlastní barva';

  @override
  String get themeApplyCustomColor => 'Použít barvu';

  @override
  String get themeApplySettings => 'Použít nastavení';

  @override
  String get dataImportExport => 'Import a export dat';

  @override
  String get dataImportExportDesc =>
      'Importovat úplná data nebo jednotlivé rozvrhy nebo exportovat aktuální/všechny rozvrhy.';

  @override
  String get openSourceLicenses => 'Licence s otevřeným zdrojovým kódem';

  @override
  String get openSourceLicensesDesc =>
      'Zobrazení licencí pro závislosti Flutter a aktiva ikon aplikací.';

  @override
  String get checkForUpdates => 'Zkontrolujte aktualizace';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Oficiální stránky / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Již v nejnovější verzi ($version)';
  }

  @override
  String get currentVersionLabel => 'Aktuální verze';

  @override
  String get newVersionAvailable => 'Aktualizace k dispozici';

  @override
  String get latestVersionLabel => 'Nejnovější verze';

  @override
  String get updateContentLabel => 'Aktualizace podrobností';

  @override
  String get officialWebsite => 'Oficiální webové stránky';

  @override
  String get googlePlay => 'služby Google Play';

  @override
  String get cloudDrive => 'Cloud disk';

  @override
  String get ignoreThisVersion => 'Ignorovat tuto verzi';

  @override
  String get openUpdatesFailed => 'Nelze otevřít odkaz na aktualizaci';

  @override
  String get updateCheckFailedTitle => 'Kontrola aktualizace selhala';

  @override
  String get updateCheckFailedMessage =>
      'Nelze získat platné informace o aktualizaci z jakéhokoli zdroje aktualizace. Přesto můžete použít níže uvedené odkazy k manuální aktualizaci.';

  @override
  String get githubRepository => 'Úložiště GitHub';

  @override
  String get openGithubFailed => 'Nelze otevřít odkaz na úložiště GitHub';

  @override
  String get selectPeriodTimeSet => 'Vyberte nastavení časového období';

  @override
  String get newItem => 'Nový';

  @override
  String get editPeriodTimeSet => 'Upravit časový nastavení období';

  @override
  String get importTimetableFiles => 'Importovat rozvrh';

  @override
  String get importTimetableFilesDesc =>
      'Podporuje jeden nebo více souborů rozvrhu.';

  @override
  String get importTimetableText => 'Importovat časový rozvrh z textu';

  @override
  String get importTimetableTextDesc =>
      'Vložte obsah časového rozvrhu JSON a importujte ho.';

  @override
  String get shareTimetableFiles => 'Sdílet soubory rozvrhu';

  @override
  String get shareTimetableFilesDesc =>
      'Nejprve vyberte jeden nebo více plánů.';

  @override
  String get saveTimetableFiles => 'Uložit soubory rozvrhu';

  @override
  String get saveTimetableFilesDesc => 'Nejprve vyberte jeden nebo více plánů.';

  @override
  String get exportTimetableText => 'Exportovat plán jako text';

  @override
  String get exportTimetableTextDesc =>
      'Vyberte jeden nebo více harmonogramů a zkopírujte obsah JSON.';

  @override
  String get jsonContent => 'Obsah JSON';

  @override
  String get pasteJsonContentHint => 'Vložte obsah JSON k importu.';

  @override
  String get jsonContentEmpty => 'Nejprve vložte obsah JSON.';

  @override
  String get copyText => 'Kopírovat';

  @override
  String get copiedToClipboard => 'Kopírovat do schránky';

  @override
  String get share => 'Sdílet';

  @override
  String get selectTimetablesToExport => 'Vyberte plány pro export';

  @override
  String get selectTimetablesToImport => 'Vyberte plány pro import';

  @override
  String timetableCourseCount(int count) {
    return '$count kurzy';
  }

  @override
  String get importAction => 'Importovat';

  @override
  String get importTimetableDialogTitle => 'Importovat rozvrh';

  @override
  String get chooseImportMethod => 'Vyberte si, jak importovat.';

  @override
  String get importAsNewTimetable => 'Importovat jako nový rozvrh';

  @override
  String get replaceCurrentTimetable => 'Nahradit aktuální rozvrh';

  @override
  String get importPeriodTimeSetDialogTitle => 'Importovat časové sady období';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Tento soubor obsahuje shromážděné časové sady období. Chcete je importovat a propojit?';

  @override
  String get importBundledPeriodTimeSets => 'Import a přidružení';

  @override
  String get discardBundledPeriodTimeSets => 'Vyhodit svázané sady';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Neexistuje žádná stávající časová sada období, takže svázané časové sady období nelze odstranit.';

  @override
  String savedToPath(Object path) {
    return 'Uloženo na $path';
  }

  @override
  String get saveCancelled => 'Uložit zrušeno';

  @override
  String get fileSaveRestrictedTitle => 'Uložení souboru omezeno';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Systém nemohl soubor uložit. Můžete to zkusit znovu nebo použít sdílení.';

  @override
  String get retrySave => 'Zkuste uložit znovu';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Povolit přístup k souboru v nastavení systému, pak se vrátit a zkuste znovu exportovat.';

  @override
  String get openSettings => 'Otevřít nastavení';

  @override
  String get browserDownloadRestrictedTitle => 'Omezené stahování prohlížeče';

  @override
  String get browserDownloadRestrictedMessage =>
      'Tento prohlížeč nepodporuje přímé uložení do lokálního souboru. Zkontrolujte oprávnění ke stahování prohlížeče nebo místo toho použijte sdílení souborů.';

  @override
  String get switchToShare => 'Místo toho používejte sdílení';

  @override
  String get fileSaveFailedTitle => 'Uložení souboru selhalo';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Nelze zapsat do aktuální cesty. Cílová složka může být chráněna, soubor může být používán nebo cesta může být nepsátelná.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Systém nemohl soubor uložit. Můžete to zkusit znovu, zkontrolovat nastavení systému nebo místo toho použít sdílení souborů.';

  @override
  String get retryLater => 'Zkuste to znovu později';

  @override
  String get exportSwitchedToShare => 'Přepnuto na sdílení souborů pro export';

  @override
  String get saveFailedRetry =>
      'Uložení selhalo. Zkuste to prosím znovu později.';

  @override
  String get importFailedCheckContent =>
      'Import selhal. Zkontrolujte prosím obsah souboru.';

  @override
  String get noImportableTimetables =>
      'V importovaném souboru nebyly nalezeny žádné použitelné harmonogramy.';

  @override
  String importedTimetablesCount(int count) {
    return 'Importované $count rozvrhy';
  }

  @override
  String get periodTimesTitle => 'Časy období';

  @override
  String get importExport => 'Import a export';

  @override
  String get importPeriodTemplate => 'Šablona období importu';

  @override
  String get importPeriodTemplateText => 'Importovat šablonu období z textu';

  @override
  String get sharePeriodTemplate => 'Šablona období podílu';

  @override
  String get saveTemplateToFile => 'Uložit šablonu do souboru';

  @override
  String get exportPeriodTemplateText => 'Exportovat šablonu období jako text';

  @override
  String get deletePeriodTimeSet => 'Smazat nastavený čas období';

  @override
  String get periodTimeSetName => 'Název nastavení času období';

  @override
  String get addOnePeriod => 'Přidat období';

  @override
  String periodNumberLabel(int index) {
    return 'Období $index';
  }

  @override
  String get deleteThisPeriod => 'Smazat tuto dobu';

  @override
  String durationMinutes(int minutes) {
    return 'Trvání $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Mezeru od předchozího $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'Čas ukončení musí být později než čas zahájení';

  @override
  String get periodOverlapPrevious => 'Toto období překrývá předchozí';

  @override
  String get periodTimesSaved => 'Uložené období';

  @override
  String get deletePeriodTimeSetTitle => 'Smazat nastavený čas období';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Smazat \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'nastavení času aktuálního období';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Importované období $count';
  }

  @override
  String get periodFilePermissionTitle => 'Povolení k souboru potřebné';

  @override
  String get androidFilePermissionMessage =>
      'Android export vyžaduje oprávnění k přístupu k souborům. Udělejte oprávnění pokračovat v ukládání.';

  @override
  String get reauthorize => 'Opět autorizovat';

  @override
  String get permissionPermanentlyDeniedTitle => 'Povolení trvale odmítnuto';

  @override
  String get permissionSettingsExportMessage =>
      'Povolit přístup k souboru v nastavení systému, pak se vrátit a zkuste znovu exportovat.';

  @override
  String get privacyPolicyTitle => 'Zásady ochrany osobních údajů';

  @override
  String get privacyPolicyEntryDesc =>
      'Přečtěte si, jak aplikace zpracovává místní úložiště, konfiguraci školního webu, import/export souborů, analýzu webových stránek a externí odkazy.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Přijatá verze: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked je rozvrhový nástroj upřednostňující lokální ukládání. Rozvrhy, časové sady a konfigurace školních stránek jsou uloženy pouze ve vašem zařízení nebo prohlížeči a nikdy nejsou automaticky nahrávány. Aplikace zpracovává data pouze tehdy, když výslovně spustíte akce jako import, analýzu webových stránek, sdílení nebo otevírání externích odkazů. Úplné zásady ochrany osobních údajů jsou k dispozici online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lokální skladování';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Data o rozvrhu a související nastavení jsou uložena v lokálním souboru s názvem Sked_data.json uvnitř adresáře dokumentů aplikace. Upravitelná konfigurace školního webu je uložena samostatně v Sked_school_sites.json. Vlastní nastavení parseru časového rozvrhu, včetně jakékoli vlastní základní adresy URL, klíče API a vybraného modelu, jsou také uloženy lokálně ve stejných datech aplikace a nejsou chráněny trezorem systémových přihlášení. Při použití v prohlížeči jsou stejné druhy dat uloženy v úložišti prohlížeče. Aplikace tyto lokální data automaticky nenahrává na server řízený vývojářem.';

  @override
  String get privacyPolicyImportExportTitle => 'Import a export';

  @override
  String get privacyPolicyImportExportBody =>
      'Aplikace čte nebo zapisuje soubory JSON časového rozvrhu, soubory JSON školních stránek a soubory šablon období pouze tehdy, když explicitně vyberete soubor nebo spustíte akci exportu. Import těchto souborů je lokální operací, pokud nevyberte také analýzu webových stránek. Nalezení vlastního seznamu modelů je také explicitní síťovou akci a kontaktuje pouze vlastní koncový bod, který jste nakonfigurovali.';

  @override
  String get privacyPolicySharingTitle => 'Sdílení';

  @override
  String get privacyPolicySharingBody =>
      'Když explicitně používáte sdílení, aplikace předá exportovaný soubor do listu sdílení systému nebo do cílové aplikace, kterou vyberete. Jak bude tento soubor následně zpracován, závisí na cílové aplikaci nebo službě, kterou jste vybrali.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Externí odkazy';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Když otevřete externí odkazy, jako je úložiště GitHub, aplikace předá akci vašemu prohlížeči nebo jiné externí aplikaci. Zpracování údajů po tomto bodě se řídí třetí stranou, kterou otevřete.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Co aplikace neshromažďuje';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Aplikace nevyžaduje účet Sked a neumožňuje analýzu, reklamní identifikátory ani cloudové zálohování. Také neposkytuje vyhrazené pole pro shromažďování hesel školních účtů. Pokud se přihlásíte na webové stránky školy uvnitř aplikace, dojde k této interakci na stránce školy, kterou jste otevřeli.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Analýza webových stránek';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Když používáte k analýze import nebo vložení HTML webové stránky školy, aplikace nejprve komprimuje obsah lokálně a pak odešle odeslaný obsah stránky, volitelný název stránky a adresu URL, aktuální jazyk aplikace a obsah výzvy k analýze vybranému koncovému bodu analýzy. Používáte-li oficiální parser, požadavek přejde na konfigurovaný oficiální backend aplikace. Pokud povolíte vlastní parser kompatibilní s OpenAI, stejný obsah je odeslán přímo na nakonfigurovaný koncový bod třetí strany a načítání seznamu modelů také vyžaduje stejný koncový bod. Vlastní koncový bod může předat žádost jiným službám AI podle vlastního návrhu tohoto poskytovatele. Nasazený oficiální backend v současné době omezuje každou odeslanou užitečnou zátěž na 300 KB, používá nakonfigurovaný časový limit a umožňuje maximálně 5 požadavků na analýzu na IP denně.';

  @override
  String get privacyPolicyUpdatesTitle => 'Aktualizace zásad';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Aktuální verze zásad ochrany osobních údajů je $version. Pokud pozdější verze změní způsob zpracování dat, aplikace vás může požádat, abyste si znovu přečetli aktualizované zásady a souhlasili s nimi.';
  }

  @override
  String get privacyGateTitle =>
      'Souhlaste prosím se zásadami ochrany osobních údajů před použitím aplikace';

  @override
  String get privacyGateSummaryStorage =>
      'Plány, časové sady a konfigurace školy jsou uloženy pouze lokálně a nejsou automaticky nahrány na server vývojářů.';

  @override
  String get privacyGateSummaryImportExport =>
      'Import, export a sdílení se odehrávají pouze tehdy, když je explicitně spustíte; Analýza webových stránek odesílá pouze komprimovaný obsah, který odešlete do nakonfigurovaného koncového bodu analýzy, a před uložením můžete zkontrolovat analyzovaný časový rozvrh.';

  @override
  String get privacyGateSummaryUpdates =>
      'Pokud pozdější verze změní způsob zpracování dat, aplikace vás může požádat, abyste znovu přezkoumali aktualizované zásady ochrany osobních údajů.';

  @override
  String get schoolWebImportEntry => 'Import ze školní stránky';

  @override
  String get schoolWebImportEntryDesc =>
      'Importujte aktuální časový rozvrh ze školních stránek.';

  @override
  String get schoolSitesManageEntry => 'Správa školních stránek';

  @override
  String get schoolSitesManageEntryDesc =>
      'Přidat, upravit a odstranit přihlašovací adresy školy pomocí importu a exportu JSON.';

  @override
  String get schoolSitesPageTitle => 'Správa školních míst';

  @override
  String get schoolSitesImportJson => 'Importovat školní JSON';

  @override
  String get schoolSitesShareJson => 'Sdílet školu JSON';

  @override
  String get schoolSitesSaveJson => 'Uložit školní JSON';

  @override
  String get schoolSitesSaved => 'Uložené školní stránky';

  @override
  String get schoolSitesImported => 'Školní stránky importované';

  @override
  String get schoolSitesEmpty => 'Zatím žádná konfigurace školních stránek.';

  @override
  String get schoolSitesNameLabel => 'Název školy';

  @override
  String get schoolSitesLoginUrlLabel => 'URL přihlášení';

  @override
  String get schoolSitesAdd => 'Přidat školu';

  @override
  String get schoolSitesEdit => 'Upravit školu';

  @override
  String get schoolSitesDeleteTitle => 'Odstranit školu';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Smazat \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Nejprve vyplňte název školy a přihlašovací adresu.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importovat vložením obsahu stránky rozvrhu';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Vložte zdrojový kód nebo surový obsah stránky obsahující informace o harmonogramu ručně.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analyzovat časový rozvrh z obsahu stránky';

  @override
  String get schoolHtmlImportUrlLabel => 'Zdrojová adresa (volitelná)';

  @override
  String get schoolHtmlImportTitleLabel => 'Název stránky (volitelné)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Obsah stránky';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Vložte zdrojový kód nebo surový obsah stránky obsahující informace o harmonogramu sem.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Veškerý obsah obsahující informace o harmonogramu může být analyzován a importován, nejen HTML.';

  @override
  String get schoolHtmlImportCompress => 'Komprimovat obsah';

  @override
  String get schoolHtmlImportCompressed => 'Komprimovaný obsah';

  @override
  String get schoolHtmlImportCompressFirst => 'Nejdřív stiskněte obsah.';

  @override
  String get schoolHtmlImportSubmit => 'Analyzovat a importovat';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsing může chvíli trvat. Počkejte, prosím.';

  @override
  String get schoolHtmlImportEmpty => 'Nejprve vložte HTML stránku.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Zpět na stránku';

  @override
  String get schoolWebImportPageTitle => 'Import školních webových stránek';

  @override
  String get schoolWebImportPreview => 'Importovat náhled';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count kurzy';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count období';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Název stránky';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Importovat poznámky';

  @override
  String get schoolWebImportOpenPageHint =>
      'Přihlaste se na stránku školy v aplikaci a přejděte na stránku časového rozvrhu ručně.';

  @override
  String get schoolWebImportConfigMissing =>
      'Web import backend API zatím není nakonfigurováno.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Tato platforma zatím nepodporuje vložené webové přihlášení. Používejte platformu s podporou WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Vyberte si školu';

  @override
  String get schoolWebImportNoSchools =>
      'Školní konfigurace není k dispozici. Nejprve zkontrolujte school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Nepodařilo se načíst konfiguraci školy. Zkontrolujte formát souboru JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importovat aktuální stránku';

  @override
  String get schoolWebImportGoBack => 'Předchozí stránka';

  @override
  String get schoolWebImportLoadingPage => 'Načítání stránky…';

  @override
  String get schoolWebImportParsing => 'Analyzuje aktuální stránku...';

  @override
  String get schoolWebImportLoadFailed =>
      'Načítání stránky selhalo. Prosím, obnovte nebo zkuste to znovu později.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Načítání stránky vypršelo. Prosím, osvěžte a zkuste znovu.';

  @override
  String get schoolWebImportEmptyPage =>
      'Aktuální obsah stránky je prázdný a zatím nelze importovat.';

  @override
  String get schoolWebImportSuccess => 'Webový rozvrh importován';

  @override
  String get schoolImportParserSettingsTitle => 'Nastavení rozvrhu parseru';

  @override
  String get schoolImportParserSettingsDesc =>
      'Vyberte si oficiální parser nebo vlastní koncový bod kompatibilní s OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Zdroj parseru';

  @override
  String get schoolImportParserSourceOfficial => 'Oficiální parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Použijte vestavěnou oficiální službu analýzy nakonfigurovanou aplikací.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Oficiální parser používá konfigurovaný parsovací backend aplikace a udržuje aktuální tok importu nezměněný.';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'Kompatibilní s OpenAI';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Odešlete obsah stránky přímo na svůj vlastní koncový bod kompatibilní s OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Vlastní parser kompatibilní s OpenAI';

  @override
  String get schoolImportParserCustomPromptTitle => 'Vlastní výzva';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Upravte vestavěnou výzvu parseru zde. Změny ovlivňují pouze vlastní parser kompatibilní s OpenAI.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Vestavěná výzva je zde ve výchozím nastavení načtená. Vymazejte ji, abyste se vrátili k vestavěné verzi.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Resetovat výchozí výzvu';

  @override
  String get schoolImportParserBaseUrl => 'Základní adresa URL';

  @override
  String get schoolImportParserApiKey => 'Klíč API';

  @override
  String get schoolImportParserModel => 'modelu';

  @override
  String get schoolImportParserFetchModels => 'Přinést seznam modelů';

  @override
  String get schoolImportParserFetchingModels => 'Přivádět modely. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Konečným bodem nebyly vráceny žádné modely.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Přihlášené modely $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Vlastní klíč API je uložen v místním nastavení aplikace v plaintextu v současné implementaci. Používejte ji pouze na zařízení nebo prohlížeči, kterému důvěřujete.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Konfigurace vlastního parseru je neúplná. Nejprve vyplňte základní adresu URL, klíč API a model.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Oficiální';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: Vlastní ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Zobrazit úplné zásady ochrany osobních údajů';

  @override
  String get privacyAgreeAndContinue => 'Souhlasím a pokračujeme';

  @override
  String get privacyDecline => 'Odmítnutí';

  @override
  String get privacyDeclineWebHint =>
      'Toto prostředí prohlížeče neumožňuje aplikaci zavřít stránku pro vás. Pokud nesouhlasíte, zavřete prosím tuto kartu nebo okno sami.';

  @override
  String get defaultPeriodTimeSetName => 'Výchozí období';

  @override
  String get periodTimeSetFallbackName => 'Časy období';

  @override
  String get untitledTimetableName => 'Rozvrh bez názvu';

  @override
  String get newTimetableName => 'Nový rozvrh';

  @override
  String get newPeriodTimeSetName => 'Nastavení nového období';

  @override
  String get emptyTimetableName => 'Prázdný rozvrh';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name období';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Typ souboru importu se neshoduje.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Tato verze importového souboru zatím není podporována.';

  @override
  String get noPeriodTimesInImportMessage =>
      'V souboru importu nebyly nalezeny žádné časové období.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Vyberte alespoň jeden časový rozvrh.';

  @override
  String get noExportableTimetableMessage =>
      'Pro export není k dispozici žádný časový rozvrh.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Nahrazení aktuálního harmonogramu podporuje pouze výběr jednoho harmonogramu.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Neexistuje žádný aktuální časový rozvrh k nahrazení.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Toto časové období je stále používáno časovým rozvrhem $count. Před smazáním je znovu přiřaďte.';
  }

  @override
  String get weekdayMonday => 'pondělí';

  @override
  String get weekdayTuesday => 'Úterý';

  @override
  String get weekdayWednesday => 'Středa';

  @override
  String get weekdayThursday => 'Čtvrtek';

  @override
  String get weekdayFriday => 'pátek';

  @override
  String get weekdaySaturday => 'sobota';

  @override
  String get weekdaySunday => 'Neděle';

  @override
  String get weekdayShortMonday => 'pondělí';

  @override
  String get weekdayShortTuesday => 'úterý';

  @override
  String get weekdayShortWednesday => 'Středa';

  @override
  String get weekdayShortThursday => 'Čtvrtek';

  @override
  String get weekdayShortFriday => 'pátek';

  @override
  String get weekdayShortSaturday => 'sobotu';

  @override
  String get weekdayShortSunday => 'Slunce';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'Únor';

  @override
  String get monthMarch => 'března';

  @override
  String get monthApril => 'duben';

  @override
  String get monthMay => 'května';

  @override
  String get monthJune => 'června';

  @override
  String get monthJuly => 'červenec';

  @override
  String get monthAugust => 'srpen';

  @override
  String get monthSeptember => 'září';

  @override
  String get monthOctober => 'říjen';

  @override
  String get monthNovember => 'listopad';

  @override
  String get monthDecember => 'prosinec';

  @override
  String get semesterWeeksWholeTerm => 'Celý semestr';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Týdny $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Týdny $value';
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
}
