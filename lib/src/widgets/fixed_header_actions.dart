import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/header_slot.dart';
import '../models/header_layout_config.dart';
import '../models/header_animation_config.dart';
import '../utils/lerp_utils.dart';

/// Renders the persistent leading/trailing action-bar row.
///
/// All layout dimensions from [HeaderLayoutConfig] are scaled with
/// [flutter_screenutil] at render time (.r, .w, .h).
class FixedHeaderActions extends StatelessWidget {
  final HeaderSlot? leading;
  final List<HeaderSlot> trailing;
  final double progress;
  final HeaderLayoutConfig layout;
  final HeaderAnimationConfig animation;
  final Widget? flexibleSpaceInBar;
  final double flexibleSpaceInBarOpacity;

  const FixedHeaderActions({
    super.key,
    this.leading,
    required this.trailing,
    required this.progress,
    required this.layout,
    required this.animation,
    this.flexibleSpaceInBar,
    this.flexibleSpaceInBarOpacity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: layout.topPadding.h,
        left: layout.horizontalPadding.w,
        right: layout.horizontalPadding.w,
        bottom: layout.bottomPadding.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Leading ──────────────────────────────────────────────────────
          if (leading != null)
            SizedBox(
              width: layout.leadingWidth.r,
              child: _buildActionItem(leading!),
            ),

          if (leading != null) SizedBox(width: layout.spacing.w),

          // ── Centre: flexibleSpace pinned in bar ───────────────────────────
          Expanded(
            child: flexibleSpaceInBar != null
                ? Opacity(
                    opacity: flexibleSpaceInBarOpacity.clamp(0.0, 1.0),
                    child: flexibleSpaceInBar,
                  )
                : const SizedBox.shrink(),
          ),

          // ── Trailing ──────────────────────────────────────────────────────
          ...trailing.asMap().entries.map((entry) {
            final i = entry.key;
            final slot = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? layout.spacing.w : (layout.spacing / 2).w,
              ),
              child: SizedBox(
                width: layout.trailingWidth.r,
                child: _buildActionItem(slot),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(HeaderSlot slot) {
    if (slot.fixed) {
      return Padding(padding: slot.padding, child: slot.child);
    }

    final opacity = animation.enableFade
        ? LerpUtils.rangeMapInverted(progress, inStart: 0.0, inEnd: 0.5)
        : 1.0;

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Padding(padding: slot.padding, child: slot.child),
    );
  }
}
