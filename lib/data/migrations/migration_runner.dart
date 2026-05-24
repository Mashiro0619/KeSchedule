import 'migration.dart';

/// 顶层 AppData JSON 的版本迁移引擎。
///
/// 用法：
/// ```
/// final runner = MigrationRunner(
///   targetVersion: 2,
///   migrations: const [MigrationV1ToV2()],
/// );
/// final upgraded = runner.run(rawJson);
/// ```
///
/// 约束：
/// - 入参 map 不会被修改。
/// - 缺失 `schemaVersion` 视为 v1。
/// - 数据版本高于 target 抛 [MigrationException]，本应用不做降级。
/// - 中间断链（缺少某一步 migration）抛 [MigrationException]。
class MigrationRunner {
  const MigrationRunner({
    required this.targetVersion,
    required this.migrations,
  });

  final int targetVersion;
  final List<Migration> migrations;

  Map<String, dynamic> run(Map<String, dynamic> input) {
    final currentVersion = _readVersion(input);

    if (currentVersion > targetVersion) {
      throw MigrationException(
        'Data schemaVersion $currentVersion exceeds supported '
        'targetVersion $targetVersion; downgrade is not supported.',
      );
    }

    var working = Map<String, dynamic>.from(input);
    var version = currentVersion;

    while (version < targetVersion) {
      final next = _findMigrationFrom(version);
      if (next == null) {
        throw MigrationException(
          'No migration registered from schemaVersion $version '
          'to $targetVersion.',
        );
      }
      working = Map<String, dynamic>.from(next.apply(working));
      version = next.to;
    }

    working['schemaVersion'] = version;
    return working;
  }

  Migration? _findMigrationFrom(int version) {
    for (final m in migrations) {
      if (m.from == version) return m;
    }
    return null;
  }

  static int _readVersion(Map<String, dynamic> json) {
    final raw = json['schemaVersion'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return 1;
  }
}
