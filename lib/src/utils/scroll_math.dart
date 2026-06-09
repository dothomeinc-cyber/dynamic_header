import 'package:flutter/animation.dart';

/// Math helpers for scroll-based progress calculations used by the delegate.
class ScrollMath {
  ScrollMath._();

  /// Convert raw [shrinkOffset] from [SliverPersistentHeaderDelegate.build]
  /// into a normalised progress value (0.0 = expanded, 1.0 = collapsed).
  static double calculateProgress(
    double shrinkOffset,
    double maxExtent,
    double minExtent,
  ) {
    final scrollDistance = maxExtent - minExtent;
    if (scrollDistance <= 0) return 0.0;
    return (shrinkOffset / scrollDistance).clamp(0.0, 1.0);
  }

  /// Interpolate between [start] and [end] at [progress] with [curve].
  static double interpolate(
    double start,
    double end,
    double progress,
    Curve curve,
  ) {
    final curvedProgress = curve.transform(progress.clamp(0.0, 1.0));
    return start + (end - start) * curvedProgress;
  }

  /// True when the header is fully collapsed (progress ≥ 0.99).
  static bool isFullyCollapsed(double progress) => progress >= 0.99;

  /// True when the header is fully expanded (progress ≤ 0.01).
  static bool isFullyExpanded(double progress) => progress <= 0.01;

  /// Returns the current rendered height of the header.
  static double currentHeight(double shrinkOffset, double maxExtent) =>
      (maxExtent - shrinkOffset).clamp(0.0, maxExtent);

  /// Snap decision: returns 0.0 (expand) or 1.0 (collapse).
  static double calculateSnapProgress(
    double currentProgress,
    double velocity,
    double velocityThreshold,
  ) {
    if (velocity.abs() > velocityThreshold) {
      return velocity > 0 ? 1.0 : 0.0;
    }
    return currentProgress > 0.5 ? 1.0 : 0.0;
  }
}
