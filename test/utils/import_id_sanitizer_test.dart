import 'package:flutter_test/flutter_test.dart';
import 'package:sked/utils/import_id_sanitizer.dart';

void main() {
  group('sanitizeImportedId', () {
    test('keeps safe imported ids unchanged', () {
      expect(sanitizeImportedId('abc.DEF-123_4'), 'abc.DEF-123_4');
    });

    test('collapses unsafe characters and trims underscores', () {
      expect(
        sanitizeImportedId(' team|sync/room@example.com '),
        'team_sync_room_example.com',
      );
    });

    test('returns empty when no safe characters remain', () {
      expect(sanitizeImportedId(' ||| '), '');
    });

    test('caps sanitized ids at the configured length', () {
      expect(sanitizeImportedId('abcdef', maxLength: 4), 'abcd');
    });
  });
}
