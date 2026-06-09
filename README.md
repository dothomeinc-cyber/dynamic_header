Here's your complete updated README.md with the color lerp section added without missing any existing content:

## **README.md** (Complete with Color Lerp Section)

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
- 🎨 **Color Lerp** — Smooth background and icon colour transitions on scroll
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

## Color Lerp — Smooth Background and Icon Transition

The background colour smoothly transitions from expanded to collapsed state as you scroll.

### Basic colour change on scroll

```dart
DynamicSliverHeader(
  expandedHeight: 300,
  collapsedHeight: 90,
  pinned: true,

  colors: const HeaderColorConfig(
    expandedBackgroundColor: Colors.transparent, // colour when expanded
    collapsedBackgroundColor: Colors.white,       // colour when collapsed
  ),

  animation: const HeaderAnimationConfig(
    enableColorLerp: true, // ← this does the smooth colour transition
  ),

  layout: const HeaderLayoutConfig(),
  // ... your slots
)
```

### How it works

```
Scroll position 0%   → expandedBackgroundColor  (fully expanded)
Scroll position 50%  → lerped colour in between  (halfway)
Scroll position 100% → collapsedBackgroundColor  (fully collapsed)
```

### Real examples

#### Transparent → white (like most app bars)

```dart
colors: const HeaderColorConfig(
  expandedBackgroundColor: Colors.transparent,
  collapsedBackgroundColor: Colors.white,
),
animation: const HeaderAnimationConfig(
  enableColorLerp: true,
),
```

#### Gold → dark (Blinkit style)

```dart
colors: const HeaderColorConfig(
  expandedBackgroundColor: Color(0xFF8B6914),
  collapsedBackgroundColor: Color(0xFF5D4410),
),
animation: const HeaderAnimationConfig(
  enableColorLerp: true,
),
```

#### With background image — image tints to colour

```dart
backgroundImage: const NetworkImage('https://example.com/image.jpg'),

colors: const HeaderColorConfig(
  expandedBackgroundColor: Colors.transparent,
  collapsedBackgroundColor: Color(0xFF37474F), // tints over image
),

animation: const HeaderAnimationConfig(
  enableColorLerp: true, // overlay fades in as collapsed
),
```

### Icon and Text Colour Transition

Your `HeaderColorConfig` includes `expandedIconColor` and `collapsedIconColor` properties. To use them:

```dart
colors: const HeaderColorConfig(
  expandedBackgroundColor: Colors.transparent,
  collapsedBackgroundColor: Colors.white,
  expandedIconColor: Colors.white,   // icons white when expanded
  collapsedIconColor: Colors.black,  // icons black when collapsed
  expandedTextColor: Colors.white,
  collapsedTextColor: Colors.black87,
),

// Then in your slot, use HeaderProgress to lerp colors:
leading: HeaderSlot(
  id: 'back',
  fixed: true,
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      final color = Color.lerp(
        Colors.white,   // expanded icon colour
        Colors.black,   // collapsed icon colour
        hp.curvedProgress,
      );
      return Icon(Icons.arrow_back, color: color);
    },
  ),
),
```

### Presets Note

For presets (`LocationSliverHeader`, `RalphsSliverHeader`, `TextShrinkSliverHeader`), colour lerp uses the same colour by default. To use different expanded/collapsed colours with presets, use `DynamicSliverHeader` directly:

```dart
// Instead of LocationSliverHeader, use DynamicSliverHeader
DynamicSliverHeader(
  expandedHeight: 280,
  collapsedHeight: 88,
  colors: const HeaderColorConfig(
    expandedBackgroundColor: Color(0xFF8B6914),  // gold when expanded
    collapsedBackgroundColor: Color(0xFF5D4410), // dark when collapsed
  ),
  animation: const HeaderAnimationConfig(
    enableColorLerp: true,
  ),
  // ... copy the slot configurations from LocationSliverHeader
)
```

---

## Manual Examples — Full Control

Sometimes you want complete control over every widget and animation. Here's how to build the same headers manually.

### Manual Blinkit (Location Style)

```dart
class ManualBlinkitDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 300,
            collapsedHeight: 90,
            pinned: true,

            colors: const HeaderColorConfig(
              expandedBackgroundColor: Color(0xFF8B6914),
              collapsedBackgroundColor: Color(0xFF8B6914),
            ),

            layout: const HeaderLayoutConfig(
              horizontalPadding: 16,
              topPadding: 8,
              bottomPadding: 8,
              spacing: 8,
              leadingWidth: 40,
              trailingWidth: 40,
              contentBelowBar: true,
            ),

            animation: const HeaderAnimationConfig(
              curve: Curves.easeOutCubic,
              enableFade: true,
              enableScale: false,
              enableSlide: false,
              enableColorLerp: false,
            ),

            // Leading: location icon — always fixed
            leading: HeaderSlot(
              id: 'location_icon',
              fixed: true,
              child: Icon(Icons.location_on, color: Colors.white, size: 24.r),
            ),

            // Trailing: profile fixed, favourite fades
            trailing: [
              HeaderSlot(
                id: 'profile',
                fixed: true,
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_outline, color: Colors.white, size: 20.r),
                ),
              ),
              const HeaderSlot(
                id: 'favorite',
                fixed: false,  // fades out on collapse
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],

            // FlexibleSpace: search bar — pins in bar when collapsed
            flexibleSpace: HeaderSlot(
              id: 'search',
              pinnedOnCollapse: true,
              child: Container(
                height: 44.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(Icons.search, color: Colors.grey, size: 20.r),
                    SizedBox(width: 8.w),
                    Text('Search for food...',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ],
                ),
              ),
            ),

            // Content: delivery time + location + chips — fades out
            content: HeaderSlot(
              id: 'blinkit_content',
              pinnedOnCollapse: false,
              fadeOnCollapse: true,  // package fades this out
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Blinkit in',
                        style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
                    Text('15 minutes',
                        style: TextStyle(
                            color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text('HOME',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4.w),
                        Text('- Floor 2, Main Street',
                            style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
                        Icon(Icons.arrow_drop_down, color: Colors.white, size: 20.r),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 14.w),
                          Icon(Icons.search, color: Colors.grey, size: 20.r),
                          SizedBox(width: 8.w),
                          Text('Search for food...',
                              style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chip('Delivery', Colors.white24, Colors.white),
                          SizedBox(width: 8.w),
                          _chip('15 minutes', Colors.white24, Colors.white),
                          SizedBox(width: 8.w),
                          _chip('Free delivery', Colors.white24, Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList.builder(...),
        ],
      ),
    );
  }
}
```

| You build: | Package does: |
|---|---|
| location icon | keeps it fixed in bar |
| search bar widget | pins it in bar row on collapse |
| delivery time text | fades it all out on collapse |
| chips row | fades it all out on collapse |
| profile avatar | keeps it fixed in bar |
| fav icon | fades it out (fixed: false) |

---

### Manual Ralphs (Grocery Store Style)

```dart
class ManualRalphsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 280,
            collapsedHeight: 90,
            pinned: true,

            colors: const HeaderColorConfig(
              expandedBackgroundColor: Color(0xFFB71C1C),
              collapsedBackgroundColor: Color(0xFFB71C1C),
            ),

            layout: const HeaderLayoutConfig(
              horizontalPadding: 16,
              topPadding: 8,
              bottomPadding: 8,
              spacing: 8,
              leadingWidth: 48,
              trailingWidth: 48,
              contentBelowBar: true,
            ),

            animation: const HeaderAnimationConfig(
              curve: Curves.easeOutCubic,
              enableFade: true,
              enableScale: true,
              enableSlide: false,
              enableColorLerp: false,
            ),

            // Leading: back button — always fixed
            leading: HeaderSlot(
              id: 'back',
              fixed: true,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.r),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Trailing: cart — always fixed
            trailing: [
              HeaderSlot(
                id: 'cart',
                fixed: true,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white, size: 24.r),
                  onPressed: () {},
                ),
              ),
            ],

            // FlexibleSpace: search bar — pins in bar when collapsed
            flexibleSpace: HeaderSlot(
              id: 'search',
              pinnedOnCollapse: true,
              child: Container(
                height: 44.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(Icons.search, color: Colors.grey, size: 20.r),
                    SizedBox(width: 8.w),
                    Text('Search products...',
                        style: TextStyle(color: Colors.grey, fontSize: 15.sp)),
                  ],
                ),
              ),
            ),

            // Content: logo + title + promo — fades + scales out
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
                          backgroundColor: Colors.white,
                          child: Icon(Icons.store, size: 28.r, color: Color(0xFFB71C1C)),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ralphs',
                                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('Fresh for Everyone',
                                  style: TextStyle(fontSize: 13.sp, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_offer, color: Colors.white, size: 18.r),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text('Save up to 20% on your first order!',
                                style: TextStyle(fontSize: 13.sp, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 14.w),
                          Icon(Icons.search, color: Colors.grey, size: 20.r),
                          SizedBox(width: 8.w),
                          Text('Search products...',
                              style: TextStyle(color: Colors.grey, fontSize: 15.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList.builder(...),
        ],
      ),
    );
  }
}
```

| You build: | Package does: |
|---|---|
| back button | keeps it fixed |
| cart button | keeps it fixed |
| search bar widget | pins it in bar row on collapse |
| logo + title | fades + scales out on collapse |
| promo banner | fades + scales out on collapse |

---

### Manual Text Shrink

```dart
class ManualTextShrinkDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 200,
            collapsedHeight: 80,
            pinned: true,

            colors: const HeaderColorConfig(
              expandedBackgroundColor: Color(0xFFCDDC39),
              collapsedBackgroundColor: Color(0xFFCDDC39),
            ),

            layout: const HeaderLayoutConfig(
              horizontalPadding: 16,
              topPadding: 8,
              bottomPadding: 8,
              spacing: 8,
              leadingWidth: 48,
              trailingWidth: 48,
              contentBelowBar: true,
            ),

            animation: const HeaderAnimationConfig(
              curve: Curves.easeOutCubic,
              enableFade: false,
              enableScale: false,
              enableSlide: false,
              enableColorLerp: false,
              enableTextShrink: true,
              oneLineThreshold: 0.85,
            ),

            // Leading: back — always fixed
            leading: HeaderSlot(
              id: 'back',
              fixed: true,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.r),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Trailing: share — always fixed
            trailing: [
              HeaderSlot(
                id: 'share',
                fixed: true,
                child: IconButton(
                  icon: Icon(Icons.share, color: Colors.white, size: 24.r),
                  onPressed: () {},
                ),
              ),
            ],

            // Content: ShrinkingText title + description
            content: HeaderSlot(
              id: 'text_content',
              pinnedOnCollapse: true,
              child: Builder(
                builder: (context) {
                  final hp = HeaderProgress.of(context);
                  final progress = hp.curvedProgress;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShrinkingText(
                          text: 'Some very long text that is multiline when expanded and one line when shrunken',
                          progress: progress,
                          config: const HeaderTextConfig(
                            expandedFontSize: 28,
                            collapsedFontSize: 20,
                            expandedMaxLines: 3,
                            collapsedMaxLines: 1,
                            expandedFontWeight: FontWeight.bold,
                            collapsedFontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          animation: const HeaderAnimationConfig(
                            enableTextShrink: true,
                            oneLineThreshold: 0.85,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (progress < 0.5) ...[
                          SizedBox(height: 6.h),
                          Opacity(
                            opacity: (1.0 - progress * 2).clamp(0.0, 1.0),
                            child: Text(
                              'This subtitle fades out as the header collapses.',
                              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SliverList.builder(...),
        ],
      ),
    );
  }
}
```

| You build: | Package does: |
|---|---|
| back + share buttons | keeps them fixed |
| ShrinkingText(progress: hp...) | shrinks font + collapses lines |
| description with Opacity(...) | you manually fade with progress |

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

## Summary of Color Lerp Features

| Feature | Status | How to Use |
|---|---|---|
| Background color lerp | ✅ Already works | `enableColorLerp: true` |
| Icon color lerp | ⚠️ Properties exist, need manual | Use `Builder` + `HeaderProgress` |
| Text color lerp | ⚠️ Properties exist, need manual | Use `Builder` + `HeaderProgress` |
| Image overlay tint | ✅ Already works | `backgroundImage` + color lerp |

---

Here's the complete code for the search integration example:

## **`search_integration_example.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OPTION 1: Using the preset — just pass onSearchTap
// ─────────────────────────────────────────────────────────────────────────────

class BlinkitWithSearchPreset extends StatelessWidget {
  const BlinkitWithSearchPreset({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          LocationSliverHeader(
            locationName: 'HOME',
            locationAddress: 'Floor 2, Main Street',

            // ← just pass onSearchTap — that's it
            onSearchTap: () => context.go('/search'),

            onLocationTap: () => context.go('/location'),
            onProfileTap: () => context.go('/profile'),
            onFavoriteTap: () => context.go('/favorites'),
          ),

          SliverList.builder(
            itemCount: 40,
            itemBuilder: (_, i) => ListTile(
              title: Text('Item ${i + 1}'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OPTION 2: Manual style — full control over search bar tap
// ─────────────────────────────────────────────────────────────────────────────

class BlinkitWithSearchManual extends StatelessWidget {
  const BlinkitWithSearchManual({super.key});

  // The search bar widget — reused in both bar row and expanded content
  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/search'), // ← navigate on tap
      child: Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
        ),
        // AbsorbPointer prevents the text field from getting focus
        // since this is just a tap-to-navigate dummy bar
        child: AbsorbPointer(
          child: Row(
            children: [
              SizedBox(width: 14.w),
              Icon(Icons.search, color: Colors.grey, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                'Search for food...',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
              const Spacer(),
              Icon(Icons.mic, color: Colors.grey, size: 20.r),
              SizedBox(width: 14.w),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 300,
            collapsedHeight: 90,
            pinned: true,

            colors: const HeaderColorConfig(
              expandedBackgroundColor: Color(0xFF8B6914),
              collapsedBackgroundColor: Color(0xFF8B6914),
            ),

            layout: const HeaderLayoutConfig(
              horizontalPadding: 16,
              topPadding: 8,
              bottomPadding: 8,
              spacing: 8,
              leadingWidth: 40,
              trailingWidth: 40,
              contentBelowBar: true,
            ),

            animation: const HeaderAnimationConfig(
              curve: Curves.easeOutCubic,
              enableFade: true,
            ),

            leading: const HeaderSlot(
              id: 'location_icon',
              fixed: true,
              child: Icon(Icons.location_on, color: Colors.white),
            ),

            trailing: [
              const HeaderSlot(
                id: 'profile',
                fixed: true,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
              ),
              const HeaderSlot(
                id: 'favorite',
                fixed: false, // fades out
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],

            // ── Search bar in bar row — pins when collapsed ─────────────────
            // Same widget used here and in content below
            flexibleSpace: HeaderSlot(
              id: 'search_bar',
              pinnedOnCollapse: true, // stays in bar when collapsed
              child: _searchBar(context), // ← tapping goes to /search
            ),

            // ── Expanded content — fades out on scroll ──────────────────────
            content: HeaderSlot(
              id: 'blinkit_content',
              pinnedOnCollapse: false,
              fadeOnCollapse: true,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery time
                    Text(
                      'Blinkit in',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13.sp),
                    ),
                    Text(
                      '15 minutes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Location row — tap to change location
                    GestureDetector(
                      onTap: () => context.go('/location'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'HOME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '- Floor 2, Main Street',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13.sp),
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Colors.white),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Search bar inside expanded content
                    _searchBar(context), // ← same widget, same navigation

                    SizedBox(height: 10.h),

                    // Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chip('Delivery'),
                          SizedBox(width: 8.w),
                          _chip('15 minutes'),
                          SizedBox(width: 8.w),
                          _chip('Free delivery'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverList.builder(
            itemCount: 40,
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    i.isEven ? Colors.orange[100] : Colors.grey[100],
                child: Text('${i + 1}'),
              ),
              title: Text('Item ${i + 1}'),
              subtitle: const Text('Tap to add to cart'),
              trailing: const Icon(Icons.add_circle_outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.sp, color: Colors.white),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// The search screen you navigate TO
// ─────────────────────────────────────────────────────────────────────────────

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: TextField(
          autofocus: true, // keyboard opens immediately
          decoration: const InputDecoration(
            hintText: 'Search for food...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // your search logic here
          },
        ),
      ),
      body: const Center(
        child: Text('Search results appear here'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GoRouter setup
// ─────────────────────────────────────────────────────────────────────────────

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const BlinkitWithSearchManual(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// Main app entry point
// ─────────────────────────────────────────────────────────────────────────────

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
      builder: (context, child) => MaterialApp.router(
        title: 'Dynamic Sliver Header Demo',
        theme: ThemeData(useMaterial3: true),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

## **Key Features of This Example:**

| Feature | Implementation |
|---|---|
| **Preset usage** | `BlinkitWithSearchPreset` - just pass `onSearchTap` |
| **Manual control** | `BlinkitWithSearchManual` - full control over search bar |
| **Shared widget** | `_searchBar()` reused in both `flexibleSpace` and `content` |
| **Navigation** | `go_router` for seamless screen transitions |
| **AbsorbPointer** | Prevents keyboard focus on dummy search bar |
| **Autofocus** | Keyboard opens immediately on search screen |
| **Screenutil** | All sizes properly scaled |

This example shows two ways to implement search navigation with your package!

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
- ✅ All existing content (presets, manual examples, API reference)
- ✅ New Color Lerp section with complete documentation
- ✅ Real examples for transparent→white, gold→dark, and background image tinting
- ✅ Icon and text color transition examples using `HeaderProgress`
- ✅ Summary table at the end showing feature status
- ✅ Presets note explaining how to use color lerp with presets