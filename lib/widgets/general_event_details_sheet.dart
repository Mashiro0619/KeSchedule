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
              value: _formatOccurrenceTime(occurrence),
            ),
            if (isRepeating)
              _InfoRow(
                icon: Icons.repeat,
                value: _repeatSummary(event.recurrenceRule),
              ),
            if (event.reminders.isNotEmpty)
              _InfoRow(
                icon: Icons.notifications_outlined,
                value: event.reminders
                    .map((item) => _reminderLabel(item.minutesBefore))
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
                    label: Text(isRepeating ? 'Delete this' : l10n.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                if (isRepeating && onDeleteFuture != null)
                  OutlinedButton.icon(
                    onPressed: onDeleteFuture,
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: const Text('Delete future'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                if (isRepeating && onDeleteAll != null)
                  OutlinedButton.icon(
                    onPressed: onDeleteAll,
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Delete all'),
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
                    label: const Text('Duplicate'),
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

String _formatOccurrenceTime(GeneralEventOccurrence occurrence) {
  if (occurrence.isAllDay) {
    final end = occurrence.end.subtract(const Duration(days: 1));
    if (_sameDay(occurrence.start, end)) {
      return '${_fmtDate(occurrence.start)}  All-day';
    }
    return '${_fmtDate(occurrence.start)} - ${_fmtDate(end)}  All-day';
  }
  if (_sameDay(occurrence.start, occurrence.end)) {
    return '${_fmtDate(occurrence.start)} ${_fmtTime(occurrence.start)} - ${_fmtTime(occurrence.end)}';
  }
  return '${_fmtDate(occurrence.start)} ${_fmtTime(occurrence.start)} - ${_fmtDate(occurrence.end)} ${_fmtTime(occurrence.end)}';
}

String _repeatSummary(GeneralEventRecurrenceRule rule) {
  final base = switch (rule.type) {
    GeneralEventRecurrence.daily => 'Repeats daily',
    GeneralEventRecurrence.weekly => 'Repeats weekly',
    GeneralEventRecurrence.monthly => 'Repeats monthly',
    GeneralEventRecurrence.custom =>
      'Repeats every ${rule.normalizedInterval} ${_unitLabel(rule.unit)}',
    GeneralEventRecurrence.none => 'Does not repeat',
  };
  final suffix = [
    if (rule.untilDateIso != null) 'until ${rule.untilDateIso}',
    if (rule.count != null && rule.count! > 0) '${rule.count} times',
  ].join(', ');
  return suffix.isEmpty ? base : '$base, $suffix';
}

String _unitLabel(GeneralEventRecurrenceUnit unit) {
  return switch (unit) {
    GeneralEventRecurrenceUnit.day => 'days',
    GeneralEventRecurrenceUnit.week => 'weeks',
    GeneralEventRecurrenceUnit.month => 'months',
  };
}

String _reminderLabel(int minutes) {
  return switch (minutes) {
    0 => 'At start',
    5 => '5 minutes before',
    10 => '10 minutes before',
    30 => '30 minutes before',
    60 => '1 hour before',
    1440 => '1 day before',
    _ => '$minutes minutes before',
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
