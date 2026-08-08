import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dynamic_sliver_header_delegate.dart';
import '../models/header_slot.dart';
import '../models/header_animation_config.dart';
import '../models/header_layout_config.dart';
import '../models/header_color_config.dart';
import '../models/header_scroll_config.dart';

/// A fully dynamic animated sliver header.
///
/// Drop this anywhere inside a [CustomScrollView.slivers] list.
///
/// [expandedHeight] and [collapsedHeight] are in logical pixels and are
/// automatically scaled with [flutter_screenutil] `.h`.
class DynamicSliverHeader extends StatelessWidget {
  /// Height when fully expanded — scaled with `.h` internally.
  final double expandedHeight;

  /// Height when fully collapsed — scaled with `.h` internally.
  final double collapsedHeight;

  final bool pinned;
  final bool floating;
  final bool snap;
  final HeaderSlot? leading;
  final List<HeaderSlot> trailing;
  final HeaderSlot? flexibleSpace;
  final HeaderSlot? content;
  final HeaderColorConfig colors;
  final HeaderLayoutConfig layout;
  final HeaderAnimationConfig animation;
  final HeaderScrollConfig? scrollConfig;
  final ImageProvider? backgroundImage;

  const DynamicSliverHeader({
    super.key,
    required this.expandedHeight,
    required this.collapsedHeight,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.leading,
    this.trailing = const [],
    this.flexibleSpace,
    this.content,
    this.colors = const HeaderColorConfig(),
    this.layout = const HeaderLayoutConfig(),
    this.animation = const HeaderAnimationConfig(),
    this.scrollConfig,
    this.backgroundImage,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('expandedHeight', expandedHeight))
      ..add(DoubleProperty('collapsedHeight', collapsedHeight))
      ..add(FlagProperty('pinned', value: pinned, ifTrue: 'pinned'))
      ..add(FlagProperty('floating', value: floating, ifTrue: 'floating'))
      ..add(FlagProperty('snap', value: snap, ifTrue: 'snap'))
      ..add(DiagnosticsProperty<HeaderColorConfig>('colors', colors))
      ..add(DiagnosticsProperty<HeaderLayoutConfig>('layout', layout))
      ..add(DiagnosticsProperty<HeaderAnimationConfig>('animation', animation))
      ..add(DiagnosticsProperty<HeaderScrollConfig?>(
          'scrollConfig', scrollConfig));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topInset = layout.respectSafeArea ? mediaQuery.padding.top : 0.0;

    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: DynamicSliverHeaderDelegate(
        // Scale heights with screenutil
        expandedHeight: expandedHeight.h + topInset,
        collapsedHeight: collapsedHeight.h,
        leading: leading,
        trailing: trailing,
        flexibleSpace: flexibleSpace,
        content: content,
        colors: colors,
        layout: layout.copyWith(
          topPadding: layout.topPadding + topInset,
        ),
        animation: animation,
        scrollConfig: scrollConfig,
        backgroundImage: backgroundImage,
      ),
    );
  }
}
