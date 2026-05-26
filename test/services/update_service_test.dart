import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sked/config/app_config.dart';
import 'package:sked/services/update_service.dart';

void main() {
  group('update version helpers', () {
    test('normalizes common release tag formats', () {
      expect(normalizeUpdateVersion(' v1.2.3+5 '), '1.2.3');
      expect(normalizeUpdateVersion('V2.0.0-beta.1'), '2.0.0');
      expect(normalizeUpdateVersion(''), '');
    });

    test('compares numeric version segments instead of lexicographic text', () {
      expect(compareUpdateVersions('1.10.0', '1.9.9'), greaterThan(0));
      expect(compareUpdateVersions('1.2', '1.2.0'), 0);
      expect(compareUpdateVersions('v1.2.3+5', '1.2.3'), 0);
      expect(compareUpdateVersions('1.2.3-beta.1', '1.2.3'), 0);
      expect(compareUpdateVersions('1.2.4', '1.2.3-beta.1'), greaterThan(0));
    });
  });

  group('UpdateService.checkForUpdates', () {
    setUp(() {
      PackageInfo.setMockInitialValues(
        appName: 'Sked',
        packageName: 'com.mashiro.sked',
        version: '1.9.9',
        buildNumber: '1',
        buildSignature: '',
      );
    });

    test('uses shared version comparison for hasUpdate', () async {
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': 'v1.10.0+2',
                'html_url':
                    'https://github.com/Mashiro0619/KeSchedule/releases/tag/v1.10.0',
                'body': 'notes',
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates(
        preferredLocale: const Locale('en'),
      );

      expect(result.remoteVersion, '1.10.0');
      expect(result.hasUpdate, isTrue);
    });

    test(
      'falls back from GitHub to configured source when available',
      () async {
        final service = UpdateService(
          client: MockClient((request) async {
            if (request.url.toString().contains('/releases/latest')) {
              return http.Response('{"tag_name":""}', 200);
            }
            if (request.url.toString() == AppConfig.updateVersionUrl) {
              return http.Response(jsonEncode({'version': '1.9.9+7'}), 200);
            }
            return http.Response('not found', 404);
          }),
        );

        final result = await service.checkForUpdates(
          preferredLocale: const Locale('en'),
        );

        expect(result.remoteVersion, '1.9.9');
        expect(result.hasUpdate, isFalse);
      },
    );

    test('falls back when GitHub version field is malformed', () async {
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': {'version': 'v2.0.0'},
                'html_url': ['https://example.test/release'],
                'body': {'notes': 'bad shape'},
              }),
              200,
            );
          }
          if (request.url.toString() == AppConfig.updateVersionUrl) {
            return http.Response(
              jsonEncode({
                'version': '2.0.0',
                'updateContent': ['bad'],
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates(
        preferredLocale: const Locale('en'),
      );

      expect(result.remoteVersion, '2.0.0');
      expect(result.updateContent, isEmpty);
      expect(result.hasUpdate, isTrue);
    });

    test('ignores malformed GitHub optional release fields', () async {
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': 'v2.0.0',
                'html_url': {'url': 'https://example.test/release'},
                'body': ['bad notes'],
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates(
        preferredLocale: const Locale('en'),
      );

      expect(result.remoteVersion, '2.0.0');
      expect(result.releaseUrl, UpdateService.latestReleaseUrl);
      expect(result.updateContent, isEmpty);
      expect(result.hasUpdate, isTrue);
    });

    test('rejects malformed configured update version fields', () async {
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response('not found', 404);
          }
          if (request.url.toString() == AppConfig.updateVersionUrl) {
            return http.Response(
              jsonEncode({
                'version': {'value': '2.0.0'},
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      expect(
        () => service.checkForUpdates(preferredLocale: const Locale('en')),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Invalid custom update response.',
          ),
        ),
      );
    });

    test('falls back after the preferred update source times out', () async {
      final service = UpdateService(
        requestTimeout: const Duration(milliseconds: 1),
        client: MockClient((request) async {
          if (request.url.toString() == AppConfig.updateVersionUrl) {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return http.Response(jsonEncode({'version': '2.0.0'}), 200);
          }
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': 'v1.10.0',
                'html_url':
                    'https://github.com/Mashiro0619/KeSchedule/releases/tag/v1.10.0',
                'body': 'notes',
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates(
        preferredLocale: const Locale('zh'),
      );

      expect(result.remoteVersion, '1.10.0');
      expect(result.hasUpdate, isTrue);
    });
  });
}
