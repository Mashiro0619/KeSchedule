import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../config/app_config.dart';

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.localVersion,
    required this.remoteVersion,
    required this.releaseUrl,
    required this.officialWebsiteUrl,
    required this.updateContent,
    required this.hasUpdate,
  });

  final String localVersion;
  final String remoteVersion;
  final String releaseUrl;
  final String officialWebsiteUrl;
  final String updateContent;
  final bool hasUpdate;
}

class _RemoteUpdateInfo {
  const _RemoteUpdateInfo({
    required this.version,
    required this.releaseUrl,
    this.updateContent = '',
  });

  final String version;
  final String releaseUrl;
  final String updateContent;
}

bool prefersConfiguredUpdateSourceForLocale(Locale? locale) {
  final languageCode = locale?.languageCode.toLowerCase();
  return languageCode == 'zh';
}

String normalizeUpdateVersion(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '';
  }
  final withoutPrefix = trimmed.startsWith('v') || trimmed.startsWith('V')
      ? trimmed.substring(1)
      : trimmed;
  return withoutPrefix.split('+').first.split('-').first.trim();
}

int compareUpdateVersions(String a, String b) {
  final aParts = _versionParts(a);
  final bParts = _versionParts(b);
  final maxLength = aParts.length > bParts.length
      ? aParts.length
      : bParts.length;
  for (var index = 0; index < maxLength; index++) {
    final left = index < aParts.length ? aParts[index] : 0;
    final right = index < bParts.length ? bParts[index] : 0;
    if (left != right) {
      return left.compareTo(right);
    }
  }
  return 0;
}

List<int> _versionParts(String value) {
  return normalizeUpdateVersion(value)
      .split('.')
      .map((item) => int.tryParse(item) ?? _leadingNumber(item))
      .toList();
}

int _leadingNumber(String value) {
  final match = RegExp(r'^\d+').firstMatch(value.trim());
  return match == null ? 0 : int.parse(match.group(0)!);
}

class UpdateService {
  const UpdateService({
    http.Client? client,
    Duration requestTimeout = const Duration(seconds: 10),
  }) : _client = client,
       _requestTimeout = requestTimeout;

  static const _githubLatestApi =
      'https://api.github.com/repos/Mashiro0619/KeSchedule/releases/latest';
  static const latestReleaseUrl =
      'https://github.com/Mashiro0619/KeSchedule/releases/latest';

  final http.Client? _client;
  final Duration _requestTimeout;

  Future<UpdateCheckResult> checkForUpdates({Locale? preferredLocale}) async {
    final localVersion = await _getLocalVersion();
    final remoteInfo = await _getRemoteUpdateInfo(
      preferredLocale: preferredLocale,
    );
    return UpdateCheckResult(
      localVersion: localVersion,
      remoteVersion: remoteInfo.version,
      releaseUrl: remoteInfo.releaseUrl,
      officialWebsiteUrl: AppConfig.officialWebsiteUrl,
      updateContent: remoteInfo.updateContent,
      hasUpdate: compareUpdateVersions(remoteInfo.version, localVersion) > 0,
    );
  }

  Future<String> _getLocalVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<_RemoteUpdateInfo> _getRemoteUpdateInfo({
    Locale? preferredLocale,
  }) async {
    final client = _client ?? http.Client();
    final ownsClient = _client == null;
    try {
      final locale = preferredLocale ?? _defaultPreferredLocale();
      final tryCustomFirst = prefersConfiguredUpdateSourceForLocale(locale);
      final fetchers = <Future<_RemoteUpdateInfo> Function()>[
        if (tryCustomFirst && AppConfig.hasUpdateVersionUrl)
          () => _getCustomUpdateInfo(client),
        if (!tryCustomFirst) () => _getGithubLatestReleaseInfo(client),
        if (tryCustomFirst) () => _getGithubLatestReleaseInfo(client),
        if (!tryCustomFirst && AppConfig.hasUpdateVersionUrl)
          () => _getCustomUpdateInfo(client),
      ];
      Object? lastError;
      StackTrace? lastStackTrace;
      for (final fetch in fetchers) {
        try {
          return await fetch();
        } catch (error, stackTrace) {
          lastError = error;
          lastStackTrace = stackTrace;
        }
      }
      if (lastError != null) {
        Error.throwWithStackTrace(lastError, lastStackTrace!);
      }
      throw const FormatException('No update source is available.');
    } finally {
      if (ownsClient) {
        client.close();
      }
    }
  }

  Locale? _defaultPreferredLocale() {
    final locales = PlatformDispatcher.instance.locales;
    return locales.isEmpty ? null : locales.first;
  }

  Future<_RemoteUpdateInfo> _getCustomUpdateInfo(http.Client client) async {
    final response = await client
        .get(Uri.parse(AppConfig.updateVersionUrl))
        .timeout(_requestTimeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'Unable to fetch custom update info.',
        Uri.parse(AppConfig.updateVersionUrl),
      );
    }
    final responseText = utf8.decode(response.bodyBytes, allowMalformed: true);
    final decoded = jsonDecode(responseText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid custom update response.');
    }
    final version = _readRemoteVersionField(
      decoded,
      'version',
      invalidMessage: 'Invalid custom update response.',
      emptyMessage: 'Custom update version is empty.',
    );
    return _RemoteUpdateInfo(
      version: version,
      releaseUrl: latestReleaseUrl,
      updateContent: _optionalStringField(decoded, 'updateContent'),
    );
  }

  Future<_RemoteUpdateInfo> _getGithubLatestReleaseInfo(
    http.Client client,
  ) async {
    final response = await client
        .get(
          Uri.parse(_githubLatestApi),
          headers: const {'Accept': 'application/vnd.github+json'},
        )
        .timeout(_requestTimeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const FormatException('Unable to fetch latest release version.');
    }
    final decoded = jsonDecode(
      utf8.decode(response.bodyBytes, allowMalformed: true),
    );
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid latest release response.');
    }
    final version = _readRemoteVersionField(
      decoded,
      'tag_name',
      invalidMessage: 'Invalid latest release response.',
      emptyMessage: 'Latest release version is empty.',
    );
    final releaseUrl = _optionalStringField(decoded, 'html_url');
    return _RemoteUpdateInfo(
      version: version,
      releaseUrl: releaseUrl.isNotEmpty ? releaseUrl : latestReleaseUrl,
      updateContent: _optionalStringField(decoded, 'body'),
    );
  }
}

String _readRemoteVersionField(
  Map<String, dynamic> json,
  String key, {
  required String invalidMessage,
  required String emptyMessage,
}) {
  final raw = json[key];
  if (raw is! String) {
    throw FormatException(invalidMessage);
  }
  final version = normalizeUpdateVersion(raw);
  if (version.isEmpty) {
    throw FormatException(emptyMessage);
  }
  return version;
}

String _optionalStringField(Map<String, dynamic> json, String key) {
  final raw = json[key];
  return raw is String ? raw.trim() : '';
}
