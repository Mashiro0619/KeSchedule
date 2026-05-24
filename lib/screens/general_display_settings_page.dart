import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';

class GeneralDisplaySettingsPage extends StatelessWidget {
  const GeneralDisplaySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.generalDisplaySettings)),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: generalViewWeek,
                      icon: Icon(Icons.view_week_outlined),
                      label: Text('Week'),
                    ),
                    ButtonSegment(
                      value: generalViewDay,
                      icon: Icon(Icons.view_day_outlined),
                      label: Text('Day'),
                    ),
                    ButtonSegment(
                      value: generalViewList,
                      icon: Icon(Icons.list_alt_outlined),
                      label: Text('List'),
                    ),
                  ],
                  selected: {provider.generalDefaultView},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) {
                    provider.updateGeneralDisplaySettings(
                      defaultView: selection.first,
                    );
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Show weekends'),
                value: provider.generalShowWeekends,
                onChanged: (value) =>
                    provider.updateGeneralDisplaySettings(showWeekends: value),
              ),
              _HourTile(
                title: 'Start hour',
                value: provider.generalDayStartHour,
                min: 0,
                max: provider.generalDayEndHour - 1,
                onChanged: (value) =>
                    provider.updateGeneralDisplaySettings(dayStartHour: value),
              ),
              _HourTile(
                title: 'End hour',
                value: provider.generalDayEndHour,
                min: provider.generalDayStartHour + 1,
                max: 24,
                onChanged: (value) =>
                    provider.updateGeneralDisplaySettings(dayEndHour: value),
              ),
              ListTile(
                leading: const Icon(Icons.grid_4x4_outlined),
                title: const Text('Time grid density'),
                trailing: DropdownButton<int>(
                  value: provider.generalTimeGridMinutes,
                  items: const [
                    DropdownMenuItem(value: 15, child: Text('15 min')),
                    DropdownMenuItem(value: 30, child: Text('30 min')),
                    DropdownMenuItem(value: 60, child: Text('60 min')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateGeneralDisplaySettings(
                        timeGridMinutes: value,
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 24),
              SwitchListTile(
                title: const Text('Close popup on outside tap'),
                value: provider.closeGeneralEventPopupOnOutsideTap,
                onChanged: (value) => provider.updateGeneralDisplaySettings(
                  closeEventPopupOnOutsideTap: value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HourTile extends StatelessWidget {
  const _HourTile({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(min, max).toInt();
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(title),
      subtitle: Slider(
        value: safeValue.toDouble(),
        min: min.toDouble(),
        max: max.toDouble(),
        divisions: (max - min).clamp(1, 24).toInt(),
        label: '${safeValue.toString().padLeft(2, '0')}:00',
        onChanged: (value) => onChanged(value.round()),
      ),
      trailing: Text('${safeValue.toString().padLeft(2, '0')}:00'),
    );
  }
}
