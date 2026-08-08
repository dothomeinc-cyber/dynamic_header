import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

/// Demonstrates building a header directly from [DynamicSliverHeader] and
/// raw [HeaderSlot]s, without going through a preset. Shows:
/// - a fixed leading/trailing action bar
/// - a `flexibleSpace` slot that pins into the bar row on collapse
/// - a `content` slot that fades + scales as it collapses
/// - reading live scroll progress via `HeaderProgress.of(context)`
/// - a background gradient scrim
class CustomDemoScreen extends StatelessWidget {
  const CustomDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 260,
            collapsedHeight: 90,
            pinned: true,
            colors: HeaderColorConfig(
              expandedBackgroundColor: const Color(0xFF6A1B9A),
              collapsedBackgroundColor: const Color(0xFF4A148C),
              expandedGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
            layout: HeaderLayoutConfig(
              horizontalPadding: 16.w,
              topPadding: 8.h,
              bottomPadding: 8.h,
              leadingWidth: 40.r,
              trailingWidth: 40.r,
            ),
            animation: const HeaderAnimationConfig(
              enableFade: true,
              enableScale: true,
              enableColorLerp: true,
            ),
            leading: HeaderSlot(
              id: 'back',
              fixed: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            trailing: [
              HeaderSlot(
                id: 'share',
                fixed: false, // fades out as the header collapses
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
            // Pinned into the bar row once collapsed — a compact title
            // sits where the leading/trailing icons already are.
            flexibleSpace: const HeaderSlot(
              id: 'flexible_title',
              pinnedOnCollapse: true,
              child: _CollapsedTitle(),
            ),
            // Scrolls away and fades/scales out below the bar row while
            // expanded, replaced by `flexibleSpace` once pinned.
            content: HeaderSlot(
              id: 'expanded_content',
              fadeOnCollapse: true,
              scaleOnCollapse: true,
              expandedScale: 1.0,
              collapsedScale: 0.85,
              expandedAlignment: Alignment.bottomLeft,
              collapsedAlignment: Alignment.bottomLeft,
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
              child: const _ExpandedContent(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text('Entry #$index'),
              ),
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reads live scroll progress to show a debug readout, and demonstrates
/// the compact "pinned in bar" presentation.
class _CollapsedTitle extends StatelessWidget {
  const _CollapsedTitle();

  @override
  Widget build(BuildContext context) {
    final hp = HeaderProgress.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Vendor Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(hp.progress * 100).round()}%',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  const _ExpandedContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Vendor Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'GST verified • Bank verified • 4.8★ (128 orders)',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
