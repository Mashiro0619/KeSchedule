import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';

class GeneralEventEditorResult {
  const GeneralEventEditorResult({this.event, this.delete = false});
  final GeneralEvent? event;
  final bool delete;
}

class GeneralEventEditorSheet extends StatefulWidget {
  const GeneralEventEditorSheet({
    super.key,
    this.initialEvent,
    this.initialDate,
    this.calendars = const [],
    this.activeCalendarId,
  });

  final GeneralEvent? initialEvent;
  final DateTime? initialDate;
  final List<GeneralSchedule> calendars;
  final String? activeCalendarId;

  @override
  State<GeneralEventEditorSheet> createState() =>
      _GeneralEventEditorSheetState();
}

class _GeneralEventEditorSheetState extends State<GeneralEventEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;
  late final TextEditingController _repeatCountController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _isAllDay;
  late String _calendarId;
  late GeneralEventRecurrence _recurrence;
  late GeneralEventRecurrenceUnit _customUnit;
  late int _interval;
  DateTime? _untilDate;
  int? _repeatCount;
  int? _colorValue;
  late List<int> _reminders;
  late List<GeneralSchedule> _calendarOptions;

  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.initialEvent != null;

  @override
  void initState() {
    super.initState();
    _calendarOptions = _buildCalendarOptions();
    final event = widget.initialEvent;
    final initial = widget.initialDate ?? DateTime.now();
    final startDt = event != null
        ? tryParseStrictIsoDateTime(event.startDateTimeIso) ?? initial
        : DateTime(
            initial.year,
            initial.month,
            initial.day,
            initial.hour,
            initial.minute,
          );
    final endDt = event != null
        ? tryParseStrictIsoDateTime(event.endDateTimeIso) ??
              startDt.add(const Duration(hours: 1))
        : startDt.add(const Duration(hours: 1));
    var displayEndDt = event?.isAllDay == true
        ? endDt.subtract(const Duration(days: 1))
        : endDt;
    if (displayEndDt.isBefore(startDt)) {
      displayEndDt = startDt;
    }
    final rule = event?.recurrenceRule ?? const GeneralEventRecurrenceRule();

    _titleController = TextEditingController(text: event?.title ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    _notesController = TextEditingController(text: event?.notes ?? '');
    _repeatCount = rule.count;
    _repeatCountController = TextEditingController(
      text: _repeatCount == null ? '' : _repeatCount.toString(),
    );
    _startDate = normalizeDateOnly(startDt);
    _endDate = normalizeDateOnly(displayEndDt);
    _startTime = TimeOfDay(hour: startDt.hour, minute: startDt.minute);
    _endTime = TimeOfDay(hour: endDt.hour, minute: endDt.minute);
    _isAllDay = event?.isAllDay ?? false;
    _calendarId = _resolveCalendarId(event?.calendarId);
    _recurrence = rule.type;
    _customUnit = rule.unit;
    _interval = rule.normalizedInterval;
    _untilDate = rule.untilDateIso == null
        ? null
        : tryParseStrictIsoDate(rule.untilDateIso!);
    _colorValue = event?.colorValue;
    _reminders =
        event?.reminders.map((item) => item.minutesBefore).toList() ?? const [];
  }

  @override
  void didUpdateWidget(covariant GeneralEventEditorSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendars == widget.calendars &&
        oldWidget.activeCalendarId == widget.activeCalendarId) {
      return;
    }
    _calendarOptions = _buildCalendarOptions();
    if (!_calendarOptions.any((calendar) => calendar.id == _calendarId)) {
      _calendarId = _resolveCalendarId(widget.initialEvent?.calendarId);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _repeatCountController.dispose();
    super.dispose();
  }

  List<GeneralSchedule> _buildCalendarOptions() {
    if (widget.calendars.isNotEmpty) {
      return List<GeneralSchedule>.unmodifiable(widget.calendars);
    }
    return [
      createDefaultGeneralSchedule(
        name: 'My calendar',
        colorValue: defaultGeneralCalendarColorValue,
      ),
    ];
  }

  String _resolveCalendarId(String? eventCalendarId) {
    final ids = _calendarOptions.map((item) => item.id).toSet();
    final normalizedEventCalendarId = eventCalendarId?.trim() ?? '';
    if (ids.contains(normalizedEventCalendarId)) {
      return normalizedEventCalendarId;
    }
    final active = widget.activeCalendarId;
    if (active != null && ids.contains(active)) {
      return active;
    }
    return _calendarOptions.first.id;
  }

  DateTime _buildStartDateTime() {
    if (_isAllDay) {
      return normalizeDateOnly(_startDate);
    }
    return DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
  }

  DateTime _buildEndDateTime() {
    if (_isAllDay) {
      var end = normalizeDateOnly(_endDate).add(const Duration(days: 1));
      final start = _buildStartDateTime();
      if (!end.isAfter(start)) {
        end = start.add(const Duration(days: 1));
      }
      return end;
    }
    var end = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );
    final start = _buildStartDateTime();
    if (!end.isAfter(start)) {
      end = start.add(const Duration(hours: 1));
    }
    return end;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final startDt = _buildStartDateTime();
    final endDt = _buildEndDateTime();
    final now = DateTime.now().toIso8601String();
    final repeatCount = int.tryParse(_repeatCountController.text.trim());
    final rule = _buildRecurrenceRule(repeatCount);
    final event = GeneralEvent(
      id: widget.initialEvent?.id ?? _generateId(),
      calendarId: _calendarId,
      title: _titleController.text.trim(),
      startDateTimeIso: startDt.toIso8601String(),
      endDateTimeIso: endDt.toIso8601String(),
      isAllDay: _isAllDay,
      recurrenceRule: rule,
      recurrenceExceptionDateIso:
          widget.initialEvent?.recurrenceExceptionDateIso ?? const [],
      location: _locationController.text.trim(),
      notes: _notesController.text.trim(),
      colorValue: _colorValue,
      reminders: [
        for (final minutes in _reminders.toSet().toList()..sort())
          GeneralEventReminder(minutesBefore: minutes),
      ],
      createdAtIso: widget.initialEvent?.createdAtIso ?? now,
      updatedAtIso: now,
    );
    Navigator.of(context).pop(GeneralEventEditorResult(event: event));
  }

  GeneralEventRecurrenceRule _buildRecurrenceRule(int? repeatCount) {
    if (_recurrence == GeneralEventRecurrence.none) {
      return const GeneralEventRecurrenceRule();
    }
    return GeneralEventRecurrenceRule(
      type: _recurrence,
      interval: _recurrence == GeneralEventRecurrence.custom ? _interval : 1,
      unit: switch (_recurrence) {
        GeneralEventRecurrence.daily => GeneralEventRecurrenceUnit.day,
        GeneralEventRecurrence.weekly => GeneralEventRecurrenceUnit.week,
        GeneralEventRecurrence.monthly => GeneralEventRecurrenceUnit.month,
        GeneralEventRecurrence.custom => _customUnit,
        GeneralEventRecurrence.none => _customUnit,
      },
      untilDateIso: _untilDate == null
          ? null
          : normalizeDateOnly(_untilDate!).toIso8601String().split('T').first,
      count: repeatCount == null || repeatCount < 1 ? null : repeatCount,
    );
  }

  String _generateId() => 'evt_${DateTime.now().microsecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isEditing ? l10n.editEvent : l10n.addEvent,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.eventTitle,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.eventTitleRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _calendarId,
                    decoration: InputDecoration(
                      labelText: l10n.calendar,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                    ),
                    items: [
                      for (final calendar in _calendarOptions)
                        DropdownMenuItem(
                          value: calendar.id,
                          child: _CalendarDropdownItem(calendar: calendar),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _calendarId = value);
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.event_available_outlined),
                    title: Text(l10n.allDay),
                    value: _isAllDay,
                    onChanged: (value) => setState(() {
                      _isAllDay = value;
                      if (value && _endDate.isBefore(_startDate)) {
                        _endDate = _startDate;
                      }
                    }),
                  ),
                  _DateTimeRow(
                    icon: Icons.play_arrow_outlined,
                    label: l10n.eventStartTime,
                    date: _startDate,
                    time: _startTime,
                    showTime: !_isAllDay,
                    onPickDate: () async {
                      final picked = await _pickDate(context, _startDate);
                      if (!mounted || picked == null) {
                        return;
                      }
                      setState(() {
                        _startDate = picked;
                        if (_endDate.isBefore(_startDate)) {
                          _endDate = _startDate;
                        }
                      });
                    },
                    onPickTime: () async {
                      final picked = await _pickTime(context, _startTime);
                      if (!mounted || picked == null) {
                        return;
                      }
                      setState(() => _startTime = picked);
                    },
                  ),
                  _DateTimeRow(
                    icon: Icons.stop_outlined,
                    label: l10n.eventEndTime,
                    date: _endDate,
                    time: _endTime,
                    showTime: !_isAllDay,
                    onPickDate: () async {
                      final picked = await _pickDate(context, _endDate);
                      if (!mounted || picked == null) {
                        return;
                      }
                      setState(() => _endDate = picked);
                    },
                    onPickTime: () async {
                      final picked = await _pickTime(context, _endTime);
                      if (!mounted || picked == null) {
                        return;
                      }
                      setState(() => _endTime = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<GeneralEventRecurrence>(
                    initialValue: _recurrence,
                    decoration: InputDecoration(
                      labelText: l10n.eventRecurrence,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.repeat),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: GeneralEventRecurrence.none,
                        child: Text(l10n.recurrenceNone),
                      ),
                      DropdownMenuItem(
                        value: GeneralEventRecurrence.daily,
                        child: Text(l10n.recurrenceDaily),
                      ),
                      DropdownMenuItem(
                        value: GeneralEventRecurrence.weekly,
                        child: Text(l10n.recurrenceWeekly),
                      ),
                      DropdownMenuItem(
                        value: GeneralEventRecurrence.monthly,
                        child: Text(l10n.recurrenceMonthly),
                      ),
                      DropdownMenuItem(
                        value: GeneralEventRecurrence.custom,
                        child: Text(l10n.recurrenceCustom),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _recurrence = value);
                    },
                  ),
                  if (_recurrence != GeneralEventRecurrence.none) ...[
                    const SizedBox(height: 12),
                    _RepeatOptions(
                      recurrence: _recurrence,
                      interval: _interval,
                      customUnit: _customUnit,
                      untilDate: _untilDate,
                      repeatCountController: _repeatCountController,
                      onIntervalChanged: (value) =>
                          setState(() => _interval = value),
                      onUnitChanged: (value) =>
                          setState(() => _customUnit = value),
                      onPickUntil: () async {
                        final picked = await _pickDate(
                          context,
                          _untilDate ??
                              _startDate.add(const Duration(days: 90)),
                        );
                        if (!mounted || picked == null) {
                          return;
                        }
                        setState(() => _untilDate = picked);
                      },
                      onClearUntil: () => setState(() => _untilDate = null),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _ReminderPicker(
                    reminders: _reminders,
                    onChanged: (values) => setState(() => _reminders = values),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: l10n.location,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: l10n.eventNotes,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.notes_outlined),
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.eventColor, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final colorValue in _colorOptions)
                        _ColorOption(
                          colorValue: colorValue,
                          selected: _colorValue == colorValue,
                          onTap: () => setState(() {
                            _colorValue = _colorValue == colorValue
                                ? null
                                : colorValue;
                          }),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding + 16),
            child: Row(
              children: [
                if (_isEditing)
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(const GeneralEventEditorResult(delete: true)),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  const _DateTimeRow({
    required this.icon,
    required this.label,
    required this.date,
    required this.time,
    required this.showTime,
    required this.onPickDate,
    required this.onPickTime,
  });

  final IconData icon;
  final String label;
  final DateTime date;
  final TimeOfDay time;
  final bool showTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(
        showTime ? '${_fmtDate(date)} ${time.format(context)}' : _fmtDate(date),
      ),
      trailing: Wrap(
        children: [
          IconButton(
            tooltip: AppLocalizations.of(context).pickDate,
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_today_outlined),
          ),
          if (showTime)
            IconButton(
              tooltip: AppLocalizations.of(context).pickTime,
              onPressed: onPickTime,
              icon: const Icon(Icons.access_time),
            ),
        ],
      ),
    );
  }
}

class _RepeatOptions extends StatelessWidget {
  const _RepeatOptions({
    required this.recurrence,
    required this.interval,
    required this.customUnit,
    required this.untilDate,
    required this.repeatCountController,
    required this.onIntervalChanged,
    required this.onUnitChanged,
    required this.onPickUntil,
    required this.onClearUntil,
  });

  final GeneralEventRecurrence recurrence;
  final int interval;
  final GeneralEventRecurrenceUnit customUnit;
  final DateTime? untilDate;
  final TextEditingController repeatCountController;
  final ValueChanged<int> onIntervalChanged;
  final ValueChanged<GeneralEventRecurrenceUnit> onUnitChanged;
  final VoidCallback onPickUntil;
  final VoidCallback onClearUntil;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        if (recurrence == GeneralEventRecurrence.custom)
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: interval.clamp(1, 30).toInt(),
                  decoration: InputDecoration(
                    labelText: l10n.recurrenceEvery,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    for (var value = 1; value <= 30; value++)
                      DropdownMenuItem(value: value, child: Text('$value')),
                  ],
                  onChanged: (value) {
                    if (value != null) onIntervalChanged(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<GeneralEventRecurrenceUnit>(
                  initialValue: customUnit,
                  decoration: InputDecoration(
                    labelText: l10n.recurrenceUnit,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: GeneralEventRecurrenceUnit.day,
                      child: Text(l10n.recurrenceDays),
                    ),
                    DropdownMenuItem(
                      value: GeneralEventRecurrenceUnit.week,
                      child: Text(l10n.recurrenceWeeks),
                    ),
                    DropdownMenuItem(
                      value: GeneralEventRecurrenceUnit.month,
                      child: Text(l10n.recurrenceMonths),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onUnitChanged(value);
                  },
                ),
              ),
            ],
          ),
        if (recurrence == GeneralEventRecurrence.custom)
          const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: repeatCountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.recurrenceRepeatCount,
                  hintText: l10n.recurrenceNoLimit,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  final parsed = int.tryParse(text);
                  if (parsed == null || parsed < 1) {
                    return l10n.recurrencePositiveNumber;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickUntil,
                icon: const Icon(Icons.event_repeat_outlined),
                label: Text(
                  untilDate == null
                      ? l10n.recurrenceEndDate
                      : _fmtDate(untilDate!),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (untilDate != null)
              IconButton(
                tooltip: l10n.clearEndDate,
                onPressed: onClearUntil,
                icon: const Icon(Icons.clear),
              ),
          ],
        ),
      ],
    );
  }
}

class _ReminderPicker extends StatelessWidget {
  const _ReminderPicker({required this.reminders, required this.onChanged});

  final List<int> reminders;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: l10n.reminder,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.notifications_outlined),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilterChip(
            label: Text(l10n.none),
            selected: reminders.isEmpty,
            onSelected: (_) => onChanged(const []),
          ),
          for (final option in _reminderOptions)
            FilterChip(
              label: Text(_reminderLabel(option, l10n)),
              selected: reminders.contains(option),
              onSelected: (selected) {
                final next = reminders.toSet();
                if (selected) {
                  next.add(option);
                } else {
                  next.remove(option);
                }
                onChanged(next.toList()..sort());
              },
            ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.colorValue,
    required this.selected,
    required this.onTap,
  });

  final int colorValue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: '#${colorValue.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(colorValue),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? theme.colorScheme.primary : theme.dividerColor,
              width: selected ? 3 : 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDropdownItem extends StatelessWidget {
  const _CalendarDropdownItem({required this.calendar});

  final GeneralSchedule calendar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ColorDot(color: Color(calendar.colorValue)),
        const SizedBox(width: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: Text(
            calendar.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) {
  final firstDate = DateTime(1970);
  final lastDate = DateTime(2100);
  final boundedInitialDate = initialDate.isBefore(firstDate)
      ? firstDate
      : initialDate.isAfter(lastDate)
      ? lastDate
      : initialDate;
  return showDatePicker(
    context: context,
    initialDate: boundedInitialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay initialTime) {
  return showTimePicker(context: context, initialTime: initialTime);
}

String _fmtDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _reminderLabel(int minutes, AppLocalizations l10n) {
  return switch (minutes) {
    0 => l10n.reminderAtStart,
    60 => l10n.reminderHourBefore,
    1440 => l10n.reminderDayBefore,
    _ => l10n.reminderMinutesBefore(minutes),
  };
}

const _reminderOptions = [0, 5, 10, 30, 60, 1440];

const _colorOptions = <int>[
  0xFFE57373,
  0xFFF06292,
  0xFFBA68C8,
  0xFF9575CD,
  0xFF7986CB,
  0xFF64B5F6,
  0xFF4FC3F7,
  0xFF4DD0E1,
  0xFF4DB6AC,
  0xFF81C784,
  0xFFAED581,
  0xFFFFD54F,
  0xFFFFB74D,
  0xFFFF8A65,
  0xFFA1887F,
  0xFF90A4AE,
];
