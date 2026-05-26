import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/services/school_site_service.dart';
import 'package:sked/services/school_site_store.dart';

class _FakeSchoolSiteStore extends SchoolSiteStore {
  const _FakeSchoolSiteStore(this.source) : super.base();

  final String? source;

  @override
  Future<String?> load() async => source;

  @override
  Future<void> save(String source) async {}

  @override
  Future<String?> filePath() async => 'memory://school-sites';
}

class _CandidateSchoolSiteStore extends SchoolSiteStore {
  _CandidateSchoolSiteStore(this.candidates) : super.base();

  final List<SchoolSiteStoreCandidate> candidates;

  @override
  Future<String?> load() async {
    return candidates.isEmpty ? null : candidates.first.source;
  }

  @override
  Future<List<SchoolSiteStoreCandidate>> loadCandidates() async => candidates;

  @override
  Future<void> save(String source) async {}

  @override
  Future<String?> filePath() async => 'memory://school-sites';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void mockSchoolSitesAsset(String source) {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMessageHandler('flutter/assets', (message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      if (key != SchoolSiteService.schoolSitesAssetPath) {
        return null;
      }
      return ByteData.sublistView(Uint8List.fromList(utf8.encode(source)));
    });
    addTearDown(() => messenger.setMockMessageHandler('flutter/assets', null));
  }

  group('SchoolSiteService.loadSites', () {
    test('falls back to bundled sites when stored JSON is invalid', () async {
      mockSchoolSitesAsset(
        jsonEncode([
          {'name': 'Example University', 'loginUrl': 'https://example.test'},
        ]),
      );
      const service = SchoolSiteService(
        store: _FakeSchoolSiteStore('{ broken json'),
      );

      final sites = await service.loadSites();

      expect(sites, hasLength(1));
      expect(sites.single.name, 'Example University');
      expect(sites.single.loginUrl, 'https://example.test');
    });

    test(
      'uses a valid backup candidate when stored primary JSON is invalid',
      () async {
        mockSchoolSitesAsset(
          jsonEncode([
            {'name': 'Bundled University', 'loginUrl': 'https://bundled.test'},
          ]),
        );
        var promoted = false;
        final service = SchoolSiteService(
          store: _CandidateSchoolSiteStore([
            const SchoolSiteStoreCandidate(source: '{ broken json'),
            SchoolSiteStoreCandidate(
              source: jsonEncode([
                {
                  'name': 'Backup University',
                  'loginUrl': 'https://backup.test',
                },
              ]),
              promote: () async => promoted = true,
            ),
          ]),
        );

        final sites = await service.loadSites();

        expect(sites, hasLength(1));
        expect(sites.single.name, 'Backup University');
        expect(sites.single.loginUrl, 'https://backup.test');
        expect(promoted, isTrue);
      },
    );

    test('keeps manual import strict when source JSON is invalid', () async {
      const service = SchoolSiteService(store: _FakeSchoolSiteStore(null));

      expect(() => service.importSites('{ broken json'), throwsFormatException);
    });

    test('manual import filters malformed site entries and fields', () async {
      const service = SchoolSiteService(store: _FakeSchoolSiteStore(null));

      final sites = await service.importSites(
        jsonEncode([
          {'name': 'Valid University', 'loginUrl': 'https://valid.test'},
          {'name': 42, 'loginUrl': 'https://bad-name.test'},
          {'name': 'Bad URL', 'loginUrl': 42},
          'bad',
          null,
        ]),
      );

      expect(sites, hasLength(1));
      expect(sites.single.name, 'Valid University');
      expect(sites.single.loginUrl, 'https://valid.test');
    });

    test('manual import rejects non-empty files with no valid sites', () async {
      const service = SchoolSiteService(store: _FakeSchoolSiteStore(null));

      expect(
        () => service.importSites(
          jsonEncode([
            {'name': 42, 'loginUrl': 'https://bad-name.test'},
            {'name': 'Bad URL', 'loginUrl': 42},
            'bad',
            null,
          ]),
        ),
        throwsFormatException,
      );
    });

    test('manual import accepts an explicit empty site list', () async {
      const service = SchoolSiteService(store: _FakeSchoolSiteStore(null));

      final sites = await service.importSites('[]');

      expect(sites, isEmpty);
    });
  });
}
