import 'package:flutter/material.dart';

/// Controls the global animation behaviour of [DynamicSliverHeader].
///
/// Per-slot flags ([HeaderSlot.fadeOnCollapse], etc.) are opt-in on each slot.
/// This config acts as a master switch and global tuning knob.
class HeaderAnimationConfig {
  /// Easing curve applied to the raw scroll progress (0 → 1).
  final Curve curve;

  /// Master switch: allow fade animations on any slot.
  final bool enableFade;

  /// Master switch: allow scale animations on any slot.
  final bool enableScale;

  /// Master switch: allow slide/translate animations on any slot.
  final bool enableSlide;

  /// Lerp the background colour from expanded → collapsed colour.
  final bool enableColorLerp;

  /// Animate [ShrinkingText] from multi-line expanded to single-line collapsed.
  final bool enableTextShrink;

  /// Snap the header fully open or closed when the user releases mid-scroll.
  /// Only works when [HeaderScrollConfig.snap] = true.
  final bool enableSnap;

  /// Progress threshold (0–1) at which [ShrinkingText] switches to
  /// [HeaderTextConfig.collapsedMaxLines]. Default 0.9.
  final double oneLineThreshold;

  /// Logical pixels of scroll over which the background colour fully transitions.
  final double colorChangeScrollDistance;

  /// Duration for snap animations.
  final Duration snapDuration;

  const HeaderAnimationConfig({
    this.curve = Curves.easeOutCubic,
    this.enableFade = true,
    this.enableScale = true,
    this.enableSlide = true,
    this.enableColorLerp = true,
    this.enableTextShrink = true,
    this.enableSnap = false,
    this.oneLineThreshold = 0.9,
    this.colorChangeScrollDistance = 120.0,
    this.snapDuration = const Duration(milliseconds: 300),
  });

  /// No animations at all — useful for debugging layout.
  static const HeaderAnimationConfig none = HeaderAnimationConfig(
    enableFade: false,
    enableScale: false,
    enableSlide: false,
    enableColorLerp: false,
    enableTextShrink: false,
  );
}
