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
import '../widgets/timetable_entry.dart';
import '../widgets/timetable_grid.dart';

class GeneralScheduleHomeScreen extends StatefulWidget {
  const GeneralScheduleHomeScreen({super.key});

  @override
  State<GeneralScheduleHomeScreen> createState() =>
      _GeneralScheduleHomeScreenState();
}

class _GeneralScheduleHomeScreenState extends State<GeneralScheduleHomeScreen> {
  PageController? _pageController;

  static final DateTime _kEpoch = DateTime.utc(2020, 1, 6);

  static DateTime _mondayOf(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  static DateTime _weekStartForPage(int page) =>
      _kEpoch.add(Duration(days: page * 7));

  static int _pageForWeekStart(DateTime weekStart) =>
      weekStart.difference(_kEpoch).inDays ~/ 7;

  @override
  void initState() {
    super.initState();
    _ensurePageController(_pageForWeekStart(_mondayOf(DateTime.now())));
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _ensurePageController(int page) {
    _pageController ??= PageController(initialPage: page);
  }

  DateTime get _displayedWeekStart {
    final controller = _pageController;
    if (controller == null || !controller.hasClients) {
      return _mondayOf(DateTime.now());
    }
    final page = controller.page?.round() ?? controller.initialPage;
    return _weekStartForPage(page);
  }

  Future<void> _animateToPage(int page) async {
    final controller = _pageController;
    if (controller == null || !controller.hasClients) {
      _pageController = PageController(initialPage: page);
      setState(() {});
      return;
    }
    await controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimetableProvider>();
    final l10n = AppLocalizations.of(context);

    final page = _pageForWeekStart(_displayedWeekStart);
    _ensurePageController(page);

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
                  _weekRangeLabel(_displayedWeekStart),
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
          const ModeSwitchAction(),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: l10n.today,
            onPressed: () => _goToToday(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _animateToPage(
                  _pageForWeekStart(_displayedWeekStart) - 1,
                ),
              ),
              TextButton(
                onPressed: () => _pickDate(context),
                child: Text(_weekRangeLabel(_displayedWeekStart)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _animateToPage(
                  _pageForWeekStart(_displayedWeekStart) + 1,
                ),
              ),
            ],
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
              child: PageView.builder(
                controller: _pageController!,
                itemBuilder: (context, page) {
                  final weekStart = _weekStartForPage(page);
                  final occurrences = provider.generalOccurrencesForRange(
                    startInclusive: weekStart,
                    endExclusive: weekStart.add(const Duration(days: 7)),
                  );
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(2, 8, 0, 12),
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
                        initialDate: weekStart.add(
                          Duration(days: info.weekday - 1),
                        ),
                        initialStartMinutes: info.startMinutes,
                        initialEndMinutes: info.endMinutes,
                      ),
                      themeColorMode: provider.themeColorMode,
                      courseNameColorValues: const {},
                      colorfulCourseTextColorMode:
                          provider.colorfulCourseTextColorMode,
                      liveCourseOutlineEnabled: false,
                      liveCourseOutlineMode: liveCourseOutlineModeAllDisplayed,
                      liveCourseOutlineColorValue:
                          provider.liveCourseOutlineColorValue,
                      liveCourseOutlineWidth: provider.liveCourseOutlineWidth,
                      entries:
                          occurrences.map((o) => occurrenceToEntry(o)).toList(),
                      onEntryTap: (entry) =>
                          _openDetails(context, provider, entry),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToToday() {
    _animateToPage(_pageForWeekStart(_mondayOf(DateTime.now())));
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _displayedWeekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _animateToPage(_pageForWeekStart(_mondayOf(picked)));
    }
  }

  String _weekRangeLabel(DateTime start) {
    final end = start.add(const Duration(days: 7));
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
