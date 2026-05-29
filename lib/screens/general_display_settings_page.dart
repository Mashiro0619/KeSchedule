import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_locale.dart' as app_locale;
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
        final localeCode = app_locale.normalizeLocaleCode(provider.localeCode);
        return Scaffold(
          appBar: AppBar(title: Text(l10n.generalDisplaySettings)),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: generalViewWeek,
                      icon: const Icon(Icons.view_week_outlined),
                      label: Text(l10n.viewWeek),
                    ),
                    ButtonSegment(
                      value: generalViewDay,
                      icon: const Icon(Icons.view_day_outlined),
                      label: Text(l10n.viewDay),
                    ),
                    ButtonSegment(
                      value: generalViewList,
                      icon: const Icon(Icons.list_alt_outlined),
                      label: Text(l10n.viewList),
                    ),
                    ButtonSegment(
                      value: generalViewMonth,
                      icon: const Icon(Icons.calendar_view_month_outlined),
                      label: Text(l10n.viewMonth),
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
                title: Text(l10n.showWeekends),
                value: provider.generalShowWeekends,
                onChanged: (value) =>
                    provider.updateGeneralDisplaySettings(showWeekends: value),
              ),
              if (localeCode == 'zh' || localeCode == 'zh-Hant')
                SwitchListTile(
                  title: Text(l10n.showLunarCalendar),
                  value: provider.generalShowLunarCalendar,
                  onChanged: (value) => provider.updateGeneralDisplaySettings(
                    showLunarCalendar: value,
                  ),
                ),
              _HourTile(
                title: l10n.startHour,
                value: provider.generalDayStartHour,
                min: 0,
                max: provider.generalDayEndHour - 1,
                onChanged: (value) =>
                    provider.updateGeneralDisplaySettings(dayStartHour: value),
              ),
              _HourTile(
                title: l10n.endHour,
                value: provider.generalDayEndHour,
                min: provider.generalDayStartHour + 1,
                max: 24,
                onChanged: (value) =>
                    provider.updateGeneralDisplaySettings(dayEndHour: value),
              ),
              ListTile(
                leading: const Icon(Icons.grid_4x4_outlined),
                title: Text(l10n.timeGridDensity),
                trailing: DropdownButton<int>(
                  value: provider.generalTimeGridMinutes,
                  items: [
                    DropdownMenuItem(
                      value: 15,
                      child: Text(l10n.timeGridMinutes(15)),
                    ),
                    DropdownMenuItem(
                      value: 30,
                      child: Text(l10n.timeGridMinutes(30)),
                    ),
                    DropdownMenuItem(
                      value: 60,
                      child: Text(l10n.timeGridMinutes(60)),
                    ),
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
                title: Text(l10n.closePopupOnOutsideTap),
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
