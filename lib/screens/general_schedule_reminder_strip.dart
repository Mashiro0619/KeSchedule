part of 'general_schedule_home_screen.dart';

class _ReminderStrip extends StatelessWidget {
  const _ReminderStrip({
    required this.provider,
    required this.filter,
    required this.onOccurrenceTap,
  });

  final TimetableProvider provider;
  final _GeneralOccurrenceFilter filter;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final reminderFilter = filter.toQuery(
      startInclusive: now.subtract(const Duration(hours: 24)),
      endExclusive: now.add(const Duration(hours: 24)),
    );
    final items = provider.generalReminderItems(
      now: now,
      occurrenceFilter: reminderFilter,
    );
    final upcoming = items
        .where((item) => item.status == GeneralReminderStatus.upcoming)
        .take(3)
        .toList();
    final inProgress = items
        .where((item) => item.status == GeneralReminderStatus.inProgress)
        .take(3)
        .toList();
    final overdue = items
        .where((item) => item.status == GeneralReminderStatus.overdue)
        .take(3)
        .toList();
    if (upcoming.isEmpty && inProgress.isEmpty && overdue.isEmpty) {
      return const SizedBox(height: 4);
    }
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 54,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          for (final item in upcoming)
            _GeneralReminderItemPill(
              item: item,
              statusLabel: l10n.reminderUpcoming,
              color: theme.colorScheme.primary,
              onTap: () => onOccurrenceTap(item.occurrence),
              onDismiss: () => provider.dismissGeneralReminder(item.occurrence),
            ),
          for (final item in inProgress)
            _GeneralReminderItemPill(
              item: item,
              statusLabel: l10n.reminderInProgress,
              color: theme.colorScheme.tertiary,
              onTap: () => onOccurrenceTap(item.occurrence),
              onDismiss: () => provider.dismissGeneralReminder(item.occurrence),
            ),
          for (final item in overdue)
            _GeneralReminderItemPill(
              item: item,
              statusLabel: l10n.reminderOverdue,
              color: theme.colorScheme.error,
              onTap: () => onOccurrenceTap(item.occurrence),
              onDismiss: () => provider.dismissGeneralReminder(item.occurrence),
            ),
        ],
      ),
    );
  }
}

class _GeneralReminderItemPill extends StatelessWidget {
  const _GeneralReminderItemPill({
    required this.item,
    required this.statusLabel,
    required this.color,
    required this.onTap,
    required this.onDismiss,
  });

  final GeneralReminderItem item;
  final String statusLabel;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: '${item.occurrence.event.title}, $statusLabel',
      child: Container(
        width: 210,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(24),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(96)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12, end: 2),
            child: Row(
              children: [
                Icon(
                  item.status == GeneralReminderStatus.upcoming
                      ? Icons.notifications_active_outlined
                      : item.status == GeneralReminderStatus.inProgress
                      ? Icons.play_circle_outline
                      : Icons.pending_actions_outlined,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$statusLabel - ${item.occurrence.event.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color),
                  ),
                ),
                IconButton(
                  tooltip: l10n.markReminderHandled,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  onPressed: onDismiss,
                  icon: const Icon(Icons.check_circle_outline),
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
