import 'package:flutter/material.dart';
import 'package:gapopa/utils/web_utils.dart';

/// A web-specific interceptor implementation
class WebInterceptor extends StatefulWidget {
  /// The child widget to wrap.
  final Widget child;
  
  /// Whether to prevent the default context menu.
  final bool preventDefaultContextMenu;

  const WebInterceptor({
    Key? key,
    required this.child,
    this.preventDefaultContextMenu = true,
  }) : super(key: key);

  @override
  State<WebInterceptor> createState() => _WebInterceptorState();
}

class _WebInterceptorState extends State<WebInterceptor> {
  @override
  void initState() {
    super.initState();
    if (widget.preventDefaultContextMenu) {
      // Disable context menu for the entire document
      WebUtils.disableContextMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
