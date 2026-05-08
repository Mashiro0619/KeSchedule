import 'dart:async';

import 'package:flutter/material.dart';

import '../models/school_import_models.dart';
import '../services/school_import_api.dart';

class SchoolImportStreamDialog extends StatefulWidget {
  const SchoolImportStreamDialog({
    super.key,
    required this.stream,
  });

  final Stream<SchoolImportStreamEvent> stream;

  @override
  State<SchoolImportStreamDialog> createState() =>
      _SchoolImportStreamDialogState();
}

class _SchoolImportStreamDialogState extends State<SchoolImportStreamDialog> {
  final _textBuffer = StringBuffer();
  final _scrollController = ScrollController();
  StreamSubscription<SchoolImportStreamEvent>? _subscription;
  bool _isDone = false;
  String? _error;
  SchoolImportResponse? _response;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(
      (event) {
        switch (event) {
          case ParseDelta(:final text):
            _textBuffer.write(text);
            break;
          case ParseDone(:final response):
            _response = response;
            _isDone = true;
            break;
          case ParseError(:final message):
            _error = message;
            break;
        }
        if (mounted) {
          setState(() {});
          _scrollToBottom();
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _error = '$error');
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasContent = _textBuffer.isNotEmpty;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Row(
          children: [
            if (!_isDone && _error == null) ...[
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
            ],
            if (_error != null)
              const Icon(Icons.error_outline, color: Colors.red),
            if (_isDone)
              const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 8),
            const Text('解析课表'),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              Container(
                constraints: const BoxConstraints(maxHeight: 360),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(
                    hasContent
                        ? _textBuffer.toString()
                        : (_error != null ? '解析失败' : '正在连接...'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _subscription?.cancel();
              Navigator.of(context).pop(null);
            },
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed:
                _isDone ? () => Navigator.of(context).pop(_response) : null,
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
