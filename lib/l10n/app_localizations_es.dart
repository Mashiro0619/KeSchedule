// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Semana $week';
  }

  @override
  String get addCourse => 'Añadir curso';

  @override
  String get settings => 'Ajustes';

  @override
  String get multiTimetableSwitch => 'Cambiar horario';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Horario actual · $weeks semanas';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Toca para cambiar · $weeks semanas';
  }

  @override
  String get editTimetable => 'Editar horario';

  @override
  String get createTimetable => 'Nuevo horario';

  @override
  String get jumpToWeek => 'Ir a la semana';

  @override
  String get timetable => 'Horario';

  @override
  String get timetableName => 'Nombre del horario';

  @override
  String get totalWeeks => 'Semanas totales';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get deleteTimetableTitle => 'Eliminar horario';

  @override
  String deleteTimetableMessage(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Aún no hay horario';

  @override
  String get noTimetableMessage =>
      'Crea un horario o importa uno desde un archivo JSON.';

  @override
  String get importTimetable => 'Importar horario';

  @override
  String get courseName => 'Nombre del curso';

  @override
  String get location => 'Ubicación';

  @override
  String get dayOfWeek => 'Día';

  @override
  String get semesterWeeks => 'Semanas';

  @override
  String get startTime => 'Hora de inicio';

  @override
  String get endTime => 'Hora de fin';

  @override
  String get linkedPeriods => 'Periodos vinculados';

  @override
  String get linkedPeriodsUnmatched =>
      'Ningún periodo coincide con la hora actual. Toca para elegir manualmente.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Periodo $start-$end';
  }

  @override
  String get teacherName => 'Profesor';

  @override
  String get credits => 'Créditos';

  @override
  String get remarks => 'Observaciones';

  @override
  String get customFields => 'Campos personalizados';

  @override
  String get customFieldsHint => 'Uno por línea, formato: clave:valor';

  @override
  String get selectDayOfWeek => 'Elegir día';

  @override
  String get selectSemesterWeeks => 'Elegir semanas';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get clear => 'Borrar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectLinkedPeriods => 'Elegir periodos vinculados';

  @override
  String get addCourseTitle => 'Añadir curso';

  @override
  String get editCourseTitle => 'Editar curso';

  @override
  String get editCourseTooltip => 'Editar curso';

  @override
  String get place => 'Ubicación';

  @override
  String get time => 'Hora';

  @override
  String get notFilled => 'Sin completar';

  @override
  String get none => 'Ninguno';

  @override
  String get conflictCourses => 'Cursos en conflicto';

  @override
  String get locationNotFilled => 'Ubicación sin completar';

  @override
  String get setAsDisplayed => 'Establecer como mostrado';

  @override
  String get editThisCourse => 'Editar este curso';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get noTimetableSettings =>
      'No hay un horario disponible actualmente para los ajustes.';

  @override
  String get semesterStartDate => 'Fecha de inicio del semestre';

  @override
  String get periodTimeSets => 'Conjunto de horarios de periodos';

  @override
  String get noPeriodTimeAvailable =>
      'No hay conjuntos de horarios de periodos disponibles';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count periodos';
  }

  @override
  String get coursePopupDismissSetting =>
      'Permitir tocar fuera para cerrar el popup del curso';

  @override
  String get coursePopupDismissSettingHint =>
      'Desactivar esto también desactiva el cierre deslizando hacia abajo.';

  @override
  String get preserveTimetableGaps => 'Mantener huecos del horario';

  @override
  String get preserveTimetableGapsHint =>
      'Si está desactivado, los huecos de almuerzo y descansos se colapsan para que las clases posteriores suban.';

  @override
  String get showPastEndedCourses => 'Mostrar cursos ya finalizados';

  @override
  String get showPastEndedCoursesHint =>
      'Muestra los cursos que ya terminaron según la semana real actual con un estilo gris más claro.';

  @override
  String get showFutureCourses => 'Mostrar cursos futuros';

  @override
  String get showFutureCoursesHint =>
      'Muestra los cursos que no están activos esta semana pero aparecerán en semanas posteriores con un estilo gris.';

  @override
  String get timetableDisplaySettings =>
      'Visualización e interacción del horario';

  @override
  String get timetableDisplaySettingsDesc =>
      'Cierre del popup, huecos, cursos en gris y líneas de cuadrícula';

  @override
  String get showTimetableGridLines =>
      'Mostrar líneas de cuadrícula del horario';

  @override
  String get showTimetableGridLinesHint =>
      'Controla si las líneas de cuadrícula horizontales y verticales son visibles en el horario.';

  @override
  String get liveCourseOutlineColor => 'Color del contorno del curso';

  @override
  String get liveCourseOutlineColorHint =>
      'Elige si los contornos apuntan al curso actual/siguiente o a todos los cursos mostrados en la página actual.';

  @override
  String get liveCourseOutlineSettings => 'Contorno del curso';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Configura si el contorno está habilitado, a qué apunta, si sigue el color del tema y el color efectivo del contorno.';

  @override
  String get liveCourseOutlineEnabled => 'Activar contorno';

  @override
  String get liveCourseOutlineFollowTheme => 'Seguir color del tema';

  @override
  String get liveCourseOutlineTarget => 'Destino del contorno';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Curso actual/siguiente';

  @override
  String get liveCourseOutlineTargetAllDisplayed =>
      'Todos los cursos mostrados';

  @override
  String get liveCourseOutlineEffectiveColor => 'Color efectivo';

  @override
  String get liveCourseOutlineCustomColor => 'Color de contorno personalizado';

  @override
  String get liveCourseOutlineWidth => 'Ancho del contorno';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Idioma';

  @override
  String get languagePageDescription =>
      'Elige uno de los idiomas que realmente están disponibles en la app.';

  @override
  String get languageChinese => 'Chino';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/KeSchedule';

  @override
  String get apiResponseTitle => 'Respuesta de la API';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Seguir el sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get themeColorModeSingle => 'Un solo color de tema';

  @override
  String get themeColorModeColorful => 'Colorido';

  @override
  String get themeColorUiColors => 'Colores de la interfaz';

  @override
  String get themeColorCourseColors => 'Colores de los cursos';

  @override
  String get themeColorPrimary => 'Primario';

  @override
  String get themeColorSecondary => 'Secundario';

  @override
  String get themeColorTertiary => 'Terciario';

  @override
  String get themeColorCourseText => 'Texto del curso';

  @override
  String get themeColorCourseTextAuto => 'Automático';

  @override
  String get themeColorCourseTextCustom => 'Color personalizado';

  @override
  String get themeColorCourseColorsEmpty =>
      'Los colores de los cursos se generarán después de importar un horario.';

  @override
  String get themeCustomColor => 'Color personalizado';

  @override
  String get themeApplyCustomColor => 'Aplicar color';

  @override
  String get themeApplySettings => 'Aplicar ajustes';

  @override
  String get dataImportExport => 'Importar y exportar datos';

  @override
  String get dataImportExportDesc =>
      'Importa todos los datos o un solo horario, o exporta el horario actual/todos.';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get openSourceLicensesDesc =>
      'Ver licencias de las dependencias de Flutter y de los recursos del icono de la app incluidos.';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Ya tienes la versión más reciente ($version)';
  }

  @override
  String get currentVersionLabel => 'Versión actual';

  @override
  String get newVersionAvailable => 'Actualización disponible';

  @override
  String get latestVersionLabel => 'Última versión';

  @override
  String get updateContentLabel => 'Detalles de la actualización';

  @override
  String get officialWebsite => 'Sitio web oficial';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Unidad en la nube';

  @override
  String get ignoreThisVersion => 'Ignorar esta versión';

  @override
  String get openUpdatesFailed => 'No se pudo abrir el enlace de actualización';

  @override
  String get updateCheckFailedTitle =>
      'Falló la comprobación de actualizaciones';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'Repositorio de GitHub';

  @override
  String get openGithubFailed =>
      'No se pudo abrir el enlace del repositorio de GitHub';

  @override
  String get selectPeriodTimeSet => 'Elegir conjunto de horarios de periodos';

  @override
  String get newItem => 'Nuevo';

  @override
  String get editPeriodTimeSet => 'Editar conjunto de horarios de periodos';

  @override
  String get importTimetableFiles => 'Importar horario';

  @override
  String get importTimetableFilesDesc =>
      'Admite uno o varios archivos de horario.';

  @override
  String get importTimetableText => 'Importar horario desde texto';

  @override
  String get importTimetableTextDesc =>
      'Pega el contenido JSON del horario e impórtalo.';

  @override
  String get shareTimetableFiles => 'Compartir archivos de horario';

  @override
  String get shareTimetableFilesDesc => 'Elige primero uno o varios horarios.';

  @override
  String get saveTimetableFiles => 'Guardar archivos de horario';

  @override
  String get saveTimetableFilesDesc => 'Elige primero uno o varios horarios.';

  @override
  String get exportTimetableText => 'Exportar horario como texto';

  @override
  String get exportTimetableTextDesc =>
      'Elige uno o varios horarios y luego copia el contenido JSON.';

  @override
  String get jsonContent => 'Contenido JSON';

  @override
  String get pasteJsonContentHint => 'Pega el contenido JSON para importar.';

  @override
  String get jsonContentEmpty => 'Primero pega el contenido JSON.';

  @override
  String get copyText => 'Copiar';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get share => 'Compartir';

  @override
  String get selectTimetablesToExport => 'Elegir horarios para exportar';

  @override
  String get selectTimetablesToImport => 'Elegir horarios para importar';

  @override
  String timetableCourseCount(int count) {
    return '$count cursos';
  }

  @override
  String get importAction => 'Importar';

  @override
  String get importTimetableDialogTitle => 'Importar horario';

  @override
  String get chooseImportMethod => 'Elige cómo importar.';

  @override
  String get importAsNewTimetable => 'Importar como nuevo horario';

  @override
  String get replaceCurrentTimetable => 'Reemplazar el horario actual';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Importar conjuntos de horarios de periodos';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Este archivo contiene conjuntos de horarios de periodos incluidos. ¿Quieres importarlos y asociarlos?';

  @override
  String get importBundledPeriodTimeSets => 'Importar y asociar';

  @override
  String get discardBundledPeriodTimeSets => 'Descartar conjuntos incluidos';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'No hay ningún conjunto de horarios de periodos existente disponible, por lo que no se pueden descartar los conjuntos incluidos.';

  @override
  String savedToPath(Object path) {
    return 'Guardado en $path';
  }

  @override
  String get saveCancelled => 'Guardado cancelado';

  @override
  String get fileSaveRestrictedTitle => 'Guardado de archivos restringido';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'El sistema no pudo guardar el archivo. Puedes intentarlo de nuevo o usar compartir en su lugar.';

  @override
  String get retrySave => 'Intentar guardar de nuevo';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Activa el acceso a archivos en los ajustes del sistema y luego vuelve e intenta exportar otra vez.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get browserDownloadRestrictedTitle =>
      'Descarga del navegador restringida';

  @override
  String get browserDownloadRestrictedMessage =>
      'Este navegador no admite guardar directamente en un archivo local. Comprueba los permisos de descarga del navegador o usa el uso compartido de archivos en su lugar.';

  @override
  String get switchToShare => 'Usar compartir en su lugar';

  @override
  String get fileSaveFailedTitle => 'Falló el guardado del archivo';

  @override
  String get fileSaveFailedWindowsMessage =>
      'No se puede escribir en la ruta actual. La carpeta de destino puede estar protegida, el archivo puede estar en uso o la ruta puede no ser escribible.';

  @override
  String get fileSaveFailedGenericMessage =>
      'El sistema no pudo guardar el archivo. Puedes intentarlo de nuevo, revisar los ajustes del sistema o usar el uso compartido de archivos en su lugar.';

  @override
  String get retryLater => 'Intentarlo de nuevo más tarde';

  @override
  String get exportSwitchedToShare =>
      'Se cambió a compartir archivos para la exportación';

  @override
  String get saveFailedRetry =>
      'No se pudo guardar. Inténtalo de nuevo más tarde.';

  @override
  String get importFailedCheckContent =>
      'La importación falló. Revisa el contenido del archivo.';

  @override
  String get noImportableTimetables =>
      'No se encontraron horarios utilizables en el archivo importado.';

  @override
  String importedTimetablesCount(int count) {
    return 'Se importaron $count horarios';
  }

  @override
  String get periodTimesTitle => 'Horarios de periodos';

  @override
  String get importExport => 'Importar y exportar';

  @override
  String get importPeriodTemplate => 'Importar plantilla de periodos';

  @override
  String get importPeriodTemplateText =>
      'Importar plantilla de periodos desde texto';

  @override
  String get sharePeriodTemplate => 'Compartir plantilla de periodos';

  @override
  String get saveTemplateToFile => 'Guardar plantilla en archivo';

  @override
  String get exportPeriodTemplateText =>
      'Exportar plantilla de periodos como texto';

  @override
  String get deletePeriodTimeSet => 'Eliminar conjunto de horarios de periodos';

  @override
  String get periodTimeSetName => 'Nombre del conjunto de horarios de periodos';

  @override
  String get addOnePeriod => 'Añadir periodo';

  @override
  String periodNumberLabel(int index) {
    return 'Periodo $index';
  }

  @override
  String get deleteThisPeriod => 'Eliminar este periodo';

  @override
  String durationMinutes(int minutes) {
    return 'Duración $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Intervalo desde el anterior $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'La hora de fin debe ser posterior a la de inicio';

  @override
  String get periodOverlapPrevious =>
      'Este periodo se superpone con el anterior';

  @override
  String get periodTimesSaved => 'Horarios de periodos guardados';

  @override
  String get deletePeriodTimeSetTitle =>
      'Eliminar conjunto de horarios de periodos';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'conjunto actual de horarios de periodos';

  @override
  String importedPeriodTimesCount(int count) {
    return 'Se importaron $count horarios de periodos';
  }

  @override
  String get periodFilePermissionTitle => 'Se necesita permiso de archivos';

  @override
  String get androidFilePermissionMessage =>
      'La exportación en Android requiere permiso de acceso a archivos. Concede el permiso para continuar guardando.';

  @override
  String get reauthorize => 'Autorizar de nuevo';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Permiso denegado permanentemente';

  @override
  String get permissionSettingsExportMessage =>
      'Activa el acceso a archivos en los ajustes del sistema y luego vuelve e intenta exportar otra vez.';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get privacyPolicyEntryDesc =>
      'Descubre cómo la app gestiona el almacenamiento local, la configuración de sitios escolares, la importación/exportación de archivos, el análisis de páginas web y los enlaces externos.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Versión aceptada: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'Sked es una herramienta de horarios que prioriza el almacenamiento local. Los horarios, conjuntos de periodos y configuración de sitios escolares se almacenan solo en tu dispositivo o navegador y nunca se suben automáticamente. La app solo procesa datos cuando activas explícitamente acciones como importar, analizar páginas web, compartir o abrir enlaces externos. La política de privacidad completa está disponible en línea.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Almacenamiento local';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Los datos del horario y los ajustes relacionados se almacenan en un archivo local llamado Sked_data.json dentro del directorio de documentos de la app. La configuración editable de sitios escolares se almacena por separado en Sked_school_sites.json. Los ajustes personalizados del analizador de horarios, incluidos cualquier Base URL personalizada, API key y modelo seleccionado, también se almacenan localmente en los mismos datos de la app y no están protegidos por un almacén de credenciales del sistema. Cuando se usa en un navegador, el mismo tipo de datos se almacena en el almacenamiento del navegador. La app no sube automáticamente estos datos locales a un servidor controlado por el desarrollador.';

  @override
  String get privacyPolicyImportExportTitle => 'Importación y exportación';

  @override
  String get privacyPolicyImportExportBody =>
      'La app lee o escribe archivos JSON de horarios, archivos JSON de sitios escolares y archivos de plantillas de periodos solo cuando eliges explícitamente un archivo o inicias una acción de exportación. Importar estos archivos es una operación local a menos que también elijas el análisis de páginas web. Obtener una lista de modelos personalizados también es una acción de red explícita y solo contacta el endpoint personalizado que configuraste.';

  @override
  String get privacyPolicySharingTitle => 'Compartir';

  @override
  String get privacyPolicySharingBody =>
      'Cuando usas explícitamente compartir, la app pasa el archivo exportado a la hoja de compartir del sistema o a la app de destino que elijas. Cómo se maneja ese archivo después depende de la app o del servicio de destino que hayas seleccionado.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Enlaces externos';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Cuando abres enlaces externos como el repositorio de GitHub, la app entrega la acción a tu navegador u otra aplicación externa. El tratamiento de los datos a partir de ese momento se rige por el tercero que abras.';

  @override
  String get privacyPolicyNoCollectionTitle => 'Qué no recopila la app';

  @override
  String get privacyPolicyNoCollectionBody =>
      'La app no requiere una cuenta de Sked y no habilita análisis, identificadores publicitarios ni copia de seguridad en la nube. Tampoco ofrece un campo dedicado para recopilar contraseñas de cuentas escolares. Si inicias sesión en un sitio web escolar dentro de la app, esa interacción ocurre en la página escolar que abriste.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Análisis de páginas web';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Cuando usas la importación desde páginas web escolares o pegas HTML para analizarlo, la app primero comprime el contenido localmente y luego envía el contenido de la página enviada, el título y la URL opcionales, el idioma actual de la app y el contenido del prompt del analizador al endpoint de análisis seleccionado. Si usas el analizador oficial, la solicitud va al backend oficial configurado por la app. Si habilitas un analizador personalizado compatible con OpenAI, el mismo contenido se envía directamente al endpoint de terceros que configuraste, y obtener la lista de modelos también solicita ese mismo endpoint. Un endpoint personalizado puede reenviar la solicitud a otros servicios de IA según el diseño propio de ese proveedor. El backend oficial desplegado actualmente limita cada carga enviada a 300KB, usa su tiempo de espera configurado y permite como máximo 5 solicitudes de análisis por IP al día.';

  @override
  String get privacyPolicyUpdatesTitle => 'Actualizaciones de la política';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'La versión actual de la política de privacidad es $version. Si una versión posterior cambia la forma en que se manejan los datos, la app puede pedirte que leas y aceptes la política actualizada de nuevo.';
  }

  @override
  String get privacyGateTitle =>
      'Acepta la política de privacidad antes de usar la app';

  @override
  String get privacyGateSummaryStorage =>
      'Los horarios, los conjuntos de horarios de periodos y la configuración de sitios escolares solo se almacenan localmente y no se suben automáticamente a un servidor del desarrollador.';

  @override
  String get privacyGateSummaryImportExport =>
      'La importación, exportación y el uso compartido solo ocurren cuando los inicias explícitamente; el análisis de páginas web envía solo el contenido comprimido que envías al endpoint de análisis configurado, y puedes revisar el horario analizado antes de guardarlo.';

  @override
  String get privacyGateSummaryUpdates =>
      'Si una versión posterior cambia la forma en que se manejan los datos, la app puede pedirte que revises la política de privacidad actualizada de nuevo.';

  @override
  String get schoolWebImportEntry => 'Importar desde página web escolar';

  @override
  String get schoolWebImportEntryDesc =>
      'Importa la página actual del horario desde el sitio escolar.';

  @override
  String get schoolSitesManageEntry => 'Gestionar sitios escolares';

  @override
  String get schoolSitesManageEntryDesc =>
      'Añade, edita y elimina URLs de inicio de sesión escolar, con importación y exportación JSON.';

  @override
  String get schoolSitesPageTitle => 'Gestión de sitios escolares';

  @override
  String get schoolSitesImportJson => 'Importar JSON de escuelas';

  @override
  String get schoolSitesShareJson => 'Compartir JSON de escuelas';

  @override
  String get schoolSitesSaveJson => 'Guardar JSON de escuelas';

  @override
  String get schoolSitesSaved => 'Sitios escolares guardados';

  @override
  String get schoolSitesImported => 'Sitios escolares importados';

  @override
  String get schoolSitesEmpty =>
      'Aún no hay configuración de sitios escolares.';

  @override
  String get schoolSitesNameLabel => 'Nombre de la escuela';

  @override
  String get schoolSitesLoginUrlLabel => 'URL de inicio de sesión';

  @override
  String get schoolSitesAdd => 'Añadir escuela';

  @override
  String get schoolSitesEdit => 'Editar escuela';

  @override
  String get schoolSitesDeleteTitle => 'Eliminar escuela';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Primero completa el nombre de la escuela y la URL de inicio de sesión.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importar pegando el contenido de la página del horario';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Pega manualmente el código fuente o el contenido sin procesar de la página que contiene información del horario.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analizar horario desde el contenido de la página';

  @override
  String get schoolHtmlImportUrlLabel => 'URL de origen (opcional)';

  @override
  String get schoolHtmlImportTitleLabel => 'Título de la página (opcional)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Contenido de la página';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Pega aquí el código fuente o el contenido sin procesar de la página que contiene información del horario.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Se puede analizar e importar cualquier contenido que contenga información del horario, no solo HTML.';

  @override
  String get schoolHtmlImportCompress => 'Comprimir contenido';

  @override
  String get schoolHtmlImportCompressed => 'Contenido comprimido';

  @override
  String get schoolHtmlImportCompressFirst => 'Primero comprime el contenido.';

  @override
  String get schoolHtmlImportSubmit => 'Analizar e importar';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'El análisis puede tardar un poco. Espera, por favor.';

  @override
  String get schoolHtmlImportEmpty => 'Primero pega el HTML de la página.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Volver a la página web';

  @override
  String get schoolWebImportPageTitle => 'Importación desde página web escolar';

  @override
  String get schoolWebImportPreview => 'Vista previa de importación';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count cursos';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count periodos';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Título de la página';

  @override
  String get schoolWebImportParserUsed => 'Analizador';

  @override
  String get schoolWebImportWarnings => 'Notas de importación';

  @override
  String get schoolWebImportOpenPageHint =>
      'Inicia sesión en el sitio escolar dentro de la app y luego navega manualmente a la página del horario.';

  @override
  String get schoolWebImportConfigMissing =>
      'La API del backend de importación web aún no está configurada.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Esta plataforma aún no admite el inicio de sesión web incrustado. Usa una plataforma con compatibilidad con WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Elegir escuela';

  @override
  String get schoolWebImportNoSchools =>
      'No hay ninguna configuración de escuela disponible. Revisa primero school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'No se pudo cargar la configuración de la escuela. Revisa el formato del archivo JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importar la página actual';

  @override
  String get schoolWebImportGoBack => 'Página anterior';

  @override
  String get schoolWebImportLoadingPage => 'Cargando página…';

  @override
  String get schoolWebImportParsing => 'Analizando la página actual…';

  @override
  String get schoolWebImportLoadFailed =>
      'No se pudo cargar la página. Actualiza o inténtalo de nuevo más tarde.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'Se agotó el tiempo de carga de la página. Actualiza e inténtalo de nuevo.';

  @override
  String get schoolWebImportEmptyPage =>
      'El contenido actual de la página está vacío y aún no se puede importar.';

  @override
  String get schoolWebImportSuccess => 'Horario web importado';

  @override
  String get schoolImportParserSettingsTitle =>
      'Ajustes del analizador de horarios';

  @override
  String get schoolImportParserSettingsDesc =>
      'Elige el analizador oficial o un endpoint personalizado compatible con OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Fuente del analizador';

  @override
  String get schoolImportParserSourceOfficial => 'Analizador oficial';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Usa el servicio de análisis oficial integrado configurado por la app.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'El analizador oficial usa el backend de análisis configurado por la app y mantiene sin cambios el flujo de importación actual.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Compatible con OpenAI personalizado';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Envía el contenido de la página directamente a tu propio endpoint compatible con OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Analizador personalizado compatible con OpenAI';

  @override
  String get schoolImportParserCustomPromptTitle => 'Prompt personalizado';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Edita aquí el prompt integrado del analizador. Los cambios solo afectan al analizador personalizado compatible con OpenAI.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'El prompt integrado se carga aquí por defecto. Bórralo para volver a la versión integrada.';

  @override
  String get schoolImportParserResetDefaultPrompt =>
      'Restablecer prompt predeterminado';

  @override
  String get schoolImportParserBaseUrl => 'Base URL';

  @override
  String get schoolImportParserApiKey => 'API key';

  @override
  String get schoolImportParserModel => 'Modelo';

  @override
  String get schoolImportParserFetchModels => 'Obtener lista de modelos';

  @override
  String get schoolImportParserFetchingModels => 'Obteniendo modelos...';

  @override
  String get schoolImportParserNoModelsFound =>
      'El endpoint no devolvió ningún modelo.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return 'Se obtuvieron $count modelos';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'La API key personalizada se almacena en texto plano en la configuración local de la app con la implementación actual. Úsala solo en un dispositivo o entorno de navegador en el que confíes.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'La configuración del analizador personalizado está incompleta. Primero completa Base URL, API key y modelo.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Analizador: Oficial';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Analizador: Personalizado ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Ver la política de privacidad completa';

  @override
  String get privacyAgreeAndContinue => 'Aceptar y continuar';

  @override
  String get privacyDecline => 'Rechazar';

  @override
  String get privacyDeclineWebHint =>
      'Este entorno del navegador no permite que la app cierre la página por ti. Si no aceptas, cierra esta pestaña o ventana manualmente.';

  @override
  String get defaultPeriodTimeSetName => 'Periodos predeterminados';

  @override
  String get periodTimeSetFallbackName => 'Horarios de periodos';

  @override
  String get untitledTimetableName => 'Horario sin título';

  @override
  String get newTimetableName => 'Nuevo horario';

  @override
  String get newPeriodTimeSetName => 'Nuevo conjunto de horarios de periodos';

  @override
  String get emptyTimetableName => 'Horario vacío';

  @override
  String importedPeriodTimeSetName(Object name) {
    return 'Periodos de $name';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'El tipo de archivo importado no coincide.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Esta versión del archivo importado aún no es compatible.';

  @override
  String get noPeriodTimesInImportMessage =>
      'No se encontraron horarios de periodos en el archivo importado.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Selecciona al menos un horario.';

  @override
  String get noExportableTimetableMessage =>
      'No hay ningún horario disponible para exportar.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Reemplazar el horario actual solo permite seleccionar un horario.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'No hay un horario actual para reemplazar.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Este conjunto de horarios de periodos todavía está siendo usado por $count horario(s). Reasígnalos antes de eliminarlo.';
  }

  @override
  String get weekdayMonday => 'Lunes';

  @override
  String get weekdayTuesday => 'Martes';

  @override
  String get weekdayWednesday => 'Miércoles';

  @override
  String get weekdayThursday => 'Jueves';

  @override
  String get weekdayFriday => 'Viernes';

  @override
  String get weekdaySaturday => 'Sábado';

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get weekdayShortMonday => 'Lun';

  @override
  String get weekdayShortTuesday => 'Mar';

  @override
  String get weekdayShortWednesday => 'Mié';

  @override
  String get weekdayShortThursday => 'Jue';

  @override
  String get weekdayShortFriday => 'Vie';

  @override
  String get weekdayShortSaturday => 'Sáb';

  @override
  String get weekdayShortSunday => 'Dom';

  @override
  String get monthJanuary => 'Ene';

  @override
  String get monthFebruary => 'Feb';

  @override
  String get monthMarch => 'Mar';

  @override
  String get monthApril => 'Abr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'Jul';

  @override
  String get monthAugust => 'Ago';

  @override
  String get monthSeptember => 'Sep';

  @override
  String get monthOctober => 'Oct';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Dic';

  @override
  String get semesterWeeksWholeTerm => 'Todo el semestre';

  @override
  String semesterWeeksRange(Object start, Object end) {
    return 'Semanas $start-$end';
  }

  @override
  String semesterWeeksList(Object value) {
    return 'Semanas $value';
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
