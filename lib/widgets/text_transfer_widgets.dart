import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

typedef TextImportSubmit =
    Future<bool> Function(BuildContext context, String content);

class TextImportPage extends StatefulWidget {
  const TextImportPage({
    super.key,
    required this.title,
    required this.onSubmit,
    this.labelText,
    this.hintText,
    this.initialContent = '',
    this.submitText,
  });

  final String title;
  final String? labelText;
  final String? hintText;
  final String initialContent;
  final String? submitText;
  final TextImportSubmit onSubmit;

  @override
  State<TextImportPage> createState() => _TextImportPageState();
}

class _TextImportPageState extends State<TextImportPage> {
  late final TextEditingController _controller;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            enabled: !_isSubmitting,
            minLines: 12,
            maxLines: 20,
            decoration: InputDecoration(
              labelText: widget.labelText ?? l10n.jsonContent,
              hintText: widget.hintText ?? l10n.pasteJsonContentHint,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.file_download_outlined),
            label: Text(widget.submitText ?? l10n.importAction),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final content = _controller.text.trim();
    if (content.isEmpty) {
      _showMessage(l10n.jsonContentEmpty);
      return;
    }

    setState(() => _isSubmitting = true);
    var shouldResetSubmitting = true;
    try {
      final imported = await widget.onSubmit(context, content);
      if (imported && mounted) {
        shouldResetSubmitting = false;
        Navigator.of(context).pop();
      }
    } finally {
      if (shouldResetSubmitting && mounted) {
        setState(() => _isSubmitting = false);
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

Future<void> showTextExportDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext);
      var popped = false;
      void popOnce() {
        if (popped) return;
        popped = true;
        Navigator.of(dialogContext).pop();
      }

      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(child: SelectableText(content)),
        ),
        actions: [
          TextButton(onPressed: popOnce, child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: content));
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
              }
            },
            child: Text(l10n.copyText),
          ),
        ],
      );
    },
  );
}
