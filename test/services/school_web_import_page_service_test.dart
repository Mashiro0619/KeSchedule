import 'package:flutter_test/flutter_test.dart';
import 'package:sked/services/school_web_import_page_service.dart';

void main() {
  group('normalizeJavaScriptResult', () {
    test('treats null-like JavaScript results as empty content', () {
      expect(normalizeJavaScriptResult(null), '');
      expect(normalizeJavaScriptResult('null'), '');
      expect(normalizeJavaScriptResult(' undefined '), '');
    });

    test('decodes quoted JavaScript string results', () {
      expect(
        normalizeJavaScriptResult(r'"<html>\n<body>课表</body></html>"'),
        '<html>\n<body>课表</body></html>',
      );
    });

    test('keeps already-decoded string results unchanged', () {
      const html = '<html><body>Timetable</body></html>';

      expect(normalizeJavaScriptResult(html), html);
    });
  });
}
