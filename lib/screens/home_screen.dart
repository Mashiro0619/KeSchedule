import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../widgets/course_details_sheet.dart';
import '../widgets/course_editor_sheet.dart';
import '../widgets/text_transfer_widgets.dart';
import '../widgets/timetable_grid.dart';
import '../widgets/mode_switch_action.dart';
import 'settings_page.dart';
import 'timetable_import_flow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? _pageController;
  bool _hasScheduledStartupUpdateCheck = false;
  bool _hasStartedPrivacyPolicyFetch = false;
  bool _isShowingPrivacyConsentDialog = false;
  Timer? _liveCourseTimer;
  TimetableProvider? _lastProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<TimetableProvider>();
    _startPrivacyPolicyFetch(provider);
    if (_lastProvider != provider) {
      _lastProvider?.removeListener(_onProviderReady);
      _lastProvider = provider;
      provider.addListener(_onProviderReady);
    }
    _onProviderReady();
  }

  void _onProviderReady() {
    if (!mounted) return;
    final provider = _lastProvider;
    if (provider == null || !provider.isLoaded) return;
    _ensurePrivacyConsentDialog(provider);
    _scheduleStartupUpdateCheck(provider);
    _ensureLiveCourseTimer(provider);
  }

  @override
  void dispose() {
    _lastProvider?.removeListener(_onProviderReady);
    _liveCourseTimer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  void _startPrivacyPolicyFetch(TimetableProvider provider) {
    if (_hasStartedPrivacyPolicyFetch) return;
    _hasStartedPrivacyPolicyFetch = true;
    provider.fetchRemotePrivacyPolicyVersion();
  }

  void _scheduleStartupUpdateCheck(TimetableProvider provider) {
    if (_hasScheduledStartupUpdateCheck) {
      return;
    }
    _hasScheduledStartupUpdateCheck = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted ||
          !provider.isLoaded ||
          !provider.hasAcceptedCurrentPrivacyPolicy) {
        return;
      }
      await AppUpdateCoordinator.checkForUpdates(
        context,
        provider: provider,
        source: UpdateCheckSource.startup,
      );
    });
  }

  void _ensureLiveCourseTimer(TimetableProvider provider) {
    if (!provider.isLoaded || provider.activeTimetableOrNull == null) {
      _liveCourseTimer?.cancel();
      _liveCourseTimer = null;
      return;
    }
    if (_liveCourseTimer != null) {
      return;
    }
    _liveCourseTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void _ensurePrivacyConsentDialog(TimetableProvider provider) {
    if (!mounted ||
        !provider.isLoaded ||
        provider.hasAcceptedCurrentPrivacyPolicy ||
        _isShowingPrivacyConsentDialog) {
      return;
    }
    _isShowingPrivacyConsentDialog = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (!mounted ||
            !provider.isLoaded ||
            provider.hasAcceptedCurrentPrivacyPolicy) {
          return;
        }
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            final l10n = AppLocalizations.of(dialogContext);
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text(l10n.privacyGateTitle),
                content: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.privacyPolicyIntro),
                        const SizedBox(height: 16),
                        _PrivacySummaryRow(text: l10n.privacyGateSummaryStorage),
                        const SizedBox(height: 8),
                        _PrivacySummaryRow(
                          text: l10n.privacyGateSummaryImportExport,
                        ),
                        const SizedBox(height: 8),
                        _PrivacySummaryRow(text: l10n.privacyGateSummaryUpdates),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => _openPrivacyPolicyPage(),
                    child: Text(l10n.privacyViewFullPolicy),
                  ),
                  TextButton(
                    onPressed: () => _declinePrivacyPolicy(dialogContext),
                    child: Text(l10n.privacyDecline),
                  ),
                  FilledButton(
                    onPressed: () async {
                      await provider.acceptPrivacyPolicyCurrentVersion();
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: Text(l10n.privacyAgreeAndContinue),
                  ),
                ],
              ),
            );
          },
        );
      } finally {
        _isShowingPrivacyConsentDialog = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context);
        if (!provider.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final timetable = provider.activeTimetableOrNull;
        if (timetable == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.appTitle),
              actions: const [ModeSwitchAction()],
            ),
            body: _EmptyTimetableState(
              onCreate: provider.addTimetable,
              onImport: () => _importTimetableData(context, provider),
              onImportFromText: () =>
                  _importTimetablesFromText(context, provider),
              onImportFromWeb: () => _importTimetableFromWeb(context, provider),
            ),
          );
        }

        final config = timetable.config;
        final week = provider.selectedWeek;
        _ensurePageController(week);

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 12,
            title: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _showWeekPicker(
                context,
                provider,
                config.totalWeeks,
                currentWeekFor(config),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.weekLabel(week),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      config.name,
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
                onPressed: () => _openEditor(context, provider),
                icon: const Icon(Icons.add),
                tooltip: l10n.addCourse,
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ChangeNotifierProvider<TimetableProvider>.value(
                          value: provider,
                          child: const SettingsPage(),
                        ),
                  ),
                ),
                icon: const Icon(Icons.settings_outlined),
                tooltip: l10n.settings,
              ),
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(title: Text(l10n.multiTimetableSwitch)),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final item in provider.timetables)
                          ListTile(
                            selected: item.id == timetable.id,
                            leading: Icon(
                              item.id == timetable.id
                                  ? Icons.check_circle
                                  : Icons.calendar_view_week,
                            ),
                            title: Text(item.config.name),
                            subtitle: Text(
                              item.id == timetable.id
                                  ? l10n.currentTimetableWeeks(
                                      item.config.totalWeeks,
                                    )
                                  : l10n.tapToSwitchWeeks(
                                      item.config.totalWeeks,
                                    ),
                            ),
                            trailing: IconButton(
                              tooltip: l10n.editTimetable,
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () {
                                _openTimetableItemDialog(
                                  this.context,
                                  provider,
                                  item,
                                );
                              },
                            ),
                            onTap: () async {
                              if (item.id == timetable.id) {
                                Navigator.of(context).pop();
                                return;
                              }
                              await provider.switchTimetable(item.id);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FilledButton.icon(
                      onPressed: provider.addTimetable,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.createTimetable),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
                  _jumpWeekBy(provider, -1),
              const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
                  _jumpWeekBy(provider, 1),
            },
            child: Focus(
              autofocus: true,
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
                  itemCount: config.totalWeeks,
                  onPageChanged: (index) => provider.setSelectedWeek(index + 1),
                  itemBuilder: (context, index) {
                    final pageWeek = index + 1;
                    final weekStart = startOfWeekFor(config, pageWeek);
                    final realCurrentWeek = currentWeekFor(config);
                    final liveCourseTarget = currentOrNextCourseTargetFor(
                      timetable: timetable,
                      selectedWeek: pageWeek,
                      realCurrentWeek: realCurrentWeek,
                      now: DateTime.now(),
                      displayedCourseIdForConflict:
                          provider.displayedCourseIdForConflict,
                    );
                    final liveCourseOutlineColorValue =
                        provider.liveCourseOutlineFollowTheme
                        ? deriveLiveCourseOutlineColorFromSeed(
                            Color(provider.themeSeedColorValue),
                          ).toARGB32()
                        : provider.liveCourseOutlineColorValue;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 8, 0, 12),
                      child: TimetableGrid(
                        timetable: timetable,
                        periodTimes: provider.periodTimesForTimetable(
                          timetable,
                        ),
                        weekDateStart: weekStart,
                        selectedWeek: pageWeek,
                        realCurrentWeek: currentWeekFor(config),
                        localeCode: provider.localeCode,
                        preserveGaps: provider.preserveTimetableGaps,
                        showPastEndedCourses: provider.showPastEndedCourses,
                        showFutureCourses: provider.showFutureCourses,
                        showGridLines: provider.showTimetableGridLines,
                        themeColorMode: provider.themeColorMode,
                        courseNameColorValues: provider.courseNameColorValues,
                        colorfulCourseTextColorMode:
                            provider.colorfulCourseTextColorMode,
                        colorfulCourseTextColorValue: provider
                            .colorfulUiColorValues[colorfulCourseTextColorKey],
                        displayedCourseIdForConflict:
                            provider.displayedCourseIdForConflict,
                        liveCourseTarget: liveCourseTarget,
                        liveCourseOutlineEnabled:
                            provider.liveCourseOutlineEnabled,
                        liveCourseOutlineMode:
                            provider.liveCourseOutlineMode,
                        liveCourseOutlineColorValue:
                            liveCourseOutlineColorValue,
                        liveCourseOutlineWidth:
                            provider.liveCourseOutlineWidth,
                        onCourseTap: (info) =>
                            _openDetails(context, provider, info),
                        onEmptySlotTap: (slotInfo) => _openEditor(
                          context,
                          provider,
                          weekday: slotInfo.weekday,
                          emptySlot: slotInfo,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _ensurePageController(int week) {
    // 周数要等 provider 异步加载完成后才稳定，所以这里每次 build 都顺手校正一下页码。
    final targetPage = week - 1;
    if (_pageController == null) {
      _pageController = PageController(initialPage: targetPage);
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _pageController == null || !_pageController!.hasClients) {
        return;
      }
      final currentPage = _pageController!.page?.round() ?? targetPage;
      if (currentPage != targetPage) {
        _pageController!.jumpToPage(targetPage);
      }
    });
  }

  Future<void> _jumpWeekBy(TimetableProvider provider, int offset) async {
    final timetable = provider.activeTimetableOrNull;
    if (timetable == null || offset == 0) {
      return;
    }
    final targetWeek = (provider.selectedWeek + offset).clamp(
      1,
      timetable.config.totalWeeks,
    );
    if (targetWeek == provider.selectedWeek) {
      return;
    }
    await _animateToWeek(provider, targetWeek);
  }

  Future<void> _animateToWeek(TimetableProvider provider, int week) async {
    final controller = _pageController;
    final targetPage = week - 1;
    if (controller == null || !controller.hasClients) {
      await provider.setSelectedWeek(week);
      return;
    }
    await controller.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openDetails(
    BuildContext context,
    TimetableProvider provider,
    TimetableCourseTapInfo info,
  ) async {
    final canDismiss = provider.closeCoursePopupOnOutsideTap;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
        maxWidth: 860,
        dismissOnOutsideTap: canDismiss,
        child: CourseDetailsSheet(
          courseId: info.course.id,
          weekday: info.course.dayOfWeek,
          conflictKey: info.conflictKey,
          isFullConflict: info.isFullConflict,
          onEdit: () {
            _openEditor(context, provider, course: info.course);
          },
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
              : (course) {
                  _openEditor(context, provider, course: course);
                },
        ),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    TimetableProvider provider, {
    CourseItem? course,
    int? weekday,
    TimetableEmptySlotTapInfo? emptySlot,
  }) async {
    // 外部点按是否关闭交给设置控制，但底部弹窗本身仍保持明确的保存/取消出口。
    final periodTimes = provider.activeTimetableOrNull == null
        ? buildDefaultPeriodTimes()
        : provider.periodTimesForTimetable(provider.activeTimetable);
    final totalWeeks = provider.activeTimetableOrNull?.config.totalWeeks ?? 18;
    final canDismiss = provider.closeCoursePopupOnOutsideTap;
    final result = await showModalBottomSheet<CourseEditorResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: canDismiss,
      enableDrag: canDismiss,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _buildAdaptiveBottomSheet(
        sheetContext,
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
      await provider.deleteCourse(course.id);
      return;
    }
    if (result.course != null) {
      await provider.saveCourse(result.course!);
    }
  }

  Future<void> _showWeekPicker(
    BuildContext context,
    TimetableProvider provider,
    int totalWeeks,
    int realCurrentWeek,
  ) async {
    // 这里直接给一个轻量选择框，比再进设置页改周数顺手很多。
    final week = await showDialog<int>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final mediaQuery = MediaQuery.of(context);
        final dialogWidth = math.min(mediaQuery.size.width - 32, 360.0);
        const spacing = 10.0;
        const chipHeight = 40.0;
        final maxGridHeight = mediaQuery.size.height * 0.5;
        return AlertDialog(
          title: Text(AppLocalizations.of(context).jumpToWeek),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: SizedBox(
            width: dialogWidth,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final crossAxisCount = availableWidth >= 280 ? 4 : 3;
                final chipWidth =
                    (availableWidth - ((crossAxisCount - 1) * spacing)) /
                    crossAxisCount;
                final rowCount = (totalWeeks / crossAxisCount).ceil();
                final fullGridHeight =
                    (rowCount * chipHeight) + ((rowCount - 1) * spacing);
                final visibleRows = math.max(
                  1,
                  math.min(
                    rowCount,
                    ((maxGridHeight + spacing) / (chipHeight + spacing)).floor(),
                  ),
                );
                final gridHeight = rowCount <= visibleRows
                    ? fullGridHeight
                    : (visibleRows * chipHeight) +
                        ((visibleRows - 1) * spacing);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: gridHeight),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (var index = 0; index < totalWeeks; index++)
                          Builder(
                            builder: (context) {
                              final weekNumber = index + 1;
                              final isSelected = weekNumber == provider.selectedWeek;
                              final isRealCurrentWeek =
                                  weekNumber == realCurrentWeek;
                              final backgroundColor = isSelected
                                  ? theme.colorScheme.secondaryContainer
                                  : isRealCurrentWeek
                                  ? theme.colorScheme.surfaceContainerHighest
                                  : theme.colorScheme.surface;
                              return SizedBox(
                                width: chipWidth,
                                height: chipHeight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => Navigator.of(context).pop(weekNumber),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.secondary
                                              : theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$weekNumber',
                                          style: theme.textTheme.titleMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (week != null) {
      await _animateToWeek(provider, week);
    }
  }

  Future<void> _openTimetableItemDialog(
    BuildContext context,
    TimetableProvider provider,
    TimetableData timetable,
  ) async {
    final nameController = TextEditingController(text: timetable.config.name);
    final weeksController = TextEditingController(
      text: timetable.config.totalWeeks.toString(),
    );
    var selectedStartDate = timetable.config.startDate;
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final viewInsets = MediaQuery.of(context).viewInsets;
        String formatDate(DateTime date) {
          final year = date.year.toString().padLeft(4, '0');
          final month = date.month.toString().padLeft(2, '0');
          final day = date.day.toString().padLeft(2, '0');
          return '$year-$month-$day';
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(24, 24, 24, viewInsets.bottom + 24),
              child: Center(
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(28),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n.timetable,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: l10n.timetableName,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: weeksController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                      final text = newValue.text;
                                      if (text.isEmpty) {
                                        return newValue;
                                      }
                                      final value = int.tryParse(text);
                                      if (value == null) {
                                        return oldValue;
                                      }
                                      final clamped = normalizeTimetableWeeks(value);
                                      if (clamped == value) {
                                        return newValue;
                                      }
                                      final clampedText = clamped.toString();
                                      return TextEditingValue(
                                        text: clampedText,
                                        selection: TextSelection.collapsed(
                                          offset: clampedText.length,
                                        ),
                                      );
                                    }),
                                  ],
                                  decoration: InputDecoration(labelText: l10n.totalWeeks),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            leading: const Icon(Icons.calendar_month_outlined),
                            title: Text(l10n.semesterStartDate),
                            subtitle: Text(formatDate(selectedStartDate)),
                            trailing: const Icon(Icons.calendar_month),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                                initialDate: selectedStartDate,
                              );
                              if (picked == null || picked == selectedStartDate) {
                                return;
                              }
                              setDialogState(() => selectedStartDate = picked);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop('delete'),
                                  child: Text(l10n.delete),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(l10n.cancel),
                                ),
                                const SizedBox(width: 8),
                                FilledButton(
                                  onPressed: () => Navigator.of(context).pop('save'),
                                  child: Text(l10n.save),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    if (result == 'save') {
      final totalWeeks = normalizeTimetableWeeks(
        int.tryParse(weeksController.text) ?? timetable.config.totalWeeks,
      );
      weeksController.value = TextEditingValue(
        text: totalWeeks.toString(),
        selection: TextSelection.collapsed(
          offset: totalWeeks.toString().length,
        ),
      );
      await provider.updateTimetableConfigFor(
        timetable.id,
        timetable.config.copyWith(
          name: nameController.text.trim().isEmpty
              ? timetable.config.name
              : nameController.text.trim(),
          startDate: selectedStartDate,
          totalWeeks: totalWeeks,
        ),
      );
    }
    if (result == 'delete') {
      if (!mounted) {
        nameController.dispose();
        weeksController.dispose();
        return;
      }
      final confirmed = await showDialog<bool>(
        context: this.context,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(l10n.deleteTimetableTitle),
            content: Text(l10n.deleteTimetableMessage(timetable.config.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.delete),
              ),
            ],
          );
        },
      );
      if (confirmed == true) {
        await provider.deleteTimetable(timetable.id);
      }
    }
    nameController.dispose();
    weeksController.dispose();
  }

  Future<void> _importTimetableData(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    await TimetableImportFlow.importTimetables(context, provider);
  }

  Future<void> _importTimetablesFromText(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextImportPage(
          title: l10n.importTimetableText,
          onSubmit: (context, content) {
            return TimetableImportFlow.importTimetablesFromSource(
              context,
              provider,
              content,
            );
          },
        ),
      ),
    );
  }

  Future<void> _importTimetableFromWeb(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    await TimetableImportFlow.openSchoolSitesPage(context, provider);
  }

  Future<void> _openPrivacyPolicyPage() async {
    final uri = Uri.parse('https://mashiro.tech/KeSchedule/privacy.html');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _declinePrivacyPolicy(BuildContext context) async {
    if (kIsWeb) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).privacyDeclineWebHint,
          ),
        ),
      );
      return;
    }
    await SystemNavigator.pop();
  }

  Widget _buildAdaptiveBottomSheet(
    BuildContext context, {
    required Widget child,
    required double maxWidth,
    bool dismissOnOutsideTap = false,
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

class _PrivacySummaryRow extends StatelessWidget {
  const _PrivacySummaryRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(Icons.check_circle_outline, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _EmptyTimetableState extends StatelessWidget {
  const _EmptyTimetableState({
    required this.onCreate,
    required this.onImport,
    required this.onImportFromText,
    required this.onImportFromWeb,
  });

  final Future<void> Function() onCreate;
  final Future<void> Function() onImport;
  final Future<void> Function() onImportFromText;
  final Future<void> Function() onImportFromWeb;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 48),
            const SizedBox(height: 12),
            Text(
              l10n.noTimetableTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.noTimetableMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.createTimetable),
                ),
                OutlinedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.file_download_outlined),
                  label: Text(l10n.importTimetable),
                ),
                OutlinedButton.icon(
                  onPressed: onImportFromText,
                  icon: const Icon(Icons.paste_outlined),
                  label: Text(l10n.importTimetableText),
                ),
                OutlinedButton.icon(
                  onPressed: onImportFromWeb,
                  icon: const Icon(Icons.language_outlined),
                  label: Text(l10n.schoolWebImportEntry),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
