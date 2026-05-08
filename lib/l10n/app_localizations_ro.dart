// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Colegul de clasă';

  @override
  String weekLabel(int week) {
    return 'Săptămână $week';
  }

  @override
  String get addCourse => 'Adăugați curs';

  @override
  String get settings => 'Setări';

  @override
  String get multiTimetableSwitch => 'Comută programele';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Orarul curent · $weeks săptămâni';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Atingeți pentru a comuta · $weeks săptămâni';
  }

  @override
  String get editTimetable => 'Editați orarul';

  @override
  String get createTimetable => 'Orar nou';

  @override
  String get jumpToWeek => 'Salt la săptămână';

  @override
  String get timetable => 'Orarul';

  @override
  String get timetableName => 'Numele orarului';

  @override
  String get totalWeeks => 'Total săptămâni';

  @override
  String get delete => 'Șterge';

  @override
  String get cancel => 'Anulează';

  @override
  String get save => 'Salvează';

  @override
  String get deleteTimetableTitle => 'Ştergerea orarului';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Ştergeţi \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Încă nu există orar';

  @override
  String get noTimetableMessage =>
      'Creați un orar sau importați unul dintr-un fișier JSON.';

  @override
  String get importTimetable => 'Import orar';

  @override
  String get courseName => 'Numele cursului';

  @override
  String get location => 'Locație';

  @override
  String get dayOfWeek => 'Ziua';

  @override
  String get semesterWeeks => 'Săptămâni';

  @override
  String get startTime => 'Ora de începere';

  @override
  String get endTime => 'Ora de sfârşit';

  @override
  String get linkedPeriods => 'Perioadele legate';

  @override
  String get linkedPeriodsUnmatched =>
      'Nu se potrivesc perioade pentru ora curentă. Atingeți pentru a alege manual.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Perioada $start-$end';
  }

  @override
  String get teacherName => 'Profesor';

  @override
  String get credits => 'Credite';

  @override
  String get remarks => 'Observații';

  @override
  String get customFields => 'Câmpuri personalizate';

  @override
  String get customFieldsHint => 'Unul pe linie, format: cheie:valoare';

  @override
  String get selectDayOfWeek => 'Alegeți ziua';

  @override
  String get selectSemesterWeeks => 'Alegeți săptămâni';

  @override
  String get selectAll => 'Selectați toate';

  @override
  String get clear => 'Curge';

  @override
  String get confirm => 'Confirmă';

  @override
  String get selectLinkedPeriods => 'Alegeți perioadele legate';

  @override
  String get addCourseTitle => 'Adăugați curs';

  @override
  String get editCourseTitle => 'Editați cursul';

  @override
  String get editCourseTooltip => 'Editați cursul';

  @override
  String get place => 'Locație';

  @override
  String get time => 'Timpul';

  @override
  String get notFilled => 'Nu este umplut';

  @override
  String get none => 'Niciun';

  @override
  String get conflictCourses => 'Cursuri în conflict';

  @override
  String get locationNotFilled => 'Locația nu este umplută';

  @override
  String get setAsDisplayed => 'Setați ca afișat';

  @override
  String get editThisCourse => 'Editați acest curs';

  @override
  String get settingsTitle => 'Setări';

  @override
  String get noTimetableSettings =>
      'În prezent nu este disponibil niciun orar pentru setări.';

  @override
  String get semesterStartDate => 'Data începerii semestrului';

  @override
  String get periodTimeSets => 'Perioada de timp stabilită';

  @override
  String get noPeriodTimeAvailable => 'Nici o perioadă de timp disponibilă';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count perioade';
  }

  @override
  String get coursePopupDismissSetting =>
      'Permiteți atingerea din afară pentru a închide pop-up-ul cursului';

  @override
  String get coursePopupDismissSettingHint =>
      'Oprirea acestui lucru dezactivează, de asemenea, concedierea cu glisarea în jos.';

  @override
  String get preserveTimetableGaps => 'Păstrați lacunele programului';

  @override
  String get preserveTimetableGapsHint =>
      'Când sunt libere, prânzul și pauza se prăbușesc, astfel încât clasele ulterioare se mută în sus.';

  @override
  String get showPastEndedCourses => 'Afișează cursurile încheiate în trecut';

  @override
  String get showPastEndedCoursesHint =>
      'Afișați cursurile care au terminat deja săptămâna actuală reală cu un stil gri deschis.';

  @override
  String get showFutureCourses => 'Afișați cursurile viitoare';

  @override
  String get showFutureCoursesHint =>
      'Afișați cursuri care nu sunt active în această săptămână, dar vor apărea în săptămânile ulterioare cu un stil gri.';

  @override
  String get timetableDisplaySettings => 'Afișarea orarului și interacțiunea';

  @override
  String get timetableDisplaySettingsDesc =>
      'Eliminare pop-up, lacune, cursuri gri și linii de rețea';

  @override
  String get showTimetableGridLines => 'Afișează liniile grilei de orar';

  @override
  String get showTimetableGridLinesHint =>
      'Controlați dacă liniile de rețea orizontale și verticale sunt vizibile în orar.';

  @override
  String get liveCourseOutlineColor => 'Culoarea conturului cursului';

  @override
  String get liveCourseOutlineColorHint =>
      'Alegeți dacă conturile vizează cursul curent / următor sau toate cursurile afișate pe pagina curentă.';

  @override
  String get liveCourseOutlineSettings => 'Descriere curs';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Configurați dacă conturul este activat, ce vizează, dacă urmează culoarea temei și culoarea efectivă a conturului.';

  @override
  String get liveCourseOutlineEnabled => 'Activează contorul';

  @override
  String get liveCourseOutlineFollowTheme => 'Urmăriți culoarea temei';

  @override
  String get liveCourseOutlineTarget => 'Obiectivul general';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Cursul curent/următor';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Toate cursurile afișate';

  @override
  String get liveCourseOutlineEffectiveColor => 'Culoare eficientă';

  @override
  String get liveCourseOutlineCustomColor => 'Culoare contour personalizată';

  @override
  String get liveCourseOutlineWidth => 'Lățimea conturului';

  @override
  String get outlineWidthUnit => 'pe px';

  @override
  String get language => 'Limbă';

  @override
  String get languagePageDescription =>
      'Alegeți una dintre limbile care sunt cu adevărat disponibile în aplicație.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'engleză';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/classmate';

  @override
  String get apiResponseTitle => 'Răspunsul API';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Urmăriți sistemul';

  @override
  String get themeLight => 'Lumină';

  @override
  String get themeDark => 'Întunecat';

  @override
  String get themeColor => 'Culoarea temei';

  @override
  String get themeColorModeSingle => 'Culoare temă unică';

  @override
  String get themeColorModeColorful => 'Colorate';

  @override
  String get themeColorUiColors => 'Culori UI';

  @override
  String get themeColorCourseColors => 'Culorile cursului';

  @override
  String get themeColorPrimary => 'Primară';

  @override
  String get themeColorSecondary => 'secundară';

  @override
  String get themeColorTertiary => 'Terțiar';

  @override
  String get themeColorCourseText => 'Textul cursului';

  @override
  String get themeColorCourseTextAuto => 'Auto';

  @override
  String get themeColorCourseTextCustom => 'Culoare personalizată';

  @override
  String get themeColorCourseColorsEmpty =>
      'Culorile cursului vor fi generate după importarea unui orar.';

  @override
  String get themeCustomColor => 'Culoare personalizată';

  @override
  String get themeApplyCustomColor => 'Aplică culoare';

  @override
  String get themeApplySettings => 'Aplică setările';

  @override
  String get dataImportExport => 'Import și export de date';

  @override
  String get dataImportExportDesc =>
      'Importați date complete sau orare unice sau exportați orarele curente/toate.';

  @override
  String get openSourceLicenses => 'Licențe open-source';

  @override
  String get openSourceLicensesDesc =>
      'Vizualizați licențele pentru dependențele Flutter și activele de pictogramă a aplicației.';

  @override
  String get checkForUpdates => 'Verificați pentru actualizări';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Site-ul oficial / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Deja pe cea mai recentă versiune ($version)';
  }

  @override
  String get currentVersionLabel => 'Versiunea curentă';

  @override
  String get newVersionAvailable => 'Actualizare disponibilă';

  @override
  String get latestVersionLabel => 'Ultima versiune';

  @override
  String get updateContentLabel => 'Detalii de actualizare';

  @override
  String get officialWebsite => 'Site-ul oficial';

  @override
  String get googlePlay => 'pe Google Play';

  @override
  String get cloudDrive => 'Drive în cloud';

  @override
  String get ignoreThisVersion => 'Ignoraţi această versiune';

  @override
  String get openUpdatesFailed => 'Imposibil de deschis link-ul de actualizare';

  @override
  String get updateCheckFailedTitle => 'Verificarea actualizării a eșuat';

  @override
  String get updateCheckFailedMessage =>
      'Imposibil de obţinut informaţii de actualizare valide din orice sursă de actualizare. Puteți folosi link-urile de mai jos pentru a actualiza manual.';

  @override
  String get githubRepository => 'Repozitoriul GitHub';

  @override
  String get openGithubFailed =>
      'Imposibil de deschis link-ul de depozit GitHub';

  @override
  String get selectPeriodTimeSet => 'Alegeți intervalul de timp';

  @override
  String get newItem => 'Nou';

  @override
  String get editPeriodTimeSet => 'Editați intervalul de timp';

  @override
  String get importTimetableFiles => 'Import orar';

  @override
  String get importTimetableFilesDesc =>
      'Suporta unul sau mai multe fișiere de orar.';

  @override
  String get importTimetableText => 'Importarea orarului din text';

  @override
  String get importTimetableTextDesc =>
      'Lipiți conținutul JSON al programului și importați-l.';

  @override
  String get shareTimetableFiles => 'Partajați fișiere de orar';

  @override
  String get shareTimetableFilesDesc =>
      'Alegeți mai întâi unul sau mai multe programe.';

  @override
  String get saveTimetableFiles => 'Salvați fișierele de orar';

  @override
  String get saveTimetableFilesDesc =>
      'Alegeți mai întâi unul sau mai multe programe.';

  @override
  String get exportTimetableText => 'Exportarea orarului ca text';

  @override
  String get exportTimetableTextDesc =>
      'Alegeți unul sau mai multe programe, apoi copiați conținutul JSON.';

  @override
  String get jsonContent => 'Conținut JSON';

  @override
  String get pasteJsonContentHint => 'Lipiți conținutul JSON pentru a importa.';

  @override
  String get jsonContentEmpty => 'Lipiți mai întâi conținutul JSON.';

  @override
  String get copyText => 'Copiați';

  @override
  String get copiedToClipboard => 'Copiat în clipboard';

  @override
  String get share => 'Partajați';

  @override
  String get selectTimetablesToExport => 'Alegeți programele de export';

  @override
  String get selectTimetablesToImport => 'Alegeți programele de import';

  @override
  String timetableCourseCount(int count) {
    return '$count cursuri';
  }

  @override
  String get importAction => 'Import';

  @override
  String get importTimetableDialogTitle => 'Import orar';

  @override
  String get chooseImportMethod => 'Alegeți cum să importați.';

  @override
  String get importAsNewTimetable => 'Import ca calendar nou';

  @override
  String get replaceCurrentTimetable => 'Înlocuiește orarul curent';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Seturi de timp pentru perioada de import';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Acest fișier conține seturi de timp de perioadă. Vrei să le importi și să le asociezi?';

  @override
  String get importBundledPeriodTimeSets => 'Import și asociere';

  @override
  String get discardBundledPeriodTimeSets => 'Aruncă seturile în pachet';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Nu este disponibil niciun set de timp de perioadă existent, astfel încât seturile de timp de perioadă combinate nu pot fi aruncate.';

  @override
  String savedToPath(Object path) {
    return 'Salvat în $path';
  }

  @override
  String get saveCancelled => 'Salvare anulată';

  @override
  String get fileSaveRestrictedTitle => 'Salvarea fișierelor restricționată';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Sistemul nu a putut salva fișierul. Puteți încerca din nou sau utilizați partajarea în schimb.';

  @override
  String get retrySave => 'Încercați din nou să salvați';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Activați accesul la fișiere în setările sistemului, apoi întoarceți-vă și încercați din nou să exportați.';

  @override
  String get openSettings => 'Deschide setările';

  @override
  String get browserDownloadRestrictedTitle =>
      'Descărcarea browserului este restricționată';

  @override
  String get browserDownloadRestrictedMessage =>
      'Acest browser nu suportă salvarea directă într-un fișier local. Verificați permisiunile de descărcare ale browserului sau utilizați partajarea fișierelor în schimb.';

  @override
  String get switchToShare => 'Utilizați partajarea în loc';

  @override
  String get fileSaveFailedTitle => 'Salvarea fișierului a eșuat';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Imposibil de scris la calea curentă. Dosarul țintă poate fi protejat, fișierul poate fi în uz sau calea poate fi nescrită.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Sistemul nu a putut salva fișierul. Puteți încerca din nou, verifica setările sistemului sau utilizați partajarea fișierelor în schimb.';

  @override
  String get retryLater => 'Încearcă din nou mai târziu';

  @override
  String get exportSwitchedToShare =>
      'Comutat la partajarea fișierelor pentru export';

  @override
  String get saveFailedRetry =>
      'Salvarea a eșuat. Vă rugăm să încercați din nou mai târziu.';

  @override
  String get importFailedCheckContent =>
      'Importul a eșuat. Vă rugăm să verificați conținutul fișierului.';

  @override
  String get noImportableTimetables =>
      'Nu au fost găsite programe de utilizare în fișierul importat.';

  @override
  String importedTimetablesCount(int count) {
    return 'Importat $count orare';
  }

  @override
  String get periodTimesTitle => 'Perioadele';

  @override
  String get importExport => 'Import și export';

  @override
  String get importPeriodTemplate => 'Şablon de perioadă de import';

  @override
  String get importPeriodTemplateText =>
      'Importarea unui șablon de perioadă din text';

  @override
  String get sharePeriodTemplate => 'Şablon de perioadă de partajare';

  @override
  String get saveTemplateToFile => 'Salvați șablonul în fișier';

  @override
  String get exportPeriodTemplateText =>
      'Exportarea şablonului de perioadă ca text';

  @override
  String get deletePeriodTimeSet => 'Ştergerea intervalului de timp stabilit';

  @override
  String get periodTimeSetName => 'Numele setului de timp pentru perioadă';

  @override
  String get addOnePeriod => 'Adăugați perioadă';

  @override
  String periodNumberLabel(int index) {
    return 'Perioada $index';
  }

  @override
  String get deleteThisPeriod => 'Ștergeți această perioadă';

  @override
  String durationMinutes(int minutes) {
    return 'Durată $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Distanța față de precedentul $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'Ora de sfârșit trebuie să fie mai târziu decât ora de începere';

  @override
  String get periodOverlapPrevious =>
      'Această perioadă se suprapune cu cea precedentă';

  @override
  String get periodTimesSaved => 'Perioadele salvate';

  @override
  String get deletePeriodTimeSetTitle =>
      'Ştergerea intervalului de timp stabilit';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Ştergeţi \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'perioadă curentă de timp stabilit';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Importat $count perioade de timp';
  }

  @override
  String get periodFilePermissionTitle => 'Permisiuni pentru fișiere necesare';

  @override
  String get androidFilePermissionMessage =>
      'Exportul Android necesită permisiunea de acces la fișiere. Acordați permisiunea de a continua să economisiți.';

  @override
  String get reauthorize => 'Autorizează din nou';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Permisiunea refuzată permanent';

  @override
  String get permissionSettingsExportMessage =>
      'Activați accesul la fișiere în setările sistemului, apoi întoarceți-vă și încercați din nou să exportați.';

  @override
  String get privacyPolicyTitle => 'Politica de confidențialitate';

  @override
  String get privacyPolicyEntryDesc =>
      'Aflați cum aplicația gestionează stocarea locală, configurarea site-ului școlii, importul/exportul de fișiere, analizarea paginilor web și linkurile externe.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Versiunea acceptată: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Classmate este un instrument de orar care prioritizează stocarea locală. Orarele, seturile de perioade și configurația site-ului școlii sunt stocate numai pe dispozitivul dvs. sau în browser și nu sunt niciodată încărcate automat. Aplicația procesează datele numai atunci când declanșați explicit acțiuni precum importul, analizarea paginilor web, partajarea sau deschiderea linkurilor externe. Politica de confidențialitate completă este disponibilă online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Depozitare locală';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Datele de orar și setările conexe sunt stocate într-un fișier local numit classmate_data.json în directorul documentelor aplicației. Configurația editabilă a site-ului școlii este stocată separat în classmate_school_sites.json. Setările parserului de orar personalizate, inclusiv orice URL de bază personalizat, cheia API și modelul selectat, sunt, de asemenea, stocate local în aceleași date ale aplicației și nu sunt protejate de un seif de acreditare a sistemului. Când sunt utilizate într-un browser, aceleași tipuri de date sunt stocate în stocarea browserului. Aplicația nu încărcă automat aceste date locale pe un server controlat de dezvoltator.';

  @override
  String get privacyPolicyImportExportTitle => 'Import și export';

  @override
  String get privacyPolicyImportExportBody =>
      'Aplicația citește sau scrie fișiere JSON de orar, fișiere JSON de site-ul școlii și fișiere de șablon de perioadă numai atunci când alegeți în mod explicit un fișier sau începeți o acțiune de export. Importarea acestor fișiere este o operație locală, cu excepția cazului în care alegeți și analizarea paginilor web. Obținerea unei liste de modele personalizate este, de asemenea, o acțiune de rețea explicită și contactează doar punctul final personalizat pe care l-ați configurat.';

  @override
  String get privacyPolicySharingTitle => 'Partajare';

  @override
  String get privacyPolicySharingBody =>
      'Când utilizați în mod explicit partajarea, aplicația trece fișierul exportat la foaia de partajare a sistemului sau la aplicația țintă pe care o alegeți. Modul în care fișierul este manipulat ulterior depinde de aplicația sau serviciul țintă selectat.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Legături externe';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Când deschideți link-uri externe, cum ar fi depozitul GitHub, aplicația transmite acțiunea browserului sau unei alte aplicații externe. Procesarea datelor după acest punct este guvernată de terța parte pe care o deschideți.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Ce nu colectează aplicația';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Aplicația nu necesită un cont Classmate și nu permite analize, identificatori publicitari sau backup în cloud. De asemenea, nu oferă un câmp dedicat colectării parolelor contului școlii. Dacă vă conectați la un site web al școlii în interiorul aplicației, această interacțiune are loc pe pagina școlii pe care ați deschis-o.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Analizarea paginilor web';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Când utilizați importarea sau lipirea HTML a paginilor web ale școlii pentru analizare, aplicația comprimă mai întâi conținutul local, apoi trimite conținutul paginii trimise, titlul și adresa URL a paginii opționale, limba curentă a aplicației și conținutul promptului de analizare la punctul final de analizare selectat. Dacă utilizați analizatorul oficial, cererea merge la backend-ul oficial configurat al aplicației. Dacă activați un analizator compatibil cu OpenAI personalizat, același conținut este trimis direct la endpoint-ul terț pe care l-ați configurat, iar preluarea listei de modele solicită, de asemenea, același endpoint. Un endpoint personalizat poate transmite cererea către alte servicii AI în conformitate cu propriul design al furnizorului respectiv. Backend-ul oficial implementat limitează în prezent fiecare sarcină utilă trimisă la 300KB, utilizează timeout-ul său configurat și permite cel mult 5 solicitări de analizare pe IP pe zi.';

  @override
  String get privacyPolicyUpdatesTitle => 'Actualizări ale politicii';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Versiunea actuală a politicii de confidențialitate este $version. Dacă o versiune ulterioară modifică modul în care sunt manipulate datele, aplicația vă poate cere să citiți și să acceptați din nou politica actualizată.';
  }

  @override
  String get privacyGateTitle =>
      'Vă rugăm să acceptați politica de confidențialitate înainte de a utiliza aplicația';

  @override
  String get privacyGateSummaryStorage =>
      'Orarele, seturile de perioade și configurația școlii-site sunt stocate doar local și nu sunt încărcate automat pe un server de dezvoltator.';

  @override
  String get privacyGateSummaryImportExport =>
      'Importul, exportul și partajarea se întâmplă numai atunci când le porniți în mod explicit; analizarea paginilor web trimite doar conținutul comprimat pe care îl trimiteți la punctul final de analizare configurat și puteți revizui programul analizat înainte de a salva.';

  @override
  String get privacyGateSummaryUpdates =>
      'Dacă o versiune ulterioară modifică modul în care sunt manipulate datele, aplicația vă poate cere să revizuiți politica de confidențialitate actualizată din nou.';

  @override
  String get schoolWebImportEntry => 'Import de pe pagina web a școlii';

  @override
  String get schoolWebImportEntryDesc =>
      'Importați pagina de orar curent de pe site-ul școlii.';

  @override
  String get schoolSitesManageEntry => 'Gestionați site-urile școlii';

  @override
  String get schoolSitesManageEntryDesc =>
      'Adăugați, editați și ștergeți URL-urile de conectare la școală, cu import și export JSON.';

  @override
  String get schoolSitesPageTitle => 'Managementul site-ului școlii';

  @override
  String get schoolSitesImportJson => 'Importarea școlii JSON';

  @override
  String get schoolSitesShareJson => 'Partajați școala JSON';

  @override
  String get schoolSitesSaveJson => 'Salvați școala JSON';

  @override
  String get schoolSitesSaved => 'Site-uri școlare salvate';

  @override
  String get schoolSitesImported => 'Site-uri școlare importate';

  @override
  String get schoolSitesEmpty =>
      'Încă nu există configurare a site-ului școlii.';

  @override
  String get schoolSitesNameLabel => 'Numele școlii';

  @override
  String get schoolSitesLoginUrlLabel => 'URL-ul de conectare';

  @override
  String get schoolSitesAdd => 'Adăugați școală';

  @override
  String get schoolSitesEdit => 'Editați școala';

  @override
  String get schoolSitesDeleteTitle => 'Ştergerea şcolii';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Ştergeţi \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Completați mai întâi numele școlii și URL-ul de autentificare.';

  @override
  String get schoolSitesJsonFileName => 'classmate_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Import prin lipirea conținutului paginii de orar';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Lipiți manual codul sursă sau conținutul paginii brute care conține informații despre orar.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analiza programului din conținutul paginii';

  @override
  String get schoolHtmlImportUrlLabel => 'URL sursă (opțional)';

  @override
  String get schoolHtmlImportTitleLabel => 'Titlul paginii (opțional)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Conținutul paginii';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Lipiți codul sursă sau conținutul paginii brute care conține informații despre orar aici.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Orice conținut care conține informații despre orar poate fi analizat și importat, nu doar HTML.';

  @override
  String get schoolHtmlImportCompress => 'Comprimați conținutul';

  @override
  String get schoolHtmlImportCompressed => 'Conținut comprimat';

  @override
  String get schoolHtmlImportCompressFirst =>
      'Comprimați mai întâi conținutul.';

  @override
  String get schoolHtmlImportSubmit => 'Analiza și import';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Analiza poate dura ceva timp. Vă rog aşteptaţi.';

  @override
  String get schoolHtmlImportEmpty => 'Lipiți mai întâi pagina HTML.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Înapoi la pagina web';

  @override
  String get schoolWebImportPageTitle => 'Importul paginilor web ale școlii';

  @override
  String get schoolWebImportPreview => 'Import previzualizare';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count cursuri';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count perioade';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Titlul paginii';

  @override
  String get schoolWebImportParserUsed => 'Analizator';

  @override
  String get schoolWebImportWarnings => 'Import de note';

  @override
  String get schoolWebImportOpenPageHint =>
      'Conectați-vă la site-ul școlii în aplicație, apoi navigați manual la pagina de orar.';

  @override
  String get schoolWebImportConfigMissing =>
      'API-ul de import web nu este încă configurat.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Această platformă nu suportă încă autentificarea web încorporată. Vă rugăm să utilizați o platformă cu suport WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Alegeți școala';

  @override
  String get schoolWebImportNoSchools =>
      'Nu este disponibilă configurația școlii. Verificați mai întâi school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'A eșuat încărcarea configurației școlii. Verificați formatul de fișier JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importează pagina curentă';

  @override
  String get schoolWebImportGoBack => 'Pagina anterioară';

  @override
  String get schoolWebImportLoadingPage => 'Se încărcă pagina…';

  @override
  String get schoolWebImportParsing => 'Se analizează pagina curentă...';

  @override
  String get schoolWebImportLoadFailed =>
      'Încărcarea paginii a eșuat. Vă rugăm să vă reîmprospătați sau să încercați din nou mai târziu.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Încărcarea paginii a expirat. Vă rugăm să vă reîmprospătați și să încercați din nou.';

  @override
  String get schoolWebImportEmptyPage =>
      'Conținutul paginii curente este gol și nu poate fi încă importat.';

  @override
  String get schoolWebImportSuccess => 'Orarul web importat';

  @override
  String get schoolImportParserSettingsTitle =>
      'Setările analizatorului de orar';

  @override
  String get schoolImportParserSettingsDesc =>
      'Alegeți analizatorul oficial sau un endpoint compatibil cu OpenAI personalizat.';

  @override
  String get schoolImportParserSourceTitle => 'Sursa analizatorului';

  @override
  String get schoolImportParserSourceOfficial => 'Analizator oficial';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Utilizați serviciul oficial de analizare încorporat configurat de aplicație.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Analizatorul oficial utilizează backend-ul de analizare configurat al aplicației și păstrează fluxul de import curent neschimbat.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Compatibil cu OpenAI personalizat';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Trimiteți conținutul paginii direct la propriul dvs. endpoint compatibil cu OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Parser compatibil cu OpenAI personalizat';

  @override
  String get schoolImportParserCustomPromptTitle => 'Prompt personalizat';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Editați promptul de analizare încorporat aici. Modificările afectează doar analizatorul compatibil cu OpenAI personalizat.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Promptul încorporat este încărcat aici în mod implicit. Eliminați-l pentru a reveni la versiunea încorporată.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Resetați promptul implicit';

  @override
  String get schoolImportParserBaseUrl => 'URL-ul de bază';

  @override
  String get schoolImportParserApiKey => 'Cheia API';

  @override
  String get schoolImportParserModel => 'Modelul';

  @override
  String get schoolImportParserFetchModels => 'Alege lista modelelor';

  @override
  String get schoolImportParserFetchingModels => 'Aduce modele. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Nu au fost returnate modele de la punctul final.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Modele preluate $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Cheia API personalizată este stocată în setările locale ale aplicației în text simplu în cadrul implementării curente. Utilizați-l numai pe un dispozitiv sau un mediu de browser în care aveți încredere.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Configurarea parserului personalizat este incompletă. Completați mai întâi URL-ul de bază, cheia API și modelul.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Oficial';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Analizator: Personalizat ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Vezi politica completă de confidențialitate';

  @override
  String get privacyAgreeAndContinue => 'Sunt de acord și continuă';

  @override
  String get privacyDecline => 'Declinează';

  @override
  String get privacyDeclineWebHint =>
      'Acest mediu de browser nu permite aplicației să închidă pagina pentru tine. Dacă nu sunteți de acord, închideți singur această fila sau fereastră.';

  @override
  String get defaultPeriodTimeSetName => 'Perioadele implicite';

  @override
  String get periodTimeSetFallbackName => 'Perioadele';

  @override
  String get untitledTimetableName => 'Orar fără titlu';

  @override
  String get newTimetableName => 'Orar nou';

  @override
  String get newPeriodTimeSetName => 'Noua perioadă de timp stabilită';

  @override
  String get emptyTimetableName => 'Orarul gol';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name perioade';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Tipul de fișier de import nu se potrivește.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Această versiune de fișier de import nu este încă suportată.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Nu s-au găsit vremuri de perioadă în fișierul de import.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Vă rugăm să selectați cel puțin un calendar.';

  @override
  String get noExportableTimetableMessage =>
      'Nu există un calendar disponibil pentru export.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Înlocuirea orarului curent suportă doar selectarea unui singur orar.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Nu există un calendar actual de înlocuit.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Această perioadă de timp este încă utilizată de $count orar(e). Realocați-le înainte de a le șterge.';
  }

  @override
  String get weekdayMonday => 'luni';

  @override
  String get weekdayTuesday => 'Marți';

  @override
  String get weekdayWednesday => 'Miercuri';

  @override
  String get weekdayThursday => 'Joi';

  @override
  String get weekdayFriday => 'vineri';

  @override
  String get weekdaySaturday => 'sâmbătă';

  @override
  String get weekdaySunday => 'Duminică';

  @override
  String get weekdayShortMonday => 'luni';

  @override
  String get weekdayShortTuesday => 'Marți';

  @override
  String get weekdayShortWednesday => 'Miercuri';

  @override
  String get weekdayShortThursday => 'joi';

  @override
  String get weekdayShortFriday => 'vineri';

  @override
  String get weekdayShortSaturday => 'sâmbătă';

  @override
  String get weekdayShortSunday => 'Soarele';

  @override
  String get monthJanuary => 'ianuarie';

  @override
  String get monthFebruary => 'februarie';

  @override
  String get monthMarch => 'martie';

  @override
  String get monthApril => 'Aprilie';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'iunie';

  @override
  String get monthJuly => 'iulie';

  @override
  String get monthAugust => 'octombrie';

  @override
  String get monthSeptember => 'Septembrie';

  @override
  String get monthOctober => 'octombrie';

  @override
  String get monthNovember => 'noiembrie';

  @override
  String get monthDecember => 'Decembrie';

  @override
  String get semesterWeeksWholeTerm => 'Toate semestrele';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Săptămâni $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Săptămâni $value';
  }
}
