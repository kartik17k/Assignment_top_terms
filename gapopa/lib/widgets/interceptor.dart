import 'package:flutter/material.dart';

/// A widget that intercepts and prevents the default browser context menu
/// on web and works seamlessly on native platforms as well.
/// 
/// Note: The actual prevention of the browser's context menu is handled
/// by JavaScript in the web/index.html file.
class Interceptor extends StatelessWidget {
  /// The child widget to wrap.
  final Widget child;
  
  /// Whether to prevent the default context menu.
  /// This property is kept for API compatibility but the actual
  /// prevention is done at the document level in index.html.
  final bool preventDefaultContextMenu;

  const Interceptor({
    Key? key,
    required this.child,
    this.preventDefaultContextMenu = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // The prevention of browser's context menu is now handled by
    // JavaScript code directly in index.html, so we just return the child
    return child;
  }
}
