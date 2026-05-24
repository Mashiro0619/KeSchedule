part of 'general_schedule_home_screen.dart';

class _CalendarManagerSheet extends StatelessWidget {
  const _CalendarManagerSheet();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimetableProvider>();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
            child: Row(
              children: [
                Text(l10n.calendars, style: theme.textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  tooltip: l10n.addCalendar,
                  icon: const Icon(Icons.add),
                  onPressed: () => provider.addGeneralSchedule(
                    name: l10n.newCalendar,
                    colorValue: _nextCalendarColor(provider.generalSchedules),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              itemCount: provider.generalSchedules.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final schedule = provider.generalSchedules[index];
                final active = schedule.id == provider.activeGeneralSchedule.id;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  selected: active,
                  leading: _ColorDot(color: Color(schedule.colorValue)),
                  title: Text(schedule.name),
                  subtitle: Text(
                    l10n.generalScheduleEventCount(schedule.events.length),
                  ),
                  trailing: Wrap(
                    spacing: 2,
                    children: [
                      IconButton(
                        tooltip: schedule.isVisible
                            ? l10n.hideCalendar
                            : l10n.showCalendar,
                        icon: Icon(
                          schedule.isVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () =>
                            provider.updateGeneralScheduleVisibility(
                              schedule.id,
                              !schedule.isVisible,
                            ),
                      ),
                      IconButton(
                        tooltip: l10n.rename,
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _renameCalendar(context, schedule),
                      ),
                      IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteCalendar(context, schedule),
                      ),
                    ],
                  ),
                  onTap: () => provider.switchGeneralSchedule(schedule.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _renameCalendar(
    BuildContext context,
    GeneralSchedule schedule,
  ) async {
    final provider = context.read<TimetableProvider>();
    final controller = TextEditingController(text: schedule.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(l10n.renameCalendar),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.name,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await provider.renameGeneralSchedule(schedule.id, name);
    }
  }

  Future<void> _deleteCalendar(
    BuildContext context,
    GeneralSchedule schedule,
  ) async {
    final provider = context.read<TimetableProvider>();
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteCalendar),
        content: Text(l10n.deleteCalendarMessage(schedule.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await provider.deleteGeneralSchedule(schedule.id);
    }
  }
}
