part of 'general_schedule_home_screen.dart';

class _MonthCalendarView extends StatelessWidget {
  const _MonthCalendarView({
    required this.date,
    required this.provider,
    required this.filter,
    required this.onDaySelected,
    required this.onOccurrenceTap,
  });

  final DateTime date;
  final TimetableProvider provider;
  final _GeneralOccurrenceFilter filter;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  static int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  DateTime _monthWithDay(int year, int month) {
    return DateTime(year, month, date.day.clamp(1, _daysInMonth(year, month)));
  }

  void _goToPreviousMonth() {
    final prevMonth = date.month == 1 ? 12 : date.month - 1;
    final prevYear = date.month == 1 ? date.year - 1 : date.year;
    onDaySelected(_monthWithDay(prevYear, prevMonth));
  }

  void _goToNextMonth() {
    final nextMonth = date.month == 12 ? 1 : date.month + 1;
    final nextYear = date.month == 12 ? date.year + 1 : date.year;
    onDaySelected(_monthWithDay(nextYear, nextMonth));
  }

  @override
  Widget build(BuildContext context) {
    final today = normalizeDateOnly(DateTime.now());
    final selectedDate = normalizeDateOnly(date);
    final showWeekends = provider.generalShowWeekends;
    final firstOfMonth = DateTime(date.year, date.month, 1);
    final lastOfMonth = DateTime(date.year, date.month + 1, 0);
    final gridStart = startOfWeekMonday(firstOfMonth);
    final gridEnd = startOfWeekMonday(
      DateTime(lastOfMonth.year, lastOfMonth.month + 1, 1),
    ).add(const Duration(days: 6));
    final allDays = <DateTime>[];
    for (var d = gridStart;
        !d.isAfter(gridEnd);
        d = d.add(const Duration(days: 1))) {
      if (showWeekends || d.weekday <= DateTime.friday) {
        allDays.add(d);
      }
    }
    final cols = showWeekends ? 7 : 5;
    final months = allDays.length ~/ cols;
    final occurrences = provider.generalOccurrencesForQuery(
      filter.toQuery(
        startInclusive: allDays.first,
        endExclusive: allDays.last.add(const Duration(days: 1)),
      ),
    );
    final occurrencesByDay = _groupOccurrencesByDay(occurrences, allDays);
    final selectedKey = _dateKey(selectedDate);
    final selectedOccurrences = occurrencesByDay[selectedKey] ?? const [];
    final sorted = selectedOccurrences.toList()
      ..sort((a, b) {
        if (a.isAllDay && !b.isAllDay) return -1;
        if (!a.isAllDay && b.isAllDay) return 1;
        return a.start.compareTo(b.start);
      });

    return Column(
      children: [
        _MonthHeaderRow(
          year: date.year,
          month: date.month,
          isCurrentMonth:
              date.year == today.year && date.month == today.month,
          onMonthChanged: (year, month) =>
              onDaySelected(_monthWithDay(year, month)),
          onToday: () => onDaySelected(today),
        ),
        _MonthWeekdayHeaderRow(showWeekends: showWeekends),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: LayoutBuilder(
            key: ValueKey('grid-${date.year}-${date.month}'),
            builder: (context, constraints) {
              const spacing = 1.0;
              final cellW =
                  constraints.maxWidth / cols;
              final targetCellH =
                  (cellW * 0.35).clamp(32.0, 48.0);
              final aspectRatio = cellW / targetCellH;
              final cellH = targetCellH;
              final gridHeight =
                  months * cellH + (months - 1) * spacing;
              return SizedBox(
                height: gridHeight,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) return;
                    if (details.primaryVelocity! < -100) {
                      _goToNextMonth();
                    } else if (details.primaryVelocity! > 100) {
                      _goToPreviousMonth();
                    }
                  },
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: 0,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: allDays.length,
                    itemBuilder: (context, index) {
                      final rowIndex = index ~/ cols;
                      final day = allDays[index];
                      final isToday = _sameDay(day, today);
                      final isSelected =
                          _sameDay(day, selectedDate);
                      final isCurrentMonth =
                          day.month == date.month;
                      final isEvenRow = rowIndex % 2 == 0;
                      final key = _dateKey(day);
                      final dayOccurrences =
                          occurrencesByDay[key] ?? const [];
                      return Semantics(
                        label: dayOccurrences.isNotEmpty
                            ? '$day, ${dayOccurrences.length} events'
                            : '$day',
                        child: _MonthDayCell(
                          day: day.day,
                          isToday: isToday,
                          isSelected: isSelected,
                          isCurrentMonth: isCurrentMonth,
                          isWeekend: day.weekday ==
                                  DateTime.saturday ||
                              day.weekday == DateTime.sunday,
                          isEvenRow: isEvenRow,
                          occurrences: dayOccurrences,
                          onTap: () => onDaySelected(day),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: sorted.isEmpty
              ? Center(
                  child: Text(
                    _formatDate(selectedDate),
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(80),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    final occurrence = sorted[index];
                    final color = Color(
                      occurrence.event.colorValue ??
                          occurrence.calendar.colorValue,
                    );
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: _ColorDot(color: color),
                      title: Text(
                        occurrence.event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _formatOccurrenceTime(context, occurrence),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () =>
                          onOccurrenceTap(occurrence),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

Map<String, List<GeneralEventOccurrence>> _groupOccurrencesByDay(
  List<GeneralEventOccurrence> occurrences,
  List<DateTime> days,
) {
  final daySet = days.map(_dateKey).toSet();
  final result = <String, List<GeneralEventOccurrence>>{};
  for (final key in daySet) {
    result[key] = [];
  }
  for (final occurrence in occurrences) {
    var d = normalizeDateOnly(occurrence.start);
    final end = normalizeDateOnly(occurrence.end);
    while (!d.isAfter(end)) {
      final key = _dateKey(d);
      if (daySet.contains(key)) {
        result[key]?.add(occurrence);
      }
      d = d.add(const Duration(days: 1));
    }
  }
  return result;
}

class _MonthHeaderRow extends StatelessWidget {
  const _MonthHeaderRow({
    required this.year,
    required this.month,
    required this.onMonthChanged,
    required this.onToday,
    required this.isCurrentMonth,
  });

  final int year;
  final int month;
  final bool isCurrentMonth;
  final void Function(int year, int month) onMonthChanged;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final label = localizations.formatMonthYear(DateTime(year, month));
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 22),
            visualDensity: VisualDensity.compact,
            tooltip: 'Previous month',
            onPressed: () {
              final prev = month == 1 ? 12 : month - 1;
              final prevYear = month == 1 ? year - 1 : year;
              onMonthChanged(prevYear, prev);
            },
          ),
          if (!isCurrentMonth)
            TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: onToday,
              child: Text(AppLocalizations.of(context).today),
            ),
          Expanded(
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 22),
            visualDensity: VisualDensity.compact,
            tooltip: 'Next month',
            onPressed: () {
              final next = month == 12 ? 1 : month + 1;
              final nextYear = month == 12 ? year + 1 : year;
              onMonthChanged(nextYear, next);
            },
          ),
        ],
      ),
    );
  }
}

class _MonthWeekdayHeaderRow extends StatelessWidget {
  const _MonthWeekdayHeaderRow({required this.showWeekends});

  final bool showWeekends;

  static final _referenceMonday = DateTime(2026, 1, 5);

  @override
  Widget build(BuildContext context) {
    final weekdays = showWeekends
        ? [
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
            DateTime.sunday,
          ]
        : [
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
          ];
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Row(
        children: [
          for (final weekday in weekdays)
            Expanded(
              child: Center(
                child: Text(
                  _weekdayLabel(
                    context,
                    _referenceMonday.add(
                      Duration(days: weekday - DateTime.monday),
                    ),
                  ),
                  style: labelStyle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.isCurrentMonth,
    required this.isWeekend,
    required this.isEvenRow,
    required this.occurrences,
    required this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final bool isCurrentMonth;
  final bool isWeekend;
  final bool isEvenRow;
  final List<GeneralEventOccurrence> occurrences;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = TextStyle(
      fontSize: 11,
      color: isCurrentMonth
          ? (isToday ? colorScheme.onPrimary : colorScheme.onSurface)
          : colorScheme.onSurface.withAlpha(isDark ? 70 : 100),
      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.all(1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            color: isWeekend
                ? colorScheme.surfaceContainerHighest.withAlpha(80)
                : isEvenRow
                    ? null
                    : colorScheme.surfaceContainerHighest.withAlpha(40),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isToday
                        ? colorScheme.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: isToday
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(day.toString(), style: textStyle),
                ),
                if (occurrences.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0;
                            i < occurrences.length && i < 3;
                            i++)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 1),
                            decoration: BoxDecoration(
                              color: Color(
                                occurrences[i].event.colorValue ??
                                    occurrences[i]
                                        .calendar
                                        .colorValue,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
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
