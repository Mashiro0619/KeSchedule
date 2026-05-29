import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_data.dart';
import '../models/general_schedule_data.dart';
import '../models/student_mode_data.dart';
import 'timetable_storage.dart';

/// 应用所有持久化数据的唯一入口。
///
/// 设计目标：
/// - 把"读子树 → 纯函数变换 → 串行写"的契约写进 API 层，避免调用方各自
///   维护 `_appData = _appData.copyWith(...)` + `storage.save(...)` 的散点写法。
/// - 写入队列串行化（最近一次 save 排在最末），不会因为并发 UI 操作互相覆盖。
/// - 默认 `flush: false` 允许调用方 fire-and-forget；关键路径（导入、删除日历、
///   删除事件、结构性迁移等）必须显式 `flush: true` 或在 await 后调 [flush]。
///
/// 注意：本类不持有任何业务逻辑，只负责 AppData 整体的读、合成、写。具体的
/// 课程/事件操作应该走 Service 层，然后通过本类的 patch API 落盘。
class AppRepository {
  AppRepository({required TimetableStorage storage}) : _storage = storage;

  final TimetableStorage _storage;

  AppData? _current;
  AppData? _lastPersisted;
  RecoveryStatus _lastRecoveryStatus = RecoveryStatus.none;
  Future<void> _pendingWrite = Future.value();
  var _currentRevision = 0;

  /// 上一次 [load] 的恢复状态。UI 必须消费这个值以决定是否给用户提示
  /// （比如 banner 或设置页通知）。
  RecoveryStatus get lastRecoveryStatus => _lastRecoveryStatus;

  /// 当前内存中的 AppData 快照。[load] 之前为 null。
  AppData? get current => _current;

  /// 从底层存储加载一次。返回值为 null 表示首次启动或彻底无数据。
  ///
  /// 加载结果会被缓存到 [current]，恢复状态写入 [lastRecoveryStatus]。
  Future<AppData?> load() async {
    final result = await _storage.load();
    _lastRecoveryStatus = result.recoveryStatus;
    _current = result.data;
    _lastPersisted = result.data;
    _currentRevision += 1;
    return _current;
  }

  /// 整份替换当前 AppData，并立即落盘（默认 flush=true，因为整份替换基本
  /// 都发生在导入、初始化等不能丢的场景）。
  Future<void> save(AppData data, {bool flush = true}) async {
    final revision = _replaceCurrent(data);
    final pendingWrite = _enqueueWrite(data);
    if (flush) {
      await _awaitOrRollback(pendingWrite, revision);
    }
  }

  /// 通用模式子树的事务式更新。
  ///
  /// `patch` 必须是纯函数：拿到当前 [GeneralScheduleData] 返回新的子树。
  /// 抛异常时 [current] 不会变化，也不会触发写入。
  Future<void> updateGeneral(
    GeneralScheduleData Function(GeneralScheduleData) patch, {
    bool flush = false,
  }) async {
    final current = _requireCurrent();
    final updatedSubtree = patch(current.generalMode);
    final updated = current.copyWith(generalMode: updatedSubtree);
    final revision = _replaceCurrent(updated);
    final pendingWrite = _enqueueWrite(updated);
    if (flush) {
      await _awaitOrRollback(pendingWrite, revision);
    }
  }

  /// 学生模式子树的事务式更新。语义同 [updateGeneral]。
  Future<void> updateStudent(
    StudentModeData Function(StudentModeData) patch, {
    bool flush = false,
  }) async {
    final current = _requireCurrent();
    final updatedSubtree = patch(current.studentMode);
    final updated = current.copyWith(studentMode: updatedSubtree);
    final revision = _replaceCurrent(updated);
    final pendingWrite = _enqueueWrite(updated);
    if (flush) {
      await _awaitOrRollback(pendingWrite, revision);
    }
  }

  /// 设置类字段（theme/locale/privacy/...）的事务式更新。
  ///
  /// 因为这些字段平铺在 AppData 顶层，没有独立子树，patch 直接拿到整份
  /// AppData。约定调用方只修改与"设置"相关的字段，不要在这里改业务数据。
  Future<void> updateSettings(
    AppData Function(AppData) patch, {
    bool flush = false,
  }) async {
    final current = _requireCurrent();
    final updated = patch(current);
    final revision = _replaceCurrent(updated);
    final pendingWrite = _enqueueWrite(updated);
    if (flush) {
      await _awaitOrRollback(pendingWrite, revision);
    }
  }

  /// 等待所有已排队的写入完成。
  ///
  /// 关键操作（导入、替换数据、删除日历/事件、结构性迁移）调用方应该
  /// 在 update 后 `await flush()` 以确保数据真的落盘后再返回 UI。
  Future<void> flush() => _pendingWrite;

  Future<String?> filePath() => _storage.filePath();

  AppData _requireCurrent() {
    final current = _current;
    if (current == null) {
      throw StateError(
        'AppRepository used before load(); call load() once at startup.',
      );
    }
    return current;
  }

  int _replaceCurrent(AppData data) {
    _current = data;
    _currentRevision += 1;
    return _currentRevision;
  }

  Future<void> _awaitOrRollback(Future<void> pendingWrite, int revision) async {
    try {
      await pendingWrite;
    } catch (_) {
      if (_currentRevision == revision) {
        _current = _lastPersisted;
        _currentRevision += 1;
      }
      rethrow;
    }
  }

  Future<void> _enqueueWrite(AppData data) {
    final write = _pendingWrite
        .catchError((e) {
          debugPrint(
            'AppRepository: previous write failed; continuing queue: $e',
          );
        })
        .then((_) async {
          await _storage.save(data);
          _lastPersisted = data;
        });
    _pendingWrite = write;
    return write;
  }
}
