import 'package:flutter_test/flutter_test.dart';
import 'package:sked/services/privacy_service.dart';

void main() {
  group('extractPrivacyPolicyVersion', () {
    test('parses meta attributes regardless of order', () {
      final version = extractPrivacyPolicyVersion(
        '<meta content="2026-05-24" data-owner="sked" '
        'name="privacy-policy-version">',
      );

      expect(version, '2026-05-24');
    });

    test('parses mixed-case tags and single quoted attributes', () {
      final version = extractPrivacyPolicyVersion(
        "<META NAME='privacy-policy-version' CONTENT=' 2026-05-25 '>",
      );

      expect(version, '2026-05-25');
    });

    test('ignores empty privacy policy version content', () {
      expect(
        extractPrivacyPolicyVersion(
          '<meta name="privacy-policy-version" content="  ">',
        ),
        isNull,
      );
    });
  });
}
