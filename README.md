Here's the complete README.md with the additional content integrated:

## **README.md**

```markdown
# dynamic_sliver_header

A fully dynamic animated `SliverPersistentHeader` package for Flutter. Create beautiful collapsing headers with smooth animations — fade, scale, slide, color interpolation, and text shrinking. Complete control over every widget with intuitive presets.

[![pub package](https://img.shields.io/pub/v/dynamic_sliver_header.svg)](https://pub.dev/packages/dynamic_sliver_header)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

---

## Features

- 🎯 **Complete Control** — Every widget's animation is opt-in via simple flags
- ✨ **Smooth Animations** — Fade, scale, slide, color lerp, and text shrinking
- 📦 **Ready-to-Use Presets** — Location (Blinkit-style), Grocery (Ralphs-style), Text Shrink
- 🔧 **Flexible Slots** — Leading, trailing, flexibleSpace, and content slots
- 📱 **Responsive** — Built-in `flutter_screenutil` support for all sizes
- 🎭 **Live Progress** — Read scroll progress anywhere with `HeaderProgress.of(context)`
- 🖼️ **Background Image** — Full-bleed image with colour overlay and gradient scrim
- 💪 **Production Ready** — Null safety, no deprecated APIs, 0 lint warnings

---

## Installation

```yaml
dependencies:
  dynamic_sliver_header: ^2.0.0
  flutter_screenutil: ^5.9.3
```

Wrap your app with `ScreenUtilInit`:

```dart
void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(home: child),
      child: const HomePage(),
    );
  }
}
```

---

## Quick Start

### Use a preset

```dart
CustomScrollView(
  slivers: [
    LocationSliverHeader(
      locationName: 'HOME',
      locationAddress: '123 Main Street, Bengaluru',
      onSearchTap: () {},
    ),
    SliverList.builder(
      itemCount: 50,
      itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
    ),
  ],
)
```

### Build your own

```dart
DynamicSliverHeader(
  expandedHeight: 300,
  collapsedHeight: 90,
  pinned: true,
  colors: const HeaderColorConfig(
    expandedBackgroundColor: Colors.deepPurple,
    collapsedBackgroundColor: Colors.deepPurple,
  ),
  layout: const HeaderLayoutConfig(),
  animation: const HeaderAnimationConfig(),
  leading: HeaderSlot(
    id: 'back',
    fixed: true,
    child: BackButton(color: Colors.white),
  ),
  trailing: [
    const HeaderSlot(
      id: 'search',
      fixed: true,
      child: Icon(Icons.search, color: Colors.white),
    ),
    const HeaderSlot(
      id: 'favorite',
      fixed: false,         // fades out on collapse
      child: Icon(Icons.favorite_border, color: Colors.white),
    ),
  ],
  flexibleSpace: HeaderSlot(
    id: 'searchbar',
    pinnedOnCollapse: true, // pins in bar when collapsed
    child: MySearchBar(),
  ),
  content: HeaderSlot(
    id: 'hero',
    fadeOnCollapse: true,
    scaleOnCollapse: true,
    child: MyHeroContent(),
  ),
)
```

---

## Read Live Scroll Progress

Inside any slot, read the current progress using `HeaderProgress.of(context)`:

```dart
// Read live scroll progress inside any slot
final hp = HeaderProgress.of(context);
hp.progress        // 0.0 → 1.0 raw
hp.curvedProgress  // smoothed with animation curve
hp.isCollapsed     // bool (progress ≥ 0.99)
hp.isExpanded      // bool (progress ≤ 0.01)
hp.height          // current height in pixels
```

### Live Progress Example

```dart
content: HeaderSlot(
  id: 'live',
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return Opacity(
        opacity: 1.0 - hp.curvedProgress,
        child: Column(
          children: [
            Text('Progress: ${(hp.progress * 100).toStringAsFixed(0)}%'),
            if (!hp.isCollapsed) Text('Still expanding...'),
            if (hp.isExpanded) Text('Fully expanded!'),
          ],
        ),
      );
    },
  ),
),
```

---

## Presets

### `LocationSliverHeader` — Blinkit / Swiggy style

Food delivery app header with location, address, search bar, and chips.

```dart
LocationSliverHeader(
  // Content
  locationName: 'HOME',
  locationAddress: 'Floor 2, Main Street',
  searchHint: 'Search for food...',
  chips: const ['Delivery', '15–30 min', 'Free delivery'],

  // Heights
  expandedHeight: 280,
  collapsedHeight: 88,

  // Background
  backgroundColor: Colors.white,

  // Search bar
  searchBarColor: Color(0xFFF5F5F5),
  searchBarBorderColor: Color(0xFFE0E0E0),
  searchHintColor: Colors.grey,
  searchHintFontSize: 14,
  searchIconColor: Colors.grey,

  // Location text
  locationTextColor: Colors.black87,
  locationFontSize: 18,
  addressTextColor: Colors.grey,
  addressFontSize: 13,

  // Chips
  chipBackgroundColor: Color(0xFFF5F5F5),
  chipBorderColor: Color(0xFFE0E0E0),
  chipTextColor: Colors.grey,
  chipFontSize: 12,

  // Icons
  leadingIconColor: Colors.black87,
  profileIconColor: Colors.black54,
  profileAvatarColor: Color(0xFFEEEEEE),
  favouriteIconColor: Colors.black54,

  // Callbacks
  onLocationTap: () {},
  onSearchTap: () {},
  onProfileTap: () {},
  onFavoriteTap: () {},
)
```

**Behaviour:** Location info + chips fade out. Search bar pins inside the bar row when collapsed.

---

### `RalphsSliverHeader` — Grocery store style

Supermarket-style header with logo, title, subtitle, promo banner, and search.

```dart
RalphsSliverHeader(
  // Content
  title: 'Ralphs',
  subtitle: 'Fresh for Everyone',
  searchHint: 'Search products...',
  promoText: 'Save up to 20% on your first order!',

  // Heights
  expandedHeight: 280,
  collapsedHeight: 88,

  // Background
  backgroundColor: Color(0xFFB71C1C),

  // Store avatar
  storeAvatarColor: Colors.white,
  storeIconColor: Color(0xFFB71C1C),

  // Title
  titleColor: Colors.white,
  titleFontSize: 22,
  subtitleColor: Colors.white70,
  subtitleFontSize: 13,

  // Search bar
  searchBarColor: Colors.white,
  searchHintColor: Colors.grey,
  searchHintFontSize: 15,
  searchIconColor: Colors.grey,

  // Promo
  promoBoxColor: Color(0x26FFFFFF),
  promoTextColor: Colors.white,
  promoFontSize: 13,
  promoIconColor: Colors.white,

  // Icons
  iconColor: Colors.white,

  // Callbacks
  onBackTap: () => Navigator.pop(context),
  onSearchTap: () {},
  onCartTap: () {},
)
```

**Behaviour:** Logo + title + promo fades and scales out. Search bar pins inside the bar row.

---

### `TextShrinkSliverHeader` — Multiline to single line

Multiline title that smoothly shrinks to a single line with ellipsis.

```dart
TextShrinkSliverHeader(
  // Content
  title: 'Some very long text that is multiline when expanded',
  description: 'Optional subtitle that fades out.',

  // Heights
  expandedHeight: 200,
  collapsedHeight: 80,

  // Background
  backgroundColor: Color(0xFFCDDC39),

  // Title
  titleColor: Colors.white,
  expandedTitleSize: 28,
  collapsedTitleSize: 20,

  // Description
  descriptionColor: Colors.white70,
  descriptionSize: 14,

  // Icons
  iconColor: Colors.white,

  // Callbacks
  onBackTap: () => Navigator.pop(context),
  onShareTap: () {},
)
```

**Behaviour:** Title font smoothly shrinks and collapses to 1 line with ellipsis. Description fades out in the first half of collapse.

---

## Slot Behaviour — You Decide Everything

The package handles animation. You decide what each widget does:

| Property | Type | Default | Effect |
|---|---|---|---|
| `fixed` | bool | false | **Leading/trailing**: always visible, no animation ever |
| `fixed: false` | bool | false | **Leading/trailing**: fades out as header collapses |
| `pinnedOnCollapse` | bool | false | **FlexibleSpace**: pins inside bar row when collapsed |
| `fadeOnCollapse` | bool | false | Opacity 1 → 0 as progress goes 0 → 1 |
| `scaleOnCollapse` | bool | false | Scale `expandedScale` → `collapsedScale` |
| `slideOnCollapse` | bool | false | Translate `expandedOffset` → `collapsedOffset` |
| `hideOnCollapse` | bool | false | Completely invisible at progress = 1 |
| `expandedAlignment` | Alignment | center | Alignment at progress = 0 |
| `collapsedAlignment` | Alignment | center | Alignment at progress = 1 |

---

## Live Progress — `HeaderProgress`

Any widget inside any slot can read the live scroll progress using a `Builder`:

```dart
content: HeaderSlot(
  id: 'live',
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return Opacity(
        opacity: 1.0 - hp.curvedProgress,
        child: Text(
          'Progress: ${(hp.progress * 100).toStringAsFixed(0)}%',
        ),
      );
    },
  ),
),
```

| Property | Type | Description |
|---|---|---|
| `hp.progress` | double 0–1 | Raw normalised scroll progress |
| `hp.curvedProgress` | double 0–1 | Progress with animation curve applied |
| `hp.height` | double px | Current rendered height of the header |
| `hp.isExpanded` | bool | True when progress ≤ 0.01 |
| `hp.isCollapsed` | bool | True when progress ≥ 0.99 |

---

## `ShrinkingText` — Standalone shrinking widget

Use `ShrinkingText` anywhere inside a slot for animated font size:

```dart
content: HeaderSlot(
  id: 'title',
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return ShrinkingText(
        text: 'My Title',
        progress: hp.curvedProgress,
        config: const HeaderTextConfig(
          expandedFontSize: 28,
          collapsedFontSize: 18,
          expandedMaxLines: 3,
          collapsedMaxLines: 1,
          expandedFontWeight: FontWeight.bold,
          collapsedFontWeight: FontWeight.w600,
        ),
        animation: const HeaderAnimationConfig(),
        style: const TextStyle(color: Colors.white),
      );
    },
  ),
),
```

---

## Background Image

```dart
DynamicSliverHeader(
  expandedHeight: 320,
  collapsedHeight: 90,

  // Full-bleed image
  backgroundImage: const NetworkImage('https://example.com/image.jpg'),

  colors: const HeaderColorConfig(
    expandedBackgroundColor: Colors.transparent,
    collapsedBackgroundColor: Color(0xFF37474F), // tint when collapsed
    // Gradient scrim for text readability
    expandedGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black54],
    ),
    gradientOpacity: 1.0, // 0.0–1.0
  ),
  // ... rest of config
)
```

---

## API Reference

### `DynamicSliverHeader`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `expandedHeight` | double | required | Height when fully expanded (scaled with `.h`) |
| `collapsedHeight` | double | required | Height when fully collapsed (scaled with `.h`) |
| `pinned` | bool | true | Pins header to top of viewport |
| `floating` | bool | false | Re-appears on any upward scroll |
| `snap` | bool | false | Snaps fully open/closed on release (requires `floating: true`) |
| `colors` | HeaderColorConfig | required | Background colour / gradient config |
| `layout` | HeaderLayoutConfig | required | Padding, spacing, widths |
| `animation` | HeaderAnimationConfig | required | Curve, enable flags |
| `leading` | HeaderSlot? | null | Leading widget (e.g. back button) |
| `trailing` | List\<HeaderSlot\> | [] | Trailing widgets (e.g. icons) |
| `flexibleSpace` | HeaderSlot? | null | Centre widget — can pin on collapse |
| `content` | HeaderSlot? | null | Large expanded content area |
| `backgroundImage` | ImageProvider? | null | Full-bleed background image |
| `scrollConfig` | HeaderScrollConfig? | null | Advanced scroll physics |

---

### `HeaderColorConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `expandedBackgroundColor` | Color | `Colors.blue` | Background at progress = 0 |
| `collapsedBackgroundColor` | Color | `Colors.blue` | Background at progress = 1 |
| `expandedIconColor` | Color? | null | Icon tint when expanded |
| `collapsedIconColor` | Color? | null | Icon tint when collapsed |
| `expandedTextColor` | Color? | null | Text colour when expanded |
| `collapsedTextColor` | Color? | null | Text colour when collapsed |
| `expandedGradient` | Gradient? | null | Gradient scrim over background |
| `gradientOpacity` | double | 1.0 | Max opacity of gradient scrim |

---

### `HeaderAnimationConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `curve` | Curve | `easeOutCubic` | Easing applied to raw scroll progress |
| `enableFade` | bool | true | Master switch for all fade animations |
| `enableScale` | bool | true | Master switch for all scale animations |
| `enableSlide` | bool | true | Master switch for all slide/translate animations |
| `enableColorLerp` | bool | true | Lerp background colour expanded → collapsed |
| `enableTextShrink` | bool | true | Enable `ShrinkingText` font animation |
| `enableSnap` | bool | false | Snap header open/closed on release |
| `oneLineThreshold` | double | 0.9 | Progress at which text collapses to 1 line |
| `colorChangeScrollDistance` | double | 120.0 | Pixels over which colour fully transitions |
| `snapDuration` | Duration | 300ms | Duration for snap animations |

---

### `HeaderLayoutConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `horizontalPadding` | double | 16.0 | Padding left/right of bar row (scaled `.w`) |
| `topPadding` | double | 12.0 | Padding above bar row (scaled `.h`) |
| `bottomPadding` | double | 12.0 | Padding below bar row (scaled `.h`) |
| `spacing` | double | 12.0 | Gap between leading, centre, trailing (scaled `.w`) |
| `leadingWidth` | double | 48.0 | Width of leading slot (scaled `.r`) |
| `trailingWidth` | double | 48.0 | Width of each trailing slot (scaled `.r`) |
| `respectSafeArea` | bool | true | Adds status-bar / notch inset to topPadding |
| `contentBelowBar` | bool | true | Content sits below bar row; false = fills whole header |

---

### `HeaderTextConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `expandedFontSize` | double | 28.0 | Font size at progress = 0 (scaled `.sp`) |
| `collapsedFontSize` | double | 16.0 | Font size at progress = 1 (scaled `.sp`) |
| `expandedMaxLines` | int | 3 | Max lines when expanded |
| `collapsedMaxLines` | int | 1 | Max lines when collapsed |
| `expandedFontWeight` | FontWeight | bold | Weight when expanded |
| `collapsedFontWeight` | FontWeight | w600 | Weight when collapsed |
| `overflow` | TextOverflow | ellipsis | Overflow when collapsed |

---

### `HeaderScrollConfig`

| Property | Type | Default | Description |
|---|---|---|---|
| `collapseOnScrollUp` | bool | true | Collapse when scrolling up |
| `expandOnScrollDown` | bool | true | Expand when scrolling down |
| `snapVelocityThreshold` | double | 500.0 | Velocity (px/s) used for snap decision |

---

### `HeaderPresetType` enum

Convenience enum — use with `HeaderPresetType.defaultExpandedHeight` / `defaultCollapsedHeight`:

```dart
final preset = HeaderPresetType.location;
print(preset.displayName);           // 'Location Header'
print(preset.defaultExpandedHeight); // 320.0
print(preset.defaultCollapsedHeight);// 88.0
```

| Value | Display Name | Expanded | Collapsed |
|---|---|---|---|
| `location` | Location Header | 320 | 88 |
| `ralphs` | Ralphs Header | 280 | 88 |
| `textShrink` | Text Shrink Header | 250 | 80 |
| `custom` | Custom Header | 300 | 90 |

---

## Screenutil Reference

All sizes in the package use `flutter_screenutil` automatically:

| Used for | Screenutil |
|---|---|
| Heights (`expandedHeight`, `collapsedHeight`, vertical padding) | `.h` |
| Horizontal widths, horizontal padding, spacing | `.w` |
| Icon sizes, border radius, avatar radius, leading/trailing widths | `.r` |
| Font sizes | `.sp` |

You pass plain `double` values — the package applies the scaling internally.

---

## Running the Example

The complete example app is included in the `example/` folder.

```bash
cd dynamic_sliver_header/example
flutter pub get
flutter run
```

The example app has **5 tabs**:

| Tab | Description |
|---|---|
| **Blinkit** | `LocationSliverHeader` preset with custom styling options |
| **Ralphs** | `RalphsSliverHeader` preset with full customization |
| **Text** | `TextShrinkSliverHeader` preset - multiline to single line |
| **Custom** | `DynamicSliverHeader` with your own widgets and animations |
| **Manual** | Background image + live `HeaderProgress` values display |

Each tab demonstrates:
- ✅ Minimal usage (just required fields)
- ✅ Full custom styling
- ✅ Proper screenutil scaling
- ✅ Smooth 60fps animations

---

## Requirements

- Flutter >= 3.10.0
- Dart >= 3.0.0
- flutter_screenutil >= 5.9.0

---

## License

MIT

---

## Credits

Created with ❤️ for the Flutter community. Built on top of Flutter's `SliverPersistentHeader`.
```

This README now includes:
- ✅ Live progress example with `HeaderProgress.of(context)`
- ✅ All 5 example tabs documented
- ✅ Complete API reference tables
- ✅ Screenutil scaling reference
- ✅ Preset behaviour descriptions
- ✅ Installation and quick start guides