import 'package:flutter/foundation.dart';

bool get supportsInAppWebView {
  if (kIsWeb) {
    return false;
  }
  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.windows => true,
    _ => false,
  };
}
