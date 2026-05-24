import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';

class GeneralEventDetailsSheet extends StatelessWidget {
  const GeneralEventDetailsSheet({
    super.key,
    required this.occurrence,
    this.onEdit,
    this.onDuplicate,
    this.onDeleteThis,
    this.onDeleteFuture,
    this.onDeleteAll,
  });

  final GeneralEventOccurrence occurrence;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDeleteThis;
  final VoidCallback? onDeleteFuture;
  final VoidCallback? onDeleteAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final event = occurrence.event;
    final color = Color(event.colorValue ?? occurrence.calendar.colorValue);
    final isRepeating = event.recurrenceRule.isRepeating;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        occurrence.calendar.name,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _InfoRow(
              icon: Icons.access_time,
              value: _formatOccurrenceTime(occurrence, l10n),
            ),
            if (isRepeating)
              _InfoRow(
                icon: Icons.repeat,
                value: _repeatSummary(event.recurrenceRule, l10n),
              ),
            if (event.reminders.isNotEmpty)
              _InfoRow(
                icon: Icons.notifications_outlined,
                value: event.reminders
                    .map((item) => _reminderLabel(item.minutesBefore, l10n))
                    .join(', '),
              ),
            if (event.location.isNotEmpty)
              _InfoRow(icon: Icons.location_on_outlined, value: event.location),
            if (event.notes.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                l10n.eventNotes,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(height: 6),
              Text(event.notes),
            ],
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                if (onDeleteThis != null)
                  OutlinedButton.icon(
                    onPressed: onDeleteThis,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(
                      isRepeating ? l10n.deleteThisOccurrence : l10n.delete,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                if (isRepeating && onDeleteFuture != null)
                  OutlinedButton.icon(
                    onPressed: onDeleteFuture,
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: Text(l10n.deleteFutureOccurrences),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                if (isRepeating && onDeleteAll != null)
                  OutlinedButton.icon(
                    onPressed: onDeleteAll,
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: Text(l10n.deleteAllOccurrences),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                if (onEdit != null)
                  FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l10n.editEvent),
                  ),
                if (onDuplicate != null)
                  FilledButton.icon(
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.content_copy_outlined),
                    label: Text(l10n.duplicateEvent),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

String _formatOccurrenceTime(
  GeneralEventOccurrence occurrence,
  AppLocalizations l10n,
) {
  if (occurrence.isAllDay) {
    final end = occurrence.end.subtract(const Duration(days: 1));
    if (_sameDay(occurrence.start, end)) {
      return '${_fmtDate(occurrence.start)}  ${l10n.allDay}';
    }
    return '${_fmtDate(occurrence.start)} - ${_fmtDate(end)}  ${l10n.allDay}';
  }
  if (_sameDay(occurrence.start, occurrence.end)) {
    return '${_fmtDate(occurrence.start)} ${_fmtTime(occurrence.start)} - ${_fmtTime(occurrence.end)}';
  }
  return '${_fmtDate(occurrence.start)} ${_fmtTime(occurrence.start)} - ${_fmtDate(occurrence.end)} ${_fmtTime(occurrence.end)}';
}

String _repeatSummary(GeneralEventRecurrenceRule rule, AppLocalizations l10n) {
  final base = switch (rule.type) {
    GeneralEventRecurrence.daily => l10n.repeatsDaily,
    GeneralEventRecurrence.weekly => l10n.repeatsWeekly,
    GeneralEventRecurrence.monthly => l10n.repeatsMonthly,
    GeneralEventRecurrence.custom => l10n.repeatsEvery(
      rule.normalizedInterval,
      _unitLabel(rule.unit, l10n),
    ),
    GeneralEventRecurrence.none => l10n.recurrenceNone,
  };
  final suffix = [
    if (rule.untilDateIso != null) l10n.recurrenceUntil(rule.untilDateIso!),
    if (rule.count != null && rule.count! > 0)
      l10n.recurrenceCountTimes(rule.count!),
  ].join(', ');
  return suffix.isEmpty ? base : '$base, $suffix';
}

String _unitLabel(GeneralEventRecurrenceUnit unit, AppLocalizations l10n) {
  return switch (unit) {
    GeneralEventRecurrenceUnit.day => l10n.recurrenceDays,
    GeneralEventRecurrenceUnit.week => l10n.recurrenceWeeks,
    GeneralEventRecurrenceUnit.month => l10n.recurrenceMonths,
  };
}

String _reminderLabel(int minutes, AppLocalizations l10n) {
  return switch (minutes) {
    0 => l10n.reminderAtStart,
    60 => l10n.reminderHourBefore,
    1440 => l10n.reminderDayBefore,
    _ => l10n.reminderMinutesBefore(minutes),
  };
}

String _fmtDate(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

String _fmtTime(DateTime dt) {
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

bool _sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
