import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import 'general_schedule_home_screen.dart';
import 'home_screen.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        if (!provider.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.isStudentMode) {
          return const StudentModeShell(child: HomeScreen());
        }

        return const GeneralScheduleHomeScreen();
      },
    );
  }
}

class StudentModeShell extends StatelessWidget {
  const StudentModeShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TimetableProvider>();
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          right: 8,
          child: SafeArea(
            child: _ModeSwitchButton(provider: provider),
          ),
        ),
      ],
    );
  }
}

class _ModeSwitchButton extends StatelessWidget {
  const _ModeSwitchButton({required this.provider});

  final TimetableProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<AppMode>(
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
    );
  }
}
