import 'package:flutter/material.dart';
import '../models/header_color_config.dart';
import '../models/header_animation_config.dart';
import '../utils/lerp_utils.dart';

/// Draws the animated background of [DynamicSliverHeader].
///
/// Interpolates between [HeaderColorConfig.expandedBackgroundColor] and
/// [HeaderColorConfig.collapsedBackgroundColor] as [progress] moves 0 → 1.
///
/// Also supports:
/// - Optional full-bleed [backgroundImage] with a colour overlay that fades in.
/// - Optional [HeaderColorConfig.expandedGradient] scrim (e.g. bottom gradient
///   for text readability over images).
class HeaderBackground extends StatelessWidget {
  final double progress;
  final HeaderColorConfig colors;
  final HeaderAnimationConfig animation;

  /// Optional full-bleed image rendered behind everything.
  final ImageProvider? backgroundImage;

  /// Alignment of the background image. Defaults to [Alignment.topCenter].
  final Alignment imageAlignment;

  const HeaderBackground({
    super.key,
    required this.progress,
    required this.colors,
    required this.animation,
    this.backgroundImage,
    this.imageAlignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    // Lerp between expanded and collapsed background colours.
    final bg = animation.enableColorLerp
        ? LerpUtils.lerpColor(
            colors.expandedBackgroundColor,
            colors.collapsedBackgroundColor,
            progress,
          )!
        : colors.expandedBackgroundColor;

    if (backgroundImage != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed image
          Image(
            image: backgroundImage!,
            fit: BoxFit.cover,
            alignment: imageAlignment,
          ),
          // Optional gradient scrim fades out as collapsed
          if (colors.expandedGradient != null)
            Opacity(
              opacity:
                  ((1.0 - progress) * colors.gradientOpacity).clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: colors.expandedGradient),
                child: const SizedBox.expand(),
              ),
            ),
          // Colour overlay fades in as collapsed (tints the image)
          Opacity(
            opacity: progress.clamp(0.0, 1.0),
            child: ColoredBox(
              color: colors.collapsedBackgroundColor,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: bg),
        // Optional gradient scrim (no image case)
        if (colors.expandedGradient != null)
          Opacity(
            opacity:
                ((1.0 - progress) * colors.gradientOpacity).clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: colors.expandedGradient),
              child: const SizedBox.expand(),
            ),
          ),
      ],
    );
  }
}
