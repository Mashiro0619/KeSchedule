import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/utils/platform_capabilities.dart';

void main() {
  group('supportsInAppWebView', () {
    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    test('is true on supported app platforms', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(supportsInAppWebView, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(supportsInAppWebView, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      expect(supportsInAppWebView, isTrue);
    });

    test('is false on unsupported desktop platforms', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(supportsInAppWebView, isFalse);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(supportsInAppWebView, isFalse);
    });
  });
}
