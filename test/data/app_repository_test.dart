import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/app_repository.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/models/app_data.dart';
import 'package:sked/models/app_mode.dart';

class _FakeStorage implements TimetableStorage {
  _FakeStorage({this.initialResult = const StorageLoadResult.empty()});

  StorageLoadResult initialResult;
  AppData? lastSaved;
  final List<AppData> writeLog = [];
  Completer<void>? gate;
  int saveCount = 0;

  @override
  Future<StorageLoadResult> load() async => initialResult;

  @override
  Future<void> save(AppData data) async {
    saveCount += 1;
    if (gate != null) {
      await gate!.future;
    }
    lastSaved = data;
    writeLog.add(data);
  }

  @override
  Future<String?> filePath() async => 'memory://app-repo-test';
}

AppData _emptyApp() => AppData.fromJson(const {});

void main() {
  group('AppRepository load', () {
    test('returns null on empty storage and reports RecoveryStatus.none',
        () async {
      final repo = AppRepository(storage: _FakeStorage());

      final loaded = await repo.load();

      expect(loaded, isNull);
      expect(repo.lastRecoveryStatus, equals(RecoveryStatus.none));
      expect(repo.current, isNull);
    });

    test('caches loaded AppData as current state', () async {
      final initial = _emptyApp();
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: initial,
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);

      final loaded = await repo.load();

      expect(loaded, isNotNull);
      expect(repo.current, equals(loaded));
    });

    test('propagates RecoveryStatus.restoredFromBackup from storage', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.restoredFromBackup,
        ),
      );
      final repo = AppRepository(storage: storage);

      await repo.load();

      expect(
        repo.lastRecoveryStatus,
        equals(RecoveryStatus.restoredFromBackup),
      );
    });
  });

  group('AppRepository updates', () {
    test('updateGeneral applies pure-function patch to subtree', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);
      await repo.load();

      await repo.updateGeneral(
        (g) => g.copyWith(dayStartHour: 5),
        flush: true,
      );

      expect(
        repo.current!.generalMode.dayStartHour,
        equals(5),
      );
      expect(
        storage.lastSaved!.generalMode.dayStartHour,
        equals(5),
      );
    });

    test('updateStudent applies pure-function patch to subtree', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);
      await repo.load();

      await repo.updateStudent(
        (s) => s.copyWith(activeTimetableId: 'student-active'),
        flush: true,
      );

      expect(
        repo.current!.studentMode.activeTimetableId,
        equals('student-active'),
      );
      expect(
        storage.lastSaved!.studentMode.activeTimetableId,
        equals('student-active'),
      );
    });

    test('updateSettings applies pure-function patch to AppData', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);
      await repo.load();

      await repo.updateSettings(
        (data) => data.copyWith(activeMode: AppMode.student),
        flush: true,
      );

      expect(repo.current!.activeMode, equals(AppMode.student));
      expect(storage.lastSaved!.activeMode, equals(AppMode.student));
    });

    test('update throws StateError when load was not called', () async {
      final repo = AppRepository(storage: _FakeStorage());

      expect(
        () => repo.updateGeneral((g) => g, flush: true),
        throwsA(isA<StateError>()),
      );
    });

    test('updates leave current unchanged when patch throws', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);
      await repo.load();
      final before = repo.current;

      expect(
        () => repo.updateGeneral(
          (g) => throw Exception('boom'),
          flush: true,
        ),
        throwsException,
      );

      expect(repo.current, same(before));
      expect(storage.saveCount, equals(0));
    });
  });

  group('AppRepository write serialization', () {
    test('updates without flush still persist in registration order',
        () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);
      await repo.load();

      // Fire two updates without flush; the second depends on the first
      // through the chained pending write.
      await repo.updateGeneral(
        (g) => g.copyWith(dayStartHour: 5),
      );
      await repo.updateGeneral(
        (g) => g.copyWith(dayStartHour: 7),
      );
      await repo.flush();

      expect(storage.writeLog.length, equals(2));
      expect(
        storage.writeLog[0].generalMode.dayStartHour,
        equals(5),
      );
      expect(
        storage.writeLog[1].generalMode.dayStartHour,
        equals(7),
      );
    });

    test('flush awaits the most recent pending save', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      // Block the storage save so we can observe flush waiting.
      storage.gate = Completer<void>();
      final repo = AppRepository(storage: storage);
      await repo.load();

      await repo.updateGeneral(
        (g) => g.copyWith(dayStartHour: 9),
      );

      var flushDone = false;
      final flushFuture = repo.flush().then((_) => flushDone = true);

      // Give the event loop a chance; flush should still be pending.
      await Future<void>.delayed(Duration.zero);
      expect(flushDone, isFalse);

      storage.gate!.complete();
      await flushFuture;

      expect(flushDone, isTrue);
      expect(
        storage.lastSaved!.generalMode.dayStartHour,
        equals(9),
      );
    });

    test('save() replaces current and persists the snapshot', () async {
      final storage = _FakeStorage(
        initialResult: StorageLoadResult(
          data: _emptyApp(),
          recoveryStatus: RecoveryStatus.none,
        ),
      );
      final repo = AppRepository(storage: storage);
      await repo.load();
      final replacement = _emptyApp().copyWith(activeMode: AppMode.student);

      await repo.save(replacement);

      expect(repo.current!.activeMode, equals(AppMode.student));
      expect(storage.lastSaved!.activeMode, equals(AppMode.student));
    });
  });
}
