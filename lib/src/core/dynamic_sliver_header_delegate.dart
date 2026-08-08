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

  // `HeaderSlot.==` intentionally ignores `child` (see header_slot.dart),
  // so it alone can't tell us whether a slot's *content* changed — only
  // whether its animation/layout flags did. We additionally compare
  // `child` by identity here: cheap, and correct in the common case where
  // callers hold widgets in `const` fields or otherwise return the same
  // instance across rebuilds when nothing changed. If a caller rebuilds a
  // brand-new (but visually identical) widget tree every time, this will
  // over-trigger rebuilds — the safe direction to err in.
  bool _slotChanged(HeaderSlot? a, HeaderSlot? b) {
    if (a == null && b == null) return false;
    if (a == null || b == null) return true;
    return a != b || !identical(a.child, b.child);
  }

  @override
  bool shouldRebuild(covariant DynamicSliverHeaderDelegate old) {
    return expandedHeight != old.expandedHeight ||
        collapsedHeight != old.collapsedHeight ||
        _slotChanged(leading, old.leading) ||
        trailing.length != old.trailing.length ||
        _trailingChanged(trailing, old.trailing) ||
        _slotChanged(flexibleSpace, old.flexibleSpace) ||
        _slotChanged(content, old.content) ||
        colors != old.colors ||
        layout != old.layout ||
        animation != old.animation ||
        scrollConfig != old.scrollConfig ||
        backgroundImage != old.backgroundImage;
  }

  bool _trailingChanged(List<HeaderSlot> a, List<HeaderSlot> b) {
    for (var i = 0; i < a.length; i++) {
      if (_slotChanged(a[i], b[i])) return true;
    }
    return false;
  }

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
    final currentH = ScrollMath.currentHeight(shrinkOffset, maxExtent, minExtent);

    // Bar row height — 48 scaled with screenutil
    final barRowHeight = layout.topPadding.h + layout.bottomPadding.h + 48.r;

    final flexPinned = flexibleSpace?.pinnedOnCollapse ?? false;
    final contentPinned = content?.pinnedOnCollapse ?? false;

    final flexInBarOpacity = animation.enableFade
        ? LerpUtils.rangeMap(curvedProgress, inStart: 0.6, inEnd: 1.0)
        : (curvedProgress >= 0.6 ? 1.0 : 0.0);

    final flexOutsideOpacity = animation.enableFade
        ? LerpUtils.rangeMapInverted(curvedProgress, inStart: 0.0, inEnd: 0.5)
        : 1.0;

    // When `content.pinnedOnCollapse` is true, the slot is anchored at the
    // top of the header (like the bar row) instead of sitting in a gap
    // below it, and always sized to the header's full *current* height
    // (`currentH`) rather than the constant bar-row band. This gives it
    // room to render its expanded, multi-line presentation while the
    // header is open, and still keeps it from being squeezed into a
    // near-zero gap as the header nears `collapsedHeight` — a pinned
    // slot's own animation (e.g. `ShrinkingText`) is what actually
    // produces the compact "lives alongside the bar row" look once
    // collapsed, not a shrinking layout box.
    final contentTop = layout.contentBelowBar && !contentPinned
        ? barRowHeight
        : 0.0;
    final contentHeight = contentPinned
        ? currentH.clamp(0.0, maxExtent)
        : (currentH - contentTop).clamp(0.0, maxExtent);

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
                top: contentPinned ? 0 : contentTop,
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
