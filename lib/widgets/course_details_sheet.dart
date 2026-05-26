import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_locale.dart' as app_locale;
import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart'
    show
        CourseItem,
        TimetableData,
        buildConflictKeyForCourses,
        formatDayOfWeekLabel,
        formatSemesterWeeksLabel,
        isFullConflictGroup,
        pickDisplayedCourseForConflict;
import '../providers/timetable_provider.dart';

class CourseDetailsSheet extends StatefulWidget {
  const CourseDetailsSheet({
    super.key,
    required this.courseId,
    required this.weekday,
    required this.conflictKey,
    required this.isFullConflict,
    required this.onEdit,
    this.onSelectDisplayedCourse,
    this.onEditConflictCourse,
    this.onMissing,
  });

  final String courseId;
  final int weekday;
  final String? conflictKey;
  final bool isFullConflict;
  final FutureOr<void> Function() onEdit;
  final FutureOr<void> Function(CourseItem)? onSelectDisplayedCourse;
  final FutureOr<void> Function(CourseItem)? onEditConflictCourse;
  final VoidCallback? onMissing;

  @override
  State<CourseDetailsSheet> createState() => _CourseDetailsSheetState();
}

class _CourseDetailsSheetState extends State<CourseDetailsSheet> {
  var _actionInProgress = false;
  var _missingNotified = false;

  Future<void> _runAction(
    FutureOr<void> Function()? action, {
    bool resetOnSuccess = true,
  }) async {
    if (_actionInProgress || action == null) {
      return;
    }
    setState(() => _actionInProgress = true);
    var succeeded = false;
    try {
      await action();
      succeeded = true;
    } finally {
      if (mounted && (resetOnSuccess || !succeeded)) {
        setState(() => _actionInProgress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        final timetable = provider.activeTimetableOrNull;
        if (timetable == null) {
          _notifyMissing();
          return const SizedBox.shrink();
        }

        final course = timetable.courses
            .where((item) => item.id == widget.courseId)
            .cast<CourseItem?>()
            .firstWhere((item) => item != null, orElse: () => null);
        if (course == null) {
          _notifyMissing();
          return const SizedBox.shrink();
        }

        final resolvedConflictCourses = _resolveConflictCourses(
          provider: provider,
          timetable: timetable,
          course: course,
        );
        final otherConflictCourses = resolvedConflictCourses
            .where((item) => item.id != course.id)
            .toList();

        final maxHeight = MediaQuery.of(context).size.height * 0.8;

        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.name,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.editCourseTooltip,
                        onPressed: _actionInProgress
                            ? null
                            : () => _runAction(widget.onEdit),
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _PrimaryInfoCard(
                    icon: Icons.place_outlined,
                    label: l10n.place,
                    value: course.location.isEmpty
                        ? l10n.notFilled
                        : course.location,
                  ),
                  const SizedBox(height: 10),
                  _PrimaryInfoCard(
                    icon: Icons.schedule,
                    label: l10n.time,
                    value: course.periods.isEmpty
                        ? course.timeRange
                        : '${course.timeRange} · ${_formatPeriodsLabel(l10n, course.periods)}',
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    label: l10n.teacherName,
                    value: course.teacher.isEmpty
                        ? l10n.notFilled
                        : course.teacher,
                  ),
                  _DetailRow(
                    label: l10n.dayOfWeek,
                    value: formatDayOfWeekLabel(
                      course.dayOfWeek,
                      localeCode: app_locale.localeCodeFromLocale(
                        Localizations.localeOf(context),
                      ),
                    ),
                  ),
                  _DetailRow(
                    label: l10n.semesterWeeks,
                    value: formatSemesterWeeksLabel(
                      course.semesterWeeks,
                      localeCode: app_locale.localeCodeFromLocale(
                        Localizations.localeOf(context),
                      ),
                    ),
                  ),
                  _DetailRow(
                    label: l10n.credits,
                    value: course.credit == 0
                        ? l10n.notFilled
                        : course.credit.toString(),
                  ),
                  _DetailRow(
                    label: l10n.remarks,
                    value: course.remarks.isEmpty ? l10n.none : course.remarks,
                  ),
                  if (otherConflictCourses.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.conflictCourses,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (final item in otherConflictCourses)
                      Card.outlined(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            '${item.location.isEmpty ? l10n.locationNotFilled : item.location} · ${item.timeRange}${item.periods.isEmpty ? '' : ' · ${_formatPeriodsLabel(l10n, item.periods)}'}',
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              if (widget.onSelectDisplayedCourse != null)
                                IconButton(
                                  tooltip: l10n.setAsDisplayed,
                                  onPressed: _actionInProgress
                                      ? null
                                      : () => _runAction(
                                          () => widget.onSelectDisplayedCourse!(
                                            item,
                                          ),
                                          resetOnSuccess: false,
                                        ),
                                  icon: const Icon(Icons.visibility_outlined),
                                ),
                              if (widget.onEditConflictCourse != null)
                                IconButton(
                                  tooltip: l10n.editThisCourse,
                                  onPressed: _actionInProgress
                                      ? null
                                      : () => _runAction(
                                          () => widget.onEditConflictCourse!(
                                            item,
                                          ),
                                        ),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                  if (course.customFields.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(l10n.customFields, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    for (final entry in course.customFields.entries)
                      _DetailRow(
                        label: entry.key,
                        value: entry.value.toString(),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<CourseItem> _resolveConflictCourses({
    required TimetableProvider provider,
    required TimetableData timetable,
    required CourseItem course,
  }) {
    if (!widget.isFullConflict) {
      return [course];
    }

    final sameWeekdayCourses = timetable.courses
        .where((item) => item.dayOfWeek == widget.weekday)
        .toList();
    final exactRangeCourses = sameWeekdayCourses
        .where(
          (item) =>
              item.startMinutes == course.startMinutes &&
              item.endMinutes == course.endMinutes,
        )
        .toList();
    if (exactRangeCourses.length > 1 &&
        isFullConflictGroup(exactRangeCourses)) {
      return _sortConflictCourses(provider, exactRangeCourses);
    }

    final containingCourses = sameWeekdayCourses
        .where(
          (item) =>
              item.startMinutes <= course.startMinutes &&
              item.endMinutes >= course.endMinutes,
        )
        .toList();
    if (containingCourses.length > 1 &&
        isFullConflictGroup(containingCourses)) {
      return _sortConflictCourses(provider, containingCourses);
    }

    return [course];
  }

  List<CourseItem> _sortConflictCourses(
    TimetableProvider provider,
    List<CourseItem> courses,
  ) {
    if (courses.length < 2) {
      return courses;
    }
    final key =
        widget.conflictKey ??
        buildConflictKeyForCourses(
          provider.activeTimetable.id,
          widget.weekday,
          courses,
        );
    final displayedCourseId = provider.displayedCourseIdForConflict(key);
    final displayedCourse = pickDisplayedCourseForConflict(
      courses,
      displayedCourseId,
    );
    final others = [...courses.where((item) => item.id != displayedCourse.id)]
      ..sort(_compareDisplayedCourseChoice);
    return [displayedCourse, ...others];
  }

  void _notifyMissing() {
    if (widget.onMissing == null || _missingNotified) {
      return;
    }
    _missingNotified = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onMissing?.call();
      }
    });
  }
}

String _formatPeriodsLabel(AppLocalizations l10n, List<int> periods) {
  if (periods.isEmpty) {
    return '';
  }
  final sorted = [...periods]..sort();
  if (sorted.first == sorted.last) {
    return l10n.periodNumberLabel(sorted.first);
  }
  return l10n.periodRangeLabel(sorted.first, sorted.last);
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

class _PrimaryInfoCard extends StatelessWidget {
  const _PrimaryInfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          const SizedBox(width: 12),
          Flexible(flex: 7, child: Text(value, softWrap: true)),
        ],
      ),
    );
  }
}
