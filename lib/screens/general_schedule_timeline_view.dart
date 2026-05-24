part of 'general_schedule_home_screen.dart';

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
