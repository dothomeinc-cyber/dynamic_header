import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/header_text_config.dart';
import '../models/header_animation_config.dart';
import '../utils/lerp_utils.dart';

/// A [Text] widget that smoothly transitions from a multi-line expanded style
/// to a single-line collapsed style as [progress] moves from 0 → 1.
///
/// Font size is scaled with [flutter_screenutil] `.sp` for consistent
/// sizing across different screen densities.
class ShrinkingText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final HeaderTextConfig config;
  final HeaderAnimationConfig animation;
  final double progress;
  final TextAlign textAlign;

  const ShrinkingText({
    super.key,
    required this.text,
    required this.config,
    required this.animation,
    required this.progress,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = animation.enableTextShrink
        ? (progress / animation.oneLineThreshold).clamp(0.0, 1.0)
        : 0.0;

    // Lerp between expanded and collapsed font sizes, then apply .sp scaling.
    final rawFontSize = LerpUtils.lerpDouble(
      config.expandedFontSize,
      config.collapsedFontSize,
      effectiveProgress,
    );

    final fontSize = rawFontSize.sp; // ← screenutil scaling

    final maxLines = effectiveProgress >= 1.0
        ? config.collapsedMaxLines
        : config.expandedMaxLines;

    final fontWeight = effectiveProgress > 0.5
        ? config.collapsedFontWeight
        : config.expandedFontWeight;

    return Text(
      text,
      maxLines: maxLines,
      overflow: config.overflow,
      textAlign: textAlign,
      style: (style ?? const TextStyle()).copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
