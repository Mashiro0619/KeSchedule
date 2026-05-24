part of 'general_schedule_home_screen.dart';

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.controller,
    required this.colorValue,
    required this.colorOptions,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onColorChanged,
  });

  final TextEditingController controller;
  final int? colorValue;
  final List<int> colorOptions;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<int?> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                hintText: l10n.searchEvents,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.clearSearch,
                        onPressed: onClearSearch,
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<int>(
            tooltip: l10n.filterByColor,
            icon: Icon(
              colorValue == null ? Icons.filter_alt_outlined : Icons.filter_alt,
            ),
            onSelected: (value) => onColorChanged(value < 0 ? null : value),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: -1, child: Text(l10n.allColors)),
              for (final option in colorOptions)
                PopupMenuItem<int>(
                  value: option,
                  child: Row(
                    children: [
                      _ColorDot(color: Color(option)),
                      const SizedBox(width: 10),
                      Text(
                        '#${option.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GeneralOccurrenceFilter {
  const _GeneralOccurrenceFilter({
    required this.query,
    required this.colorValue,
  });

  final String query;
  final int? colorValue;

  bool get isActive => query.trim().isNotEmpty || colorValue != null;

  GeneralOccurrenceQuery toQuery({
    required DateTime startInclusive,
    required DateTime endExclusive,
    bool onlyVisibleCalendars = true,
  }) {
    return GeneralOccurrenceQuery(
      startInclusive: startInclusive,
      endExclusive: endExclusive,
      onlyVisibleCalendars: onlyVisibleCalendars,
      searchQuery: query,
      colorValue: colorValue,
    );
  }

  bool matches(GeneralEventOccurrence occurrence) {
    return toQuery(
      startInclusive: occurrence.start,
      endExclusive: occurrence.end,
    ).matches(occurrence);
  }
}
