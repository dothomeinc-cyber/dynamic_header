/// dynamic_sliver_header
///
/// A fully dynamic animated SliverPersistentHeader package.
/// Drop [DynamicSliverHeader] anywhere inside a [CustomScrollView].
///
/// Any widget inside a slot can read live scroll progress:
/// ```dart
/// Builder(builder: (context) {
///   final hp = HeaderProgress.of(context);
///   hp.progress        // 0.0 expanded → 1.0 collapsed
///   hp.curvedProgress  // same, with animation curve applied
///   hp.height          // current header height in px
///   hp.isExpanded      // bool
///   hp.isCollapsed     // bool
/// })
/// ```
library dynamic_sliver_header;

// Core
export 'src/core/dynamic_sliver_header.dart';
export 'src/core/dynamic_sliver_header_delegate.dart';
export 'src/core/header_progress.dart';

// Models
export 'src/models/header_slot.dart';
export 'src/models/header_animation_config.dart';
export 'src/models/header_layout_config.dart';
export 'src/models/header_color_config.dart';
export 'src/models/header_text_config.dart';
export 'src/models/header_scroll_config.dart';
export 'src/models/header_preset_type.dart';

// Widgets (public for advanced customisation)
export 'src/widgets/animated_header_slot.dart';
export 'src/widgets/fixed_header_actions.dart';
export 'src/widgets/shrinking_text.dart';
export 'src/widgets/header_background.dart';
export 'src/widgets/header_safe_area.dart';

// Presets
export 'src/presets/location_sliver_header.dart';
export 'src/presets/ralphs_sliver_header.dart';
export 'src/presets/text_shrink_sliver_header.dart';

// Utils
export 'src/utils/lerp_utils.dart';
export 'src/utils/scroll_math.dart';
