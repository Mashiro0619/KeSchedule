import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';

class ModeSwitchAction extends StatelessWidget {
  const ModeSwitchAction({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimetableProvider>();
    final l10n = AppLocalizations.of(context);
    final isStudent = provider.isStudentMode;
    return IconButton(
      icon: Icon(
        isStudent ? Icons.event_note_outlined : Icons.school_outlined,
      ),
      tooltip: isStudent
          ? l10n.switchToGeneralSchedule
          : l10n.switchToStudentTimetable,
      onPressed: () => provider.switchMode(
        isStudent ? AppMode.general : AppMode.student,
      ),
    );
  }
}
