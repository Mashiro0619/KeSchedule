import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../models/school_import_models.dart';

class SchoolWebImportPageService {
  const SchoolWebImportPageService();

  static const extractImportHtmlScript = '''
(() => {
  const root = document.documentElement;
  if (!root) {
    return '';
  }
  const cloned = root.cloneNode(true);
  cloned.querySelectorAll('script,style,noscript,svg,canvas,iframe,template').forEach((node) => node.remove());
  return cloned.outerHTML;
})()
''';

  Future<SchoolImportSourcePayload> extractSource(
    InAppWebViewController controller, {
    required String fallbackUrl,
    required String fallbackTitle,
  }) async {
    final html = await controller.evaluateJavascript(
      source: extractImportHtmlScript,
    );
    final currentUrl = (await controller.getUrl())?.toString() ?? fallbackUrl;
    final title = await _safeGetTitle(controller, fallbackTitle: fallbackTitle);
    final normalizedContent = normalizeJavaScriptResult(html).trim();
    if (normalizedContent.isEmpty) {
      throw const FormatException('Import content is empty.');
    }
    return SchoolImportSourcePayload(
      url: currentUrl,
      title: title,
      content: normalizedContent,
    );
  }

  Future<String> _safeGetTitle(
    InAppWebViewController controller, {
    required String fallbackTitle,
  }) async {
    try {
      return await controller.getTitle() ?? fallbackTitle;
    } catch (_) {
      return fallbackTitle;
    }
  }
}

@visibleForTesting
String normalizeJavaScriptResult(Object? value) {
  if (value == null) {
    return '';
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == 'null' || trimmed == 'undefined') {
      return '';
    }
    if (trimmed.length >= 2 &&
        trimmed.startsWith('"') &&
        trimmed.endsWith('"')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is String) {
          return decoded;
        }
      } catch (_) {
        return trimmed.substring(1, trimmed.length - 1);
      }
    }
    return value;
  }
  final text = value.toString().trim();
  return text == 'null' || text == 'undefined' ? '' : text;
}
