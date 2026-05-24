part of 'home_screen.dart';

class _StudentHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _StudentHomeAppBar({
    required this.provider,
    required this.timetable,
    required this.week,
    required this.onTitleTap,
    required this.onAddCourse,
    required this.onOpenSettings,
  });

  final TimetableProvider provider;
  final TimetableData timetable;
  final int week;
  final VoidCallback onTitleTap;
  final VoidCallback onAddCourse;
  final VoidCallback onOpenSettings;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppBar(
      titleSpacing: AppSpacing.md,
      title: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTitleTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.weekLabel(week),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                timetable.config.name,
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
          onPressed: onAddCourse,
          icon: const Icon(Icons.add),
          tooltip: l10n.addCourse,
        ),
        IconButton(
          onPressed: onOpenSettings,
          icon: const Icon(Icons.settings_outlined),
          tooltip: l10n.settings,
        ),
      ],
    );
  }
}

class _TimetableDrawer extends StatelessWidget {
  const _TimetableDrawer({
    required this.provider,
    required this.activeTimetable,
    required this.onEditTimetable,
  });

  final TimetableProvider provider;
  final TimetableData activeTimetable;
  final ValueChanged<TimetableData> onEditTimetable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(title: Text(l10n.multiTimetableSwitch)),
            Expanded(
              child: ListView(
                children: [
                  for (final item in provider.timetables)
                    ListTile(
                      selected: item.id == activeTimetable.id,
                      leading: Icon(
                        item.id == activeTimetable.id
                            ? Icons.check_circle
                            : Icons.calendar_view_week,
                      ),
                      title: Text(item.config.name),
                      subtitle: Text(
                        item.id == activeTimetable.id
                            ? l10n.currentTimetableWeeks(item.config.totalWeeks)
                            : l10n.tapToSwitchWeeks(item.config.totalWeeks),
                      ),
                      trailing: IconButton(
                        tooltip: l10n.editTimetable,
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => onEditTimetable(item),
                      ),
                      onTap: () async {
                        if (item.id == activeTimetable.id) {
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
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton.icon(
                onPressed: provider.addTimetable,
                icon: const Icon(Icons.add),
                label: Text(l10n.createTimetable),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimetableWeekPager extends StatelessWidget {
  const _TimetableWeekPager({
    required this.controller,
    required this.provider,
    required this.timetable,
    required this.config,
    required this.onJumpWeekBy,
    required this.onCourseTap,
    required this.onEmptySlotTap,
  });

  final PageController controller;
  final TimetableProvider provider;
  final TimetableData timetable;
  final TimetableConfig config;
  final Future<void> Function(int offset) onJumpWeekBy;
  final ValueChanged<TimetableCourseTapInfo> onCourseTap;
  final ValueChanged<TimetableEmptySlotTapInfo> onEmptySlotTap;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          onJumpWeekBy(-1);
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          onJumpWeekBy(1);
        },
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
            controller: controller,
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
                padding: const EdgeInsets.fromLTRB(2, 8, 0, AppSpacing.md),
                child: TimetableGrid(
                  timetable: timetable,
                  periodTimes: provider.periodTimesForTimetable(timetable),
                  weekDateStart: weekStart,
                  selectedWeek: pageWeek,
                  realCurrentWeek: realCurrentWeek,
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
                  liveCourseOutlineEnabled: provider.liveCourseOutlineEnabled,
                  liveCourseOutlineMode: provider.liveCourseOutlineMode,
                  liveCourseOutlineColorValue: liveCourseOutlineColorValue,
                  liveCourseOutlineWidth: provider.liveCourseOutlineWidth,
                  onCourseTap: onCourseTap,
                  onEmptySlotTap: onEmptySlotTap,
                ),
              );
            },
          ),
        ),
      ),
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
