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
import '../widgets/adaptive_modal_surface.dart';
import '../widgets/app_layout_tokens.dart';
import '../widgets/course_details_sheet.dart';
import '../widgets/course_editor_sheet.dart';
import '../widgets/mode_switch_action.dart';
import '../widgets/text_transfer_widgets.dart';
import '../widgets/timetable_grid.dart';
import 'settings_page.dart';
import 'timetable_import_flow.dart';

part 'home_screen_course_actions.dart';
part 'home_screen_imports.dart';
part 'home_screen_privacy.dart';
part 'home_screen_timetable_management.dart';
part 'home_screen_widgets.dart';

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
          appBar: _StudentHomeAppBar(
            provider: provider,
            timetable: timetable,
            week: week,
            onTitleTap: () => _showWeekPicker(
              context,
              provider,
              config.totalWeeks,
              currentWeekFor(config),
            ),
            onAddCourse: () => _openEditor(context, provider),
            onOpenSettings: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider<TimetableProvider>.value(
                  value: provider,
                  child: const SettingsPage(),
                ),
              ),
            ),
          ),
          drawer: _TimetableDrawer(
            provider: provider,
            activeTimetable: timetable,
            onEditTimetable: (item) =>
                _openTimetableItemDialog(this.context, provider, item),
          ),
          body: _TimetableWeekPager(
            controller: _pageController!,
            provider: provider,
            timetable: timetable,
            config: config,
            onJumpWeekBy: (offset) => _jumpWeekBy(provider, offset),
            onCourseTap: (info) => _openDetails(context, provider, info),
            onEmptySlotTap: (slotInfo) => _openEditor(
              context,
              provider,
              weekday: slotInfo.weekday,
              emptySlot: slotInfo,
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
}
