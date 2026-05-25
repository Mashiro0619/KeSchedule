import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/school_site_models.dart';
import '../providers/timetable_provider.dart';
import '../services/export_service.dart';
import '../services/school_site_service.dart';
import 'school_html_import_page.dart';
import 'school_web_import_page.dart';

enum _SchoolSitesMenuAction { toggleEditMode, importJson, shareJson, saveJson }

enum _SchoolSiteItemAction { edit, delete }

class SchoolSitesPage extends StatefulWidget {
  const SchoolSitesPage({super.key});

  @override
  State<SchoolSitesPage> createState() => _SchoolSitesPageState();
}

class _SchoolSitesPageState extends State<SchoolSitesPage> {
  static const _exportService = ExportService();
  static const _siteService = SchoolSiteService();

  var _loading = true;
  var _isEditMode = false;
  List<SchoolSite> _sites = const [];

  bool get _supportsWebImport =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.schoolSitesPageTitle),
        actions: [
          IconButton(
            tooltip: l10n.schoolSitesAdd,
            onPressed: _addSite,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: l10n.schoolHtmlImportEntry,
            onPressed: _openHtmlImport,
            icon: const Icon(Icons.code),
          ),
          PopupMenuButton<_SchoolSitesMenuAction>(
            tooltip: l10n.importExport,
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _SchoolSitesMenuAction.toggleEditMode,
                child: Text(_isEditMode ? l10n.confirm : l10n.schoolSitesEdit),
              ),
              PopupMenuItem(
                value: _SchoolSitesMenuAction.importJson,
                child: Text(l10n.schoolSitesImportJson),
              ),
              PopupMenuItem(
                value: _SchoolSitesMenuAction.shareJson,
                child: Text(l10n.schoolSitesShareJson),
              ),
              PopupMenuItem(
                value: _SchoolSitesMenuAction.saveJson,
                child: Text(l10n.schoolSitesSaveJson),
              ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.schoolSitesEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: _sites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final site = _sites[index];
                return Card.outlined(
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                    leading: const Icon(Icons.school_outlined),
                    title: Text(site.name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(site.loginUrl),
                    ),
                    isThreeLine: false,
                    enabled: _supportsWebImport,
                    onTap: _supportsWebImport
                        ? () => _openWebImportForSite(site)
                        : null,
                    trailing: _isEditMode
                        ? PopupMenuButton<_SchoolSiteItemAction>(
                            onSelected: (action) async {
                              switch (action) {
                                case _SchoolSiteItemAction.edit:
                                  await _editSite(index);
                                  return;
                                case _SchoolSiteItemAction.delete:
                                  await _deleteSite(index);
                                  return;
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: _SchoolSiteItemAction.edit,
                                child: Text(l10n.schoolSitesEdit),
                              ),
                              PopupMenuItem(
                                value: _SchoolSiteItemAction.delete,
                                child: Text(l10n.delete),
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }

  Future<void> _loadSites() async {
    try {
      final sites = await _siteService.loadSites();
      if (!mounted) {
        return;
      }
      setState(() {
        _sites = sites;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('Failed to load school sites: $e\n$st');
      if (!mounted) {
        return;
      }
      setState(() {
        _sites = const [];
        _loading = false;
      });
      _showMessage(
        AppLocalizations.of(context).schoolWebImportSchoolLoadFailed,
      );
    }
  }

  Future<void> _handleMenuAction(_SchoolSitesMenuAction action) async {
    switch (action) {
      case _SchoolSitesMenuAction.toggleEditMode:
        setState(() => _isEditMode = !_isEditMode);
        return;
      case _SchoolSitesMenuAction.importJson:
        await _importJson();
        return;
      case _SchoolSitesMenuAction.shareJson:
        await _shareJson();
        return;
      case _SchoolSitesMenuAction.saveJson:
        await _saveJsonToFile();
        return;
    }
  }

  Future<void> _openHtmlImport() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SchoolHtmlImportPage()));
  }

  Future<void> _openWebImportForSite(SchoolSite site) async {
    final provider = context.read<TimetableProvider>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: SchoolWebImportPage(site: site),
        ),
      ),
    );
  }

  Future<void> _addSite() async {
    final created = await _showEditorDialog();
    if (!mounted || created == null) {
      return;
    }
    await _persistSites([..._sites, created]);
  }

  Future<void> _editSite(int index) async {
    final updated = await _showEditorDialog(initialSite: _sites[index]);
    if (!mounted || updated == null) {
      return;
    }
    final nextSites = [..._sites];
    nextSites[index] = updated;
    await _persistSites(nextSites);
  }

  Future<void> _deleteSite(int index) async {
    final l10n = AppLocalizations.of(context);
    final site = _sites[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.schoolSitesDeleteTitle),
          content: Text(l10n.schoolSitesDeleteMessage(site.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    final nextSites = [..._sites]..removeAt(index);
    await _persistSites(nextSites);
  }

  Future<SchoolSite?> _showEditorDialog({SchoolSite? initialSite}) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(text: initialSite?.name ?? '');
    final urlController = TextEditingController(
      text: initialSite?.loginUrl ?? '',
    );

    return showDialog<SchoolSite>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            initialSite == null ? l10n.schoolSitesAdd : l10n.schoolSitesEdit,
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.schoolSitesNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: l10n.schoolSitesLoginUrlLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final site = SchoolSite(
                  name: nameController.text.trim(),
                  loginUrl: urlController.text.trim(),
                );
                if (!site.isValid) {
                  _showMessage(l10n.schoolSitesFormInvalid);
                  return;
                }
                Navigator.of(context).pop(site);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _persistSites(List<SchoolSite> sites) async {
    final l10n = AppLocalizations.of(context);
    try {
      await _siteService.saveSites(sites);
      if (!mounted) {
        return;
      }
      setState(() {
        _sites = sites;
      });
      _showMessage(l10n.schoolSitesSaved);
    } catch (_) {
      _showMessage(l10n.saveFailedRetry);
    }
  }

  Future<void> _importJson() async {
    final l10n = AppLocalizations.of(context);
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (!mounted) {
      return;
    }
    final files = result?.files ?? const <PlatformFile>[];
    final file = files.isEmpty ? null : files.first;
    final bytes = file?.bytes;
    if (file == null || bytes == null) {
      return;
    }
    try {
      final imported = await _siteService.importSites(utf8.decode(bytes));
      if (!mounted) {
        return;
      }
      setState(() {
        _sites = imported;
        _isEditMode = false;
      });
      _showMessage(l10n.schoolSitesImported);
    } on FormatException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(l10n.importFailedCheckContent);
    }
  }

  Future<void> _shareJson() async {
    final l10n = AppLocalizations.of(context);
    final content = await _siteService.exportSites(_sites);
    if (!mounted) {
      return;
    }
    await _exportService.shareFile(
      ExportPayload(fileName: l10n.schoolSitesJsonFileName, content: content),
    );
  }

  Future<void> _saveJsonToFile() async {
    final l10n = AppLocalizations.of(context);
    final result = await _exportService.saveFile(
      ExportPayload(
        fileName: l10n.schoolSitesJsonFileName,
        content: await _siteService.exportSites(_sites),
      ),
    );

    switch (result.status) {
      case ExportSaveStatus.saved:
        _showMessage(
          l10n.savedToPath(result.path ?? l10n.schoolSitesJsonFileName),
        );
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
          await _saveJsonToFile();
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
          await _shareJson();
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
          await _shareJson();
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
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
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
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context).retryLater),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
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
}
