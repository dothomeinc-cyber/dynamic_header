/// Layout configuration for [DynamicSliverHeader].
///
/// All default values are in **logical pixels** — [DynamicSliverHeader]
/// applies [flutter_screenutil] scaling internally when building.
class HeaderLayoutConfig {
  /// Horizontal padding for the leading/trailing action row.
  final double horizontalPadding;

  /// Padding above the action row (added to safe-area inset when
  /// [respectSafeArea] is true).
  final double topPadding;

  /// Padding below the action row.
  final double bottomPadding;

  /// Horizontal gap between leading, centre content, and trailing widgets.
  final double spacing;

  /// Fixed width reserved for the leading widget slot.
  final double leadingWidth;

  /// Fixed width reserved for each trailing widget slot.
  final double trailingWidth;

  /// When true, the delegate adds the device's top safe-area inset
  /// (status-bar / notch) to [topPadding] automatically.
  final bool respectSafeArea;

  /// When true, [flexibleSpace] and [content] are laid out below the
  /// leading+trailing bar row. When false they fill the entire header.
  final bool contentBelowBar;

  const HeaderLayoutConfig({
    this.horizontalPadding = 16.0,
    this.topPadding = 12.0,
    this.bottomPadding = 12.0,
    this.spacing = 12.0,
    this.leadingWidth = 48.0,
    this.trailingWidth = 48.0,
    this.respectSafeArea = true,
    this.contentBelowBar = true,
  });

  HeaderLayoutConfig copyWith({
    double? horizontalPadding,
    double? topPadding,
    double? bottomPadding,
    double? spacing,
    double? leadingWidth,
    double? trailingWidth,
    bool? respectSafeArea,
    bool? contentBelowBar,
  }) {
    return HeaderLayoutConfig(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      topPadding: topPadding ?? this.topPadding,
      bottomPadding: bottomPadding ?? this.bottomPadding,
      spacing: spacing ?? this.spacing,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      trailingWidth: trailingWidth ?? this.trailingWidth,
      respectSafeArea: respectSafeArea ?? this.respectSafeArea,
      contentBelowBar: contentBelowBar ?? this.contentBelowBar,
    );
  }
}
