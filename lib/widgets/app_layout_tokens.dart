import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

abstract final class AppRadii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 24.0;
  static const sheet = 28.0;
}

abstract final class AppBreakpoints {
  static const desktop = 900.0;
}

abstract final class AppInsets {
  static const page = EdgeInsets.all(AppSpacing.xl);
  static const listTile = EdgeInsets.symmetric(horizontal: AppSpacing.lg);
  static const bottomSheet = EdgeInsets.fromLTRB(
    AppSpacing.xl,
    AppSpacing.xl,
    AppSpacing.xl,
    AppSpacing.xl,
  );
}
