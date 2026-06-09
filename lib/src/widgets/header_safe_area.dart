import 'package:flutter/material.dart';

/// Safe-area wrapper for header content.
///
/// Applies device insets (notch, status bar, etc.) as padding rather than
/// using [SafeArea] directly, which would consume the constraints.
class HeaderSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const HeaderSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = false,
    this.left = true,
    this.right = true,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: top ? mediaQuery.padding.top : 0,
        bottom: bottom ? mediaQuery.padding.bottom : 0,
        left: left ? mediaQuery.padding.left : 0,
        right: right ? mediaQuery.padding.right : 0,
      ),
      child: child,
    );
  }
}
