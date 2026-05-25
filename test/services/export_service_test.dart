import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/services/export_service.dart';

void main() {
  group('ExportService platform helpers', () {
    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    test('detects Android through Flutter target platform', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      const service = ExportService();

      expect(service.isWeb, isFalse);
      expect(service.isAndroid, isTrue);
      expect(service.isWindows, isFalse);
    });

    test('detects Windows through Flutter target platform', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      const service = ExportService();

      expect(service.isWeb, isFalse);
      expect(service.isAndroid, isFalse);
      expect(service.isWindows, isTrue);
    });
  });
}
