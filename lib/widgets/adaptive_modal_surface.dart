import 'package:flutter/material.dart';

import 'app_layout_tokens.dart';

class AdaptiveModalSurface extends StatelessWidget {
  const AdaptiveModalSurface({
    super.key,
    required this.child,
    required this.maxWidth,
    this.dismissOnOutsideTap = false,
  });

  final Widget child;
  final double maxWidth;
  final bool dismissOnOutsideTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktopLike = width >= AppBreakpoints.desktop;

    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: dismissOnOutsideTap
                  ? () => Navigator.of(context).maybePop()
                  : null,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktopLike ? maxWidth : width,
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadii.sheet),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
