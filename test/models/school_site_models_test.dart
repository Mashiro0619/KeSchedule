import 'package:flutter_test/flutter_test.dart';
import 'package:sked/models/school_site_models.dart';

void main() {
  group('SchoolSite validation', () {
    test('accepts absolute http and https URLs with hosts', () {
      expect(
        const SchoolSite(
          name: 'School',
          loginUrl: 'https://school.example.edu/login',
        ).isValid,
        isTrue,
      );
      expect(
        const SchoolSite(
          name: 'School',
          loginUrl: 'http://school.example.edu/login',
        ).isValid,
        isTrue,
      );
    });

    test('rejects non-web and hostless login URLs', () {
      for (final url in [
        'javascript:alert(1)',
        'data:text/html,hello',
        'file:///etc/passwd',
        'https:///missing-host',
        '/relative/path',
      ]) {
        expect(
          SchoolSite(name: 'School', loginUrl: url).isValid,
          isFalse,
          reason: url,
        );
      }
    });

    test('decodeSchoolSites filters invalid web URLs', () {
      final sites = decodeSchoolSites('''
[
  {"name":"Valid","loginUrl":" https://school.example.edu/login "},
  {"name":"Script","loginUrl":"javascript:alert(1)"}
]
''');

      expect(sites, hasLength(1));
      expect(sites.single.loginUrl, 'https://school.example.edu/login');
    });
  });
}
