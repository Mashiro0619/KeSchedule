// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Sked';

  @override
  String weekLabel(int week) {
    return 'Semana $week';
  }

  @override
  String get addCourse => 'Adicionar disciplina';

  @override
  String get settings => 'Configurações';

  @override
  String get multiTimetableSwitch => 'Alternar horários';

  @override
  String currentTimetableWeeks(int weeks) {
    return 'Horário atual · $weeks semanas';
  }

  @override
  String tapToSwitchWeeks(int weeks) {
    return 'Toque para alternar · $weeks semanas';
  }

  @override
  String get editTimetable => 'Editar horário';

  @override
  String get createTimetable => 'Novo horário';

  @override
  String get jumpToWeek => 'Ir para a semana';

  @override
  String get timetable => 'Horário';

  @override
  String get timetableName => 'Nome do horário';

  @override
  String get totalWeeks => 'Total de semanas';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get deleteTimetableTitle => 'Excluir horário';

  @override
  String deleteTimetableMessage(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get noTimetableTitle => 'Ainda não há horário';

  @override
  String get noTimetableMessage =>
      'Crie um horário ou importe um de um arquivo JSON.';

  @override
  String get importTimetable => 'Importar horário';

  @override
  String get courseName => 'Nome da disciplina';

  @override
  String get location => 'Local';

  @override
  String get dayOfWeek => 'Dia';

  @override
  String get semesterWeeks => 'Semanas';

  @override
  String get startTime => 'Horário de início';

  @override
  String get endTime => 'Horário de término';

  @override
  String get linkedPeriods => 'Períodos vinculados';

  @override
  String get linkedPeriodsUnmatched =>
      'Nenhum período corresponde ao horário atual. Toque para escolher manualmente.';

  @override
  String periodRangeLabel(int start, int end) {
    return 'Período $start-$end';
  }

  @override
  String get teacherName => 'Professor';

  @override
  String get credits => 'Créditos';

  @override
  String get remarks => 'Observações';

  @override
  String get customFields => 'Campos personalizados';

  @override
  String get customFieldsHint => 'Um por linha, formato: chave:valor';

  @override
  String get selectDayOfWeek => 'Escolher dia';

  @override
  String get selectSemesterWeeks => 'Escolher semanas';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get clear => 'Limpar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get selectLinkedPeriods => 'Escolher períodos vinculados';

  @override
  String get addCourseTitle => 'Adicionar disciplina';

  @override
  String get editCourseTitle => 'Editar disciplina';

  @override
  String get editCourseTooltip => 'Editar disciplina';

  @override
  String get place => 'Local';

  @override
  String get time => 'Horário';

  @override
  String get notFilled => 'Não preenchido';

  @override
  String get none => 'Nenhum';

  @override
  String get conflictCourses => 'Disciplinas em conflito';

  @override
  String get locationNotFilled => 'Local não preenchido';

  @override
  String get setAsDisplayed => 'Definir como exibido';

  @override
  String get editThisCourse => 'Editar esta disciplina';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get noTimetableSettings =>
      'Nenhum horário está disponível no momento para configurações.';

  @override
  String get semesterStartDate => 'Data de início do semestre';

  @override
  String get periodTimeSets => 'Conjunto de horários dos períodos';

  @override
  String get noPeriodTimeAvailable =>
      'Nenhum conjunto de horários dos períodos disponível';

  @override
  String periodTimeSetSummary(Object name, int count) {
    return '$name · $count períodos';
  }

  @override
  String get coursePopupDismissSetting =>
      'Permitir toque fora para fechar o pop-up da disciplina';

  @override
  String get coursePopupDismissSettingHint =>
      'Desativar isso também desativa o fechamento ao deslizar para baixo.';

  @override
  String get preserveTimetableGaps => 'Preservar intervalos no horário';

  @override
  String get preserveTimetableGapsHint =>
      'Quando desativado, os intervalos de almoço e descanso são recolhidos para que as aulas seguintes subam.';

  @override
  String get showPastEndedCourses => 'Mostrar disciplinas já encerradas';

  @override
  String get showPastEndedCoursesHint =>
      'Mostra disciplinas que já terminaram na semana atual real com um estilo cinza mais claro.';

  @override
  String get showFutureCourses => 'Mostrar disciplinas futuras';

  @override
  String get showFutureCoursesHint =>
      'Mostra disciplinas que não estão ativas nesta semana, mas aparecerão nas semanas seguintes, com um estilo cinza.';

  @override
  String get timetableDisplaySettings => 'Exibição e interação do horário';

  @override
  String get timetableDisplaySettingsDesc =>
      'Fechamento do pop-up, intervalos, disciplinas em cinza e linhas da grade';

  @override
  String get showTimetableGridLines => 'Mostrar linhas da grade do horário';

  @override
  String get showTimetableGridLinesHint =>
      'Controla se as linhas horizontais e verticais da grade ficam visíveis no horário.';

  @override
  String get liveCourseOutlineColor => 'Cor do contorno da disciplina';

  @override
  String get liveCourseOutlineColorHint =>
      'Escolha se os contornos destacam a disciplina atual/próxima ou todas as disciplinas exibidas na página atual.';

  @override
  String get liveCourseOutlineSettings => 'Contorno da disciplina';

  @override
  String get liveCourseOutlineSettingsHint =>
      'Configure se o contorno está ativado, o que ele destaca, se segue a cor do tema e qual é a cor efetiva do contorno.';

  @override
  String get liveCourseOutlineEnabled => 'Ativar contorno';

  @override
  String get liveCourseOutlineFollowTheme => 'Seguir a cor do tema';

  @override
  String get liveCourseOutlineTarget => 'Alvo do contorno';

  @override
  String get liveCourseOutlineTargetCurrentOrNext => 'Disciplina atual/próxima';

  @override
  String get liveCourseOutlineTargetAllDisplayed =>
      'Todas as disciplinas exibidas';

  @override
  String get liveCourseOutlineEffectiveColor => 'Cor efetiva';

  @override
  String get liveCourseOutlineCustomColor => 'Cor personalizada do contorno';

  @override
  String get liveCourseOutlineWidth => 'Largura do contorno';

  @override
  String get outlineWidthUnit => 'px';

  @override
  String get language => 'Idioma';

  @override
  String get languagePageDescription =>
      'Escolha um dos idiomas que realmente estão disponíveis no app.';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get githubRepositoryUrl => 'github.com/Mashiro0619/Sked';

  @override
  String get apiResponseTitle => 'Resposta da API';

  @override
  String get theme => 'Tema';

  @override
  String get themeFollowSystem => 'Seguir o sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeColor => 'Cor do tema';

  @override
  String get themeColorModeSingle => 'Uma única cor de tema';

  @override
  String get themeColorModeColorful => 'Colorido';

  @override
  String get themeColorUiColors => 'Cores da interface';

  @override
  String get themeColorCourseColors => 'Cores das disciplinas';

  @override
  String get themeColorPrimary => 'Primária';

  @override
  String get themeColorSecondary => 'Secundária';

  @override
  String get themeColorTertiary => 'Terciária';

  @override
  String get themeColorCourseText => 'Texto da disciplina';

  @override
  String get themeColorCourseTextAuto => 'Automático';

  @override
  String get themeColorCourseTextCustom => 'Cor personalizada';

  @override
  String get themeColorCourseColorsEmpty =>
      'As cores das disciplinas serão geradas após importar um horário.';

  @override
  String get themeCustomColor => 'Cor personalizada';

  @override
  String get themeApplyCustomColor => 'Aplicar cor';

  @override
  String get themeApplySettings => 'Aplicar configurações';

  @override
  String get dataImportExport => 'Importar e exportar dados';

  @override
  String get dataImportExportDesc =>
      'Importe todos os dados ou horários individuais, ou exporte o horário atual/todos os horários.';

  @override
  String get openSourceLicenses => 'Licenças de código aberto';

  @override
  String get openSourceLicensesDesc =>
      'Veja as licenças das dependências do Flutter e dos recursos do ícone do app incluídos.';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get checkForUpdatesDesc => 'GitHub';

  @override
  String alreadyLatestVersion(Object version) {
    return 'Já está na versão mais recente ($version)';
  }

  @override
  String get currentVersionLabel => 'Versão atual';

  @override
  String get newVersionAvailable => 'Atualização disponível';

  @override
  String get latestVersionLabel => 'Versão mais recente';

  @override
  String get updateContentLabel => 'Detalhes da atualização';

  @override
  String get officialWebsite => 'Site oficial';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get cloudDrive => 'Nuvem';

  @override
  String get ignoreThisVersion => 'Ignorar esta versão';

  @override
  String get openUpdatesFailed =>
      'Não foi possível abrir o link de atualização';

  @override
  String get updateCheckFailedTitle => 'Falha ao verificar atualizações';

  @override
  String get updateCheckFailedMessage =>
      'Unable to fetch the latest version from GitHub. You can still open GitHub Releases below.';

  @override
  String get githubRepository => 'Repositório no GitHub';

  @override
  String get openGithubFailed =>
      'Não foi possível abrir o link do repositório no GitHub';

  @override
  String get selectPeriodTimeSet =>
      'Escolher conjunto de horários dos períodos';

  @override
  String get newItem => 'Novo';

  @override
  String get editPeriodTimeSet => 'Editar conjunto de horários dos períodos';

  @override
  String get importTimetableFiles => 'Importar horário';

  @override
  String get importTimetableFilesDesc =>
      'Suporta um ou vários arquivos de horário.';

  @override
  String get importTimetableText => 'Importar horário a partir de texto';

  @override
  String get importTimetableTextDesc =>
      'Cole o conteúdo JSON do horário e importe.';

  @override
  String get shareTimetableFiles => 'Compartilhar arquivos de horário';

  @override
  String get shareTimetableFilesDesc => 'Escolha um ou mais horários primeiro.';

  @override
  String get saveTimetableFiles => 'Salvar arquivos de horário';

  @override
  String get saveTimetableFilesDesc => 'Escolha um ou mais horários primeiro.';

  @override
  String get exportTimetableText => 'Exportar horário como texto';

  @override
  String get exportTimetableTextDesc =>
      'Escolha um ou mais horários e depois copie o conteúdo JSON.';

  @override
  String get jsonContent => 'Conteúdo JSON';

  @override
  String get pasteJsonContentHint => 'Cole o conteúdo JSON para importar.';

  @override
  String get jsonContentEmpty => 'Cole primeiro o conteúdo JSON.';

  @override
  String get copyText => 'Copiar';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get share => 'Compartilhar';

  @override
  String get selectTimetablesToExport => 'Escolher horários para exportar';

  @override
  String get selectTimetablesToImport => 'Escolher horários para importar';

  @override
  String timetableCourseCount(int count) {
    return '$count disciplinas';
  }

  @override
  String get importAction => 'Importar';

  @override
  String get importTimetableDialogTitle => 'Importar horário';

  @override
  String get chooseImportMethod => 'Escolha como importar.';

  @override
  String get importAsNewTimetable => 'Importar como novo horário';

  @override
  String get replaceCurrentTimetable => 'Substituir o horário atual';

  @override
  String get importPeriodTimeSetDialogTitle =>
      'Importar conjuntos de horários dos períodos';

  @override
  String get importPeriodTimeSetDialogBody =>
      'Este arquivo contém conjuntos de horários dos períodos incluídos. Deseja importá-los e associá-los?';

  @override
  String get importBundledPeriodTimeSets => 'Importar e associar';

  @override
  String get discardBundledPeriodTimeSets => 'Descartar conjuntos incluídos';

  @override
  String get importDiscardPeriodTimeSetUnavailable =>
      'Nenhum conjunto de horários dos períodos existente está disponível, portanto os conjuntos incluídos não podem ser descartados.';

  @override
  String savedToPath(Object path) {
    return 'Salvo em $path';
  }

  @override
  String get saveCancelled => 'Salvamento cancelado';

  @override
  String get fileSaveRestrictedTitle => 'Salvamento de arquivo restrito';

  @override
  String get fileSaveRestrictedRetryMessage =>
      'O sistema não pôde salvar o arquivo. Você pode tentar novamente ou usar o compartilhamento.';

  @override
  String get retrySave => 'Tentar salvar novamente';

  @override
  String get fileSaveRestrictedSettingsMessage =>
      'Ative o acesso a arquivos nas configurações do sistema e depois volte para tentar exportar novamente.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get browserDownloadRestrictedTitle => 'Download no navegador restrito';

  @override
  String get browserDownloadRestrictedMessage =>
      'Este navegador não oferece suporte para salvar diretamente em um arquivo local. Verifique as permissões de download do navegador ou use o compartilhamento de arquivos.';

  @override
  String get switchToShare => 'Usar compartilhamento em vez disso';

  @override
  String get fileSaveFailedTitle => 'Falha ao salvar arquivo';

  @override
  String get fileSaveFailedWindowsMessage =>
      'Não foi possível gravar no caminho atual. A pasta de destino pode estar protegida, o arquivo pode estar em uso ou o caminho pode não permitir gravação.';

  @override
  String get fileSaveFailedGenericMessage =>
      'O sistema não pôde salvar o arquivo. Você pode tentar novamente, verificar as configurações do sistema ou usar o compartilhamento de arquivos.';

  @override
  String get retryLater => 'Tente novamente mais tarde';

  @override
  String get exportSwitchedToShare =>
      'Exportação alterada para compartilhamento de arquivos';

  @override
  String get saveFailedRetry => 'Falha ao salvar. Tente novamente mais tarde.';

  @override
  String get importFailedCheckContent =>
      'Falha na importação. Verifique o conteúdo do arquivo.';

  @override
  String get noImportableTimetables =>
      'Nenhum horário utilizável foi encontrado no arquivo importado.';

  @override
  String importedTimetablesCount(int count) {
    return '$count horários importados';
  }

  @override
  String get periodTimesTitle => 'Horários dos períodos';

  @override
  String get importExport => 'Importar e exportar';

  @override
  String get importPeriodTemplate => 'Importar modelo de períodos';

  @override
  String get importPeriodTemplateText =>
      'Importar modelo de períodos a partir de texto';

  @override
  String get sharePeriodTemplate => 'Compartilhar modelo de períodos';

  @override
  String get saveTemplateToFile => 'Salvar modelo em arquivo';

  @override
  String get exportPeriodTemplateText =>
      'Exportar modelo de períodos como texto';

  @override
  String get deletePeriodTimeSet => 'Excluir conjunto de horários dos períodos';

  @override
  String get periodTimeSetName => 'Nome do conjunto de horários dos períodos';

  @override
  String get addOnePeriod => 'Adicionar período';

  @override
  String periodNumberLabel(int index) {
    return 'Período $index';
  }

  @override
  String get deleteThisPeriod => 'Excluir este período';

  @override
  String durationMinutes(int minutes) {
    return 'Duração $minutes min';
  }

  @override
  String gapFromPrevious(int minutes) {
    return 'Intervalo desde o anterior $minutes min';
  }

  @override
  String get endTimeMustBeLater =>
      'O horário de término deve ser posterior ao de início';

  @override
  String get periodOverlapPrevious => 'Este período se sobrepõe ao anterior';

  @override
  String get periodTimesSaved => 'Horários dos períodos salvos';

  @override
  String get deletePeriodTimeSetTitle =>
      'Excluir conjunto de horários dos períodos';

  @override
  String deletePeriodTimeSetMessage(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get currentPeriodTimeSet => 'conjunto atual de horários dos períodos';

  @override
  String importedPeriodTimesCount(int count) {
    return '$count horários de períodos importados';
  }

  @override
  String get periodFilePermissionTitle => 'Permissão de arquivo necessária';

  @override
  String get androidFilePermissionMessage =>
      'A exportação no Android exige permissão de acesso a arquivos. Conceda a permissão para continuar salvando.';

  @override
  String get reauthorize => 'Autorizar novamente';

  @override
  String get permissionPermanentlyDeniedTitle =>
      'Permissão negada permanentemente';

  @override
  String get permissionSettingsExportMessage =>
      'Ative o acesso a arquivos nas configurações do sistema e depois volte para tentar exportar novamente.';

  @override
  String get privacyPolicyTitle => 'Política de Privacidade';

  @override
  String get privacyPolicyEntryDesc =>
      'Saiba como o app lida com armazenamento local, configuração de sites escolares, importação/exportação de arquivos, análise de páginas web e links externos.';

  @override
  String privacyPolicyAcceptedVersionLabel(Object version) {
    return 'Versão aceita: $version';
  }

  @override
  String get privacyPolicyIntro =>
      'O Sked é uma ferramenta de horários com foco local. Os horários, conjuntos de períodos e configurações de sites escolares são armazenados apenas no seu dispositivo ou navegador e nunca são enviados automaticamente. O app só processa dados quando você aciona explicitamente ações como importar, analisar páginas web, compartilhar ou abrir links externos. A política de privacidade completa está disponível online.';

  @override
  String get privacyPolicyLocalStorageTitle => 'Armazenamento local';

  @override
  String get privacyPolicyLocalStorageBody =>
      'Os dados do horário e as configurações relacionadas são armazenados em um arquivo local chamado Sked_data.json dentro do diretório de documentos do app. A configuração editável de sites escolares é armazenada separadamente em Sked_school_sites.json. As configurações personalizadas do analisador de horários, incluindo qualquer URL base personalizada, chave de API e modelo selecionado, também são armazenadas localmente nos mesmos dados do app e não são protegidas por um cofre de credenciais do sistema. Quando usado em um navegador, os mesmos tipos de dados são armazenados no armazenamento do navegador. O app não envia automaticamente esses dados locais para um servidor controlado pelo desenvolvedor.';

  @override
  String get privacyPolicyImportExportTitle => 'Importação e exportação';

  @override
  String get privacyPolicyImportExportBody =>
      'O app lê ou grava arquivos JSON de horário, arquivos JSON de sites escolares e arquivos de modelo de períodos somente quando você escolhe explicitamente um arquivo ou inicia uma ação de exportação. Importar esses arquivos é uma operação local, a menos que você também escolha a análise de página web. Buscar uma lista de modelos personalizados também é uma ação de rede explícita e contata apenas o endpoint personalizado que você configurou.';

  @override
  String get privacyPolicySharingTitle => 'Compartilhamento';

  @override
  String get privacyPolicySharingBody =>
      'Quando você usa o compartilhamento explicitamente, o app passa o arquivo exportado para a folha de compartilhamento do sistema ou para o app de destino que você escolher. Como esse arquivo será tratado depois disso depende do app ou serviço de destino selecionado.';

  @override
  String get privacyPolicyExternalLinksTitle => 'Links externos';

  @override
  String get privacyPolicyExternalLinksBody =>
      'Quando você abre links externos, como o repositório do GitHub, o app entrega essa ação ao seu navegador ou a outro aplicativo externo. O tratamento de dados a partir desse ponto é regido pelo terceiro que você abrir.';

  @override
  String get privacyPolicyNoCollectionTitle => 'O que o app não coleta';

  @override
  String get privacyPolicyNoCollectionBody =>
      'O app não exige uma conta do Sked e não ativa análise, identificadores de publicidade nem backup em nuvem. Ele também não fornece um campo dedicado para coletar senhas de contas escolares. Se você entrar em um site escolar dentro do app, essa interação acontece na página escolar que você abriu.';

  @override
  String get privacyPolicyFutureFeatureTitle => 'Análise de página web';

  @override
  String get privacyPolicyFutureFeatureBody =>
      'Quando você usa a importação por página web da escola ou cola HTML para análise, o app primeiro comprime o conteúdo localmente e depois envia o conteúdo da página enviada, o título e a URL opcionais, o idioma atual do app e o conteúdo do prompt do analisador para o endpoint de análise selecionado. Se você usar o analisador oficial, a solicitação vai para o backend oficial configurado do app. Se ativar um analisador personalizado compatível com OpenAI, o mesmo conteúdo será enviado diretamente ao endpoint de terceiros que você configurou, e a busca da lista de modelos também consultará esse mesmo endpoint. Um endpoint personalizado pode encaminhar a solicitação para outros serviços de IA conforme o próprio design desse provedor. O backend oficial implantado atualmente limita cada carga enviada a 300 KB, usa o tempo limite configurado e permite no máximo 5 solicitações de análise por IP por dia.';

  @override
  String get privacyPolicyUpdatesTitle => 'Atualizações da política';

  @override
  String privacyPolicyUpdatesBody(Object version) {
    return 'A versão atual da política de privacidade é $version. Se uma versão posterior alterar como os dados são tratados, o app poderá pedir que você leia e concorde novamente com a política atualizada.';
  }

  @override
  String get privacyGateTitle =>
      'Concorde com a política de privacidade antes de usar o app';

  @override
  String get privacyGateSummaryStorage =>
      'Horários, conjuntos de horários dos períodos e configurações de sites escolares são armazenados apenas localmente e não são enviados automaticamente para um servidor do desenvolvedor.';

  @override
  String get privacyGateSummaryImportExport =>
      'Importação, exportação e compartilhamento só acontecem quando você os inicia explicitamente; a análise de página web envia apenas o conteúdo compactado que você enviar ao endpoint configurado, e você pode revisar o horário analisado antes de salvar.';

  @override
  String get privacyGateSummaryUpdates =>
      'Se uma versão posterior alterar como os dados são tratados, o app poderá pedir que você revise novamente a política de privacidade atualizada.';

  @override
  String get schoolWebImportEntry => 'Importar da página web da escola';

  @override
  String get schoolWebImportEntryDesc =>
      'Importe a página atual do horário a partir do site da escola.';

  @override
  String get schoolSitesManageEntry => 'Gerenciar sites escolares';

  @override
  String get schoolSitesManageEntryDesc =>
      'Adicione, edite e exclua URLs de login escolar, com importação e exportação em JSON.';

  @override
  String get schoolSitesPageTitle => 'Gerenciamento de sites escolares';

  @override
  String get schoolSitesImportJson => 'Importar JSON de escolas';

  @override
  String get schoolSitesShareJson => 'Compartilhar JSON de escolas';

  @override
  String get schoolSitesSaveJson => 'Salvar JSON de escolas';

  @override
  String get schoolSitesSaved => 'Sites escolares salvos';

  @override
  String get schoolSitesImported => 'Sites escolares importados';

  @override
  String get schoolSitesEmpty => 'Ainda não há configuração de site escolar.';

  @override
  String get schoolSitesNameLabel => 'Nome da escola';

  @override
  String get schoolSitesLoginUrlLabel => 'URL de login';

  @override
  String get schoolSitesAdd => 'Adicionar escola';

  @override
  String get schoolSitesEdit => 'Editar escola';

  @override
  String get schoolSitesDeleteTitle => 'Excluir escola';

  @override
  String schoolSitesDeleteMessage(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get schoolSitesFormInvalid =>
      'Preencha primeiro o nome da escola e a URL de login.';

  @override
  String get schoolSitesJsonFileName => 'Sked_school_sites.json';

  @override
  String get schoolHtmlImportEntry =>
      'Importar colando o conteúdo da página do horário';

  @override
  String get schoolHtmlImportEntryDesc =>
      'Cole manualmente o código-fonte ou o conteúdo bruto da página que contém as informações do horário.';

  @override
  String get schoolHtmlImportPageTitle =>
      'Analisar horário a partir do conteúdo da página';

  @override
  String get schoolHtmlImportUrlLabel => 'URL de origem (opcional)';

  @override
  String get schoolHtmlImportTitleLabel => 'Título da página (opcional)';

  @override
  String get schoolHtmlImportHtmlLabel => 'Conteúdo da página';

  @override
  String get schoolHtmlImportHtmlHint =>
      'Cole aqui o código-fonte ou o conteúdo bruto da página que contém as informações do horário.';

  @override
  String get schoolHtmlImportNonHtmlHint =>
      'Qualquer conteúdo que contenha informações do horário pode ser analisado e importado, não apenas HTML.';

  @override
  String get schoolHtmlImportCompress => 'Compactar conteúdo';

  @override
  String get schoolHtmlImportCompressed => 'Conteúdo compactado';

  @override
  String get schoolHtmlImportCompressFirst => 'Compacte o conteúdo primeiro.';

  @override
  String get schoolHtmlImportSubmit => 'Analisar e importar';

  @override
  String get schoolHtmlImportParsingMayTakeLong =>
      'A análise pode demorar um pouco. Aguarde.';

  @override
  String get schoolHtmlImportEmpty => 'Cole primeiro o HTML da página.';

  @override
  String get schoolHtmlImportReturnToWebPage => 'Voltar para a página web';

  @override
  String get schoolWebImportPageTitle => 'Importação da página web da escola';

  @override
  String get schoolWebImportPreview => 'Pré-visualização da importação';

  @override
  String schoolWebImportCourseCount(int count) {
    return '$count disciplinas';
  }

  @override
  String schoolWebImportPeriodCount(int count) {
    return '$count períodos';
  }

  @override
  String get schoolWebImportPageTitleLabel => 'Título da página';

  @override
  String get schoolWebImportParserUsed => 'Analisador';

  @override
  String get schoolWebImportWarnings => 'Observações da importação';

  @override
  String get schoolWebImportOpenPageHint =>
      'Entre no site da escola dentro do app e depois navegue manualmente até a página do horário.';

  @override
  String get schoolWebImportConfigMissing =>
      'A API de backend da importação web ainda não está configurada.';

  @override
  String get schoolWebImportUnsupportedPlatform =>
      'Esta plataforma ainda não oferece suporte para login web incorporado. Use uma plataforma com suporte a WebView.';

  @override
  String get schoolWebImportSelectSchool => 'Escolher escola';

  @override
  String get schoolWebImportNoSchools =>
      'Nenhuma configuração de escola está disponível. Verifique primeiro o school_sites.json.';

  @override
  String get schoolWebImportSchoolLoadFailed =>
      'Falha ao carregar a configuração da escola. Verifique o formato do arquivo JSON.';

  @override
  String get schoolWebImportImportCurrentPage => 'Importar página atual';

  @override
  String get schoolWebImportGoBack => 'Página anterior';

  @override
  String get schoolWebImportLoadingPage => 'Carregando página…';

  @override
  String get schoolWebImportParsing => 'Analisando a página atual…';

  @override
  String get schoolWebImportLoadFailed =>
      'Falha ao carregar a página. Atualize ou tente novamente mais tarde.';

  @override
  String get schoolWebImportLoadTimedOut =>
      'O carregamento da página expirou. Atualize e tente novamente.';

  @override
  String get schoolWebImportEmptyPage =>
      'O conteúdo da página atual está vazio e ainda não pode ser importado.';

  @override
  String get schoolWebImportSuccess => 'Horário web importado';

  @override
  String get schoolImportParserSettingsTitle =>
      'Configurações do analisador de horários';

  @override
  String get schoolImportParserSettingsDesc =>
      'Escolha o analisador oficial ou um endpoint personalizado compatível com OpenAI.';

  @override
  String get schoolImportParserSourceTitle => 'Origem do analisador';

  @override
  String get schoolImportParserSourceOfficial => 'Analisador oficial';

  @override
  String get schoolImportParserSourceOfficialDesc =>
      'Use o serviço oficial de análise integrado configurado pelo app.';

  @override
  String get schoolImportParserSourceOfficialInfo =>
      'O analisador oficial usa o backend de análise configurado pelo app e mantém inalterado o fluxo atual de importação.';

  @override
  String get schoolImportParserSourceCustomOpenAi =>
      'Compatível com OpenAI personalizado';

  @override
  String get schoolImportParserSourceCustomOpenAiDesc =>
      'Envie o conteúdo da página diretamente para seu próprio endpoint compatível com OpenAI.';

  @override
  String get schoolImportParserCustomOpenAi =>
      'Analisador personalizado compatível com OpenAI';

  @override
  String get schoolImportParserCustomPromptTitle => 'Prompt personalizado';

  @override
  String get schoolImportParserCustomPromptDescription =>
      'Edite aqui o prompt integrado do analisador. As alterações afetam apenas o analisador personalizado compatível com OpenAI.';

  @override
  String get schoolImportParserCustomPromptHint =>
      'O prompt integrado é carregado aqui por padrão. Limpe-o para voltar à versão integrada.';

  @override
  String get schoolImportParserResetDefaultPrompt => 'Restaurar prompt padrão';

  @override
  String get schoolImportParserBaseUrl => 'URL base';

  @override
  String get schoolImportParserApiKey => 'Chave de API';

  @override
  String get schoolImportParserModel => 'Modelo';

  @override
  String get schoolImportParserFetchModels => 'Buscar lista de modelos';

  @override
  String get schoolImportParserFetchingModels => 'Buscando modelos...';

  @override
  String get schoolImportParserNoModelsFound =>
      'Nenhum modelo foi retornado pelo endpoint.';

  @override
  String schoolImportParserModelsFetched(int count) {
    return '$count modelos obtidos';
  }

  @override
  String get schoolImportParserPlaintextWarning =>
      'A chave de API personalizada é armazenada em texto simples nas configurações locais do app na implementação atual. Use-a apenas em um dispositivo ou ambiente de navegador em que você confia.';

  @override
  String get schoolImportParserCustomConfigIncomplete =>
      'A configuração do analisador personalizado está incompleta. Preencha primeiro a URL base, a chave de API e o modelo.';

  @override
  String get schoolImportParserCurrentSourceOfficial => 'Analisador: oficial';

  @override
  String schoolImportParserCurrentSourceCustom(Object model) {
    return 'Analisador: personalizado ($model)';
  }

  @override
  String get privacyViewFullPolicy => 'Ver política de privacidade completa';

  @override
  String get privacyAgreeAndContinue => 'Concordar e continuar';

  @override
  String get privacyDecline => 'Recusar';

  @override
  String get privacyDeclineWebHint =>
      'Este ambiente de navegador não permite que o app feche a página por você. Se não concordar, feche esta aba ou janela manualmente.';

  @override
  String get defaultPeriodTimeSetName => 'Períodos padrão';

  @override
  String get periodTimeSetFallbackName => 'Horários dos períodos';

  @override
  String get untitledTimetableName => 'Horário sem título';

  @override
  String get newTimetableName => 'Novo horário';

  @override
  String get newPeriodTimeSetName => 'Novo conjunto de horários dos períodos';

  @override
  String get emptyTimetableName => 'Horário vazio';

  @override
  String importedPeriodTimeSetName(Object name) {
    return 'Períodos de $name';
  }

  @override
  String get importFileTypeMismatchMessage =>
      'O tipo de arquivo importado não corresponde.';

  @override
  String get importFileVersionUnsupportedMessage =>
      'Esta versão do arquivo de importação ainda não é compatível.';

  @override
  String get noPeriodTimesInImportMessage =>
      'Nenhum horário de período foi encontrado no arquivo importado.';

  @override
  String get selectAtLeastOneTimetableMessage =>
      'Selecione pelo menos um horário.';

  @override
  String get noExportableTimetableMessage =>
      'Não há horário disponível para exportar.';

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      'Substituir o horário atual permite selecionar apenas um horário.';

  @override
  String get noActiveTimetableToReplaceMessage =>
      'Não há horário atual para substituir.';

  @override
  String periodTimeSetInUseMessage(int count) {
    return 'Este conjunto de horários dos períodos ainda é usado por $count horário(s). Reatribua-os antes de excluir.';
  }

  @override
  String get weekdayMonday => 'Segunda-feira';

  @override
  String get weekdayTuesday => 'Terça-feira';

  @override
  String get weekdayWednesday => 'Quarta-feira';

  @override
  String get weekdayThursday => 'Quinta-feira';

  @override
  String get weekdayFriday => 'Sexta-feira';

  @override
  String get weekdaySaturday => 'Sábado';

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get weekdayShortMonday => 'Seg';

  @override
  String get weekdayShortTuesday => 'Ter';

  @override
  String get weekdayShortWednesday => 'Qua';

  @override
  String get weekdayShortThursday => 'Qui';

  @override
  String get weekdayShortFriday => 'Sex';

  @override
  String get weekdayShortSaturday => 'Sáb';

  @override
  String get weekdayShortSunday => 'Dom';

  @override
  String get monthJanuary => 'Jan';

  @override
  String get monthFebruary => 'Fev';

  @override
  String get monthMarch => 'Mar';

  @override
  String get monthApril => 'Abr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'Jul';

  @override
  String get monthAugust => 'Ago';

  @override
  String get monthSeptember => 'Set';

  @override
  String get monthOctober => 'Out';

  @override
  String get monthNovember => 'Nov';

  @override
  String get monthDecember => 'Dez';

  @override
  String get semesterWeeksWholeTerm => 'Todo o semestre';

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
