# dynamic_sliver_header

A fully dynamic, animated `SliverPersistentHeader` for Flutter. Build collapsing headers with fade, scale, slide, colour-lerp, and text-shrink animations — either from three ready-made presets or fully custom slots.

---

## Features

- **Slot-based layout** — `leading`, `trailing`, `flexibleSpace`, and `content` slots, each with independent animation flags
- **Three presets** — `LocationSliverHeader` (food-delivery style), `RalphsSliverHeader` (grocery-store style), `TextShrinkSliverHeader` (multiline title that shrinks to one line)
- **Live scroll progress** — read `HeaderProgress.of(context)` from any widget inside a slot
- **Optional background image** — with colour overlay and gradient scrim
- **`flutter_screenutil` integration** — layout values scale automatically once you wrap your app in `ScreenUtilInit`

---

## Installation

```yaml
dependencies:
  dynamic_sliver_header: ^1.0.0
  flutter_screenutil: ^5.9.3
```

Wrap your app in `ScreenUtilInit` (required — the package's `.h`/`.w`/`.r`/`.sp` scaling reads from it):

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) => const MaterialApp(home: HomePage()),
    );
  }
}
```

---

## Quick start

### Use a preset

```dart
CustomScrollView(
  slivers: [
    LocationSliverHeader(
      locationName: 'Home',
      locationAddress: '123 Main Street',
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

`colors`, `layout`, and `animation` are all optional — omit them to use the defaults shown further down.

```dart
DynamicSliverHeader(
  expandedHeight: 300,
  collapsedHeight: 90,
  pinned: true, // default
  colors: const HeaderColorConfig(
    expandedBackgroundColor: Colors.deepPurple,
    collapsedBackgroundColor: Colors.deepPurple,
  ),
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
      fixed: false, // fades out as the header collapses
      child: Icon(Icons.favorite_border, color: Colors.white),
    ),
  ],
  flexibleSpace: HeaderSlot(
    id: 'searchbar',
    pinnedOnCollapse: true, // stays in the bar row once collapsed
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

## Reading live scroll progress

Any widget inside a slot can read the header's current state via `HeaderProgress.of(context)`:

```dart
content: HeaderSlot(
  id: 'live',
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return Opacity(
        opacity: 1.0 - hp.curvedProgress,
        child: Text('Progress: ${(hp.progress * 100).toStringAsFixed(0)}%'),
      );
    },
  ),
),
```

| Getter | Type | Description |
|---|---|---|
| `progress` | `double` | Raw scroll progress, `0.0` (expanded) → `1.0` (collapsed) |
| `curvedProgress` | `double` | Same, with the header's `animation.curve` applied |
| `height` | `double` | Current rendered height of the header, in logical pixels |
| `isExpanded` | `bool` | `true` when `progress <= 0.01` |
| `isCollapsed` | `bool` | `true` when `progress >= 0.99` |

`HeaderProgress.maybeOf(context)` returns `null` instead of throwing if called outside a `DynamicSliverHeader`.

---

## Presets

### `LocationSliverHeader`

Food-delivery style header: location name/address, a search bar that pins into the bar row on collapse, and a horizontal row of filter chips.

```dart
LocationSliverHeader(
  locationName: 'Home',
  locationAddress: '221B Baker Street',
  searchHint: 'Search for food...',       // default shown
  chips: const ['Delivery', '15–30 min', 'Free delivery'], // default shown
  expandedHeight: 280,                     // default shown
  collapsedHeight: 88,                     // default shown
  backgroundColor: Colors.white,           // default shown
  onLocationTap: () {},
  onSearchTap: () {},
  onProfileTap: () {},
  onFavoriteTap: () {},
)
```

`locationName` and `locationAddress` are required; everything else — including all colours and font sizes — has a default. See `lib/src/presets/location_sliver_header.dart` for the full list of overridable parameters (colours, font sizes, icon colours, search-bar styling).

### `RalphsSliverHeader`

Grocery-store style header: store avatar, title/subtitle, a promo banner, and a search bar that pins into the bar row on collapse.

```dart
RalphsSliverHeader(
  title: 'CSP Traders',
  subtitle: 'Ponmanai, Kanyakumari',
  searchHint: 'Search products...',                          // default shown
  promoText: 'Save up to 20% on your first order!',           // default shown
  expandedHeight: 280,                                        // default shown
  collapsedHeight: 88,                                        // default shown
  backgroundColor: const Color(0xFFB71C1C),                   // default shown
  onSearchTap: () {},
  onCartTap: () {},
  // onBackTap defaults to Navigator.of(context).pop() if omitted
)
```

`title` and `subtitle` are required. See `lib/src/presets/ralphs_sliver_header.dart` for the full parameter list.

### `TextShrinkSliverHeader`

A large multiline title that shrinks to a single ellipsized line as the header collapses. An optional description fades out once the header is roughly half-collapsed.

```dart
TextShrinkSliverHeader(
  title: 'Understanding Cement Grades: OPC vs PPC vs PSC',
  description: 'A practical guide for contractors.',
  expandedHeight: 200,       // default shown
  collapsedHeight: 80,       // default shown
  backgroundColor: const Color(0xFFCDDC39), // default shown
  onBackTap: () {},
  onShareTap: () {},
)
```

Only `title` is required.

---

## Core building blocks

### `DynamicSliverHeader`

| Parameter | Type | Default |
|---|---|---|
| `expandedHeight` | `double` | required |
| `collapsedHeight` | `double` | required |
| `pinned` | `bool` | `true` |
| `floating` | `bool` | `false` |
| `snap` | `bool` | `false` |
| `leading` | `HeaderSlot?` | `null` |
| `trailing` | `List<HeaderSlot>` | `[]` |
| `flexibleSpace` | `HeaderSlot?` | `null` |
| `content` | `HeaderSlot?` | `null` |
| `colors` | `HeaderColorConfig` | `HeaderColorConfig()` |
| `layout` | `HeaderLayoutConfig` | `HeaderLayoutConfig()` |
| `animation` | `HeaderAnimationConfig` | `HeaderAnimationConfig()` |
| `backgroundImage` | `ImageProvider?` | `null` |

### `HeaderSlot`

Wraps a widget and declares how it animates as the header collapses.

```dart
HeaderSlot(
  id: 'my_slot',        // required, used for keying/debugging
  child: MyWidget(),    // required
  fixed: false,               // leading/trailing only: no fade if true
  pinnedOnCollapse: false,    // flexibleSpace/content only: stays in the bar row if true
  hideOnCollapse: false,      // becomes invisible once progress >= 0.99
  fadeOnCollapse: false,
  scaleOnCollapse: false,
  slideOnCollapse: false,
  expandedAlignment: Alignment.center,
  collapsedAlignment: Alignment.center,
  padding: EdgeInsets.zero,
  expandedScale: 1.0,
  collapsedScale: 1.0,
  expandedOffset: Offset.zero,
  collapsedOffset: Offset.zero,
)
```

### `HeaderColorConfig`

```dart
HeaderColorConfig(
  expandedBackgroundColor: Color(0xFF2196F3), // default shown
  collapsedBackgroundColor: Color(0xFF2196F3), // default shown
  expandedIconColor: null,
  collapsedIconColor: null,
  expandedTextColor: null,
  collapsedTextColor: null,
  expandedGradient: null,     // e.g. a bottom scrim over a background image
  gradientOpacity: 1.0,
)
```

### `HeaderLayoutConfig`

```dart
HeaderLayoutConfig(
  horizontalPadding: 16.0,
  topPadding: 12.0,
  bottomPadding: 12.0,
  spacing: 12.0,
  leadingWidth: 48.0,
  trailingWidth: 48.0,
  respectSafeArea: true,   // adds the device's top safe-area inset automatically
  contentBelowBar: true,   // lay content out below the leading/trailing row
)
```

### `HeaderAnimationConfig`

```dart
HeaderAnimationConfig(
  curve: Curves.easeOutCubic,
  enableFade: true,
  enableScale: true,
  enableSlide: true,
  enableColorLerp: true,
  enableTextShrink: true,
  enableSnap: false,
  oneLineThreshold: 0.9,           // progress at which ShrinkingText switches to one line
  colorChangeScrollDistance: 120.0,
  snapDuration: Duration(milliseconds: 300),
)
```

`HeaderAnimationConfig.none` is a shortcut that disables fade/scale/slide/colour-lerp/text-shrink — useful while debugging layout.

---

## Background image

```dart
DynamicSliverHeader(
  expandedHeight: 260,
  collapsedHeight: 90,
  backgroundImage: const NetworkImage('https://example.com/banner.jpg'),
  colors: HeaderColorConfig(
    collapsedBackgroundColor: Colors.black,
    expandedGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.0),
        Colors.black.withValues(alpha: 0.55),
      ],
    ),
  ),
  // ...leading/trailing/content
)
```

The image fades under a colour overlay as the header collapses; the gradient scrim (if set) fades out over the same range.

---

## Example app

A runnable example lives in `example/`, with one screen per preset plus a fully custom header built from raw `HeaderSlot`s (showing `flexibleSpace` pinning, `HeaderProgress.of(context)`, and a background gradient scrim):

```bash
cd example
flutter pub get
flutter run
```

`example/lib/screens/`:

| File | Demonstrates |
|---|---|
| `location_demo_screen.dart` | `LocationSliverHeader` |
| `ralphs_demo_screen.dart` | `RalphsSliverHeader` |
| `text_shrink_demo_screen.dart` | `TextShrinkSliverHeader` |
| `custom_demo_screen.dart` | Raw `HeaderSlot`s, `flexibleSpace` pinning, live progress readout |

---

## Requirements

- Flutter >= 3.10.0
- Dart >= 3.0.0
- `flutter_screenutil` >= 5.9.3

---

## License

MIT