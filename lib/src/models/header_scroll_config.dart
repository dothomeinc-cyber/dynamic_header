/// Scroll-physics configuration for [DynamicSliverHeader].
class HeaderScrollConfig {
  /// Whether to collapse on scroll up. Default true.
  final bool collapseOnScrollUp;

  /// Whether to expand on scroll down. Default true.
  final bool expandOnScrollDown;

  /// Velocity threshold (logical-pixels/s) used for snap decision.
  final double snapVelocityThreshold;

  const HeaderScrollConfig({
    this.collapseOnScrollUp = true,
    this.expandOnScrollDown = true,
    this.snapVelocityThreshold = 500.0,
  });
}
