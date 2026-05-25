import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/data/timetable_storage_io.dart';
import 'package:sked/models/app_data.dart';
import 'package:sked/models/app_mode.dart';

void main() {
  late Directory tempDir;
  late IoTimetableStorage storage;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sked_storage_test_');
    storage = IoTimetableStorage(directoryProvider: () async => tempDir);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  AppData buildAppData(AppMode mode) {
    final empty = AppData.fromJson(const {});
    return AppData(
      activeMode: mode,
      studentMode: empty.studentMode,
      generalMode: empty.generalMode,
    );
  }

  File mainFile() =>
      File('${tempDir.path}${Platform.pathSeparator}Sked_data.json');
  File backupFile() =>
      File('${tempDir.path}${Platform.pathSeparator}Sked_data.json.bak');
  File tempFile() =>
      File('${tempDir.path}${Platform.pathSeparator}Sked_data.json.tmp');

  group('IoTimetableStorage atomic write & recovery', () {
    test('first load returns null with status none', () async {
      final result = await storage.load();

      expect(result.data, isNull);
      expect(result.recoveryStatus, equals(RecoveryStatus.none));
    });

    test('write then read returns identical AppData', () async {
      final data = buildAppData(AppMode.student);

      await storage.save(data);
      final result = await storage.load();

      expect(result.data, isNotNull);
      expect(result.data!.activeMode, equals(AppMode.student));
      expect(result.recoveryStatus, equals(RecoveryStatus.none));
    });

    test('second write rotates previous main to .bak', () async {
      final v1 = buildAppData(AppMode.student);
      final v2 = buildAppData(AppMode.general);

      await storage.save(v1);
      await storage.save(v2);

      // Main now has v2.
      final result = await storage.load();
      expect(result.data!.activeMode, equals(AppMode.general));

      // .bak should contain the previous version (v1 == student mode).
      expect(await backupFile().exists(), isTrue);
      final bakContent = await backupFile().readAsString();
      final bakData = AppData.decode(bakContent);
      expect(bakData.activeMode, equals(AppMode.student));
    });

    test('successful save leaves no stale .tmp file', () async {
      final data = buildAppData(AppMode.general);

      await storage.save(data);

      expect(await tempFile().exists(), isFalse);
    });

    test('falls back to .bak when main file is corrupted', () async {
      final v1 = buildAppData(AppMode.student);
      final v2 = buildAppData(AppMode.general);

      // Two writes: main = v2, .bak = v1.
      await storage.save(v1);
      await storage.save(v2);

      // Corrupt main file by writing invalid JSON.
      await mainFile().writeAsString('{not valid json');

      final result = await storage.load();

      expect(result.data, isNotNull);
      expect(result.data!.activeMode, equals(AppMode.student));
      expect(result.recoveryStatus, equals(RecoveryStatus.restoredFromBackup));

      final secondLoad = await storage.load();
      expect(secondLoad.data, isNotNull);
      expect(secondLoad.data!.activeMode, equals(AppMode.student));
      expect(secondLoad.recoveryStatus, equals(RecoveryStatus.none));
    });

    test('falls back to .bak when main file is not valid UTF-8', () async {
      final v1 = buildAppData(AppMode.student);
      final v2 = buildAppData(AppMode.general);

      await storage.save(v1);
      await storage.save(v2);

      await mainFile().writeAsBytes([0xff, 0xfe, 0xfd]);

      final result = await storage.load();

      expect(result.data, isNotNull);
      expect(result.data!.activeMode, equals(AppMode.student));
      expect(result.recoveryStatus, equals(RecoveryStatus.restoredFromBackup));
    });

    test(
      'returns failedBackupRestore when both main and .bak are corrupted',
      () async {
        await mainFile().writeAsString('{garbage');
        await backupFile().writeAsString('{also garbage');

        final result = await storage.load();

        expect(result.data, isNull);
        expect(
          result.recoveryStatus,
          equals(RecoveryStatus.failedBackupRestore),
        );
      },
    );

    test('empty main file is treated as missing (not corrupt)', () async {
      await mainFile().writeAsString('   ');

      final result = await storage.load();

      expect(result.data, isNull);
      // Empty is "no data yet", not a corruption event.
      expect(result.recoveryStatus, equals(RecoveryStatus.none));
    });

    test('stale .tmp file from previous crash is ignored on load', () async {
      // Simulate: a previous save crashed after writing .tmp but before rotation.
      await tempFile().writeAsString('{leftover');

      final result = await storage.load();

      expect(result.data, isNull);
      expect(result.recoveryStatus, equals(RecoveryStatus.none));
    });
  });
}
