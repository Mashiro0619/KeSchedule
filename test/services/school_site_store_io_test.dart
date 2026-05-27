import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sked/services/school_site_store_io.dart';

void main() {
  group('PlatformSchoolSiteStore IO', () {
    late Directory tempDir;
    late PlatformSchoolSiteStore store;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('sked_school_sites_');
      store = PlatformSchoolSiteStore(directoryProvider: () async => tempDir);
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    File mainFile() => File(path.join(tempDir.path, 'Sked_school_sites.json'));
    File backupFile() =>
        File(path.join(tempDir.path, 'Sked_school_sites.json.bak'));
    File tempFile() =>
        File(path.join(tempDir.path, 'Sked_school_sites.json.tmp'));

    test('saves with a backup of the previous content', () async {
      await store.save('[{"name":"A","loginUrl":"https://a.test"}]');
      await store.save('[{"name":"B","loginUrl":"https://b.test"}]');

      expect(await mainFile().readAsString(), contains('"B"'));
      expect(await backupFile().readAsString(), contains('"A"'));
    });

    test('loads and promotes backup when main file is missing', () async {
      const first = '[{"name":"A","loginUrl":"https://a.test"}]';
      const second = '[{"name":"B","loginUrl":"https://b.test"}]';
      await store.save(first);
      await store.save(second);
      await mainFile().delete();

      final loaded = await store.load();

      expect(loaded, first);
      expect(await mainFile().readAsString(), first);
    });

    test('failed save before main replace keeps previous main file', () async {
      const first = '[{"name":"A","loginUrl":"https://a.test"}]';
      const second = '[{"name":"B","loginUrl":"https://b.test"}]';
      await store.save(first);
      final failingStore = PlatformSchoolSiteStore(
        directoryProvider: () async => tempDir,
        beforeMainReplace: () async => throw Exception('crash before replace'),
      );

      await expectLater(failingStore.save(second), throwsException);

      expect(await mainFile().readAsString(), first);
      expect(await backupFile().readAsString(), first);
      expect(await tempFile().readAsString(), second);
    });

    test('exposes backup as a candidate when main file is corrupt', () async {
      const first = '[{"name":"A","loginUrl":"https://a.test"}]';
      const second = '[{"name":"B","loginUrl":"https://b.test"}]';
      await store.save(first);
      await store.save(second);
      await mainFile().writeAsString('{ broken json');

      final candidates = await store.loadCandidates();

      expect(candidates, hasLength(2));
      expect(candidates.first.source, '{ broken json');
      expect(candidates.last.source, first);

      await candidates.last.promote();
      expect(await mainFile().readAsString(), first);
    });

    test('falls back to backup when main file is not valid UTF-8', () async {
      const first = '[{"name":"A","loginUrl":"https://a.test"}]';
      const second = '[{"name":"B","loginUrl":"https://b.test"}]';
      await store.save(first);
      await store.save(second);
      await mainFile().writeAsBytes([0xff, 0xfe, 0xfd]);

      final loaded = await store.load();

      expect(loaded, first);
      expect(await mainFile().readAsString(), first);
    });

    test('treats empty main and missing backup as no stored content', () async {
      await mainFile().writeAsString('   ');

      expect(await store.load(), isNull);
    });
  });
}
