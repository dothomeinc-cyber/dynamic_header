import 'package:flutter/material.dart';
import '../models/header_slot.dart';
import '../models/header_animation_config.dart';
import '../utils/lerp_utils.dart';

/// Wraps a [HeaderSlot]'s child and applies the configured animations
/// based on the current scroll [progress] (0 = expanded, 1 = collapsed).
///
/// Used for **flexibleSpace** and **content** slots — NOT for fixed
/// leading/trailing action-bar items (those are handled by [FixedHeaderActions]).
///
/// Animation precedence:
/// 1. [HeaderSlot.hideOnCollapse] → invisible at progress ≥ 1
/// 2. [HeaderSlot.fadeOnCollapse] → opacity 1 → 0
/// 3. [HeaderSlot.scaleOnCollapse] → scale expandedScale → collapsedScale
/// 4. [HeaderSlot.slideOnCollapse] → translate expandedOffset → collapsedOffset
/// 5. Alignment lerp: expandedAlignment → collapsedAlignment (always active)
class AnimatedHeaderSlot extends StatelessWidget {
  final HeaderSlot slot;
  final double progress;
  final HeaderAnimationConfig animation;

  const AnimatedHeaderSlot({
    super.key,
    required this.slot,
    required this.progress,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    // ── 1. Hard hide ───────────────────────────────────────────────────────
    if (slot.hideOnCollapse && progress >= 0.99) {
      return const SizedBox.shrink();
    }

    // ── 2. Opacity ─────────────────────────────────────────────────────────
    double opacity = 1.0;
    if (slot.fadeOnCollapse && animation.enableFade) {
      // Fade out over the first 60 % of collapse so it's gone well before
      // fully collapsed.
      opacity = LerpUtils.rangeMapInverted(
        progress,
        inStart: 0.0,
        inEnd: 0.6,
      );
    }

    // ── 3. Scale ───────────────────────────────────────────────────────────
    double scale = slot.expandedScale;
    if (slot.scaleOnCollapse && animation.enableScale) {
      scale = LerpUtils.lerpDouble(
        slot.expandedScale,
        slot.collapsedScale,
        progress,
      );
    }

    // ── 4. Slide ───────────────────────────────────────────────────────────
    Offset slideOffset = slot.expandedOffset;
    if (slot.slideOnCollapse && animation.enableSlide) {
      slideOffset = LerpUtils.lerpOffset(
        slot.expandedOffset,
        slot.collapsedOffset,
        progress,
      );
    }

    // ── 5. Alignment ───────────────────────────────────────────────────────
    final alignment = LerpUtils.lerpAlignment(
      slot.expandedAlignment,
      slot.collapsedAlignment,
      progress,
    );

    // ── Compose transforms ─────────────────────────────────────────────────
    Widget child = Padding(padding: slot.padding, child: slot.child);

    if (slot.scaleOnCollapse && animation.enableScale) {
      child = Transform.scale(scale: scale.clamp(0.0, 2.0), child: child);
    }

    if (slot.slideOnCollapse && animation.enableSlide) {
      child = Transform.translate(offset: slideOffset, child: child);
    }

    if (slot.fadeOnCollapse && animation.enableFade) {
      child = Opacity(opacity: opacity.clamp(0.0, 1.0), child: child);
    }

    return Align(alignment: alignment, child: child);
  }
}
