part of 'home_screen.dart';

extension _HomeScreenTimetableManagement on _HomeScreenState {
  Future<void> _showWeekPicker(
    BuildContext context,
    TimetableProvider provider,
    int totalWeeks,
    int realCurrentWeek,
  ) async {
    final week = await showDialog<int>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final mediaQuery = MediaQuery.of(context);
        final dialogWidth = math.min(mediaQuery.size.width - 32, 360.0);
        const spacing = 10.0;
        const chipHeight = 40.0;
        final maxGridHeight = mediaQuery.size.height * 0.5;
        var popped = false;
        void popWith(int value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }
        return AlertDialog(
          title: Text(AppLocalizations.of(context).jumpToWeek),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: SizedBox(
            width: dialogWidth,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final crossAxisCount = availableWidth >= 280 ? 4 : 3;
                final chipWidth =
                    (availableWidth - ((crossAxisCount - 1) * spacing)) /
                    crossAxisCount;
                final rowCount = (totalWeeks / crossAxisCount).ceil();
                final fullGridHeight =
                    (rowCount * chipHeight) + ((rowCount - 1) * spacing);
                final visibleRows = math.max(
                  1,
                  math.min(
                    rowCount,
                    ((maxGridHeight + spacing) / (chipHeight + spacing))
                        .floor(),
                  ),
                );
                final gridHeight = rowCount <= visibleRows
                    ? fullGridHeight
                    : (visibleRows * chipHeight) +
                          ((visibleRows - 1) * spacing);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: gridHeight),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (var index = 0; index < totalWeeks; index++)
                          Builder(
                            builder: (context) {
                              final weekNumber = index + 1;
                              final isSelected =
                                  weekNumber == provider.selectedWeek;
                              final isRealCurrentWeek =
                                  weekNumber == realCurrentWeek;
                              final backgroundColor = isSelected
                                  ? theme.colorScheme.secondaryContainer
                                  : isRealCurrentWeek
                                  ? theme.colorScheme.surfaceContainerHighest
                                  : theme.colorScheme.surface;
                              return SizedBox(
                                width: chipWidth,
                                height: chipHeight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => popWith(weekNumber),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.secondary
                                              : theme
                                                    .colorScheme
                                                    .outlineVariant,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$weekNumber',
                                          style: theme.textTheme.titleMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (week != null) {
      await _animateToWeek(provider, week);
    }
  }

  Future<void> _openTimetableItemDialog(
    BuildContext context,
    TimetableProvider provider,
    TimetableData timetable,
  ) async {
    final nameController = TextEditingController(text: timetable.config.name);
    final weeksController = TextEditingController(
      text: timetable.config.totalWeeks.toString(),
    );
    var selectedStartDate = timetable.config.startDate;
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final viewInsets = MediaQuery.of(context).viewInsets;
        var popped = false;
        void popWith(String? value) {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop(value);
        }
        String formatDate(DateTime date) {
          final year = date.year.toString().padLeft(4, '0');
          final month = date.month.toString().padLeft(2, '0');
          final day = date.day.toString().padLeft(2, '0');
          return '$year-$month-$day';
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(24, 24, 24, viewInsets.bottom + 24),
              child: Center(
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(28),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n.timetable,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: l10n.timetableName,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: weeksController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TextInputFormatter.withFunction((
                                      oldValue,
                                      newValue,
                                    ) {
                                      final text = newValue.text;
                                      if (text.isEmpty) {
                                        return newValue;
                                      }
                                      final value = int.tryParse(text);
                                      if (value == null) {
                                        return oldValue;
                                      }
                                      final clamped = normalizeTimetableWeeks(
                                        value,
                                      );
                                      if (clamped == value) {
                                        return newValue;
                                      }
                                      final clampedText = clamped.toString();
                                      return TextEditingValue(
                                        text: clampedText,
                                        selection: TextSelection.collapsed(
                                          offset: clampedText.length,
                                        ),
                                      );
                                    }),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: l10n.totalWeeks,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            leading: const Icon(Icons.calendar_month_outlined),
                            title: Text(l10n.semesterStartDate),
                            subtitle: Text(formatDate(selectedStartDate)),
                            trailing: const Icon(Icons.calendar_month),
                            onTap: () async {
                              final firstDate = DateTime(2020);
                              final lastDate = DateTime(2035);
                              final boundedInitialDate =
                                  selectedStartDate.isBefore(firstDate)
                                  ? firstDate
                                  : selectedStartDate.isAfter(lastDate)
                                  ? lastDate
                                  : selectedStartDate;
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: firstDate,
                                lastDate: lastDate,
                                initialDate: boundedInitialDate,
                              );
                              if (!context.mounted ||
                                  picked == null ||
                                  picked == selectedStartDate) {
                                return;
                              }
                              setDialogState(() => selectedStartDate = picked);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () => popWith('delete'),
                                  child: Text(l10n.delete),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => popWith(null),
                                  child: Text(l10n.cancel),
                                ),
                                const SizedBox(width: 8),
                                FilledButton(
                                  onPressed: () => popWith('save'),
                                  child: Text(l10n.save),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    if (result == 'save') {
      final totalWeeks = normalizeTimetableWeeks(
        int.tryParse(weeksController.text) ?? timetable.config.totalWeeks,
      );
      weeksController.value = TextEditingValue(
        text: totalWeeks.toString(),
        selection: TextSelection.collapsed(
          offset: totalWeeks.toString().length,
        ),
      );
      await provider.updateTimetableConfigFor(
        timetable.id,
        timetable.config.copyWith(
          name: nameController.text.trim().isEmpty
              ? timetable.config.name
              : nameController.text.trim(),
          startDate: selectedStartDate,
          totalWeeks: totalWeeks,
        ),
      );
    }
    if (result == 'delete') {
      if (!mounted) {
        nameController.dispose();
        weeksController.dispose();
        return;
      }
      final confirmed = await showDialog<bool>(
        context: this.context,
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          var popped = false;
          void popWith(bool value) {
            if (popped) return;
            popped = true;
            Navigator.of(context).pop(value);
          }
          return AlertDialog(
            title: Text(l10n.deleteTimetableTitle),
            content: Text(l10n.deleteTimetableMessage(timetable.config.name)),
            actions: [
              TextButton(
                onPressed: () => popWith(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => popWith(true),
                child: Text(l10n.delete),
              ),
            ],
          );
        },
      );
      if (confirmed == true) {
        await provider.deleteTimetable(timetable.id);
      }
    }
    nameController.dispose();
    weeksController.dispose();
  }
}
