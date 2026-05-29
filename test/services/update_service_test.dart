import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

    test('rejects malformed version strings during comparison', () {
      for (final value in ['future', '1.x', '1..2']) {
        expect(
          () => compareUpdateVersions(value, '1.0.0'),
          throwsFormatException,
          reason: value,
        );
      }
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

    test('uses GitHub latest release for hasUpdate', () async {
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': 'v1.10.0+2',
                'html_url':
                    'https://github.com/Mashiro0619/Sked/releases/tag/v1.10.0',
                'body': 'notes',
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates();

      expect(result.remoteVersion, '1.10.0');
      expect(result.updateContent, 'notes');
      expect(result.hasUpdate, isTrue);
    });

    test('throws when GitHub latest release request fails', () async {
      final service = UpdateService(
        client: MockClient((request) async => http.Response('not found', 404)),
      );

      expect(
        service.checkForUpdates,
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Unable to fetch latest release version.',
          ),
        ),
      );
    });

    test('rejects malformed GitHub version fields', () async {
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
          return http.Response('not found', 404);
        }),
      );

      expect(
        service.checkForUpdates,
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Invalid latest release response.',
          ),
        ),
      );
    });

    test('rejects malformed GitHub version strings', () async {
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': 'future',
                'html_url':
                    'https://github.com/Mashiro0619/Sked/releases/tag/future',
                'body': 'bad version',
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      expect(
        service.checkForUpdates,
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Invalid latest release response.',
          ),
        ),
      );
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

      final result = await service.checkForUpdates();

      expect(result.remoteVersion, '2.0.0');
      expect(result.releaseUrl, UpdateService.latestReleaseUrl);
      expect(result.updateContent, isEmpty);
      expect(result.hasUpdate, isTrue);
    });

    test(
      'falls back when GitHub release URL is not a project HTTPS URL',
      () async {
        for (final url in [
          'javascript:alert(1)',
          'http://github.com/Mashiro0619/Sked/releases/tag/v2.0.0',
          'https://example.test/Mashiro0619/Sked/releases/tag/v2.0.0',
          'https://github.com/other/project/releases/tag/v2.0.0',
        ]) {
          final service = UpdateService(
            client: MockClient((request) async {
              if (request.url.toString().contains('/releases/latest')) {
                return http.Response(
                  jsonEncode({
                    'tag_name': 'v2.0.0',
                    'html_url': url,
                    'body': 'notes',
                  }),
                  200,
                );
              }
              return http.Response('not found', 404);
            }),
          );

          final result = await service.checkForUpdates();

          expect(
            result.releaseUrl,
            UpdateService.latestReleaseUrl,
            reason: url,
          );
        }
      },
    );

    test('times out when GitHub latest release stalls', () async {
      final service = UpdateService(
        requestTimeout: const Duration(milliseconds: 1),
        client: MockClient((request) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return http.Response('{}', 200);
        }),
      );

      expect(service.checkForUpdates, throwsA(isA<TimeoutException>()));
    });
  });
}
