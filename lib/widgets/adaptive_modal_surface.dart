import 'package:flutter/material.dart';

import 'app_layout_tokens.dart';

class AdaptiveModalSurface extends StatefulWidget {
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
  State<AdaptiveModalSurface> createState() => _AdaptiveModalSurfaceState();
}

class _AdaptiveModalSurfaceState extends State<AdaptiveModalSurface> {
  var _dismissInProgress = false;

  Future<void> _dismissOnce() async {
    if (_dismissInProgress) {
      return;
    }
    setState(() => _dismissInProgress = true);
    final popped = await Navigator.of(context).maybePop();
    if (!popped && mounted) {
      setState(() => _dismissInProgress = false);
    }
  }

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
              onTap: widget.dismissOnOutsideTap ? _dismissOnce : null,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktopLike ? widget.maxWidth : width,
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadii.sheet),
                ),
                clipBehavior: Clip.antiAlias,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
