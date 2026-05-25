import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/text_transfer_widgets.dart';

import '../data/timetable_storage.dart';
import '../l10n/app_locale.dart';
import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../services/export_service.dart';
import '../services/general_calendar_ics_service.dart';
import '../services/import_export_service.dart';
import '../services/update_service.dart';
import '../widgets/period_time_set_picker_dialog.dart';
import 'general_display_settings_page.dart';
import 'language_settings_page.dart';
import 'school_html_import_page.dart';
import 'theme_settings_page.dart';
import 'timetable_display_settings_page.dart';
import 'timetable_import_flow.dart';

enum _DataAction {
  importTimetables,
  importTimetablesText,
  importSchoolHtml,
  exportTimetablesShare,
  exportTimetablesSave,
  exportTimetablesText,
}

enum _GeneralDataAction {
  importSchedulesJsonFile,
  importSchedulesJsonText,
  importSchedulesIcsFile,
  importSchedulesIcsText,
  exportSchedulesJsonShare,
  exportSchedulesJsonSave,
  exportSchedulesJsonText,
  exportSchedulesIcsShare,
  exportSchedulesIcsSave,
  exportSchedulesIcsText,
}

enum _ExportFormat { json, ics }

enum UpdateCheckSource { manual, startup }

enum _UpdateAction { github, website, googlePlay, quark, ignore, cancel }

class AppUpdateCoordinator {
  static const _updateService = UpdateService();
  static const _googlePlayDeepLink = 'market://details?id=com.mashiro.sked';
  static const _googlePlayUrl =
      'https://play.google.com/store/apps/details?id=com.mashiro.sked';
  static const _quarkPanUrl = 'https://pan.quark.cn/s/420966ed21ec';

  static Future<void> checkForUpdates(
    BuildContext context, {
    required TimetableProvider provider,
    required UpdateCheckSource source,
    UpdateService updateService = _updateService,
  }) async {
    final l10n = AppLocalizations.of(context);
    final showIgnoreButton = source == UpdateCheckSource.startup;
    try {
      final result = await updateService.checkForUpdates(
        preferredLocale: Localizations.localeOf(context),
      );
      if (!context.mounted) {
        return;
      }
      final latestMessage = l10n.alreadyLatestVersion(result.localVersion);
      if (!result.hasUpdate) {
        await provider.updateAvailableUpdateVersion(null);
        if (!context.mounted) {
          return;
        }
        if (source == UpdateCheckSource.manual) {
          _showMessage(context, latestMessage);
        }
        return;
      }
      await provider.updateAvailableUpdateVersion(result.remoteVersion);
      if (!context.mounted) {
        return;
      }
      if (showIgnoreButton &&
          provider.ignoredUpdateVersion == result.remoteVersion) {
        return;
      }
      final action = await _showUpdateDialog(
        context,
        result,
        showIgnoreButton: showIgnoreButton,
      );
      if (!context.mounted) {
        return;
      }
      await _handleUpdateAction(
        context,
        provider: provider,
        action: action,
        showIgnoreButton: showIgnoreButton,
        remoteVersion: result.remoteVersion,
        releaseUrl: result.releaseUrl,
        websiteUrl: result.officialWebsiteUrl,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      final action = await _showUpdateCheckFailedDialog(
        context,
        showIgnoreButton: showIgnoreButton,
      );
      if (!context.mounted) {
        return;
      }
      await _handleUpdateAction(
        context,
        provider: provider,
        action: action,
        showIgnoreButton: showIgnoreButton,
        releaseUrl: UpdateService.latestReleaseUrl,
        websiteUrl: null,
      );
    }
  }

  static Future<_UpdateAction?> _showUpdateDialog(
    BuildContext context,
    UpdateCheckResult result, {
    required bool showIgnoreButton,
  }) {
    final l10n = AppLocalizations.of(context);
    final updateContent = result.updateContent.trim();
    return showDialog<_UpdateAction>(
      context: context,
      builder: (context) {
        var popped = false;
        void popWith(_UpdateAction action) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(action);
        }
        return AlertDialog(
          title: Text(l10n.checkForUpdates),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.currentVersionLabel} ${result.localVersion}'),
                const SizedBox(height: 8),
                Text('${l10n.latestVersionLabel} ${result.remoteVersion}'),
                if (updateContent.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.updateContentLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(updateContent),
                ],
              ],
            ),
          ),
          actions: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _buildUpdateDialogActions(
                context,
                pop: popWith,
                showIgnoreButton: showIgnoreButton,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<_UpdateAction?> _showUpdateCheckFailedDialog(
    BuildContext context, {
    required bool showIgnoreButton,
  }) {
    final l10n = AppLocalizations.of(context);
    return showDialog<_UpdateAction>(
      context: context,
      builder: (context) {
        var popped = false;
        void popWith(_UpdateAction action) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(action);
        }
        return AlertDialog(
          title: Text(l10n.updateCheckFailedTitle),
          content: Text(l10n.updateCheckFailedMessage),
          actions: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _buildUpdateDialogActions(
                context,
                pop: popWith,
                showIgnoreButton: showIgnoreButton,
              ),
            ),
          ],
        );
      },
    );
  }

  static List<Widget> _buildUpdateDialogActions(
    BuildContext context, {
    required void Function(_UpdateAction action) pop,
    required bool showIgnoreButton,
  }) {
    final l10n = AppLocalizations.of(context);
    return [
      TextButton(
        onPressed: () => pop(_UpdateAction.cancel),
        child: Text(l10n.cancel),
      ),
      if (showIgnoreButton)
        TextButton(
          onPressed: () => pop(_UpdateAction.ignore),
          child: Text(l10n.ignoreThisVersion),
        ),
      TextButton(
        onPressed: () => pop(_UpdateAction.website),
        child: Text(l10n.officialWebsite),
      ),
      TextButton(
        onPressed: () => pop(_UpdateAction.googlePlay),
        child: Text(l10n.googlePlay),
      ),
      TextButton(
        onPressed: () => pop(_UpdateAction.quark),
        child: Text(l10n.cloudDrive),
      ),
      FilledButton(
        onPressed: () => pop(_UpdateAction.github),
        child: Text(l10n.githubRepository),
      ),
    ];
  }

  static Future<void> _handleUpdateAction(
    BuildContext context, {
    required TimetableProvider provider,
    required _UpdateAction? action,
    required bool showIgnoreButton,
    String? remoteVersion,
    String? releaseUrl,
    String? websiteUrl,
  }) async {
    switch (action) {
      case _UpdateAction.github:
        await _openExternalPage(
          context,
          releaseUrl ?? UpdateService.latestReleaseUrl,
        );
        return;
      case _UpdateAction.website:
        await _openExternalPage(
          context,
          websiteUrl ?? 'https://mashiro.tech/KeSchedule',
        );
        return;
      case _UpdateAction.googlePlay:
        await _openGooglePlayPage(context);
        return;
      case _UpdateAction.quark:
        await _openExternalPage(context, _quarkPanUrl);
        return;
      case _UpdateAction.ignore:
        if (showIgnoreButton &&
            remoteVersion != null &&
            remoteVersion.trim().isNotEmpty) {
          await provider.ignoreUpdateVersion(remoteVersion);
        }
        return;
      case _UpdateAction.cancel:
      case null:
        return;
    }
  }

  static Future<void> _openGooglePlayPage(BuildContext context) async {
    final deepLinkUri = Uri.parse(_googlePlayDeepLink);
    final openedDeepLink = await launchUrl(
      deepLinkUri,
      mode: LaunchMode.externalApplication,
    );
    if (openedDeepLink || !context.mounted) {
      return;
    }
    await _openExternalPage(context, _googlePlayUrl);
  }

  static Future<void> _openExternalPage(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showMessage(context, AppLocalizations.of(context).openUpdatesFailed);
    }
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _exportService = ExportService();

  String? _editingTimetableId;
  String _currentVersion = '';
  String? _selectedPeriodTimeSetId;

  @override
  void initState() {
    super.initState();
    _loadCurrentVersion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<TimetableProvider>();
    final timetable = provider.activeTimetableOrNull;
    if (timetable == null) {
      return;
    }
    if (_editingTimetableId == timetable.id) {
      return;
    }
    _editingTimetableId = timetable.id;
    _selectedPeriodTimeSetId = timetable.config.periodTimeSetId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context);
        final languageOptions = supportedLanguageOptions(l10n);
        final currentLanguageLabel = _languageLabelForCode(
          languageOptions,
          provider.localeCode,
        );
        final timetable = provider.activeTimetableOrNull;
        final hasTimetable = timetable != null;
        if (!hasTimetable && provider.isStudentMode) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.settingsTitle)),
            body: Center(child: Text(l10n.noTimetableSettings)),
          );
        }
        final selectedSet = _selectedPeriodTimeSetId != null
            ? provider.periodTimeSetForId(_selectedPeriodTimeSetId!)
            : provider.activePeriodTimeSetOrNull;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.settingsTitle)),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              if (provider.lastRecoveryStatus != RecoveryStatus.none) ...[
                _RecoveryNoticeTile(status: provider.lastRecoveryStatus),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ],
              if (provider.isStudentMode) ...[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.schedule_outlined),
                  title: Text(l10n.periodTimeSets),
                  subtitle: Text(
                    selectedSet == null
                        ? l10n.noPeriodTimeAvailable
                        : l10n.periodTimeSetSummary(
                            selectedSet.name,
                            selectedSet.periodTimes.length,
                          ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: () => _pickPeriodTimeSet(provider, timetable!.config),
                ),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.schoolWebImportEntry),
                  subtitle: Text(l10n.schoolWebImportEntryDesc),
                  onTap: () => _openSchoolSitesPage(provider),
                ),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ],
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.theme),
                subtitle: Text(
                  '${switch (provider.themeMode) {
                    'dark' => l10n.themeDark,
                    'system' => l10n.themeFollowSystem,
                    _ => l10n.themeLight,
                  }} · ${provider.themeColorMode == themeColorModeColorful ? l10n.themeColorModeColorful : l10n.themeColorModeSingle}',
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => _openThemeSettingsPage(provider),
              ),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
              if (provider.isStudentMode) ...[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.grid_view_outlined),
                  title: Text(l10n.timetableDisplaySettings),
                  subtitle: Text(l10n.timetableDisplaySettingsDesc),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => _openTimetableDisplaySettingsPage(provider),
                ),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ],
              if (provider.isGeneralMode) ...[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.grid_view_outlined),
                  title: Text(l10n.generalDisplaySettings),
                  subtitle: Text(l10n.generalDisplaySettingsDesc),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => _openGeneralDisplaySettingsPage(provider),
                ),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ],
              if (provider.isStudentMode)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.import_export),
                  title: Text(l10n.dataImportExport),
                  subtitle: Text(l10n.dataImportExportDesc),
                  onTap: () => _showDataActions(provider),
                ),
              if (provider.isGeneralMode)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.import_export),
                  title: Text(l10n.generalScheduleImportExport),
                  subtitle: Text(l10n.generalScheduleImportExportDesc),
                  onTap: () => _showGeneralDataActions(provider),
                ),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.translate_outlined),
                title: Text(l10n.language),
                subtitle: Text(currentLanguageLabel),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => _openLanguageSettingsPage(provider),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.privacyPolicyTitle),
                subtitle: Text(
                  provider.acceptedPrivacyPolicyVersion == null
                      ? l10n.privacyPolicyEntryDesc
                      : l10n.privacyPolicyAcceptedVersionLabel(
                          provider.acceptedPrivacyPolicyVersion!,
                        ),
                ),
                onTap: _openPrivacyPolicyPage,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.description_outlined),
                title: Text(l10n.openSourceLicenses),
                subtitle: Text(l10n.openSourceLicensesDesc),
                onTap: _openLicensesPage,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.update_outlined),
                title: Text(l10n.checkForUpdates),
                subtitle: Text(_buildUpdateSubtitle(provider, l10n)),
                onTap: _checkForUpdates,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const FaIcon(FontAwesomeIcons.github),
                title: Text(l10n.githubRepository),
                subtitle: Text(l10n.githubRepositoryUrl),
                onTap: _openGithubRepo,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openThemeSettingsPage(TimetableProvider provider) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const ThemeSettingsPage(),
        ),
      ),
    );
  }

  Future<void> _openTimetableDisplaySettingsPage(
    TimetableProvider provider,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const TimetableDisplaySettingsPage(),
        ),
      ),
    );
  }

  Future<void> _openGeneralDisplaySettingsPage(
    TimetableProvider provider,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const GeneralDisplaySettingsPage(),
        ),
      ),
    );
  }

  Future<void> _openLanguageSettingsPage(TimetableProvider provider) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const LanguageSettingsPage(),
        ),
      ),
    );
  }

  String _languageLabelForCode(
    List<AppLanguageOption> options,
    String localeCode,
  ) {
    final normalizedCode = normalizeLocaleCode(localeCode);
    for (final option in options) {
      if (option.code == normalizedCode) {
        return option.label;
      }
    }
    return languageLabelForLocaleCode(
      normalizedCode,
      l10n: AppLocalizations.of(context),
    );
  }

  Future<void> _pickPeriodTimeSet(
    TimetableProvider provider,
    TimetableConfig config,
  ) async {
    final result = await showPeriodTimeSetPickerDialog(
      context,
      provider: provider,
      selectedPeriodTimeSetId: _selectedPeriodTimeSetId!,
    );
    if (result == null || result == _selectedPeriodTimeSetId) {
      return;
    }
    setState(() => _selectedPeriodTimeSetId = result);
    await provider.updateTimetableConfig(
      config.copyWith(periodTimeSetId: result),
    );
  }

  Future<void> _openPrivacyPolicyPage() async {
    final uri = Uri.parse('https://mashiro.tech/KeSchedule/privacy.html');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _openLicensesPage() {
    showLicensePage(context: context, applicationName: 'Sked');
  }

  String _buildUpdateSubtitle(
    TimetableProvider provider,
    AppLocalizations l10n,
  ) {
    final versionLabel = _currentVersion.isEmpty
        ? l10n.currentVersionLabel
        : '${l10n.currentVersionLabel} $_currentVersion';
    final availableUpdateVersion = provider.availableUpdateVersion;
    if (availableUpdateVersion == null ||
        availableUpdateVersion.isEmpty ||
        !_isNewerThanCurrentVersion(availableUpdateVersion)) {
      return versionLabel;
    }
    return '$versionLabel · ${l10n.newVersionAvailable}';
  }

  Future<void> _loadCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) {
      return;
    }
    final currentVersion = info.version;
    setState(() => _currentVersion = currentVersion);
    final provider = context.read<TimetableProvider>();
    final availableUpdateVersion = provider.availableUpdateVersion;
    if (availableUpdateVersion != null &&
        availableUpdateVersion.isNotEmpty &&
        compareUpdateVersions(availableUpdateVersion, currentVersion) <= 0) {
      await provider.updateAvailableUpdateVersion(null);
    }
  }

  Future<void> _checkForUpdates() {
    return AppUpdateCoordinator.checkForUpdates(
      context,
      provider: context.read<TimetableProvider>(),
      source: UpdateCheckSource.manual,
    );
  }

  bool _isNewerThanCurrentVersion(String version) {
    if (_currentVersion.isEmpty) {
      return true;
    }
    return compareUpdateVersions(version, _currentVersion) > 0;
  }

  Future<void> _openGithubRepo() async {
    final uri = Uri.parse('https://github.com/Mashiro0619/KeSchedule');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      _showMessage(AppLocalizations.of(context).openGithubFailed);
    }
  }

  Future<void> _showDataActions(TimetableProvider provider) async {
    final action = await showModalBottomSheet<_DataAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext);
        return _buildAdaptiveBottomSheet(
          sheetContext,
          maxWidth: 680,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download_outlined),
                  title: Text(l10n.importTimetableFiles),
                  subtitle: Text(l10n.importTimetableFilesDesc),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_DataAction.importTimetables),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.paste_outlined),
                  title: Text(l10n.importTimetableText),
                  subtitle: Text(l10n.importTimetableTextDesc),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_DataAction.importTimetablesText),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.html_outlined),
                  title: Text(l10n.schoolHtmlImportEntry),
                  subtitle: Text(l10n.schoolHtmlImportEntryDesc),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_DataAction.importSchoolHtml),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: Text(l10n.shareTimetableFiles),
                  subtitle: Text(l10n.shareTimetableFilesDesc),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_DataAction.exportTimetablesShare),
                ),
                ListTile(
                  leading: const Icon(Icons.save_alt_outlined),
                  title: Text(l10n.saveTimetableFiles),
                  subtitle: Text(l10n.saveTimetableFilesDesc),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_DataAction.exportTimetablesSave),
                ),
                ListTile(
                  leading: const Icon(Icons.text_snippet_outlined),
                  title: Text(l10n.exportTimetableText),
                  subtitle: Text(l10n.exportTimetableTextDesc),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_DataAction.exportTimetablesText),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (action == null || !mounted) {
      return;
    }
    switch (action) {
      case _DataAction.importTimetables:
        await TimetableImportFlow.importTimetables(context, provider);
        return;
      case _DataAction.importTimetablesText:
        await _importTimetablesFromText(provider);
        return;
      case _DataAction.importSchoolHtml:
        await _openSchoolHtmlImportPage(provider);
        return;
      case _DataAction.exportTimetablesShare:
        await _exportTimetables(provider, share: true);
        return;
      case _DataAction.exportTimetablesSave:
        await _exportTimetables(provider, share: false);
        return;
      case _DataAction.exportTimetablesText:
        await _exportTimetablesAsText(provider);
        return;
    }
  }

  Future<void> _openSchoolSitesPage(TimetableProvider provider) async {
    await TimetableImportFlow.openSchoolSitesPage(context, provider);
  }

  Future<void> _importTimetablesFromText(TimetableProvider provider) async {
    final l10n = AppLocalizations.of(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextImportPage(
          title: l10n.importTimetableText,
          onSubmit: (context, content) {
            return TimetableImportFlow.importTimetablesFromSource(
              context,
              provider,
              content,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openSchoolHtmlImportPage(TimetableProvider provider) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const SchoolHtmlImportPage(),
        ),
      ),
    );
  }

  Future<void> _exportTimetablesAsText(TimetableProvider provider) async {
    final l10n = AppLocalizations.of(context);
    final activeId = provider.activeTimetableOrNull?.id;
    final selectedIds = await _pickTimetableIds(
      timetables: provider.timetables,
      title: l10n.selectTimetablesToExport,
      confirmText: l10n.copyText,
      initialSelectedIds: activeId == null ? const [] : [activeId],
    );
    if (selectedIds == null || selectedIds.isEmpty || !mounted) {
      return;
    }
    try {
      final content = provider.exportSelectedTimetablesJson(selectedIds);
      await showTextExportDialog(
        context,
        title: l10n.exportTimetableText,
        content: content,
      );
    } on FormatException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(l10n.saveFailedRetry);
      }
    }
  }

  Future<void> _exportTimetables(
    TimetableProvider provider, {
    required bool share,
  }) async {
    final l10n = AppLocalizations.of(context);
    final activeId = provider.activeTimetableOrNull?.id;
    final selectedIds = await _pickTimetableIds(
      timetables: provider.timetables,
      title: l10n.selectTimetablesToExport,
      confirmText: share ? l10n.share : l10n.save,
      initialSelectedIds: activeId == null ? const [] : [activeId],
    );
    if (selectedIds == null || selectedIds.isEmpty) {
      return;
    }
    try {
      final content = provider.exportSelectedTimetablesJson(selectedIds);
      const fileName = 'Sked_timetables.json';
      if (share) {
        await _shareJson(fileName, content);
      } else {
        await _saveJsonToFile(fileName, content);
      }
    } on FormatException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(l10n.saveFailedRetry);
      }
    }
  }

  Future<List<String>?> _pickTimetableIds({
    required List<TimetableData> timetables,
    required String title,
    required String confirmText,
    List<String> initialSelectedIds = const [],
  }) {
    final draft = <String>{
      ...initialSelectedIds.where(
        (id) => timetables.any((item) => item.id == id),
      ),
    };
    if (draft.isEmpty && timetables.isNotEmpty) {
      draft.add(timetables.first.id);
    }
    return showDialog<List<String>>(
      context: context,
      builder: (context) {
        var popped = false;
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = AppLocalizations.of(context);
            void popWith(List<String>? value) {
              if (popped) return;
              popped = true;
              Navigator.of(context).pop(value);
            }
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => setState(() {
                              draft
                                ..clear()
                                ..addAll(timetables.map((item) => item.id));
                            }),
                            child: Text(l10n.selectAll),
                          ),
                          TextButton(
                            onPressed: () => setState(draft.clear),
                            child: Text(l10n.clear),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: timetables.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final timetable = timetables[index];
                          final selected = draft.contains(timetable.id);
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: selected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer
                                : null,
                            title: Text(timetable.config.name),
                            subtitle: Text(
                              l10n.timetableCourseCount(
                                timetable.courses.length,
                              ),
                            ),
                            trailing: selected ? const Icon(Icons.check) : null,
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  draft.remove(timetable.id);
                                } else {
                                  draft.add(timetable.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => popWith(null),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: draft.isEmpty
                      ? null
                      : () => popWith(
                          timetables
                              .where((item) => draft.contains(item.id))
                              .map((item) => item.id)
                              .toList(),
                        ),
                  child: Text(confirmText),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _shareJson(String fileName, String content) async {
    await _shareFile(ExportPayload(fileName: fileName, content: content));
  }

  Future<void> _shareFile(ExportPayload payload) async {
    await _exportService.shareFile(payload);
  }

  Future<void> _saveJsonToFile(String fileName, String content) async {
    await _saveFileToDisk(ExportPayload(fileName: fileName, content: content));
  }

  Future<void> _saveFileToDisk(ExportPayload payload) async {
    final l10n = AppLocalizations.of(context);
    final result = await _exportService.saveFile(payload);
    if (!mounted) {
      return;
    }

    switch (result.status) {
      case ExportSaveStatus.saved:
        _showMessage(l10n.savedToPath(result.path ?? payload.fileName));
        return;
      case ExportSaveStatus.cancelled:
        _showMessage(l10n.saveCancelled);
        return;
      case ExportSaveStatus.permissionDenied:
        final retry = await _showPermissionDialog(
          title: l10n.fileSaveRestrictedTitle,
          message: l10n.fileSaveRestrictedRetryMessage,
          confirmText: l10n.retrySave,
        );
        if (retry == true && mounted) {
          await _saveFileToDisk(payload);
        }
        return;
      case ExportSaveStatus.permissionPermanentlyDenied:
        final openSettings = await _showPermissionDialog(
          title: l10n.fileSaveRestrictedTitle,
          message: l10n.fileSaveRestrictedSettingsMessage,
          confirmText: l10n.openSettings,
        );
        if (openSettings == true) {
          await _exportService.openSettings();
        }
        return;
      case ExportSaveStatus.unsupported:
        final shouldShare = await _showFailureDialog(
          title: l10n.browserDownloadRestrictedTitle,
          message: l10n.browserDownloadRestrictedMessage,
        );
        if (shouldShare == true) {
          await _shareFile(payload);
          if (mounted) {
            _showMessage(l10n.exportSwitchedToShare);
          }
        }
        return;
      case ExportSaveStatus.failed:
        final shouldShare = await _showFailureDialog(
          title: _exportService.isWindows
              ? l10n.fileSaveFailedTitle
              : l10n.fileSaveRestrictedTitle,
          message: _exportService.isWindows
              ? l10n.fileSaveFailedWindowsMessage
              : l10n.fileSaveFailedGenericMessage,
        );
        if (shouldShare == true) {
          await _shareFile(payload);
          if (mounted) {
            _showMessage(l10n.exportSwitchedToShare);
          }
        } else if (mounted) {
          _showMessage(l10n.saveFailedRetry);
        }
        return;
    }
  }

  Future<bool?> _showPermissionDialog({
    required String title,
    required String message,
    required String confirmText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        var popped = false;
        void popWith(bool value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => popWith(false),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            FilledButton(
              onPressed: () => popWith(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showFailureDialog({
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        var popped = false;
        void popWith(bool value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => popWith(false),
              child: Text(AppLocalizations.of(context).retryLater),
            ),
            FilledButton(
              onPressed: () => popWith(true),
              child: Text(AppLocalizations.of(context).switchToShare),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showGeneralDataActions(TimetableProvider provider) async {
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<_GeneralDataAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.85;
        return _buildAdaptiveBottomSheet(
          sheetContext,
          maxWidth: 680,
          child: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: Text(l10n.importJsonFile),
                    subtitle: Text(l10n.importGeneralSchedulesDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.importSchedulesJsonFile),
                  ),
                  ListTile(
                    leading: const Icon(Icons.paste_outlined),
                    title: Text(l10n.pasteJson),
                    subtitle: Text(l10n.importGeneralSchedulesJsonTextDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.importSchedulesJsonText),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: Text(l10n.importIcsFile),
                    subtitle: Text(l10n.importIcsFileDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.importSchedulesIcsFile),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event_note_outlined),
                    title: Text(l10n.pasteIcs),
                    subtitle: Text(l10n.pasteIcsDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.importSchedulesIcsText),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: Text('${l10n.shareGeneralSchedules} JSON'),
                    subtitle: Text(l10n.shareGeneralSchedulesDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.exportSchedulesJsonShare),
                  ),
                  ListTile(
                    leading: const Icon(Icons.save_alt_outlined),
                    title: Text('${l10n.saveGeneralSchedules} JSON'),
                    subtitle: Text(l10n.saveGeneralSchedulesDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.exportSchedulesJsonSave),
                  ),
                  ListTile(
                    leading: const Icon(Icons.text_snippet_outlined),
                    title: Text(l10n.copyJson),
                    subtitle: Text(l10n.copyJsonDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.exportSchedulesJsonText),
                  ),
                  ListTile(
                    leading: const Icon(Icons.ios_share_outlined),
                    title: Text(l10n.shareIcs),
                    subtitle: Text(l10n.shareIcsDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.exportSchedulesIcsShare),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event_available_outlined),
                    title: Text(l10n.saveIcs),
                    subtitle: Text(l10n.saveIcsDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.exportSchedulesIcsSave),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event_note_outlined),
                    title: Text(l10n.copyIcs),
                    subtitle: Text(l10n.copyIcsDesc),
                    onTap: () => Navigator.of(
                      sheetContext,
                    ).pop(_GeneralDataAction.exportSchedulesIcsText),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (action == null || !mounted) return;
    switch (action) {
      case _GeneralDataAction.importSchedulesJsonFile:
        await _importGeneralSchedulesJsonFile(provider);
      case _GeneralDataAction.importSchedulesJsonText:
        await _importGeneralSchedulesJsonText(provider);
      case _GeneralDataAction.importSchedulesIcsFile:
        await _importGeneralSchedulesIcsFile(provider);
      case _GeneralDataAction.importSchedulesIcsText:
        await _importGeneralSchedulesIcsText(provider);
      case _GeneralDataAction.exportSchedulesJsonShare:
        await _exportGeneralSchedules(provider, share: true);
      case _GeneralDataAction.exportSchedulesJsonSave:
        await _exportGeneralSchedules(provider, share: false);
      case _GeneralDataAction.exportSchedulesJsonText:
        await _exportGeneralSchedulesAsText(
          provider,
          format: _ExportFormat.json,
        );
      case _GeneralDataAction.exportSchedulesIcsShare:
        await _exportGeneralSchedulesIcs(provider, share: true);
      case _GeneralDataAction.exportSchedulesIcsSave:
        await _exportGeneralSchedulesIcs(provider, share: false);
      case _GeneralDataAction.exportSchedulesIcsText:
        await _exportGeneralSchedulesAsText(
          provider,
          format: _ExportFormat.ics,
        );
    }
  }

  Future<List<String>?> _pickGeneralScheduleIds({
    required List<GeneralSchedule> schedules,
    required String title,
    required String confirmText,
    List<String> initialSelectedIds = const [],
  }) {
    final draft = <String>{
      ...initialSelectedIds.where((id) => schedules.any((s) => s.id == id)),
    };
    if (draft.isEmpty && schedules.isNotEmpty) {
      draft.add(schedules.first.id);
    }
    return showDialog<List<String>>(
      context: context,
      builder: (context) {
        var popped = false;
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = AppLocalizations.of(context);
            void popWith(List<String>? value) {
              if (popped) return;
              popped = true;
              Navigator.of(context).pop(value);
            }
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => setState(() {
                              draft
                                ..clear()
                                ..addAll(schedules.map((s) => s.id));
                            }),
                            child: Text(l10n.selectAll),
                          ),
                          TextButton(
                            onPressed: () => setState(draft.clear),
                            child: Text(l10n.clear),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: schedules.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          final selected = draft.contains(schedule.id);
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: selected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer
                                : null,
                            title: Text(schedule.name),
                            subtitle: Text(
                              l10n.generalScheduleEventCount(
                                schedule.events.length,
                              ),
                            ),
                            trailing: selected ? const Icon(Icons.check) : null,
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  draft.remove(schedule.id);
                                } else {
                                  draft.add(schedule.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => popWith(null),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: draft.isEmpty
                      ? null
                      : () => popWith(
                          schedules
                              .where((s) => draft.contains(s.id))
                              .map((s) => s.id)
                              .toList(),
                        ),
                  child: Text(confirmText),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _importGeneralSchedulesJsonFile(
    TimetableProvider provider,
  ) async {
    final source = await _pickTextFile(allowedExtensions: const ['json']);
    if (source == null || !mounted) return;
    await _importGeneralSchedulesJsonSource(provider, source, context);
  }

  Future<void> _importGeneralSchedulesJsonText(
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextImportPage(
          title: l10n.importGeneralSchedules,
          onSubmit: (context, content) async {
            return _importGeneralSchedulesJsonSource(
              provider,
              content,
              context,
            );
          },
        ),
      ),
    );
  }

  Future<bool> _importGeneralSchedulesJsonSource(
    TimetableProvider provider,
    String content,
    BuildContext feedbackContext,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      final preview = provider.previewImportGeneralSchedules(content);
      if (!feedbackContext.mounted) return false;
      final selectedIds = await _pickGeneralScheduleIds(
        schedules: preview,
        title: l10n.selectSchedulesToImport,
        confirmText: l10n.save,
      );
      if (selectedIds == null || selectedIds.isEmpty) return false;

      var mode = GeneralScheduleImportMode.addAsNew;
      if (selectedIds.length == 1 &&
          provider.activeGeneralScheduleOrNull != null &&
          feedbackContext.mounted) {
        final choice = await showDialog<String>(
          context: feedbackContext,
          builder: (ctx) {
            var popped = false;
            void popWith(String value) {
              if (popped) return;
              popped = true;
              Navigator.of(ctx).pop(value);
            }
            return AlertDialog(
              title: Text(l10n.dataImportExport),
              content: Text(l10n.replaceActiveSchedulePrompt),
              actions: [
                TextButton(
                  onPressed: () => popWith('new'),
                  child: Text(l10n.addAsNewSchedule),
                ),
                FilledButton(
                  onPressed: () => popWith('replace'),
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
        if (choice == 'replace') {
          mode = GeneralScheduleImportMode.replaceActive;
        }
      }

      final result = await provider.importSelectedGeneralSchedulesJson(
        content,
        scheduleIds: selectedIds,
        mode: mode,
      );
      if (feedbackContext.mounted) {
        ScaffoldMessenger.of(feedbackContext).showSnackBar(
          SnackBar(content: Text(_formatGeneralImportResult(result, l10n))),
        );
      }
      return true;
    } on FormatException catch (e) {
      if (feedbackContext.mounted) {
        ScaffoldMessenger.of(
          feedbackContext,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
      return false;
    }
  }

  Future<void> _importGeneralSchedulesIcsFile(
    TimetableProvider provider,
  ) async {
    final source = await _pickTextFile(allowedExtensions: const ['ics']);
    if (source == null || !mounted) return;
    await _importGeneralSchedulesIcsSource(provider, source, context);
  }

  Future<void> _importGeneralSchedulesIcsText(
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextImportPage(
          title: l10n.importIcs,
          labelText: l10n.icsContent,
          hintText: l10n.pasteIcsContentHint,
          onSubmit: (context, content) async {
            return _importGeneralSchedulesIcsSource(provider, content, context);
          },
        ),
      ),
    );
  }

  Future<bool> _importGeneralSchedulesIcsSource(
    TimetableProvider provider,
    String content,
    BuildContext feedbackContext,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      final preview = provider.previewImportGeneralSchedulesIcs(content);
      if (!feedbackContext.mounted) return false;
      var mode = GeneralScheduleImportMode.addAsNew;
      if (preview.schedules.length == 1 &&
          provider.activeGeneralScheduleOrNull != null &&
          feedbackContext.mounted) {
        final choice = await showDialog<String>(
          context: feedbackContext,
          builder: (ctx) {
            var popped = false;
            void popWith(String value) {
              if (popped) return;
              popped = true;
              Navigator.of(ctx).pop(value);
            }
            return AlertDialog(
              title: Text(l10n.importIcs),
              content: Text(
                l10n.importIcsPreviewPrompt(
                  preview.schedules.first.events.length,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => popWith('new'),
                  child: Text(l10n.addAsNewSchedule),
                ),
                FilledButton(
                  onPressed: () => popWith('replace'),
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
        if (choice == 'replace') {
          mode = GeneralScheduleImportMode.replaceActive;
        }
      }
      final result = await provider.importGeneralSchedulesIcs(
        content,
        mode: mode,
      );
      if (feedbackContext.mounted) {
        ScaffoldMessenger.of(feedbackContext).showSnackBar(
          SnackBar(content: Text(_formatGeneralImportResult(result, l10n))),
        );
      }
      return true;
    } on FormatException catch (e) {
      if (feedbackContext.mounted) {
        ScaffoldMessenger.of(
          feedbackContext,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
      return false;
    }
  }

  Future<String?> _pickTextFile({
    required List<String> allowedExtensions,
  }) async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        withData: true,
      );
      if (!mounted) {
        return null;
      }
      final files = result?.files ?? const <PlatformFile>[];
      final file = files.isEmpty ? null : files.first;
      final bytes = file?.bytes;
      if (file == null || bytes == null) {
        return null;
      }
      return utf8.decode(bytes);
    } catch (_) {
      if (mounted) {
        _showMessage(l10n.importFailedCheckContent);
      }
      return null;
    }
  }

  Future<void> _exportGeneralSchedules(
    TimetableProvider provider, {
    required bool share,
  }) async {
    final l10n = AppLocalizations.of(context);
    final activeId = provider.activeGeneralScheduleOrNull?.id;
    final selectedIds = await _pickGeneralScheduleIds(
      schedules: provider.generalSchedules,
      title: l10n.selectSchedulesToExport,
      confirmText: share ? l10n.share : l10n.save,
      initialSelectedIds: activeId == null ? const [] : [activeId],
    );
    if (selectedIds == null || selectedIds.isEmpty) return;
    try {
      final content = provider.exportSelectedGeneralSchedulesJson(selectedIds);
      const fileName = 'Sked_general_schedules.json';
      if (share) {
        await _shareJson(fileName, content);
      } else {
        await _saveJsonToFile(fileName, content);
      }
    } on FormatException catch (e) {
      if (mounted) _showMessage(e.message);
    } catch (_) {
      if (mounted) _showMessage(l10n.saveFailedRetry);
    }
  }

  Future<void> _exportGeneralSchedulesAsText(
    TimetableProvider provider, {
    required _ExportFormat format,
  }) async {
    final l10n = AppLocalizations.of(context);
    final activeId = provider.activeGeneralScheduleOrNull?.id;
    final selectedIds = await _pickGeneralScheduleIds(
      schedules: provider.generalSchedules,
      title: format == _ExportFormat.ics
          ? l10n.selectCalendarsToCopyIcs
          : l10n.selectSchedulesToExport,
      confirmText: l10n.copyText,
      initialSelectedIds: activeId == null ? const [] : [activeId],
    );
    if (selectedIds == null || selectedIds.isEmpty || !mounted) return;
    try {
      final content = format == _ExportFormat.ics
          ? provider.exportSelectedGeneralSchedulesIcs(selectedIds)
          : provider.exportSelectedGeneralSchedulesJson(selectedIds);
      await showTextExportDialog(
        context,
        title: format == _ExportFormat.ics
            ? l10n.exportIcsText
            : l10n.exportJsonText,
        content: content,
      );
    } on FormatException catch (e) {
      if (mounted) _showMessage(e.message);
    } catch (_) {
      if (mounted) _showMessage(l10n.saveFailedRetry);
    }
  }

  Future<void> _exportGeneralSchedulesIcs(
    TimetableProvider provider, {
    required bool share,
  }) async {
    final l10n = AppLocalizations.of(context);
    final activeId = provider.activeGeneralScheduleOrNull?.id;
    final selectedIds = await _pickGeneralScheduleIds(
      schedules: provider.generalSchedules,
      title: l10n.selectCalendarsToExportIcs,
      confirmText: share ? l10n.share : l10n.save,
      initialSelectedIds: activeId == null ? const [] : [activeId],
    );
    if (selectedIds == null || selectedIds.isEmpty) return;
    try {
      final content = provider.exportSelectedGeneralSchedulesIcs(selectedIds);
      const fileName = 'Sked_general_schedules.ics';
      final payload = ExportPayload(
        fileName: fileName,
        content: content,
        mimeType: 'text/calendar',
        allowedExtensions: const ['ics'],
      );
      if (share) {
        await _shareFile(payload);
      } else {
        await _saveFileToDisk(payload);
      }
    } on FormatException catch (e) {
      if (mounted) _showMessage(e.message);
    } catch (_) {
      if (mounted) _showMessage(l10n.saveFailedRetry);
    }
  }

  String _formatGeneralImportResult(
    GeneralScheduleImportResult result,
    AppLocalizations l10n,
  ) {
    if (!result.hasWarnings) {
      return l10n.importedSchedulesCount(result.importedCount);
    }
    final warningText = result.icsWarnings
        .map((warning) => _formatIcsWarning(warning, l10n))
        .take(2)
        .join(' ');
    return '${l10n.importedSchedulesWithWarnings(result.importedCount, result.icsWarnings.length)} $warningText';
  }

  String _formatIcsWarning(
    GeneralCalendarIcsImportWarning warning,
    AppLocalizations l10n,
  ) {
    return switch (warning.code) {
      GeneralCalendarIcsWarningCode.missingDtStart =>
        l10n.importWarningSkippedMissingStart,
      GeneralCalendarIcsWarningCode.unsupportedDtStart =>
        l10n.importWarningSkippedUnsupportedStart,
      GeneralCalendarIcsWarningCode.adjustedEnd =>
        l10n.importWarningAdjustedEnd,
      GeneralCalendarIcsWarningCode.unsupportedFields =>
        l10n.importWarningUnsupportedFields(warning.values.join(', ')),
      GeneralCalendarIcsWarningCode.unsupportedRRuleFrequency =>
        l10n.importWarningUnsupportedRRuleFrequency(
          warning.values.isEmpty ? '' : warning.values.first,
        ),
    };
  }

  Widget _buildAdaptiveBottomSheet(
    BuildContext context, {
    required Widget child,
    required double maxWidth,
  }) {
    final width = MediaQuery.of(context).size.width;
    final isDesktopLike = width >= 900;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktopLike ? maxWidth : width,
          ),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _RecoveryNoticeTile extends StatelessWidget {
  const _RecoveryNoticeTile({required this.status});

  final RecoveryStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isFailure = status == RecoveryStatus.failedBackupRestore;
    final tone = isFailure
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.tertiaryContainer;
    final foreground = isFailure
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onTertiaryContainer;
    final message = isFailure
        ? l10n.dataBackupRestoreFailedNotice
        : l10n.dataRestoredFromBackupNotice;
    return Container(
      color: tone,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          isFailure ? Icons.error_outline : Icons.history_toggle_off,
          color: foreground,
        ),
        title: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
