import 'migration.dart';
import 'migration_runner.dart';

/// 当前 AppData JSON 的目标版本号。
///
/// 修改步骤：
/// 1. 把这里的常量 +1。
/// 2. 在 [appDataMigrations] 注册新的 `from: 旧版本, to: 新版本` 实现。
/// 3. 编写对应的单元测试，确认旧数据能升级、新数据 round-trip 保版本号。
const int appDataCurrentSchemaVersion = 1;

/// 已注册的 AppData 顶层迁移列表。
///
/// 当前没有需要执行的迁移，保留空列表用于：
/// - 后续 schema 演进时直接追加。
/// - 在 [appDataMigrationRunner] 里作为单一注册点，避免逻辑散落到 fromJson。
const List<Migration> appDataMigrations = <Migration>[];

/// AppData 加载路径统一使用的 runner。
const MigrationRunner appDataMigrationRunner = MigrationRunner(
  targetVersion: appDataCurrentSchemaVersion,
  migrations: appDataMigrations,
);
