import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/school_import_models.dart';
import '../services/school_import_api.dart';

Map<String, dynamic>? _tryDecodeJsonObject(String source) {
  try {
    final decoded = jsonDecode(source);
    if (decoded is! Map) {
      return null;
    }
    final result = <String, dynamic>{};
    for (final entry in decoded.entries) {
      final key = entry.key;
      if (key is String) {
        result[key] = entry.value;
      }
    }
    return result;
  } catch (_) {
    return null;
  }
}

class SchoolImportStreamDialog extends StatefulWidget {
  const SchoolImportStreamDialog({super.key, required this.stream});

  final Stream<SchoolImportStreamEvent> stream;

  @override
  State<SchoolImportStreamDialog> createState() =>
      _SchoolImportStreamDialogState();
}

class _SchoolImportStreamDialogState extends State<SchoolImportStreamDialog> {
  final _textBuffer = StringBuffer();
  final _scrollController = ScrollController();
  late final TextEditingController _editController;
  StreamSubscription<SchoolImportStreamEvent>? _subscription;
  bool _isDone = false;
  bool _isEditing = false;
  String? _error;
  SchoolImportResponse? _response;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
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
    _editController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_isEditing) return;
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

  void _enterEditMode() {
    _editController.text = _textBuffer.toString();
    setState(() => _isEditing = true);
  }

  void _confirmEdit() {
    final rawText = _editController.text.trim();
    if (rawText.isEmpty) {
      setState(() => _error = '内容不能为空。');
      return;
    }

    final json = _tryDecodeJsonObject(rawText);
    if (json == null) {
      setState(() => _error = 'JSON 格式无效');
      return;
    }

    try {
      if (json.containsKey('timetable')) {
        _response = SchoolImportResponse.fromJson(json);
      } else if (json.containsKey('name') || json.containsKey('courses')) {
        _response = SchoolImportApi.buildResponseFromPhpDone(json);
      } else {
        setState(() => _error = '无法识别的课表格式。');
        return;
      }
    } catch (e) {
      setState(() => _error = '解析失败: $e');
      return;
    }

    _error = null;
    Navigator.of(context).pop(_response);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Row(
          children: [
            if (_isEditing) ...[
              const Icon(Icons.edit, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text('解析课表 - 编辑中'),
            ] else if (_error != null) ...[
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              const Text('解析课表'),
            ] else if (_isDone) ...[
              const Icon(Icons.check_circle_outline, color: Colors.green),
              const SizedBox(width: 8),
              const Text('解析课表'),
            ] else ...[
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              const Text('解析课表'),
            ],
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
                child: _isEditing
                    ? TextField(
                        controller: _editController,
                        maxLines: null,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        child: SelectableText(
                          _textBuffer.isNotEmpty
                              ? _textBuffer.toString()
                              : (_error != null ? '解析失败' : '正在连接...'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _subscription?.cancel();
                      Navigator.of(context).pop(null);
                    },
                    child: const Text('取消'),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        _editController.text = _textBuffer.toString();
                        setState(() {
                          _isEditing = false;
                          _error = null;
                        });
                      },
                      child: const Text('重置'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _confirmEdit,
                      child: const Text('确定'),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _isDone ? _enterEditMode : null,
                      child: const Text('修改'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _isDone
                          ? () => Navigator.of(context).pop(_response)
                          : null,
                      child: const Text('确定'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
