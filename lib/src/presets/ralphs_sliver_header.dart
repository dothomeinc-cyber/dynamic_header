import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dynamic_sliver_header.dart';

/// Grocery-store style header (Ralphs / supermarket style).
///
/// You only set the content and colours — all animations are automatic.
/// All sizes are scaled with [flutter_screenutil].
class RalphsSliverHeader extends StatelessWidget {
  // ── Content ───────────────────────────────────────────────────────────────
  final String title;
  final String subtitle;
  final String searchHint;
  final String promoText;

  // ── Heights ───────────────────────────────────────────────────────────────
  final double expandedHeight;
  final double collapsedHeight;

  // ── Colours ───────────────────────────────────────────────────────────────
  final Color backgroundColor;
  final Color searchBarColor;
  final Color searchBarBorderColor;
  final Color promoBoxColor;
  final Color storeAvatarColor;

  // ── Text colours ─────────────────────────────────────────────────────────
  final Color titleColor;
  final Color subtitleColor;
  final Color searchHintColor;
  final Color promoTextColor;

  // ── Font sizes ────────────────────────────────────────────────────────────
  final double titleFontSize;
  final double subtitleFontSize;
  final double searchHintFontSize;
  final double promoFontSize;

  // ── Icon colours ─────────────────────────────────────────────────────────
  final Color iconColor;
  final Color storeIconColor;
  final Color searchIconColor;
  final Color promoIconColor;

  // ── Callbacks ─────────────────────────────────────────────────────────────
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  const RalphsSliverHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.searchHint = 'Search products...',
    this.promoText = 'Save up to 20% on your first order!',
    this.expandedHeight = 280,
    this.collapsedHeight = 88,
    this.backgroundColor = const Color(0xFFB71C1C),
    this.searchBarColor = Colors.white,
    this.searchBarBorderColor = Colors.transparent,
    this.promoBoxColor = const Color(0x26FFFFFF),
    this.storeAvatarColor = Colors.white,
    this.titleColor = Colors.white,
    this.subtitleColor = const Color(0xCCFFFFFF),
    this.searchHintColor = const Color(0xFF757575),
    this.promoTextColor = Colors.white,
    this.titleFontSize = 22,
    this.subtitleFontSize = 13,
    this.searchHintFontSize = 15,
    this.promoFontSize = 13,
    this.iconColor = Colors.white,
    this.storeIconColor = const Color(0xFFB71C1C),
    this.searchIconColor = const Color(0xFF757575),
    this.promoIconColor = Colors.white,
    this.onBackTap,
    this.onSearchTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
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
      animation: const HeaderAnimationConfig(
        curve: Curves.easeOutCubic,
        enableFade: true,
        enableScale: true,
        enableSlide: false,
        enableColorLerp: false,
        enableTextShrink: false,
      ),
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
          id: 'cart',
          fixed: true,
          child: IconButton(
            icon: Icon(Icons.shopping_cart, color: iconColor, size: 24.r),
            onPressed: onCartTap,
          ),
        ),
      ],
      flexibleSpace: HeaderSlot(
        id: 'search',
        pinnedOnCollapse: true,
        child: GestureDetector(
          onTap: onSearchTap,
          child: Container(
            height: 44.h,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: searchBarColor,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: searchBarBorderColor),
            ),
            child: Row(
              children: [
                SizedBox(width: 14.w),
                Icon(Icons.search, color: searchIconColor, size: 20.r),
                SizedBox(width: 8.w),
                Text(searchHint,
                    style: TextStyle(
                        color: searchHintColor,
                        fontSize: searchHintFontSize.sp)),
              ],
            ),
          ),
        ),
      ),
      content: HeaderSlot(
        id: 'ralphs_content',
        pinnedOnCollapse: false,
        fadeOnCollapse: true,
        scaleOnCollapse: true,
        expandedScale: 1.0,
        collapsedScale: 0.9,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: storeAvatarColor,
                    child: Icon(Icons.store, size: 28.r, color: storeIconColor),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: titleFontSize.sp,
                                fontWeight: FontWeight.bold,
                                color: titleColor)),
                        Text(subtitle,
                            style: TextStyle(
                                fontSize: subtitleFontSize.sp,
                                color: subtitleColor)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: promoBoxColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer, color: promoIconColor, size: 18.r),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(promoText,
                          style: TextStyle(
                              fontSize: promoFontSize.sp,
                              color: promoTextColor)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: onSearchTap,
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: searchBarColor,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: searchBarBorderColor),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 14.w),
                      Icon(Icons.search, color: searchIconColor, size: 20.r),
                      SizedBox(width: 8.w),
                      Text(searchHint,
                          style: TextStyle(
                              color: searchHintColor,
                              fontSize: searchHintFontSize.sp)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
