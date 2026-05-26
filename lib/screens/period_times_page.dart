import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../services/export_service.dart';
import '../widgets/text_transfer_widgets.dart';

enum _PeriodTimesMenuAction {
  importTemplate,
  importTemplateText,
  exportTemplate,
  saveTemplate,
  exportTemplateText,
  deleteSet,
}

/// 这块单独拆页，不塞进设置弹窗里，不然一口气改多节时间会很难操作。
class PeriodTimesPage extends StatefulWidget {
  const PeriodTimesPage({super.key, required this.periodTimeSetId});

  final String periodTimeSetId;

  @override
  State<PeriodTimesPage> createState() => _PeriodTimesPageState();
}

class _PeriodTimesPageState extends State<PeriodTimesPage> {
  static const _exportService = ExportService();

  late final TextEditingController _nameController;
  late List<CoursePeriodTime> _periodTimes;
  var _loading = true;
  var _timePickerOpen = false;
  var _menuActionInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading) {
      final provider = context.read<TimetableProvider>();
      final periodTimeSet = provider.periodTimeSetForId(widget.periodTimeSetId);
      if (periodTimeSet != null) {
        _nameController.text = periodTimeSet.name;
        _periodTimes = periodTimeSet.periodTimes
            .map((item) => item.copyWith())
            .toList();
      } else {
        _nameController.text = AppLocalizations.of(context).periodTimesTitle;
        _periodTimes = buildPeriodTimesForCount(10);
      }
      _loading = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.periodTimesTitle),
        actions: [
          PopupMenuButton<_PeriodTimesMenuAction>(
            tooltip: l10n.importExport,
            enabled: !_menuActionInProgress,
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _PeriodTimesMenuAction.importTemplate,
                child: Text(l10n.importPeriodTemplate),
              ),
              PopupMenuItem(
                value: _PeriodTimesMenuAction.importTemplateText,
                child: Text(l10n.importPeriodTemplateText),
              ),
              PopupMenuItem(
                value: _PeriodTimesMenuAction.exportTemplate,
                child: Text(l10n.sharePeriodTemplate),
              ),
              PopupMenuItem(
                value: _PeriodTimesMenuAction.saveTemplate,
                child: Text(l10n.saveTemplateToFile),
              ),
              PopupMenuItem(
                value: _PeriodTimesMenuAction.exportTemplateText,
                child: Text(l10n.exportPeriodTemplateText),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _PeriodTimesMenuAction.deleteSet,
                child: Text(l10n.deletePeriodTimeSet),
              ),
            ],
          ),
          TextButton(onPressed: _save, child: Text(l10n.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.periodTimeSetName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < _periodTimes.length; index++)
            _buildPeriodCard(index),
          OutlinedButton.icon(
            onPressed: _addPeriod,
            icon: const Icon(Icons.add),
            label: Text(l10n.addOnePeriod),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(int index) {
    final l10n = AppLocalizations.of(context);
    final period = _periodTimes[index];
    final previous = index == 0 ? null : _periodTimes[index - 1];
    final duration = period.endMinutes - period.startMinutes;
    final gap = previous == null
        ? null
        : period.startMinutes - previous.endMinutes;
    final invalid = duration <= 0 || (previous != null && gap! < 0);

    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.periodNumberLabel(period.index),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (_periodTimes.length > 1)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.deleteThisPeriod,
                    onPressed: () => _removePeriod(index),
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _TimeCell(
                    label: l10n.startTime,
                    value: formatMinutes(period.startMinutes),
                    onTap: _timePickerOpen
                        ? null
                        : () => _pickPeriodTime(index, isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeCell(
                    label: l10n.endTime,
                    value: formatMinutes(period.endMinutes),
                    onTap: _timePickerOpen
                        ? null
                        : () => _pickPeriodTime(index, isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(
                  label: l10n.durationMinutes(duration > 0 ? duration : 0),
                ),
                if (gap != null)
                  _MetaChip(label: l10n.gapFromPrevious(gap > 0 ? gap : 0)),
              ],
            ),
            if (invalid) ...[
              const SizedBox(height: 10),
              Text(
                duration <= 0
                    ? l10n.endTimeMustBeLater
                    : l10n.periodOverlapPrevious,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(_PeriodTimesMenuAction action) async {
    if (_menuActionInProgress) {
      return;
    }
    _setMenuActionInProgress(true);
    try {
      switch (action) {
        case _PeriodTimesMenuAction.importTemplate:
          await _importTemplate();
          return;
        case _PeriodTimesMenuAction.importTemplateText:
          await _importTemplateFromText();
          return;
        case _PeriodTimesMenuAction.exportTemplate:
          await _shareTemplate();
          return;
        case _PeriodTimesMenuAction.saveTemplate:
          await _saveTemplateToFile();
          return;
        case _PeriodTimesMenuAction.exportTemplateText:
          await _exportTemplateAsText();
          return;
        case _PeriodTimesMenuAction.deleteSet:
          await _deleteSet();
          return;
      }
    } finally {
      _setMenuActionInProgress(false);
    }
  }

  void _setMenuActionInProgress(bool value) {
    if (mounted) {
      setState(() => _menuActionInProgress = value);
    } else {
      _menuActionInProgress = value;
    }
  }

  void _addPeriod() {
    setState(() {
      _periodTimes = buildPeriodTimesForCount(
        _periodTimes.length + 1,
        source: _periodTimes,
      );
    });
  }

  void _removePeriod(int index) {
    setState(() {
      final next = [..._periodTimes]..removeAt(index);
      _periodTimes = List.generate(
        next.length,
        (itemIndex) => next[itemIndex].copyWith(index: itemIndex + 1),
      );
    });
  }

  Future<void> _save() async {
    final provider = context.read<TimetableProvider>();
    final normalized = buildPeriodTimesForCount(
      _periodTimes.length,
      source: _periodTimes,
    );
    await provider.updatePeriodTimeSet(
      PeriodTimeSet(
        id: widget.periodTimeSetId,
        name: _nameController.text.trim(),
        periodTimes: normalized,
      ),
    );
    if (mounted) {
      _showMessage(AppLocalizations.of(context).periodTimesSaved);
    }
  }

  Future<void> _deleteSet() async {
    final provider = context.read<TimetableProvider>();
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final name = _nameController.text.trim().isEmpty
            ? l10n.currentPeriodTimeSet
            : _nameController.text.trim();
        var popped = false;
        void popWith(bool value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }

        return AlertDialog(
          title: Text(l10n.deletePeriodTimeSetTitle),
          content: Text(l10n.deletePeriodTimeSetMessage(name)),
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
    try {
      await provider.deletePeriodTimeSet(widget.periodTimeSetId);
      if (mounted) {
        navigator.pop(true);
      }
    } on FormatException catch (error) {
      _showMessage(error.message);
    }
  }

  Future<void> _importTemplate() async {
    final provider = context.read<TimetableProvider>();
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
      final decoded = utf8.decode(bytes);
      final imported = provider.importPeriodTimesJson(decoded);
      final count = imported.length;
      if (count == 0) {
        throw FormatException(
          noPeriodTimesInImportMessage(localeCode: provider.localeCode),
        );
      }
      setState(() {
        _periodTimes = imported;
      });
      _showMessage(l10n.importedPeriodTimesCount(count));
    } on FormatException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(l10n.importFailedCheckContent);
    }
  }

  Future<void> _importTemplateFromText() async {
    final l10n = AppLocalizations.of(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextImportPage(
          title: l10n.importPeriodTemplateText,
          onSubmit: (_, content) async {
            if (!mounted) {
              return false;
            }
            final provider = context.read<TimetableProvider>();
            try {
              final imported = provider.importPeriodTimesJson(content);
              final count = imported.length;
              if (count == 0) {
                throw FormatException(
                  noPeriodTimesInImportMessage(localeCode: provider.localeCode),
                );
              }
              if (!mounted) {
                return false;
              }
              setState(() {
                _periodTimes = imported;
              });
              _showMessage(l10n.importedPeriodTimesCount(count));
              return true;
            } on FormatException catch (error) {
              _showMessage(error.message);
              return false;
            } catch (_) {
              _showMessage(l10n.importFailedCheckContent);
              return false;
            }
          },
        ),
      ),
    );
  }

  Future<void> _shareTemplate() async {
    await _exportService.shareFile(
      ExportPayload(
        fileName: 'Sked_period_times.json',
        content: encodePeriodTimesEnvelope(_periodTimes),
      ),
    );
  }

  Future<void> _exportTemplateAsText() async {
    final l10n = AppLocalizations.of(context);
    await showTextExportDialog(
      context,
      title: l10n.exportPeriodTemplateText,
      content: encodePeriodTimesEnvelope(_periodTimes),
    );
  }

  Future<void> _saveTemplateToFile() async {
    final l10n = AppLocalizations.of(context);
    final result = await _exportService.saveFile(
      ExportPayload(
        fileName: 'Sked_period_times.json',
        content: encodePeriodTimesEnvelope(_periodTimes),
      ),
    );

    switch (result.status) {
      case ExportSaveStatus.saved:
        _showMessage(l10n.savedToPath(result.path ?? 'Sked_period_times.json'));
        return;
      case ExportSaveStatus.cancelled:
        _showMessage(l10n.saveCancelled);
        return;
      case ExportSaveStatus.permissionDenied:
        final retry = await _showPermissionDialog(
          title: l10n.periodFilePermissionTitle,
          message: l10n.androidFilePermissionMessage,
          confirmText: l10n.reauthorize,
        );
        if (retry == true && mounted) {
          await _saveTemplateToFile();
        }
        return;
      case ExportSaveStatus.permissionPermanentlyDenied:
        final openSettings = await _showPermissionDialog(
          title: l10n.permissionPermanentlyDeniedTitle,
          message: l10n.permissionSettingsExportMessage,
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
          await _shareTemplate();
          _showMessage(l10n.exportSwitchedToShare);
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
          await _shareTemplate();
          _showMessage(l10n.exportSwitchedToShare);
        } else {
          _showMessage(l10n.saveFailedRetry);
        }
        return;
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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

  Future<void> _pickPeriodTime(int index, {required bool isStart}) async {
    if (_timePickerOpen || index < 0 || index >= _periodTimes.length) {
      return;
    }
    setState(() => _timePickerOpen = true);
    // 这里先只改草稿，等用户点保存时再整体写回，避免改到一半就影响正在用的课表。
    final period = _periodTimes[index];
    final initialMinutes = normalizeMinuteOfDay(
      isStart ? period.startMinutes : period.endMinutes,
    );
    try {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: initialMinutes ~/ 60,
          minute: initialMinutes % 60,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (!mounted ||
          picked == null ||
          index < 0 ||
          index >= _periodTimes.length) {
        return;
      }
      final minutes = (picked.hour * 60) + picked.minute;
      setState(() {
        final currentPeriod = _periodTimes[index];
        _periodTimes[index] = isStart
            ? currentPeriod.copyWith(startMinutes: minutes)
            : currentPeriod.copyWith(endMinutes: minutes);
      });
    } finally {
      if (mounted) {
        setState(() => _timePickerOpen = false);
      } else {
        _timePickerOpen = false;
      }
    }
  }
}

class _TimeCell extends StatelessWidget {
  const _TimeCell({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
