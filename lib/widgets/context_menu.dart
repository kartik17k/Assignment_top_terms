import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gapopa/widgets/interceptor.dart';

/// A widget that wraps around a child and displays a custom context menu
/// with "Create", "Edit" and "Remove" options on right click.
class ContextMenu extends StatefulWidget {
  /// The child widget to wrap.
  final Widget child;
  
  /// Custom menu items to display in the context menu.
  /// By default, it shows "Create", "Edit", and "Remove".
  final List<ContextMenuItem>? menuItems;
  
  /// Background color for the context menu.
  final Color? menuBackgroundColor;
  
  /// Text color for the menu items.
  final Color? menuItemTextColor;
  
  /// Border radius for the context menu.
  final BorderRadius? menuBorderRadius;
  
  /// Whether to use the Interceptor widget to prevent default context menu on Web.
  /// Default is true.
  final bool useInterceptor;

  const ContextMenu({
    Key? key,
    required this.child,
    this.menuItems,
    this.menuBackgroundColor,
    this.menuItemTextColor,
    this.menuBorderRadius,
    this.useInterceptor = true,
  }) : super(key: key);

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  /// Whether the context menu is currently visible.
  bool _isMenuVisible = false;
  
  /// The global position of the context menu.
  Offset _menuPosition = Offset.zero;
  
  /// A key to access the parent widget's render box.
  final GlobalKey _parentKey = GlobalKey();
  
  /// An overlay entry for displaying the context menu.
  OverlayEntry? _overlayEntry;

  /// The default menu items if none are provided.
  List<ContextMenuItem> get _defaultMenuItems => [
    ContextMenuItem(text: 'Create', onTap: () {}),
    ContextMenuItem(text: 'Edit', onTap: () {}),
    ContextMenuItem(text: 'Remove', onTap: () {}),
  ];

  /// The menu items to display in the context menu.
  List<ContextMenuItem> get menuItems => widget.menuItems ?? _defaultMenuItems;

  @override
  void dispose() {
    // Remove the overlay entry when the widget is disposed
    _removeMenu();
    super.dispose();
  }

  /// Handles the right-click event and shows the context menu.
  void _handleRightClick(TapDownDetails details) {
    // Get the global position of the tap
    final RenderBox renderBox = _parentKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localPosition = details.localPosition;
    final Offset globalPosition = renderBox.localToGlobal(localPosition);
    
    // Show the menu at this position
    _showMenu(globalPosition);
  }

  /// Shows the context menu at the given position.
  void _showMenu(Offset position) {
    setState(() {
      _isMenuVisible = true;
      _menuPosition = position;
    });

    // Create a new overlay entry for the menu
    _overlayEntry = _createOverlayEntry();
    
    // Insert the overlay into the overlay layer
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Removes the context menu from the screen.
  void _removeMenu() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    
    if (_isMenuVisible) {
      setState(() {
        _isMenuVisible = false;
      });
    }
  }

  /// Creates an overlay entry for the context menu.
  OverlayEntry _createOverlayEntry() {
    // Get the size of the screen
    final Size screenSize = MediaQuery.of(context).size;
    
    // Calculate the position of the menu to ensure it stays within screen bounds
    double dx = _menuPosition.dx;
    double dy = _menuPosition.dy;
    
    // Create the overlay entry
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _removeMenu,
          child: Stack(
            children: [
              Positioned(
                left: dx,
                top: dy,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Get the size of the menu to check boundaries
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Find render box of the menu
                      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                      if (renderBox != null) {
                        final menuSize = renderBox.size;
                        
                        // Check if the menu goes beyond screen boundaries
                        if (dx + menuSize.width > screenSize.width) {
                          dx = screenSize.width - menuSize.width;
                        }
                        
                        if (dy + menuSize.height > screenSize.height) {
                          dy = screenSize.height - menuSize.height;
                        }
                        
                        // Update the position if necessary
                        if (dx != _menuPosition.dx || dy != _menuPosition.dy) {
                          _overlayEntry?.markNeedsBuild();
                        }
                      }
                    });
                    
                    return Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.menuBackgroundColor ?? Theme.of(context).cardColor,
                          borderRadius: widget.menuBorderRadius ?? BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: IntrinsicWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: menuItems.map((item) {
                              return InkWell(
                                onTap: () {
                                  _removeMenu();
                                  item.onTap?.call();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    item.text,
                                    style: TextStyle(
                                      color: widget.menuItemTextColor ?? Colors.black87,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the child with a detector for right clicks
    Widget childWithDetector = GestureDetector(
      key: _parentKey,      onSecondaryTapDown: _handleRightClick,
      // For mobile platforms, we can use long press to trigger context menu
      onLongPress: () {
        final renderBox = _parentKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        _showMenu(position);
      },
      child: widget.child,
    );
    
    // Optionally wrap with Interceptor for web platforms
    if (widget.useInterceptor) {
      return Interceptor(child: childWithDetector);
    } else {
      return childWithDetector;
    }
  }
}

/// A class representing an item in the context menu.
class ContextMenuItem {
  /// The text to display for this menu item.
  final String text;
  
  /// The callback to execute when this menu item is tapped.
  final VoidCallback? onTap;
  
  /// Creates a new context menu item.
  ContextMenuItem({
    required this.text,
    this.onTap,
  });
}
