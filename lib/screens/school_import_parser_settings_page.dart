import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';
import '../services/school_import_api.dart';

class SchoolImportParserSettingsPage extends StatefulWidget {
  const SchoolImportParserSettingsPage({
    super.key,
    this.api = const SchoolImportApi(),
  });

  final SchoolImportApi api;

  @override
  State<SchoolImportParserSettingsPage> createState() =>
      _SchoolImportParserSettingsPageState();
}

class _SchoolImportParserSettingsPageState
    extends State<SchoolImportParserSettingsPage> {
  late final TextEditingController _baseUrlController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _modelController;
  late final TextEditingController _customPromptController;

  bool _showApiKey = false;
  bool _isFetchingModels = false;
  List<String> _availableModels = const [];

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController();
    _apiKeyController = TextEditingController();
    _modelController = TextEditingController();
    _customPromptController = TextEditingController();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    _customPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (context, provider, child) {
        _syncControllers(provider);
        final l10n = AppLocalizations.of(context);
        final isCustom =
            provider.schoolImportParserSource ==
            schoolImportParserSourceCustomOpenAi;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.schoolImportParserSettingsTitle)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card.outlined(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.schoolImportParserSourceTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _SelectableParserTile(
                        title: l10n.schoolImportParserSourceOfficial,
                        subtitle: l10n.schoolImportParserSourceOfficialDesc,
                        selected:
                            provider.schoolImportParserSource ==
                            schoolImportParserSourceOfficial,
                        onTap: () => provider.updateSchoolImportParserSource(
                          schoolImportParserSourceOfficial,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SelectableParserTile(
                        title: l10n.schoolImportParserSourceCustomOpenAi,
                        subtitle: l10n.schoolImportParserSourceCustomOpenAiDesc,
                        selected: isCustom,
                        onTap: () => provider.updateSchoolImportParserSource(
                          schoolImportParserSourceCustomOpenAi,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (isCustom) ...[
                Card.outlined(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.schoolImportParserCustomOpenAi,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _baseUrlController,
                          decoration: InputDecoration(
                            labelText: l10n.schoolImportParserBaseUrl,
                            hintText: 'https://api.example.com/v1',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.url,
                          onChanged: provider.updateCustomSchoolImportBaseUrl,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _apiKeyController,
                          obscureText: !_showApiKey,
                          decoration: InputDecoration(
                            labelText: l10n.schoolImportParserApiKey,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _showApiKey = !_showApiKey);
                              },
                              icon: Icon(
                                _showApiKey
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                          onChanged: provider.updateCustomSchoolImportApiKey,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _modelController,
                          decoration: InputDecoration(
                            labelText: l10n.schoolImportParserModel,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: provider.updateCustomSchoolImportModel,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed:
                              _isFetchingModels ||
                                  provider.customSchoolImportBaseUrl.isEmpty ||
                                  provider.customSchoolImportApiKey.isEmpty
                              ? null
                              : () => _fetchModels(provider),
                          icon: _isFetchingModels
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh_outlined),
                          label: Text(
                            _isFetchingModels
                                ? l10n.schoolImportParserFetchingModels
                                : l10n.schoolImportParserFetchModels,
                          ),
                        ),
                        if (_availableModels.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final model in _availableModels)
                                ChoiceChip(
                                  label: Text(model),
                                  selected:
                                      provider.customSchoolImportModel == model,
                                  onSelected: (_) async {
                                    _modelController.text = model;
                                    _modelController.selection =
                                        TextSelection.collapsed(
                                          offset: model.length,
                                        );
                                    await provider
                                        .updateCustomSchoolImportModel(model);
                                  },
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            initiallyExpanded: false,
                            title: Text(
                              l10n.schoolImportParserCustomPromptTitle,
                            ),
                            subtitle: Text(
                              l10n.schoolImportParserCustomPromptDescription,
                            ),
                            children: [
                              const SizedBox(height: 8),
                              TextField(
                                controller: _customPromptController,
                                minLines: 4,
                                maxLines: 8,
                                decoration: InputDecoration(
                                  labelText:
                                      l10n.schoolImportParserCustomPromptTitle,
                                  hintText:
                                      l10n.schoolImportParserCustomPromptHint,
                                  border: const OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                ),
                                onChanged:
                                    provider.updateCustomSchoolImportPrompt,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    _syncController(
                                      _customPromptController,
                                      SchoolImportApi
                                          .defaultCustomOpenAiSystemPrompt,
                                    );
                                    await provider
                                        .updateCustomSchoolImportPrompt('');
                                  },
                                  icon: const Icon(Icons.restart_alt_outlined),
                                  label: Text(
                                    l10n.schoolImportParserResetDefaultPrompt,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    child: Text(
                      l10n.schoolImportParserPlaintextWarning,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ] else
                Card.outlined(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.schoolImportParserSourceOfficialInfo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _syncControllers(TimetableProvider provider) {
    _syncController(_baseUrlController, provider.customSchoolImportBaseUrl);
    _syncController(_apiKeyController, provider.customSchoolImportApiKey);
    _syncController(_modelController, provider.customSchoolImportModel);
    _syncController(
      _customPromptController,
      provider.customSchoolImportPrompt.isEmpty
          ? SchoolImportApi.defaultCustomOpenAiSystemPrompt
          : provider.customSchoolImportPrompt,
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _fetchModels(TimetableProvider provider) async {
    if (_isFetchingModels) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() => _isFetchingModels = true);
    try {
      final models = await widget.api.fetchCustomModels(
        baseUrl: provider.customSchoolImportBaseUrl,
        apiKey: provider.customSchoolImportApiKey,
      );
      if (!mounted) {
        return;
      }
      setState(() => _availableModels = models);
      _showMessage(
        models.isEmpty
            ? l10n.schoolImportParserNoModelsFound
            : l10n.schoolImportParserModelsFetched(models.length),
      );
    } on FormatException catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.message);
    } finally {
      if (mounted) {
        setState(() => _isFetchingModels = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SelectableParserTile extends StatelessWidget {
  const _SelectableParserTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 2),
                  child: Icon(Icons.check, color: colors.onSecondaryContainer),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
