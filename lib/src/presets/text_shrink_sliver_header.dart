import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dynamic_sliver_header.dart';

/// Header with a large multiline title that shrinks to a single line
/// with ellipsis as the header collapses.
///
/// All sizes are scaled with [flutter_screenutil].
class TextShrinkSliverHeader extends StatelessWidget {
  // ── Content ───────────────────────────────────────────────────────────────
  final String title;
  final String? description;

  // ── Heights ───────────────────────────────────────────────────────────────
  final double expandedHeight;
  final double collapsedHeight;

  // ── Colours ───────────────────────────────────────────────────────────────
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;

  // ── Font sizes ────────────────────────────────────────────────────────────
  final double expandedTitleSize;
  final double collapsedTitleSize;
  final double descriptionSize;

  // ── Icon colours ─────────────────────────────────────────────────────────
  final Color iconColor;

  // ── Callbacks ─────────────────────────────────────────────────────────────
  final VoidCallback? onBackTap;
  final VoidCallback? onShareTap;

  const TextShrinkSliverHeader({
    super.key,
    required this.title,
    this.description,
    this.expandedHeight = 200,
    this.collapsedHeight = 80,
    this.backgroundColor = const Color(0xFFCDDC39),
    this.titleColor = Colors.white,
    this.descriptionColor = Colors.white70,
    this.expandedTitleSize = 28,
    this.collapsedTitleSize = 20,
    this.descriptionSize = 14,
    this.iconColor = Colors.white,
    this.onBackTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    const animConfig = HeaderAnimationConfig(
      curve: Curves.easeOutCubic,
      enableFade: false,
      enableScale: false,
      enableSlide: false,
      enableColorLerp: false,
      enableTextShrink: true,
      oneLineThreshold: 0.85,
    );

    return DynamicSliverHeader(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      pinned: true,
      floating: false,
      colors: HeaderColorConfig(
        expandedBackgroundColor: backgroundColor,
        collapsedBackgroundColor: backgroundColor,
      ),
      layout: HeaderLayoutConfig(
        horizontalPadding: 16.w,
        topPadding: 8.h,
        bottomPadding: 8.h,
        spacing: 8.w,
        leadingWidth: 48.r,
        trailingWidth: 48.r,
        contentBelowBar: true,
      ),
      animation: animConfig,
      leading: HeaderSlot(
        id: 'back',
        fixed: true,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor, size: 24.r),
          onPressed: onBackTap ?? () => Navigator.of(context).pop(),
        ),
      ),
      trailing: [
        HeaderSlot(
          id: 'share',
          fixed: true,
          child: IconButton(
            icon: Icon(Icons.share, color: iconColor, size: 24.r),
            onPressed: onShareTap,
          ),
        ),
      ],
      content: HeaderSlot(
        id: 'text_content',
        pinnedOnCollapse: true,
        child: Builder(
          builder: (context) {
            final hp = HeaderProgress.of(context);
            final progress = hp.curvedProgress;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShrinkingText(
                    text: title,
                    progress: progress,
                    config: HeaderTextConfig(
                      expandedFontSize: expandedTitleSize,
                      collapsedFontSize: collapsedTitleSize,
                      expandedMaxLines: 3,
                      collapsedMaxLines: 1,
                      expandedFontWeight: FontWeight.bold,
                      collapsedFontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    animation: animConfig,
                    style: TextStyle(color: titleColor),
                  ),
                  if (description != null && progress < 0.5) ...[
                    SizedBox(height: 6.h),
                    Opacity(
                      opacity: (1.0 - progress * 2).clamp(0.0, 1.0),
                      child: Text(
                        description!,
                        style: TextStyle(
                          fontSize: descriptionSize.sp,
                          color: descriptionColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
