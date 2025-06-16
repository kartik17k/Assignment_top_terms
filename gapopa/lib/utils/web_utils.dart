import 'package:flutter/material.dart';
import 'dart:js' as js;

/// A utility class for web-specific operations
class WebUtils {
  /// Prevents the default context menu on the entire document
  static void disableContextMenu() {
    // Use JavaScript to disable the context menu
    js.context.callMethod('eval', ['''
      document.addEventListener('contextmenu', function(event) {
        event.preventDefault();
        return false;
      }, true);
    ''']);
  }
}
