import 'package:flutter_test/flutter_test.dart';
import 'package:sked/services/school_import_content_sanitizer.dart';

void main() {
  group('SchoolImportContentSanitizer', () {
    test('preserves table span attributes used by timetable layouts', () {
      const source = '''
<table>
  <tr>
    <td class="course" rowspan="2" colspan="3" onclick="x()">Math</td>
  </tr>
</table>
''';

      final sanitized = SchoolImportContentSanitizer.sanitize(source);

      expect(sanitized, contains('rowspan="2"'));
      expect(sanitized, contains('colspan="3"'));
      expect(sanitized, isNot(contains('class=')));
      expect(sanitized, isNot(contains('onclick=')));
    });

    test('removes script blocks and caps very large content', () {
      final oversizedText = List.filled(
        SchoolImportContentSanitizer.maxContentLength + 10,
        'A',
      ).join();
      final source = '<script>alert(1)</script>$oversizedText';

      final sanitized = SchoolImportContentSanitizer.sanitize(source);

      expect(sanitized, isNot(contains('alert')));
      expect(sanitized.length, SchoolImportContentSanitizer.maxContentLength);
    });

    test('removes dangling unsafe block tags', () {
      const source = '''
<table><tr><td>Math</td></tr></table>
<script>window.leak = "not timetable";
''';

      final sanitized = SchoolImportContentSanitizer.sanitize(source);

      expect(sanitized, contains('Math'));
      expect(sanitized, isNot(contains('window.leak')));
      expect(sanitized, isNot(contains('not timetable')));
    });
  });
}
