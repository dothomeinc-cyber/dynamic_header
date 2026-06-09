import 'package:flutter/material.dart';

/// Typography configuration used by [ShrinkingText].
///
/// Font sizes are in **logical pixels** — [ShrinkingText] applies
/// [flutter_screenutil] `.sp` scaling when rendering.
class HeaderTextConfig {
  /// Font size when the header is fully expanded (progress = 0).
  final double expandedFontSize;

  /// Font size when the header is fully collapsed (progress = 1).
  final double collapsedFontSize;

  /// Max lines when fully expanded.
  final int expandedMaxLines;

  /// Max lines when fully collapsed (usually 1).
  final int collapsedMaxLines;

  final FontWeight expandedFontWeight;
  final FontWeight collapsedFontWeight;

  /// Text overflow behaviour when collapsed.
  final TextOverflow overflow;

  const HeaderTextConfig({
    this.expandedFontSize = 28.0,
    this.collapsedFontSize = 16.0,
    this.expandedMaxLines = 3,
    this.collapsedMaxLines = 1,
    this.expandedFontWeight = FontWeight.bold,
    this.collapsedFontWeight = FontWeight.w600,
    this.overflow = TextOverflow.ellipsis,
  });
}
