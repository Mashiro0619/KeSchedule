import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PrivacyService {
  const PrivacyService({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<String?> fetchCurrentPrivacyPolicyVersion() async {
    try {
      final client = _client ?? http.Client();
      final ownsClient = _client == null;
      try {
        final uri = Uri.parse('https://mashiro.tech/KeSchedule/privacy.html');
        final response = await client
            .get(uri)
            .timeout(const Duration(seconds: 10));
        if (response.statusCode != 200) return null;
        return extractPrivacyPolicyVersion(response.body);
      } finally {
        if (ownsClient) client.close();
      }
    } catch (e, st) {
      debugPrint('Failed to fetch privacy version: $e\n$st');
      return null;
    }
  }
}

@visibleForTesting
String? extractPrivacyPolicyVersion(String html) {
  final metaTagPattern = RegExp(r'<meta\b[^>]*>', caseSensitive: false);
  for (final tagMatch in metaTagPattern.allMatches(html)) {
    final attributes = _parseHtmlAttributes(tagMatch.group(0)!);
    if (attributes['name']?.trim().toLowerCase() != 'privacy-policy-version') {
      continue;
    }
    final version = attributes['content']?.trim();
    return version == null || version.isEmpty ? null : version;
  }
  return null;
}

Map<String, String> _parseHtmlAttributes(String tag) {
  final attributes = <String, String>{};
  final attributePattern = RegExp(
    r'''([a-zA-Z_:][-a-zA-Z0-9_:.]*)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s"'=<>`]+))''',
  );
  for (final match in attributePattern.allMatches(tag)) {
    final name = match.group(1)!.toLowerCase();
    final value = match.group(2) ?? match.group(3) ?? match.group(4) ?? '';
    attributes[name] = value;
  }
  return attributes;
}
