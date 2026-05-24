/// 数据格式单步迁移：把 `from` 版的 JSON 升级到 `to` 版。
///
/// 实现必须满足：
/// - `to == from + 1`（runner 期望严格逐版本推进，方便组合）。
/// - `apply` 是纯函数，不修改入参 map。
/// - 返回的 map 不需要写 `schemaVersion`，runner 会统一打上。
abstract class Migration {
  const Migration();

  int get from;

  int get to;

  Map<String, dynamic> apply(Map<String, dynamic> json);
}

class MigrationException implements Exception {
  const MigrationException(this.message);

  final String message;

  @override
  String toString() => 'MigrationException: $message';
}
