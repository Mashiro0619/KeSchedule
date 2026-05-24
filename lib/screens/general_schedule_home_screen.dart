import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../widgets/general_event_details_sheet.dart';
import '../widgets/general_event_editor_sheet.dart';
import '../widgets/mode_switch_action.dart';
import 'settings_page.dart';

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
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedGeneralDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      await provider.setSelectedGeneralDate(picked);
    }
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
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
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
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
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
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
        maxWidth: 620,
        dismissOnOutsideTap: canDismiss,
        child: ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const _CalendarManagerSheet(),
        ),
      ),
    );
  }

  Widget _buildAdaptiveBottomSheet(
    BuildContext context, {
    required double maxWidth,
    required bool dismissOnOutsideTap,
    required Widget child,
  }) {
    final width = MediaQuery.of(context).size.width;
    final isDesktopLike = width >= 900;

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismissOnOutsideTap
                  ? () => Navigator.of(context).maybePop()
                  : null,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktopLike ? maxWidth : width,
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.controller,
    required this.colorValue,
    required this.colorOptions,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onColorChanged,
  });

  final TextEditingController controller;
  final int? colorValue;
  final List<int> colorOptions;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<int?> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                hintText: l10n.searchEvents,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.clearSearch,
                        onPressed: onClearSearch,
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<int>(
            tooltip: l10n.filterByColor,
            icon: Icon(
              colorValue == null ? Icons.filter_alt_outlined : Icons.filter_alt,
            ),
            onSelected: (value) => onColorChanged(value < 0 ? null : value),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: -1, child: Text(l10n.allColors)),
              for (final option in colorOptions)
                PopupMenuItem<int>(
                  value: option,
                  child: Row(
                    children: [
                      _ColorDot(color: Color(option)),
                      const SizedBox(width: 10),
                      Text(
                        '#${option.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GeneralOccurrenceFilter {
  const _GeneralOccurrenceFilter({
    required this.query,
    required this.colorValue,
  });

  final String query;
  final int? colorValue;

  bool get isActive => query.trim().isNotEmpty || colorValue != null;

  GeneralOccurrenceQuery toQuery({
    required DateTime startInclusive,
    required DateTime endExclusive,
    bool onlyVisibleCalendars = true,
  }) {
    return GeneralOccurrenceQuery(
      startInclusive: startInclusive,
      endExclusive: endExclusive,
      onlyVisibleCalendars: onlyVisibleCalendars,
      searchQuery: query,
      colorValue: colorValue,
    );
  }

  bool matches(GeneralEventOccurrence occurrence) {
    return toQuery(
      startInclusive: occurrence.start,
      endExclusive: occurrence.end,
    ).matches(occurrence);
  }
}

class _WeekCalendarView extends StatelessWidget {
  const _WeekCalendarView({
    required this.date,
    required this.provider,
    required this.filter,
    required this.onDaySelected,
    required this.onEmptySlotTap,
    required this.onOccurrenceTap,
  });

  final DateTime date;
  final TimetableProvider provider;
  final _GeneralOccurrenceFilter filter;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onEmptySlotTap;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final weekStart = startOfWeekMonday(date);
    final days = _visibleWeekDays(weekStart, provider.generalShowWeekends);
    final occurrences = provider.generalOccurrencesForQuery(
      filter.toQuery(
        startInclusive: weekStart,
        endExclusive: weekStart.add(const Duration(days: 7)),
      ),
    );
    return _CalendarTimeline(
      days: days,
      selectedDate: date,
      occurrences: occurrences,
      startHour: provider.generalDayStartHour,
      endHour: provider.generalDayEndHour,
      gridMinutes: provider.generalTimeGridMinutes,
      onDaySelected: onDaySelected,
      onEmptySlotTap: onEmptySlotTap,
      onOccurrenceTap: onOccurrenceTap,
    );
  }
}

class _DayCalendarView extends StatelessWidget {
  const _DayCalendarView({
    required this.date,
    required this.provider,
    required this.filter,
    required this.onEmptySlotTap,
    required this.onOccurrenceTap,
  });

  final DateTime date;
  final TimetableProvider provider;
  final _GeneralOccurrenceFilter filter;
  final ValueChanged<DateTime> onEmptySlotTap;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final day = normalizeDateOnly(date);
    final occurrences = provider.generalOccurrencesForQuery(
      filter.toQuery(
        startInclusive: day,
        endExclusive: day.add(const Duration(days: 1)),
      ),
    );
    return _CalendarTimeline(
      days: [day],
      selectedDate: day,
      occurrences: occurrences,
      startHour: provider.generalDayStartHour,
      endHour: provider.generalDayEndHour,
      gridMinutes: provider.generalTimeGridMinutes,
      onDaySelected: (_) {},
      onEmptySlotTap: onEmptySlotTap,
      onOccurrenceTap: onOccurrenceTap,
    );
  }
}

class _CalendarTimeline extends StatelessWidget {
  const _CalendarTimeline({
    required this.days,
    required this.selectedDate,
    required this.occurrences,
    required this.startHour,
    required this.endHour,
    required this.gridMinutes,
    required this.onDaySelected,
    required this.onEmptySlotTap,
    required this.onOccurrenceTap,
  });

  static const double _headerHeight = 56;
  static const double _allDayHeight = 74;
  static const double _hourHeight = 72;

  final List<DateTime> days;
  final DateTime selectedDate;
  final List<GeneralEventOccurrence> occurrences;
  final int startHour;
  final int endHour;
  final int gridMinutes;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onEmptySlotTap;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }
    final startMinutes = startHour * 60;
    final endMinutes = endHour * 60;
    final contentHeight = math.max(1, endHour - startHour) * _hourHeight;
    final minuteHeight = _hourHeight / 60;

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _TimelineMetrics.fromWidth(
          constraints.maxWidth,
          dayCount: days.length,
        );

        return SizedBox(
          width: metrics.totalWidth,
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: Row(
                  children: [
                    SizedBox(width: metrics.timeColumnWidth),
                    for (final day in days)
                      _DayHeader(
                        date: day,
                        width: metrics.dayWidth,
                        selected: _sameDay(day, selectedDate),
                        onTap: () => onDaySelected(day),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: _allDayHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: metrics.timeColumnWidth,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.allDay,
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    for (final day in days)
                      _AllDayColumn(
                        date: day,
                        width: metrics.dayWidth,
                        occurrences: _allDayOccurrencesFor(day),
                        onTap: onOccurrenceTap,
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: contentHeight,
                    child: Stack(
                      children: [
                        _GridBackground(
                          timeColumnWidth: metrics.timeColumnWidth,
                          dayWidth: metrics.dayWidth,
                          dayCount: days.length,
                          startHour: startHour,
                          endHour: endHour,
                          gridMinutes: gridMinutes,
                          hourHeight: _hourHeight,
                        ),
                        for (var index = 0; index < days.length; index++)
                          Positioned(
                            left:
                                metrics.timeColumnWidth +
                                index * metrics.dayWidth,
                            top: 0,
                            width: metrics.dayWidth,
                            height: contentHeight,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTapDown: (details) {
                                final minutes = _snapMinutes(
                                  startMinutes +
                                      (details.localPosition.dy / minuteHeight)
                                          .round(),
                                  gridMinutes,
                                ).clamp(startMinutes, endMinutes - 15).toInt();
                                final day = days[index];
                                onEmptySlotTap(
                                  DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                    minutes ~/ 60,
                                    minutes % 60,
                                  ),
                                );
                              },
                            ),
                          ),
                        for (var index = 0; index < days.length; index++)
                          ..._timedOccurrenceCards(
                            context: context,
                            day: days[index],
                            left:
                                metrics.timeColumnWidth +
                                index * metrics.dayWidth,
                            width: metrics.dayWidth,
                            startMinutes: startMinutes,
                            endMinutes: endMinutes,
                            minuteHeight: minuteHeight,
                          ),
                        for (var index = 0; index < days.length; index++)
                          if (_sameDay(days[index], DateTime.now()) &&
                              _nowMinutes() >= startMinutes &&
                              _nowMinutes() <= endMinutes)
                            Positioned(
                              left:
                                  metrics.timeColumnWidth +
                                  index * metrics.dayWidth,
                              top:
                                  (_nowMinutes() - startMinutes) * minuteHeight,
                              width: metrics.dayWidth,
                              child: const _NowLine(),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<GeneralEventOccurrence> _allDayOccurrencesFor(DateTime day) {
    return occurrences.where((occurrence) {
      if (!_occurrenceIntersectsDay(occurrence, day)) return false;
      return occurrence.isAllDay || !_sameDay(occurrence.start, occurrence.end);
    }).toList();
  }

  Iterable<Widget> _timedOccurrenceCards({
    required BuildContext context,
    required DateTime day,
    required double left,
    required double width,
    required int startMinutes,
    required int endMinutes,
    required double minuteHeight,
  }) sync* {
    final dayStart = normalizeDateOnly(day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final segments = <_TimedOccurrenceSegment>[];
    for (final occurrence in occurrences) {
      if (occurrence.isAllDay || !_sameDay(occurrence.start, occurrence.end)) {
        continue;
      }
      if (!_occurrenceIntersectsDay(occurrence, day)) {
        continue;
      }
      final segmentStart = occurrence.start.isBefore(dayStart)
          ? dayStart
          : occurrence.start;
      final segmentEnd = occurrence.end.isAfter(dayEnd)
          ? dayEnd
          : occurrence.end;
      final rawStart = segmentStart.hour * 60 + segmentStart.minute;
      final rawEnd = segmentEnd.hour * 60 + segmentEnd.minute;
      final topMinutes = rawStart.clamp(startMinutes, endMinutes).toInt();
      final bottomMinutes = rawEnd.clamp(startMinutes, endMinutes).toInt();
      if (bottomMinutes <= startMinutes || topMinutes >= endMinutes) {
        continue;
      }
      segments.add(
        _TimedOccurrenceSegment(
          occurrence: occurrence,
          startMinutes: topMinutes,
          endMinutes: bottomMinutes,
        ),
      );
    }
    final layouts = _layoutTimedOccurrenceSegments(segments);
    for (final layout in layouts) {
      final height = math.max(
        28,
        (layout.endMinutes - layout.startMinutes) * minuteHeight,
      );
      final laneGap = layout.laneCount > 1 ? 2.0 : 0.0;
      final availableWidth = width - 8 - laneGap * (layout.laneCount - 1);
      final laneWidth = math.max(1.0, availableWidth / layout.laneCount);
      yield Positioned(
        left: left + 4 + layout.lane * (laneWidth + laneGap),
        top: (layout.startMinutes - startMinutes) * minuteHeight + 2,
        width: laneWidth,
        height: height - 4,
        child: _OccurrenceCard(
          occurrence: layout.occurrence,
          dense: height < 46 || laneWidth < 72,
          onTap: () => onOccurrenceTap(layout.occurrence),
        ),
      );
    }
  }
}

class _TimelineMetrics {
  const _TimelineMetrics({
    required this.totalWidth,
    required this.timeColumnWidth,
    required this.dayWidth,
  });

  final double totalWidth;
  final double timeColumnWidth;
  final double dayWidth;

  factory _TimelineMetrics.fromWidth(double width, {required int dayCount}) {
    final safeWidth = width.isFinite && width > 0 ? width : 360.0;
    final timeColumnWidth = safeWidth < 600
        ? 34.0
        : safeWidth < 840
        ? 42.0
        : 52.0;
    final availableDaysWidth = math.max(safeWidth - timeColumnWidth, 0.0);
    final effectiveDayCount = math.max(dayCount, 1);
    return _TimelineMetrics(
      totalWidth: safeWidth,
      timeColumnWidth: timeColumnWidth,
      dayWidth: availableDaysWidth / effectiveDayCount,
    );
  }
}

class _TimedOccurrenceSegment {
  _TimedOccurrenceSegment({
    required this.occurrence,
    required this.startMinutes,
    required this.endMinutes,
  });

  final GeneralEventOccurrence occurrence;
  final int startMinutes;
  final int endMinutes;
  int lane = 0;
  int laneCount = 1;
}

List<_TimedOccurrenceSegment> _layoutTimedOccurrenceSegments(
  List<_TimedOccurrenceSegment> segments,
) {
  if (segments.isEmpty) {
    return segments;
  }
  final sorted = [...segments]
    ..sort((a, b) {
      final startCompare = a.startMinutes.compareTo(b.startMinutes);
      if (startCompare != 0) return startCompare;
      return a.endMinutes.compareTo(b.endMinutes);
    });

  final groups = <List<_TimedOccurrenceSegment>>[];
  var currentGroup = <_TimedOccurrenceSegment>[];
  var currentGroupEnd = -1;
  for (final segment in sorted) {
    if (currentGroup.isEmpty || segment.startMinutes < currentGroupEnd) {
      currentGroup.add(segment);
      currentGroupEnd = math.max(currentGroupEnd, segment.endMinutes);
    } else {
      groups.add(currentGroup);
      currentGroup = [segment];
      currentGroupEnd = segment.endMinutes;
    }
  }
  if (currentGroup.isNotEmpty) {
    groups.add(currentGroup);
  }

  for (final group in groups) {
    final laneEnds = <int>[];
    for (final segment in group) {
      var lane = laneEnds.indexWhere((end) => end <= segment.startMinutes);
      if (lane < 0) {
        lane = laneEnds.length;
        laneEnds.add(segment.endMinutes);
      } else {
        laneEnds[lane] = segment.endMinutes;
      }
      segment.lane = lane;
    }
    for (final segment in group) {
      segment.laneCount = laneEnds.length;
    }
  }

  return sorted;
}

class _ListCalendarView extends StatelessWidget {
  const _ListCalendarView({
    required this.date,
    required this.provider,
    required this.filter,
    required this.onToday,
    required this.onPickDate,
    required this.onOccurrenceTap,
  });

  final DateTime date;
  final TimetableProvider provider;
  final _GeneralOccurrenceFilter filter;
  final VoidCallback onToday;
  final VoidCallback onPickDate;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final start = normalizeDateOnly(date);
    final occurrences = provider.generalOccurrencesForQuery(
      filter.toQuery(
        startInclusive: start,
        endExclusive: start.add(const Duration(days: 180)),
      ),
    );
    if (occurrences.isEmpty) {
      return _EmptyListState(onToday: onToday, filtered: filter.isActive);
    }
    final groups = <String, List<GeneralEventOccurrence>>{};
    for (final occurrence in occurrences) {
      final key = _dateKey(occurrence.start);
      groups.putIfAbsent(key, () => []).add(occurrence);
    }
    final entries = groups.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 88),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ListJumpBar(onToday: onToday, onPickDate: onPickDate);
        }
        final group = entries[index - 1];
        final date = DateTime.parse(group.key);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
              child: Text(
                '${_formatDate(date)}  ${_weekdayLabel(context, date)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            for (final occurrence in group.value)
              _ListOccurrenceTile(
                occurrence: occurrence,
                onTap: () => onOccurrenceTap(occurrence),
              ),
          ],
        );
      },
    );
  }
}

class _ListJumpBar extends StatelessWidget {
  const _ListJumpBar({required this.onToday, required this.onPickDate});

  final VoidCallback onToday;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: onToday,
            icon: const Icon(Icons.today_outlined),
            label: Text(l10n.today),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(l10n.pickDate),
          ),
        ],
      ),
    );
  }
}

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
    final overdue = items
        .where((item) => item.status == GeneralReminderStatus.overdue)
        .take(3)
        .toList();
    if (upcoming.isEmpty && overdue.isEmpty) {
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
            _ReminderItemPill(
              item: item,
              statusLabel: l10n.reminderUpcoming,
              color: theme.colorScheme.primary,
              onTap: () => onOccurrenceTap(item.occurrence),
              onDismiss: () => provider.dismissGeneralReminder(item.occurrence),
            ),
          for (final item in overdue)
            _ReminderItemPill(
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

class _ReminderItemPill extends StatelessWidget {
  const _ReminderItemPill({
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
            padding: const EdgeInsets.only(left: 12, right: 2),
            child: Row(
              children: [
                Icon(
                  item.status == GeneralReminderStatus.upcoming
                      ? Icons.notifications_active_outlined
                      : Icons.pending_actions_outlined,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$statusLabel · ${item.occurrence.event.title}',
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

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.date,
    required this.width,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final double width;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _sameDay(date, DateTime.now());
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primaryContainer
                  : isToday
                  ? theme.colorScheme.secondaryContainer.withAlpha(120)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _weekdayLabel(context, date),
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date.day.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: selected || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllDayColumn extends StatelessWidget {
  const _AllDayColumn({
    required this.date,
    required this.width,
    required this.occurrences,
    required this.onTap,
  });

  final DateTime date;
  final double width;
  final List<GeneralEventOccurrence> occurrences;
  final ValueChanged<GeneralEventOccurrence> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor.withAlpha(96)),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: occurrences.isEmpty
          ? const SizedBox.shrink()
          : ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                for (final occurrence in occurrences.take(2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: _AllDayChip(
                      occurrence: occurrence,
                      onTap: () => onTap(occurrence),
                    ),
                  ),
                if (occurrences.length > 2)
                  Text(
                    l10n.moreEvents(occurrences.length - 2),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
              ],
            ),
    );
  }
}

class _AllDayChip extends StatelessWidget {
  const _AllDayChip({required this.occurrence, required this.onTap});

  final GeneralEventOccurrence occurrence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(
      occurrence.event.colorValue ?? occurrence.calendar.colorValue,
    );
    return Material(
      color: color.withAlpha(36),
      borderRadius: BorderRadius.circular(8),
      child: Semantics(
        button: true,
        label: occurrence.event.title,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            child: Text(
              occurrence.event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _readableColor(color),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridBackground extends StatelessWidget {
  const _GridBackground({
    required this.timeColumnWidth,
    required this.dayWidth,
    required this.dayCount,
    required this.startHour,
    required this.endHour,
    required this.gridMinutes,
    required this.hourHeight,
  });

  final double timeColumnWidth;
  final double dayWidth;
  final int dayCount;
  final int startHour;
  final int endHour;
  final int gridMinutes;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalHeight = (endHour - startHour) * hourHeight;
    final lineColor = theme.dividerColor.withAlpha(96);
    final minorColor = theme.dividerColor.withAlpha(48);
    final gridStep = gridMinutes.clamp(15, 60).toInt();
    return Stack(
      children: [
        for (var hour = startHour; hour <= endHour; hour++)
          Positioned(
            left: 0,
            right: 0,
            top: (hour - startHour) * hourHeight,
            child: Row(
              children: [
                SizedBox(
                  width: timeColumnWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      textAlign: TextAlign.right,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                Expanded(child: Divider(height: 1, color: lineColor)),
              ],
            ),
          ),
        for (
          var minute = gridStep;
          minute < (endHour - startHour) * 60;
          minute += gridStep
        )
          if (minute % 60 != 0)
            Positioned(
              left: timeColumnWidth,
              right: 0,
              top: minute / 60 * hourHeight,
              child: Divider(height: 1, color: minorColor),
            ),
        for (var day = 0; day <= dayCount; day++)
          Positioned(
            top: 0,
            bottom: 0,
            left: timeColumnWidth + day * dayWidth,
            child: VerticalDivider(width: 1, color: lineColor),
          ),
        Positioned(
          left: 0,
          right: 0,
          top: totalHeight - 1,
          child: Divider(height: 1, color: lineColor),
        ),
      ],
    );
  }
}

class _OccurrenceCard extends StatelessWidget {
  const _OccurrenceCard({
    required this.occurrence,
    required this.dense,
    required this.onTap,
  });

  final GeneralEventOccurrence occurrence;
  final bool dense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(
      occurrence.event.colorValue ?? occurrence.calendar.colorValue,
    );
    final textColor = _readableColor(color);
    return Material(
      color: color.withAlpha(210),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        label: occurrence.event.title,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: dense ? 3 : 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: dense
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text(
                  occurrence.event.title,
                  maxLines: dense ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!dense) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatOccurrenceTime(context, occurrence),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: textColor.withAlpha(220),
                    ),
                  ),
                  if (occurrence.event.location.isNotEmpty)
                    Text(
                      occurrence.event.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textColor.withAlpha(220),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NowLine extends StatelessWidget {
  const _NowLine();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Expanded(child: Divider(height: 1, thickness: 2, color: color)),
      ],
    );
  }
}

class _ListOccurrenceTile extends StatelessWidget {
  const _ListOccurrenceTile({required this.occurrence, required this.onTap});

  final GeneralEventOccurrence occurrence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(
      occurrence.event.colorValue ?? occurrence.calendar.colorValue,
    );
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: Container(
        width: 10,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(occurrence.event.title),
      subtitle: Text(
        [
          _formatOccurrenceTime(context, occurrence),
          if (occurrence.event.location.isNotEmpty) occurrence.event.location,
          occurrence.calendar.name,
        ].join('  |  '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: occurrence.event.recurrenceRule.isRepeating
          ? Icon(Icons.repeat, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _EmptyListState extends StatelessWidget {
  const _EmptyListState({required this.onToday, required this.filtered});

  final VoidCallback onToday;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              filtered ? l10n.noMatchingEvents : l10n.noUpcomingEvents,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onToday,
              icon: const Icon(Icons.today_outlined),
              label: Text(l10n.today),
            ),
          ],
        ),
      ),
    );
  }
}

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
