// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Settimana $week';
  }

  @override
  String get addCourse => 'Aggiungi corso';

  @override
  String get settings => 'Impostazioni';

  @override
  String get multiTimetableSwitch => 'Cambia orario';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Orario attuale · $weeks settimane';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Tocca per cambiare · $weeks settimane';
  }

  @override
  String get editTimetable => 'Modifica orario';

  @override
  String get createTimetable => 'Nuovo orario';

  @override
  String get jumpToWeek => 'Vai alla settimana';

  @override
  String get timetable => 'Orario';

  @override
  String get timetableName => 'Nome dell\'orario';

  @override
  String get totalWeeks => 'Settimane totali';

  @override
  String get delete => 'Elimina';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get deleteTimetableTitle => 'Elimina orario';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Nessun orario ancora';

  @override
  String get noTimetableMessage =>
      'Crea un orario o importane uno da un file JSON.';

  @override
  String get importTimetable => 'Importa orario';

  @override
  String get courseName => 'Nome del corso';

  @override
  String get location => 'Luogo';

  @override
  String get dayOfWeek => 'Giorno';

  @override
  String get semesterWeeks => 'Settimane';

  @override
  String get startTime => 'Ora di inizio';

  @override
  String get endTime => 'Ora di fine';

  @override
  String get linkedPeriods => 'Periodi collegati';

  @override
  String get linkedPeriodsUnmatched =>
      'Nessun periodo corrisponde all\'orario attuale. Tocca per scegliere manualmente.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Periodo $start-$end';
  }

  @override
  String get teacherName => 'Docente';

  @override
  String get credits => 'Crediti';

  @override
  String get remarks => 'Note';

  @override
  String get customFields => 'Campi personalizzati';

  @override
  String get customFieldsHint => 'Uno per riga, formato: chiave:valore';

  @override
  String get selectDayOfWeek => 'Scegli giorno';

  @override
  String get selectSemesterWeeks => 'Scegli settimane';

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get clear => 'Cancella';

  @override
  String get confirm => 'Conferma';

  @override
  String get selectLinkedPeriods => 'Scegli periodi collegati';

  @override
  String get addCourseTitle => 'Aggiungi corso';

  @override
  String get editCourseTitle => 'Modifica corso';

  @override
  String get editCourseTooltip => 'Modifica corso';

  @override
  String get place => 'Luogo';

  @override
  String get time => 'Orario';

  @override
  String get notFilled => 'Non compilato';

  @override
  String get none => 'Nessuno';

  @override
  String get conflictCourses => 'Corsi in conflitto';

  @override
  String get locationNotFilled => 'Luogo non compilato';

  @override
  String get setAsDisplayed => 'Imposta come visualizzato';

  @override
  String get editThisCourse => 'Modifica questo corso';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get noTimetableSettings =>
      'Nessun orario è attualmente disponibile nelle impostazioni.';

  @override
  String get semesterStartDate => 'Data di inizio semestre';

  @override
  String get periodTimeSets => 'Set di orari dei periodi';

  @override
  String get noPeriodTimeAvailable =>
      'Nessun set di orari dei periodi disponibile';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count periodi';
  }

  @override
  String get coursePopupDismissSetting =>
      'Consenti tocco esterno per chiudere il popup del corso';

  @override
  String get coursePopupDismissSettingHint =>
      'Disattivandolo si disabilita anche la chiusura con scorrimento verso il basso.';

  @override
  String get preserveTimetableGaps => 'Mantieni gli spazi vuoti nell\'orario';

  @override
  String get preserveTimetableGapsHint =>
      'Se disattivato, le pause pranzo e gli intervalli vengono compressi e le lezioni successive si spostano verso l\'alto.';

  @override
  String get showPastEndedCourses => 'Mostra i corsi già terminati';

  @override
  String get showPastEndedCoursesHint =>
      'Mostra i corsi già conclusi rispetto alla settimana corrente reale con uno stile grigio più chiaro.';

  @override
  String get showFutureCourses => 'Mostra i corsi futuri';

  @override
  String get showFutureCoursesHint =>
      'Mostra con uno stile grigio i corsi non attivi questa settimana ma previsti nelle settimane successive.';

  @override
  String get timetableDisplaySettings =>
      'Visualizzazione e interazione dell\'orario';

  @override
  String get timetableDisplaySettingsDesc =>
      'Chiusura popup, spazi vuoti, corsi grigi e linee della griglia';

  @override
  String get showTimetableGridLines =>
      'Mostra linee della griglia dell\'orario';

  @override
  String get showTimetableGridLinesHint =>
      'Controlla se le linee orizzontali e verticali della griglia sono visibili nell\'orario.';

  @override
  String get liveCourseOutlineColor => 'Colore del contorno del corso';

  @override
  String get liveCourseOutlineColorHint =>
      'Scegli se i contorni devono evidenziare il corso attuale/successivo oppure tutti i corsi mostrati nella pagina corrente.';

  @override
  String get liveCourseOutlineSettings => 'Contorno del corso';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Configura se il contorno è attivo, cosa evidenzia, se segue il colore del tema e il colore effettivo del contorno.';

  @override
  String get liveCourseOutlineEnabled => 'Abilita contorno';

  @override
  String get liveCourseOutlineFollowTheme => 'Segui il colore del tema';

  @override
  String get liveCourseOutlineTarget => 'Destinazione del contorno';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Corso attuale/successivo';

  @override
  String get liveCourseOutlineTargetAllDisplayed =>
      'Tutti i corsi visualizzati';

  @override
  String get liveCourseOutlineEffectiveColor => 'Colore effettivo';

  @override
  String get liveCourseOutlineCustomColor =>
      'Colore personalizzato del contorno';

  @override
  String get liveCourseOutlineWidth => 'Spessore del contorno';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Lingua';

  @override
  String get languagePageDescription =>
      'Scegli una delle lingue realmente disponibili nell\'app.';

  @override
  String get languageChinese => 'Cinese';

  @override
  String get languageEnglish => 'Inglese';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Risposta API';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Segui il sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeColor => 'Colore del tema';

  @override
  String get themeColorModeSingle => 'Colore singolo del tema';

  @override
  String get themeColorModeColorful => 'Colorato';

  @override
  String get themeColorUiColors => 'Colori dell\'interfaccia';

  @override
  String get themeColorCourseColors => 'Colori dei corsi';

  @override
  String get themeColorPrimary => 'Primario';

  @override
  String get themeColorSecondary => 'Secondario';

  @override
  String get themeColorTertiary => 'Terziario';

  @override
  String get themeColorCourseText => 'Testo del corso';

  @override
  String get themeColorCourseTextAuto => 'Automatico';

  @override
  String get themeColorCourseTextCustom => 'Colore personalizzato';

  @override
  String get themeColorCourseColorsEmpty =>
      'I colori dei corsi verranno generati dopo l\'importazione di un orario.';

  @override
  String get themeCustomColor => 'Colore personalizzato';

  @override
  String get themeApplyCustomColor => 'Applica colore';

  @override
  String get themeApplySettings => 'Applica impostazioni';

  @override
  String get dataImportExport => 'Importa ed esporta dati';

  @override
  String get dataImportExportDesc =>
      'Importa tutti i dati o singoli orari, oppure esporta l\'orario corrente o tutti gli orari.';

  @override
  String get openSourceLicenses => 'Licenze open source';

  @override
  String get openSourceLicensesDesc =>
      'Visualizza le licenze delle dipendenze Flutter e delle risorse dell\'icona dell\'app incluse.';

  @override
  String get checkForUpdates => 'Controlla aggiornamenti';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Hai già l\'ultima versione ($version)';
  }

  @override
  String get currentVersionLabel => 'Versione attuale';

  @override
  String get newVersionAvailable => 'Aggiornamento disponibile';

  @override
  String get latestVersionLabel => 'Ultima versione';

  @override
  String get updateContentLabel => 'Dettagli aggiornamento';

  @override
  String get officialWebsite => 'Sito ufficiale';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Cloud drive';

  @override
  String get ignoreThisVersion => 'Ignora questa versione';

  @override
  String get openUpdatesFailed => 'Impossibile aprire il link di aggiornamento';

  @override
  String get updateCheckFailedTitle => 'Controllo aggiornamenti non riuscito';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'Repository GitHub';

  @override
  String get openGithubFailed =>
      'Impossibile aprire il link del repository GitHub';

  @override
  String get selectPeriodTimeSet => 'Scegli set di orari dei periodi';

  @override
  String get newItem => 'Nuovo';

  @override
  String get editPeriodTimeSet => 'Modifica set di orari dei periodi';

  @override
  String get importTimetableFiles => 'Importa orario';

  @override
  String get importTimetableFilesDesc => 'Supporta uno o più file di orario.';

  @override
  String get importTimetableText => 'Importa orario da testo';

  @override
  String get importTimetableTextDesc =>
      'Incolla il contenuto JSON dell\'orario e importalo.';

  @override
  String get shareTimetableFiles => 'Condividi file dell\'orario';

  @override
  String get shareTimetableFilesDesc => 'Scegli prima uno o più orari.';

  @override
  String get saveTimetableFiles => 'Salva file dell\'orario';

  @override
  String get saveTimetableFilesDesc => 'Scegli prima uno o più orari.';

  @override
  String get exportTimetableText => 'Esporta orario come testo';

  @override
  String get exportTimetableTextDesc =>
      'Scegli uno o più orari, poi copia il contenuto JSON.';

  @override
  String get jsonContent => 'Contenuto JSON';

  @override
  String get pasteJsonContentHint => 'Incolla il contenuto JSON da importare.';

  @override
  String get jsonContentEmpty => 'Incolla prima il contenuto JSON.';

  @override
  String get copyText => 'Copia';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get share => 'Condividi';

  @override
  String get selectTimetablesToExport => 'Scegli gli orari da esportare';

  @override
  String get selectTimetablesToImport => 'Scegli gli orari da importare';

  @override
  String timetableCourseCount(int count) {
    return '$count corsi';
  }

  @override
  String get importAction => 'Importa';

  @override
  String get importTimetableDialogTitle => 'Importa orario';

  @override
  String get chooseImportMethod => 'Scegli come importare.';

  @override
  String get importAsNewTimetable => 'Importa come nuovo orario';

  @override
  String get replaceCurrentTimetable => 'Sostituisci l\'orario attuale';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Importa set di orari dei periodi';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Questo file contiene set di orari dei periodi inclusi. Vuoi importarli e associarli?';

  @override
  String get importBundledPeriodTimeSets => 'Importa e associa';

  @override
  String get discardBundledPeriodTimeSets => 'Scarta set inclusi';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Non è disponibile alcun set di orari dei periodi esistente, quindi quelli inclusi non possono essere scartati.';

  @override
  String savedToPath(Object path) {
    return 'Salvato in $path';
  }

  @override
  String get saveCancelled => 'Salvataggio annullato';

  @override
  String get fileSaveRestrictedTitle => 'Salvataggio file limitato';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Il sistema non è riuscito a salvare il file. Puoi riprovare o usare invece la condivisione.';

  @override
  String get retrySave => 'Riprova a salvare';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Abilita l\'accesso ai file nelle impostazioni di sistema, poi torna qui e prova di nuovo a esportare.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get browserDownloadRestrictedTitle => 'Download del browser limitato';

  @override
  String get browserDownloadRestrictedMessage =>
      'Questo browser non supporta il salvataggio diretto in un file locale. Controlla i permessi di download del browser oppure usa la condivisione file.';

  @override
  String get switchToShare => 'Usa invece la condivisione';

  @override
  String get fileSaveFailedTitle => 'Salvataggio file non riuscito';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Impossibile scrivere nel percorso corrente. La cartella di destinazione potrebbe essere protetta, il file potrebbe essere in uso oppure il percorso potrebbe non essere scrivibile.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Il sistema non è riuscito a salvare il file. Puoi riprovare, controllare le impostazioni di sistema o usare invece la condivisione file.';

  @override
  String get retryLater => 'Riprova più tardi';

  @override
  String get exportSwitchedToShare =>
      'Esportazione passata alla condivisione file';

  @override
  String get saveFailedRetry => 'Salvataggio non riuscito. Riprova più tardi.';

  @override
  String get importFailedCheckContent =>
      'Importazione non riuscita. Controlla il contenuto del file.';

  @override
  String get noImportableTimetables =>
      'Nessun orario utilizzabile trovato nel file importato.';

  @override
  String importedTimetablesCount(int count) {
    return 'Importati $count orari';
  }

  @override
  String get periodTimesTitle => 'Orari dei periodi';

  @override
  String get importExport => 'Importa ed esporta';

  @override
  String get importPeriodTemplate => 'Importa modello dei periodi';

  @override
  String get importPeriodTemplateText => 'Importa modello dei periodi da testo';

  @override
  String get sharePeriodTemplate => 'Condividi modello dei periodi';

  @override
  String get saveTemplateToFile => 'Salva modello su file';

  @override
  String get exportPeriodTemplateText =>
      'Esporta modello dei periodi come testo';

  @override
  String get deletePeriodTimeSet => 'Elimina set di orari dei periodi';

  @override
  String get periodTimeSetName => 'Nome del set di orari dei periodi';

  @override
  String get addOnePeriod => 'Aggiungi periodo';

  @override
  String periodNumberLabel(int index) {
    return 'Periodo $index';
  }

  @override
  String get deleteThisPeriod => 'Elimina questo periodo';

  @override
  String durationMinutes(int minutes) {
    return 'Durata $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Intervallo dal precedente $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'L\'ora di fine deve essere successiva all\'ora di inizio';

  @override
  String get periodOverlapPrevious =>
      'Questo periodo si sovrappone al precedente';

  @override
  String get periodTimesSaved => 'Orari dei periodi salvati';

  @override
  String get deletePeriodTimeSetTitle => 'Elimina set di orari dei periodi';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'set di orari dei periodi attuale';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Importati $count orari dei periodi';
  }

  @override
  String get periodFilePermissionTitle => 'Permesso file necessario';

  @override
  String get androidFilePermissionMessage =>
      'L\'esportazione su Android richiede il permesso di accesso ai file. Concedilo per continuare a salvare.';

  @override
  String get reauthorize => 'Autorizza di nuovo';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Permesso negato in modo permanente';

  @override
  String get permissionSettingsExportMessage =>
      'Abilita l\'accesso ai file nelle impostazioni di sistema, poi torna qui e prova di nuovo a esportare.';

  @override
  String get privacyPolicyTitle => 'Informativa sulla privacy';

  @override
  String get privacyPolicyEntryDesc =>
      'Scopri come l\'app gestisce archiviazione locale, configurazione dei siti scolastici, importazione/esportazione file, parsing delle pagine web e link esterni.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Versione accettata: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked è uno strumento di orari che privilegia l\'archiviazione locale. Orari, set di periodi e configurazione dei siti scolastici sono memorizzati solo sul tuo dispositivo o nel browser e non vengono mai caricati automaticamente. L\'app elabora i dati solo quando attivi esplicitamente azioni come importazione, parsing di pagine web, condivisione o apertura di link esterni. L\'informativa completa sulla privacy è disponibile online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Archiviazione locale';

  @override
  String get privacyPolicyLocalStorageBody =>
      'I dati dell\'orario e le relative impostazioni sono memorizzati in un file locale chiamato Sked_data.json nella directory dei documenti dell\'app. La configurazione modificabile dei siti scolastici è memorizzata separatamente in Sked_school_sites.json. Anche le impostazioni personalizzate del parser dell\'orario, compresi eventuali Base URL personalizzati, chiave API e modello selezionato, sono salvate localmente negli stessi dati dell\'app e non sono protette da un archivio credenziali di sistema. Quando l\'app viene usata nel browser, gli stessi tipi di dati sono salvati nella memoria del browser. L\'app non carica automaticamente questi dati locali su un server controllato dallo sviluppatore.';

  @override
  String get privacyPolicyImportExportTitle => 'Importazione ed esportazione';

  @override
  String get privacyPolicyImportExportBody =>
      'L\'app legge o scrive file JSON dell\'orario, file JSON dei siti scolastici e file modello dei periodi solo quando scegli esplicitamente un file o avvii un\'esportazione. L\'importazione di questi file è un\'operazione locale, a meno che tu non scelga anche il parsing della pagina web. Anche il recupero di un elenco di modelli personalizzati è un\'azione di rete esplicita e contatta solo l\'endpoint personalizzato che hai configurato.';

  @override
  String get privacyPolicySharingTitle => 'Condivisione';

  @override
  String get privacyPolicySharingBody =>
      'Quando usi esplicitamente la condivisione, l\'app passa il file esportato al pannello di condivisione del sistema o all\'app di destinazione che scegli. Il modo in cui quel file viene poi gestito dipende dall\'app o dal servizio di destinazione selezionato.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Link esterni';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Quando apri link esterni come il repository GitHub, l\'app delega l\'azione al browser o a un\'altra applicazione esterna. La gestione dei dati da quel momento in poi è regolata dalla terza parte che apri.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Cosa non raccoglie l\'app';

  @override
  String get privacyPolicyNoCollectionBody =>
      'L\'app non richiede un account Sked e non abilita analytics, identificatori pubblicitari o backup cloud. Inoltre non fornisce un campo dedicato alla raccolta delle password degli account scolastici. Se accedi a un sito scolastico all\'interno dell\'app, quell\'interazione avviene nella pagina scolastica che hai aperto.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Parsing delle pagine web';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Quando usi l\'importazione da pagina web scolastica o incolli HTML da analizzare, l\'app comprime prima localmente il contenuto, poi invia all\'endpoint di parsing selezionato il contenuto della pagina inviata, eventuali titolo e URL della pagina, la lingua corrente dell\'app e il contenuto del prompt del parser. Se usi il parser ufficiale, la richiesta viene inviata al backend ufficiale configurato dall\'app. Se abiliti un parser OpenAI-compatibile personalizzato, lo stesso contenuto viene inviato direttamente all\'endpoint di terze parti che hai configurato e anche il recupero della lista dei modelli interroga quello stesso endpoint. Un endpoint personalizzato può inoltrare la richiesta ad altri servizi AI secondo il design del relativo fornitore. Il backend ufficiale distribuito attualmente limita ogni payload inviato a 300 KB, usa il timeout configurato e consente al massimo 5 richieste di parsing per IP al giorno.';

  @override
  String get privacyPolicyUpdatesTitle => 'Aggiornamenti dell\'informativa';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'La versione attuale dell\'informativa sulla privacy è $version. Se una versione successiva modifica il modo in cui vengono gestiti i dati, l\'app potrebbe chiederti di leggere e accettare nuovamente l\'informativa aggiornata.';
  }

  @override
  String get privacyGateTitle =>
      'Accetta l\'informativa sulla privacy prima di usare l\'app';

  @override
  String get privacyGateSummaryStorage =>
      'Orari, set di orari dei periodi e configurazione dei siti scolastici sono memorizzati solo localmente e non vengono caricati automaticamente su un server dello sviluppatore.';

  @override
  String get privacyGateSummaryImportExport =>
      'Importazione, esportazione e condivisione avvengono solo quando le avvii esplicitamente; il parsing delle pagine web invia solo il contenuto compresso che hai inviato al tuo endpoint di parsing configurato e puoi controllare l\'orario analizzato prima di salvarlo.';

  @override
  String get privacyGateSummaryUpdates =>
      'Se una versione successiva cambia il modo in cui vengono gestiti i dati, l\'app potrebbe chiederti di rivedere di nuovo l\'informativa aggiornata.';

  @override
  String get schoolWebImportEntry => 'Importa dalla pagina web della scuola';

  @override
  String get schoolWebImportEntryDesc =>
      'Importa la pagina dell\'orario corrente dal sito della scuola.';

  @override
  String get schoolSitesManageEntry => 'Gestisci siti scolastici';

  @override
  String get schoolSitesManageEntryDesc =>
      'Aggiungi, modifica ed elimina URL di accesso scolastici, con importazione ed esportazione JSON.';

  @override
  String get schoolSitesPageTitle => 'Gestione siti scolastici';

  @override
  String get schoolSitesImportJson => 'Importa JSON scolastico';

  @override
  String get schoolSitesShareJson => 'Condividi JSON scolastico';

  @override
  String get schoolSitesSaveJson => 'Salva JSON scolastico';

  @override
  String get schoolSitesSaved => 'Siti scolastici salvati';

  @override
  String get schoolSitesImported => 'Siti scolastici importati';

  @override
  String get schoolSitesEmpty =>
      'Nessuna configurazione di sito scolastico ancora.';

  @override
  String get schoolSitesNameLabel => 'Nome della scuola';

  @override
  String get schoolSitesLoginUrlLabel => 'URL di accesso';

  @override
  String get schoolSitesAdd => 'Aggiungi scuola';

  @override
  String get schoolSitesEdit => 'Modifica scuola';

  @override
  String get schoolSitesDeleteTitle => 'Elimina scuola';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Compila prima il nome della scuola e l\'URL di accesso.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importa incollando il contenuto della pagina dell\'orario';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Incolla manualmente il codice sorgente o il contenuto grezzo della pagina che contiene le informazioni dell\'orario.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analizza orario dal contenuto della pagina';

  @override
  String get schoolHtmlImportUrlLabel => 'URL sorgente (opzionale)';

  @override
  String get schoolHtmlImportTitleLabel => 'Titolo della pagina (opzionale)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Contenuto della pagina';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Incolla qui il codice sorgente o il contenuto grezzo della pagina che contiene informazioni sull\'orario.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Può essere analizzato e importato qualsiasi contenuto che contenga informazioni sull\'orario, non solo HTML.';

  @override
  String get schoolHtmlImportCompress => 'Comprimi contenuto';

  @override
  String get schoolHtmlImportCompressed => 'Contenuto compresso';

  @override
  String get schoolHtmlImportCompressFirst => 'Comprimi prima il contenuto.';

  @override
  String get schoolHtmlImportSubmit => 'Analizza e importa';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'L\'analisi potrebbe richiedere un po\' di tempo. Attendi.';

  @override
  String get schoolHtmlImportEmpty => 'Incolla prima l\'HTML della pagina.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Torna alla pagina web';

  @override
  String get schoolWebImportPageTitle =>
      'Importazione da pagina web scolastica';

  @override
  String get schoolWebImportPreview => 'Anteprima importazione';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count corsi';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count periodi';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Titolo della pagina';

  @override
  String get schoolWebImportParserUsed => 'Parser';

  @override
  String get schoolWebImportWarnings => 'Note di importazione';

  @override
  String get schoolWebImportOpenPageHint =>
      'Accedi al sito della scuola nell\'app, poi vai manualmente alla pagina dell\'orario.';

  @override
  String get schoolWebImportConfigMissing =>
      'L\'API backend per l\'importazione web non è ancora configurata.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Questa piattaforma non supporta ancora il login web incorporato. Usa una piattaforma con supporto WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Scegli scuola';

  @override
  String get schoolWebImportNoSchools =>
      'Nessuna configurazione scolastica disponibile. Controlla prima school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Impossibile caricare la configurazione scolastica. Controlla il formato del file JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importa pagina corrente';

  @override
  String get schoolWebImportGoBack => 'Pagina precedente';

  @override
  String get schoolWebImportLoadingPage => 'Caricamento pagina…';

  @override
  String get schoolWebImportParsing => 'Analisi della pagina corrente…';

  @override
  String get schoolWebImportLoadFailed =>
      'Caricamento della pagina non riuscito. Aggiorna o riprova più tardi.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Caricamento della pagina scaduto. Aggiorna e riprova.';

  @override
  String get schoolWebImportEmptyPage =>
      'Il contenuto della pagina corrente è vuoto e non può ancora essere importato.';

  @override
  String get schoolWebImportSuccess => 'Orario web importato';

  @override
  String get schoolImportParserSettingsTitle =>
      'Impostazioni parser dell\'orario';

  @override
  String get schoolImportParserSettingsDesc =>
      'Scegli il parser ufficiale o un endpoint personalizzato compatibile con OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Sorgente del parser';

  @override
  String get schoolImportParserSourceOfficial => 'Parser ufficiale';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Usa il servizio di parsing ufficiale integrato configurato dall\'app.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'Il parser ufficiale usa il backend di parsing configurato dall\'app e mantiene invariato il flusso di importazione corrente.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'OpenAI-compatibile personalizzato';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Invia direttamente il contenuto della pagina al tuo endpoint personale compatibile con OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Parser OpenAI-compatibile personalizzato';

  @override
  String get schoolImportParserCustomPromptTitle => 'Prompt personalizzato';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Modifica qui il prompt integrato del parser. Le modifiche influenzano solo il parser OpenAI-compatibile personalizzato.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Il prompt integrato viene caricato qui per impostazione predefinita. Cancellalo per tornare alla versione integrata.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Ripristina prompt predefinito';

  @override
  String get schoolImportParserBaseUrl => 'URL di base';

  @override
  String get schoolImportParserApiKey => 'Chiave API';

  @override
  String get schoolImportParserModel => 'Modello';

  @override
  String get schoolImportParserFetchModels => 'Recupera elenco modelli';

  @override
  String get schoolImportParserFetchingModels => 'Recupero modelli...';

  @override
  String get schoolImportParserNoModelsFound =>
      'Nessun modello restituito dall\'endpoint.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Recuperati $count modelli';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'Nell\'implementazione attuale, la chiave API personalizzata viene salvata in chiaro nelle impostazioni locali dell\'app. Usala solo su un dispositivo o in un ambiente browser di cui ti fidi.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'La configurazione del parser personalizzato è incompleta. Inserisci prima URL di base, chiave API e modello.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Parser: ufficiale';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Parser: personalizzato ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Visualizza informativa completa sulla privacy';

  @override
  String get privacyAgreeAndContinue => 'Accetta e continua';

  @override
  String get privacyDecline => 'Rifiuta';

  @override
  String get privacyDeclineWebHint =>
      'Questo ambiente browser non consente all\'app di chiudere la pagina al posto tuo. Se non accetti, chiudi tu stesso questa scheda o finestra.';

  @override
  String get defaultPeriodTimeSetName => 'Periodi predefiniti';

  @override
  String get periodTimeSetFallbackName => 'Orari dei periodi';

  @override
  String get untitledTimetableName => 'Orario senza titolo';

  @override
  String get newTimetableName => 'Nuovo orario';

  @override
  String get newPeriodTimeSetName => 'Nuovo set di orari dei periodi';

  @override
  String get emptyTimetableName => 'Orario vuoto';

  @override
  String importedPeriodTimeSetName(Object name) {
    return 'Periodi di $name';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Il tipo di file importato non corrisponde.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Questa versione del file di importazione non è ancora supportata.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Nessun orario dei periodi trovato nel file importato.';

  @override
  String get selectAtLeastOneTimetableMessage => 'Seleziona almeno un orario.';

  @override
  String get noExportableTimetableMessage =>
      'Non c\'è alcun orario disponibile da esportare.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'La sostituzione dell\'orario attuale supporta solo la selezione di un singolo orario.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Non c\'è alcun orario attuale da sostituire.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Questo set di orari dei periodi è ancora usato da $count orario/i. Riassegnali prima di eliminarlo.';
  }

  @override
  String get weekdayMonday => 'Lunedì';

  @override
  String get weekdayTuesday => 'Martedì';

  @override
  String get weekdayWednesday => 'Mercoledì';

  @override
  String get weekdayThursday => 'Giovedì';

  @override
  String get weekdayFriday => 'Venerdì';

  @override
  String get weekdaySaturday => 'Sabato';

  @override
  String get weekdaySunday => 'Domenica';

  @override
  String get weekdayShortMonday => 'Lun';

  @override
  String get weekdayShortTuesday => 'Mar';

  @override
  String get weekdayShortWednesday => 'Mer';

  @override
  String get weekdayShortThursday => 'Gio';

  @override
  String get weekdayShortFriday => 'Ven';

  @override
  String get weekdayShortSaturday => 'Sab';

  @override
  String get weekdayShortSunday => 'Dom';

  @override
  String get monthJanuary => 'Gen';

  @override
  String get monthFebruary => 'Feb';

  @override
  String get monthMarch => 'Mar';

  @override
  String get monthApril => 'Apr';

  @override
  String get monthMay => 'Mag';

  @override
  String get monthJune => 'Giu';

  @override
  String get monthJuly => 'Lug';

  @override
  String get monthAugust => 'Ago';

  @override
  String get monthSeptember => 'Set';

  @override
  String get monthOctober => 'Ott';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Dic';

  @override
  String get semesterWeeksWholeTerm => 'Tutto il semestre';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Settimane $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Settimane $value';
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
