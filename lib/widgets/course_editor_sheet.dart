import 'package:flutter/material.dart';

import '../l10n/app_locale.dart' as app_locale;
import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';

/// delete 单独保留成一个标记，避免和“只是点了取消”共用同一种空值语义。
class CourseEditorResult {
  const CourseEditorResult.save(this.course) : delete = false;
  const CourseEditorResult.delete() : course = null, delete = true;

  final CourseItem? course;
  final bool delete;
}

/// 周次选择单独放二级弹窗，不然编辑页一长起来，在手机上会很挤。
class CourseEditorSheet extends StatefulWidget {
  const CourseEditorSheet({
    super.key,
    required this.periodTimes,
    required this.totalWeeks,
    required this.dayOfWeek,
    this.initialCourse,
    this.initialStartMinutes,
    this.initialEndMinutes,
    this.initialPeriods,
  });

  final List<CoursePeriodTime> periodTimes;
  final int totalWeeks;
  final int dayOfWeek;
  final CourseItem? initialCourse;
  final int? initialStartMinutes;
  final int? initialEndMinutes;
  final List<int>? initialPeriods;

  @override
  State<CourseEditorSheet> createState() => _CourseEditorSheetState();
}

class _CourseEditorSheetState extends State<CourseEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _teacherController;
  late final TextEditingController _locationController;
  late final TextEditingController _creditController;
  late final TextEditingController _remarksController;
  late final TextEditingController _customFieldsController;

  late int _selectedDayOfWeek;
  late List<int> _selectedSemesterWeeks;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late List<int> _selectedPeriods;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialCourse;
    final defaultStartMinutes =
        widget.initialStartMinutes ??
        (widget.periodTimes.isNotEmpty
            ? widget.periodTimes.first.startMinutes
            : 8 * 60);
    final defaultEndMinutes =
        widget.initialEndMinutes ??
        (widget.periodTimes.length > 1
            ? widget.periodTimes[1].endMinutes
            : widget.periodTimes.isNotEmpty
            ? widget.periodTimes.first.endMinutes
            : (8 * 60) + 45);

    _nameController = TextEditingController(text: initial?.name ?? '');
    _teacherController = TextEditingController(text: initial?.teacher ?? '');
    _locationController = TextEditingController(text: initial?.location ?? '');
    _creditController = TextEditingController(
      text: initial == null || initial.credit == 0
          ? ''
          : initial.credit.toString(),
    );
    _remarksController = TextEditingController(text: initial?.remarks ?? '');
    _customFieldsController = TextEditingController(
      text: initial == null
          ? ''
          : initial.customFields.entries
                .map((entry) => '${entry.key}:${entry.value}')
                .join('\n'),
    );
    _selectedDayOfWeek = initial?.dayOfWeek ?? widget.dayOfWeek;
    _selectedSemesterWeeks = normalizeSemesterWeeks(
      initial?.semesterWeeks ?? buildAllSemesterWeeks(widget.totalWeeks),
    );
    _startTime = _timeOfDayFromMinutes(
      initial?.startMinutes ?? defaultStartMinutes,
    );
    _endTime = _timeOfDayFromMinutes(initial?.endMinutes ?? defaultEndMinutes);
    _selectedPeriods = _normalizeSelectedPeriods(
      initial?.periods.isNotEmpty == true
          ? initial!.periods
          : widget.initialPeriods != null
          ? widget.initialPeriods!
          : matchPeriodsForTimeRange(
              widget.periodTimes,
              initial?.startMinutes ?? defaultStartMinutes,
              initial?.endMinutes ?? defaultEndMinutes,
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    _locationController.dispose();
    _creditController.dispose();
    _remarksController.dispose();
    _customFieldsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final linkedPeriods = _selectedPeriods;
    final linkedPeriodsLabel = _formatPeriodsLabel(linkedPeriods, l10n);

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.66,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.initialCourse == null
                            ? l10n.addCourseTitle
                            : l10n.editCourseTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: l10n.courseName),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(labelText: l10n.location),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.dayOfWeek),
                              subtitle: Text(
                                formatDayOfWeekLabel(
                                  _selectedDayOfWeek,
                                  localeCode: app_locale.localeCodeFromLocale(
                                    Localizations.localeOf(context),
                                  ),
                                ),
                              ),
                              trailing: const Icon(Icons.today_outlined),
                              onTap: _pickDayOfWeek,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.semesterWeeks),
                              subtitle: Text(
                                formatSemesterWeeksLabel(
                                  _selectedSemesterWeeks,
                                  totalWeeks: widget.totalWeeks,
                                  localeCode: app_locale.localeCodeFromLocale(
                                    Localizations.localeOf(context),
                                  ),
                                ),
                              ),
                              trailing: const Icon(Icons.edit_calendar),
                              onTap: _pickSemesterWeeks,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.startTime),
                              subtitle: Text(_formatTimeOfDay(_startTime)),
                              trailing: const Icon(Icons.schedule),
                              onTap: () => _pickTime(isStart: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.endTime),
                              subtitle: Text(_formatTimeOfDay(_endTime)),
                              trailing: const Icon(Icons.schedule),
                              onTap: () => _pickTime(isStart: false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.linkedPeriods),
                        subtitle: Text(
                          linkedPeriods.isEmpty
                              ? l10n.linkedPeriodsUnmatched
                              : linkedPeriodsLabel,
                        ),
                        trailing: const Icon(Icons.tune),
                        onTap: _pickPeriods,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _teacherController,
                              decoration: InputDecoration(
                                labelText: l10n.teacherName,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _creditController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l10n.credits,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _remarksController,
                        decoration: InputDecoration(labelText: l10n.remarks),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customFieldsController,
                        decoration: InputDecoration(
                          labelText: l10n.customFields,
                          hintText: l10n.customFieldsHint,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (widget.initialCourse != null)
                    TextButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(const CourseEditorResult.delete()),
                      child: Text(l10n.delete),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _submit, child: Text(l10n.save)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<int> get _matchedPeriods => matchPeriodsForTimeRange(
    widget.periodTimes,
    _minutesFromTimeOfDay(_startTime),
    _minutesFromTimeOfDay(_endTime),
  );

  void _dismissActiveInputFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _pickDayOfWeek() async {
    _dismissActiveInputFocus();
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).selectDayOfWeek),
          content: SizedBox(
            width: 320,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final day = index + 1;
                return ChoiceChip(
                  label: Text(
                    formatDayOfWeekLabel(
                      day,
                      localeCode: app_locale.localeCodeFromLocale(
                        Localizations.localeOf(context),
                      ),
                    ),
                  ),
                  selected: day == _selectedDayOfWeek,
                  onSelected: (_) => Navigator.of(context).pop(day),
                );
              }),
            ),
          ),
        );
      },
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() => _selectedDayOfWeek = result);
  }

  Future<void> _pickSemesterWeeks() async {
    _dismissActiveInputFocus();
    final draft = {..._selectedSemesterWeeks};
    final result = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = AppLocalizations.of(context);
            return AlertDialog(
              title: Text(l10n.selectSemesterWeeks),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => setState(() {
                              draft
                                ..clear()
                                ..addAll(
                                  buildAllSemesterWeeks(widget.totalWeeks),
                                );
                            }),
                            child: Text(l10n.selectAll),
                          ),
                          TextButton(
                            onPressed: () => setState(() => draft.clear()),
                            child: Text(l10n.clear),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: widget.totalWeeks,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.6,
                            ),
                        itemBuilder: (context, index) {
                          final week = index + 1;
                          final selected = draft.contains(week);
                          final colorScheme = Theme.of(context).colorScheme;
                          return Material(
                            color: selected
                                ? colorScheme.primaryContainer
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  if (selected) {
                                    draft.remove(week);
                                  } else {
                                    draft.add(week);
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                  '$week',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: selected
                                            ? colorScheme.onSecondaryContainer
                                            : colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(normalizeSemesterWeeks(draft.toList())),
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      _selectedSemesterWeeks = result.isEmpty
          ? buildAllSemesterWeeks(widget.totalWeeks)
          : result;
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    _dismissActiveInputFocus();
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
      _selectedPeriods = _matchedPeriods;
    });
  }

  Future<void> _pickPeriods() async {
    _dismissActiveInputFocus();
    final draft = List<int>.from(_selectedPeriods);
    final result = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = AppLocalizations.of(context);
            return AlertDialog(
              title: Text(l10n.selectLinkedPeriods),
              content: SizedBox(
                width: 360,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final period in widget.periodTimes)
                      ChoiceChip(
                        label: Text(l10n.periodNumberLabel(period.index)),
                        selected: draft.contains(period.index),
                        onSelected: (_) {
                          setState(() {
                            final next = _togglePeriodSelection(
                              draft,
                              period.index,
                            );
                            draft
                              ..clear()
                              ..addAll(next);
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => setState(draft.clear),
                  child: Text(l10n.clear),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pop(List<int>.from(draft)),
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      _selectedPeriods = _normalizeSelectedPeriods(result);
      if (_selectedPeriods.isNotEmpty) {
        final selectedTimes =
            widget.periodTimes
                .where((item) => _selectedPeriods.contains(item.index))
                .toList()
              ..sort((a, b) => a.index.compareTo(b.index));
        if (selectedTimes.isNotEmpty) {
          _startTime = _timeOfDayFromMinutes(selectedTimes.first.startMinutes);
          _endTime = _timeOfDayFromMinutes(selectedTimes.last.endMinutes);
        }
      }
    });
  }

  void _submit() {
    final startMinutes = _minutesFromTimeOfDay(_startTime);
    final endMinutes = _minutesFromTimeOfDay(_endTime);
    if (_nameController.text.trim().isEmpty || startMinutes >= endMinutes) {
      return;
    }

    final periods = _normalizeSelectedPeriods(
      _selectedPeriods.isEmpty ? _matchedPeriods : _selectedPeriods,
    );
    final course = CourseItem(
      id:
          widget.initialCourse?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      teacher: _teacherController.text.trim(),
      location: _locationController.text.trim(),
      dayOfWeek: _selectedDayOfWeek,
      semesterWeeks: normalizeSemesterWeeks(_selectedSemesterWeeks),
      periods: periods,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      timeRange: buildTimeRange(startMinutes, endMinutes),
      credit: _parseCredit(_creditController.text),
      remarks: _remarksController.text.trim(),
      customFields: _parseCustomFields(_customFieldsController.text),
    );
    Navigator.of(context).pop(CourseEditorResult.save(course));
  }

  List<int> _togglePeriodSelection(List<int> current, int periodIndex) {
    final next = <int>{...current};
    if (next.contains(periodIndex)) {
      next.remove(periodIndex);
    } else {
      next.add(periodIndex);
    }
    if (next.isEmpty) {
      return const [];
    }
    final sorted = next.toList()..sort();
    final contiguous = <int>[];
    for (var i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i] != sorted[i - 1] + 1) {
        return [periodIndex];
      }
      contiguous.add(sorted[i]);
    }
    return contiguous;
  }

  List<int> _normalizeSelectedPeriods(Iterable<int> periods) {
    final validIndices = widget.periodTimes.map((item) => item.index).toSet();
    final normalized =
        periods
            .where((period) => period > 0)
            .where(
              (period) => validIndices.isEmpty || validIndices.contains(period),
            )
            .toSet()
            .toList()
          ..sort();
    return normalized;
  }

  double _parseCredit(String value) {
    final parsed = double.tryParse(value.trim());
    return parsed == null || !parsed.isFinite ? 0 : parsed;
  }

  TimeOfDay _timeOfDayFromMinutes(int minutes) {
    final normalized = normalizeMinuteOfDay(minutes);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  int _minutesFromTimeOfDay(TimeOfDay time) => (time.hour * 60) + time.minute;

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatPeriodsLabel(List<int> periods, AppLocalizations l10n) {
    if (periods.isEmpty) {
      return '';
    }
    final sorted = [...periods]..sort();
    if (sorted.first == sorted.last) {
      return l10n.periodNumberLabel(sorted.first);
    }
    return l10n.periodRangeLabel(sorted.first, sorted.last);
  }

  Map<String, dynamic> _parseCustomFields(String value) {
    final result = <String, dynamic>{};
    for (final line in value.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final separator = trimmed.indexOf(':');
      if (separator <= 0) {
        result[trimmed] = '';
        continue;
      }
      final key = trimmed.substring(0, separator).trim();
      final content = trimmed.substring(separator + 1).trim();
      result[key] = content;
    }
    return result;
  }
}
