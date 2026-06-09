import 'package:flutter/material.dart';

/// Configuration for a header widget slot.
///
/// Each slot wraps a [child] widget and declares how it should behave
/// during the expand → collapse transition.
///
/// ### Leading / Trailing slots
/// | [fixed] = true  | Always visible, no animation applied. |
/// | [fixed] = false | Fades out as header collapses (progress 0 → 0.5). |
///
/// ### FlexibleSpace / Content slots
/// | [pinnedOnCollapse] = true  | Widget stays inside the bar row when collapsed. |
/// | [pinnedOnCollapse] = false | Widget scrolls away; use fade/scale/slide flags to animate. |
class HeaderSlot {
  /// Unique identifier for the slot (used for keying and debugging).
  final String id;

  /// The widget to display in this slot.
  final Widget child;

  /// **Leading / trailing only.**
  /// When true, the widget is always rendered at full opacity with no
  /// transform. It never fades, scales, or slides.
  final bool fixed;

  /// **FlexibleSpace / content only.**
  /// When true, the widget sticks inside the collapsed bar rather than
  /// scrolling off-screen.
  final bool pinnedOnCollapse;

  /// Widget becomes invisible (opacity → 0) when fully collapsed.
  final bool hideOnCollapse;

  /// Fade the widget out as the header collapses.
  final bool fadeOnCollapse;

  /// Scale the widget from [expandedScale] → [collapsedScale].
  final bool scaleOnCollapse;

  /// Translate the widget from [expandedOffset] → [collapsedOffset].
  final bool slideOnCollapse;

  /// Alignment when the header is fully expanded (progress = 0).
  final Alignment expandedAlignment;

  /// Alignment when the header is fully collapsed (progress = 1).
  final Alignment collapsedAlignment;

  /// Scale factor at progress = 0. Defaults to 1.0.
  final double expandedScale;

  /// Scale factor at progress = 1. Only used when [scaleOnCollapse] = true.
  final double collapsedScale;

  /// Translate offset at progress = 0. Defaults to [Offset.zero].
  final Offset expandedOffset;

  /// Translate offset at progress = 1. Only used when [slideOnCollapse] = true.
  final Offset collapsedOffset;

  /// Padding around the child widget inside its slot.
  final EdgeInsets padding;

  const HeaderSlot({
    required this.id,
    required this.child,
    this.fixed = false,
    this.pinnedOnCollapse = false,
    this.hideOnCollapse = false,
    this.fadeOnCollapse = false,
    this.scaleOnCollapse = false,
    this.slideOnCollapse = false,
    this.expandedAlignment = Alignment.center,
    this.collapsedAlignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.expandedScale = 1.0,
    this.collapsedScale = 1.0,
    this.expandedOffset = Offset.zero,
    this.collapsedOffset = Offset.zero,
  });
}
