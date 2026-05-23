import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/timetable_provider.dart';

class GeneralDisplaySettingsPage extends StatefulWidget {
  const GeneralDisplaySettingsPage({super.key});

  @override
  State<GeneralDisplaySettingsPage> createState() =>
      _GeneralDisplaySettingsPageState();
}

class _GeneralDisplaySettingsPageState extends State<GeneralDisplaySettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.generalDisplaySettings)),
          body: ListView(
            children: [
              SwitchListTile(
                title: Text(l10n.closePopupOnOutsideTap),
                value: provider.closeCoursePopupOnOutsideTap,
                onChanged: provider.updateCloseCoursePopupOnOutsideTap,
              ),
              SwitchListTile(
                title: Text(l10n.showGridLines),
                value: provider.showTimetableGridLines,
                onChanged: provider.updateShowTimetableGridLines,
              ),
            ],
          ),
        );
      },
    );
  }
}
