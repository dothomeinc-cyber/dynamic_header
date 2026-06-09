import 'package:flutter/widgets.dart';

/// Provides the current scroll progress to any widget inside a
/// [DynamicSliverHeader] slot.
///
/// The delegate injects this automatically — you never construct it yourself.
///
/// ### Usage
/// ```dart
/// content: HeaderSlot(
///   id: 'my_slot',
///   child: Builder(builder: (context) {
///     final hp = HeaderProgress.of(context);
///     return Opacity(
///       opacity: 1.0 - hp.curvedProgress,
///       child: MyWidget(),
///     );
///   }),
/// ),
/// ```
///
/// ### Available values
/// | Getter            | Range / Type | Description |
/// |-------------------|--------------|-------------|
/// | [progress]        | 0.0 → 1.0    | Raw normalised scroll progress |
/// | [curvedProgress]  | 0.0 → 1.0    | Progress with animation curve applied |
/// | [height]          | px           | Current rendered height of the header |
/// | [isExpanded]      | bool         | True when fully expanded (progress ≤ 0.01) |
/// | [isCollapsed]     | bool         | True when fully collapsed (progress ≥ 0.99) |
class HeaderProgress extends InheritedWidget {
  /// Raw normalised progress.
  /// `0.0` = fully expanded, `1.0` = fully collapsed.
  final double progress;

  /// Progress with [HeaderAnimationConfig.curve] applied.
  /// Use this for smooth visual animations.
  final double curvedProgress;

  /// Current rendered height of the header in logical pixels.
  final double height;

  const HeaderProgress({
    super.key,
    required this.progress,
    required this.curvedProgress,
    required this.height,
    required super.child,
  });

  /// Returns the nearest [HeaderProgress] ancestor.
  ///
  /// Throws if called outside a [DynamicSliverHeader].
  /// Use [maybeOf] if the widget might not be inside a header.
  static HeaderProgress of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeaderProgress>();
    assert(
      result != null,
      'HeaderProgress.of() called outside a DynamicSliverHeader. '
      'Use HeaderProgress.maybeOf() if the widget may not be inside a header.',
    );
    return result!;
  }

  /// Returns the nearest [HeaderProgress] ancestor, or `null` if there is none.
  static HeaderProgress? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HeaderProgress>();

  /// True when the header is fully expanded (progress ≤ 0.01).
  bool get isExpanded => progress <= 0.01;

  /// True when the header is fully collapsed (progress ≥ 0.99).
  bool get isCollapsed => progress >= 0.99;

  @override
  bool updateShouldNotify(HeaderProgress oldWidget) =>
      progress != oldWidget.progress ||
      curvedProgress != oldWidget.curvedProgress ||
      height != oldWidget.height;
}
