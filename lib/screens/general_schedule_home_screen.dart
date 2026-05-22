import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../widgets/general_event_details_sheet.dart';
import '../widgets/general_event_editor_sheet.dart';
import 'settings_page.dart';
import '../widgets/timetable_entry.dart';
import '../widgets/timetable_grid.dart';

class GeneralScheduleHomeScreen extends StatefulWidget {
  const GeneralScheduleHomeScreen({super.key});

  @override
  State<GeneralScheduleHomeScreen> createState() =>
      _GeneralScheduleHomeScreenState();
}

class _GeneralScheduleHomeScreenState extends State<GeneralScheduleHomeScreen> {
  late DateTime _displayedWeekStart;

  static DateTime _mondayOf(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    _displayedWeekStart = _mondayOf(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimetableProvider>();
    final l10n = AppLocalizations.of(context);

    final weekStart = _displayedWeekStart;
    final weekEnd = weekStart.add(const Duration(days: 7));
    final occurrences = provider.generalOccurrencesForRange(
      startInclusive: weekStart,
      endExclusive: weekEnd,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _pickDate(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _weekRangeLabel(weekStart, weekEnd),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  provider.activeGeneralSchedule.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
        actions: [
          PopupMenuButton<AppMode>(
            icon: const Icon(Icons.swap_horiz),
            tooltip: l10n.switchMode,
            onSelected: (mode) => provider.switchMode(mode),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AppMode.general,
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 18,
                      color: provider.isGeneralMode
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.generalSchedule),
                  ],
                ),
              ),
              PopupMenuItem(
                value: AppMode.student,
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 18,
                      color: provider.isStudentMode
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.studentTimetable),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: l10n.today,
            onPressed: () => _goToToday(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addCourse,
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
                        child: _buildSettingsPage(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Week navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _jumpWeek(-1),
              ),
              TextButton(
                onPressed: () => _pickDate(context),
                child: Text(_weekRangeLabel(weekStart, weekEnd)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _jumpWeek(1),
              ),
            ],
          ),
          // Week view
          Expanded(
            child: TimetableGrid(
              timetable: _buildDummyTimetable(),
              periodTimes: _buildHourlySlots(),
              weekDateStart: weekStart,
              selectedWeek: 1,
              realCurrentWeek: 1,
              localeCode: provider.localeCode,
              preserveGaps: true,
              showPastEndedCourses: false,
              showFutureCourses: true,
              showGridLines: provider.showTimetableGridLines,
              onCourseTap: (_) {},
              onEmptySlotTap: (info) => _openEditor(
                context,
                provider,
                initialDate: weekStart.add(Duration(days: info.weekday - 1)),
                initialStartMinutes: info.startMinutes,
                initialEndMinutes: info.endMinutes,
              ),
              themeColorMode: provider.themeColorMode,
              courseNameColorValues: const {},
              colorfulCourseTextColorMode: provider.colorfulCourseTextColorMode,
              liveCourseOutlineEnabled: false,
              liveCourseOutlineMode: liveCourseOutlineModeAllDisplayed,
              liveCourseOutlineColorValue: provider.liveCourseOutlineColorValue,
              liveCourseOutlineWidth: provider.liveCourseOutlineWidth,
              entries: occurrences.map((o) => occurrenceToEntry(o)).toList(),
              onEntryTap: (entry) => _openDetails(context, provider, entry),
            ),
          ),
        ],
      ),
    );
  }

  void _goToToday() {
    setState(() => _displayedWeekStart = _mondayOf(DateTime.now()));
  }

  void _jumpWeek(int offset) {
    setState(() {
      _displayedWeekStart = _displayedWeekStart.add(Duration(days: offset * 7));
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _displayedWeekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _displayedWeekStart = _mondayOf(picked));
    }
  }

  String _weekRangeLabel(DateTime start, DateTime end) {
    String fmt(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return '${fmt(start)} - ${fmt(end)}';
  }

  Future<void> _openEditor(
    BuildContext context,
    TimetableProvider provider, {
    DateTime? initialDate,
    int? initialStartMinutes,
    int? initialEndMinutes,
    GeneralEvent? event,
  }) async {
    DateTime? resolvedDate = initialDate;
    if (resolvedDate != null && initialStartMinutes != null) {
      resolvedDate = DateTime(
        resolvedDate.year,
        resolvedDate.month,
        resolvedDate.day,
        initialStartMinutes ~/ 60,
        initialStartMinutes % 60,
      );
    }
    final canDismiss = provider.closeCoursePopupOnOutsideTap;
    final result = await showModalBottomSheet<GeneralEventEditorResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
        maxWidth: 600,
        dismissOnOutsideTap: canDismiss,
        child: GeneralEventEditorSheet(
          initialEvent: event,
          initialDate: resolvedDate,
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
    TimetableEntry entry,
  ) async {
    final occurrence = entry.source as GeneralEventOccurrence;
    final canDismiss = provider.closeCoursePopupOnOutsideTap;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
        maxWidth: 520,
        dismissOnOutsideTap: canDismiss,
        child: GeneralEventDetailsSheet(
          occurrence: occurrence,
          onEdit: () {
            Navigator.of(sheetContext).pop();
            _openEditor(context, provider, event: occurrence.event);
          },
          onDelete: () async {
            await provider.deleteGeneralEvent(occurrence.event.id);
            if (sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
            }
          },
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
    final mediaQuery = MediaQuery.of(context);
    final effectiveWidth = mediaQuery.size.width > maxWidth
        ? maxWidth
        : mediaQuery.size.width;
    return SafeArea(
      child: GestureDetector(
        onTap: dismissOnOutsideTap
            ? () => Navigator.of(context).maybePop()
            : null,
        behavior: HitTestBehavior.opaque,
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  (mediaQuery.size.width - effectiveWidth) / 2,
                  0,
                  (mediaQuery.size.width - effectiveWidth) / 2,
                  0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(40),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [child],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static TimetableData _buildDummyTimetable() {
    return TimetableData(
      id: 'general_dummy',
      config: TimetableConfig(
        name: '',
        startDate: DateTime(2020),
        totalWeeks: 1,
        periodTimeSetId: '',
      ),
      courses: const [],
    );
  }

  static List<CoursePeriodTime> _buildHourlySlots() {
    final slots = <CoursePeriodTime>[];
    for (var h = 6; h < 24; h++) {
      slots.add(
        CoursePeriodTime(
          index: slots.length + 1,
          startMinutes: h * 60,
          endMinutes: (h + 1) * 60,
        ),
      );
    }
    return slots;
  }

  Widget _buildSettingsPage() {
    return const SettingsPage();
  }
}
