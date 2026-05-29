part of 'home_screen.dart';

extension _HomeScreenCourseActions on _HomeScreenState {
  Future<void> _openDetails(
    BuildContext context,
    TimetableProvider provider,
    TimetableCourseTapInfo info,
  ) async {
    if (_courseDetailsOpen || !mounted) {
      return;
    }
    _setCourseDetailsOpen(true);
    try {
      final canDismiss = provider.closeCoursePopupOnOutsideTap;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        isDismissible: canDismiss,
        enableDrag: canDismiss,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => AdaptiveModalSurface(
          maxWidth: 860,
          dismissOnOutsideTap: canDismiss,
          child: CourseDetailsSheet(
            courseId: info.course.id,
            weekday: info.course.dayOfWeek,
            conflictKey: info.conflictKey,
            isFullConflict: info.isFullConflict,
            onEdit: () => _openEditor(context, provider, course: info.course),
            onMissing: () {
              if (sheetContext.mounted) {
                Navigator.of(sheetContext).maybePop();
              }
            },
            onSelectDisplayedCourse:
                !info.isFullConflict || info.conflictKey == null
                ? null
                : (course) async {
                    await provider.setDisplayedCourseForConflict(
                      info.conflictKey!,
                      course.id,
                    );
                    if (sheetContext.mounted) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
            onEditConflictCourse: !info.isFullConflict
                ? null
                : (course) => _openEditor(context, provider, course: course),
          ),
        ),
      );
    } finally {
      _setCourseDetailsOpen(false);
    }
  }

  Future<void> _openEditor(
    BuildContext context,
    TimetableProvider provider, {
    CourseItem? course,
    int? weekday,
    TimetableEmptySlotTapInfo? emptySlot,
  }) async {
    if (_courseEditorOpen || !mounted) {
      return;
    }
    _setCourseEditorOpen(true);
    try {
      final periodTimes = provider.activeTimetableOrNull == null
          ? buildDefaultPeriodTimes()
          : provider.periodTimesForTimetable(provider.activeTimetable);
      final totalWeeks =
          provider.activeTimetableOrNull?.config.totalWeeks ?? 18;
      final canDismiss = provider.closeCoursePopupOnOutsideTap;
      final result = await showModalBottomSheet<CourseEditorResult>(
        context: context,
        isScrollControlled: true,
        isDismissible: canDismiss,
        enableDrag: canDismiss,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => AdaptiveModalSurface(
          maxWidth: 920,
          dismissOnOutsideTap: canDismiss,
          child: CourseEditorSheet(
            periodTimes: periodTimes,
            totalWeeks: totalWeeks,
            initialCourse: course,
            dayOfWeek: weekday ?? emptySlot?.weekday ?? course?.dayOfWeek ?? 1,
            initialStartMinutes: emptySlot?.startMinutes,
            initialEndMinutes: emptySlot?.endMinutes,
            initialPeriods: emptySlot?.periods,
          ),
        ),
      );

      if (result == null) {
        return;
      }
      if (result.delete && course != null) {
        try {
          await provider.deleteCourse(course.id);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).saveFailedRetry),
              ),
            );
          }
        }
        return;
      }
      if (result.course != null) {
        try {
          await provider.saveCourse(result.course!);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).saveFailedRetry),
              ),
            );
          }
        }
      }
    } finally {
      _setCourseEditorOpen(false);
    }
  }
}
