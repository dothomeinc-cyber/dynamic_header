import 'package:flutter/material.dart';

/// Interpolation helpers used throughout the package.
class LerpUtils {
  LerpUtils._();

  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }

  static Offset lerpOffset(Offset a, Offset b, double t) {
    final tc = t.clamp(0.0, 1.0);
    return Offset(
      a.dx + (b.dx - a.dx) * tc,
      a.dy + (b.dy - a.dy) * tc,
    );
  }

  static Alignment lerpAlignment(Alignment a, Alignment b, double t) {
    final tc = t.clamp(0.0, 1.0);
    return Alignment(
      a.x + (b.x - a.x) * tc,
      a.y + (b.y - a.y) * tc,
    );
  }

  /// Returns null only if BOTH inputs are null.
  static Color? lerpColor(Color? a, Color? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return Color.lerp(a, b, t.clamp(0.0, 1.0));
  }

  /// Map [progress] from the sub-range [[inStart], [inEnd]] to [0, 1].
  ///
  /// Returns 0 when progress ≤ inStart, 1 when progress ≥ inEnd.
  /// Useful for staggering animations within a single scroll range.
  ///
  /// Example: fade out between 30 % and 60 % of collapse:
  /// ```dart
  /// final opacity = 1.0 - LerpUtils.rangeMap(progress, inStart: 0.3, inEnd: 0.6);
  /// ```
  static double rangeMap(
    double progress, {
    required double inStart,
    required double inEnd,
  }) {
    if (inEnd <= inStart) return progress >= inEnd ? 1.0 : 0.0;
    return ((progress - inStart) / (inEnd - inStart)).clamp(0.0, 1.0);
  }

  /// Inverse of [rangeMap]: returns 1.0 at [inStart] and 0.0 at [inEnd].
  static double rangeMapInverted(
    double progress, {
    required double inStart,
    required double inEnd,
  }) =>
      1.0 - rangeMap(progress, inStart: inStart, inEnd: inEnd);
}
