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
  const SchoolSitesPage({
    super.key,
    SchoolSiteService? siteService,
    ExportService? exportService,
  }) : siteService = siteService ?? const SchoolSiteService(),
       exportService = exportService ?? const ExportService();

  final SchoolSiteService siteService;
  final ExportService exportService;

  @override
  State<SchoolSitesPage> createState() => _SchoolSitesPageState();
}

class _SchoolSitesPageState extends State<SchoolSitesPage> {
  var _loading = true;
  var _isEditMode = false;
  var _editorDialogOpen = false;
  var _htmlImportOpen = false;
  var _webImportOpen = false;
  var _jsonImportInProgress = false;
  var _jsonShareInProgress = false;
  var _jsonSaveInProgress = false;
  List<SchoolSite> _sites = const [];

  bool get _supportsWebImport =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  ExportService get _exportService => widget.exportService;
  SchoolSiteService get _siteService => widget.siteService;

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
            onPressed: _editorDialogOpen ? null : _addSite,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: l10n.schoolHtmlImportEntry,
            onPressed: _htmlImportOpen ? null : _openHtmlImport,
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
                enabled: !_jsonImportInProgress,
                child: Text(l10n.schoolSitesImportJson),
              ),
              PopupMenuItem(
                value: _SchoolSitesMenuAction.shareJson,
                enabled: !_jsonShareInProgress,
                child: Text(l10n.schoolSitesShareJson),
              ),
              PopupMenuItem(
                value: _SchoolSitesMenuAction.saveJson,
                enabled: !_jsonSaveInProgress,
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
                    enabled: _supportsWebImport && !_webImportOpen,
                    onTap: _supportsWebImport && !_webImportOpen
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

  void _setEditorDialogOpen(bool value) {
    if (_editorDialogOpen == value) return;
    if (mounted) {
      setState(() => _editorDialogOpen = value);
    } else {
      _editorDialogOpen = value;
    }
  }

  void _setHtmlImportOpen(bool value) {
    if (_htmlImportOpen == value) return;
    if (mounted) {
      setState(() => _htmlImportOpen = value);
    } else {
      _htmlImportOpen = value;
    }
  }

  void _setWebImportOpen(bool value) {
    if (_webImportOpen == value) return;
    if (mounted) {
      setState(() => _webImportOpen = value);
    } else {
      _webImportOpen = value;
    }
  }

  void _setJsonImportInProgress(bool value) {
    if (_jsonImportInProgress == value) return;
    if (mounted) {
      setState(() => _jsonImportInProgress = value);
    } else {
      _jsonImportInProgress = value;
    }
  }

  void _setJsonShareInProgress(bool value) {
    if (_jsonShareInProgress == value) return;
    if (mounted) {
      setState(() => _jsonShareInProgress = value);
    } else {
      _jsonShareInProgress = value;
    }
  }

  void _setJsonSaveInProgress(bool value) {
    if (_jsonSaveInProgress == value) return;
    if (mounted) {
      setState(() => _jsonSaveInProgress = value);
    } else {
      _jsonSaveInProgress = value;
    }
  }

  Future<void> _openHtmlImport() async {
    if (_htmlImportOpen || !mounted) {
      return;
    }
    _setHtmlImportOpen(true);
    try {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SchoolHtmlImportPage()));
    } finally {
      _setHtmlImportOpen(false);
    }
  }

  Future<void> _openWebImportForSite(SchoolSite site) async {
    if (_webImportOpen || !mounted) {
      return;
    }
    _setWebImportOpen(true);
    final provider = context.read<TimetableProvider>();
    try {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
            value: provider,
            child: SchoolWebImportPage(site: site),
          ),
        ),
      );
    } finally {
      _setWebImportOpen(false);
    }
  }

  Future<void> _addSite() async {
    if (_editorDialogOpen || !mounted) {
      return;
    }
    _setEditorDialogOpen(true);
    try {
      final created = await _showEditorDialog();
      if (!mounted || created == null) {
        return;
      }
      await _persistSites([..._sites, created]);
    } finally {
      _setEditorDialogOpen(false);
    }
  }

  Future<void> _editSite(int index) async {
    if (_editorDialogOpen || !mounted) {
      return;
    }
    _setEditorDialogOpen(true);
    try {
      final updated = await _showEditorDialog(initialSite: _sites[index]);
      if (!mounted || updated == null) {
        return;
      }
      final nextSites = [..._sites];
      nextSites[index] = updated;
      await _persistSites(nextSites);
    } finally {
      _setEditorDialogOpen(false);
    }
  }

  Future<void> _deleteSite(int index) async {
    final l10n = AppLocalizations.of(context);
    final site = _sites[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        var popped = false;
        void popWith(bool value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }

        return AlertDialog(
          title: Text(l10n.schoolSitesDeleteTitle),
          content: Text(l10n.schoolSitesDeleteMessage(site.name)),
          actions: [
            TextButton(
              onPressed: () => popWith(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => popWith(true),
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

    final future = showDialog<SchoolSite>(
      context: context,
      builder: (context) {
        var popped = false;
        void popWith(SchoolSite? value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }

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
              onPressed: () => popWith(null),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (popped) return;
                final site = SchoolSite(
                  name: nameController.text.trim(),
                  loginUrl: urlController.text.trim(),
                );
                if (!site.isValid) {
                  _showMessage(l10n.schoolSitesFormInvalid);
                  return;
                }
                popWith(site);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
    future.whenComplete(() {
      nameController.dispose();
      urlController.dispose();
    });
    return future;
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
    if (_jsonImportInProgress || !mounted) {
      return;
    }
    _setJsonImportInProgress(true);
    final l10n = AppLocalizations.of(context);
    try {
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
    } finally {
      _setJsonImportInProgress(false);
    }
  }

  Future<void> _shareJson() async {
    if (_jsonShareInProgress || !mounted) {
      return;
    }
    _setJsonShareInProgress(true);
    final l10n = AppLocalizations.of(context);
    try {
      final content = await _siteService.exportSites(_sites);
      if (!mounted) {
        return;
      }
      await _exportService.shareFile(
        ExportPayload(fileName: l10n.schoolSitesJsonFileName, content: content),
      );
    } finally {
      _setJsonShareInProgress(false);
    }
  }

  Future<void> _saveJsonToFile() async {
    if (_jsonSaveInProgress || !mounted) {
      return;
    }
    _setJsonSaveInProgress(true);
    try {
      await _saveJsonToFileInner();
    } finally {
      _setJsonSaveInProgress(false);
    }
  }

  Future<void> _saveJsonToFileInner() async {
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
          await _saveJsonToFileInner();
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
}
