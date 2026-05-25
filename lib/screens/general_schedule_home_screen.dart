import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../widgets/adaptive_modal_surface.dart';
import '../widgets/general_event_details_sheet.dart';
import '../widgets/general_event_editor_sheet.dart';
import '../widgets/mode_switch_action.dart';
import 'settings_page.dart';

part 'general_schedule_list_view.dart';
part 'general_schedule_reminder_strip.dart';
part 'general_schedule_filter_bar.dart';
part 'general_schedule_timeline_view.dart';
part 'general_schedule_calendar_manager.dart';

class GeneralScheduleHomeScreen extends StatefulWidget {
  const GeneralScheduleHomeScreen({super.key});

  @override
  State<GeneralScheduleHomeScreen> createState() =>
      _GeneralScheduleHomeScreenState();
}

class _GeneralScheduleHomeScreenState extends State<GeneralScheduleHomeScreen> {
  final _searchController = TextEditingController();
  String? _view;
  String _searchQuery = '';
  int? _colorFilterValue;
  bool _initializedView = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedView) {
      _view = context.read<TimetableProvider>().generalDefaultView;
      _initializedView = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimetableProvider>();
    final l10n = AppLocalizations.of(context);
    final selectedDate = provider.selectedGeneralDate;
    final view = normalizeGeneralView(_view ?? provider.generalDefaultView);
    final filter = _GeneralOccurrenceFilter(
      query: _searchQuery,
      colorValue: _colorFilterValue,
    );
    final colorOptions = _availableFilterColors(
      provider.visibleGeneralSchedules,
      query: _searchQuery,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _pickDate(context, provider),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sked', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  _yearLabel(selectedDate, view),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
        actions: [
          const ModeSwitchAction(),
          IconButton(
            icon: const Icon(Icons.today_outlined),
            tooltip: l10n.today,
            onPressed: () => _goToToday(provider),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: l10n.calendars,
            onPressed: () => _openCalendarManager(context, provider),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addEvent,
            onPressed: () => _openEditor(context, provider),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ChangeNotifierProvider<TimetableProvider>.value(
                        value: provider,
                        child: const SettingsPage(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, provider),
        tooltip: l10n.addEvent,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: generalViewWeek,
                          icon: const Icon(Icons.view_week_outlined),
                          label: Text(l10n.viewWeek),
                        ),
                        ButtonSegment(
                          value: generalViewDay,
                          icon: const Icon(Icons.view_day_outlined),
                          label: Text(l10n.viewDay),
                        ),
                        ButtonSegment(
                          value: generalViewList,
                          icon: const Icon(Icons.list_alt_outlined),
                          label: Text(l10n.viewList),
                        ),
                      ],
                      selected: {view},
                      showSelectedIcon: false,
                      onSelectionChanged: (selection) {
                        setState(() => _view = selection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
            _FilterBar(
              controller: _searchController,
              colorValue: _colorFilterValue,
              colorOptions: colorOptions,
              onSearchChanged: (value) => setState(() {
                _searchQuery = value;
              }),
              onClearSearch: () => setState(() {
                _searchController.clear();
                _searchQuery = '';
              }),
              onColorChanged: (value) => setState(() {
                _colorFilterValue = value;
              }),
            ),
            _ReminderStrip(
              provider: provider,
              filter: filter,
              onOccurrenceTap: (occurrence) =>
                  _openDetails(context, provider, occurrence),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.invertedStylus,
                  },
                ),
                child: switch (view) {
                  generalViewDay => _DayCalendarView(
                    date: selectedDate,
                    provider: provider,
                    filter: filter,
                    onEmptySlotTap: (date) =>
                        _openEditor(context, provider, initialDate: date),
                    onOccurrenceTap: (occurrence) =>
                        _openDetails(context, provider, occurrence),
                  ),
                  generalViewList => _ListCalendarView(
                    date: selectedDate,
                    provider: provider,
                    filter: filter,
                    onToday: () => _goToToday(provider),
                    onPickDate: () => _pickDate(context, provider),
                    onOccurrenceTap: (occurrence) =>
                        _openDetails(context, provider, occurrence),
                  ),
                  _ => _WeekCalendarView(
                    date: selectedDate,
                    provider: provider,
                    filter: filter,
                    onDaySelected: provider.setSelectedGeneralDate,
                    onEmptySlotTap: (date) =>
                        _openEditor(context, provider, initialDate: date),
                    onOccurrenceTap: (occurrence) =>
                        _openDetails(context, provider, occurrence),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToToday(TimetableProvider provider) async {
    await provider.setSelectedGeneralDate(DateTime.now());
  }

  Future<void> _pickDate(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final firstDate = DateTime(1970);
    final lastDate = DateTime(2100);
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(
        provider.selectedGeneralDate,
        firstDate,
        lastDate,
      ),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (!mounted || picked == null) {
      return;
    }
    await provider.setSelectedGeneralDate(picked);
  }

  Future<void> _openEditor(
    BuildContext context,
    TimetableProvider provider, {
    DateTime? initialDate,
    GeneralEvent? event,
  }) async {
    final canDismiss = provider.closeGeneralEventPopupOnOutsideTap;
    final result = await showModalBottomSheet<GeneralEventEditorResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AdaptiveModalSurface(
        maxWidth: 680,
        dismissOnOutsideTap: canDismiss,
        child: GeneralEventEditorSheet(
          initialEvent: event,
          initialDate: initialDate ?? provider.selectedGeneralDate,
          calendars: provider.generalSchedules,
          activeCalendarId: provider.activeGeneralSchedule.id,
        ),
      ),
    );

    if (result == null || !mounted) return;

    if (result.delete && event != null) {
      await provider.deleteGeneralEvent(event.id);
    } else if (result.event != null) {
      await provider.saveGeneralEvent(result.event!);
    }
  }

  Future<void> _openDetails(
    BuildContext context,
    TimetableProvider provider,
    GeneralEventOccurrence occurrence,
  ) async {
    final canDismiss = provider.closeGeneralEventPopupOnOutsideTap;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AdaptiveModalSurface(
        maxWidth: 560,
        dismissOnOutsideTap: canDismiss,
        child: GeneralEventDetailsSheet(
          occurrence: occurrence,
          isReminderHandled: provider.isGeneralReminderHandled(occurrence),
          onEdit: () {
            Navigator.of(sheetContext).pop();
            _openEditor(context, provider, event: occurrence.event);
          },
          onDismissReminder: () async {
            final messenger = ScaffoldMessenger.of(context);
            final message = AppLocalizations.of(context).reminderHandled;
            await provider.dismissGeneralReminder(occurrence);
            if (sheetContext.mounted) Navigator.of(sheetContext).pop();
            if (mounted) {
              messenger.showSnackBar(SnackBar(content: Text(message)));
            }
          },
          onRestoreReminder: () async {
            final messenger = ScaffoldMessenger.of(context);
            final message = AppLocalizations.of(context).reminderRestored;
            await provider.restoreGeneralReminder(occurrence);
            if (sheetContext.mounted) Navigator.of(sheetContext).pop();
            if (mounted) {
              messenger.showSnackBar(SnackBar(content: Text(message)));
            }
          },
          onDuplicate: () async {
            final messenger = ScaffoldMessenger.of(context);
            final message = AppLocalizations.of(context).eventDuplicated;
            await provider.duplicateGeneralOccurrence(occurrence);
            if (sheetContext.mounted) Navigator.of(sheetContext).pop();
            if (mounted) {
              messenger.showSnackBar(SnackBar(content: Text(message)));
            }
          },
          onDeleteThis: () async {
            await provider.deleteGeneralOccurrence(occurrence);
            if (sheetContext.mounted) Navigator.of(sheetContext).pop();
          },
          onDeleteFuture: occurrence.event.recurrenceRule.isRepeating
              ? () async {
                  await provider.deleteFutureGeneralOccurrences(occurrence);
                  if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                }
              : null,
          onDeleteAll: () async {
            await provider.deleteGeneralEvent(occurrence.event.id);
            if (sheetContext.mounted) Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openCalendarManager(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final canDismiss = provider.closeGeneralEventPopupOnOutsideTap;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AdaptiveModalSurface(
        maxWidth: 620,
        dismissOnOutsideTap: canDismiss,
        child: ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const _CalendarManagerSheet(),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
    );
  }
}

List<DateTime> _visibleWeekDays(DateTime weekStart, bool showWeekends) {
  return [
    for (var i = 0; i < 7; i++)
      if (showWeekends || i < 5) weekStart.add(Duration(days: i)),
  ];
}

List<int> _availableFilterColors(
  List<GeneralSchedule> schedules, {
  String query = '',
}) {
  final values = <int>{};
  final normalizedQuery = query.trim().toLowerCase();
  for (final schedule in schedules) {
    for (final event in schedule.events) {
      if (normalizedQuery.isNotEmpty &&
          ![
            event.title,
            event.location,
            event.notes,
            schedule.name,
          ].any((value) => value.toLowerCase().contains(normalizedQuery))) {
        continue;
      }
      values.add(event.colorValue ?? schedule.colorValue);
    }
  }
  return values.toList()..sort();
}

String _yearLabel(DateTime date, String view) {
  if (view != generalViewWeek) {
    return date.year.toString();
  }
  final start = startOfWeekMonday(date);
  final end = start.add(const Duration(days: 6));
  return start.year == end.year
      ? '${start.year}'
      : '${start.year} / ${end.year}';
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

DateTime _clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
  if (date.isBefore(firstDate)) {
    return firstDate;
  }
  if (date.isAfter(lastDate)) {
    return lastDate;
  }
  return date;
}

String _formatTime(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String _formatOccurrenceTime(
  BuildContext context,
  GeneralEventOccurrence occurrence,
) {
  if (occurrence.isAllDay) {
    return AppLocalizations.of(context).allDay;
  }
  if (!_sameDay(occurrence.start, occurrence.end)) {
    return '${_formatDate(occurrence.start)} ${_formatTime(occurrence.start)} - ${_formatDate(occurrence.end)} ${_formatTime(occurrence.end)}';
  }
  return '${_formatTime(occurrence.start)} - ${_formatTime(occurrence.end)}';
}

String _weekdayLabel(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context);
  return switch (date.weekday) {
    DateTime.monday => l10n.weekdayShortMonday,
    DateTime.tuesday => l10n.weekdayShortTuesday,
    DateTime.wednesday => l10n.weekdayShortWednesday,
    DateTime.thursday => l10n.weekdayShortThursday,
    DateTime.friday => l10n.weekdayShortFriday,
    DateTime.saturday => l10n.weekdayShortSaturday,
    _ => l10n.weekdayShortSunday,
  };
}

String _dateKey(DateTime date) => normalizeDateOnly(date).toIso8601String();

bool _sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _occurrenceIntersectsDay(GeneralEventOccurrence occurrence, DateTime day) {
  final start = normalizeDateOnly(day);
  final end = start.add(const Duration(days: 1));
  return occurrence.end.isAfter(start) && occurrence.start.isBefore(end);
}

int _nowMinutes() {
  final now = DateTime.now();
  return now.hour * 60 + now.minute;
}

int _snapMinutes(int minutes, int gridMinutes) {
  final step = gridMinutes.clamp(15, 60).toInt();
  return (minutes / step).round() * step;
}

Color _readableColor(Color color) {
  return color.computeLuminance() > 0.42 ? Colors.black87 : Colors.white;
}

int _nextCalendarColor(List<GeneralSchedule> schedules) {
  const colors = [
    0xFF4DB6AC,
    0xFF64B5F6,
    0xFFFFB74D,
    0xFFBA68C8,
    0xFF81C784,
    0xFFE57373,
  ];
  return colors[schedules.length % colors.length];
}
