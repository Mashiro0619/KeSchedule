// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'Učitelj';

  @override
  String weekLabel(int week) {
    return 'Teden $week';
  }

  @override
  String get addCourse => 'Dodaj smer';

  @override
  String get settings => 'Nastavitve';

  @override
  String get multiTimetableSwitch => 'Zamenjaj vozni red';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Trenutni urnik · $weeks tednov';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Tapnite za preklop · $weeks tednov';
  }

  @override
  String get editTimetable => 'Uredi urnik';

  @override
  String get createTimetable => 'Nov časovni razpored';

  @override
  String get jumpToWeek => 'Skoči na teden';

  @override
  String get timetable => 'Časovni razpored';

  @override
  String get timetableName => 'Ime urnika';

  @override
  String get totalWeeks => 'Skupaj tedni';

  @override
  String get delete => 'Zbriši';

  @override
  String get cancel => 'Prekliči';

  @override
  String get save => 'Shrani';

  @override
  String get deleteTimetableTitle => 'Izbriši časovni razpored';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Izbriši \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Časovnega razporeda še ni';

  @override
  String get noTimetableMessage =>
      'Ustvarite urnik ali ga uvozite iz datoteke JSON.';

  @override
  String get importTimetable => 'Uvozni časovni razpored';

  @override
  String get courseName => 'Ime tečaja';

  @override
  String get location => 'Lokacija';

  @override
  String get dayOfWeek => 'Dan';

  @override
  String get semesterWeeks => 'Tedni';

  @override
  String get startTime => 'Začetni čas';

  @override
  String get endTime => 'Končni čas';

  @override
  String get linkedPeriods => 'Povezana obdobja';

  @override
  String get linkedPeriodsUnmatched =>
      'Obdobja se za trenutni čas ne ujemajo. Tapnite, da izberete ročno.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Obdobje $start-$end';
  }

  @override
  String get teacherName => 'Učitelj';

  @override
  String get credits => 'Krediti';

  @override
  String get remarks => 'Opombe';

  @override
  String get customFields => 'Polja po meri';

  @override
  String get customFieldsHint => 'Ena na vrstico, oblika: ključ: value';

  @override
  String get selectDayOfWeek => 'Izberite dan';

  @override
  String get selectSemesterWeeks => 'Izberite tedne';

  @override
  String get selectAll => 'Izberi vse';

  @override
  String get clear => 'Počisti';

  @override
  String get confirm => 'Potrdi';

  @override
  String get selectLinkedPeriods => 'Izberite povezana obdobja';

  @override
  String get addCourseTitle => 'Dodaj smer';

  @override
  String get editCourseTitle => 'Uredi smer';

  @override
  String get editCourseTooltip => 'Uredi smer';

  @override
  String get place => 'Lokacija';

  @override
  String get time => 'Čas';

  @override
  String get notFilled => 'Ni napolnjeno';

  @override
  String get none => 'Brez';

  @override
  String get conflictCourses => 'Nasprotujoči tečaji';

  @override
  String get locationNotFilled => 'Lokacija ni zapolnjena';

  @override
  String get setAsDisplayed => 'Nastavi kot prikazano';

  @override
  String get editThisCourse => 'Uredi ta tečaj';

  @override
  String get settingsTitle => 'Nastavitve';

  @override
  String get noTimetableSettings =>
      'Trenutno ni na voljo nobenega urnika za nastavitve.';

  @override
  String get semesterStartDate => 'Datum začetka semestra';

  @override
  String get periodTimeSets => 'Določen čas obdobja';

  @override
  String get noPeriodTimeAvailable => 'Ni nastavljenega obdobja';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count obdobja';
  }

  @override
  String get coursePopupDismissSetting =>
      'Dovoli zunanji tap, da zaprete pojavno okno smeri';

  @override
  String get coursePopupDismissSettingHint =>
      'Če to izklopite, onemogočite tudi odpustitev podrska navzdol.';

  @override
  String get preserveTimetableGaps => 'Ohranitev vrzeli v časovnem razporedu';

  @override
  String get preserveTimetableGapsHint =>
      'Ko je izklopljeno, se vrzeli za kosilo in prelom zrušijo, tako da se kasnejši razredi premaknejo navzgor.';

  @override
  String get showPastEndedCourses => 'Prikaži pretekle tečaje';

  @override
  String get showPastEndedCoursesHint =>
      'Prikaži tečaje, ki so že končali do resničnega tekočega tedna s svetlejšim sivim slogom.';

  @override
  String get showFutureCourses => 'Prikaži prihodnje tečaje';

  @override
  String get showFutureCoursesHint =>
      'Prikaži tečaje, ki ta teden niso aktivni, vendar se bodo pojavili v poznejših tednih s sivim slogom.';

  @override
  String get timetableDisplaySettings => 'Prikaz urnika in interakcija';

  @override
  String get timetableDisplaySettingsDesc =>
      'Razrešitev pojavnega okna, vrzeli, sivi tečaji in mrežne črte';

  @override
  String get showTimetableGridLines => 'Prikaži črte mreže urnika';

  @override
  String get showTimetableGridLinesHint =>
      'Nadzorujte, ali so vodoravne in navpične mrežne črte vidne v voznem redu.';

  @override
  String get liveCourseOutlineColor => 'Barva orisa tečaja';

  @override
  String get liveCourseOutlineColorHint =>
      'Izberite, ali so obrisi usmerjeni v trenutni/naslednji tečaj ali vse prikazane tečaje na trenutni strani.';

  @override
  String get liveCourseOutlineSettings => 'Opis tečaja';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Nastavite, ali je oris omogočen, kaj cilja, ali sledi barvi teme in učinkoviti barvi orisa.';

  @override
  String get liveCourseOutlineEnabled => 'Omogoči oris';

  @override
  String get liveCourseOutlineFollowTheme => 'Sledi barvi teme';

  @override
  String get liveCourseOutlineTarget => 'Osnovni cilj';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Trenutni/naslednji tečaj';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Vsi prikazani tečaji';

  @override
  String get liveCourseOutlineEffectiveColor => 'Učinkovita barva';

  @override
  String get liveCourseOutlineCustomColor => 'Barva orisa po meri';

  @override
  String get liveCourseOutlineWidth => 'Širina orisa';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Jezik';

  @override
  String get languagePageDescription =>
      'Izberite enega od jezikov, ki je resnično na voljo v aplikaciji.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'angleščina';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Odziv API';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Sistem sledenja';

  @override
  String get themeLight => 'Svetloba';

  @override
  String get themeDark => 'Temna';

  @override
  String get themeColor => 'Barva teme';

  @override
  String get themeColorModeSingle => 'Barva ene teme';

  @override
  String get themeColorModeColorful => 'Barvno';

  @override
  String get themeColorUiColors => 'Barve uporabniškega vmesnika';

  @override
  String get themeColorCourseColors => 'Barve tečaja';

  @override
  String get themeColorPrimary => 'Primarni';

  @override
  String get themeColorSecondary => 'Sekundarni';

  @override
  String get themeColorTertiary => 'Terciarna';

  @override
  String get themeColorCourseText => 'Besedilo tečaja';

  @override
  String get themeColorCourseTextAuto => 'Samodejno';

  @override
  String get themeColorCourseTextCustom => 'Barva po meri';

  @override
  String get themeColorCourseColorsEmpty =>
      'Barve tečaja bodo ustvarjene po uvozu urnika.';

  @override
  String get themeCustomColor => 'Barva po meri';

  @override
  String get themeApplyCustomColor => 'Uporabi barvo';

  @override
  String get themeApplySettings => 'Uporabi nastavitve';

  @override
  String get dataImportExport => 'Podatki o uvozu in izvozu';

  @override
  String get dataImportExportDesc =>
      'Uvozite celotne podatke ali posamezne vozne redi ali izvozite trenutne/vse vozne redi.';

  @override
  String get openSourceLicenses => 'Odprtokodne licence';

  @override
  String get openSourceLicensesDesc =>
      'Oglejte si licence za odvisnosti Flutter in združena sredstva ikon aplikacij.';

  @override
  String get checkForUpdates => 'Preveri posodobitve';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Uradna spletna stran / Google Play / Cloud Drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Že na najnovejši različici ($version)';
  }

  @override
  String get currentVersionLabel => 'Trenutna različica';

  @override
  String get newVersionAvailable => 'Na voljo je posodobitev';

  @override
  String get latestVersionLabel => 'Najnovejša različica';

  @override
  String get updateContentLabel => 'Podrobnosti o posodobitvi';

  @override
  String get officialWebsite => 'Uradna spletna stran';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Pogon v oblaku';

  @override
  String get ignoreThisVersion => 'Prezri to različico';

  @override
  String get openUpdatesFailed => 'Ni moč odpreti povezave za posodobitev';

  @override
  String get updateCheckFailedTitle => 'Preverjanje posodobitve ni uspelo';

  @override
  String get updateCheckFailedMessage =>
      'Ni moč dobiti veljavnih informacij o posodobitvi iz katerega koli vira posodobitve. Še vedno lahko uporabite spodnje povezave za ročno posodobitev.';

  @override
  String get githubRepository => 'Skladišče GitHub';

  @override
  String get openGithubFailed =>
      'Ni moč odpreti povezave za repozitorij GitHub';

  @override
  String get selectPeriodTimeSet => 'Izberite nastavljeno obdobje';

  @override
  String get newItem => 'Novo';

  @override
  String get editPeriodTimeSet => 'Uredi nastavljeno obdobje';

  @override
  String get importTimetableFiles => 'Uvozni časovni razpored';

  @override
  String get importTimetableFilesDesc => 'Podpira eno ali več datotek urnika.';

  @override
  String get importTimetableText => 'Uvozni časovni razpored iz besedila';

  @override
  String get importTimetableTextDesc =>
      'Prilepite vsebino JSON urnika in jo uvozite.';

  @override
  String get shareTimetableFiles => 'Deli datoteke s časovnim razporedom';

  @override
  String get shareTimetableFilesDesc =>
      'Najprej izberite enega ali več voznih redov.';

  @override
  String get saveTimetableFiles => 'Shrani datoteke s časovnim razporedom';

  @override
  String get saveTimetableFilesDesc =>
      'Najprej izberite enega ali več voznih redov.';

  @override
  String get exportTimetableText => 'Časovni razpored izvoza kot besedilo';

  @override
  String get exportTimetableTextDesc =>
      'Izberite enega ali več voznih redov in kopirajte vsebino JSON.';

  @override
  String get jsonContent => 'Vsebina JSON';

  @override
  String get pasteJsonContentHint => 'Prilepi vsebino JSON za uvoz.';

  @override
  String get jsonContentEmpty => 'Najprej prilepi vsebino JSON.';

  @override
  String get copyText => 'Kopiraj';

  @override
  String get copiedToClipboard => 'Kopirano v odložišče';

  @override
  String get share => 'Delež';

  @override
  String get selectTimetablesToExport => 'Izberite časovne razporede za izvoz';

  @override
  String get selectTimetablesToImport => 'Izberite časovne razporede za uvoz';

  @override
  String timetableCourseCount(int count) {
    return '$count tečaji';
  }

  @override
  String get importAction => 'Uvozi';

  @override
  String get importTimetableDialogTitle => 'Uvozni časovni razpored';

  @override
  String get chooseImportMethod => 'Izberite, kako uvoziti.';

  @override
  String get importAsNewTimetable => 'Uvoz kot nov časovni razpored';

  @override
  String get replaceCurrentTimetable => 'Zamenjaj trenutni časovni razpored';

  @override
  String get importPeriodTimeSetDialogTitle => 'Časovni nizi obdobja uvoza';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Ta datoteka vsebuje združene nabore časovnih obdobj. Ali jih želite uvoziti in povezati?';

  @override
  String get importBundledPeriodTimeSets => 'Uvozi in povezuj';

  @override
  String get discardBundledPeriodTimeSets => 'Zavrzite pakete';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Obstoječih časovnih nastavitev obdobja ni na voljo, zato združenih časovnih nizov obdobja ni mogoče zavreči.';

  @override
  String savedToPath(Object path) {
    return 'Shranjeno v $path';
  }

  @override
  String get saveCancelled => 'Shranjevanje preklicano';

  @override
  String get fileSaveRestrictedTitle => 'Shranjevanje datotek omejeno';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Sistem ni mogel shraniti datoteke. Namesto tega lahko znova poskusite ali uporabite skupno rabo.';

  @override
  String get retrySave => 'Poskusi znova shraniti';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Omogočite dostop do datotek v sistemskih nastavitvah, nato pa se vrnite in poskusite znova izvoziti.';

  @override
  String get openSettings => 'Odpri nastavitve';

  @override
  String get browserDownloadRestrictedTitle => 'Prenos brskalnika omejen';

  @override
  String get browserDownloadRestrictedMessage =>
      'Ta brskalnik ne podpira neposrednega shranjevanja v lokalno datoteko. Preverite dovoljenja za prenos brskalnika ali namesto tega uporabite skupno rabo datotek.';

  @override
  String get switchToShare => 'Namesto tega uporabi skupno rabo';

  @override
  String get fileSaveFailedTitle => 'Shranjevanje datoteke ni uspelo';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Ni moč pisati na trenutno pot. Ciljna mapa je lahko zaščitena, datoteka je lahko v uporabi ali pot ni mogoče napisati.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Sistem ni mogel shraniti datoteke. Lahko znova poskusite, preverite sistemske nastavitve ali namesto tega uporabite skupno rabo datotek.';

  @override
  String get retryLater => 'Poskusi kasneje znova.';

  @override
  String get exportSwitchedToShare =>
      'Preklopil na skupno rabo datotek za izvoz';

  @override
  String get saveFailedRetry =>
      'Shranjevanje ni uspelo. Prosim, poskusite kasneje znova.';

  @override
  String get importFailedCheckContent =>
      'Uvoz ni uspel. Prosim preverite vsebino datoteke.';

  @override
  String get noImportableTimetables =>
      'V uvoženi datoteki niso našli uporabnih urnikov.';

  @override
  String importedTimetablesCount(int count) {
    return 'Uvoženi vozni redi $count';
  }

  @override
  String get periodTimesTitle => 'Obdobje';

  @override
  String get importExport => 'Uvoz in izvoz';

  @override
  String get importPeriodTemplate => 'Predloga za uvoz obdobja';

  @override
  String get importPeriodTemplateText => 'Uvozi predlogo obdobja iz besedila';

  @override
  String get sharePeriodTemplate => 'Predloga obdobja deljenja';

  @override
  String get saveTemplateToFile => 'Shrani predlogo v datoteko';

  @override
  String get exportPeriodTemplateText => 'Izvozi predlogo obdobja kot besedilo';

  @override
  String get deletePeriodTimeSet => 'Izbriši nastavljeno obdobje';

  @override
  String get periodTimeSetName => 'Ime nastavljenega časa obdobja';

  @override
  String get addOnePeriod => 'Dodaj obdobje';

  @override
  String periodNumberLabel(int index) {
    return 'Obdobje $index';
  }

  @override
  String get deleteThisPeriod => 'Črtaj to obdobje';

  @override
  String durationMinutes(int minutes) {
    return 'Trajanje $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Vrzel od prejšnjega $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'Končni čas mora biti poznejši od začetnega časa';

  @override
  String get periodOverlapPrevious => 'To obdobje se prekriva s prejšnjim';

  @override
  String get periodTimesSaved => 'Obdobje shranjeno';

  @override
  String get deletePeriodTimeSetTitle => 'Izbriši nastavljeno obdobje';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Izbriši \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'določen čas trenutnega obdobja';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Uvoženi $count časi obdobja';
  }

  @override
  String get periodFilePermissionTitle => 'Potrebno je dovoljenje za datoteko';

  @override
  String get androidFilePermissionMessage =>
      'Izvoz Android zahteva dovoljenje za dostop do datotek. Daj dovoljenje za nadaljnje shranjevanje.';

  @override
  String get reauthorize => 'Ponovno odobri';

  @override
  String get permissionPermanentlyDeniedTitle => 'Dovoljenje trajno zavrnjeno';

  @override
  String get permissionSettingsExportMessage =>
      'Omogočite dostop do datotek v sistemskih nastavitvah, nato pa se vrnite in poskusite znova izvoziti.';

  @override
  String get privacyPolicyTitle => 'Pravilnik o zasebnosti';

  @override
  String get privacyPolicyEntryDesc =>
      'Preberite, kako aplikacija obravnava lokalno shranjevanje, konfiguracijo šolskega mesta, uvoz/izvoz datotek, razčlenjevanje spletnih strani in zunanje povezave.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Sprejeta različica: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked je orodje za urnike, ki daje prednost lokalni hrambi. Urniki, nabori obdobij in konfiguracija šolskega mesta so shranjeni samo v vaši napravi ali brskalniku in se nikoli ne naložijo samodejno. Aplikacija obdeluje podatke samo, ko izrecno sprožite dejanja, kot so uvoz, razčlenjevanje spletnih strani, deljenje ali odpiranje zunanjih povezav. Celotna politika zasebnosti je na voljo na spletu.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lokalno shranjevanje';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Podatki o urniku in sorodnih nastavitvah so shranjeni v lokalni datoteki z imenom Sked_data.json znotraj imenika dokumentov aplikacije. Urejljiva konfiguracija šolskega mesta je shranjena ločeno v Sked_school_sites.json. Nastavitve razčlenjevalnika urnika po meri, vključno s katerim koli osnovnim URL-jem po meri, ključem API in izbranim modelom, so prav tako lokalno shranjene v istih podatkih aplikacije in niso zaščitene s sistemskim trezorjem poverilnic. Kadar se uporabljajo v brskalniku, se enake vrste podatkov shranijo v shranjevanju brskalnika. Aplikacija ne nalaga samodejno teh lokalnih podatkov v strežnik, ki ga nadzoruje razvijalec.';

  @override
  String get privacyPolicyImportExportTitle => 'Uvoz in izvoz';

  @override
  String get privacyPolicyImportExportBody =>
      'Aplikacija bere ali piše datoteke JSON urnika, datoteke JSON šolskega mesta in datoteke predloge obdobja samo, ko izrecno izberete datoteko ali začnete izvozno dejanje. Uvoz teh datotek je lokalna operacija, razen če izberete tudi razčlenitev spletne strani. Pridobivanje seznama modelov po meri je tudi izrecno omrežno dejanje in kontaktira le končno točko po meri, ki ste jo konfigurirali.';

  @override
  String get privacyPolicySharingTitle => 'Delitev';

  @override
  String get privacyPolicySharingBody =>
      'Ko izrecno uporabljate skupno rabo, program prenese izvoženo datoteko na list skupne rabe sistema ali ciljni program, ki ga izberete. Način uporabe te datoteke je odvisen od ciljne aplikacije ali storitve, ki ste jo izbrali.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Zunanje povezave';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Ko odprete zunanje povezave, kot je repozitorij GitHub, aplikacija prenese dejanje vašemu brskalniku ali drugi zunanji aplikaciji. Obdelavo podatkov po tej točki ureja tretja oseba, ki jo odprete.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Kaj aplikacija ne zbira';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Aplikacija ne zahteva računa Sked in ne omogoča analitike, oglaševalskih identifikatorjev ali varnostne kopije v oblaku. Prav tako ne zagotavlja namenskega polja za zbiranje gesel šolskih računov. Če se v aplikaciji vpišete na spletno mesto šole, se ta interakcija zgodi na strani šole, ki ste jo odprli.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Razčlenitev spletnih strani';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Ko za razčlenitev uporabljate šolsko spletno stran uvoz ali lepljenje HTML, aplikacija najprej stisne vsebino lokalno, nato pa pošlje vsebino poslane strani, neobvezni naslov strani in URL, trenutni jezik aplikacije in vsebino poziva za razčlenitev na izbrano končno točko razčlenitve. Če uporabljate uradni razčlenjevalnik, zahteva gre na konfigurirano uradno hrbtenico aplikacije. Če omogočite razčlenjevalnik, združljiv z OpenAI, po meri, bo ista vsebina poslana neposredno končni točki tretje osebe, ki ste jo konfigurirali, pridobivanje seznama modelov pa zahteva tudi to končno točko. Končna točka po meri lahko zahtevo posreduje drugim storitvam umetne inteligence v skladu z lastno zasnovo tega ponudnika. Uvedena uradna hrbtenica trenutno omejuje vsako poslano koristno obremenitev na 300 KB, uporablja konfigurirano časovno omejitev in omogoča največ 5 zahtev za razčlenitev na IP na dan.';

  @override
  String get privacyPolicyUpdatesTitle => 'Posodobitve pravilnika';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Trenutna različica politike zasebnosti je $version. Če poznejša različica spremeni način ravnanja s podatki, vas lahko aplikacija zahteva, da znova preberete posodobljeni pravilnik in se z njim strinjate.';
  }

  @override
  String get privacyGateTitle =>
      'Prosimo, strinjajte se s politiko zasebnosti pred uporabo aplikacije';

  @override
  String get privacyGateSummaryStorage =>
      'Časovni razporedi, nabori obdobja in konfiguracija šolskega mesta so shranjeni le lokalno in se ne naložijo samodejno v strežnik razvijalcev.';

  @override
  String get privacyGateSummaryImportExport =>
      'Uvoz, izvoz in skupna raba se zgodijo le, ko jih izrecno zaženete; Razčlenjevanje spletne strani pošlje samo stisnjeno vsebino, ki jo pošljete na konfigurirano končno točko razčlenjanja, preden shranite, pa lahko pregledate razčlenjen časovni razpored.';

  @override
  String get privacyGateSummaryUpdates =>
      'Če poznejša različica spremeni način ravnanja s podatki, vas lahko aplikacija zahteva, da znova pregledate posodobljeni pravilnik o zasebnosti.';

  @override
  String get schoolWebImportEntry => 'Uvozi s spletne strani šole';

  @override
  String get schoolWebImportEntryDesc =>
      'Uvozi trenutno stran voznega reda s spletnega mesta šole.';

  @override
  String get schoolSitesManageEntry => 'Upravljanje šolskih spletnih mest';

  @override
  String get schoolSitesManageEntryDesc =>
      'Dodajanje, urejanje in brisanje šolskih prijavnih URL-jev z uvozom in izvozom JSON.';

  @override
  String get schoolSitesPageTitle => 'Upravljanje šolskih lokacij';

  @override
  String get schoolSitesImportJson => 'Uvozna šola JSON';

  @override
  String get schoolSitesShareJson => 'Deli šolo JSON';

  @override
  String get schoolSitesSaveJson => 'Shrani šolo JSON';

  @override
  String get schoolSitesSaved => 'Shranjena šolska mesta';

  @override
  String get schoolSitesImported => 'Uvožena šolska mesta';

  @override
  String get schoolSitesEmpty => 'Šolska lokacija še ni konfiguracije.';

  @override
  String get schoolSitesNameLabel => 'Ime šole';

  @override
  String get schoolSitesLoginUrlLabel => 'URL za prijavo';

  @override
  String get schoolSitesAdd => 'Dodaj šolo';

  @override
  String get schoolSitesEdit => 'Uredi šolo';

  @override
  String get schoolSitesDeleteTitle => 'Izbriši šolo';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Izbriši \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Najprej vnesite ime šole in URL za prijavo.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Uvoz z lepljenjem vsebine strani s časovnim razporedom';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Ročno prilepite izvorno kodo ali neobdelano vsebino strani, ki vsebuje informacije o urniku.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Razčleni časovni razpored iz vsebine strani';

  @override
  String get schoolHtmlImportUrlLabel => 'Izvorni URL (neobvezno)';

  @override
  String get schoolHtmlImportTitleLabel => 'Naslov strani (neobvezno)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Vsebina strani';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Tukaj prilepite izvorno kodo ali neobdelano vsebino strani, ki vsebuje informacije o urniku.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Vsako vsebino, ki vsebuje informacije o voznem redu, je mogoče razčleniti in uvoziti, ne samo HTML.';

  @override
  String get schoolHtmlImportCompress => 'Stisni vsebino';

  @override
  String get schoolHtmlImportCompressed => 'Vsebina stisnjena';

  @override
  String get schoolHtmlImportCompressFirst => 'Najprej stisni vsebino.';

  @override
  String get schoolHtmlImportSubmit => 'Razčlenitev in uvoz';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Razčlenitev bo trajala nekaj časa. Prosim, počakajte.';

  @override
  String get schoolHtmlImportEmpty => 'Najprej prilepi HTML strani.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Nazaj na spletno stran';

  @override
  String get schoolWebImportPageTitle => 'Uvoz spletne strani šole';

  @override
  String get schoolWebImportPreview => 'Uvozi predogled';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count tečaji';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count obdobja';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Naslov strani';

  @override
  String get schoolWebImportParserUsed => 'Razčlenjevalnik';

  @override
  String get schoolWebImportWarnings => 'Uvozi opombe';

  @override
  String get schoolWebImportOpenPageHint =>
      'Vpišite se v šolsko spletno mesto v aplikaciji in se ročno pomaknite na stran s časovnim razporedom.';

  @override
  String get schoolWebImportConfigMissing =>
      'API za spletni uvoz hrbtenice še ni konfiguriran.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Ta platforma še ne podpira vdelane spletne prijave. Prosimo, uporabite platformo s podporo WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Izberite šolo';

  @override
  String get schoolWebImportNoSchools =>
      'Šolska nastavitev ni na voljo. Najprej preveri school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Ni uspelo naložiti šolske nastavitve. Preverite obliko datoteke JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Uvozi trenutno stran';

  @override
  String get schoolWebImportGoBack => 'Prejšnja stran';

  @override
  String get schoolWebImportLoadingPage => 'Nalaganje strani...';

  @override
  String get schoolWebImportParsing => 'Razčlenitev trenutne strani...';

  @override
  String get schoolWebImportLoadFailed =>
      'Nalaganje strani ni uspelo. Osvežite ali poskusite znova kasneje.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Nalaganje strani je poteklo. Prosim osvežite in poskusite znova.';

  @override
  String get schoolWebImportEmptyPage =>
      'Trenutna vsebina strani je prazna in je še ni mogoče uvoziti.';

  @override
  String get schoolWebImportSuccess => 'Uvožen spletni urnik';

  @override
  String get schoolImportParserSettingsTitle =>
      'Nastavitve razčlenjevalnika časovnega reda';

  @override
  String get schoolImportParserSettingsDesc =>
      'Izberite uradni razčlenjevalnik ali končno točko po meri, združljivo z OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Vir razčlenjevanja';

  @override
  String get schoolImportParserSourceOfficial => 'Uradni razčlenjevalnik';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Uporabite vgrajeno uradno storitev razčlenitve, ki jo konfigurira aplikacija.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Uradni razčlenjevalnik uporablja konfigurirano razčlenjevalno hrbtenico aplikacije in ohranja trenutni uvozni tok nespremenjen.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Po meri združljiv z OpenAI';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Pošljite vsebino strani neposredno na svojo končno točko, združljivo z OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Razčlenjevalnik po meri, združljiv z OpenAI';

  @override
  String get schoolImportParserCustomPromptTitle => 'Poziv po meri';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Uredi vgrajen poziv razčlenjevalnika tukaj. Spremembe vplivajo samo na razčlenjevalnik, združljiv z OpenAI po meri.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Vgrajeni poziv je privzeto naložen tukaj. Počistite ga, da se vrnete na vgrajeno različico.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Ponastavi privzeti poziv';

  @override
  String get schoolImportParserBaseUrl => 'Osnovni URL';

  @override
  String get schoolImportParserApiKey => 'Ključ API';

  @override
  String get schoolImportParserModel => 'Vzorec';

  @override
  String get schoolImportParserFetchModels => 'Pridobi seznam modelov';

  @override
  String get schoolImportParserFetchingModels => 'Dobivam modele. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Do končne točke modelov niso vrnili.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Pridobljeni modeli $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Ključ API po meri je shranjen v lokalnih nastavitvah aplikacije v navadnem besedilu pod trenutno implementacijo. Uporabljajte ga samo v napravi ali brskalniku, ki mu zaupate.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Nastavitev razčlenjevalnika po meri je nepopolna. Najprej izpolnite osnovni URL, API ključ in model.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Razdeljevalec: Uradni';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Razčlenitev: po meri ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Oglejte si celoten pravilnik o zasebnosti';

  @override
  String get privacyAgreeAndContinue => 'Strinjam se in nadaljujem';

  @override
  String get privacyDecline => 'Zavrni';

  @override
  String get privacyDeclineWebHint =>
      'To okolje brskalnika ne dovoljuje aplikaciji, da zapre stran za vas. Če se ne strinjate, zaprite ta zavihek ali okno sami.';

  @override
  String get defaultPeriodTimeSetName => 'Privzeta obdobja';

  @override
  String get periodTimeSetFallbackName => 'Obdobje';

  @override
  String get untitledTimetableName => 'Brez naslova vozni red';

  @override
  String get newTimetableName => 'Nov časovni razpored';

  @override
  String get newPeriodTimeSetName => 'Novo določeno obdobje';

  @override
  String get emptyTimetableName => 'Prazen urnik';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name obdobja';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Vrsta uvoza datoteke se ne ujema.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Različica uvozne datoteke še ni podprta.';

  @override
  String get noPeriodTimesInImportMessage =>
      'V uvozni datoteki ni bilo časa obdobja.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Prosimo, izberite vsaj en urnik.';

  @override
  String get noExportableTimetableMessage => 'Za izvoz ni razporeda.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Zamenjava sedanjega voznega reda podpira samo izbiro enega voznega reda.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Trenutnega časovnega razporeda ni za nadomestitev.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'To določeno obdobje še vedno uporabljajo $count urniki. Prerazporedite jih preden izbrišete.';
  }

  @override
  String get weekdayMonday => 'Ponedeljek';

  @override
  String get weekdayTuesday => 'Torek';

  @override
  String get weekdayWednesday => 'Sreda';

  @override
  String get weekdayThursday => 'Četrtek';

  @override
  String get weekdayFriday => 'Petek';

  @override
  String get weekdaySaturday => 'Sobota';

  @override
  String get weekdaySunday => 'Nedelja';

  @override
  String get weekdayShortMonday => 'Naslednji mesec';

  @override
  String get weekdayShortTuesday => 'Tor';

  @override
  String get weekdayShortWednesday => 'sreda';

  @override
  String get weekdayShortThursday => 'četrt';

  @override
  String get weekdayShortFriday => 'pet';

  @override
  String get weekdayShortSaturday => 'Sat';

  @override
  String get weekdayShortSunday => 'Sonce';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'februar';

  @override
  String get monthMarch => 'Mar';

  @override
  String get monthApril => 'Apr';

  @override
  String get monthMay => 'Maj';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'jul';

  @override
  String get monthAugust => 'avg';

  @override
  String get monthSeptember => 'sept.';

  @override
  String get monthOctober => 'okt.';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Dec.';

  @override
  String get semesterWeeksWholeTerm => 'Cel semester';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Tedni $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Tedni $value';
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
  String get markReminderHandled => 'Mark handled';

  @override
  String get restoreReminder => 'Restore reminder';

  @override
  String get reminderHandled => 'Reminder marked handled';

  @override
  String get reminderRestored => 'Reminder restored';

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
}
