import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sked/data/migrations/app_data_migrations.dart';
import 'package:sked/data/migrations/migration.dart';
import 'package:sked/models/app_data.dart';
import 'package:sked/models/app_mode.dart';

void main() {
  group('AppData schemaVersion', () {
    test('toJson always writes the current schemaVersion', () {
      final data = AppData(
        activeMode: AppMode.general,
        studentMode: AppData.fromJson(const {}).studentMode,
        generalMode: AppData.fromJson(const {}).generalMode,
      );

      final json = data.toJson();

      expect(json['schemaVersion'], equals(appDataCurrentSchemaVersion));
    });

    test('encode -> decode round-trips schemaVersion to current', () {
      final original = AppData.fromJson(const {});
      final encoded = original.encode();

      final decoded = AppData.decode(encoded);
      final reencoded = jsonDecode(decoded.encode()) as Map<String, dynamic>;

      expect(reencoded['schemaVersion'], equals(appDataCurrentSchemaVersion));
    });

    test('fromJson accepts raw maps without schemaVersion (legacy)', () {
      // No schemaVersion -> treated as v1 by runner -> still upgrades cleanly.
      final json = <String, dynamic>{'activeMode': 'general'};

      // Should not throw.
      final data = AppData.fromJson(json);

      expect(data.activeMode, equals(AppMode.general));
    });

    test('fromJson throws MigrationException for future schemaVersion', () {
      final json = <String, dynamic>{
        'schemaVersion': appDataCurrentSchemaVersion + 99,
      };

      expect(() => AppData.fromJson(json), throwsA(isA<MigrationException>()));
    });

    test('fromJson rejects future schemaVersion encoded as a string', () {
      final json = <String, dynamic>{
        'schemaVersion': '${appDataCurrentSchemaVersion + 99}',
      };

      expect(() => AppData.fromJson(json), throwsA(isA<MigrationException>()));
    });

    test('decode runs migrations before constructing AppData', () {
      // Synthesize a JSON document at the current schemaVersion.
      final source = jsonEncode({
        'schemaVersion': appDataCurrentSchemaVersion,
        'activeMode': 'student',
      });

      final data = AppData.decode(source);

      expect(data.activeMode, equals(AppMode.student));
    });
  });
}
