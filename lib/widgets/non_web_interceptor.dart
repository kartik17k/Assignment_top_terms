import 'package:flutter/material.dart';

/// A placeholder implementation for non-web platforms
class NonWebInterceptor extends StatelessWidget {
  /// The child widget to wrap.
  final Widget child;
  
  /// Whether to prevent the default context menu (ignored on non-web).
  final bool preventDefaultContextMenu;

  const NonWebInterceptor({
    Key? key,
    required this.child,
    this.preventDefaultContextMenu = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // On non-web platforms, just return the child
    return child;
  }
}
