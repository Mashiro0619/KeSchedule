part of 'general_schedule_home_screen.dart';

class _MonthCalendarView extends StatelessWidget {
  const _MonthCalendarView({
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

  static int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  DateTime _visibleDayForDate(DateTime date) {
    final normalized = normalizeDateOnly(date);
    if (provider.generalShowWeekends || normalized.weekday <= DateTime.friday) {
      return normalized;
    }
    return normalized.add(Duration(days: 8 - normalized.weekday));
  }

  DateTime _monthWithDay(DateTime baseDate, int year, int month) {
    final target = DateTime(
      year,
      month,
      baseDate.day.clamp(1, _daysInMonth(year, month)),
    );
    return _visibleDayForDate(target);
  }

  void _goToPreviousMonth() {
    final selectedDate = _visibleDayForDate(date);
    final prevMonth = date.month == 1 ? 12 : date.month - 1;
    final prevYear = date.month == 1 ? date.year - 1 : date.year;
    onDaySelected(_monthWithDay(selectedDate, prevYear, prevMonth));
  }

  void _goToNextMonth() {
    final selectedDate = _visibleDayForDate(date);
    final nextMonth = date.month == 12 ? 1 : date.month + 1;
    final nextYear = date.month == 12 ? date.year + 1 : date.year;
    onDaySelected(_monthWithDay(selectedDate, nextYear, nextMonth));
  }

  @override
  Widget build(BuildContext context) {
    final today = normalizeDateOnly(DateTime.now());
    final requestedDate = normalizeDateOnly(date);
    final selectedDate = _visibleDayForDate(requestedDate);
    if (!_sameDay(selectedDate, requestedDate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onDaySelected(selectedDate);
      });
    }
    final model = _MonthGridModel.build(
      monthDate: selectedDate,
      showWeekends: provider.generalShowWeekends,
    );
    final occurrences = provider.generalOccurrencesForQuery(
      filter.toQuery(
        startInclusive: model.queryStart,
        endExclusive: model.queryEndExclusive,
      ),
    );
    final occurrencesByDay = _groupOccurrencesByDay(occurrences, model.days);
    final selectedOccurrences =
        (occurrencesByDay[_dateKey(selectedDate)] ?? const [])
            .sortedForAgenda();

    return LayoutBuilder(
      builder: (context, constraints) {
        final sideBySide = constraints.maxWidth >= 760;
        final calendar = _MonthCalendarPanel(
          model: model,
          selectedDate: selectedDate,
          today: today,
          occurrencesByDay: occurrencesByDay,
          provider: provider,
          onPreviousMonth: _goToPreviousMonth,
          onNextMonth: _goToNextMonth,
          onToday: () => onDaySelected(_visibleDayForDate(today)),
          onDaySelected: onDaySelected,
        );
        final agenda = _MonthAgendaPanel(
          date: selectedDate,
          occurrences: selectedOccurrences,
          filtered: filter.isActive,
          onAddEvent: () => onEmptySlotTap(selectedDate),
          onOccurrenceTap: onOccurrenceTap,
        );

        if (sideBySide) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: calendar),
                const SizedBox(width: 16),
                SizedBox(width: 320, child: agenda),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 88),
          children: [
            calendar,
            const SizedBox(height: 10),
            SizedBox(height: 188, child: agenda),
          ],
        );
      },
    );
  }
}

class _MonthGridModel {
  const _MonthGridModel({
    required this.days,
    required this.columnCount,
    required this.rowCount,
    required this.queryStart,
    required this.queryEndExclusive,
  });

  final List<DateTime> days;
  final int columnCount;
  final int rowCount;
  final DateTime queryStart;
  final DateTime queryEndExclusive;

  static _MonthGridModel build({
    required DateTime monthDate,
    required bool showWeekends,
  }) {
    final firstOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    final lastOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0);
    final gridStart = showWeekends
        ? startOfWeekSunday(firstOfMonth)
        : startOfWeekMonday(firstOfMonth);
    final gridEnd =
        (showWeekends
                ? startOfWeekSunday(lastOfMonth)
                : startOfWeekMonday(lastOfMonth))
            .add(Duration(days: showWeekends ? 6 : 4));
    final days = <DateTime>[];
    for (
      var d = gridStart;
      !d.isAfter(gridEnd);
      d = d.add(const Duration(days: 1))
    ) {
      if (showWeekends || d.weekday <= DateTime.friday) {
        days.add(d);
      }
    }
    final columnCount = showWeekends ? 7 : 5;
    return _MonthGridModel(
      days: days,
      columnCount: columnCount,
      rowCount: days.length ~/ columnCount,
      queryStart: days.first,
      queryEndExclusive: days.last.add(const Duration(days: 1)),
    );
  }
}

class _MonthCalendarPanel extends StatelessWidget {
  const _MonthCalendarPanel({
    required this.model,
    required this.selectedDate,
    required this.today,
    required this.occurrencesByDay,
    required this.provider,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onToday,
    required this.onDaySelected,
  });

  final _MonthGridModel model;
  final DateTime selectedDate;
  final DateTime today;
  final Map<String, List<GeneralEventOccurrence>> occurrencesByDay;
  final TimetableProvider provider;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onToday;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final monthLabel = MaterialLocalizations.of(
      context,
    ).formatMonthYear(selectedDate);
    final compact = MediaQuery.sizeOf(context).width < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fillsHeight =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;
        final grid = GestureDetector(
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity;
            if (velocity == null) return;
            if (velocity < -100) {
              onNextMonth();
            } else if (velocity > 100) {
              onPreviousMonth();
            }
          },
          child: _MonthDateGrid(
            model: model,
            selectedDate: selectedDate,
            today: today,
            occurrencesByDay: occurrencesByDay,
            provider: provider,
            compact: compact,
            onDaySelected: onDaySelected,
          ),
        );

        return Material(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: fillsHeight ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: l10n.previousMonth,
                      onPressed: onPreviousMonth,
                    ),
                    Expanded(
                      child: Text(
                        monthLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (!_sameDay(
                      DateTime(selectedDate.year, selectedDate.month),
                      DateTime(today.year, today.month),
                    ))
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: onToday,
                        child: Text(l10n.today),
                      ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: l10n.nextMonth,
                      onPressed: onNextMonth,
                    ),
                  ],
                ),
              ),
              _MonthWeekdayHeaderRow(
                showWeekends: provider.generalShowWeekends,
              ),
              if (fillsHeight)
                Flexible(fit: FlexFit.loose, child: grid)
              else
                grid,
            ],
          ),
        );
      },
    );
  }
}

class _MonthDateGrid extends StatelessWidget {
  const _MonthDateGrid({
    required this.model,
    required this.selectedDate,
    required this.today,
    required this.occurrencesByDay,
    required this.provider,
    required this.compact,
    required this.onDaySelected,
  });

  final _MonthGridModel model;
  final DateTime selectedDate;
  final DateTime today;
  final Map<String, List<GeneralEventOccurrence>> occurrencesByDay;
  final TimetableProvider provider;
  final bool compact;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 1.0;
        final boundedHeight =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;
        final cellWidth = constraints.maxWidth / model.columnCount;
        final preferredHeight = (cellWidth * (compact ? 0.58 : 0.68))
            .clamp(compact ? 48.0 : 72.0, compact ? 64.0 : 92.0)
            .toDouble();
        final totalSpacing = (model.rowCount - 1) * spacing;
        final preferredGridHeight =
            model.rowCount * preferredHeight + totalSpacing;
        final height = boundedHeight
            ? math.min(preferredGridHeight, constraints.maxHeight)
            : preferredGridHeight;
        final targetHeight = math.max(
          1.0,
          (height - totalSpacing) / model.rowCount,
        );
        final gridCompact = compact || targetHeight < 64;

        return SizedBox(
          height: height,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: model.columnCount,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: cellWidth / math.max(targetHeight, 1.0),
            ),
            itemCount: model.days.length,
            itemBuilder: (context, index) {
              final day = model.days[index];
              final dayOccurrences =
                  occurrencesByDay[_dateKey(day)] ?? const [];
              return LayoutBuilder(
                builder: (context, cellConstraints) {
                  final cellCompact =
                      gridCompact || cellConstraints.maxHeight < 64;
                  return _MonthDayCell(
                    date: day,
                    month: selectedDate.month,
                    isToday: _sameDay(day, today),
                    isSelected: _sameDay(day, selectedDate),
                    occurrences: dayOccurrences.sortedForAgenda(),
                    localeCode: provider.localeCode,
                    showLunarCalendar: provider.generalShowLunarCalendar,
                    maxPreviewItems: cellCompact
                        ? 0
                        : cellConstraints.maxHeight < 84
                        ? 0
                        : cellConstraints.maxHeight < 96
                        ? 1
                        : 2,
                    compact: cellCompact,
                    onTap: () => onDaySelected(day),
                  );
                },
              );
            },
          ),
        );
      },
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
    for (final day in days) {
      if (_occurrenceIntersectsDay(occurrence, day)) {
        final key = _dateKey(day);
        result[key]?.add(occurrence);
      }
    }
  }
  return result;
}

class _MonthWeekdayHeaderRow extends StatelessWidget {
  const _MonthWeekdayHeaderRow({required this.showWeekends});

  final bool showWeekends;

  static final _referenceMonday = DateTime(2026, 1, 5);

  @override
  Widget build(BuildContext context) {
    final weekdays = showWeekends
        ? [
            DateTime.sunday,
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
          ]
        : [
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
          ];
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
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
                  maxLines: 1,
                  overflow: TextOverflow.clip,
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
    required this.date,
    required this.month,
    required this.isToday,
    required this.isSelected,
    required this.occurrences,
    required this.localeCode,
    required this.showLunarCalendar,
    required this.maxPreviewItems,
    required this.compact,
    required this.onTap,
  });

  final DateTime date;
  final int month;
  final bool isToday;
  final bool isSelected;
  final List<GeneralEventOccurrence> occurrences;
  final String localeCode;
  final bool showLunarCalendar;
  final int maxPreviewItems;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCurrentMonth = date.month == month;
    final baseColor = isCurrentMonth
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant.withAlpha(130);
    final dayFillColor = isToday ? colorScheme.primary : Colors.transparent;
    final bgColor = isSelected
        ? colorScheme.primaryContainer
        : isToday
        ? colorScheme.secondaryContainer.withAlpha(150)
        : colorScheme.surface;
    final borderColor = isSelected
        ? colorScheme.primary
        : isToday
        ? colorScheme.secondary
        : colorScheme.outlineVariant.withAlpha(160);
    final visibleOccurrences = occurrences.take(maxPreviewItems).toList();
    final hiddenCount = occurrences.length - visibleOccurrences.length;
    final showHiddenCount = !compact && hiddenCount > 0;
    final hasAgendaPreview = visibleOccurrences.isNotEmpty || showHiddenCount;
    final dateContent = SizedBox(
      width: double.infinity,
      height: compact ? 34 : 38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: compact ? 20 : 22,
            height: compact ? 19 : 21,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dayFillColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              date.day.toString(),
              style: theme.textTheme.labelLarge?.copyWith(
                height: 1.0,
                color: isToday ? colorScheme.onPrimary : baseColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 1),
          SizedBox(
            width: double.infinity,
            child: _LunarDateLabel(
              date: date,
              colorScheme: colorScheme,
              localeCode: localeCode,
              enabled: showLunarCalendar,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: isSelected,
      label: occurrences.isNotEmpty
          ? AppLocalizations.of(
              context,
            ).monthDayEvents(date.day, occurrences.length)
          : '${date.day}',
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: borderColor, width: isSelected ? 1.4 : 0.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(compact ? 4 : 5),
            child: hasAgendaPreview
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dateContent,
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!compact) const SizedBox(height: 2),
                            for (final occurrence in visibleOccurrences)
                              _MonthEventChip(occurrence: occurrence),
                            if (showHiddenCount)
                              Text(
                                '+$hiddenCount',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  height: 1.0,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(child: dateContent),
          ),
        ),
      ),
    );
  }
}

class _MonthEventChip extends StatelessWidget {
  const _MonthEventChip({required this.occurrence});

  final GeneralEventOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final color = Color(
      occurrence.event.colorValue ?? occurrence.calendar.colorValue,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              occurrence.event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                height: 1.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthAgendaPanel extends StatelessWidget {
  const _MonthAgendaPanel({
    required this.date,
    required this.occurrences,
    required this.filtered,
    required this.onAddEvent,
    required this.onOccurrenceTap,
  });

  final DateTime date;
  final List<GeneralEventOccurrence> occurrences;
  final bool filtered;
  final VoidCallback onAddEvent;
  final ValueChanged<GeneralEventOccurrence> onOccurrenceTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_formatDate(date)}  ${_weekdayLabel(context, date)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        occurrences.isEmpty
                            ? (filtered
                                  ? l10n.noMatchingEvents
                                  : l10n.noUpcomingEvents)
                            : l10n.monthDayEvents(date.day, occurrences.length),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.addEvent,
                  onPressed: onAddEvent,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: occurrences.isEmpty
                ? _MonthAgendaEmptyState(
                    filtered: filtered,
                    onAddEvent: onAddEvent,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                    itemCount: occurrences.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final occurrence = occurrences[index];
                      return _MonthAgendaTile(
                        occurrence: occurrence,
                        onTap: () => onOccurrenceTap(occurrence),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MonthAgendaEmptyState extends StatelessWidget {
  const _MonthAgendaEmptyState({
    required this.filtered,
    required this.onAddEvent,
  });

  final bool filtered;
  final VoidCallback onAddEvent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                filtered
                    ? Icons.event_busy_outlined
                    : Icons.event_available_outlined,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                filtered ? l10n.noMatchingEvents : l10n.noUpcomingEvents,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
              if (!filtered) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onAddEvent,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addEvent),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthAgendaTile extends StatelessWidget {
  const _MonthAgendaTile({required this.occurrence, required this.onTap});

  final GeneralEventOccurrence occurrence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(
      occurrence.event.colorValue ?? occurrence.calendar.colorValue,
    );
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      leading: Container(
        width: 8,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      title: Text(
        occurrence.event.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
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

class _LunarDateLabel extends StatelessWidget {
  const _LunarDateLabel({
    required this.date,
    required this.colorScheme,
    required this.localeCode,
    required this.enabled,
  });

  final DateTime date;
  final ColorScheme colorScheme;
  final String localeCode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || (localeCode != 'zh' && localeCode != 'zh-Hant')) {
      return const SizedBox.shrink();
    }
    final lunar = Lunar.fromDate(date);
    final festivals = lunar.getFestivals();
    if (festivals.isNotEmpty) {
      return _LunarText(text: festivals.first, color: colorScheme.primary);
    }
    final jieQi = lunar.getJieQi();
    if (jieQi.isNotEmpty) {
      return _LunarText(text: jieQi, color: colorScheme.tertiary);
    }
    return _LunarText(
      text: lunar.getDayInChinese(),
      color: colorScheme.onSurfaceVariant,
    );
  }
}

class _LunarText extends StatelessWidget {
  const _LunarText({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 9.5,
        height: 1.05,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

extension on List<GeneralEventOccurrence> {
  List<GeneralEventOccurrence> sortedForAgenda() {
    return toList()..sort((a, b) {
      if (a.isAllDay && !b.isAllDay) return -1;
      if (!a.isAllDay && b.isAllDay) return 1;
      return a.start.compareTo(b.start);
    });
  }
}
