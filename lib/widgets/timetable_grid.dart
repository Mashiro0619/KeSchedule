import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/timetable_models.dart';
import 'timetable_entry.dart';

const _minuteHeight = 1.4;
const _courseVerticalGap = 4.0;
const _compactHeaderHeight = 56.0;
const _regularHeaderHeight = 64.0;

class TimetableCourseTapInfo {
  const TimetableCourseTapInfo({
    required this.course,
    required this.courses,
    required this.isFullConflict,
    this.conflictKey,
  });

  final CourseItem course;
  final List<CourseItem> courses;
  final bool isFullConflict;
  final String? conflictKey;

  TimetableCourseTapInfo copyWith({
    CourseItem? course,
    List<CourseItem>? courses,
    bool? isFullConflict,
    String? conflictKey,
  }) {
    return TimetableCourseTapInfo(
      course: course ?? this.course,
      courses: courses ?? this.courses,
      isFullConflict: isFullConflict ?? this.isFullConflict,
      conflictKey: conflictKey ?? this.conflictKey,
    );
  }
}

class TimetableEmptySlotTapInfo {
  const TimetableEmptySlotTapInfo({
    required this.weekday,
    required this.startMinutes,
    required this.endMinutes,
    required this.periods,
  });

  final int weekday;
  final int startMinutes;
  final int endMinutes;
  final List<int> periods;
}

/// 这里按真实时间排版课程块，这样换一套节次时间后，视觉位置也会跟着对齐。
class TimetableGrid extends StatelessWidget {
  const TimetableGrid({
    super.key,
    required this.timetable,
    required this.periodTimes,
    required this.weekDateStart,
    required this.selectedWeek,
    required this.realCurrentWeek,
    required this.localeCode,
    required this.preserveGaps,
    required this.showPastEndedCourses,
    required this.showFutureCourses,
    required this.showGridLines,
    required this.onCourseTap,
    required this.onEmptySlotTap,
    required this.themeColorMode,
    required this.courseNameColorValues,
    required this.colorfulCourseTextColorMode,
    this.colorfulCourseTextColorValue,
    this.displayedCourseIdForConflict,
    this.liveCourseTarget,
    required this.liveCourseOutlineEnabled,
    required this.liveCourseOutlineMode,
    required this.liveCourseOutlineColorValue,
    required this.liveCourseOutlineWidth,
    this.entries,
    this.onEntryTap,
  });

  final TimetableData timetable;
  final List<CoursePeriodTime> periodTimes;
  final DateTime weekDateStart;
  final int selectedWeek;
  final int realCurrentWeek;
  final String localeCode;
  final bool preserveGaps;
  final bool showPastEndedCourses;
  final bool showFutureCourses;
  final bool showGridLines;
  final ValueChanged<TimetableCourseTapInfo> onCourseTap;
  final ValueChanged<TimetableEmptySlotTapInfo> onEmptySlotTap;
  final String themeColorMode;
  final Map<String, int> courseNameColorValues;
  final String colorfulCourseTextColorMode;
  final int? colorfulCourseTextColorValue;
  final String? Function(String conflictKey)? displayedCourseIdForConflict;
  final TimetableLiveCourseTarget? liveCourseTarget;
  final bool liveCourseOutlineEnabled;
  final String liveCourseOutlineMode;
  final int liveCourseOutlineColorValue;
  final double liveCourseOutlineWidth;
  final List<TimetableEntry>? entries;
  final ValueChanged<TimetableEntry>? onEntryTap;

  @override
  Widget build(BuildContext context) {
    final slots = periodTimes.isEmpty
        ? buildPeriodTimesForCount(1)
        : periodTimes;
    final layout = _TimetableVerticalLayout(
      slots: slots,
      preserveGaps: preserveGaps || entries != null,
    );
    final colors = Theme.of(context).colorScheme;
    final useEntries = entries != null;
    assert(
      entries == null || onEntryTap != null,
      'onEntryTap must be provided when entries is provided',
    );
    final dayLayoutsByWeekday = <int, List<CourseLayout>>{
      for (var weekday = 1; weekday <= 7; weekday++)
        weekday: useEntries
            ? _buildDayLayoutsFromEntries(entries: entries!, weekday: weekday)
            : _buildDayLayouts(
                timetable: timetable,
                courses: timetable.courses,
                weekday: weekday,
                selectedWeek: selectedWeek,
                realCurrentWeek: realCurrentWeek,
                showPastEndedCourses: showPastEndedCourses,
                showFutureCourses: showFutureCourses,
                displayedCourseIdForConflict: displayedCourseIdForConflict,
                liveCourseTarget: liveCourseTarget,
                liveCourseOutlineEnabled: liveCourseOutlineEnabled,
                liveCourseOutlineMode: liveCourseOutlineMode,
              ),
    };
    final colorfulTextColor = themeColorMode == themeColorModeColorful
        ? colorfulCourseTextColorMode == colorfulCourseTextColorModeCustom &&
                  colorfulCourseTextColorValue != null
              ? Color(colorfulCourseTextColorValue!)
              : resolveSharedColorfulTextColor(
                  layouts: dayLayoutsByWeekday.values.expand((items) => items),
                  courseNameColorValues: courseNameColorValues,
                  surfaceColor: colors.surface,
                  fallbackColor: colors.onSecondaryContainer,
                )
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _TimetableMetrics.fromWidth(constraints.maxWidth);
        final headerHeight = metrics.compact
            ? _compactHeaderHeight
            : _regularHeaderHeight;

        return SizedBox(
          width: constraints.maxWidth,
          child: Column(
            children: [
              SizedBox(
                height: headerHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: metrics.timeLabelWidth,
                      child: _MonthHeader(
                        date: weekDateStart,
                        compact: metrics.compact,
                        localeCode: localeCode,
                      ),
                    ),
                    for (var weekday = 1; weekday <= 7; weekday++)
                      SizedBox(
                        width: metrics.dayColumnWidth,
                        child: _DayHeader(
                          weekday: weekday,
                          date: weekDateStart.add(Duration(days: weekday - 1)),
                          compact: metrics.compact,
                          localeCode: localeCode,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: layout.totalHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: metrics.timeLabelWidth,
                          child: Stack(
                            children: [
                              for (final slot in slots)
                                Positioned(
                                  top: layout.slotTop(slot),
                                  left: 0,
                                  right: 0,
                                  child: SizedBox(
                                    height: layout.slotHeight(slot),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: metrics.sidePadding,
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                slot.index.toString(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${formatMinutes(slot.startMinutes)}\n${formatMinutes(slot.endMinutes)}',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(height: 1.05),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        for (var weekday = 1; weekday <= 7; weekday++)
                          _DayColumn(
                            width: metrics.dayColumnWidth,
                            borderColor: showGridLines
                                ? colors.outlineVariant.withValues(alpha: 0.25)
                                : Colors.transparent,
                            onLongPressAt: (localPosition) {
                              final matchedPeriod = layout.slotForY(
                                localPosition.dy,
                              );
                              onEmptySlotTap(
                                TimetableEmptySlotTapInfo(
                                  weekday: weekday,
                                  startMinutes: matchedPeriod.startMinutes,
                                  endMinutes: matchedPeriod.endMinutes,
                                  periods: [matchedPeriod.index],
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if (showGridLines)
                                  for (final slot in slots)
                                    Positioned(
                                      top: layout.slotTop(slot),
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: layout.slotHeight(slot),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: colors.outlineVariant
                                                  .withValues(alpha: 0.18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ...dayLayoutsByWeekday[weekday]!.map(
                                  (item) => _CourseCard(
                                    layout: item,
                                    verticalLayout: layout,
                                    metrics: metrics,
                                    themeColorMode: themeColorMode,
                                    courseNameColorValues:
                                        courseNameColorValues,
                                    colorfulTextColor: colorfulTextColor,
                                    liveCourseOutlineMode:
                                        liveCourseOutlineMode,
                                    outlineColor: Color(
                                      liveCourseOutlineColorValue,
                                    ),
                                    outlineWidth: liveCourseOutlineWidth,
                                    onTap: useEntries && item.entry != null
                                        ? () => onEntryTap!(item.entry!)
                                        : () => onCourseTap(
                                            TimetableCourseTapInfo(
                                              course: item.course!,
                                              courses: item.conflictCourses
                                                  .map((e) => e as CourseItem)
                                                  .toList(),
                                              isFullConflict:
                                                  item.isFullConflict,
                                              conflictKey: item.conflictKey,
                                            ),
                                          ),
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
            ],
          ),
        );
      },
    );
  }
}

/// 这些阈值先保证整周能塞进当前宽度，再去调留白和可读性。
class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.width,
    required this.borderColor,
    required this.onLongPressAt,
    required this.child,
  });

  final double width;
  final Color borderColor;
  final ValueChanged<Offset> onLongPressAt;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor)),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => onLongPressAt(details.localPosition),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}

class _TimetableMetrics {
  const _TimetableMetrics({
    required this.timeLabelWidth,
    required this.dayColumnWidth,
    required this.courseGap,
    required this.cardPadding,
    required this.sidePadding,
    required this.compact,
  });

  final double timeLabelWidth;
  final double dayColumnWidth;
  final double courseGap;
  final double cardPadding;
  final double sidePadding;
  final bool compact;

  factory _TimetableMetrics.fromWidth(double width) {
    final safeWidth = width.isFinite && width > 0 ? width : 980.0;
    final compact = safeWidth < 920;
    final timeLabelWidth = safeWidth < 600
        ? 34.0
        : safeWidth < 840
        ? 42.0
        : 52.0;
    final availableDaysWidth = math.max(safeWidth - timeLabelWidth, 0.0);
    return _TimetableMetrics(
      timeLabelWidth: timeLabelWidth,
      dayColumnWidth: availableDaysWidth / 7,
      courseGap: safeWidth < 600
          ? 2.0
          : compact
          ? 4.0
          : 6.0,
      cardPadding: safeWidth < 600
          ? 3.0
          : compact
          ? 5.0
          : 8.0,
      sidePadding: safeWidth < 600
          ? 1.0
          : compact
          ? 2.0
          : 4.0,
      compact: compact,
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.date,
    required this.compact,
    required this.localeCode,
  });

  final DateTime date;
  final bool compact;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 1 : 4, vertical: 8),
      child: Center(
        child: Text(
          formatMonthLabel(date.month, localeCode: localeCode),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: compact
              ? Theme.of(context).textTheme.labelSmall
              : Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.weekday,
    required this.date,
    required this.compact,
    required this.localeCode,
  });

  final int weekday;
  final DateTime date;
  final bool compact;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isToday = _isSameDate(date, DateTime.now());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 1 : 4, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatWeekdayShortLabel(weekday, localeCode: localeCode),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: compact
                ? Theme.of(context).textTheme.labelMedium
                : Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 2),
          Container(
            constraints: BoxConstraints(minWidth: compact ? 24 : 28),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 4 : 6,
              vertical: compact ? 2 : 3,
            ),
            decoration: isToday
                ? BoxDecoration(
                    color: colorScheme.primaryContainer,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.65),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  )
                : null,
            child: Text(
              '${date.day}',
              textAlign: TextAlign.center,
              style:
                  (compact
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.bodySmall)
                      ?.copyWith(
                        color: isToday ? colorScheme.onPrimaryContainer : null,
                        fontWeight: isToday ? FontWeight.w700 : null,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimetableVerticalLayout {
  _TimetableVerticalLayout({required this.slots, required this.preserveGaps})
    : _slotTops = _buildSlotTops(slots, preserveGaps) {
    totalHeight = slots.isEmpty
        ? 0
        : preserveGaps
        ? (slots.last.endMinutes - slots.first.startMinutes) * _minuteHeight
        : slots.fold<double>(0, (sum, slot) => sum + _slotHeightFor(slot));
  }

  final List<CoursePeriodTime> slots;
  final bool preserveGaps;
  final List<double> _slotTops;
  late final double totalHeight;

  static List<double> _buildSlotTops(
    List<CoursePeriodTime> slots,
    bool preserveGaps,
  ) {
    if (slots.isEmpty) {
      return const [];
    }
    if (preserveGaps) {
      final startMinutes = slots.first.startMinutes;
      return [
        for (final slot in slots)
          (slot.startMinutes - startMinutes) * _minuteHeight,
      ];
    }
    var currentTop = 0.0;
    final tops = <double>[];
    for (final slot in slots) {
      tops.add(currentTop);
      currentTop += _slotHeightFor(slot);
    }
    return tops;
  }

  static double _slotHeightFor(CoursePeriodTime slot) {
    return math.max(0, slot.endMinutes - slot.startMinutes) * _minuteHeight;
  }

  int _slotIndex(CoursePeriodTime slot) {
    final index = slots.indexWhere((item) => item.index == slot.index);
    return index < 0 ? 0 : index;
  }

  double slotTop(CoursePeriodTime slot) => _slotTops[_slotIndex(slot)];

  double slotHeight(CoursePeriodTime slot) => _slotHeightFor(slot);

  double minuteToY(int minute) {
    if (slots.isEmpty) {
      return 0;
    }
    final firstStart = slots.first.startMinutes;
    final lastEnd = slots.last.endMinutes;
    final clampedMinute = minute.clamp(firstStart, lastEnd).toInt();
    if (preserveGaps) {
      return (clampedMinute - firstStart) * _minuteHeight;
    }
    for (var index = 0; index < slots.length; index++) {
      final slot = slots[index];
      final top = _slotTops[index];
      if (clampedMinute < slot.startMinutes) {
        return top;
      }
      if (clampedMinute <= slot.endMinutes) {
        return top + (clampedMinute - slot.startMinutes) * _minuteHeight;
      }
    }
    return totalHeight;
  }

  double courseTop(CourseItem course) => minuteToY(course.startMinutes);

  double courseHeight(CourseItem course) {
    final visualHeight =
        minuteToY(course.endMinutes) - minuteToY(course.startMinutes);
    return math.max(88.0, visualHeight - _courseVerticalGap);
  }

  double entryTop(int startMinutes) => minuteToY(startMinutes);

  double entryHeight(int startMinutes, int endMinutes) {
    final visualHeight = minuteToY(endMinutes) - minuteToY(startMinutes);
    return math.max(88.0, visualHeight - _courseVerticalGap);
  }

  CoursePeriodTime slotForY(double y) {
    if (slots.isEmpty) {
      throw StateError('No period slots available');
    }
    final clampedY = totalHeight <= 0
        ? 0.0
        : y.clamp(0.0, math.max(totalHeight - 0.001, 0.0)).toDouble();
    for (var index = 0; index < slots.length; index++) {
      final bottom = _slotTops[index] + slotHeight(slots[index]);
      if (clampedY < bottom) {
        return slots[index];
      }
    }
    return slots.last;
  }
}

enum CourseDisplayState { active, futureInactive, pastEnded }

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.layout,
    required this.verticalLayout,
    required this.metrics,
    required this.themeColorMode,
    required this.courseNameColorValues,
    required this.colorfulTextColor,
    required this.liveCourseOutlineMode,
    required this.outlineColor,
    required this.outlineWidth,
    required this.onTap,
  });

  final CourseLayout layout;
  final _TimetableVerticalLayout verticalLayout;
  final _TimetableMetrics metrics;
  final String themeColorMode;
  final Map<String, int> courseNameColorValues;
  final Color? colorfulTextColor;
  final String liveCourseOutlineMode;
  final Color outlineColor;
  final double outlineWidth;
  final VoidCallback onTap;

  bool get _isInactiveForCurrentWeek =>
      layout.entry?.isInactive ??
      layout.displayState != CourseDisplayState.active;

  bool get _isPastEnded =>
      layout.entry?.isPastEnded ??
      layout.displayState == CourseDisplayState.pastEnded;

  String get _title => layout.entry?.title ?? layout.course?.name ?? '';

  String get _location =>
      layout.entry?.location ?? layout.course?.location ?? '';

  String get _teacher => layout.entry?.teacher ?? layout.course?.teacher ?? '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final entry = layout.entry;
    final top = entry != null
        ? verticalLayout.entryTop(entry.startMinutes)
        : verticalLayout.courseTop(layout.course!);
    final height = entry != null
        ? verticalLayout.entryHeight(entry.startMinutes, entry.endMinutes)
        : verticalLayout.courseHeight(layout.course!);
    final width = math.max(
      0.0,
      metrics.dayColumnWidth - (metrics.courseGap * 2),
    );
    final compact = width < 96 || height < 112;
    final normalizedColorName =
        layout.entry?.colorName ??
        (layout.course != null
            ? normalizeCourseColorName(layout.course!.name)
            : '');
    final colorfulCourseBase = normalizedColorName.isEmpty
        ? null
        : courseNameColorValues[normalizedColorName];
    final entryColorValue = layout.entry?.colorValue;
    final activeBaseColor = entryColorValue != null
        ? Color(entryColorValue)
        : themeColorMode == themeColorModeColorful && colorfulCourseBase != null
        ? Color(colorfulCourseBase)
        : Color.lerp(
                colorScheme.secondaryContainer,
                colorScheme.primaryContainer,
                0.18 + (layout.priorityDepth * 0.18),
              ) ??
              colorScheme.secondaryContainer;
    final futureInactiveColor = themeColorMode == themeColorModeColorful
        ? Color.lerp(activeBaseColor, colorScheme.surface, 0.58) ??
              colorScheme.surfaceContainerHighest
        : Color.lerp(
                colorScheme.surfaceContainerHighest,
                colorScheme.outlineVariant,
                0.34,
              ) ??
              colorScheme.surfaceContainerHighest;
    final pastEndedColor = themeColorMode == themeColorModeColorful
        ? Color.lerp(activeBaseColor, colorScheme.surface, 0.74) ??
              colorScheme.surfaceContainerHighest
        : Color.lerp(
                colorScheme.surface,
                colorScheme.surfaceContainerHighest,
                0.72,
              ) ??
              colorScheme.surfaceContainerHighest;
    final baseColor = switch (layout.displayState) {
      CourseDisplayState.active => activeBaseColor,
      CourseDisplayState.futureInactive => futureInactiveColor,
      CourseDisplayState.pastEnded => pastEndedColor,
    };
    final color = baseColor.withValues(
      alpha: _isInactiveForCurrentWeek
          ? (_isPastEnded ? 0.92 : 0.96)
          : layout.isFullConflict
          ? 0.94
          : layout.priorityDepth == 0
          ? 0.92
          : math.max(0.48, 0.82 - (layout.priorityDepth * 0.10)),
    );

    final effectiveOutlineWidth = compact
        ? math.max(minLiveCourseOutlineWidth, outlineWidth - 0.5)
        : outlineWidth;
    final effectivePrimaryOutlineWidth =
        liveCourseOutlineMode == liveCourseOutlineModeAllDisplayed &&
            layout.isPrimaryLiveTarget
        ? effectiveOutlineWidth + (compact ? 1.2 : 1.6)
        : effectiveOutlineWidth;

    return Positioned(
      top: top,
      left: metrics.courseGap,
      width: width,
      height: height,
      child: Card.filled(
        color: color,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(compact ? 8 : 10),
          side: layout.isLiveHighlighted
              ? BorderSide(
                  color: outlineColor,
                  width: layout.isPrimaryLiveTarget
                      ? effectivePrimaryOutlineWidth
                      : effectiveOutlineWidth,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(metrics.cardPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textColor =
                    (themeColorMode == themeColorModeColorful
                            ? (colorfulTextColor ??
                                  colorScheme.onSecondaryContainer)
                            : (_isInactiveForCurrentWeek
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSecondaryContainer))
                        .withValues(
                          alpha: _isInactiveForCurrentWeek
                              ? 0.9
                              : layout.priorityDepth == 0
                              ? 0.96
                              : 0.92,
                        );
                final titleStyle =
                    (compact ? textTheme.titleSmall : textTheme.titleMedium)
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: textColor,
                        );
                final bodyStyle =
                    (compact ? textTheme.bodySmall : textTheme.bodyMedium)
                        ?.copyWith(height: 1.1, color: textColor);
                final teacherStyle =
                    (compact ? textTheme.labelSmall : textTheme.labelMedium)
                        ?.copyWith(
                          height: 1.1,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        );

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: layout.isFullConflict
                              ? (compact ? 18.0 : 22.0)
                              : 0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: titleStyle,
                            ),
                            if (_location.isNotEmpty)
                              Text(
                                _location,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: bodyStyle,
                              ),
                            if (_teacher.isNotEmpty)
                              Text(
                                _teacher,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: teacherStyle,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (layout.isFullConflict)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(compact ? 2 : 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Icon(
                            Icons.layers_outlined,
                            size: compact ? 14 : 16,
                            color: textColor,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CourseLayout {
  const CourseLayout({
    this.course,
    this.entry,
    required this.priorityDepth,
    required this.isFullConflict,
    required this.conflictCourses,
    required this.displayState,
    required this.isLiveHighlighted,
    required this.isPrimaryLiveTarget,
    required this.liveTargetIsCurrentCourse,
    this.conflictKey,
  });

  final CourseItem? course;
  final TimetableEntry? entry;
  final int priorityDepth;
  final bool isFullConflict;
  final List<Object> conflictCourses;
  final CourseDisplayState displayState;
  final bool isLiveHighlighted;
  final bool isPrimaryLiveTarget;
  final bool liveTargetIsCurrentCourse;
  final String? conflictKey;
}

class OverlapGroup {
  const OverlapGroup(this.courses);

  final List<CourseItem> courses;
}

Color resolveSharedColorfulTextColor({
  required Iterable<CourseLayout> layouts,
  required Map<String, int> courseNameColorValues,
  required Color surfaceColor,
  required Color fallbackColor,
}) {
  var minLuminance = 1.0;
  var foundColor = false;

  for (final layout in layouts) {
    final normalizedColorName =
        layout.entry?.colorName ??
        (layout.course != null
            ? normalizeCourseColorName(layout.course!.name)
            : '');
    if (normalizedColorName.isEmpty) {
      continue;
    }
    final courseColorValue = courseNameColorValues[normalizedColorName];
    if (courseColorValue == null) {
      continue;
    }
    foundColor = true;
    final activeBaseColor = Color(courseColorValue);
    final inactiveColor =
        Color.lerp(activeBaseColor, surfaceColor, 0.74) ?? surfaceColor;
    final baseColor = switch (layout.displayState) {
      CourseDisplayState.active => activeBaseColor,
      CourseDisplayState.futureInactive =>
        Color.lerp(activeBaseColor, surfaceColor, 0.58) ?? surfaceColor,
      CourseDisplayState.pastEnded => inactiveColor,
    };
    final blendedColor = Color.alphaBlend(
      baseColor.withValues(
        alpha: layout.displayState != CourseDisplayState.active
            ? (layout.displayState == CourseDisplayState.pastEnded
                  ? 0.92
                  : 0.96)
            : layout.isFullConflict
            ? 0.94
            : layout.priorityDepth == 0
            ? 0.92
            : math.max(0.48, 0.82 - (layout.priorityDepth * 0.10)),
      ),
      surfaceColor,
    );
    minLuminance = math.min(minLuminance, blendedColor.computeLuminance());
  }

  if (!foundColor) {
    return fallbackColor;
  }

  final colorfulTextProgress = minLuminance < 0.5
      ? minLuminance * 0.4
      : 0.8 + ((minLuminance - 0.5) * 0.4);
  return Color.lerp(Colors.white, Colors.black, colorfulTextProgress) ??
      fallbackColor;
}

List<CourseLayout> _buildDayLayouts({
  required TimetableData timetable,
  required List<CourseItem> courses,
  required int weekday,
  required int selectedWeek,
  required int realCurrentWeek,
  required bool showPastEndedCourses,
  required bool showFutureCourses,
  required String? Function(String conflictKey)? displayedCourseIdForConflict,
  required TimetableLiveCourseTarget? liveCourseTarget,
  required bool liveCourseOutlineEnabled,
  required String liveCourseOutlineMode,
}) {
  final dayCourses =
      courses.where((item) => item.dayOfWeek == weekday).where((item) {
        return _displayStateForCourse(
              item,
              selectedWeek: selectedWeek,
              realCurrentWeek: realCurrentWeek,
              showPastEndedCourses: showPastEndedCourses,
              showFutureCourses: showFutureCourses,
            ) !=
            null;
      }).toList()..sort((a, b) {
        final startCompare = a.startMinutes.compareTo(b.startMinutes);
        if (startCompare != 0) {
          return startCompare;
        }
        final endCompare = a.endMinutes.compareTo(b.endMinutes);
        if (endCompare != 0) {
          return endCompare;
        }
        return a.id.compareTo(b.id);
      });

  final layouts = <CourseLayout>[];
  for (final group in buildOverlapGroups(dayCourses)) {
    if (_isFullConflictGroup(group.courses)) {
      final conflictKey = _buildConflictKey(
        timetable.id,
        weekday,
        group.courses,
      );
      final displayedCourseId = displayedCourseIdForConflict?.call(conflictKey);
      final displayedCourse = _pickDisplayedCourse(
        group.courses,
        displayedCourseId,
      );
      final sortedCourses = [...group.courses]
        ..sort(_compareDisplayedCourseChoice);
      final displayState =
          _displayStateForCourse(
            displayedCourse,
            selectedWeek: selectedWeek,
            realCurrentWeek: realCurrentWeek,
            showPastEndedCourses: showPastEndedCourses,
            showFutureCourses: showFutureCourses,
          ) ??
          CourseDisplayState.active;
      final isPrimaryLiveTarget =
          liveCourseOutlineEnabled &&
          liveCourseTarget?.week == selectedWeek &&
          liveCourseTarget?.weekday == weekday &&
          liveCourseTarget?.courseId == displayedCourse.id;
      final isLiveHighlighted =
          liveCourseOutlineEnabled &&
          (liveCourseOutlineMode == liveCourseOutlineModeAllDisplayed ||
              isPrimaryLiveTarget);
      layouts.add(
        CourseLayout(
          course: displayedCourse,
          priorityDepth: 0,
          isFullConflict: true,
          conflictCourses: sortedCourses,
          displayState: displayState,
          isLiveHighlighted: isLiveHighlighted,
          isPrimaryLiveTarget: isPrimaryLiveTarget,
          liveTargetIsCurrentCourse:
              isPrimaryLiveTarget &&
              (liveCourseTarget?.isCurrentCourse ?? false),
          conflictKey: conflictKey,
        ),
      );
      continue;
    }

    final sortedCourses = [...group.courses]..sort(_comparePaintPriority);
    for (var index = 0; index < sortedCourses.length; index++) {
      final course = sortedCourses[index];
      final displayState =
          _displayStateForCourse(
            course,
            selectedWeek: selectedWeek,
            realCurrentWeek: realCurrentWeek,
            showPastEndedCourses: showPastEndedCourses,
            showFutureCourses: showFutureCourses,
          ) ??
          CourseDisplayState.active;
      final isPrimaryLiveTarget =
          liveCourseOutlineEnabled &&
          liveCourseTarget?.week == selectedWeek &&
          liveCourseTarget?.weekday == weekday &&
          liveCourseTarget?.courseId == course.id;
      final isLiveHighlighted =
          liveCourseOutlineEnabled &&
          (liveCourseOutlineMode == liveCourseOutlineModeAllDisplayed ||
              isPrimaryLiveTarget);
      layouts.add(
        CourseLayout(
          course: course,
          priorityDepth: index,
          isFullConflict: false,
          conflictCourses: [course],
          displayState: displayState,
          isLiveHighlighted: isLiveHighlighted,
          isPrimaryLiveTarget: isPrimaryLiveTarget,
          liveTargetIsCurrentCourse:
              isPrimaryLiveTarget &&
              (liveCourseTarget?.isCurrentCourse ?? false),
        ),
      );
    }
  }
  return layouts;
}

List<CourseLayout> _buildDayLayoutsFromEntries({
  required List<TimetableEntry> entries,
  required int weekday,
}) {
  final dayEntries = entries.where((e) => e.dayOfWeek == weekday).toList()
    ..sort((a, b) {
      final startCompare = a.startMinutes.compareTo(b.startMinutes);
      if (startCompare != 0) return startCompare;
      final endCompare = a.endMinutes.compareTo(b.endMinutes);
      if (endCompare != 0) return endCompare;
      return a.id.compareTo(b.id);
    });

  final layouts = <CourseLayout>[];
  for (final group in _buildEntryOverlapGroups(dayEntries)) {
    final sorted = [...group]..sort(_compareEntryPaintPriority);
    for (var i = 0; i < sorted.length; i++) {
      layouts.add(
        CourseLayout(
          entry: sorted[i],
          priorityDepth: i,
          isFullConflict: false,
          conflictCourses: [sorted[i]],
          displayState: CourseDisplayState.active,
          isLiveHighlighted: false,
          isPrimaryLiveTarget: false,
          liveTargetIsCurrentCourse: false,
        ),
      );
    }
  }
  return layouts;
}

List<List<TimetableEntry>> _buildEntryOverlapGroups(
  List<TimetableEntry> entries,
) {
  if (entries.isEmpty) return const [];
  final groups = <List<TimetableEntry>>[];
  var current = <TimetableEntry>[];
  var currentEnd = -1;
  for (final entry in entries) {
    if (current.isEmpty) {
      current = [entry];
      currentEnd = entry.endMinutes;
      continue;
    }
    if (entry.startMinutes < currentEnd) {
      current.add(entry);
      currentEnd = math.max(currentEnd, entry.endMinutes);
      continue;
    }
    groups.add(List<TimetableEntry>.from(current));
    current = [entry];
    currentEnd = entry.endMinutes;
  }
  if (current.isNotEmpty) groups.add(List<TimetableEntry>.from(current));
  return groups;
}

int _compareEntryPaintPriority(TimetableEntry a, TimetableEntry b) {
  final startCompare = a.startMinutes.compareTo(b.startMinutes);
  if (startCompare != 0) return startCompare;
  final durCompare = (b.endMinutes - b.startMinutes).compareTo(
    a.endMinutes - a.startMinutes,
  );
  if (durCompare != 0) return durCompare;
  return a.id.compareTo(b.id);
}

CourseDisplayState? _displayStateForCourse(
  CourseItem course, {
  required int selectedWeek,
  required int realCurrentWeek,
  required bool showPastEndedCourses,
  required bool showFutureCourses,
}) {
  if (matchesSemesterWeek(course, selectedWeek)) {
    return CourseDisplayState.active;
  }
  if (course.semesterWeeks.isEmpty) {
    return CourseDisplayState.active;
  }
  final normalizedWeeks = normalizeSemesterWeeks(course.semesterWeeks);
  if (normalizedWeeks.isEmpty) {
    return CourseDisplayState.active;
  }
  if (selectedWeek < realCurrentWeek) {
    final nextWeek = normalizedWeeks.firstWhere(
      (week) => week > selectedWeek,
      orElse: () => -1,
    );
    if (nextWeek != -1) {
      return showFutureCourses ? CourseDisplayState.futureInactive : null;
    }
    return showPastEndedCourses ? CourseDisplayState.pastEnded : null;
  }
  if (selectedWeek > realCurrentWeek) {
    final lastWeek = normalizedWeeks.lastWhere(
      (week) => week < selectedWeek,
      orElse: () => -1,
    );
    if (lastWeek != -1) {
      return showPastEndedCourses ? CourseDisplayState.pastEnded : null;
    }
    return showFutureCourses ? CourseDisplayState.futureInactive : null;
  }
  final hasFutureWeek = normalizedWeeks.any((week) => week > realCurrentWeek);
  if (hasFutureWeek) {
    return showFutureCourses ? CourseDisplayState.futureInactive : null;
  }
  return showPastEndedCourses ? CourseDisplayState.pastEnded : null;
}

List<OverlapGroup> buildOverlapGroups(List<CourseItem> courses) {
  if (courses.isEmpty) {
    return const [];
  }
  final groups = <OverlapGroup>[];
  var currentCourses = <CourseItem>[];
  var currentEnd = -1;

  for (final course in courses) {
    if (currentCourses.isEmpty) {
      currentCourses = [course];
      currentEnd = course.endMinutes;
      continue;
    }
    if (course.startMinutes < currentEnd) {
      currentCourses.add(course);
      currentEnd = math.max(currentEnd, course.endMinutes);
      continue;
    }
    groups.add(OverlapGroup(List<CourseItem>.from(currentCourses)));
    currentCourses = [course];
    currentEnd = course.endMinutes;
  }

  if (currentCourses.isNotEmpty) {
    groups.add(OverlapGroup(List<CourseItem>.from(currentCourses)));
  }
  return groups;
}

bool _isFullConflictGroup(List<CourseItem> courses) {
  if (courses.length < 2) {
    return false;
  }
  final first = courses.first;
  final allSameRange = courses.every(
    (item) =>
        item.startMinutes == first.startMinutes &&
        item.endMinutes == first.endMinutes,
  );
  if (allSameRange) {
    return true;
  }
  if (courses.length == 2) {
    return _contains(courses[0], courses[1]) ||
        _contains(courses[1], courses[0]);
  }
  return false;
}

bool _contains(CourseItem outer, CourseItem inner) {
  return outer.startMinutes <= inner.startMinutes &&
      outer.endMinutes >= inner.endMinutes;
}

CourseItem _pickDisplayedCourse(
  List<CourseItem> courses,
  String? displayedCourseId,
) {
  for (final course in courses) {
    if (course.id == displayedCourseId) {
      return course;
    }
  }
  final sorted = [...courses]..sort(_compareDisplayedCourseChoice);
  return sorted.first;
}

int _compareDisplayedCourseChoice(CourseItem a, CourseItem b) {
  final durationCompare = (b.endMinutes - b.startMinutes).compareTo(
    a.endMinutes - a.startMinutes,
  );
  if (durationCompare != 0) {
    return durationCompare;
  }
  final startCompare = b.startMinutes.compareTo(a.startMinutes);
  if (startCompare != 0) {
    return startCompare;
  }
  return a.id.compareTo(b.id);
}

String _buildConflictKey(
  String timetableId,
  int weekday,
  List<CourseItem> courses,
) {
  final courseIds = courses.map((item) => item.id).toList()..sort();
  final startMinutes = courses
      .map((item) => item.startMinutes)
      .reduce(math.min);
  final endMinutes = courses.map((item) => item.endMinutes).reduce(math.max);
  return '$timetableId|$weekday|$startMinutes|$endMinutes|${courseIds.join(',')}';
}

/// 晚开始的课压在上层，更符合肉眼对重叠关系的直觉；开始时间一样时再优先短课。
int _comparePaintPriority(CourseItem a, CourseItem b) {
  final startCompare = a.startMinutes.compareTo(b.startMinutes);
  if (startCompare != 0) {
    return startCompare;
  }
  final durationCompare = (b.endMinutes - b.startMinutes).compareTo(
    a.endMinutes - a.startMinutes,
  );
  if (durationCompare != 0) {
    return durationCompare;
  }
  return a.id.compareTo(b.id);
}

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
