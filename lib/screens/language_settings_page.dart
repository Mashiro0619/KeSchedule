import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_locale.dart';
import '../l10n/app_localizations.dart';
import '../providers/timetable_provider.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _query = '';
  bool _isSearchVisible = false;
  bool _isSelectingLanguage = false;
  bool _languageSelectionPopped = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context);
        final colorScheme = Theme.of(context).colorScheme;
        final languageOptions = supportedLanguageOptions(l10n);
        final currentCode = normalizeLocaleCode(provider.localeCode);
        final normalizedQuery = _query.trim().toLowerCase();
        final filteredOptions = languageOptions.where((option) {
          if (normalizedQuery.isEmpty) {
            return true;
          }
          return option.nativeName.toLowerCase().contains(normalizedQuery) ||
              option.localizedName.toLowerCase().contains(normalizedQuery) ||
              option.englishName.toLowerCase().contains(normalizedQuery) ||
              option.code.toLowerCase().contains(normalizedQuery);
        }).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.language),
            actions: [
              IconButton(
                tooltip: _isSearchVisible
                    ? MaterialLocalizations.of(context).closeButtonTooltip
                    : MaterialLocalizations.of(context).searchFieldLabel,
                onPressed: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                    if (!_isSearchVisible) {
                      _query = '';
                    }
                  });
                },
                icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_isSearchVisible) ...[
                Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  child: SearchBar(
                    hintText: l10n.language,
                    leading: Icon(
                      Icons.search,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    trailing: _query.isEmpty
                        ? null
                        : [
                            IconButton(
                              tooltip: MaterialLocalizations.of(
                                context,
                              ).clearButtonTooltip,
                              onPressed: () => setState(() => _query = ''),
                              icon: Icon(
                                Icons.close,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                    backgroundColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    overlayColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    shadowColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    surfaceTintColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    shape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    side: const WidgetStatePropertyAll(BorderSide.none),
                    elevation: const WidgetStatePropertyAll(0),
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(color: colorScheme.onSurface),
                    ),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Card.outlined(
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < filteredOptions.length;
                      index++
                    ) ...[
                      _LanguageOptionTile(
                        option: filteredOptions[index],
                        selected: filteredOptions[index].code == currentCode,
                        onTap: _isSelectingLanguage || _languageSelectionPopped
                            ? null
                            : () => _selectLanguage(
                                context,
                                provider,
                                filteredOptions[index].code,
                              ),
                      ),
                      if (index != filteredOptions.length - 1)
                        const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    TimetableProvider provider,
    String localeCode,
  ) async {
    if (_isSelectingLanguage || _languageSelectionPopped) {
      return;
    }
    final normalizedCode = normalizeLocaleCode(localeCode);
    if (normalizedCode == normalizeLocaleCode(provider.localeCode)) {
      return;
    }
    setState(() => _isSelectingLanguage = true);
    var shouldResetSelecting = true;
    try {
      await provider.updateLocaleCode(normalizedCode);
      if (!context.mounted) {
        return;
      }
      shouldResetSelecting = false;
      setState(() {
        _isSelectingLanguage = false;
        _languageSelectionPopped = true;
      });
      Navigator.of(context).pop();
    } finally {
      if (shouldResetSelecting && mounted) {
        setState(() => _isSelectingLanguage = false);
      }
    }
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final AppLanguageOption option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(option.nativeName),
      subtitle: option.localizedName == option.nativeName
          ? null
          : Text(option.localizedName),
      trailing: selected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: onTap,
    );
  }
}
