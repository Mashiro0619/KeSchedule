import 'package:flutter/material.dart';

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
  });

  final GeneralEvent? initialEvent;
  final DateTime? initialDate;

  @override
  State<GeneralEventEditorSheet> createState() =>
      _GeneralEventEditorSheetState();
}

class _GeneralEventEditorSheetState extends State<GeneralEventEditorSheet> {
  late final TextEditingController _titleController;
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late GeneralEventRecurrence _recurrence;
  DateTime? _recurrenceEndDate;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;
  int? _colorValue;

  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.initialEvent != null;

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;
    final startDt = event != null
        ? DateTime.tryParse(event.startDateTimeIso) ?? DateTime.now()
        : widget.initialDate ?? DateTime.now();
    final endDt = event != null
        ? DateTime.tryParse(event.endDateTimeIso) ?? startDt.add(const Duration(hours: 1))
        : startDt.add(const Duration(hours: 1));

    _titleController = TextEditingController(text: event?.title ?? '');
    _date = DateTime(startDt.year, startDt.month, startDt.day);
    _startTime = TimeOfDay(hour: startDt.hour, minute: startDt.minute);
    _endTime = TimeOfDay(hour: endDt.hour, minute: endDt.minute);
    _recurrence = event?.recurrence ?? GeneralEventRecurrence.none;
    _recurrenceEndDate = event?.recurrenceEndDateIso != null
        ? DateTime.tryParse(event!.recurrenceEndDateIso!)
        : null;
    _locationController = TextEditingController(text: event?.location ?? '');
    _notesController = TextEditingController(text: event?.notes ?? '');
    _colorValue = event?.colorValue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime _buildStartDateTime() {
    return DateTime(
      _date.year, _date.month, _date.day,
      _startTime.hour, _startTime.minute,
    );
  }

  DateTime _buildEndDateTime() {
    final raw = DateTime(
      _date.year, _date.month, _date.day,
      _endTime.hour, _endTime.minute,
    );
    if (!raw.isAfter(_buildStartDateTime())) {
      return _buildStartDateTime().add(const Duration(hours: 1));
    }
    return raw;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final startDt = _buildStartDateTime();
    final endDt = _buildEndDateTime();
    final now = DateTime.now().toIso8601String();
    final event = GeneralEvent(
      id: widget.initialEvent?.id ?? _generateId(),
      title: _titleController.text.trim(),
      startDateTimeIso: startDt.toIso8601String(),
      endDateTimeIso: endDt.toIso8601String(),
      recurrence: _recurrence,
      recurrenceEndDateIso:
          _recurrence != GeneralEventRecurrence.none && _recurrenceEndDate != null
              ? _recurrenceEndDate!.toIso8601String().split('T').first
              : null,
      location: _locationController.text.trim(),
      notes: _notesController.text.trim(),
      colorValue: _colorValue,
      createdAtIso: widget.initialEvent?.createdAtIso ?? now,
      updatedAtIso: now,
    );
    Navigator.of(context).pop(GeneralEventEditorResult(event: event));
  }

  String _generateId() {
    return 'evt_${DateTime.now().millisecondsSinceEpoch}';
  }

  static const _colorOptions = <int>[
    0xFFE57373, 0xFFF06292, 0xFFBA68C8, 0xFF9575CD,
    0xFF7986CB, 0xFF64B5F6, 0xFF4FC3F7, 0xFF4DD0E1,
    0xFF4DB6AC, 0xFF81C784, 0xFFAED581, 0xFFFFD54F,
    0xFFFFB74D, 0xFFFF8A65, 0xFFA1887F, 0xFF90A4AE,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),

            // Start time
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('Start time'),
              trailing: Text(_startTime.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (picked != null) setState(() => _startTime = picked);
              },
            ),

            // End time
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('End time'),
              trailing: Text(_endTime.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                );
                if (picked != null) setState(() => _endTime = picked);
              },
            ),

            // Recurrence
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.repeat),
              title: const Text('Repeat'),
              trailing: DropdownButton<GeneralEventRecurrence>(
                value: _recurrence,
                items: const [
                  DropdownMenuItem(
                    value: GeneralEventRecurrence.none,
                    child: Text('Does not repeat'),
                  ),
                  DropdownMenuItem(
                    value: GeneralEventRecurrence.weekly,
                    child: Text('Weekly'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _recurrence = value);
                },
              ),
            ),

            // Recurrence end date
            if (_recurrence != GeneralEventRecurrence.none)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_repeat),
                title: const Text('End date'),
                subtitle: _recurrenceEndDate != null
                    ? Text(
                        '${_recurrenceEndDate!.year}-${_recurrenceEndDate!.month.toString().padLeft(2, '0')}-${_recurrenceEndDate!.day.toString().padLeft(2, '0')}',
                      )
                    : const Text('No end date'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_recurrenceEndDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _recurrenceEndDate = null),
                      ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _recurrenceEndDate ?? _date.add(const Duration(days: 90)),
                          firstDate: _date,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _recurrenceEndDate = picked);
                      },
                      child: Text(_recurrenceEndDate == null ? 'Set' : 'Change'),
                    ),
                  ],
                ),
              ),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Color
            Row(
              children: [
                const Text('Color: '),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _colorOptions.map((colorValue) {
                        final isSelected = _colorValue == colorValue;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _colorValue = isSelected ? null : colorValue;
                          }),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Color(colorValue),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: theme.colorScheme.primary, width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isEditing)
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(
                      const GeneralEventEditorResult(delete: true),
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
