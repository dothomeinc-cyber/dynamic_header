import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dynamic_sliver_header.dart';

const _kGrey100 = Color(0xFFF5F5F5);
const _kGrey200 = Color(0xFFEEEEEE);
const _kGrey300 = Color(0xFFE0E0E0);
const _kGrey600 = Color(0xFF757575);
const _kGrey700 = Color(0xFF616161);

/// Food-delivery style location header (Blinkit / Swiggy style).
///
/// You only set the content and colours — all animations are automatic.
/// All sizes are scaled with [flutter_screenutil].
class LocationSliverHeader extends StatelessWidget {
  // ── Content ───────────────────────────────────────────────────────────────
  final String locationName;
  final String locationAddress;
  final String searchHint;
  final List<String> chips;

  // ── Heights (logical px — scaled with .h internally) ─────────────────────
  final double expandedHeight;
  final double collapsedHeight;

  // ── Colours ───────────────────────────────────────────────────────────────
  final Color backgroundColor;
  final Color searchBarColor;
  final Color searchBarBorderColor;
  final Color chipBackgroundColor;
  final Color chipBorderColor;

  // ── Text colours ─────────────────────────────────────────────────────────
  final Color locationTextColor;
  final Color addressTextColor;
  final Color searchHintColor;
  final Color chipTextColor;

  // ── Font sizes (logical px — scaled with .sp internally) ─────────────────
  final double locationFontSize;
  final double addressFontSize;
  final double searchHintFontSize;
  final double chipFontSize;

  // ── Icon colours ─────────────────────────────────────────────────────────
  final Color leadingIconColor;
  final Color profileIconColor;
  final Color profileAvatarColor;
  final Color favouriteIconColor;
  final Color searchIconColor;

  // ── Callbacks ─────────────────────────────────────────────────────────────
  final VoidCallback? onLocationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFavoriteTap;

  const LocationSliverHeader({
    super.key,
    required this.locationName,
    required this.locationAddress,
    this.searchHint = 'Search for food...',
    this.chips = const ['Delivery', '15–30 min', 'Free delivery'],
    this.expandedHeight = 280,
    this.collapsedHeight = 88,
    this.backgroundColor = Colors.white,
    this.searchBarColor = _kGrey100,
    this.searchBarBorderColor = _kGrey300,
    this.chipBackgroundColor = _kGrey100,
    this.chipBorderColor = _kGrey300,
    this.locationTextColor = Colors.black87,
    this.addressTextColor = _kGrey600,
    this.searchHintColor = _kGrey600,
    this.chipTextColor = _kGrey700,
    this.locationFontSize = 18,
    this.addressFontSize = 13,
    this.searchHintFontSize = 14,
    this.chipFontSize = 12,
    this.leadingIconColor = Colors.black87,
    this.profileIconColor = Colors.black54,
    this.profileAvatarColor = _kGrey200,
    this.favouriteIconColor = Colors.black54,
    this.searchIconColor = _kGrey600,
    this.onLocationTap,
    this.onSearchTap,
    this.onProfileTap,
    this.onFavoriteTap,
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
        leadingWidth: 40.r,
        trailingWidth: 40.r,
        contentBelowBar: true,
      ),
      animation: const HeaderAnimationConfig(
        curve: Curves.easeOutCubic,
        enableFade: true,
        enableScale: false,
        enableSlide: false,
        enableColorLerp: false,
        enableTextShrink: false,
      ),
      leading: HeaderSlot(
        id: 'location_icon',
        fixed: true,
        child: GestureDetector(
          onTap: onLocationTap,
          child: Icon(Icons.location_on, color: leadingIconColor, size: 24.r),
        ),
      ),
      trailing: [
        HeaderSlot(
          id: 'profile',
          fixed: true,
          child: GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: profileAvatarColor,
              child: Icon(Icons.person_outline,
                  color: profileIconColor, size: 20.r),
            ),
          ),
        ),
        HeaderSlot(
          id: 'favorite',
          fixed: false,
          child: GestureDetector(
            onTap: onFavoriteTap,
            child: Icon(Icons.favorite_border,
                color: favouriteIconColor, size: 24.r),
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
        id: 'location_content',
        pinnedOnCollapse: false,
        fadeOnCollapse: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onLocationTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locationName,
                      style: TextStyle(
                        fontSize: locationFontSize.sp,
                        fontWeight: FontWeight.w700,
                        color: locationTextColor,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(Icons.keyboard_arrow_down,
                        size: 22.r, color: locationTextColor),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                locationAddress,
                style: TextStyle(
                    fontSize: addressFontSize.sp, color: addressTextColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
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
              SizedBox(height: 10.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < chips.length; i++) ...[
                      if (i > 0) SizedBox(width: 8.w),
                      _ChipWidget(
                        label: chips[i],
                        backgroundColor: chipBackgroundColor,
                        borderColor: chipBorderColor,
                        textColor: chipTextColor,
                        fontSize: chipFontSize,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;

  const _ChipWidget({
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize.sp, color: textColor),
      ),
    );
  }
}
