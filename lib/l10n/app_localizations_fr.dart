// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Semaine $week';
  }

  @override
  String get addCourse => 'Ajouter un cours';

  @override
  String get settings => 'Paramètres';

  @override
  String get multiTimetableSwitch => 'Changer d\'emploi du temps';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Emploi du temps actuel · $weeks semaines';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Touchez pour changer · $weeks semaines';
  }

  @override
  String get editTimetable => 'Modifier l\'emploi du temps';

  @override
  String get createTimetable => 'Nouvel emploi du temps';

  @override
  String get jumpToWeek => 'Aller à la semaine';

  @override
  String get timetable => 'Emploi du temps';

  @override
  String get timetableName => 'Nom de l\'emploi du temps';

  @override
  String get totalWeeks => 'Nombre total de semaines';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get deleteTimetableTitle => 'Supprimer l\'emploi du temps';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get noTimetableTitle => 'Aucun emploi du temps';

  @override
  String get noTimetableMessage =>
      'Créez un emploi du temps ou importez-en un depuis un fichier JSON.';

  @override
  String get importTimetable => 'Importer un emploi du temps';

  @override
  String get courseName => 'Nom du cours';

  @override
  String get location => 'Lieu';

  @override
  String get dayOfWeek => 'Jour';

  @override
  String get semesterWeeks => 'Semaines';

  @override
  String get startTime => 'Heure de début';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get linkedPeriods => 'Créneaux liés';

  @override
  String get linkedPeriodsUnmatched =>
      'Aucun créneau ne correspond à l\'heure actuelle. Touchez pour choisir manuellement.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Période $start-$end';
  }

  @override
  String get teacherName => 'Enseignant';

  @override
  String get credits => 'Crédits';

  @override
  String get remarks => 'Remarques';

  @override
  String get customFields => 'Champs personnalisés';

  @override
  String get customFieldsHint => 'Un par ligne, format : clé:valeur';

  @override
  String get selectDayOfWeek => 'Choisir un jour';

  @override
  String get selectSemesterWeeks => 'Choisir les semaines';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get clear => 'Effacer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get selectLinkedPeriods => 'Choisir les créneaux liés';

  @override
  String get addCourseTitle => 'Ajouter un cours';

  @override
  String get editCourseTitle => 'Modifier le cours';

  @override
  String get editCourseTooltip => 'Modifier le cours';

  @override
  String get place => 'Lieu';

  @override
  String get time => 'Heure';

  @override
  String get notFilled => 'Non renseigné';

  @override
  String get none => 'Aucun';

  @override
  String get conflictCourses => 'Cours en conflit';

  @override
  String get locationNotFilled => 'Lieu non renseigné';

  @override
  String get setAsDisplayed => 'Définir comme affiché';

  @override
  String get editThisCourse => 'Modifier ce cours';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get noTimetableSettings =>
      'Aucun emploi du temps n\'est actuellement disponible pour les paramètres.';

  @override
  String get semesterStartDate => 'Date de début du semestre';

  @override
  String get periodTimeSets => 'Jeu d\'horaires des périodes';

  @override
  String get noPeriodTimeAvailable =>
      'Aucun jeu d\'horaires des périodes disponible';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count périodes';
  }

  @override
  String get coursePopupDismissSetting =>
      'Autoriser le toucher à l\'extérieur pour fermer la fenêtre du cours';

  @override
  String get coursePopupDismissSettingHint =>
      'La désactivation désactive aussi la fermeture par glissement vers le bas.';

  @override
  String get preserveTimetableGaps =>
      'Conserver les espaces vides de l\'emploi du temps';

  @override
  String get preserveTimetableGapsHint =>
      'Si désactivé, les pauses déjeuner et autres intervalles sont réduits afin que les cours suivants remontent.';

  @override
  String get showPastEndedCourses => 'Afficher les cours déjà terminés';

  @override
  String get showPastEndedCoursesHint =>
      'Affiche les cours déjà terminés selon la semaine réelle actuelle avec un style gris plus clair.';

  @override
  String get showFutureCourses => 'Afficher les cours futurs';

  @override
  String get showFutureCoursesHint =>
      'Affiche les cours non actifs cette semaine mais prévus pour des semaines ultérieures avec un style gris.';

  @override
  String get timetableDisplaySettings =>
      'Affichage et interactions de l\'emploi du temps';

  @override
  String get timetableDisplaySettingsDesc =>
      'Fermeture des fenêtres, espaces, cours grisés et lignes de grille';

  @override
  String get showTimetableGridLines =>
      'Afficher les lignes de grille de l\'emploi du temps';

  @override
  String get showTimetableGridLinesHint =>
      'Contrôle la visibilité des lignes de grille horizontales et verticales dans l\'emploi du temps.';

  @override
  String get liveCourseOutlineColor => 'Couleur du contour du cours';

  @override
  String get liveCourseOutlineColorHint =>
      'Choisissez si les contours ciblent le cours actuel/suivant ou tous les cours affichés sur la page actuelle.';

  @override
  String get liveCourseOutlineSettings => 'Contour du cours';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Définissez si le contour est activé, sa cible, s\'il suit la couleur du thème et sa couleur effective.';

  @override
  String get liveCourseOutlineEnabled => 'Activer le contour';

  @override
  String get liveCourseOutlineFollowTheme => 'Suivre la couleur du thème';

  @override
  String get liveCourseOutlineTarget => 'Cible du contour';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Cours actuel/suivant';

  @override
  String get liveCourseOutlineTargetAllDisplayed => 'Tous les cours affichés';

  @override
  String get liveCourseOutlineEffectiveColor => 'Couleur effective';

  @override
  String get liveCourseOutlineCustomColor => 'Couleur de contour personnalisée';

  @override
  String get liveCourseOutlineWidth => 'Largeur du contour';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Langue';

  @override
  String get languagePageDescription =>
      'Choisissez l\'une des langues réellement disponibles dans l\'application.';

  @override
  String get languageChinese => 'Chinois';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Réponse API';

  @override
  String get theme => 'Thème';

  @override
  String get themeFollowSystem => 'Suivre le système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeColor => 'Couleur du thème';

  @override
  String get themeColorModeSingle => 'Couleur de thème unique';

  @override
  String get themeColorModeColorful => 'Coloré';

  @override
  String get themeColorUiColors => 'Couleurs de l\'interface';

  @override
  String get themeColorCourseColors => 'Couleurs des cours';

  @override
  String get themeColorPrimary => 'Primaire';

  @override
  String get themeColorSecondary => 'Secondaire';

  @override
  String get themeColorTertiary => 'Tertiaire';

  @override
  String get themeColorCourseText => 'Texte du cours';

  @override
  String get themeColorCourseTextAuto => 'Auto';

  @override
  String get themeColorCourseTextCustom => 'Couleur personnalisée';

  @override
  String get themeColorCourseColorsEmpty =>
      'Les couleurs des cours seront générées après l\'importation d\'un emploi du temps.';

  @override
  String get themeCustomColor => 'Couleur personnalisée';

  @override
  String get themeApplyCustomColor => 'Appliquer la couleur';

  @override
  String get themeApplySettings => 'Appliquer les paramètres';

  @override
  String get dataImportExport => 'Importer et exporter des données';

  @override
  String get dataImportExportDesc =>
      'Importez toutes les données ou un seul emploi du temps, ou exportez l\'emploi du temps actuel/tous les emplois du temps.';

  @override
  String get openSourceLicenses => 'Licences open source';

  @override
  String get openSourceLicensesDesc =>
      'Afficher les licences des dépendances Flutter et des ressources d\'icône intégrées.';

  @override
  String get checkForUpdates => 'Rechercher des mises à jour';

  @override
  String get checkForUpdatesDesc =>
      'GitHub / Site officiel / Google Play / Cloud drive';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Vous utilisez déjà la dernière version ($version)';
  }

  @override
  String get currentVersionLabel => 'Version actuelle';

  @override
  String get newVersionAvailable => 'Mise à jour disponible';

  @override
  String get latestVersionLabel => 'Dernière version';

  @override
  String get updateContentLabel => 'Détails de la mise à jour';

  @override
  String get officialWebsite => 'Site officiel';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Cloud drive';

  @override
  String get ignoreThisVersion => 'Ignorer cette version';

  @override
  String get openUpdatesFailed => 'Impossible d\'ouvrir le lien de mise à jour';

  @override
  String get updateCheckFailedTitle =>
      'Échec de la vérification des mises à jour';

  @override
  String get updateCheckFailedMessage =>
      'Impossible d\'obtenir des informations de mise à jour valides depuis les sources disponibles. Vous pouvez toujours utiliser les liens ci-dessous pour mettre à jour manuellement.';

  @override
  String get githubRepository => 'Dépôt GitHub';

  @override
  String get openGithubFailed => 'Impossible d\'ouvrir le lien du dépôt GitHub';

  @override
  String get selectPeriodTimeSet => 'Choisir un jeu d\'horaires des périodes';

  @override
  String get newItem => 'Nouveau';

  @override
  String get editPeriodTimeSet => 'Modifier le jeu d\'horaires des périodes';

  @override
  String get importTimetableFiles => 'Importer un emploi du temps';

  @override
  String get importTimetableFilesDesc =>
      'Prend en charge un ou plusieurs fichiers d\'emploi du temps.';

  @override
  String get importTimetableText =>
      'Importer un emploi du temps depuis du texte';

  @override
  String get importTimetableTextDesc =>
      'Collez le contenu JSON de l\'emploi du temps et importez-le.';

  @override
  String get shareTimetableFiles => 'Partager les fichiers d\'emploi du temps';

  @override
  String get shareTimetableFilesDesc =>
      'Choisissez d\'abord un ou plusieurs emplois du temps.';

  @override
  String get saveTimetableFiles =>
      'Enregistrer les fichiers d\'emploi du temps';

  @override
  String get saveTimetableFilesDesc =>
      'Choisissez d\'abord un ou plusieurs emplois du temps.';

  @override
  String get exportTimetableText => 'Exporter l\'emploi du temps en texte';

  @override
  String get exportTimetableTextDesc =>
      'Choisissez un ou plusieurs emplois du temps, puis copiez le contenu JSON.';

  @override
  String get jsonContent => 'Contenu JSON';

  @override
  String get pasteJsonContentHint => 'Collez le contenu JSON à importer.';

  @override
  String get jsonContentEmpty => 'Collez d\'abord le contenu JSON.';

  @override
  String get copyText => 'Copier';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get share => 'Partager';

  @override
  String get selectTimetablesToExport =>
      'Choisir les emplois du temps à exporter';

  @override
  String get selectTimetablesToImport =>
      'Choisir les emplois du temps à importer';

  @override
  String timetableCourseCount(int count) {
    return '$count cours';
  }

  @override
  String get importAction => 'Importer';

  @override
  String get importTimetableDialogTitle => 'Importer un emploi du temps';

  @override
  String get chooseImportMethod => 'Choisissez la méthode d\'importation.';

  @override
  String get importAsNewTimetable => 'Importer comme nouvel emploi du temps';

  @override
  String get replaceCurrentTimetable => 'Remplacer l\'emploi du temps actuel';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Importer les jeux d\'horaires des périodes';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Ce fichier contient des jeux d\'horaires des périodes intégrés. Voulez-vous les importer et les associer ?';

  @override
  String get importBundledPeriodTimeSets => 'Importer et associer';

  @override
  String get discardBundledPeriodTimeSets => 'Ignorer les jeux intégrés';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Aucun jeu d\'horaires des périodes existant n\'est disponible ; les jeux intégrés ne peuvent donc pas être ignorés.';

  @override
  String savedToPath(Object path) {
    return 'Enregistré dans $path';
  }

  @override
  String get saveCancelled => 'Enregistrement annulé';

  @override
  String get fileSaveRestrictedTitle => 'Enregistrement de fichier restreint';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'Le système n\'a pas pu enregistrer le fichier. Vous pouvez réessayer ou utiliser le partage à la place.';

  @override
  String get retrySave => 'Réessayer l\'enregistrement';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Activez l\'accès aux fichiers dans les paramètres du système, puis revenez et réessayez d\'exporter.';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get browserDownloadRestrictedTitle =>
      'Téléchargement du navigateur restreint';

  @override
  String get browserDownloadRestrictedMessage =>
      'Ce navigateur ne prend pas en charge l\'enregistrement direct dans un fichier local. Vérifiez les autorisations de téléchargement du navigateur ou utilisez plutôt le partage de fichiers.';

  @override
  String get switchToShare => 'Utiliser le partage à la place';

  @override
  String get fileSaveFailedTitle => 'Échec de l\'enregistrement du fichier';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Impossible d\'écrire dans le chemin actuel. Le dossier cible peut être protégé, le fichier peut être utilisé ou le chemin peut ne pas être accessible en écriture.';

  @override
  String get fileSaveFailedGenericMessage =>
      'Le système n\'a pas pu enregistrer le fichier. Vous pouvez réessayer, vérifier les paramètres du système ou utiliser le partage de fichiers à la place.';

  @override
  String get retryLater => 'Réessayer plus tard';

  @override
  String get exportSwitchedToShare =>
      'Passage au partage de fichiers pour l\'exportation';

  @override
  String get saveFailedRetry =>
      'Échec de l\'enregistrement. Veuillez réessayer plus tard.';

  @override
  String get importFailedCheckContent =>
      'Échec de l\'importation. Veuillez vérifier le contenu du fichier.';

  @override
  String get noImportableTimetables =>
      'Aucun emploi du temps exploitable n\'a été trouvé dans le fichier importé.';

  @override
  String importedTimetablesCount(int count) {
    return '$count emplois du temps importés';
  }

  @override
  String get periodTimesTitle => 'Horaires des périodes';

  @override
  String get importExport => 'Importer et exporter';

  @override
  String get importPeriodTemplate => 'Importer un modèle de périodes';

  @override
  String get importPeriodTemplateText =>
      'Importer un modèle de périodes depuis du texte';

  @override
  String get sharePeriodTemplate => 'Partager le modèle de périodes';

  @override
  String get saveTemplateToFile => 'Enregistrer le modèle dans un fichier';

  @override
  String get exportPeriodTemplateText =>
      'Exporter le modèle de périodes en texte';

  @override
  String get deletePeriodTimeSet => 'Supprimer le jeu d\'horaires des périodes';

  @override
  String get periodTimeSetName => 'Nom du jeu d\'horaires des périodes';

  @override
  String get addOnePeriod => 'Ajouter une période';

  @override
  String periodNumberLabel(int index) {
    return 'Période $index';
  }

  @override
  String get deleteThisPeriod => 'Supprimer cette période';

  @override
  String durationMinutes(int minutes) {
    return 'Durée $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Intervalle depuis la précédente : $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'L\'heure de fin doit être postérieure à l\'heure de début';

  @override
  String get periodOverlapPrevious => 'Cette période chevauche la précédente';

  @override
  String get periodTimesSaved => 'Horaires des périodes enregistrés';

  @override
  String get deletePeriodTimeSetTitle =>
      'Supprimer le jeu d\'horaires des périodes';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get currentPeriodTimeSet => 'jeu d\'horaires des périodes actuel';

  @override
  String importedPeriodTimesCount(int count) {
    return '$count horaires des périodes importés';
  }

  @override
  String get periodFilePermissionTitle => 'Autorisation de fichier requise';

  @override
  String get androidFilePermissionMessage =>
      'L\'exportation Android nécessite l\'autorisation d\'accès aux fichiers. Accordez-la pour continuer l\'enregistrement.';

  @override
  String get reauthorize => 'Autoriser à nouveau';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Autorisation refusée définitivement';

  @override
  String get permissionSettingsExportMessage =>
      'Activez l\'accès aux fichiers dans les paramètres du système, puis revenez et réessayez d\'exporter.';

  @override
  String get privacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get privacyPolicyEntryDesc =>
      'Découvrez comment l\'application gère le stockage local, la configuration des sites scolaires, l\'import/export de fichiers, l\'analyse de pages web et les liens externes.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Version acceptée : $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked est un outil d\'emploi du temps qui privilégie le stockage local. Les emplois du temps, les jeux d\'horaires des périodes et la configuration des sites scolaires sont stockés uniquement sur votre appareil ou dans votre navigateur et ne sont jamais téléversés automatiquement. L\'application ne traite les données que lorsque vous déclenchez explicitement des actions comme l\'importation, l\'analyse de pages web, le partage ou l\'ouverture de liens externes. La politique de confidentialité complète est disponible en ligne.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Stockage local';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Les données d\'emploi du temps et les paramètres associés sont stockés dans un fichier local nommé Sked_data.json dans le répertoire de documents de l\'application. La configuration modifiable des sites scolaires est stockée séparément dans Sked_school_sites.json. Les paramètres personnalisés de l\'analyseur d\'emploi du temps, y compris toute Base URL personnalisée, API key et le modèle sélectionné, sont également stockés localement dans les mêmes données d\'application et ne sont pas protégés par un coffre-fort d\'identifiants système. Dans un navigateur, le même type de données est stocké dans le stockage du navigateur. L\'application ne téléverse pas automatiquement ces données locales vers un serveur contrôlé par le développeur.';

  @override
  String get privacyPolicyImportExportTitle => 'Importation et exportation';

  @override
  String get privacyPolicyImportExportBody =>
      'L\'application lit ou écrit des fichiers JSON d\'emploi du temps, des fichiers JSON de sites scolaires et des fichiers de modèle de périodes uniquement lorsque vous choisissez explicitement un fichier ou lancez une action d\'exportation. L\'importation de ces fichiers reste une opération locale, sauf si vous choisissez également l\'analyse de pages web. La récupération d\'une liste de modèles personnalisés est aussi une action réseau explicite et ne contacte que le point de terminaison personnalisé que vous avez configuré.';

  @override
  String get privacyPolicySharingTitle => 'Partage';

  @override
  String get privacyPolicySharingBody =>
      'Lorsque vous utilisez explicitement le partage, l\'application transmet le fichier exporté à la feuille de partage du système ou à l\'application cible que vous choisissez. La façon dont ce fichier est ensuite traité dépend de l\'application ou du service cible sélectionné.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Liens externes';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Lorsque vous ouvrez des liens externes tels que le dépôt GitHub, l\'application transmet l\'action à votre navigateur ou à une autre application externe. Le traitement des données à partir de ce moment est régi par le tiers que vous ouvrez.';

  @override
  String get privacyPolicyNoCollectionTitle =>
      'Ce que l\'application ne collecte pas';

  @override
  String get privacyPolicyNoCollectionBody =>
      'L\'application n\'exige pas de compte Sked et n\'active ni analytics, ni identifiants publicitaires, ni sauvegarde cloud. Elle ne fournit pas non plus de champ dédié à la collecte des mots de passe des comptes scolaires. Si vous vous connectez à un site scolaire dans l\'application, cette interaction se produit sur la page scolaire que vous avez ouverte.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Analyse de pages web';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Lorsque vous utilisez l\'importation depuis une page web scolaire ou collez du HTML à analyser, l\'application compresse d\'abord le contenu localement, puis envoie le contenu de page soumis, le titre et l\'URL facultatifs, la langue actuelle de l\'application et le contenu du prompt de l\'analyseur au point de terminaison d\'analyse sélectionné. Si vous utilisez l\'analyseur officiel, la requête est envoyée au backend officiel configuré par l\'application. Si vous activez un analyseur personnalisé compatible OpenAI, le même contenu est envoyé directement au point de terminaison tiers que vous avez configuré, et la récupération de la liste des modèles interroge aussi ce même point de terminaison. Un point de terminaison personnalisé peut transférer la requête à d\'autres services d\'IA selon la conception propre à ce fournisseur. Le backend officiel déployé limite actuellement chaque charge utile envoyée à 300KB, utilise son délai d\'attente configuré et autorise au maximum 5 requêtes d\'analyse par IP et par jour.';

  @override
  String get privacyPolicyUpdatesTitle => 'Mises à jour de la politique';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'La version actuelle de la politique de confidentialité est $version. Si une version ultérieure modifie la manière dont les données sont traitées, l\'application peut vous demander de relire et d\'accepter la politique mise à jour.';
  }

  @override
  String get privacyGateTitle =>
      'Veuillez accepter la politique de confidentialité avant d\'utiliser l\'application';

  @override
  String get privacyGateSummaryStorage =>
      'Les emplois du temps, les jeux d\'horaires des périodes et la configuration des sites scolaires sont stockés uniquement en local et ne sont pas automatiquement téléversés vers un serveur du développeur.';

  @override
  String get privacyGateSummaryImportExport =>
      'L\'importation, l\'exportation et le partage ne se produisent que lorsque vous les lancez explicitement ; l\'analyse de pages web envoie uniquement le contenu compressé que vous soumettez au point de terminaison configuré, et vous pouvez vérifier l\'emploi du temps analysé avant de l\'enregistrer.';

  @override
  String get privacyGateSummaryUpdates =>
      'Si une version ultérieure modifie la manière dont les données sont traitées, l\'application peut vous demander de revoir à nouveau la politique de confidentialité mise à jour.';

  @override
  String get schoolWebImportEntry =>
      'Importer depuis la page web de l\'établissement';

  @override
  String get schoolWebImportEntryDesc =>
      'Importer la page d\'emploi du temps actuelle depuis le site de l\'établissement.';

  @override
  String get schoolSitesManageEntry => 'Gérer les sites scolaires';

  @override
  String get schoolSitesManageEntryDesc =>
      'Ajouter, modifier et supprimer des URL de connexion scolaire, avec import/export JSON.';

  @override
  String get schoolSitesPageTitle => 'Gestion des sites scolaires';

  @override
  String get schoolSitesImportJson => 'Importer le JSON des écoles';

  @override
  String get schoolSitesShareJson => 'Partager le JSON des écoles';

  @override
  String get schoolSitesSaveJson => 'Enregistrer le JSON des écoles';

  @override
  String get schoolSitesSaved => 'Sites scolaires enregistrés';

  @override
  String get schoolSitesImported => 'Sites scolaires importés';

  @override
  String get schoolSitesEmpty =>
      'Aucune configuration de site scolaire pour le moment.';

  @override
  String get schoolSitesNameLabel => 'Nom de l\'établissement';

  @override
  String get schoolSitesLoginUrlLabel => 'URL de connexion';

  @override
  String get schoolSitesAdd => 'Ajouter un établissement';

  @override
  String get schoolSitesEdit => 'Modifier l\'établissement';

  @override
  String get schoolSitesDeleteTitle => 'Supprimer l\'établissement';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Renseignez d\'abord le nom de l\'établissement et l\'URL de connexion.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importer en collant le contenu de la page d\'emploi du temps';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Collez manuellement le code source ou le contenu brut de la page contenant les informations d\'emploi du temps.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analyser l\'emploi du temps depuis le contenu de la page';

  @override
  String get schoolHtmlImportUrlLabel => 'URL source (facultatif)';

  @override
  String get schoolHtmlImportTitleLabel => 'Titre de la page (facultatif)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Contenu de la page';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Collez ici le code source ou le contenu brut de la page contenant les informations d\'emploi du temps.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Tout contenu contenant des informations d\'emploi du temps peut être analysé et importé, pas seulement du HTML.';

  @override
  String get schoolHtmlImportCompress => 'Compresser le contenu';

  @override
  String get schoolHtmlImportCompressed => 'Contenu compressé';

  @override
  String get schoolHtmlImportCompressFirst => 'Compressez d\'abord le contenu.';

  @override
  String get schoolHtmlImportSubmit => 'Analyser et importer';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'L\'analyse peut prendre un moment. Veuillez patienter.';

  @override
  String get schoolHtmlImportEmpty => 'Collez d\'abord le HTML de la page.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Retour à la page web';

  @override
  String get schoolWebImportPageTitle =>
      'Importation depuis la page web scolaire';

  @override
  String get schoolWebImportPreview => 'Aperçu de l\'importation';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count cours';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count périodes';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Titre de la page';

  @override
  String get schoolWebImportParserUsed => 'Analyseur';

  @override
  String get schoolWebImportWarnings => 'Notes d\'importation';

  @override
  String get schoolWebImportOpenPageHint =>
      'Connectez-vous au site scolaire dans l\'application, puis accédez manuellement à la page d\'emploi du temps.';

  @override
  String get schoolWebImportConfigMissing =>
      'L\'API backend d\'importation web n\'est pas encore configurée.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Cette plateforme ne prend pas encore en charge la connexion web intégrée. Veuillez utiliser une plateforme compatible WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Choisir un établissement';

  @override
  String get schoolWebImportNoSchools =>
      'Aucune configuration d\'établissement n\'est disponible. Vérifiez d\'abord school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Échec du chargement de la configuration de l\'établissement. Vérifiez le format du fichier JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importer la page actuelle';

  @override
  String get schoolWebImportGoBack => 'Page précédente';

  @override
  String get schoolWebImportLoadingPage => 'Chargement de la page…';

  @override
  String get schoolWebImportParsing => 'Analyse de la page actuelle…';

  @override
  String get schoolWebImportLoadFailed =>
      'Échec du chargement de la page. Veuillez actualiser ou réessayer plus tard.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Le chargement de la page a expiré. Veuillez actualiser puis réessayer.';

  @override
  String get schoolWebImportEmptyPage =>
      'Le contenu actuel de la page est vide et ne peut pas encore être importé.';

  @override
  String get schoolWebImportSuccess => 'Emploi du temps web importé';

  @override
  String get schoolImportParserSettingsTitle =>
      'Paramètres de l\'analyseur d\'emploi du temps';

  @override
  String get schoolImportParserSettingsDesc =>
      'Choisissez l\'analyseur officiel ou un point de terminaison personnalisé compatible OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Source de l\'analyseur';

  @override
  String get schoolImportParserSourceOfficial => 'Analyseur officiel';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Utiliser le service d\'analyse officiel intégré configuré par l\'application.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'L\'analyseur officiel utilise le backend d\'analyse configuré par l\'application et conserve le flux d\'importation actuel inchangé.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Compatible OpenAI personnalisé';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Envoyez directement le contenu de la page vers votre propre point de terminaison compatible OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Analyseur personnalisé compatible OpenAI';

  @override
  String get schoolImportParserCustomPromptTitle => 'Prompt personnalisé';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Modifiez ici le prompt intégré de l\'analyseur. Les changements n\'affectent que l\'analyseur personnalisé compatible OpenAI.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'Le prompt intégré est chargé ici par défaut. Supprimez-le pour revenir à la version intégrée.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Rétablir le prompt par défaut';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'Modèle';

  @override
  String get schoolImportParserFetchModels => 'Récupérer la liste des modèles';

  @override
  String get schoolImportParserFetchingModels => 'Récupération des modèles...';

  @override
  String get schoolImportParserNoModelsFound =>
      'Aucun modèle n\'a été renvoyé par le point de terminaison.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '$count modèles récupérés';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'L\'API key personnalisée est stockée en clair dans les paramètres locaux de l\'application dans l\'implémentation actuelle. Utilisez-la uniquement sur un appareil ou dans un navigateur de confiance.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'La configuration de l\'analyseur personnalisé est incomplète. Renseignez d\'abord la Base URL, l\'API key et le modèle.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Analyseur : Officiel';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Analyseur : Personnalisé ($model)';
  }

  @override
  String get privacyViewFullPolicy =>
      'Voir la politique de confidentialité complète';

  @override
  String get privacyAgreeAndContinue => 'Accepter et continuer';

  @override
  String get privacyDecline => 'Refuser';

  @override
  String get privacyDeclineWebHint =>
      'Cet environnement de navigateur ne permet pas à l\'application de fermer la page pour vous. Si vous n\'acceptez pas, veuillez fermer vous-même cet onglet ou cette fenêtre.';

  @override
  String get defaultPeriodTimeSetName => 'Périodes par défaut';

  @override
  String get periodTimeSetFallbackName => 'Horaires des périodes';

  @override
  String get untitledTimetableName => 'Emploi du temps sans titre';

  @override
  String get newTimetableName => 'Nouvel emploi du temps';

  @override
  String get newPeriodTimeSetName => 'Nouveau jeu d\'horaires des périodes';

  @override
  String get emptyTimetableName => 'Emploi du temps vide';

  @override
  String importedPeriodTimeSetName(Object name) {
    return 'Périodes de $name';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'Le type du fichier importé ne correspond pas.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Cette version du fichier importé n\'est pas encore prise en charge.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Aucun horaire des périodes trouvé dans le fichier importé.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Veuillez sélectionner au moins un emploi du temps.';

  @override
  String get noExportableTimetableMessage =>
      'Aucun emploi du temps n\'est disponible pour l\'exportation.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Le remplacement de l\'emploi du temps actuel ne permet de sélectionner qu\'un seul emploi du temps.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Aucun emploi du temps actuel à remplacer.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Ce jeu d\'horaires des périodes est encore utilisé par $count emploi(s) du temps. Réaffectez-les avant de le supprimer.';
  }

  @override
  String get weekdayMonday => 'Lundi';

  @override
  String get weekdayTuesday => 'Mardi';

  @override
  String get weekdayWednesday => 'Mercredi';

  @override
  String get weekdayThursday => 'Jeudi';

  @override
  String get weekdayFriday => 'Vendredi';

  @override
  String get weekdaySaturday => 'Samedi';

  @override
  String get weekdaySunday => 'Dimanche';

  @override
  String get weekdayShortMonday => 'Lun';

  @override
  String get weekdayShortTuesday => 'Mar';

  @override
  String get weekdayShortWednesday => 'Mer';

  @override
  String get weekdayShortThursday => 'Jeu';

  @override
  String get weekdayShortFriday => 'Ven';

  @override
  String get weekdayShortSaturday => 'Sam';

  @override
  String get weekdayShortSunday => 'Dim';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'Fév';

  @override
  String get monthMarch => 'Mar';

  @override
  String get monthApril => 'Avr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Juin';

  @override
  String get monthJuly => 'Juil';

  @override
  String get monthAugust => 'Aoû';

  @override
  String get monthSeptember => 'Sep';

  @override
  String get monthOctober => 'Oct';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Déc';

  @override
  String get semesterWeeksWholeTerm => 'Tout le semestre';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Semaines $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Semaines $value';
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

  @override
  String get dataRestoredFromBackupNotice =>
      'App data was restored from the previous backup because the main file failed to load.';

  @override
  String get dataBackupRestoreFailedNotice =>
      'Both the main data file and its backup are damaged. The app is now using a fresh state.';
}
