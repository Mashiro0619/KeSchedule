import '../models/timetable_models.dart';
import 'timetable_storage_stub.dart'
    if (dart.library.io) 'timetable_storage_io.dart';

/// 启动加载时区分"主文件可用"、"从备份恢复"、"备份也坏了"三种状态。
///
/// UI 拿到 [restoredFromBackup] 必须给用户可见提示（说明数据已回退到上一份备份），
/// 拿到 [failedBackupRestore] 必须告知用户主备份都损坏、当前用的是默认初始化。
enum RecoveryStatus {
  /// 首次启动 / 主文件正常加载 / Web 平台等没有备份概念的场景。
  none,

  /// 主文件损坏（或缺失但 .bak 存在），从 .bak 成功恢复。
  restoredFromBackup,

  /// 主文件和 .bak 都损坏，无法恢复任何数据。
  failedBackupRestore,
}

class StorageLoadResult {
  const StorageLoadResult({
    required this.data,
    required this.recoveryStatus,
  });

  const StorageLoadResult.empty()
    : data = null,
      recoveryStatus = RecoveryStatus.none;

  final AppData? data;
  final RecoveryStatus recoveryStatus;
}

/// 这里只管整份 AppData 的读写，至于落文件还是浏览器存储，让平台层自己决定。
abstract class TimetableStorage {
  factory TimetableStorage() => createTimetableStorage();

  /// 返回结果中 [StorageLoadResult.data] 为 null 表示首次启动或彻底无数据；
  /// [StorageLoadResult.recoveryStatus] 必须被上层用于决定是否提示用户。
  Future<StorageLoadResult> load();

  /// 统一按整份快照写回，省得在不同平台维护细碎的增量更新逻辑。
  Future<void> save(AppData data);

  /// 主要给设置页和排查问题时用；Web 没真实路径的话给个虚拟地址就行。
  Future<String?> filePath();
}
