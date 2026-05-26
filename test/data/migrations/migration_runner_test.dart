import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/migrations/migration.dart';
import 'package:sked/data/migrations/migration_runner.dart';

void main() {
  group('MigrationRunner', () {
    test(
      'returns json unchanged when current version already matches target',
      () {
        final runner = MigrationRunner(targetVersion: 1, migrations: const []);
        final input = {'schemaVersion': 1, 'foo': 'bar'};

        final result = runner.run(input);

        expect(result, equals({'schemaVersion': 1, 'foo': 'bar'}));
      },
    );

    test('treats missing schemaVersion as version 1', () {
      final runner = MigrationRunner(targetVersion: 1, migrations: const []);
      final input = {'foo': 'bar'};

      final result = runner.run(input);

      expect(result['schemaVersion'], equals(1));
      expect(result['foo'], equals('bar'));
    });

    test('applies single migration from v1 to v2', () {
      final migration = _FnMigration(
        from: 1,
        to: 2,
        transform: (json) => {...json, 'added': 'in_v2'},
      );
      final runner = MigrationRunner(targetVersion: 2, migrations: [migration]);

      final result = runner.run({'schemaVersion': 1, 'original': true});

      expect(result['schemaVersion'], equals(2));
      expect(result['original'], isTrue);
      expect(result['added'], equals('in_v2'));
    });

    test('applies multiple migrations sequentially v1 -> v2 -> v3', () {
      final m1to2 = _FnMigration(
        from: 1,
        to: 2,
        transform: (json) => {...json, 'step': '${json['step'] ?? ''}a'},
      );
      final m2to3 = _FnMigration(
        from: 2,
        to: 3,
        transform: (json) => {...json, 'step': '${json['step'] ?? ''}b'},
      );
      final runner = MigrationRunner(
        targetVersion: 3,
        migrations: [m1to2, m2to3],
      );

      final result = runner.run({'schemaVersion': 1});

      expect(result['schemaVersion'], equals(3));
      expect(result['step'], equals('ab'));
    });

    test('applies migrations in chain regardless of registration order', () {
      final m2to3 = _FnMigration(
        from: 2,
        to: 3,
        transform: (json) => {...json, 'two': true},
      );
      final m1to2 = _FnMigration(
        from: 1,
        to: 2,
        transform: (json) => {...json, 'one': true},
      );
      final runner = MigrationRunner(
        targetVersion: 3,
        migrations: [m2to3, m1to2],
      );

      final result = runner.run({'schemaVersion': 1});

      expect(result['one'], isTrue);
      expect(result['two'], isTrue);
      expect(result['schemaVersion'], equals(3));
    });

    test(
      'throws when data version exceeds target (downgrade not supported)',
      () {
        final runner = MigrationRunner(targetVersion: 1, migrations: const []);

        expect(
          () => runner.run({'schemaVersion': 5}),
          throwsA(isA<MigrationException>()),
        );
      },
    );

    test('throws when schemaVersion is present but malformed', () {
      final runner = MigrationRunner(targetVersion: 1, migrations: const []);

      for (final value in ['future', '1.0', 1.5, null]) {
        expect(
          () => runner.run({'schemaVersion': value}),
          throwsA(isA<MigrationException>()),
        );
      }
    });

    test('throws when no migration path bridges versions', () {
      final m1to2 = _FnMigration(from: 1, to: 2, transform: (json) => json);
      // Missing v2 -> v3 migration; target is v3.
      final runner = MigrationRunner(targetVersion: 3, migrations: [m1to2]);

      expect(
        () => runner.run({'schemaVersion': 1}),
        throwsA(isA<MigrationException>()),
      );
    });

    test('throws when a migration skips a schema version', () {
      final m1to3 = _FnMigration(from: 1, to: 3, transform: (json) => json);
      final runner = MigrationRunner(targetVersion: 3, migrations: [m1to3]);

      expect(
        () => runner.run({'schemaVersion': 1}),
        throwsA(isA<MigrationException>()),
      );
    });

    test('does not mutate input map', () {
      final m1to2 = _FnMigration(
        from: 1,
        to: 2,
        transform: (json) => {...json, 'added': true},
      );
      final runner = MigrationRunner(targetVersion: 2, migrations: [m1to2]);
      final input = {'schemaVersion': 1, 'original': 'x'};

      runner.run(input);

      expect(input, equals({'schemaVersion': 1, 'original': 'x'}));
    });

    test('does not expose nested input structures to migrations', () {
      final m1to2 = _FnMigration(
        from: 1,
        to: 2,
        transform: (json) {
          (json['nested'] as Map<String, dynamic>)['value'] = 'changed';
          (json['items'] as List<dynamic>).add('new-item');
          return json;
        },
      );
      final runner = MigrationRunner(targetVersion: 2, migrations: [m1to2]);
      final input = {
        'schemaVersion': 1,
        'nested': {'value': 'original'},
        'items': ['old-item'],
      };

      final result = runner.run(input);

      expect(
        input,
        equals({
          'schemaVersion': 1,
          'nested': {'value': 'original'},
          'items': ['old-item'],
        }),
      );
      expect(result['nested'], equals({'value': 'changed'}));
      expect(result['items'], equals(['old-item', 'new-item']));
    });
  });
}

class _FnMigration extends Migration {
  _FnMigration({required int from, required int to, required this.transform})
    : _from = from,
      _to = to;

  final int _from;
  final int _to;
  final Map<String, dynamic> Function(Map<String, dynamic>) transform;

  @override
  int get from => _from;

  @override
  int get to => _to;

  @override
  Map<String, dynamic> apply(Map<String, dynamic> json) => transform(json);
}
