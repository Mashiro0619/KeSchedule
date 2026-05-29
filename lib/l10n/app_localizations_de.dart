// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Woche $week';
  }

  @override
  String get addCourse => 'Kurs hinzufügen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get multiTimetableSwitch => 'Stundenpläne wechseln';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Aktueller Stundenplan · $weeks Wochen';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Tippen zum Wechseln · $weeks Wochen';
  }

  @override
  String get editTimetable => 'Stundenplan bearbeiten';

  @override
  String get createTimetable => 'Neuer Stundenplan';

  @override
  String get jumpToWeek => 'Zu Woche springen';

  @override
  String get timetable => 'Stundenplan';

  @override
  String get timetableName => 'Name des Stundenplans';

  @override
  String get totalWeeks => 'Gesamtwochen';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get deleteTimetableTitle => 'Stundenplan löschen';

  @override
  String deleteTimetableMessage(Object name) {
    return '\"$name\" löschen?';
  }

  @override
  String get noTimetableTitle => 'Noch kein Stundenplan';

  @override
  String get noTimetableMessage =>
      'Erstellen Sie einen Stundenplan oder importieren Sie einen aus einer JSON-Datei.';

  @override
  String get importTimetable => 'Stundenplan importieren';

  @override
  String get courseName => 'Kursname';

  @override
  String get location => 'Ort';

  @override
  String get dayOfWeek => 'Tag';

  @override
  String get semesterWeeks => 'Wochen';

  @override
  String get startTime => 'Startzeit';

  @override
  String get endTime => 'Endzeit';

  @override
  String get linkedPeriods => 'Verknüpfte Stunden';

  @override
  String get linkedPeriodsUnmatched =>
      'Keine Stunden passen zur aktuellen Zeit. Tippen Sie, um manuell auszuwählen.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Stunde $start-$end';
  }

  @override
  String get teacherName => 'Lehrkraft';

  @override
  String get credits => 'Credits';

  @override
  String get remarks => 'Notizen';

  @override
  String get customFields => 'Benutzerdefinierte Felder';

  @override
  String get customFieldsHint => 'Eine pro Zeile, Format: schlüssel:wert';

  @override
  String get selectDayOfWeek => 'Tag auswählen';

  @override
  String get selectSemesterWeeks => 'Wochen auswählen';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get clear => 'Leeren';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get selectLinkedPeriods => 'Verknüpfte Stunden auswählen';

  @override
  String get addCourseTitle => 'Kurs hinzufügen';

  @override
  String get editCourseTitle => 'Kurs bearbeiten';

  @override
  String get editCourseTooltip => 'Kurs bearbeiten';

  @override
  String get place => 'Ort';

  @override
  String get time => 'Zeit';

  @override
  String get notFilled => 'Nicht ausgefüllt';

  @override
  String get none => 'Keine';

  @override
  String get conflictCourses => 'Kurskonflikte';

  @override
  String get locationNotFilled => 'Ort nicht ausgefüllt';

  @override
  String get setAsDisplayed => 'Als angezeigt festlegen';

  @override
  String get editThisCourse => 'Diesen Kurs bearbeiten';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get noTimetableSettings =>
      'Derzeit ist kein Stundenplan für die Einstellungen verfügbar.';

  @override
  String get semesterStartDate => 'Semesterbeginn';

  @override
  String get periodTimeSets => 'Stundenzeiten-Set';

  @override
  String get noPeriodTimeAvailable => 'Kein verfügbares Stundenzeiten-Set';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count Stunden';
  }

  @override
  String get coursePopupDismissSetting =>
      'Tippen außerhalb erlaubt, um das Kurs-Popup zu schließen';

  @override
  String get coursePopupDismissSettingHint =>
      'Wenn dies deaktiviert ist, wird auch das Schließen per Wischen nach unten deaktiviert.';

  @override
  String get preserveTimetableGaps => 'Lücken im Stundenplan beibehalten';

  @override
  String get preserveTimetableGapsHint =>
      'Wenn deaktiviert, werden Mittags- und Pausenlücken eingeklappt, damit spätere Kurse nach oben rücken.';

  @override
  String get showPastEndedCourses => 'Bereits beendete Kurse anzeigen';

  @override
  String get showPastEndedCoursesHint =>
      'Zeigt Kurse, die nach der aktuellen realen Woche bereits beendet sind, in einem helleren Graustil an.';

  @override
  String get showFutureCourses => 'Zukünftige Kurse anzeigen';

  @override
  String get showFutureCoursesHint =>
      'Zeigt Kurse, die diese Woche nicht aktiv sind, aber in späteren Wochen erscheinen, in einem Graustil an.';

  @override
  String get timetableDisplaySettings =>
      'Anzeige und Interaktion des Stundenplans';

  @override
  String get timetableDisplaySettingsDesc =>
      'Popup-Schließen, Lücken, graue Kurse und Gitterlinien';

  @override
  String get showTimetableGridLines => 'Gitterlinien im Stundenplan anzeigen';

  @override
  String get showTimetableGridLinesHint =>
      'Legt fest, ob horizontale und vertikale Gitterlinien im Stundenplan sichtbar sind.';

  @override
  String get liveCourseOutlineColor => 'Konturfarbe des Kurses';

  @override
  String get liveCourseOutlineColorHint =>
      'Wählen Sie, ob Konturen den aktuellen/nächsten Kurs oder alle aktuell angezeigten Kurse hervorheben.';

  @override
  String get liveCourseOutlineSettings => 'Kurskontur';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Legen Sie fest, ob die Kontur aktiviert ist, worauf sie zielt, ob sie der Themenfarbe folgt und welche effektive Konturfarbe verwendet wird.';

  @override
  String get liveCourseOutlineEnabled => 'Kontur aktivieren';

  @override
  String get liveCourseOutlineFollowTheme => 'Themenfarbe folgen';

  @override
  String get liveCourseOutlineTarget => 'Konturziel';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Aktueller/nächster Kurs';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Alle angezeigten Kurse';

  @override
  String get liveCourseOutlineEffectiveColor => 'Effektive Farbe';

  @override
  String get liveCourseOutlineCustomColor => 'Benutzerdefinierte Konturfarbe';

  @override
  String get liveCourseOutlineWidth => 'Konturstärke';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Sprache';

  @override
  String get languagePageDescription =>
      'Wählen Sie eine der Sprachen aus, die in der App tatsächlich verfügbar sind.';

  @override
  String get languageChinese => 'Chinesisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'API-Antwort';

  @override
  String get theme => 'Design';

  @override
  String get themeFollowSystem => 'Systemeinstellung folgen';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeColor => 'Designfarbe';

  @override
  String get themeColorModeSingle => 'Einzelne Designfarbe';

  @override
  String get themeColorModeColorful => 'Farbenfroh';

  @override
  String get themeColorUiColors => 'UI-Farben';

  @override
  String get themeColorCourseColors => 'Kursfarben';

  @override
  String get themeColorPrimary => 'Primär';

  @override
  String get themeColorSecondary => 'Sekundär';

  @override
  String get themeColorTertiary => 'Tertiär';

  @override
  String get themeColorCourseText => 'Kurstext';

  @override
  String get themeColorCourseTextAuto => 'Automatisch';

  @override
  String get themeColorCourseTextCustom => 'Benutzerdefinierte Farbe';

  @override
  String get themeColorCourseColorsEmpty =>
      'Kursfarben werden nach dem Import eines Stundenplans generiert.';

  @override
  String get themeCustomColor => 'Benutzerdefinierte Farbe';

  @override
  String get themeApplyCustomColor => 'Farbe anwenden';

  @override
  String get themeApplySettings => 'Einstellungen anwenden';

  @override
  String get dataImportExport => 'Daten importieren und exportieren';

  @override
  String get dataImportExportDesc =>
      'Importieren Sie alle Daten oder einzelne Stundenpläne oder exportieren Sie den aktuellen/alle Stundenpläne.';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get openSourceLicensesDesc =>
      'Lizenzen für Flutter-Abhängigkeiten und gebündelte App-Icon-Ressourcen anzeigen.';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Sie verwenden bereits die neueste Version ($version)';
  }

  @override
  String get currentVersionLabel => 'Aktuelle Version';

  @override
  String get newVersionAvailable => 'Update verfügbar';

  @override
  String get latestVersionLabel => 'Neueste Version';

  @override
  String get updateContentLabel => 'Update-Details';

  @override
  String get officialWebsite => 'Offizielle Website';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Cloud-Speicher';

  @override
  String get ignoreThisVersion => 'Diese Version ignorieren';

  @override
  String get openUpdatesFailed => 'Update-Link konnte nicht geöffnet werden';

  @override
  String get updateCheckFailedTitle => 'Update-Prüfung fehlgeschlagen';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'GitHub-Repository';

  @override
  String get openGithubFailed =>
      'Der Link zum GitHub-Repository konnte nicht geöffnet werden';

  @override
  String get selectPeriodTimeSet => 'Stundenzeiten-Set auswählen';

  @override
  String get newItem => 'Neu';

  @override
  String get editPeriodTimeSet => 'Stundenzeiten-Set bearbeiten';

  @override
  String get importTimetableFiles => 'Stundenplan importieren';

  @override
  String get importTimetableFilesDesc =>
      'Unterstützt eine oder mehrere Stundenplan-Dateien.';

  @override
  String get importTimetableText => 'Stundenplan aus Text importieren';

  @override
  String get importTimetableTextDesc =>
      'Fügen Sie den JSON-Inhalt des Stundenplans ein und importieren Sie ihn.';

  @override
  String get shareTimetableFiles => 'Stundenplan-Dateien teilen';

  @override
  String get shareTimetableFilesDesc =>
      'Wählen Sie zuerst einen oder mehrere Stundenpläne aus.';

  @override
  String get saveTimetableFiles => 'Stundenplan-Dateien speichern';

  @override
  String get saveTimetableFilesDesc =>
      'Wählen Sie zuerst einen oder mehrere Stundenpläne aus.';

  @override
  String get exportTimetableText => 'Stundenplan als Text exportieren';

  @override
  String get exportTimetableTextDesc =>
      'Wählen Sie einen oder mehrere Stundenpläne und kopieren Sie dann den JSON-Inhalt.';

  @override
  String get jsonContent => 'JSON-Inhalt';

  @override
  String get pasteJsonContentHint =>
      'Fügen Sie den JSON-Inhalt zum Importieren ein.';

  @override
  String get jsonContentEmpty => 'Fügen Sie zuerst den JSON-Inhalt ein.';

  @override
  String get copyText => 'Kopieren';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get share => 'Teilen';

  @override
  String get selectTimetablesToExport =>
      'Zu exportierende Stundenpläne auswählen';

  @override
  String get selectTimetablesToImport =>
      'Zu importierende Stundenpläne auswählen';

  @override
  String timetableCourseCount(int count) {
    return '$count Kurse';
  }

  @override
  String get importAction => 'Importieren';

  @override
  String get importTimetableDialogTitle => 'Stundenplan importieren';

  @override
  String get chooseImportMethod => 'Wählen Sie, wie importiert werden soll.';

  @override
  String get importAsNewTimetable => 'Als neuen Stundenplan importieren';

  @override
  String get replaceCurrentTimetable => 'Aktuellen Stundenplan ersetzen';

  @override
  String get importPeriodTimeSetDialogTitle => 'Stundenzeiten-Sets importieren';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Diese Datei enthält gebündelte Stundenzeiten-Sets. Möchten Sie sie importieren und verknüpfen?';

  @override
  String get importBundledPeriodTimeSets => 'Importieren und verknüpfen';

  @override
  String get discardBundledPeriodTimeSets => 'Gebündelte Sets verwerfen';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Es ist kein vorhandenes Stundenzeiten-Set verfügbar, daher können gebündelte Stundenzeiten-Sets nicht verworfen werden.';

  @override
  String savedToPath(Object path) {
    return 'Gespeichert unter $path';
  }

  @override
  String get saveCancelled => 'Speichern abgebrochen';

  @override
  String get fileSaveRestrictedTitle => 'Dateispeicherung eingeschränkt';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Das System konnte die Datei nicht speichern. Sie können es erneut versuchen oder stattdessen die Teilen-Funktion verwenden.';

  @override
  String get retrySave => 'Speichern erneut versuchen';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Aktivieren Sie den Dateizugriff in den Systemeinstellungen und versuchen Sie den Export dann erneut.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get browserDownloadRestrictedTitle => 'Browser-Download eingeschränkt';

  @override
  String get browserDownloadRestrictedMessage =>
      'Dieser Browser unterstützt kein direktes Speichern in eine lokale Datei. Prüfen Sie die Download-Berechtigungen des Browsers oder verwenden Sie stattdessen Dateifreigabe.';

  @override
  String get switchToShare => 'Stattdessen teilen';

  @override
  String get fileSaveFailedTitle => 'Datei konnte nicht gespeichert werden';

  @override
  String get fileSaveFailedWindowsMessage =>
      'In den aktuellen Pfad kann nicht geschrieben werden. Der Zielordner ist möglicherweise geschützt, die Datei wird verwendet oder der Pfad ist nicht beschreibbar.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Das System konnte die Datei nicht speichern. Sie können es erneut versuchen, die Systemeinstellungen prüfen oder stattdessen Dateifreigabe verwenden.';

  @override
  String get retryLater => 'Später erneut versuchen';

  @override
  String get exportSwitchedToShare =>
      'Für den Export wurde zur Dateifreigabe gewechselt';

  @override
  String get saveFailedRetry =>
      'Speichern fehlgeschlagen. Bitte versuchen Sie es später erneut.';

  @override
  String get importFailedCheckContent =>
      'Import fehlgeschlagen. Bitte prüfen Sie den Dateiinhalt.';

  @override
  String get noImportableTimetables =>
      'In der importierten Datei wurden keine verwendbaren Stundenpläne gefunden.';

  @override
  String importedTimetablesCount(int count) {
    return '$count Stundenpläne importiert';
  }

  @override
  String get periodTimesTitle => 'Stundenzeiten';

  @override
  String get importExport => 'Import und Export';

  @override
  String get importPeriodTemplate => 'Stundenvorlage importieren';

  @override
  String get importPeriodTemplateText => 'Stundenvorlage aus Text importieren';

  @override
  String get sharePeriodTemplate => 'Stundenvorlage teilen';

  @override
  String get saveTemplateToFile => 'Vorlage in Datei speichern';

  @override
  String get exportPeriodTemplateText => 'Stundenvorlage als Text exportieren';

  @override
  String get deletePeriodTimeSet => 'Stundenzeiten-Set löschen';

  @override
  String get periodTimeSetName => 'Name des Stundenzeiten-Sets';

  @override
  String get addOnePeriod => 'Stunde hinzufügen';

  @override
  String periodNumberLabel(int index) {
    return 'Stunde $index';
  }

  @override
  String get deleteThisPeriod => 'Diese Stunde löschen';

  @override
  String durationMinutes(int minutes) {
    return 'Dauer $minutes Min.';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Abstand zur vorherigen $minutes Min.';
  }

  @override
  String get endTimeMustBeLater => 'Die Endzeit muss nach der Startzeit liegen';

  @override
  String get periodOverlapPrevious =>
      'Diese Stunde überschneidet sich mit der vorherigen';

  @override
  String get periodTimesSaved => 'Stundenzeiten gespeichert';

  @override
  String get deletePeriodTimeSetTitle => 'Stundenzeiten-Set löschen';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return '\"$name\" löschen?';
  }

  @override
  String get currentPeriodTimeSet => 'aktuelles Stundenzeiten-Set';

  @override
  String importedPeriodTimesCount(int count) {
    return '$count Stundenzeiten importiert';
  }

  @override
  String get periodFilePermissionTitle => 'Dateiberechtigung erforderlich';

  @override
  String get androidFilePermissionMessage =>
      'Für den Export unter Android ist eine Dateizugriffsberechtigung erforderlich. Erteilen Sie die Berechtigung, um das Speichern fortzusetzen.';

  @override
  String get reauthorize => 'Erneut autorisieren';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Berechtigung dauerhaft verweigert';

  @override
  String get permissionSettingsExportMessage =>
      'Aktivieren Sie den Dateizugriff in den Systemeinstellungen und versuchen Sie den Export dann erneut.';

  @override
  String get privacyPolicyTitle => 'Datenschutzrichtlinie';

  @override
  String get privacyPolicyEntryDesc =>
      'Erfahren Sie, wie die App lokalen Speicher, Schulwebsite-Konfiguration, Dateiimport/-export, Webseitenanalyse und externe Links verarbeitet.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Akzeptierte Version: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked ist ein lokal ausgerichtetes Stundenplan-Werkzeug. Stundenpläne, Stundenzeiten-Sets und Schulwebsite-Konfigurationen werden nur auf Ihrem Gerät oder in Ihrem Browser gespeichert und niemals automatisch hochgeladen. Die App verarbeitet Daten nur, wenn Sie ausdrücklich Aktionen wie Import, Webseitenanalyse, Teilen oder das Öffnen externer Links starten. Die vollständige Datenschutzrichtlinie ist online verfügbar.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Lokaler Speicher';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Stundenplandaten und zugehörige Einstellungen werden in einer lokalen Datei namens Sked_data.json im Dokumentenverzeichnis der App gespeichert. Bearbeitbare Schulwebsite-Konfigurationen werden separat in Sked_school_sites.json gespeichert. Benutzerdefinierte Einstellungen des Stundenplan-Parsers, einschließlich einer benutzerdefinierten Base URL, API key und des ausgewählten Modells, werden ebenfalls lokal in denselben App-Daten gespeichert und sind nicht durch einen System-Anmeldedatenspeicher geschützt. Im Browser werden dieselben Datentypen im Browserspeicher abgelegt. Die App lädt diese lokalen Daten nicht automatisch auf einen vom Entwickler kontrollierten Server hoch.';

  @override
  String get privacyPolicyImportExportTitle => 'Import und Export';

  @override
  String get privacyPolicyImportExportBody =>
      'Die App liest oder schreibt Stundenplan-JSON-Dateien, Schulwebsite-JSON-Dateien und Periodenvorlagen-Dateien nur, wenn Sie ausdrücklich eine Datei auswählen oder einen Export starten. Das Importieren dieser Dateien ist ein lokaler Vorgang, es sei denn, Sie wählen zusätzlich die Webseitenanalyse. Das Abrufen einer benutzerdefinierten Modellliste ist ebenfalls eine ausdrückliche Netzwerkaktion und kontaktiert nur den von Ihnen konfigurierten benutzerdefinierten Endpunkt.';

  @override
  String get privacyPolicySharingTitle => 'Teilen';

  @override
  String get privacyPolicySharingBody =>
      'Wenn Sie ausdrücklich die Teilen-Funktion verwenden, übergibt die App die exportierte Datei an das System-Freigabeblatt oder an die von Ihnen gewählte Ziel-App. Wie diese Datei anschließend verarbeitet wird, hängt von der gewählten Ziel-App oder dem Dienst ab.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Externe Links';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Wenn Sie externe Links wie das GitHub-Repository öffnen, übergibt die App die Aktion an Ihren Browser oder eine andere externe Anwendung. Die weitere Datenverarbeitung unterliegt dann dem jeweiligen Drittanbieter.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Was die App nicht sammelt';

  @override
  String get privacyPolicyNoCollectionBody =>
      'Die App benötigt kein Sked-Konto und aktiviert weder Analysen noch Werbe-IDs oder Cloud-Backups. Außerdem gibt es kein spezielles Feld zum Erfassen von Schulzugangspasswörtern. Wenn Sie sich innerhalb der App auf einer Schulwebsite anmelden, findet diese Interaktion auf der von Ihnen geöffneten Schulseite statt.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Webseitenanalyse';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Wenn Sie den Import von Schulwebseiten verwenden oder HTML zur Analyse einfügen, komprimiert die App den Inhalt zunächst lokal und sendet dann den übermittelten Seiteninhalt, optionalen Seitentitel und URL, die aktuelle App-Sprache und den Prompt-Inhalt des Parsers an den ausgewählten Analyse-Endpunkt. Wenn Sie den offiziellen Parser verwenden, geht die Anfrage an das von der App konfigurierte offizielle Backend. Wenn Sie einen benutzerdefinierten OpenAI-kompatiblen Parser aktivieren, wird derselbe Inhalt direkt an den von Ihnen konfigurierten Drittanbieter-Endpunkt gesendet, und auch das Abrufen der Modellliste ruft denselben Endpunkt auf. Ein benutzerdefinierter Endpunkt kann die Anfrage je nach Architektur des Anbieters an andere KI-Dienste weiterleiten. Das bereitgestellte offizielle Backend begrenzt derzeit jede übermittelte Nutzlast auf 300KB, verwendet das konfigurierte Timeout und erlaubt höchstens 5 Analyseanfragen pro IP und Tag.';

  @override
  String get privacyPolicyUpdatesTitle => 'Richtlinien-Updates';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'Die aktuelle Version der Datenschutzrichtlinie ist $version. Wenn eine spätere Version die Datenverarbeitung ändert, fordert die App Sie möglicherweise auf, die aktualisierte Richtlinie erneut zu lesen und zu akzeptieren.';
  }

  @override
  String get privacyGateTitle =>
      'Bitte stimmen Sie der Datenschutzrichtlinie zu, bevor Sie die App verwenden';

  @override
  String get privacyGateSummaryStorage =>
      'Stundenpläne, Stundenzeiten-Sets und Schulwebsite-Konfigurationen werden nur lokal gespeichert und nicht automatisch auf einen Entwickler-Server hochgeladen.';

  @override
  String get privacyGateSummaryImportExport =>
      'Import, Export und Teilen erfolgen nur, wenn Sie diese ausdrücklich starten; die Webseitenanalyse sendet nur den von Ihnen eingereichten komprimierten Inhalt an den konfigurierten Analyse-Endpunkt, und Sie können den analysierten Stundenplan vor dem Speichern überprüfen.';

  @override
  String get privacyGateSummaryUpdates =>
      'Wenn eine spätere Version die Datenverarbeitung ändert, fordert die App Sie möglicherweise auf, die aktualisierte Datenschutzrichtlinie erneut zu prüfen.';

  @override
  String get schoolWebImportEntry => 'Von Schulwebseite importieren';

  @override
  String get schoolWebImportEntryDesc =>
      'Importieren Sie die aktuelle Stundenplanseite von der Schulwebsite.';

  @override
  String get schoolSitesManageEntry => 'Schulwebsites verwalten';

  @override
  String get schoolSitesManageEntryDesc =>
      'Login-URLs für Schulen hinzufügen, bearbeiten und löschen, mit JSON-Import und -Export.';

  @override
  String get schoolSitesPageTitle => 'Verwaltung der Schulwebsites';

  @override
  String get schoolSitesImportJson => 'Schul-JSON importieren';

  @override
  String get schoolSitesShareJson => 'Schul-JSON teilen';

  @override
  String get schoolSitesSaveJson => 'Schul-JSON speichern';

  @override
  String get schoolSitesSaved => 'Schulwebsites gespeichert';

  @override
  String get schoolSitesImported => 'Schulwebsites importiert';

  @override
  String get schoolSitesEmpty =>
      'Noch keine Schulwebsite-Konfiguration vorhanden.';

  @override
  String get schoolSitesNameLabel => 'Name der Schule';

  @override
  String get schoolSitesLoginUrlLabel => 'Login-URL';

  @override
  String get schoolSitesAdd => 'Schule hinzufügen';

  @override
  String get schoolSitesEdit => 'Schule bearbeiten';

  @override
  String get schoolSitesDeleteTitle => 'Schule löschen';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return '\"$name\" löschen?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Füllen Sie zuerst den Schulnamen und die Login-URL aus.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Import durch Einfügen des Stundenplan-Seiteninhalts';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Fügen Sie manuell den Quellcode oder den Rohinhalt einer Seite mit Stundenplaninformationen ein.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Stundenplan aus Seiteninhalt analysieren';

  @override
  String get schoolHtmlImportUrlLabel => 'Quell-URL (optional)';

  @override
  String get schoolHtmlImportTitleLabel => 'Seitentitel (optional)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Seiteninhalt';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Fügen Sie hier den Quellcode oder den Rohinhalt einer Seite mit Stundenplaninformationen ein.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Jeder Inhalt mit Stundenplaninformationen kann analysiert und importiert werden, nicht nur HTML.';

  @override
  String get schoolHtmlImportCompress => 'Inhalt komprimieren';

  @override
  String get schoolHtmlImportCompressed => 'Inhalt komprimiert';

  @override
  String get schoolHtmlImportCompressFirst =>
      'Komprimieren Sie zuerst den Inhalt.';

  @override
  String get schoolHtmlImportSubmit => 'Analysieren und importieren';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'Die Analyse kann etwas dauern. Bitte warten.';

  @override
  String get schoolHtmlImportEmpty => 'Fügen Sie zuerst das Seiten-HTML ein.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Zurück zur Webseite';

  @override
  String get schoolWebImportPageTitle => 'Import von Schulwebseite';

  @override
  String get schoolWebImportPreview => 'Importvorschau';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count Kurse';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count Stunden';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Seitentitel';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Importhinweise';

  @override
  String get schoolWebImportOpenPageHint =>
      'Melden Sie sich in der App auf der Schulwebsite an und navigieren Sie dann manuell zur Stundenplanseite.';

  @override
  String get schoolWebImportConfigMissing =>
      'Die Backend-API für den Webimport ist noch nicht konfiguriert.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Diese Plattform unterstützt noch keine eingebettete Web-Anmeldung. Bitte verwenden Sie eine Plattform mit WebView-Unterstützung.';

  @override
  String get schoolWebImportSelectSchool => 'Schule auswählen';

  @override
  String get schoolWebImportNoSchools =>
      'Keine Schulkonfiguration verfügbar. Prüfen Sie zuerst school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Schulkonfiguration konnte nicht geladen werden. Prüfen Sie das JSON-Dateiformat.';

  @override
  String get schoolWebImportImportCurrentPage => 'Aktuelle Seite importieren';

  @override
  String get schoolWebImportGoBack => 'Vorherige Seite';

  @override
  String get schoolWebImportLoadingPage => 'Seite wird geladen…';

  @override
  String get schoolWebImportParsing => 'Aktuelle Seite wird analysiert…';

  @override
  String get schoolWebImportLoadFailed =>
      'Seite konnte nicht geladen werden. Bitte aktualisieren Sie die Seite oder versuchen Sie es später erneut.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Zeitüberschreitung beim Laden der Seite. Bitte aktualisieren Sie die Seite und versuchen Sie es erneut.';

  @override
  String get schoolWebImportEmptyPage =>
      'Der aktuelle Seiteninhalt ist leer und kann noch nicht importiert werden.';

  @override
  String get schoolWebImportSuccess => 'Web-Stundenplan importiert';

  @override
  String get schoolImportParserSettingsTitle =>
      'Einstellungen für den Stundenplan-Parser';

  @override
  String get schoolImportParserSettingsDesc =>
      'Wählen Sie den offiziellen Parser oder einen benutzerdefinierten OpenAI-kompatiblen Endpunkt.';

  @override
  String get schoolImportParserSourceTitle => 'Parser-Quelle';

  @override
  String get schoolImportParserSourceOfficial => 'Offizieller Parser';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Verwendet den integrierten offiziellen Analysedienst, der von der App konfiguriert ist.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Der offizielle Parser verwendet das von der App konfigurierte Analyse-Backend und lässt den aktuellen Importablauf unverändert.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Benutzerdefiniert OpenAI-kompatibel';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Senden Sie den Seiteninhalt direkt an Ihren eigenen OpenAI-kompatiblen Endpunkt.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Benutzerdefinierter OpenAI-kompatibler Parser';

  @override
  String get schoolImportParserCustomPromptTitle =>
      'Benutzerdefinierter Prompt';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Bearbeiten Sie hier den integrierten Parser-Prompt. Änderungen betreffen nur den benutzerdefinierten OpenAI-kompatiblen Parser.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Der integrierte Prompt wird hier standardmäßig geladen. Leeren Sie ihn, um auf die integrierte Version zurückzufallen.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Standard-Prompt zurücksetzen';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'Modell';

  @override
  String get schoolImportParserFetchModels => 'Modellliste abrufen';

  @override
  String get schoolImportParserFetchingModels => 'Modelle werden abgerufen...';

  @override
  String get schoolImportParserNoModelsFound =>
      'Der Endpunkt hat keine Modelle zurückgegeben.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '$count Modelle abgerufen';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Die benutzerdefinierte API key wird in der aktuellen Implementierung im Klartext in den lokalen Einstellungen der App gespeichert. Verwenden Sie sie nur auf einem Gerät oder in einer Browserumgebung, der Sie vertrauen.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'Die Konfiguration des benutzerdefinierten Parsers ist unvollständig. Füllen Sie zuerst Base URL, API key und Modell aus.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: Offiziell';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: Benutzerdefiniert ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Vollständige Datenschutzrichtlinie anzeigen';

  @override
  String get privacyAgreeAndContinue => 'Zustimmen und fortfahren';

  @override
  String get privacyDecline => 'Ablehnen';

  @override
  String get privacyDeclineWebHint =>
      'Diese Browserumgebung erlaubt es der App nicht, die Seite für Sie zu schließen. Wenn Sie nicht zustimmen, schließen Sie bitte diesen Tab oder dieses Fenster selbst.';

  @override
  String get defaultPeriodTimeSetName => 'Standardstunden';

  @override
  String get periodTimeSetFallbackName => 'Stundenzeiten';

  @override
  String get untitledTimetableName => 'Unbenannter Stundenplan';

  @override
  String get newTimetableName => 'Neuer Stundenplan';

  @override
  String get newPeriodTimeSetName => 'Neues Stundenzeiten-Set';

  @override
  String get emptyTimetableName => 'Leerer Stundenplan';

  @override
  String importedPeriodTimeSetName(Object name) {
    return '$name-Stunden';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Der Typ der Importdatei stimmt nicht überein.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Diese Version der Importdatei wird noch nicht unterstützt.';

  @override
  String get noPeriodTimesInImportMessage =>
      'In der Importdatei wurden keine Stundenzeiten gefunden.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Bitte wählen Sie mindestens einen Stundenplan aus.';

  @override
  String get noExportableTimetableMessage =>
      'Es ist kein Stundenplan zum Exportieren verfügbar.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Zum Ersetzen des aktuellen Stundenplans kann nur ein einzelner Stundenplan ausgewählt werden.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Es gibt keinen aktuellen Stundenplan zum Ersetzen.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Dieses Stundenzeiten-Set wird noch von $count Stundenplan/Stundenplänen verwendet. Weisen Sie diese vor dem Löschen neu zu.';
  }

  @override
  String get weekdayMonday => 'Montag';

  @override
  String get weekdayTuesday => 'Dienstag';

  @override
  String get weekdayWednesday => 'Mittwoch';

  @override
  String get weekdayThursday => 'Donnerstag';

  @override
  String get weekdayFriday => 'Freitag';

  @override
  String get weekdaySaturday => 'Samstag';

  @override
  String get weekdaySunday => 'Sonntag';

  @override
  String get weekdayShortMonday => 'Mo';

  @override
  String get weekdayShortTuesday => 'Di';

  @override
  String get weekdayShortWednesday => 'Mi';

  @override
  String get weekdayShortThursday => 'Do';

  @override
  String get weekdayShortFriday => 'Fr';

  @override
  String get weekdayShortSaturday => 'Sa';

  @override
  String get weekdayShortSunday => 'So';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'Feb';

  @override
  String get monthMarch => 'Mär';

  @override
  String get monthApril => 'Apr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'Jul';

  @override
  String get monthAugust => 'Aug';

  @override
  String get monthSeptember => 'Sep';

  @override
  String get monthOctober => 'Okt';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Dez';

  @override
  String get semesterWeeksWholeTerm => 'Ganzes Semester';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Wochen $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Wochen $value';
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
