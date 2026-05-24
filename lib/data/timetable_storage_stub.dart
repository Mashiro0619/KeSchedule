import 'package:shared_preferences/shared_preferences.dart';

import '../models/timetable_models.dart';
import 'timetable_storage.dart';

TimetableStorage createTimetableStorage() => _BrowserTimetableStorage();

/// Web 没有稳定的本地文件路径，就退回浏览器存储，但数据格式还是保持同一份 JSON。
class _BrowserTimetableStorage implements TimetableStorage {
  static const _storageKey = 'Sked_app_data';

  @override
  Future<StorageLoadResult> load() async {
    final preferences = await SharedPreferences.getInstance();
    final content = preferences.getString(_storageKey);
    if (content == null || content.trim().isEmpty) {
      return const StorageLoadResult.empty();
    }
    try {
      return StorageLoadResult(
        data: AppData.decode(content),
        recoveryStatus: RecoveryStatus.none,
      );
    } catch (_) {
      // 浏览器没有 .bak 后备，只能上报失败让 UI 提示用户。
      return const StorageLoadResult(
        data: null,
        recoveryStatus: RecoveryStatus.failedBackupRestore,
      );
    }
  }

  @override
  Future<void> save(AppData data) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, data.encode());
  }

  @override
  Future<String?> filePath() async =>
      'browser://local-storage/Sked_app_data';
}
