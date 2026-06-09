import 'package:flutter/material.dart';

/// Colour configuration for [DynamicSliverHeader].
///
/// All colour fields are **non-nullable** with sensible defaults so you never
/// get a null-check crash in the delegate.
class HeaderColorConfig {
  /// Background colour when fully expanded (progress = 0).
  final Color expandedBackgroundColor;

  /// Background colour when fully collapsed (progress = 1).
  final Color collapsedBackgroundColor;

  /// Tint colour applied to the app-bar row (icons/text) when expanded.
  final Color? expandedIconColor;

  /// Tint colour applied to the app-bar row (icons/text) when collapsed.
  final Color? collapsedIconColor;

  /// Text colour when expanded (used by [ShrinkingText]).
  final Color? expandedTextColor;

  /// Text colour when collapsed (used by [ShrinkingText]).
  final Color? collapsedTextColor;

  /// Optional gradient drawn on top of the background.
  /// Useful for making text readable over images (e.g. a bottom scrim).
  final Gradient? expandedGradient;

  /// Opacity of [expandedGradient] at progress = 0. Lerps to 0 as collapsed.
  final double gradientOpacity;

  const HeaderColorConfig({
    this.expandedBackgroundColor = const Color(0xFF2196F3),
    this.collapsedBackgroundColor = const Color(0xFF2196F3),
    this.expandedIconColor,
    this.collapsedIconColor,
    this.expandedTextColor,
    this.collapsedTextColor,
    this.expandedGradient,
    this.gradientOpacity = 1.0,
  });
}
