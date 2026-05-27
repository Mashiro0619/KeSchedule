import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/timetable_provider.dart';
import '../screens/period_times_page.dart';

Future<String?> showPeriodTimeSetPickerDialog(
  BuildContext context, {
  required TimetableProvider provider,
  required String selectedPeriodTimeSetId,
}) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      var currentSelectedId = selectedPeriodTimeSetId;
      var popped = false;
      var busy = false;

      Future<void> openPeriodTimePage(String periodTimeSetId) async {
        await Navigator.of(dialogContext).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
              value: provider,
              child: PeriodTimesPage(periodTimeSetId: periodTimeSetId),
            ),
          ),
        );
      }

      return StatefulBuilder(
        builder: (dialogContext, refreshDialog) {
          final l10n = AppLocalizations.of(dialogContext);

          Future<void> runBusy(Future<void> Function() action) async {
            if (busy || popped) return;
            refreshDialog(() => busy = true);
            try {
              await action();
            } finally {
              if (dialogContext.mounted) {
                refreshDialog(() => busy = false);
              }
            }
          }

          void popOnce([String? result]) {
            if (popped) return;
            popped = true;
            Navigator.of(dialogContext).pop(result);
          }

          return AlertDialog(
            title: Row(
              children: [
                Expanded(child: Text(l10n.selectPeriodTimeSet)),
                TextButton.icon(
                  onPressed: (busy || popped)
                      ? null
                      : () => runBusy(() async {
                          final created = await provider.addPeriodTimeSet();
                          if (!dialogContext.mounted || popped) {
                            return;
                          }
                          currentSelectedId = created.id;
                          await openPeriodTimePage(created.id);
                        }),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newItem),
                ),
              ],
            ),
            content: SizedBox(
              width: 420,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: provider.periodTimeSets.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = provider.periodTimeSets[index];
                  final selected = item.id == currentSelectedId;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: selected
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                    title: Text(item.name),
                    subtitle: Text(
                      l10n.periodTimeSetSummary(
                        item.name,
                        item.periodTimes.length,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: l10n.editPeriodTimeSet,
                      onPressed: (busy || popped)
                          ? null
                          : () => runBusy(() async {
                              await openPeriodTimePage(item.id);
                              final stillExists =
                                  provider.periodTimeSetForId(item.id) != null;
                              if (!stillExists &&
                                  currentSelectedId == item.id) {
                                currentSelectedId =
                                    provider.activePeriodTimeSetOrNull?.id ??
                                    '';
                              }
                            }),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    onTap: (busy || popped) ? null : () => popOnce(item.id),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: (busy || popped) ? null : () => popOnce(),
                child: Text(l10n.cancel),
              ),
            ],
          );
        },
      );
    },
  );
}
