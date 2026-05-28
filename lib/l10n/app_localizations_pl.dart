// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Kolegowie z klasy';

  @override
  String weekLabel(int week) {
    return 'Tydzień $week';
  }

  @override
  String get addCourse => 'Dodaj kurs';

  @override
  String get settings => 'Ustawienia';

  @override
  String get multiTimetableSwitch => 'Przełącz harmonogramy';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Aktualny rozkład · $weeks tygodnie';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Dotknij, aby przełączyć · $weeks tygodnie';
  }

  @override
  String get editTimetable => 'Edytuj harmonogram';

  @override
  String get createTimetable => 'Nowy harmonogram';

  @override
  String get jumpToWeek => 'Skocz do tygodnia';

  @override
  String get timetable => 'Rozkład pracy';

  @override
  String get timetableName => 'Nazwa rozkładu';

  @override
  String get totalWeeks => 'Całkowita liczba tygodni';

  @override
  String get delete => 'Usuń';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get deleteTimetableTitle => 'Usuń harmonogram';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Usuń \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Jeszcze nie ma harmonogramu';

  @override
  String get noTimetableMessage =>
      'Utwórz harmonogram lub zaimportuj go z pliku JSON.';

  @override
  String get importTimetable => 'Import harmonogramu';

  @override
  String get courseName => 'Nazwa kursu';

  @override
  String get location => 'Lokalizacja';

  @override
  String get dayOfWeek => 'Dzień';

  @override
  String get semesterWeeks => 'Tydzień';

  @override
  String get startTime => 'Czas rozpoczęcia';

  @override
  String get endTime => 'Czas końca';

  @override
  String get linkedPeriods => 'Powiązane okresy';

  @override
  String get linkedPeriodsUnmatched =>
      'Żadnych okresów nie pasuje do bieżącego czasu. Dotknij, aby wybrać ręcznie.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Okres $start-$end';
  }

  @override
  String get teacherName => 'Nauczyciel';

  @override
  String get credits => 'Kredyty';

  @override
  String get remarks => 'Uwagi';

  @override
  String get customFields => 'Pole niestandardowe';

  @override
  String get customFieldsHint => 'Jeden na wiersz, format: klucz:wartość';

  @override
  String get selectDayOfWeek => 'Wybierz dzień';

  @override
  String get selectSemesterWeeks => 'Wybierz tygodnie';

  @override
  String get selectAll => 'Wybierz wszystkie';

  @override
  String get clear => 'Wyczyść';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get selectLinkedPeriods => 'Wybierz powiązane okresy';

  @override
  String get addCourseTitle => 'Dodaj kurs';

  @override
  String get editCourseTitle => 'Edytuj kurs';

  @override
  String get editCourseTooltip => 'Edytuj kurs';

  @override
  String get place => 'Lokalizacja';

  @override
  String get time => 'Czas';

  @override
  String get notFilled => 'Nie wypełnione';

  @override
  String get none => 'Żaden';

  @override
  String get conflictCourses => 'Konfliktne kursy';

  @override
  String get locationNotFilled => 'Lokalizacja nie wypełniona';

  @override
  String get setAsDisplayed => 'Ustaw jak wyświetlane';

  @override
  String get editThisCourse => 'Edytuj ten kurs';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get noTimetableSettings =>
      'Nie ma obecnie dostępnego harmonogramu dla ustawień.';

  @override
  String get semesterStartDate => 'Data rozpoczęcia semestru';

  @override
  String get periodTimeSets => 'Okres ustawienia czasu';

  @override
  String get noPeriodTimeAvailable => 'Brak ustawienia czasu dostępnego okresu';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return ' $name · $count okresy';
  }

  @override
  String get coursePopupDismissSetting =>
      'Pozwól na zewnętrzne dotknięcie do zamknięcia wyskakującego okna kursu';

  @override
  String get coursePopupDismissSettingHint =>
      'Wyłączenie tego wyłącza również zwolnienie przesunięciem w dół.';

  @override
  String get preserveTimetableGaps => 'Zachowanie luk w harmonogramie';

  @override
  String get preserveTimetableGapsHint =>
      'Kiedy nie, lunch i przerwa przerwają się, więc późniejsze klasy poruszają się w górę.';

  @override
  String get showPastEndedCourses => 'Pokaż zakończone kursy';

  @override
  String get showPastEndedCoursesHint =>
      'Pokaż kursy, które już zostały zakończone przez prawdziwy bieżący tydzień w jaśniejszym szarym stylu.';

  @override
  String get showFutureCourses => 'Pokaż przyszłe kursy';

  @override
  String get showFutureCoursesHint =>
      'Pokaż kursy, które nie są aktywne w tym tygodniu, ale pojawią się w kolejnych tygodniach w szarym stylu.';

  @override
  String get timetableDisplaySettings =>
      'Wyświetlanie harmonogramu i interakcja';

  @override
  String get timetableDisplaySettingsDesc =>
      'Wyskokowe zwolnienie, luki, szare kursy i linie siatki';

  @override
  String get showTimetableGridLines => 'Pokaż linie siatki rozkładu';

  @override
  String get showTimetableGridLinesHint =>
      'Kontrola, czy poziome i pionowe linie siatki są widoczne w harmonogramie.';

  @override
  String get liveCourseOutlineColor => 'Kolor konturu kursu';

  @override
  String get liveCourseOutlineColorHint =>
      'Wybierz, czy kontury są skierowane do bieżącego/następnego kursu lub wszystkich wyświetlanych kursów na bieżącej stronie.';

  @override
  String get liveCourseOutlineSettings => 'Okres kursu';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Konfiguruj, czy kontur jest włączony, na co jest ukierunkowany, czy podąża za kolorem motywu i efektywnym kolorem konturu.';

  @override
  String get liveCourseOutlineEnabled => 'Włącz kontur';

  @override
  String get liveCourseOutlineFollowTheme => 'Śledź kolor tematu';

  @override
  String get liveCourseOutlineTarget => 'Cel nakreślony';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Bieżący/następny kurs';

  @override
  String get liveCourseOutlineTargetAllDisplayed =>
      'Wszystkie wyświetlane kursy';

  @override
  String get liveCourseOutlineEffectiveColor => 'Efektywny kolor';

  @override
  String get liveCourseOutlineCustomColor => 'Niestandardowy kolor konturu';

  @override
  String get liveCourseOutlineWidth => 'Szerokość konturu';

  @override
  String get outlineWidthUnit => 'Px';

  @override
  String get language => 'Język';

  @override
  String get languagePageDescription =>
      'Wybierz jeden z języków, który jest naprawdę dostępny w aplikacji.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'angielski';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Odpowiedź API';

  @override
  String get theme => 'Temat';

  @override
  String get themeFollowSystem => 'Śledź system';

  @override
  String get themeLight => 'Światło';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeColor => 'Kolor tematu';

  @override
  String get themeColorModeSingle => 'Kolor pojedynczego motywu';

  @override
  String get themeColorModeColorful => 'Kolorowe';

  @override
  String get themeColorUiColors => 'Kolory interfejsu użytkownika';

  @override
  String get themeColorCourseColors => 'Kolory kursu';

  @override
  String get themeColorPrimary => 'Podstawowe';

  @override
  String get themeColorSecondary => 'Sekundarny';

  @override
  String get themeColorTertiary => 'Terciarne';

  @override
  String get themeColorCourseText => 'Tekst kursu';

  @override
  String get themeColorCourseTextAuto => 'Automatyczny';

  @override
  String get themeColorCourseTextCustom => 'Kolor niestandardowy';

  @override
  String get themeColorCourseColorsEmpty =>
      'Kolory kursu zostaną wygenerowane po importowaniu harmonogramu.';

  @override
  String get themeCustomColor => 'Kolor niestandardowy';

  @override
  String get themeApplyCustomColor => 'Zastosuj kolor';

  @override
  String get themeApplySettings => 'Zastosuj ustawienia';

  @override
  String get dataImportExport => 'Import i eksport danych';

  @override
  String get dataImportExportDesc =>
      'Importuj pełne dane lub pojedyncze harmonogramy lub eksportuj bieżące/wszystkie harmonogramy.';

  @override
  String get openSourceLicenses => 'Licencje open source';

  @override
  String get openSourceLicensesDesc =>
      'Zobacz licencje dla zależności Flutter i dołączonych zasobów ikon aplikacji.';

  @override
  String get checkForUpdates => 'Sprawdź aktualizacje';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Już w najnowszej wersji ($version)';
  }

  @override
  String get currentVersionLabel => 'Aktualna wersja';

  @override
  String get newVersionAvailable => 'Dostępna aktualizacja';

  @override
  String get latestVersionLabel => 'Najnowsza wersja';

  @override
  String get updateContentLabel => 'Szczegóły aktualizacji';

  @override
  String get officialWebsite => 'Oficjalna strona internetowa';

  @override
  String get googlePlay => 'w Google Play';

  @override
  String get cloudDrive => 'Napęd w chmurze';

  @override
  String get ignoreThisVersion => 'Ignoruj tę wersję';

  @override
  String get openUpdatesFailed => 'Nie można otworzyć linku do aktualizacji';

  @override
  String get updateCheckFailedTitle => 'Nie udało się sprawdzić aktualizacji';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'Repozytorium GitHub';

  @override
  String get openGithubFailed =>
      'Nie można otworzyć linku do repozytorium GitHub';

  @override
  String get selectPeriodTimeSet => 'Wybierz ustawienie czasu okresu';

  @override
  String get newItem => 'Nowy';

  @override
  String get editPeriodTimeSet => 'Edytuj ustawienie czasu okresu';

  @override
  String get importTimetableFiles => 'Import harmonogramu';

  @override
  String get importTimetableFilesDesc =>
      'Obsługuje jeden lub więcej plików harmonogramu.';

  @override
  String get importTimetableText => 'Importowanie harmonogramu z tekstu';

  @override
  String get importTimetableTextDesc =>
      'Wklej zawartość harmonogramu JSON i zaimportuj ją.';

  @override
  String get shareTimetableFiles => 'Udostępnij pliki harmonogramu';

  @override
  String get shareTimetableFilesDesc =>
      'Najpierw wybierz jeden lub więcej harmonogramów.';

  @override
  String get saveTimetableFiles => 'Zapisz pliki harmonogramu';

  @override
  String get saveTimetableFilesDesc =>
      'Najpierw wybierz jeden lub więcej harmonogramów.';

  @override
  String get exportTimetableText => 'Eksportowanie harmonogramu jako tekstu';

  @override
  String get exportTimetableTextDesc =>
      'Wybierz jeden lub więcej harmonogramów, a następnie skopiuj zawartość JSON.';

  @override
  String get jsonContent => 'Zawartość JSON';

  @override
  String get pasteJsonContentHint => 'Wklej zawartość JSON do importu.';

  @override
  String get jsonContentEmpty => 'Najpierw wklej zawartość JSON.';

  @override
  String get copyText => 'Kopiowanie';

  @override
  String get copiedToClipboard => 'Skopiowanie do schowka';

  @override
  String get share => 'Udostępnij';

  @override
  String get selectTimetablesToExport => 'Wybierz harmonogram do eksportu';

  @override
  String get selectTimetablesToImport => 'Wybierz harmonogram do importu';

  @override
  String timetableCourseCount(int count) {
    return '$count kursy';
  }

  @override
  String get importAction => 'Importowanie';

  @override
  String get importTimetableDialogTitle => 'Import harmonogramu';

  @override
  String get chooseImportMethod => 'Wybierz sposób importu.';

  @override
  String get importAsNewTimetable => 'Import jako nowy harmonogram';

  @override
  String get replaceCurrentTimetable => 'Zamień bieżący harmonogram';

  @override
  String get importPeriodTimeSetDialogTitle => 'Import zestawów czasu okresu';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Ten plik zawiera zestawy czasu okresu. Chcesz je importować i powiązać?';

  @override
  String get importBundledPeriodTimeSets => 'Import i powiązanie';

  @override
  String get discardBundledPeriodTimeSets => 'Odrzucić zestawy w pakiecie';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Istniejący zestaw czasu okresu nie jest dostępny, dlatego nie można odrzucić zestawów czasu okresu w pakiecie.';

  @override
  String savedToPath(Object path) {
    return 'Zapisane do $path';
  }

  @override
  String get saveCancelled => 'Zapisz anulowane';

  @override
  String get fileSaveRestrictedTitle => 'Zapisywanie plików ograniczone';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'System nie mógł zapisać pliku. Możesz spróbować ponownie lub zamiast tego użyć udostępniania.';

  @override
  String get retrySave => 'Spróbuj ponownie zapisać';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Włącz dostęp do plików w ustawieniach systemu, a następnie wróć i spróbuj ponownie eksportować.';

  @override
  String get openSettings => 'Otwórz ustawienia';

  @override
  String get browserDownloadRestrictedTitle =>
      'Pobieranie przeglądarki ograniczone';

  @override
  String get browserDownloadRestrictedMessage =>
      'Ta przeglądarka nie obsługuje bezpośredniego zapisywania do pliku lokalnego. Sprawdź uprawnienia do pobierania przeglądarki lub zamiast tego użyj udostępniania plików.';

  @override
  String get switchToShare => 'Zamiast tego użyj udostępniania';

  @override
  String get fileSaveFailedTitle => 'Nie udało się zapisać pliku';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Nie można zapisać do bieżącej ścieżki. Folder docelowy może być chroniony, plik może być w użyciu lub ścieżka może nie być zapisywalna.';

  @override
  String get fileSaveFailedGenericMessage =>
      'System nie mógł zapisać pliku. Możesz spróbować ponownie, sprawdzić ustawienia systemu lub zamiast tego użyć udostępniania plików.';

  @override
  String get retryLater => 'Spróbuj ponownie później';

  @override
  String get exportSwitchedToShare =>
      'Przełączono na udostępnianie plików do eksportu';

  @override
  String get saveFailedRetry =>
      'Nie udało się zapisać. Proszę spróbować ponownie później.';

  @override
  String get importFailedCheckContent =>
      'Nie udało się importować. Proszę sprawdzić zawartość pliku.';

  @override
  String get noImportableTimetables =>
      'W zaimportowanym pliku nie znaleziono żadnych użytecznych harmonogramów.';

  @override
  String importedTimetablesCount(int count) {
    return 'Importowane harmonogramy $count';
  }

  @override
  String get periodTimesTitle => 'Czasy okresu';

  @override
  String get importExport => 'Import i eksport';

  @override
  String get importPeriodTemplate => 'Szablon okresu importu';

  @override
  String get importPeriodTemplateText =>
      'Importowanie szablonu okresu z tekstu';

  @override
  String get sharePeriodTemplate => 'Szablon okresu udziału';

  @override
  String get saveTemplateToFile => 'Zapisz szablon do pliku';

  @override
  String get exportPeriodTemplateText => 'Eksport szablonu okresu jako tekstu';

  @override
  String get deletePeriodTimeSet => 'Usuń ustawiony czas okresu';

  @override
  String get periodTimeSetName => 'Nazwa zestawu czasu okresu';

  @override
  String get addOnePeriod => 'Dodaj okres';

  @override
  String periodNumberLabel(int index) {
    return 'Okres $index';
  }

  @override
  String get deleteThisPeriod => 'Usuń ten okres';

  @override
  String durationMinutes(int minutes) {
    return 'Czas trwania $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Przerwa od poprzedniego $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'Czas końca musi być później niż czas rozpoczęcia';

  @override
  String get periodOverlapPrevious => 'Ten okres pokrywa się z poprzednim';

  @override
  String get periodTimesSaved => 'Czasy okresowe zapisane';

  @override
  String get deletePeriodTimeSetTitle => 'Usuń ustawiony czas okresu';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Usuń \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'ustawienie czasu bieżącego okresu';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Importowane $count czasy okresu';
  }

  @override
  String get periodFilePermissionTitle => 'Wymagane uprawnienia pliku';

  @override
  String get androidFilePermissionMessage =>
      'Eksport Androida wymaga uprawnień dostępu do plików. Udostępnij pozwolenie na kontynuowanie oszczędzania.';

  @override
  String get reauthorize => 'Autoryzuj ponownie';

  @override
  String get permissionPermanentlyDeniedTitle => 'Pozwolenie trwale odmówione';

  @override
  String get permissionSettingsExportMessage =>
      'Włącz dostęp do plików w ustawieniach systemu, a następnie wróć i spróbuj ponownie eksportować.';

  @override
  String get privacyPolicyTitle => 'Polityka prywatności';

  @override
  String get privacyPolicyEntryDesc =>
      'Dowiedz się, jak aplikacja obsługuje lokalne przechowywanie, konfigurację strony szkolnej, import/eksport plików, analizę stron internetowych i linki zewnętrzne.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Akceptowana wersja: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked to narzędzie do planów lekcji działające lokalnie. Plany lekcji, zestawy okresów i konfiguracja strony szkoły są przechowywane tylko na Twoim urządzeniu lub w przeglądarce i nigdy nie są automatycznie przesyłane. Aplikacja przetwarza dane tylko wtedy, gdy jawnie uruchamiasz działania takie jak import, analiza stron internetowych, udostępnianie lub otwieranie zewnętrznych linków. Pełna polityka prywatności jest dostępna online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lokalne przechowywanie';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Dane harmonogramu i powiązane z nim ustawienia są przechowywane w lokalnym pliku o nazwie Sked_data.json w katalogu dokumentów aplikacji. Edytowalna konfiguracja strony szkolnej jest przechowywana oddzielnie w Sked_school_sites.json. Niestandardowe ustawienia analizera harmonogramu, w tym dowolny niestandardowy adres URL bazowy, klucz API i wybrany model, są również przechowywane lokalnie w tych samych danych aplikacji i nie są chronione przez skrzydło uwierzytelniające systemu. W przypadku używania w przeglądarce te same rodzaje danych są przechowywane w magazynie przeglądarki. Aplikacja nie przesyła tych danych lokalnych automatycznie na serwer kontrolowany przez programistę.';

  @override
  String get privacyPolicyImportExportTitle => 'Import i eksport';

  @override
  String get privacyPolicyImportExportBody =>
      'Aplikacja odczytuje lub pisze pliki JSON harmonogramu, pliki JSON strony szkolnej i pliki szablonu okresu tylko wtedy, gdy wyraźnie wybierzesz plik lub rozpoczniesz akcję eksportu. Importowanie tych plików jest operacją lokalną, chyba że wybierzesz również analizowanie strony internetowej. Pobieranie niestandardowej listy modeli jest również wyraźną akcją sieciową i kontaktuje się tylko z skonfigurowanym przez Ciebie niestandardowym punktem końcowym.';

  @override
  String get privacyPolicySharingTitle => 'Udostępnianie';

  @override
  String get privacyPolicySharingBody =>
      'Kiedy wyraźnie używasz udostępniania, aplikacja przekazuje wyeksportowany plik do arkusza udostępniania systemu lub do wybranej aplikacji docelowej. Jak ten plik jest później obsługiwany zależy od wybranej aplikacji lub usługi docelowej.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Linki zewnętrzne';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Po otwarciu linków zewnętrznych, takich jak repozytorium GitHub, aplikacja przekazuje akcję przeglądarce lub innej aplikacji zewnętrznej. Przetwarzanie danych po tym momencie jest regulowane przez stronę trzecią, którą otwierasz.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Co aplikacja nie zbiera';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Aplikacja nie wymaga konta Sked i nie umożliwia analizy, identyfikatorów reklamowych ani tworzenia kopii zapasowych w chmurze. Nie zapewnia również dedykowanego pola do zbierania haseł do kont szkolnych. Jeśli zalogujesz się do strony internetowej szkoły w aplikacji, ta interakcja odbywa się na stronie szkoły, którą otworzyłeś.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Analiza strony internetowej';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Kiedy używasz importu lub wklejenia HTML do analizy strony internetowej szkoły, aplikacja najpierw komprimuje zawartość lokalnie, a następnie wysyła przesłaną zawartość strony, opcjonalny tytuł strony i adres URL, bieżący język aplikacji oraz zawartość promptu do wybranego punktu końcowego analizy. Jeśli używasz oficjalnego parsera, żądanie trafia do skonfigurowanego oficjalnego backendu aplikacji. Jeśli włączysz niestandardowy analizator kompatybilny z OpenAI, ta sama zawartość zostanie wysłana bezpośrednio do skonfigurowanego przez Ciebie punktu końcowego innej firmy, a pobieranie listy modeli wymaga również tego samego punktu końcowego. Niestandardowy punkt końcowy może przekazywać żądanie do innych usług AI zgodnie z własnym projektem tego dostawcy. Wdrożony oficjalny backend obecnie ogranicza każdy przesłany ładunek użyteczny do 300 KB, wykorzystuje skonfigurowany timeout i umożliwia maksymalnie 5 żądań analizujących na adres IP dziennie.';

  @override
  String get privacyPolicyUpdatesTitle => 'Aktualizacje polityki';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Aktualna wersja polityki prywatności to $version. Jeśli w późniejszej wersji zmieni się sposób przetwarzania danych, aplikacja może poprosić Cię o ponowne przeczytanie i zgodę na zaktualizowaną politykę.';
  }

  @override
  String get privacyGateTitle =>
      'Przed użyciem aplikacji zgadzaj się na politykę prywatności';

  @override
  String get privacyGateSummaryStorage =>
      'Rozkłady, zestawy okresów i konfiguracja szkoły są przechowywane tylko lokalnie i nie są automatycznie przesyłane na serwer programistów.';

  @override
  String get privacyGateSummaryImportExport =>
      'Importowanie, eksportowanie i udostępnianie następują tylko wtedy, gdy wyraźnie je uruchomisz; Analiza stron internetowych wysyła tylko skompresowaną zawartość, którą przesyłasz do skonfigurowanego punktu końcowego analizowania, a przed zapisaniem możesz sprawdzić analizowany harmonogram.';

  @override
  String get privacyGateSummaryUpdates =>
      'Jeśli w późniejszej wersji zmieni się sposób przetwarzania danych, aplikacja może poprosić Cię o ponowne zapoznanie się z zaktualizowaną polityką prywatności.';

  @override
  String get schoolWebImportEntry => 'Import ze strony internetowej szkoły';

  @override
  String get schoolWebImportEntryDesc =>
      'Importuj bieżący harmonogram ze strony szkoły.';

  @override
  String get schoolSitesManageEntry => 'Zarządzanie witrynami szkolnymi';

  @override
  String get schoolSitesManageEntryDesc =>
      'Dodaj, edytuj i usuwaj adresy URL logowania szkoły za pomocą importu i eksportu JSON.';

  @override
  String get schoolSitesPageTitle => 'Zarządzanie miejscem szkolnym';

  @override
  String get schoolSitesImportJson => 'Import szkoły JSON';

  @override
  String get schoolSitesShareJson => 'Udostępnij szkołę JSON';

  @override
  String get schoolSitesSaveJson => 'Zapisz szkołę JSON';

  @override
  String get schoolSitesSaved => 'Strony szkolne zapisane';

  @override
  String get schoolSitesImported => 'Miejsca szkolne importowane';

  @override
  String get schoolSitesEmpty => 'Nie ma jeszcze konfiguracji strony szkolnej.';

  @override
  String get schoolSitesNameLabel => 'Nazwa szkoły';

  @override
  String get schoolSitesLoginUrlLabel => 'URL logowania';

  @override
  String get schoolSitesAdd => 'Dodaj szkołę';

  @override
  String get schoolSitesEdit => 'Edytuj szkołę';

  @override
  String get schoolSitesDeleteTitle => 'Usuń szkołę';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Usuń \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Najpierw wpisz nazwę szkoły i adres URL logowania.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importowanie przez wklejenie zawartości strony harmonogramu';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Wklej ręcznie kod źródłowy lub surową zawartość strony zawierającą informacje o harmonogramie.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analizuj harmonogram z zawartości strony';

  @override
  String get schoolHtmlImportUrlLabel => 'URL źródła (opcjonalne)';

  @override
  String get schoolHtmlImportTitleLabel => 'Tytuł strony (opcjonalnie)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Zawartość strony';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Wklej kod źródłowy lub surową zawartość strony zawierającą informacje o harmonogramie tutaj.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Wszystkie treści zawierające informacje o harmonogramie mogą być analizowane i importowane, a nie tylko HTML.';

  @override
  String get schoolHtmlImportCompress => 'Kompresowanie zawartości';

  @override
  String get schoolHtmlImportCompressed => 'Zawartość skompresowana';

  @override
  String get schoolHtmlImportCompressFirst =>
      'Najpierw skompresować zawartość.';

  @override
  String get schoolHtmlImportSubmit => 'Analizuj i importuj';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Parsing może zająć trochę czasu. Proszę poczekać.';

  @override
  String get schoolHtmlImportEmpty => 'Najpierw wklej stronę HTML.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Powrót do strony internetowej';

  @override
  String get schoolWebImportPageTitle => 'Import strony internetowej szkoły';

  @override
  String get schoolWebImportPreview => 'Importuj podgląd';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count kursy';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return ' $count okresy';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Tytuł strony';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Importuj notatki';

  @override
  String get schoolWebImportOpenPageHint =>
      'Zaloguj się na stronie szkoły w aplikacji, a następnie przejdź ręcznie do strony harmonogramu.';

  @override
  String get schoolWebImportConfigMissing =>
      'Interfejs API importu internetowego nie jest jeszcze skonfigurowany.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Ta platforma jeszcze nie obsługuje wbudowanego logowania internetowego. Proszę użyć platformy z obsługą WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Wybierz szkołę';

  @override
  String get schoolWebImportNoSchools =>
      'Nie ma dostępnej konfiguracji szkoły. Najpierw sprawdź school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Nie udało się załadować konfiguracji szkoły. Sprawdź format pliku JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importuj bieżącą stronę';

  @override
  String get schoolWebImportGoBack => 'Poprzednia strona';

  @override
  String get schoolWebImportLoadingPage => 'Ładowanie strony…';

  @override
  String get schoolWebImportParsing => 'Analizuje bieżącą stronę...';

  @override
  String get schoolWebImportLoadFailed =>
      'Nie udało się załadować strony. Proszę odświeżyć lub spróbować ponownie później.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Czas ładowania strony się skończył. Proszę odświeżyć i spróbować ponownie.';

  @override
  String get schoolWebImportEmptyPage =>
      'Aktualna zawartość strony jest pusta i nie może być jeszcze zaimportowana.';

  @override
  String get schoolWebImportSuccess => 'Importowany harmonogram internetowy';

  @override
  String get schoolImportParserSettingsTitle =>
      'Ustawienia analizera harmonogramu';

  @override
  String get schoolImportParserSettingsDesc =>
      'Wybierz oficjalny parser lub niestandardowy punkt końcowy kompatybilny z OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Źródło parsera';

  @override
  String get schoolImportParserSourceOfficial => 'Oficjalny parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Użyj wbudowanej oficjalnej usługi analizowania skonfigurowanej przez aplikację.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Oficjalny analizer używa skonfigurowanego backend analizowania aplikacji i utrzymuje bieżący przepływ importu niezmieniony.';

  @override
  String get schoolImportParserSourceCustomOpenAi => 'Kompatybilny z OpenAI';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Wyślij zawartość strony bezpośrednio do własnego punktu końcowego kompatybilnego z OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Niestandardowy parser kompatybilny z OpenAI';

  @override
  String get schoolImportParserCustomPromptTitle => 'Niestandardowy prompt';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Edytuj wbudowany prompt parsera tutaj. Zmiany wpływają tylko na niestandardowy parser kompatybilny z OpenAI.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Wbudowany prompt jest domyślnie ładowany tutaj. Wyczyść go, aby wrócić do wbudowanej wersji.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Resetowanie domyślnego promptu';

  @override
  String get schoolImportParserBaseUrl => 'Podstawowy adres URL';

  @override
  String get schoolImportParserApiKey => 'Klucz API';

  @override
  String get schoolImportParserModel => 'model';

  @override
  String get schoolImportParserFetchModels => 'Pobierz listę modeli';

  @override
  String get schoolImportParserFetchingModels => 'Zabieranie modeli. ..';

  @override
  String get schoolImportParserNoModelsFound =>
      'Żadne modele nie zostały zwrócone przez punkt końcowy.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Pobierane modele $count';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Niestandardowy klucz API jest przechowywany w ustawieniach lokalnych aplikacji w tekstie prostym w bieżącej implementacji. Użyj go tylko na urządzeniu lub środowisku przeglądarki, któremu ufasz.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Niestandardowa konfiguracja parsera jest niekompletna. Najpierw wypełnij adres URL bazowy, klucz API i model.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Oficjalny';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: Niestandardowy ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Zobacz pełną politykę prywatności';

  @override
  String get privacyAgreeAndContinue => 'Zgadzam się i kontynuuj';

  @override
  String get privacyDecline => 'Odrzucić';

  @override
  String get privacyDeclineWebHint =>
      'To środowisko przeglądarki nie pozwala aplikacji na zamknięcie strony za Ciebie. Jeśli nie zgadzasz się, zamknij tę zakładkę lub okno sam.';

  @override
  String get defaultPeriodTimeSetName => 'Domyślne okresy';

  @override
  String get periodTimeSetFallbackName => 'Czasy okresu';

  @override
  String get untitledTimetableName => 'Rozkład bez tytułu';

  @override
  String get newTimetableName => 'Nowy harmonogram';

  @override
  String get newPeriodTimeSetName => 'Ustaw czasu nowego okresu';

  @override
  String get emptyTimetableName => 'Pusty harmonogram';

  @override
  String importedPeriodTimeSetName(Object name) {
    return ' $name okresy';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Typ pliku importowanego nie pasuje.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Ta wersja importu pliku nie jest jeszcze obsługiwana.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Nie znaleziono czasów okresowych w pliku importu.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Proszę wybrać co najmniej jeden harmonogram.';

  @override
  String get noExportableTimetableMessage =>
      'Nie ma dostępnego harmonogramu eksportu.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Zastąpienie bieżącego harmonogramu obsługuje tylko wybór jednego harmonogramu.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Nie ma obecnego harmonogramu do zastąpienia.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Ten zestaw czasu okresu jest nadal używany przez harmonogram $count. Przeznacz je przed usunięciem.';
  }

  @override
  String get weekdayMonday => 'Poniedziałek';

  @override
  String get weekdayTuesday => 'Wtorek';

  @override
  String get weekdayWednesday => 'środa';

  @override
  String get weekdayThursday => 'czwartek';

  @override
  String get weekdayFriday => 'Piątek';

  @override
  String get weekdaySaturday => 'sobota';

  @override
  String get weekdaySunday => 'Niedziela';

  @override
  String get weekdayShortMonday => 'poniedziałek';

  @override
  String get weekdayShortTuesday => 'wtorek';

  @override
  String get weekdayShortWednesday => 'Środa';

  @override
  String get weekdayShortThursday => 'Czwartek';

  @override
  String get weekdayShortFriday => 'Piątek';

  @override
  String get weekdayShortSaturday => 'sobota';

  @override
  String get weekdayShortSunday => 'Słońce';

  @override
  String get monthJanuary => 'stycznia';

  @override
  String get monthFebruary => 'luty';

  @override
  String get monthMarch => 'marzec';

  @override
  String get monthApril => 'kwietnia';

  @override
  String get monthMay => 'maj';

  @override
  String get monthJune => 'czerwca';

  @override
  String get monthJuly => 'lipiec';

  @override
  String get monthAugust => 'sierpień';

  @override
  String get monthSeptember => 'wrzesień';

  @override
  String get monthOctober => 'Październik';

  @override
  String get monthNovember => 'Listopad';

  @override
  String get monthDecember => 'grudzień';

  @override
  String get semesterWeeksWholeTerm => 'Cały semestr';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Tydzień $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Tydzień $value';
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
}
