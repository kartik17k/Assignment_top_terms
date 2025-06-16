# gapopa

A Flutter project featuring custom context menu widgets.

## Getting Started

This project is a starting point for a Flutter application with custom context menu functionality.

## Custom Widgets

### ContextMenu

A reusable widget that displays a custom context menu on right-click (or long press on mobile).

#### Features:
- Shows a context menu next to the wrapped child widget
- Auto-adjusts position to stay within screen bounds
- Keeps the child widget visible
- Adapts to screen size changes
- Works on both web and native platforms

#### Usage:

```dart
ContextMenu(
  child: YourWidget(),
  menuItems: [
    ContextMenuItem(text: 'Create', onTap: () { /* your action */ }),
    ContextMenuItem(text: 'Edit', onTap: () { /* your action */ }),
    ContextMenuItem(text: 'Remove', onTap: () { /* your action */ }),
  ],
)
```

### Interceptor

A widget that disables the default web browser context menu while maintaining functionality on native platforms.

#### Usage:

```dart
Interceptor(
  child: YourWidget(),
  preventDefaultContextMenu: true, // default is true
)
```

The `ContextMenu` widget uses `Interceptor` internally by default.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
