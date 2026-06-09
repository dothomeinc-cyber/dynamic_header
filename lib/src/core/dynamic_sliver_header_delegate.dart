import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/header_slot.dart';
import '../models/header_animation_config.dart';
import '../models/header_color_config.dart';
import '../models/header_layout_config.dart';
import '../models/header_scroll_config.dart';
import '../core/header_progress.dart';
import '../utils/scroll_math.dart';
import '../utils/lerp_utils.dart';
import '../widgets/header_background.dart';
import '../widgets/fixed_header_actions.dart';
import '../widgets/animated_header_slot.dart';

/// The [SliverPersistentHeaderDelegate] that powers [DynamicSliverHeader].
///
/// All internal dimensions are scaled with [flutter_screenutil].
class DynamicSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;

  final HeaderSlot? leading;
  final List<HeaderSlot> trailing;
  final HeaderSlot? flexibleSpace;
  final HeaderSlot? content;

  final HeaderColorConfig colors;
  final HeaderLayoutConfig layout;
  final HeaderAnimationConfig animation;
  final HeaderScrollConfig? scrollConfig;
  final ImageProvider? backgroundImage;

  const DynamicSliverHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    this.leading,
    this.trailing = const [],
    this.flexibleSpace,
    this.content,
    required this.colors,
    required this.layout,
    required this.animation,
    this.scrollConfig,
    this.backgroundImage,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant DynamicSliverHeaderDelegate old) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final rawProgress = ScrollMath.calculateProgress(
      shrinkOffset,
      maxExtent,
      minExtent,
    );
    final curvedProgress = animation.curve.transform(rawProgress);
    final currentH = ScrollMath.currentHeight(shrinkOffset, maxExtent);

    // Bar row height — 48 scaled with screenutil
    final barRowHeight = layout.topPadding.h + layout.bottomPadding.h + 48.r;

    final flexPinned = flexibleSpace?.pinnedOnCollapse ?? false;

    final flexInBarOpacity = animation.enableFade
        ? LerpUtils.rangeMap(curvedProgress, inStart: 0.6, inEnd: 1.0)
        : (curvedProgress >= 0.6 ? 1.0 : 0.0);

    final flexOutsideOpacity = animation.enableFade
        ? LerpUtils.rangeMapInverted(curvedProgress, inStart: 0.0, inEnd: 0.5)
        : 1.0;

    final contentTop = layout.contentBelowBar ? barRowHeight : 0.0;
    final contentHeight = (currentH - contentTop).clamp(0.0, maxExtent);

    return HeaderProgress(
      progress: rawProgress,
      curvedProgress: curvedProgress,
      height: currentH,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            // Layer 1: Background
            Positioned.fill(
              child: HeaderBackground(
                progress: curvedProgress,
                colors: colors,
                animation: animation,
                backgroundImage: backgroundImage,
              ),
            ),

            // Layer 2: Content slot
            if (content != null && contentHeight > 0)
              Positioned(
                top: contentTop,
                left: 0,
                right: 0,
                height: contentHeight,
                child: AnimatedHeaderSlot(
                  slot: content!,
                  progress: curvedProgress,
                  animation: animation,
                ),
              ),

            // Layer 3: FlexibleSpace outside bar (non-pinned)
            if (flexibleSpace != null && !flexPinned)
              Positioned(
                top: barRowHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: flexOutsideOpacity.clamp(0.0, 1.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: layout.horizontalPadding.w,
                      ),
                      child: flexibleSpace!.child,
                    ),
                  ),
                ),
              ),

            // Layer 4: FixedHeaderActions bar row
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FixedHeaderActions(
                leading: leading,
                trailing: trailing,
                progress: curvedProgress,
                layout: layout,
                animation: animation,
                flexibleSpaceInBar: (flexPinned && flexibleSpace != null)
                    ? flexibleSpace!.child
                    : null,
                flexibleSpaceInBarOpacity: flexInBarOpacity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
