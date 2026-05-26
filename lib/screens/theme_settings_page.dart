import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';

const _themeSeedOptions = <int>[
  0xFF6750A4,
  0xFF5E35B1,
  0xFF3949AB,
  0xFF1E88E5,
  0xFF00897B,
  0xFF2E7D32,
  0xFF7CB342,
  0xFFF9A825,
  0xFFEF6C00,
  0xFFF4511E,
  0xFFD81B60,
  0xFFC2185B,
  0xFF6D4C41,
  0xFF455A64,
  0xFF546E7A,
];

bool _isPresetThemeColor(int colorValue) =>
    _themeSeedOptions.contains(colorValue);

String _formatColorHex(int colorValue) {
  final rgb = colorValue & 0x00FFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

String _formatOutlineWidthNumber(double width) {
  return width.toStringAsFixed(width % 1 == 0 ? 0 : 1);
}

String _formatOutlineWidthValue(BuildContext context, double width) {
  final l10n = AppLocalizations.of(context);
  return '${_formatOutlineWidthNumber(width)} ${l10n.outlineWidthUnit}';
}

String _outlineModeLabel(BuildContext context, String mode) {
  final l10n = AppLocalizations.of(context);
  return switch (mode) {
    liveCourseOutlineModeAllDisplayed =>
      l10n.liveCourseOutlineTargetAllDisplayed,
    _ => l10n.liveCourseOutlineTargetCurrentOrNext,
  };
}

int _derivedOutlineColorValue(int themeSeedColorValue) {
  return deriveLiveCourseOutlineColorFromSeed(
    Color(themeSeedColorValue),
  ).toARGB32();
}

int _effectiveUiColorValue(
  BuildContext context,
  TimetableProvider provider,
  String key,
) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (key) {
    colorfulUiPrimaryKey =>
      provider.colorfulUiColorValues[key] ?? colorScheme.primary.toARGB32(),
    colorfulUiSecondaryKey =>
      provider.colorfulUiColorValues[key] ?? colorScheme.secondary.toARGB32(),
    colorfulUiTertiaryKey =>
      provider.colorfulUiColorValues[key] ?? colorScheme.tertiary.toARGB32(),
    colorfulCourseTextColorKey =>
      provider.colorfulUiColorValues[key] ??
          colorScheme.onSecondaryContainer.toARGB32(),
    _ => provider.colorfulUiColorValues[key] ?? colorScheme.primary.toARGB32(),
  };
}

String _uiColorLabel(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    colorfulUiPrimaryKey => l10n.themeColorPrimary,
    colorfulUiSecondaryKey => l10n.themeColorSecondary,
    colorfulUiTertiaryKey => l10n.themeColorTertiary,
    colorfulCourseTextColorKey => l10n.themeColorCourseText,
    _ => key,
  };
}

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context);
        final hasCustomColor = !_isPresetThemeColor(
          provider.themeSeedColorValue,
        );
        final effectiveOutlineColorValue = provider.liveCourseOutlineFollowTheme
            ? _derivedOutlineColorValue(provider.themeSeedColorValue)
            : provider.liveCourseOutlineColorValue;
        final outlineWidth = provider.liveCourseOutlineWidth;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.theme)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ThemeModeCard(provider: provider),
              const SizedBox(height: 12),
              _ThemeColorSettingsCard(
                provider: provider,
                hasCustomColor: hasCustomColor,
                onPickCustomColor: () =>
                    _openCustomColorDialog(context, provider),
                onPickUiColor: (key) {
                  if (key == colorfulCourseTextColorKey) {
                    _openCourseTextColorDialog(context, provider);
                    return;
                  }
                  _openColorValueDialog(
                    context,
                    title: _uiColorLabel(context, key),
                    previewTitle: l10n.themeColorUiColors,
                    initialColorValue: _effectiveUiColorValue(
                      context,
                      provider,
                      key,
                    ),
                    onApply: (colorValue) =>
                        provider.updateColorfulUiColorValue(key, colorValue),
                  );
                },
                onPickCourseColor: (courseName) => _openColorValueDialog(
                  context,
                  title: courseName,
                  previewTitle: l10n.themeColorCourseColors,
                  initialColorValue:
                      provider.courseNameColorValues[courseName] ??
                      provider.themeSeedColorValue,
                  onApply: (colorValue) => provider.updateCourseNameColorValue(
                    courseName,
                    colorValue,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _OutlineSettingsCard(
                provider: provider,
                effectiveOutlineColorValue: effectiveOutlineColorValue,
                outlineWidth: outlineWidth,
                onTap: () => _openOutlineSettingsDialog(context, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCustomColorDialog(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    var selectedColor = Color(provider.themeSeedColorValue);
    await showDialog<void>(
      context: context,
      builder: (context) {
        var popped = false;
        var busy = false;
        void popOnce() {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop();
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final colorValue = selectedColor.toARGB32();
            return AlertDialog(
              title: Text(l10n.themeCustomColor),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PreviewBanner(
                        title: l10n.themeColor,
                        value: _formatColorHex(colorValue),
                        preview: _ThemeColorPreview(
                          colorValue: colorValue,
                          selected: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card.outlined(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _CompactColorPicker(
                            colorValue: colorValue,
                            onColorChanged: (updatedColorValue) => setState(() {
                              selectedColor = Color(updatedColorValue);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: (busy || popped) ? null : popOnce,
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: (busy || popped)
                      ? null
                      : () async {
                          if (busy || popped) return;
                          setState(() => busy = true);
                          await provider.updateThemeSeedColorValue(colorValue);
                          if (!context.mounted) return;
                          popOnce();
                        },
                  child: Text(l10n.themeApplyCustomColor),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openColorValueDialog(
    BuildContext context, {
    required String title,
    required String previewTitle,
    required int initialColorValue,
    required Future<void> Function(int colorValue) onApply,
  }) async {
    final l10n = AppLocalizations.of(context);
    var selectedColor = Color(initialColorValue);
    await showDialog<void>(
      context: context,
      builder: (context) {
        var popped = false;
        var busy = false;
        void popOnce() {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop();
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final colorValue = selectedColor.toARGB32();
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PreviewBanner(
                        title: previewTitle,
                        value: _formatColorHex(colorValue),
                        preview: _ThemeColorPreview(
                          colorValue: colorValue,
                          selected: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card.outlined(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _CompactColorPicker(
                            colorValue: colorValue,
                            onColorChanged: (updatedColorValue) => setState(() {
                              selectedColor = Color(updatedColorValue);
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: (busy || popped) ? null : popOnce,
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: (busy || popped)
                      ? null
                      : () async {
                          if (busy || popped) return;
                          setState(() => busy = true);
                          await onApply(colorValue);
                          if (!context.mounted) return;
                          popOnce();
                        },
                  child: Text(l10n.themeApplySettings),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openCourseTextColorDialog(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    var mode = provider.colorfulCourseTextColorMode;
    var colorValue = _effectiveUiColorValue(
      context,
      provider,
      colorfulCourseTextColorKey,
    );
    await showDialog<void>(
      context: context,
      builder: (context) {
        var popped = false;
        var busy = false;
        void popOnce() {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop();
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final modeLabel = mode == colorfulCourseTextColorModeCustom
                ? l10n.themeColorCourseTextCustom
                : l10n.themeColorCourseTextAuto;
            return AlertDialog(
              title: Text(l10n.themeColorCourseText),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PreviewBanner(
                        title: l10n.themeColorCourseText,
                        value: mode == colorfulCourseTextColorModeCustom
                            ? '$modeLabel · ${_formatColorHex(colorValue)}'
                            : modeLabel,
                        preview: _ThemeColorPreview(
                          colorValue: colorValue,
                          selected: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card.outlined(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SelectableOptionTile(
                                title: l10n.themeColorCourseTextAuto,
                                selected:
                                    mode == colorfulCourseTextColorModeAuto,
                                onTap: () => setState(() {
                                  mode = colorfulCourseTextColorModeAuto;
                                }),
                              ),
                              const SizedBox(height: 8),
                              _SelectableOptionTile(
                                title: l10n.themeColorCourseTextCustom,
                                selected:
                                    mode == colorfulCourseTextColorModeCustom,
                                onTap: () => setState(() {
                                  mode = colorfulCourseTextColorModeCustom;
                                }),
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeInOut,
                                alignment: Alignment.topCenter,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  switchInCurve: Curves.easeOut,
                                  switchOutCurve: Curves.easeIn,
                                  child:
                                      mode == colorfulCourseTextColorModeCustom
                                      ? Padding(
                                          key: const ValueKey(
                                            'course-text-color-picker',
                                          ),
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                          ),
                                          child: _CompactColorPicker(
                                            colorValue: colorValue,
                                            onColorChanged:
                                                (updatedColorValue) =>
                                                    setState(() {
                                                      colorValue =
                                                          updatedColorValue;
                                                    }),
                                          ),
                                        )
                                      : const SizedBox.shrink(
                                          key: ValueKey(
                                            'course-text-color-auto',
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: (busy || popped) ? null : popOnce,
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: (busy || popped)
                      ? null
                      : () async {
                          if (busy || popped) return;
                          setState(() => busy = true);
                          if (mode == colorfulCourseTextColorModeCustom) {
                            await provider.updateColorfulUiColorValue(
                              colorfulCourseTextColorKey,
                              colorValue,
                            );
                          }
                          await provider.updateColorfulCourseTextColorMode(
                            mode,
                          );
                          if (!context.mounted) return;
                          popOnce();
                        },
                  child: Text(l10n.themeApplySettings),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openOutlineSettingsDialog(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
    final derivedThemeColorValue = _derivedOutlineColorValue(
      provider.themeSeedColorValue,
    );
    var enabled = provider.liveCourseOutlineEnabled;
    var followTheme = provider.liveCourseOutlineFollowTheme;
    var customColorValue = provider.liveCourseOutlineColorValue;
    var customColorInitialized =
        provider.liveCourseOutlineCustomColorInitialized;
    var outlineMode = provider.liveCourseOutlineMode;
    var outlineWidth = provider.liveCourseOutlineWidth;
    await showDialog<void>(
      context: context,
      builder: (context) {
        var popped = false;
        var busy = false;
        void popOnce() {
          if (popped) return;
          popped = true;
          Navigator.of(context).pop();
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final effectiveColorValue = followTheme
                ? derivedThemeColorValue
                : customColorValue;
            return AlertDialog(
              title: Text(l10n.liveCourseOutlineSettings),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PreviewBanner(
                        title: l10n.liveCourseOutlineEffectiveColor,
                        value:
                            '${_formatColorHex(effectiveColorValue)} · ${l10n.liveCourseOutlineWidth} ${_formatOutlineWidthValue(context, outlineWidth)}',
                        preview: _OutlineColorPreview(
                          colorValue: effectiveColorValue,
                          borderWidth: outlineWidth,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card.outlined(
                        margin: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SwitchListTile.adaptive(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              value: enabled,
                              title: Text(l10n.liveCourseOutlineEnabled),
                              onChanged: (value) => setState(() {
                                enabled = value;
                              }),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.4),
                            ),
                            SwitchListTile.adaptive(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              value: followTheme,
                              title: Text(l10n.liveCourseOutlineFollowTheme),
                              onChanged: (value) => setState(() {
                                final initializingCustomColor =
                                    followTheme &&
                                    !value &&
                                    !customColorInitialized;
                                followTheme = value;
                                if (initializingCustomColor) {
                                  customColorValue = derivedThemeColorValue;
                                  customColorInitialized = true;
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card.outlined(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.liveCourseOutlineTarget,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 12),
                              _SelectableOptionTile(
                                title:
                                    l10n.liveCourseOutlineTargetCurrentOrNext,
                                selected:
                                    outlineMode ==
                                    liveCourseOutlineModeCurrentOrNext,
                                onTap: () => setState(() {
                                  outlineMode =
                                      liveCourseOutlineModeCurrentOrNext;
                                }),
                              ),
                              const SizedBox(height: 8),
                              _SelectableOptionTile(
                                title: l10n.liveCourseOutlineTargetAllDisplayed,
                                selected:
                                    outlineMode ==
                                    liveCourseOutlineModeAllDisplayed,
                                onTap: () => setState(() {
                                  outlineMode =
                                      liveCourseOutlineModeAllDisplayed;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card.outlined(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _OutlineWidthSummaryRow(width: outlineWidth),
                              Slider.adaptive(
                                value: outlineWidth,
                                min: minLiveCourseOutlineWidth,
                                max: maxLiveCourseOutlineWidth,
                                divisions: 6,
                                label: _formatOutlineWidthValue(
                                  context,
                                  outlineWidth,
                                ),
                                onChanged: (value) => setState(() {
                                  outlineWidth = value;
                                }),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l10n.liveCourseOutlineCustomColor,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                  ),
                                  _OutlineColorPreview(
                                    colorValue: customColorValue,
                                    borderWidth: outlineWidth,
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 76,
                                    child: Text(
                                      _formatColorHex(customColorValue),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeInOut,
                                alignment: Alignment.topCenter,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  switchInCurve: Curves.easeOut,
                                  switchOutCurve: Curves.easeIn,
                                  child: followTheme
                                      ? const SizedBox.shrink(
                                          key: ValueKey(
                                            'outline-custom-hidden',
                                          ),
                                        )
                                      : Padding(
                                          key: const ValueKey(
                                            'outline-custom-picker',
                                          ),
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                          ),
                                          child: _CompactColorPicker(
                                            colorValue: customColorValue,
                                            onColorChanged: (colorValue) =>
                                                setState(() {
                                                  customColorValue = colorValue;
                                                  customColorInitialized = true;
                                                }),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: (busy || popped) ? null : popOnce,
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: (busy || popped)
                      ? null
                      : () async {
                          if (busy || popped) return;
                          setState(() => busy = true);
                          await provider.updateLiveCourseOutlineSettings(
                            enabled: enabled,
                            followTheme: followTheme,
                            colorValue: customColorValue,
                            customColorInitialized: customColorInitialized,
                            mode: outlineMode,
                            width: outlineWidth,
                          );
                          if (!context.mounted) return;
                          popOnce();
                        },
                  child: Text(l10n.themeApplySettings),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  const _ThemeModeCard({required this.provider});

  final TimetableProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _SelectableOptionTile(
              title: l10n.themeFollowSystem,
              selected: provider.themeMode == 'system',
              onTap: () => provider.updateThemeMode('system'),
            ),
            const SizedBox(height: 8),
            _SelectableOptionTile(
              title: l10n.themeLight,
              selected: provider.themeMode == 'light',
              onTap: () => provider.updateThemeMode('light'),
            ),
            const SizedBox(height: 8),
            _SelectableOptionTile(
              title: l10n.themeDark,
              selected: provider.themeMode == 'dark',
              onTap: () => provider.updateThemeMode('dark'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeColorSettingsCard extends StatelessWidget {
  const _ThemeColorSettingsCard({
    required this.provider,
    required this.hasCustomColor,
    required this.onPickCustomColor,
    required this.onPickUiColor,
    required this.onPickCourseColor,
  });

  final TimetableProvider provider;
  final bool hasCustomColor;
  final VoidCallback onPickCustomColor;
  final ValueChanged<String> onPickUiColor;
  final ValueChanged<String> onPickCourseColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSingleMode = provider.themeColorMode == themeColorModeSingle;
    final courseNames = provider.courseNameColorValues.keys.toList()..sort();
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.themeColor,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _SelectableOptionTile(
              title: l10n.themeColorModeSingle,
              selected: isSingleMode,
              onTap: () => provider.updateThemeColorMode(themeColorModeSingle),
            ),
            const SizedBox(height: 8),
            _SelectableOptionTile(
              title: l10n.themeColorModeColorful,
              selected: !isSingleMode,
              onTap: () =>
                  provider.updateThemeColorMode(themeColorModeColorful),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: isSingleMode
                  ? _SingleThemeColorSection(
                      key: const ValueKey('single-theme-color-section'),
                      provider: provider,
                      hasCustomColor: hasCustomColor,
                      onPickCustomColor: onPickCustomColor,
                    )
                  : _ColorfulThemeSection(
                      key: const ValueKey('colorful-theme-section'),
                      provider: provider,
                      courseNames: courseNames,
                      onPickUiColor: onPickUiColor,
                      onPickCourseColor: onPickCourseColor,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SingleThemeColorSection extends StatelessWidget {
  const _SingleThemeColorSection({
    super.key,
    required this.provider,
    required this.hasCustomColor,
    required this.onPickCustomColor,
  });

  final TimetableProvider provider;
  final bool hasCustomColor;
  final VoidCallback onPickCustomColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PreviewBanner(
          title: l10n.themeColor,
          value: _formatColorHex(provider.themeSeedColorValue),
          preview: _ThemeColorPreview(
            colorValue: provider.themeSeedColorValue,
            selected: true,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final colorValue in _themeSeedOptions)
              _ThemeColorOption(
                colorValue: colorValue,
                selected: provider.themeSeedColorValue == colorValue,
                onTap: () => provider.updateThemeSeedColorValue(colorValue),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _ActionOptionCard(
          onTap: onPickCustomColor,
          selected: hasCustomColor,
          leading: _ThemeColorPreview(
            colorValue: provider.themeSeedColorValue,
            selected: hasCustomColor,
          ),
          title: l10n.themeCustomColor,
          subtitle: hasCustomColor
              ? _formatColorHex(provider.themeSeedColorValue)
              : null,
        ),
      ],
    );
  }
}

class _ColorfulThemeSection extends StatelessWidget {
  const _ColorfulThemeSection({
    super.key,
    required this.provider,
    required this.courseNames,
    required this.onPickUiColor,
    required this.onPickCourseColor,
  });

  final TimetableProvider provider;
  final List<String> courseNames;
  final ValueChanged<String> onPickUiColor;
  final ValueChanged<String> onPickCourseColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ColorSettingsGroup(
          title: AppLocalizations.of(context).themeColorUiColors,
          children: [
            for (final key in const [
              colorfulUiPrimaryKey,
              colorfulUiSecondaryKey,
              colorfulUiTertiaryKey,
              colorfulCourseTextColorKey,
            ])
              _ColorValueTile(
                title: _uiColorLabel(context, key),
                colorValue: _effectiveUiColorValue(context, provider, key),
                onTap: () => onPickUiColor(key),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _ColorSettingsGroup(
          title: AppLocalizations.of(context).themeColorCourseColors,
          children: courseNames.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      AppLocalizations.of(context).themeColorCourseColorsEmpty,
                    ),
                  ),
                ]
              : [
                  for (final courseName in courseNames)
                    _ColorValueTile(
                      title: courseName,
                      colorValue:
                          provider.courseNameColorValues[courseName] ??
                          provider.themeSeedColorValue,
                      onTap: () => onPickCourseColor(courseName),
                    ),
                ],
        ),
      ],
    );
  }
}

class _ColorSettingsGroup extends StatelessWidget {
  const _ColorSettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        const SizedBox(height: 8),
        Card.outlined(
          margin: EdgeInsets.zero,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ],
    );
  }
}

class _ColorValueTile extends StatelessWidget {
  const _ColorValueTile({
    required this.title,
    required this.colorValue,
    required this.onTap,
  });

  final String title;
  final int colorValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(title),
      subtitle: Text(_formatColorHex(colorValue)),
      trailing: _ThemeColorPreview(colorValue: colorValue, selected: false),
      onTap: onTap,
    );
  }
}

class _OutlineSettingsCard extends StatelessWidget {
  const _OutlineSettingsCard({
    required this.provider,
    required this.effectiveOutlineColorValue,
    required this.outlineWidth,
    required this.onTap,
  });

  final TimetableProvider provider;
  final int effectiveOutlineColorValue;
  final double outlineWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.liveCourseOutlineSettings,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.liveCourseOutlineSettingsHint,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _OutlineColorPreview(
                    colorValue: effectiveOutlineColorValue,
                    borderWidth: outlineWidth,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SummaryValueRow(
                label: l10n.liveCourseOutlineEnabled,
                value: Icon(
                  provider.liveCourseOutlineEnabled
                      ? Icons.check_circle_outline
                      : Icons.remove_circle_outline,
                  color: provider.liveCourseOutlineEnabled
                      ? colors.primary
                      : colors.outline,
                ),
              ),
              const SizedBox(height: 10),
              _SummaryValueRow(
                label: l10n.liveCourseOutlineFollowTheme,
                value: Icon(
                  provider.liveCourseOutlineFollowTheme
                      ? Icons.check_circle_outline
                      : Icons.palette_outlined,
                  color: provider.liveCourseOutlineFollowTheme
                      ? colors.primary
                      : colors.outline,
                ),
              ),
              const SizedBox(height: 10),
              _SummaryValueRow(
                label: l10n.liveCourseOutlineTarget,
                value: Text(
                  _outlineModeLabel(context, provider.liveCourseOutlineMode),
                ),
              ),
              const SizedBox(height: 10),
              _SummaryValueRow(
                label: l10n.liveCourseOutlineEffectiveColor,
                value: Text(_formatColorHex(effectiveOutlineColorValue)),
              ),
              const SizedBox(height: 10),
              _SummaryValueRow(
                label: l10n.liveCourseOutlineWidth,
                value: Text(_formatOutlineWidthValue(context, outlineWidth)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectableOptionTile extends StatelessWidget {
  const _SelectableOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colors.secondaryContainer : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (selected)
                Icon(Icons.check, color: colors.onSecondaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeColorOption extends StatelessWidget {
  const _ThemeColorOption({
    required this.colorValue,
    required this.selected,
    required this.onTap,
  });

  final int colorValue;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ThemeColorPreview(
      colorValue: colorValue,
      selected: selected,
      onTap: onTap,
    );
  }
}

class _ThemeColorPreview extends StatelessWidget {
  const _ThemeColorPreview({
    required this.colorValue,
    required this.selected,
    this.onTap,
  });

  final int colorValue;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    final child = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? Theme.of(context).colorScheme.onSurface
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: selected
          ? Icon(
              Icons.check,
              color:
                  ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            )
          : null,
    );
    if (onTap == null) {
      return child;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: child,
    );
  }
}

class _ActionOptionCard extends StatelessWidget {
  const _ActionOptionCard({
    required this.onTap,
    required this.selected,
    required this.leading,
    required this.title,
    this.subtitle,
  });

  final VoidCallback onTap;
  final bool selected;
  final Widget leading;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colors.secondaryContainer : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check : Icons.chevron_right,
                color: selected ? colors.onSecondaryContainer : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner({
    required this.title,
    required this.value,
    required this.preview,
  });

  final String title;
  final String value;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          preview,
        ],
      ),
    );
  }
}

class _SummaryValueRow extends StatelessWidget {
  const _SummaryValueRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(width: 12),
        value,
      ],
    );
  }
}

class _OutlineWidthSummaryRow extends StatelessWidget {
  const _OutlineWidthSummaryRow({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context).liveCourseOutlineWidth,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(_formatOutlineWidthValue(context, width)),
      ],
    );
  }
}

class _OutlineColorPreview extends StatelessWidget {
  const _OutlineColorPreview({
    required this.colorValue,
    required this.borderWidth,
  });

  final int colorValue;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: borderWidth),
      ),
    );
  }
}

class _CompactColorPicker extends StatefulWidget {
  const _CompactColorPicker({
    required this.colorValue,
    required this.onColorChanged,
  });

  final int colorValue;
  final ValueChanged<int> onColorChanged;

  @override
  State<_CompactColorPicker> createState() => _CompactColorPickerState();
}

class _CompactColorPickerState extends State<_CompactColorPicker> {
  static const double _pickerWidth = 300;

  void _updateColor(Color color) {
    widget.onColorChanged(color.toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.colorValue);
    final hsvColor = HSVColor.fromColor(color);
    return SizedBox(
      width: _pickerWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _pickerWidth,
            height: _pickerWidth * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: ColorPickerArea(
                hsvColor,
                (updatedHsvColor) => _updateColor(updatedHsvColor.toColor()),
                PaletteType.hsvWithHue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: _pickerWidth,
            height: 40,
            child: ColorPickerSlider(
              TrackType.hue,
              hsvColor,
              (updatedHsvColor) => _updateColor(updatedHsvColor.toColor()),
              displayThumbColor: true,
            ),
          ),
          ColorPickerInput(
            color,
            (updatedColor) => _updateColor(updatedColor),
            enableAlpha: false,
            embeddedText: false,
          ),
        ],
      ),
    );
  }
}
