import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';

class GeneralEventDetailsSheet extends StatelessWidget {
  const GeneralEventDetailsSheet({
    super.key,
    required this.occurrence,
    this.onEdit,
    this.onDelete,
  });

  final GeneralEventOccurrence occurrence;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final event = occurrence.event;

    final startDt = DateTime.tryParse(event.startDateTimeIso);
    final endDt = DateTime.tryParse(event.endDateTimeIso);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(event.title, style: theme.textTheme.titleLarge),

          if (event.recurrence == GeneralEventRecurrence.weekly) ...[
            const SizedBox(height: 4),
            Text(
              l10n.repeatsWeekly,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            if (event.recurrenceEndDateIso != null) ...[
              const SizedBox(height: 2),
              Text(
                l10n.recurrenceUntil(_fmtDate(event.recurrenceEndDateIso!)),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ],

          const SizedBox(height: 16),

          if (startDt != null && endDt != null) ...[
            _InfoRow(
              icon: Icons.access_time,
              label: l10n.eventTime,
              value: '${_fmtDateTime(startDt)} - ${_fmtTime(endDt)}',
            ),
          ],

          _InfoRow(
            icon: Icons.calendar_today,
            label: l10n.eventDate,
            value: startDt != null ? _fmtDate(startDt.toIso8601String()) : '-',
          ),

          if (event.location.isNotEmpty)
            _InfoRow(
              icon: Icons.location_on,
              label: l10n.location,
              value: event.location,
            ),

          if (event.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.eventNotes,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
            ),
            const SizedBox(height: 4),
            Text(event.notes),
          ],

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDelete != null)
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  label: Text(l10n.delete),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              if (onEdit != null) ...[
                const Spacer(),
                FilledButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.editEvent),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _fmtDateTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} $h:$m';
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _fmtDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurface.withAlpha(160)),
          const SizedBox(width: 12),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
