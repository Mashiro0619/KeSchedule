// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Luokkakaveri';

  @override
  String weekLabel(int week) {
    return 'Viikko $week';
  }

  @override
  String get addCourse => 'Lisää kurssi';

  @override
  String get settings => 'Asetukset';

  @override
  String get multiTimetableSwitch => 'Vaihda aikataulut';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Nykyinen aikataulu · $weeks viikkoja';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Napauta vaihtaa · $weeks viikkoja';
  }

  @override
  String get editTimetable => 'Muokkaa aikataulua';

  @override
  String get createTimetable => 'Uusi aikataulu';

  @override
  String get jumpToWeek => 'Hyppää viikkoon';

  @override
  String get timetable => 'Aikataulu';

  @override
  String get timetableName => 'Aikataulun nimi';

  @override
  String get totalWeeks => 'Viikot yhteensä';

  @override
  String get delete => 'Poista';

  @override
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String get deleteTimetableTitle => 'Poista aikataulu';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Poista \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Ei aikataulua vielä';

  @override
  String get noTimetableMessage =>
      'Luo aikataulu tai tuo yksi JSON-tiedostosta.';

  @override
  String get importTimetable => 'Tuo aikataulu';

  @override
  String get courseName => 'Kurssin nimi';

  @override
  String get location => 'Sijainti';

  @override
  String get dayOfWeek => 'Päivä';

  @override
  String get semesterWeeks => 'Viikot';

  @override
  String get startTime => 'Aloitusaika';

  @override
  String get endTime => 'Loppuaika';

  @override
  String get linkedPeriods => 'Liitetyt jaksot';

  @override
  String get linkedPeriodsUnmatched =>
      'Nykyiselle ajanjaksolle ei ole yhteensopivia jaksoja. Valitse manuaalisesti.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Ajankohta $start-$end';
  }

  @override
  String get teacherName => 'Opettaja';

  @override
  String get credits => 'Krediitit';

  @override
  String get remarks => 'Huomautukset';

  @override
  String get customFields => 'Mukautetut kentät';

  @override
  String get customFieldsHint => 'Yksi rivistä kohti, muoto: avain:arvo';

  @override
  String get selectDayOfWeek => 'Valitse päivä';

  @override
  String get selectSemesterWeeks => 'Valitse viikot';

  @override
  String get selectAll => 'Valitse kaikki';

  @override
  String get clear => 'Tyhjennä';

  @override
  String get confirm => 'Vahvista';

  @override
  String get selectLinkedPeriods => 'Valitse linkitetyt ajanjaksot';

  @override
  String get addCourseTitle => 'Lisää kurssi';

  @override
  String get editCourseTitle => 'Muokkaa kurssia';

  @override
  String get editCourseTooltip => 'Muokkaa kurssia';

  @override
  String get place => 'Sijainti';

  @override
  String get time => 'Aika';

  @override
  String get notFilled => 'Ei täytetty';

  @override
  String get none => 'Ei mitään';

  @override
  String get conflictCourses => 'ristiriitaisia kursseja';

  @override
  String get locationNotFilled => 'Sijainti ei ole täytetty';

  @override
  String get setAsDisplayed => 'Aseta näytetyksi';

  @override
  String get editThisCourse => 'Muokkaa tätä kurssia';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get noTimetableSettings =>
      'Aikataulua ei ole tällä hetkellä saatavilla asetuksille.';

  @override
  String get semesterStartDate => 'Lukukauden alkamispäivä';

  @override
  String get periodTimeSets => 'Ajankohta asetettu';

  @override
  String get noPeriodTimeAvailable => 'Ei käytettävissä olevaa ajanjaksoa';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count jaksot';
  }

  @override
  String get coursePopupDismissSetting =>
      'Salli ulkopuolinen napautus sulkea kurssin ponnahdusikkuna';

  @override
  String get coursePopupDismissSettingHint =>
      'Tämän sammuttaminen poistaa myös pyyhkäisy alaspäin erottamisen käytöstä.';

  @override
  String get preserveTimetableGaps => 'Säilytä aikataulun aukot';

  @override
  String get preserveTimetableGapsHint =>
      'Kun pois, lounas ja tauko aukot romahtavat, joten myöhemmät luokat siirtyvät ylöspäin.';

  @override
  String get showPastEndedCourses => 'Näytä aiemmin päättyneet kurssit';

  @override
  String get showPastEndedCoursesHint =>
      'Näytä kursseja, jotka ovat jo päättyneet todellisella nykyisellä viikolla vaaleanharmaalla tyylillä.';

  @override
  String get showFutureCourses => 'Näytä tulevia kursseja';

  @override
  String get showFutureCoursesHint =>
      'Näytä kursseja, jotka eivät ole aktiivisia tällä viikolla, mutta näkyvät myöhemmin harmalla tyylillä.';

  @override
  String get timetableDisplaySettings => 'Aikataulun näyttö ja vuorovaikutus';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup-irrottaminen, aukot, harmaat kurssit ja verkkoviivat';

  @override
  String get showTimetableGridLines => 'Näytä aikataulun verkko-rivit';

  @override
  String get showTimetableGridLinesHint =>
      'Hallitse, näkyvätkö aikataulussa vaakasuora- ja pystysuora-verkkovinjat.';

  @override
  String get liveCourseOutlineColor => 'Kurssin luonteen väri';

  @override
  String get liveCourseOutlineColorHint =>
      'Valitse, kohdistuvatko piirrokset nykyiseen/seuraavaan kurssiin vai kaikkiin nykyisellä sivulla näkyviin kursseihin.';

  @override
  String get liveCourseOutlineSettings => 'Kurssin luonnokset';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Määritä, onko ääriviiva käytössä, mihin se kohdistuu, noudattaanko se teemaväriä ja tehokasta ääriviivaria.';

  @override
  String get liveCourseOutlineEnabled => 'Ota käyttöön piirrokset';

  @override
  String get liveCourseOutlineFollowTheme => 'Seuraa teeman väriä';

  @override
  String get liveCourseOutlineTarget => 'Suunnitelmakohde';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Nykyinen/seuraava kurssi';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Kaikki näytetyt kurssit';

  @override
  String get liveCourseOutlineEffectiveColor => 'Tehokas väri';

  @override
  String get liveCourseOutlineCustomColor => 'Mukautettu ääriviiva väri';

  @override
  String get liveCourseOutlineWidth => 'Viivan leveys';

  @override
  String get outlineWidthUnit => 'PX:n';

  @override
  String get language => 'Kieli';

  @override
  String get languagePageDescription =>
      'Valitse yksi kielistä, jotka ovat todella saatavilla sovelluksessa.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'englanninkielinen';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API-vastaus';

  @override
  String get theme => 'Teema';

  @override
  String get themeFollowSystem => 'Seuraa järjestelmää';

  @override
  String get themeLight => 'Valo';

  @override
  String get themeDark => 'Pimeä';

  @override
  String get themeColor => 'Teeman väri';

  @override
  String get themeColorModeSingle => 'Yksi teema väri';

  @override
  String get themeColorModeColorful => 'Värikäs';

  @override
  String get themeColorUiColors => 'Käyttöliittymän värit';

  @override
  String get themeColorCourseColors => 'Kurssin värit';

  @override
  String get themeColorPrimary => 'Ensisijainen';

  @override
  String get themeColorSecondary => 'Sekundaariset';

  @override
  String get themeColorTertiary => 'Tertiaarinen';

  @override
  String get themeColorCourseText => 'Kurssin teksti';

  @override
  String get themeColorCourseTextAuto => 'Automaattinen';

  @override
  String get themeColorCourseTextCustom => 'Mukautettu väri';

  @override
  String get themeColorCourseColorsEmpty =>
      'Kurssin värit luodaan aikataulun tuomisen jälkeen.';

  @override
  String get themeCustomColor => 'Mukautettu väri';

  @override
  String get themeApplyCustomColor => 'Käytä väriä';

  @override
  String get themeApplySettings => 'Soveltaa asetuksia';

  @override
  String get dataImportExport => 'Tuo- ja vientitiedot';

  @override
  String get dataImportExportDesc =>
      'Tuo täydet tiedot tai yksittäiset aikataulut tai vie nykyiset/kaikki aikataulut.';

  @override
  String get openSourceLicenses => 'Avoimen lähdekoodin lisenssit';

  @override
  String get openSourceLicensesDesc =>
      'Katso Flutterin riippuvuuksien ja mukana olevien sovelluskuvakkeiden lisenssit.';

  @override
  String get checkForUpdates => 'Tarkista päivitykset';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Jo uusimmassa versiossa ($version)';
  }

  @override
  String get currentVersionLabel => 'Nykyinen versio';

  @override
  String get newVersionAvailable => 'Päivitys saatavilla';

  @override
  String get latestVersionLabel => 'Viimeisin versio';

  @override
  String get updateContentLabel => 'Päivitä yksityiskohdat';

  @override
  String get officialWebsite => 'Virallinen verkkosivusto';

  @override
  String get googlePlay => 'Google Playn';

  @override
  String get cloudDrive => 'Pilviasema';

  @override
  String get ignoreThisVersion => 'Jätä tämä versio huomiotta';

  @override
  String get openUpdatesFailed => 'Päivityslinkkiä ei voi avata';

  @override
  String get updateCheckFailedTitle => 'Päivitystarkastus epäonnistui';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'GitHub-varasto';

  @override
  String get openGithubFailed => 'GitHub-arkiston linkkiä ei voi avata';

  @override
  String get selectPeriodTimeSet => 'Valitse ajanjaksoa';

  @override
  String get newItem => 'Uusi';

  @override
  String get editPeriodTimeSet => 'Muokkaa jakson aikaasetetta';

  @override
  String get importTimetableFiles => 'Tuo aikataulu';

  @override
  String get importTimetableFilesDesc =>
      'Tukee yhtä tai useampaa aikataulutiedostoa.';

  @override
  String get importTimetableText => 'Tuo aikataulu tekstistä';

  @override
  String get importTimetableTextDesc =>
      'Liitä aikataulun JSON-sisältö ja tuo se.';

  @override
  String get shareTimetableFiles => 'Jaa aikataulutiedostoja';

  @override
  String get shareTimetableFilesDesc =>
      'Valitse ensin yksi tai useampi aikataulu.';

  @override
  String get saveTimetableFiles => 'Tallenna aikataulutiedostot';

  @override
  String get saveTimetableFilesDesc =>
      'Valitse ensin yksi tai useampi aikataulu.';

  @override
  String get exportTimetableText => 'Vie aikataulu tekstinä';

  @override
  String get exportTimetableTextDesc =>
      'Valitse yksi tai useampi aikataulu ja kopioi sitten JSON-sisältö.';

  @override
  String get jsonContent => 'JSON-sisältö';

  @override
  String get pasteJsonContentHint => 'Liitä JSON-sisältö tuodaan.';

  @override
  String get jsonContentEmpty => 'Liitä ensin JSON-sisältö.';

  @override
  String get copyText => 'Kopioi';

  @override
  String get copiedToClipboard => 'Kopioi leikepöydälle';

  @override
  String get share => 'Jaa';

  @override
  String get selectTimetablesToExport => 'Valitse aikataulut vientiin';

  @override
  String get selectTimetablesToImport => 'Valitse aikataulut tuoda';

  @override
  String timetableCourseCount(int count) {
    return '$count kursseja';
  }

  @override
  String get importAction => 'Tuo';

  @override
  String get importTimetableDialogTitle => 'Tuo aikataulu';

  @override
  String get chooseImportMethod => 'Valitse, miten tuodaan.';

  @override
  String get importAsNewTimetable => 'Tuo uutena aikatauluna';

  @override
  String get replaceCurrentTimetable => 'Korvaa nykyinen aikataulu';

  @override
  String get importPeriodTimeSetDialogTitle => 'Tuontijakson aikaasetteet';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Tämä tiedosto sisältää sidottuja ajanjaksoja. Haluatko tuoda ja yhdistää ne?';

  @override
  String get importBundledPeriodTimeSets => 'Tuo ja liitä';

  @override
  String get discardBundledPeriodTimeSets => 'Hävittää sitoutuneet sarjat';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Ei ole olemassa olemassa olevaa jaksoaikaasetetta, joten niputettuja jaksoaikaasetteita ei voida hylätä.';

  @override
  String savedToPath(Object path) {
    return 'Tallennettu $path';
  }

  @override
  String get saveCancelled => 'Tallenna peruutettu';

  @override
  String get fileSaveRestrictedTitle => 'Tiedoston tallennus rajoitettu';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Järjestelmä ei voinut tallentaa tiedostoa. Voit kokeilla uudelleen tai käyttää jakamista sen sijaan.';

  @override
  String get retrySave => 'Yritä tallentaa uudelleen';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Ota tiedostojen käyttö käyttöön järjestelmäasetuksissa, palaa sitten ja yritä viedä uudelleen.';

  @override
  String get openSettings => 'Avaa asetukset';

  @override
  String get browserDownloadRestrictedTitle => 'Selaimen lataus rajoitettu';

  @override
  String get browserDownloadRestrictedMessage =>
      'Tämä selain ei tue suoraa tallennusta paikalliseen tiedostoon. Tarkista selaimen latausoikeudet tai käytä tiedostojen jakamista sen sijaan.';

  @override
  String get switchToShare => 'Käytä jakamista sen sijaan';

  @override
  String get fileSaveFailedTitle => 'Tiedoston tallennus epäonnistui';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Nykyiseen polkuun ei voi kirjoittaa. Kohdekansio saattaa olla suojattu, tiedosto saattaa olla käytössä tai polku saattaa olla kirjoittamaton.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Järjestelmä ei voinut tallentaa tiedostoa. Voit yrittää uudelleen, tarkistaa järjestelmän asetukset tai käyttää tiedostojen jakamista sen sijaan.';

  @override
  String get retryLater => 'Yritä uudelleen myöhemmin';

  @override
  String get exportSwitchedToShare =>
      'Vaihdettu tiedostojen jakamiseen vientiä varten';

  @override
  String get saveFailedRetry =>
      'Tallennus epäonnistui. Yritä uudelleen myöhemmin.';

  @override
  String get importFailedCheckContent =>
      'Tuo epäonnistui. Tarkista tiedoston sisältö.';

  @override
  String get noImportableTimetables =>
      'Tuotusta tiedostosta ei löytynyt käytettäviä aikatauluja.';

  @override
  String importedTimetablesCount(int count) {
    return 'Tuotut $count aikataulut';
  }

  @override
  String get periodTimesTitle => 'Ajankohdat';

  @override
  String get importExport => 'Tuonti ja vienti';

  @override
  String get importPeriodTemplate => 'Tuontikauden malli';

  @override
  String get importPeriodTemplateText => 'Tuo ajanjaksomalli tekstistä';

  @override
  String get sharePeriodTemplate => 'Osakeaikauden malli';

  @override
  String get saveTemplateToFile => 'Tallenna malli tiedostoon';

  @override
  String get exportPeriodTemplateText => 'Vie jakson malli tekstinä';

  @override
  String get deletePeriodTimeSet => 'Poista ajanjaksoa';

  @override
  String get periodTimeSetName => 'Ajankohta asetettu nimi';

  @override
  String get addOnePeriod => 'Lisää jakso';

  @override
  String periodNumberLabel(int index) {
    return 'Ajankohta $index';
  }

  @override
  String get deleteThisPeriod => 'Poista tämä jakso';

  @override
  String durationMinutes(int minutes) {
    return 'Kesto $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Aikaisesta aukosta $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'Loppuajan on oltava myöhemmin kuin alkamisaika';

  @override
  String get periodOverlapPrevious => 'Tämä jakso ylittää edellisen';

  @override
  String get periodTimesSaved => 'Säästetyt ajanjaksot';

  @override
  String get deletePeriodTimeSetTitle => 'Poista ajanjaksoa';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Poista \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'nykyisen ajan asettaminen';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Tuotut $count jaksoajat';
  }

  @override
  String get periodFilePermissionTitle => 'Tiedoston käyttöoikeus tarvitaan';

  @override
  String get androidFilePermissionMessage =>
      'Android export edellyttää tiedostojen käyttöoikeutta. Anna lupa jatkaa säästämistä.';

  @override
  String get reauthorize => 'Hyväksy uudelleen';

  @override
  String get permissionPermanentlyDeniedTitle => 'Lupa kielletty pysyvästi';

  @override
  String get permissionSettingsExportMessage =>
      'Ota tiedostojen käyttö käyttöön järjestelmäasetuksissa, palaa sitten ja yritä viedä uudelleen.';

  @override
  String get privacyPolicyTitle => 'Tietosuojakäytäntö';

  @override
  String get privacyPolicyEntryDesc =>
      'Lue, miten sovellus käsittelee paikallista tallennusta, koulun sivuston konfigurointia, tiedostojen tuontia/vientiä, verkkosivujen analysointia ja ulkoisia linkkejä.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Hyväksytty versio: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked on paikalliskäyttöön keskittyvä lukujärjestystyökalu. Lukujärjestykset, ajanjaksot ja koulusivuston asetukset tallennetaan vain laitteellesi tai selaimeesi, eikä niitä koskaan ladata automaattisesti. Sovellus käsittelee tietoja vain, kun käynnistät nimenomaisesti toimintoja kuten tuonnin, verkkosivujen analysoinnin, jakamisen tai ulkoisten linkkien avaamisen. Täydellinen tietosuojakäytäntö on saatavilla verkossa.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Paikallinen varastointi';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Aikataulutiedot ja niihin liittyvät asetukset tallennetaan paikalliseen tiedostoon nimeltä Sked_data.json sovelluksen asiakirjat hakemiston sisällä. Muokkattava koulusivuston kokoonpano tallennetaan erikseen Sked_school_sites.jsoniin. Mukautetut aikataulun analysoijan asetukset, mukaan lukien kaikki mukautetut Base URL:t, API-avaimet ja valittu malli, tallennetaan myös paikallisesti samoihin sovelluksen tietoihin eikä niitä suojaa järjestelmän tunnistustietojen holvi. Kun sitä käytetään selaimessa, samat tiedot tallennetaan selaimen tallennukseen. Sovellus ei lataa näitä paikallisia tietoja automaattisesti kehittäjän hallitsemaan palvelimeen.';

  @override
  String get privacyPolicyImportExportTitle => 'Tuonti ja vienti';

  @override
  String get privacyPolicyImportExportBody =>
      'Sovellus lukee tai kirjoittaa aikataulun JSON-tiedostoja, koulun sivuston JSON-tiedostoja ja ajanjaksomallitiedostoja vain, kun valitset nimenomaisesti tiedoston tai aloitat vientitoimen. Näiden tiedostojen tuominen on paikallista, ellet valitse myös verkkosivujen analysointia. Mukautetun malliluettelon hakeminen on myös nimenomainen verkkotoiminta ja se ottaa yhteyttä vain määrittämääsi mukautettuun päätepisteeseen.';

  @override
  String get privacyPolicySharingTitle => 'Jaaminen';

  @override
  String get privacyPolicySharingBody =>
      'Kun käytät nimenomaisesti jakamista, sovellus siirtää viedyn tiedoston järjestelmän jakamiseen tai valitsemallesi kohde-sovellukselle. Tiedoston käsittelytapa riippuu valitsemastasi kohde-sovelluksesta tai palvelusta.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Ulkoiset linkit';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Kun avaat ulkoisia linkkejä, kuten GitHub-arkistoa, sovellus siirtää toiminnan selaimeesi tai muulle ulkoiselle sovellukselle. Tietojen käsittelyä tämän kohdan jälkeen hallitsee avaamasi kolmas osapuoli.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Mitä sovellus ei kerää';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Sovellus ei vaadi Sked-tiliä eikä salli analyysiä, mainontunnisteita tai pilvivarmuuskopiointia. Se ei myöskään tarjoa erityistä kenttää koulutilien salasanojen keräämiseen. Jos kirjaudut koulun verkkosivustoon sovelluksen sisällä, tämä vuorovaikutus tapahtuu avaamallasi koulusivulla.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Verkkosivujen analysointi';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Kun käytät koulun verkkosivujen tuontia tai liittämistä HTML-tekstiä analysointiin, sovellus pakottaa ensin sisällön paikallisesti ja lähettää sitten toimitetun sivun sisällön, valinnaisen sivun otsikon ja URL-osoitteen, nykyisen sovelluksen kielen ja analysointipyynnön sisällön valittuun analysointipäätepisteeseen. Jos käytät virallista analysoijaa, pyyntö menee sovelluksen määritettyyn viralliseen takaosaan. Jos käytät mukautetun OpenAI-yhteensopivan analysoinnin, sama sisältö lähetetään suoraan määrittämällesi kolmannen osapuolen päätepisteelle, ja malliluettelon hakeminen pyytää myös samaa päätepisteetä. Mukautettu päätepiste voi lähettää pyynnön muille tekoälypalveluille kyseisen palveluntarjoajan oman suunnittelun mukaisesti. Käytetty virallinen backend rajoittaa tällä hetkellä jokaista lähetettyä hyötykuormitusta 300 KB:een, käyttää sen määritettyä aikataulua ja sallii enintään 5 analysointipyyntöä IP:tä kohti päivässä.';

  @override
  String get privacyPolicyUpdatesTitle => 'Käytännön päivitykset';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Nykyinen tietosuojakäytännön versio on $version. Jos myöhempi versio muuttaa tietojen käsittelytapaa, sovellus saattaa pyytää sinua lukemaan ja hyväksymään päivitetyn käytännön uudelleen.';
  }

  @override
  String get privacyGateTitle =>
      'Hyväksy tietosuojakäytäntö ennen sovelluksen käyttöä';

  @override
  String get privacyGateSummaryStorage =>
      'Aikataulut, ajanjaksot ja koulun sivuston konfiguraatio tallennetaan vain paikallisesti eikä niitä ladata automaattisesti kehittäjän palvelimelle.';

  @override
  String get privacyGateSummaryImportExport =>
      'Tuo, vienti ja jakaminen tapahtuu vain, kun käynnistät ne nimenomaisesti; verkkosivujen analysointi lähettää vain toimittamasi pakkautetun sisällön määritettyyn analysointipäätepisteeseen, ja voit tarkistaa analysoidun aikataulun ennen tallennusta.';

  @override
  String get privacyGateSummaryUpdates =>
      'Jos myöhempi versio muuttaa tietojen käsittelyä, sovellus saattaa pyytää sinua tarkistamaan päivitetyn tietosuojakäytännön uudelleen.';

  @override
  String get schoolWebImportEntry => 'Tuo koulun verkkosivulta';

  @override
  String get schoolWebImportEntryDesc =>
      'Tuo nykyinen aikataulun sivu koulun sivustosta.';

  @override
  String get schoolSitesManageEntry => 'Hallitse koulun sivustoja';

  @override
  String get schoolSitesManageEntryDesc =>
      'Lisää, muokkaa ja poista koulun kirjautumisURL-osoitteita JSON-tuonnin ja -viennin avulla.';

  @override
  String get schoolSitesPageTitle => 'Koulun sivuston hallinta';

  @override
  String get schoolSitesImportJson => 'Tuo koulun JSON';

  @override
  String get schoolSitesShareJson => 'Jaa koulun JSON';

  @override
  String get schoolSitesSaveJson => 'Tallenna koulun JSON';

  @override
  String get schoolSitesSaved => 'Koulun sivustot tallennettu';

  @override
  String get schoolSitesImported => 'Koulun sivustot tuodaan';

  @override
  String get schoolSitesEmpty => 'Ei koulun sivuston määritystä vielä.';

  @override
  String get schoolSitesNameLabel => 'Koulun nimi';

  @override
  String get schoolSitesLoginUrlLabel => 'Kirjautumisen URL';

  @override
  String get schoolSitesAdd => 'Lisää koulu';

  @override
  String get schoolSitesEdit => 'Muokkaa koulua';

  @override
  String get schoolSitesDeleteTitle => 'Poista koulu';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Poista \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Täytä ensin koulun nimi ja kirjautumisosoite.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Tuo liittämällä aikataulun sivun sisältö';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Liitä lähdekoodi tai raaka-sivun sisältö, joka sisältää aikataulutietoja manuaalisesti.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Aikataulun analysointi sivun sisällöstä';

  @override
  String get schoolHtmlImportUrlLabel => 'Lähde-URL (valinnainen)';

  @override
  String get schoolHtmlImportTitleLabel => 'Sivun otsikko (valinnainen)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Sivun sisältö';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Liitä lähdekoodi tai raaka-sivun sisältö, joka sisältää aikataulutietoja täällä.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Kaikki aikataulutietoja sisältävä sisältö voidaan analysoida ja tuoda, ei vain HTML.';

  @override
  String get schoolHtmlImportCompress => 'Pakkaa sisältöä';

  @override
  String get schoolHtmlImportCompressed => 'Sisältö pakattu';

  @override
  String get schoolHtmlImportCompressFirst => 'Paina ensin sisältö.';

  @override
  String get schoolHtmlImportSubmit => 'Analyysi ja tuonti';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsing voi kestää jonkin aikaa. Odottakaa.';

  @override
  String get schoolHtmlImportEmpty => 'Liitä ensin HTML-sivu.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Takaisin verkkosivulle';

  @override
  String get schoolWebImportPageTitle => 'Koulun verkkosivujen tuonti';

  @override
  String get schoolWebImportPreview => 'Tuo esikatselu';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count kursseja';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count jaksot';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Sivun otsikko';

  @override
  String get schoolWebImportParserUsed => 'Parseri';

  @override
  String get schoolWebImportWarnings => 'Tuo muistiinpanot';

  @override
  String get schoolWebImportOpenPageHint =>
      'Kirjaudu koulun sivustolle sovelluksessa ja siirry sitten aikataulun sivulle manuaalisesti.';

  @override
  String get schoolWebImportConfigMissing =>
      'Web import backend API ei ole vielä määritetty.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Tämä alusta ei vielä tue upotettua verkkokirjautumista. Käytä alustaa, jossa on WebView-tuki.';

  @override
  String get schoolWebImportSelectSchool => 'Valitse koulu';

  @override
  String get schoolWebImportNoSchools =>
      'Koulun konfiguraatiota ei ole käytettävissä. Tarkista ensin school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Koulun asetuksen lataaminen epäonnistui. Tarkista JSON-tiedostomuoto.';

  @override
  String get schoolWebImportImportCurrentPage => 'Tuo nykyinen sivu';

  @override
  String get schoolWebImportGoBack => 'Edellinen sivu';

  @override
  String get schoolWebImportLoadingPage => 'Sivu ladataan…';

  @override
  String get schoolWebImportParsing => 'Nykyisen sivun analysointi...';

  @override
  String get schoolWebImportLoadFailed =>
      'Sivun lataus epäonnistui. Virkistä tai yritä uudelleen myöhemmin.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Sivun lataaminen on päättynyt. Virkistä ja yritä uudelleen.';

  @override
  String get schoolWebImportEmptyPage =>
      'Nykyinen sivun sisältö on tyhjä eikä sitä voi tuoda vielä.';

  @override
  String get schoolWebImportSuccess => 'Web aikataulu tuotu';

  @override
  String get schoolImportParserSettingsTitle =>
      'Aikataulun analysoijan asetukset';

  @override
  String get schoolImportParserSettingsDesc =>
      'Valitse virallinen analysoija tai mukautettu OpenAI-yhteensopiva päätepiste.';

  @override
  String get schoolImportParserSourceTitle => 'Parserin lähde';

  @override
  String get schoolImportParserSourceOfficial => 'Virallinen analysoija';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Käytä sovelluksen määrittämää sisäänrakennettua virallista analysointipalvelua.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Virallinen analysoija käyttää sovelluksen määritettyä analysointi-taustaa ja pitää nykyisen tuontivirran muuttumattomana.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Custom OpenAI-yhteensopiva';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Lähetä sivun sisältö suoraan omaan OpenAI-yhteensopivaan päätepisteeseen.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Mukautettu OpenAI-yhteensopiva analysoija';

  @override
  String get schoolImportParserCustomPromptTitle => 'Mukautettu pyyntö';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Muokkaa sisäänrakennettua analysointipyyntöä täällä. Muutokset vaikuttavat vain mukautettuun OpenAI-yhteensopivaan analysoijaan.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Sisäänrakennettu pyyntö ladataan täällä oletusarvoisesti. Tyhjennä se pudota takaisin sisäänrakennettuun versioon.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Palauta oletuspyyntö';

  @override
  String get schoolImportParserBaseUrl => 'Perus-URL';

  @override
  String get schoolImportParserApiKey => 'API-avain';

  @override
  String get schoolImportParserModel => 'malli';

  @override
  String get schoolImportParserFetchModels => 'Hae malliluettelo';

  @override
  String get schoolImportParserFetchingModels => 'Haen malleja. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Loppupisteeseen ei palautettu malleja.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Haetut $count mallit';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Mukautettu API-avain tallennetaan sovelluksen paikallisiin asetuksiin yksinkertaisena tekstinä nykyisessä toteutuksessa. Käytä sitä vain laitteessa tai selaimiympäristössä, johon luotat.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Mukautettu analysoinnin konfigurointi on epätäydellinen. Täytä ensin perus-URL, API-avain ja malli.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Virallinen';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parseri: Mukautettu ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Katso täysi tietosuojakäytäntö';

  @override
  String get privacyAgreeAndContinue => 'Suostu ja jatka';

  @override
  String get privacyDecline => 'Vältä';

  @override
  String get privacyDeclineWebHint =>
      'Tämä selainympäristö ei salli sovelluksen sulkea sivua puolestasi. Jos et ole samaa mieltä, sulje tämä välilehti tai ikkuna itse.';

  @override
  String get defaultPeriodTimeSetName => 'Oletusajat';

  @override
  String get periodTimeSetFallbackName => 'Ajankohdat';

  @override
  String get untitledTimetableName => 'Nimettömä aikataulu';

  @override
  String get newTimetableName => 'Uusi aikataulu';

  @override
  String get newPeriodTimeSetName => 'Uusi aikakausi asetettu';

  @override
  String get emptyTimetableName => 'Tyhjä aikataulu';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name jaksot';
  }

  @override
  String get importFileTypeMismatchMessage => 'Tuo tiedostotyyppi ei vastaa.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Tätä tuontitiedoston versiota ei vielä tueta.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Tuontitiedostossa ei löytynyt ajanjaksoja.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Valitse ainakin yksi aikataulu.';

  @override
  String get noExportableTimetableMessage => 'Viennille ei ole aikataulua.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Nykyisen aikataulun korvaaminen tukee vain yhden aikataulun valintaa.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Nykyistä aikataulua ei ole korvattavana.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Tätä ajanjaksoa käyttää edelleen $count aikataulu. Aseta ne uudelleen ennen poistamista.';
  }

  @override
  String get weekdayMonday => 'Maanantai';

  @override
  String get weekdayTuesday => 'tiistaina';

  @override
  String get weekdayWednesday => 'Keskiviikko';

  @override
  String get weekdayThursday => 'Torstaina';

  @override
  String get weekdayFriday => 'perjantaina';

  @override
  String get weekdaySaturday => 'Lauantai';

  @override
  String get weekdaySunday => 'Sunnuntai';

  @override
  String get weekdayShortMonday => 'maanantaina';

  @override
  String get weekdayShortTuesday => 'tiistai';

  @override
  String get weekdayShortWednesday => 'Keskiviikko';

  @override
  String get weekdayShortThursday => 'torstaina';

  @override
  String get weekdayShortFriday => 'perjantai';

  @override
  String get weekdayShortSaturday => 'Lauantaina';

  @override
  String get weekdayShortSunday => 'Aurinko';

  @override
  String get monthJanuary => 'tammikuuta';

  @override
  String get monthFebruary => 'helmikuu';

  @override
  String get monthMarch => 'maaliskuu';

  @override
  String get monthApril => 'huhtikuuta';

  @override
  String get monthMay => 'toukokuu';

  @override
  String get monthJune => 'kesäkuuta';

  @override
  String get monthJuly => 'heinäkuuta';

  @override
  String get monthAugust => 'elokuuta';

  @override
  String get monthSeptember => 'syyskuu';

  @override
  String get monthOctober => 'lokakuuta';

  @override
  String get monthNovember => 'marraskuuta';

  @override
  String get monthDecember => 'joulukuu';

  @override
  String get semesterWeeksWholeTerm => 'Koko lukukausi';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Viikot $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Viikot $value';
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
