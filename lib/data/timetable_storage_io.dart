import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/timetable_models.dart';
import 'timetable_storage.dart';

TimetableStorage createTimetableStorage() => IoTimetableStorage();

/// IO 平台继续落真实文件，用户自己备份或者排查数据时都更直观。
///
/// 写入策略（原子写 + 旋转 .bak）：
/// 1. 先把新内容写到 `Sked_data.json.tmp` 并 flush。
/// 2. 如果 `Sked_data.json` 存在，先把它重命名为 `Sked_data.json.bak`
///    （已有的 .bak 会被覆盖，只保留最近一份）。
/// 3. 把 `.tmp` 重命名为 `Sked_data.json`。
///
/// 加载策略：先尝试主文件；解析失败或主文件缺失则尝试 `.bak`；都失败则上报
/// [RecoveryStatus.failedBackupRestore]。
class IoTimetableStorage implements TimetableStorage {
  IoTimetableStorage({Future<Directory> Function()? directoryProvider})
    : _directoryProvider = directoryProvider ?? getApplicationDocumentsDirectory;

  static const _fileName = 'Sked_data.json';
  static const _backupSuffix = '.bak';
  static const _tempSuffix = '.tmp';

  final Future<Directory> Function() _directoryProvider;

  @override
  Future<StorageLoadResult> load() async {
    final main = await _resolveFile();
    final backup = File('${main.path}$_backupSuffix');

    final mainAttempt = await _tryDecode(main);
    if (mainAttempt.outcome == _Outcome.success) {
      return StorageLoadResult(
        data: mainAttempt.data,
        recoveryStatus: RecoveryStatus.none,
      );
    }

    // 主文件不存在 / 空内容：如果 .bak 也没有，就当首次启动；如果 .bak 有，
    // 说明上次写入崩在了 rename 之间，用 .bak 恢复。
    final backupAttempt = await _tryDecode(backup);
    if (mainAttempt.outcome == _Outcome.missing &&
        backupAttempt.outcome == _Outcome.missing) {
      return const StorageLoadResult.empty();
    }

    if (backupAttempt.outcome == _Outcome.success) {
      return StorageLoadResult(
        data: backupAttempt.data,
        recoveryStatus: RecoveryStatus.restoredFromBackup,
      );
    }

    // 主文件存在但损坏 / .bak 不存在或损坏：无法恢复任何数据。
    if (mainAttempt.outcome == _Outcome.corrupt ||
        backupAttempt.outcome == _Outcome.corrupt) {
      return const StorageLoadResult(
        data: null,
        recoveryStatus: RecoveryStatus.failedBackupRestore,
      );
    }

    // 兜底：主文件缺失 + .bak 缺失已经在上面拦截，这里走不到。
    return const StorageLoadResult.empty();
  }

  @override
  Future<void> save(AppData data) async {
    final main = await _resolveFile();
    final tmp = File('${main.path}$_tempSuffix');
    final backup = File('${main.path}$_backupSuffix');

    // 1. 写入 .tmp 并 flush，确保数据真的落盘。
    final raf = await tmp.open(mode: FileMode.write);
    try {
      await raf.writeString(data.encode());
      await raf.flush();
    } finally {
      await raf.close();
    }

    // 2. 旋转：把现有主文件移到 .bak（覆盖旧 .bak），再把 .tmp 升为主文件。
    if (await main.exists()) {
      if (await backup.exists()) {
        await backup.delete();
      }
      await main.rename(backup.path);
    }
    await tmp.rename(main.path);
  }

  @override
  Future<String> filePath() async {
    final file = await _resolveFile();
    return file.path;
  }

  Future<File> _resolveFile() async {
    final directory = await _directoryProvider();
    final filePath = path.join(directory.path, _fileName);
    return File(filePath);
  }

  Future<_DecodeAttempt> _tryDecode(File file) async {
    if (!await file.exists()) {
      return const _DecodeAttempt(_Outcome.missing, null);
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return const _DecodeAttempt(_Outcome.missing, null);
    }
    try {
      final data = AppData.decode(content);
      return _DecodeAttempt(_Outcome.success, data);
    } catch (_) {
      return const _DecodeAttempt(_Outcome.corrupt, null);
    }
  }
}

enum _Outcome { success, missing, corrupt }

class _DecodeAttempt {
  const _DecodeAttempt(this.outcome, this.data);

  final _Outcome outcome;
  final AppData? data;
}
