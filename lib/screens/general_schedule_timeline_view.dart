part of 'general_schedule_home_screen.dart';

const _generalTimelineInitialPage = 10000;
const _generalWeekPagerKey = ValueKey<String>('general-week-pager');
const _generalDayPagerKey = ValueKey<String>('general-day-pager');
const _generalDayWeekPickerPagerKey = ValueKey<String>(
  'general-day-week-picker-pager',
);
const _generalDayPickerSelectionIndicatorKey = ValueKey<String>(
  'general-day-picker-selection-indicator',
);

class _WeekCalendarView extends StatefulWidget {
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
  State<_WeekCalendarView> createState() => _WeekCalendarViewState();
}

class _WeekCalendarViewState extends State<_WeekCalendarView> {
  late final DateTime _baseWeekStart;
  late final PageController _controller;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _baseWeekStart = startOfWeekMonday(_visibleDayForDate(widget.date));
    _currentPage = _generalTimelineInitialPage;
    _controller = PageController(initialPage: _currentPage);
    _syncVisibleSelectedDate();
  }

  @override
  void didUpdateWidget(covariant _WeekCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncVisibleSelectedDate();
    final targetPage = _pageForWeek(
      startOfWeekMonday(_visibleDayForDate(widget.date)),
    );
    if (targetPage != _currentPage) {
      _currentPage = targetPage;
      if (_controller.hasClients) {
        _controller.jumpToPage(targetPage);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _pageForWeek(DateTime weekStart) {
    final deltaDays = weekStart.difference(_baseWeekStart).inDays;
    return _generalTimelineInitialPage + deltaDays ~/ 7;
  }

  DateTime _weekStartForPage(int page) {
    final deltaWeeks = page - _generalTimelineInitialPage;
    return _baseWeekStart.add(Duration(days: deltaWeeks * 7));
  }

  bool _isVisibleDay(DateTime date) {
    return widget.provider.generalShowWeekends ||
        date.weekday <= DateTime.friday;
  }

  DateTime _visibleDayForDate(DateTime date) {
    final normalized = normalizeDateOnly(date);
    if (_isVisibleDay(normalized)) {
      return normalized;
    }
    return normalized.add(Duration(days: 8 - normalized.weekday));
  }

  void _syncVisibleSelectedDate() {
    final visibleDate = _visibleDayForDate(widget.date);
    if (_sameDay(visibleDate, widget.date)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onDaySelected(visibleDate);
      }
    });
  }

  int _selectedWeekdayOffset() {
    final selected = _visibleDayForDate(widget.date);
    return selected.difference(startOfWeekMonday(selected)).inDays;
  }

  void _handlePageChanged(int page) {
    _currentPage = page;
    final nextDate = _weekStartForPage(
      page,
    ).add(Duration(days: _selectedWeekdayOffset()));
    widget.onDaySelected(nextDate);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: _generalWeekPagerKey,
      controller: _controller,
      onPageChanged: _handlePageChanged,
      itemBuilder: (context, index) {
        final weekStart = _weekStartForPage(index);
        return _WeekTimelinePage(
          weekStart: weekStart,
          selectedDate: weekStart.add(Duration(days: _selectedWeekdayOffset())),
          provider: widget.provider,
          filter: widget.filter,
          onDaySelected: widget.onDaySelected,
          onEmptySlotTap: widget.onEmptySlotTap,
          onOccurrenceTap: widget.onOccurrenceTap,
        );
      },
    );
  }
}

class _WeekTimelinePage extends StatelessWidget {
  const _WeekTimelinePage({
    required this.weekStart,
    required this.selectedDate,
    required this.provider,
    required this.filter,
    required this.onDaySelected,
    required this.onEmptySlotTap,
    required this.onOccurrenceTap,
  });

  final DateTime weekStart;
  final DateTime selectedDate;
  final TimetableProvider provider;
  final _GeneralOccurrenceFilter filter;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onEmptySlotTap;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final days = _visibleWeekDays(weekStart, provider.generalShowWeekends);
    final occurrences = provider.generalOccurrencesForQuery(
      filter.toQuery(
        startInclusive: weekStart,
        endExclusive: weekStart.add(const Duration(days: 7)),
      ),
    );
    return _CalendarTimeline(
      days: days,
      selectedDate: selectedDate,
      occurrences: occurrences,
      startHour: provider.generalDayStartHour,
      endHour: provider.generalDayEndHour,
      gridMinutes: provider.generalTimeGridMinutes,
      showHeader: true,
      onDaySelected: onDaySelected,
      onEmptySlotTap: onEmptySlotTap,
      onOccurrenceTap: onOccurrenceTap,
    );
  }
}

class _DayCalendarView extends StatefulWidget {
  const _DayCalendarView({
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
  State<_DayCalendarView> createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<_DayCalendarView> {
  late final DateTime _baseDate;
  late final DateTime _baseWeekStart;
  late final PageController _dayController;
  late final PageController _weekController;
  late int _currentDayPage;
  late int _currentWeekPage;
  bool _syncingWeekPickerFromDay = false;

  @override
  void initState() {
    super.initState();
    _baseDate = _visibleDayForDate(widget.date);
    _baseWeekStart = startOfWeekMonday(_baseDate);
    _currentDayPage = _generalTimelineInitialPage;
    _currentWeekPage = _generalTimelineInitialPage;
    _dayController = PageController(initialPage: _currentDayPage);
    _weekController = PageController(initialPage: _currentWeekPage);
    _dayController.addListener(_syncWeekPickerToDayPage);
    _syncVisibleSelectedDate();
  }

  @override
  void didUpdateWidget(covariant _DayCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncVisibleSelectedDate();
    final selectedDate = _visibleDayForDate(widget.date);
    final targetDayPage = _pageForDay(selectedDate);
    if (targetDayPage != _currentDayPage) {
      _currentDayPage = targetDayPage;
      if (_dayController.hasClients) {
        _dayController.jumpToPage(targetDayPage);
      }
    }
    final targetWeekPage = _pageForWeek(startOfWeekMonday(selectedDate));
    if (targetWeekPage != _currentWeekPage) {
      _currentWeekPage = targetWeekPage;
      if (_weekController.hasClients) {
        _weekController.jumpToPage(targetWeekPage);
      }
    }
  }

  @override
  void dispose() {
    _dayController.removeListener(_syncWeekPickerToDayPage);
    _dayController.dispose();
    _weekController.dispose();
    super.dispose();
  }

  int _pageForDay(DateTime date) {
    final selectedDate = _visibleDayForDate(date);
    if (widget.provider.generalShowWeekends) {
      return _generalTimelineInitialPage +
          selectedDate.difference(_baseDate).inDays;
    }
    return _generalTimelineInitialPage +
        _visibleDayDifference(_baseDate, selectedDate);
  }

  DateTime _dayForPage(int page) {
    final deltaDays = page - _generalTimelineInitialPage;
    if (widget.provider.generalShowWeekends) {
      return _baseDate.add(Duration(days: deltaDays));
    }
    return _addVisibleDays(_baseDate, deltaDays);
  }

  int _pageForWeek(DateTime weekStart) {
    final deltaDays = weekStart.difference(_baseWeekStart).inDays;
    return _generalTimelineInitialPage + deltaDays ~/ 7;
  }

  DateTime _weekStartForPage(int page) {
    final deltaWeeks = page - _generalTimelineInitialPage;
    return _baseWeekStart.add(Duration(days: deltaWeeks * 7));
  }

  double _pageControllerValue(PageController controller, int fallback) {
    if (!controller.hasClients) {
      return fallback.toDouble();
    }
    final page = controller.page;
    if (page == null || !page.isFinite) {
      return fallback.toDouble();
    }
    return page;
  }

  double _weekPageForDayPage(double dayPage) {
    final lowerDayPage = dayPage.floor();
    final upperDayPage = dayPage.ceil();
    final progress = dayPage - lowerDayPage;
    final lowerWeekPage = _pageForWeek(
      startOfWeekMonday(_dayForPage(lowerDayPage)),
    );
    final upperWeekPage = _pageForWeek(
      startOfWeekMonday(_dayForPage(upperDayPage)),
    );
    return lowerWeekPage + (upperWeekPage - lowerWeekPage) * progress;
  }

  void _syncWeekPickerToDayPage() {
    if (!_dayController.hasClients || !_weekController.hasClients) {
      return;
    }
    final position = _weekController.position;
    if (!position.hasViewportDimension) {
      return;
    }
    final viewportWidth = position.viewportDimension;
    if (!viewportWidth.isFinite || viewportWidth <= 0) {
      return;
    }
    final targetPage = _weekPageForDayPage(
      _pageControllerValue(_dayController, _currentDayPage),
    );
    final targetPixels = targetPage * viewportWidth;
    if ((position.pixels - targetPixels).abs() < 0.5) {
      return;
    }
    _syncingWeekPickerFromDay = true;
    try {
      _weekController.jumpTo(targetPixels);
    } finally {
      _syncingWeekPickerFromDay = false;
    }
  }

  int _selectedWeekdayOffset() {
    final selected = _visibleDayForDate(widget.date);
    return selected.difference(startOfWeekMonday(selected)).inDays;
  }

  bool _isVisibleDay(DateTime date) {
    return widget.provider.generalShowWeekends ||
        date.weekday <= DateTime.friday;
  }

  DateTime _visibleDayForDate(DateTime date) {
    final normalized = normalizeDateOnly(date);
    if (_isVisibleDay(normalized)) {
      return normalized;
    }
    return normalized.add(Duration(days: 8 - normalized.weekday));
  }

  void _syncVisibleSelectedDate() {
    final visibleDate = _visibleDayForDate(widget.date);
    if (_sameDay(visibleDate, widget.date)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onDaySelected(visibleDate);
      }
    });
  }

  DateTime _addVisibleDays(DateTime date, int deltaDays) {
    var result = _visibleDayForDate(date);
    final step = deltaDays < 0 ? -1 : 1;
    var remaining = deltaDays.abs();
    while (remaining > 0) {
      result = result.add(Duration(days: step));
      if (_isVisibleDay(result)) {
        remaining -= 1;
      }
    }
    return result;
  }

  int _visibleDayDifference(DateTime start, DateTime end) {
    final from = _visibleDayForDate(start);
    final to = _visibleDayForDate(end);
    var cursor = from;
    var difference = 0;
    final step = to.isBefore(from) ? -1 : 1;
    while (!_sameDay(cursor, to)) {
      cursor = cursor.add(Duration(days: step));
      if (_isVisibleDay(cursor)) {
        difference += step;
      }
    }
    return difference;
  }

  void _handleDayPageChanged(int page) {
    _currentDayPage = page;
    widget.onDaySelected(_dayForPage(page));
  }

  void _handleWeekPageChanged(int page) {
    if (_syncingWeekPickerFromDay) {
      return;
    }
    _currentWeekPage = page;
    final nextDate = _weekStartForPage(
      page,
    ).add(Duration(days: _selectedWeekdayOffset()));
    widget.onDaySelected(nextDate);
  }

  @override
  Widget build(BuildContext context) {
    final day = _visibleDayForDate(widget.date);
    return Column(
      children: [
        _DayWeekPicker(
          controller: _weekController,
          selectionController: _dayController,
          selectedDate: day,
          selectedDayPageFallback: _currentDayPage,
          showWeekends: widget.provider.generalShowWeekends,
          dayPageForDate: _pageForDay,
          weekStartForPage: _weekStartForPage,
          onPageChanged: _handleWeekPageChanged,
          onDaySelected: widget.onDaySelected,
        ),
        Expanded(
          child: PageView.builder(
            key: _generalDayPagerKey,
            controller: _dayController,
            onPageChanged: _handleDayPageChanged,
            itemBuilder: (context, index) {
              final pageDay = _dayForPage(index);
              return _DayTimelinePage(
                date: pageDay,
                provider: widget.provider,
                filter: widget.filter,
                onDaySelected: widget.onDaySelected,
                onEmptySlotTap: widget.onEmptySlotTap,
                onOccurrenceTap: widget.onOccurrenceTap,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayTimelinePage extends StatelessWidget {
  const _DayTimelinePage({
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
      showHeader: false,
      onDaySelected: onDaySelected,
      onEmptySlotTap: onEmptySlotTap,
      onOccurrenceTap: onOccurrenceTap,
    );
  }
}

class _DayWeekPicker extends StatelessWidget {
  const _DayWeekPicker({
    required this.controller,
    required this.selectionController,
    required this.selectedDate,
    required this.selectedDayPageFallback,
    required this.showWeekends,
    required this.dayPageForDate,
    required this.weekStartForPage,
    required this.onPageChanged,
    required this.onDaySelected,
  });

  final PageController controller;
  final PageController selectionController;
  final DateTime selectedDate;
  final int selectedDayPageFallback;
  final bool showWeekends;
  final int Function(DateTime date) dayPageForDate;
  final DateTime Function(int page) weekStartForPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: Listenable.merge([controller, selectionController]),
      builder: (context, _) {
        final selectedDayPage = _pageControllerValue(
          selectionController,
          selectedDayPageFallback,
        );
        return Container(
          height: 66,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withAlpha(160),
              ),
            ),
          ),
          child: Row(
            children: [
              _MonthRail(date: selectedDate),
              Expanded(
                child: PageView.builder(
                  key: _generalDayWeekPickerPagerKey,
                  controller: controller,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final weekStart = weekStartForPage(index);
                    final days = _visibleWeekDays(weekStart, showWeekends);
                    return _DayWeekPickerRow(
                      days: days,
                      selectedDate: selectedDate,
                      selectedDayPage: selectedDayPage,
                      dayPageForDate: dayPageForDate,
                      onDaySelected: onDaySelected,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _pageControllerValue(PageController controller, int fallback) {
    if (!controller.hasClients) {
      return fallback.toDouble();
    }
    final page = controller.page;
    if (page == null || !page.isFinite) {
      return fallback.toDouble();
    }
    return page;
  }
}

class _DayWeekPickerRow extends StatelessWidget {
  const _DayWeekPickerRow({
    required this.days,
    required this.selectedDate,
    required this.selectedDayPage,
    required this.dayPageForDate,
    required this.onDaySelected,
  });

  final List<DateTime> days;
  final DateTime selectedDate;
  final double selectedDayPage;
  final int Function(DateTime date) dayPageForDate;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }
    final selectedPosition = _selectedPosition();
    final activeIndex = selectedPosition
        .round()
        .clamp(0, days.length - 1)
        .toInt();
    final showIndicatorKey = days.any((day) => _sameDay(day, selectedDate));
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final colorScheme = Theme.of(context).colorScheme;
          final cellWidth = constraints.maxWidth / days.length;
          final indicatorLeft = selectedPosition * cellWidth + 2;
          final indicatorWidth = math.max(0.0, cellWidth - 4);
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: indicatorLeft,
                top: 0,
                bottom: 0,
                width: indicatorWidth,
                child: IgnorePointer(
                  child: DecoratedBox(
                    key: showIndicatorKey
                        ? _generalDayPickerSelectionIndicatorKey
                        : null,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var index = 0; index < days.length; index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _DayPickerItem(
                          date: days[index],
                          selected: index == activeIndex,
                          onTap: () => onDaySelected(days[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  double _selectedPosition() {
    final firstPage = dayPageForDate(days.first).toDouble();
    final lastPage = dayPageForDate(days.last).toDouble();
    final minPage = math.min(firstPage, lastPage) - 1.0;
    final maxPage = math.max(firstPage, lastPage) + 1.0;
    if (selectedDayPage >= minPage && selectedDayPage <= maxPage) {
      return selectedDayPage - firstPage;
    }
    final sameWeekdayIndex = days.indexWhere(
      (day) => day.weekday == selectedDate.weekday,
    );
    if (sameWeekdayIndex != -1) {
      return sameWeekdayIndex.toDouble();
    }
    return 0;
  }
}

class _DayPickerItem extends StatelessWidget {
  const _DayPickerItem({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isToday = _sameDay(date, DateTime.now());
    final foreground = selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;
    return Material(
      color: isToday && !selected
          ? colorScheme.secondaryContainer.withAlpha(130)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _weekdayLabel(context, date),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date.day.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontWeight: selected || isToday
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
    required this.showHeader,
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
  final bool showHeader;
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
    final allDayOccurrencesByDay = [
      for (final day in days) _allDayOccurrencesFor(day),
    ];
    final hasAllDayOccurrences = allDayOccurrencesByDay.any(
      (items) => items.isNotEmpty,
    );

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
              if (showHeader)
                SizedBox(
                  height: _headerHeight,
                  child: Row(
                    children: [
                      _MonthRail(date: selectedDate),
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
              if (showHeader || hasAllDayOccurrences)
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
                      for (var index = 0; index < days.length; index++)
                        _AllDayColumn(
                          date: days[index],
                          width: metrics.dayWidth,
                          occurrences: allDayOccurrencesByDay[index],
                          onTap: onOccurrenceTap,
                        ),
                    ],
                  ),
                ),
              if (showHeader || hasAllDayOccurrences)
                const Divider(height: 1)
              else
                Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                  margin: EdgeInsets.only(left: metrics.timeColumnWidth),
                ),
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
                              onTapUp: (details) {
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
        28.0,
        (layout.endMinutes - layout.startMinutes) * minuteHeight,
      );
      final cardHeight = math.max(1.0, height - 4.0);
      final laneGap = layout.laneCount > 1 ? 2.0 : 0.0;
      final availableWidth = width - 8 - laneGap * (layout.laneCount - 1);
      final laneWidth = math.max(1.0, availableWidth / layout.laneCount);
      yield Positioned(
        left: left + 4 + layout.lane * (laneWidth + laneGap),
        top: (layout.startMinutes - startMinutes) * minuteHeight + 2,
        width: laneWidth,
        height: cardHeight,
        child: _OccurrenceCard(
          occurrence: layout.occurrence,
          dense: cardHeight < 64 || laneWidth < 72,
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

  static const monthRailWidth = 52.0;

  final double totalWidth;
  final double timeColumnWidth;
  final double dayWidth;

  factory _TimelineMetrics.fromWidth(double width, {required int dayCount}) {
    final safeWidth = width.isFinite && width > 0 ? width : 360.0;
    const timeColumnWidth = monthRailWidth;
    final availableDaysWidth = math.max(safeWidth - timeColumnWidth, 0.0);
    final effectiveDayCount = math.max(dayCount, 1);
    return _TimelineMetrics(
      totalWidth: safeWidth,
      timeColumnWidth: timeColumnWidth,
      dayWidth: availableDaysWidth / effectiveDayCount,
    );
  }
}

class _MonthRail extends StatelessWidget {
  const _MonthRail({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _TimelineMetrics.monthRailWidth,
      child: Center(
        child: Text(
          '${date.month}月',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
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
    final title = Text(
      occurrence.event.title,
      maxLines: dense ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
    );
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
            child: dense
                ? Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: title,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
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
