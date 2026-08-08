

---

# dynamic_sliver_header

A fully dynamic, animated `SliverPersistentHeader` for Flutter. Build collapsing headers with fade, scale, slide, color-lerp, and text-shrink animations — either from ready-made presets or fully custom slots.

[![pub package](https://img.shields.io/pub/v/dynamic_sliver_header.svg)](https://pub.dev/packages/dynamic_sliver_header)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

---

## Features

- 🎛️ **Slot-based layout** — `leading`, `trailing`, `flexibleSpace`, and `content` slots, each with independent animation flags
- 📦 **Three presets** — `LocationSliverHeader` (food-delivery style), `RalphsSliverHeader` (grocery-store style), `TextShrinkSliverHeader` (multiline title that shrinks to one line)
- 📊 **Live scroll progress** — read `HeaderProgress.of(context)` from any widget inside a slot
- 🖼️ **Optional background image** — with color overlay and gradient scrim
- 📱 **`flutter_screenutil` integration** — layout values scale automatically once you wrap your app in `ScreenUtilInit`
- 🎨 **Color lerp** — smooth background color transition from expanded to collapsed
- 📝 **Text shrink** — smoothly animate font size and max lines
- 🔧 **Full control** — every animation is opt-in via simple flags

---

## Installation

```yaml
dependencies:
  dynamic_sliver_header: ^1.0.0
  flutter_screenutil: ^5.9.3
```

Then wrap your app in `ScreenUtilInit` — this is **required** because the package's `.h`/`.w`/`.r`/`.sp` scaling reads from it:

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

## Quick Start

### Use a Preset

```dart
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

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

### Build Your Own

`colors`, `layout`, and `animation` are all optional — omit them to use the defaults:

```dart
DynamicSliverHeader(
  expandedHeight: 300,
  collapsedHeight: 90,
  pinned: true,
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
      fixed: false, // fades out as header collapses
      child: Icon(Icons.favorite_border, color: Colors.white),
    ),
  ],
  flexibleSpace: HeaderSlot(
    id: 'searchbar',
    pinnedOnCollapse: true, // stays in bar row when collapsed
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

## Live Scroll Progress

Any widget inside a slot can read the header's current state via `HeaderProgress.of(context)`:

```dart
content: HeaderSlot(
  id: 'progress_demo',
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return Column(
        children: [
          Text('Raw: ${hp.progress.toStringAsFixed(2)}'),
          Text('Curved: ${hp.curvedProgress.toStringAsFixed(2)}'),
          Text('Height: ${hp.height.toStringAsFixed(0)}px'),
          if (hp.isExpanded) const Text('⬆️ Fully expanded'),
          if (hp.isCollapsed) const Text('⬇️ Fully collapsed'),
          LinearProgressIndicator(value: hp.progress),
        ],
      );
    },
  ),
),
```

### Available Properties

| Getter | Type | Description |
|---|---|---|
| `progress` | `double` | Raw scroll progress, `0.0` (expanded) → `1.0` (collapsed) |
| `curvedProgress` | `double` | Same, with the header's `animation.curve` applied |
| `height` | `double` | Current rendered height of the header, in logical pixels |
| `isExpanded` | `bool` | `true` when `progress <= 0.01` |
| `isCollapsed` | `bool` | `true` when `progress >= 0.99` |

> **Note:** `HeaderProgress.maybeOf(context)` returns `null` instead of throwing if called outside a `DynamicSliverHeader`.

---

## Image Loading & Error Handling

When using `backgroundImage` with remote images, it's recommended to handle loading states and errors gracefully. Here are some approaches:

### Option 1: `cached_network_image` (Recommended)

For production apps, use `cached_network_image` for caching and better error handling:

```yaml
dependencies:
  cached_network_image: ^3.3.1
```

```dart
import 'package:cached_network_image/cached_network_image.dart';

DynamicSliverHeader(
  expandedHeight: 280,
  collapsedHeight: 88,
  backgroundImage: CachedNetworkImageProvider(
    'https://example.com/banner.jpg',
  ),
  colors: const HeaderColorConfig(
    expandedBackgroundColor: Colors.transparent,
    collapsedBackgroundColor: Color(0xFF37474F),
    // Gradient scrim for text readability
    expandedGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black54],
    ),
  ),
  // ... rest of config
)
```

### Option 2: `Image.network` with `errorBuilder`

Using standard Flutter `Image.network` with error handling:

```dart
backgroundImage: NetworkImageWithFallback(
  'https://example.com/banner.jpg',
  fallbackAsset: 'assets/images/fallback.png',
),
```

Create a helper class:

```dart
class NetworkImageWithFallback extends ImageProvider {
  final String url;
  final String? fallbackAsset;

  const NetworkImageWithFallback(this.url, {this.fallbackAsset});

  @override
  ImageStreamCompleter loadImage(
    ImageProvider<Object> key,
    ImageDecoderCallback decode,
  ) {
    return NetworkImage(url).loadImage(key, decode);
  }

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<Object>(url);
  }
}
```

### Option 3: Manual Error Handling in `content` Slot

For more control, handle errors manually in the `content` slot:

```dart
content: HeaderSlot(
  id: 'image_content',
  pinnedOnCollapse: false,
  fadeOnCollapse: true,
  child: Builder(
    builder: (context) {
      return FutureBuilder(
        future: precacheImage(
          NetworkImage('https://example.com/image.jpg'),
          context,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            );
          }
          return Image.network(
            'https://example.com/image.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          );
        },
      );
    },
  ),
),
```

### Option 4: Using `extended_image` Package

For advanced image handling (zoom, gesture, caching):

```yaml
dependencies:
  extended_image: ^8.0.0
```

```dart
import 'package:extended_image/extended_image.dart';

DynamicSliverHeader(
  expandedHeight: 280,
  collapsedHeight: 88,
  backgroundImage: ExtendedNetworkImageProvider(
    'https://example.com/banner.jpg',
    cache: true,
    retry: 3,
    timeToLive: const Duration(days: 7),
  ),
  // ... rest of config
)
```

### Recommended Production Setup

For most production apps, this is the recommended approach:

```dart
import 'package:cached_network_image/cached_network_image.dart';

class ProductHeaderWithImage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onBackTap;

  const ProductHeaderWithImage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicSliverHeader(
      expandedHeight: 280,
      collapsedHeight: 80,
      pinned: true,
      backgroundImage: CachedNetworkImageProvider(imageUrl),
      colors: HeaderColorConfig(
        expandedBackgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.white,
        expandedGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.5),
          ],
        ),
      ),
      leading: HeaderSlot(
        id: 'back',
        fixed: true,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBackTap,
        ),
      ),
      content: HeaderSlot(
        id: 'title',
        pinnedOnCollapse: true,
        child: Builder(
          builder: (context) {
            final hp = HeaderProgress.of(context);
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: ShrinkingText(
                text: title,
                progress: hp.curvedProgress,
                config: const HeaderTextConfig(
                  expandedFontSize: 28,
                  collapsedFontSize: 18,
                  expandedMaxLines: 3,
                  collapsedMaxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                animation: const HeaderAnimationConfig(
                  enableTextShrink: true,
                  oneLineThreshold: 0.85,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

---

## Presets

### 1. `LocationSliverHeader` — Food-Delivery Style

Location name/address, a search bar that pins into the bar row on collapse, and a horizontal row of filter chips.

```dart
LocationSliverHeader(
  locationName: 'Home',
  locationAddress: '221B Baker Street',
  searchHint: 'Search for food...',
  chips: const ['Delivery', '15–30 min', 'Free delivery'],
  expandedHeight: 280,
  collapsedHeight: 88,
  backgroundColor: Colors.white,
  onLocationTap: () {},
  onSearchTap: () {},
  onProfileTap: () {},
  onFavoriteTap: () {},
)
```

**Required:** `locationName`, `locationAddress`

**Behavior:** Location info + chips fade out. Search bar pins inside the bar row when collapsed.

---

### 2. `RalphsSliverHeader` — Grocery-Store Style

Store avatar, title/subtitle, a promo banner, and a search bar that pins into the bar row on collapse.

```dart
RalphsSliverHeader(
  title: 'CSP Traders',
  subtitle: 'Ponmanai, Kanyakumari',
  searchHint: 'Search products...',
  promoText: 'Save up to 20% on your first order!',
  expandedHeight: 280,
  collapsedHeight: 88,
  backgroundColor: const Color(0xFFB71C1C),
  onSearchTap: () {},
  onCartTap: () {},
)
```

**Required:** `title`, `subtitle`

**Behavior:** Logo + title + promo fade and scale out. Search bar pins inside the bar row when collapsed.

---

### 3. `TextShrinkSliverHeader` — Multiline to Single Line

A large multiline title that shrinks to a single ellipsized line as the header collapses. An optional description fades out once the header is roughly half-collapsed.

```dart
TextShrinkSliverHeader(
  title: 'Understanding Cement Grades: OPC vs PPC vs PSC',
  description: 'A practical guide for contractors.',
  expandedHeight: 200,
  collapsedHeight: 80,
  backgroundColor: const Color(0xFFCDDC39),
  onBackTap: () {},
  onShareTap: () {},
)
```

**Required:** `title`

**Behavior:** Title font smoothly shrinks and collapses to 1 line with ellipsis. Description fades out in the first half of collapse.

---

## Core Building Blocks

### `DynamicSliverHeader`

| Parameter | Type | Default |
|---|---|---|
| `expandedHeight` | `double` | **required** |
| `collapsedHeight` | `double` | **required** |
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

---

### `HeaderSlot`

Wraps a widget and declares how it animates as the header collapses.

```dart
HeaderSlot(
  id: 'my_slot',        // required, used for keying/debugging
  child: MyWidget(),    // required
  fixed: false,               // leading/trailing only: no fade if true
  pinnedOnCollapse: false,    // flexibleSpace/content only: stays in bar row if true
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

---

### `HeaderColorConfig`

```dart
HeaderColorConfig(
  expandedBackgroundColor: Color(0xFF2196F3), // default
  collapsedBackgroundColor: Color(0xFF2196F3), // default
  expandedIconColor: null,
  collapsedIconColor: null,
  expandedTextColor: null,
  collapsedTextColor: null,
  expandedGradient: null,     // e.g. a bottom scrim over a background image
  gradientOpacity: 1.0,
)
```

---

### `HeaderLayoutConfig`

```dart
HeaderLayoutConfig(
  horizontalPadding: 16.0,
  topPadding: 12.0,
  bottomPadding: 12.0,
  spacing: 12.0,
  leadingWidth: 48.0,
  trailingWidth: 48.0,
  respectSafeArea: true,   // adds device's top safe-area inset automatically
  contentBelowBar: true,   // lay content out below leading/trailing row
)
```

---

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

> **Tip:** `HeaderAnimationConfig.none` disables all animations — useful for debugging layout.

---

## Advanced Patterns

### Search Bar Pinning (Ralphs/Kroger Style)

The search bar pins to the top when you scroll up, and text appears inside it:

```dart
flexibleSpace: HeaderSlot(
  id: 'search',
  pinnedOnCollapse: true,  // ← Search bar pins!
  child: GestureDetector(
    onTap: onSearchTap,
    child: Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 14.w),
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8.w),
          Expanded(
            child: Builder(
              builder: (context) {
                final hp = HeaderProgress.of(context);
                return Opacity(
                  opacity: hp.curvedProgress, // ← Fades IN when collapsed
                  child: Text(
                    'Search products...',
                    style: TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  ),
),
```

### Text Shrink (Title Shrinks to One Line)

```dart
content: HeaderSlot(
  id: 'title',
  pinnedOnCollapse: true,
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return ShrinkingText(
        text: 'Your Long Title Here',
        progress: hp.curvedProgress,
        config: const HeaderTextConfig(
          expandedFontSize: 28,
          collapsedFontSize: 18,
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
        style: const TextStyle(color: Colors.black),
      );
    },
  ),
),
```

### Background Image with Gradient Scrim

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
  // ... leading/trailing/content
)
```

### Color Lerp — Smooth Background Transition

```dart
colors: const HeaderColorConfig(
  expandedBackgroundColor: Colors.transparent, // ← when expanded
  collapsedBackgroundColor: Colors.white,      // ← when collapsed
),
animation: const HeaderAnimationConfig(
  enableColorLerp: true, // ← smooth transition
),
```

---

## Complete Example: Grocery Product Detail Page (Kroger Style)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 380,
            collapsedHeight: 56,
            pinned: true,
            colors: const HeaderColorConfig(
              expandedBackgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
            ),
            layout: HeaderLayoutConfig(
              horizontalPadding: 0,
              topPadding: 0,
              bottomPadding: 0,
              spacing: 0,
              leadingWidth: 48.w,
              trailingWidth: 96.w,
              contentBelowBar: false,
            ),
            animation: const HeaderAnimationConfig(
              curve: Curves.easeOutCubic,
              enableFade: false,
              enableColorLerp: false,
            ),

            // ── Close button ──
            leading: HeaderSlot(
              id: 'close',
              fixed: true,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ── Bookmark + Share ──
            trailing: [
              HeaderSlot(
                id: 'bookmark',
                fixed: true,
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.black),
                  onPressed: () {},
                ),
              ),
              HeaderSlot(
                id: 'share',
                fixed: true,
                child: IconButton(
                  icon: const Icon(Icons.ios_share, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],

            // ── Title appears in bar when collapsed ──
            flexibleSpace: HeaderSlot(
              id: 'appbar_title',
              pinnedOnCollapse: true,
              child: Builder(
                builder: (context) {
                  final hp = HeaderProgress.of(context);
                  return Opacity(
                    opacity: hp.curvedProgress.clamp(0.0, 1.0),
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Text(
                        'Spindrift Island Punch',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Product image + hero title (fades out) ──
            content: HeaderSlot(
              id: 'product_hero',
              pinnedOnCollapse: false,
              child: Builder(
                builder: (context) {
                  final hp = HeaderProgress.of(context);
                  final heroTitleOpacity =
                      (1.0 - hp.curvedProgress * 1.7).clamp(0.0, 1.0);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Product image
                      Image.network(
                        'https://picsum.photos/seed/product/800/600',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFFCE4EC),
                          child: Center(
                            child: Icon(
                              Icons.local_drink,
                              size: 80.r,
                              color: const Color(0xFFE91E63),
                            ),
                          ),
                        ),
                      ),
                      // Bottom gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 130.h,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.white,
                                Color(0xCCFFFFFF),
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Hero title
                      Positioned(
                        bottom: 14.h,
                        left: 16.w,
                        right: 16.w,
                        child: Opacity(
                          opacity: heroTitleOpacity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (_) => Icon(
                                      Icons.star,
                                      size: 14.r,
                                      color: const Color(0xFFF59E0B),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '4.9 (8)',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Spindrift Island Punch Sparkling Water 8pk',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '12 fl oz · 8 × 12 fl oz',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // ── Product details body ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$6.99',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'reg. \$7.99',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      'Add loyalty card',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  SizedBox(height: 20.h),
                  Text(
                    'Product information',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• Zero sugar',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Bottom padding for the cart bar
          SliverToBoxAdapter(child: SizedBox(height: 90.h)),
        ],
      ),
    );
  }
}
```

---

## Real-World Usage: Search Page Integration

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          RalphsSliverHeader(
            title: 'CSP Traders',
            subtitle: 'Ponmanai, Kanyakumari',
            searchHint: 'Search for groceries...',
            onSearchTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            onCartTap: () {},
          ),
          SliverList.builder(
            itemCount: 50,
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text('Product ${i + 1}'),
              trailing: const Icon(Icons.add_circle_outline),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search groceries...',
            border: InputBorder.none,
          ),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Search results will appear here'),
      ),
    );
  }
}
```

---

## Slot Behavior Reference

| Property | Type | Default | Where | Effect |
|---|---|---|---|---|
| `fixed` | `bool` | `false` | Leading/Trailing | `true` = always visible, never animates |
| `pinnedOnCollapse` | `bool` | `false` | FlexibleSpace/Content | `true` = stays in bar row when collapsed |
| `hideOnCollapse` | `bool` | `false` | Any | Becomes invisible at `progress >= 0.99` |
| `fadeOnCollapse` | `bool` | `false` | Any | Opacity `1 → 0` as `progress` goes `0 → 1` |
| `scaleOnCollapse` | `bool` | `false` | Any | Scale from `expandedScale` → `collapsedScale` |
| `slideOnCollapse` | `bool` | `false` | Any | Translate from `expandedOffset` → `collapsedOffset` |

---

## Common Pitfalls

### ❌ Forgetting `ScreenUtilInit`
The package uses `flutter_screenutil` internally. Without `ScreenUtilInit`, `.h`/`.w`/`.r`/`.sp` calls throw errors.

### ❌ Using `HeaderProgress.of(context)` outside a slot
`HeaderProgress` is only available inside a `DynamicSliverHeader` slot. Use `HeaderProgress.maybeOf(context)` if you're unsure.

### ❌ Not providing enough scrollable content
In a `CustomScrollView`, the header only collapses as far as the content allows. Make sure you have enough scrollable content beneath the header to see the full collapse animation.

### ❌ Confusing `pinned` vs `pinnedOnCollapse`
- `pinned` (on `DynamicSliverHeader`) → header stays at top of viewport
- `pinnedOnCollapse` (on `HeaderSlot`) → widget stays in bar row when collapsed

---

## Example App

A runnable example lives in `example/`, with one screen per preset plus a fully custom header:

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
| `custom_demo_screen.dart` | Raw `HeaderSlot`s + live progress readout |

---

## Requirements

- Flutter >= 3.10.0
- Dart >= 3.0.0
- `flutter_screenutil` >= 5.9.3

---

## License

MIT

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run `flutter test` to ensure all tests pass
4. Submit a pull request

Please ensure:
- All tests pass (`flutter test`)
- No analysis issues (`flutter analyze`)
- New features include tests
- Documentation is updated

---

## Credits

Created with ❤️ for the Flutter community. Built on top of Flutter's `SliverPersistentHeader`.



---

## All Features Overview

| Feature | Supported | Widget/Property |
|---|---|---|
| ✅ **Text Shrinking** | Yes | `ShrinkingText` / `TextShrinkSliverHeader` |
| ✅ **Pin on Scroll (Search Bar)** | Yes | `pinnedOnCollapse: true` on `flexibleSpace` |
| ✅ **Translate/Slide Animation** | Yes | `slideOnCollapse: true` + `expandedOffset` / `collapsedOffset` |
| ✅ **Fade Animation** | Yes | `fadeOnCollapse: true` |
| ✅ **Scale Animation** | Yes | `scaleOnCollapse: true` |
| ✅ **Color Lerp** | Yes | `enableColorLerp: true` |
| ✅ **Hide on Collapse** | Yes | `hideOnCollapse: true` |
| ✅ **Background Image** | Yes | `backgroundImage` |
| ✅ **Live Progress** | Yes | `HeaderProgress.of(context)` |

---

## 1. Text Shrinking

### Preset (Easiest)
```dart
TextShrinkSliverHeader(
  title: 'Understanding Cement Grades: OPC vs PPC vs PSC',
  description: 'A practical guide for contractors.',
  onBackTap: () {},
)
```

### Manual (Full Control)
```dart
content: HeaderSlot(
  id: 'title',
  pinnedOnCollapse: true,
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return ShrinkingText(
        text: 'Your Long Title Here',
        progress: hp.curvedProgress,
        config: const HeaderTextConfig(
          expandedFontSize: 28,
          collapsedFontSize: 18,
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
        style: const TextStyle(color: Colors.black),
      );
    },
  ),
),
```

---

## 2. Pin on Scroll (Search Bar Pins to Top)

```dart
DynamicSliverHeader(
  expandedHeight: 280,
  collapsedHeight: 88,
  pinned: true,

  flexibleSpace: HeaderSlot(
    id: 'search_bar',
    pinnedOnCollapse: true,  // ← THIS PINS WHEN SCROLLED
    child: GestureDetector(
      onTap: onSearchTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8.w),
            Expanded(
              child: Builder(
                builder: (context) {
                  final hp = HeaderProgress.of(context);
                  return Opacity(
                    opacity: hp.curvedProgress, // ← Fades IN when collapsed
                    child: Text(
                      'Search products...',
                      style: TextStyle(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  ),

  content: HeaderSlot(
    id: 'hero_content',
    pinnedOnCollapse: false,
    fadeOnCollapse: true,  // ← Fades out when scrolled
    child: YourContent(),
  ),
)
```

---

## 3. Translate/Slide Animation

Widget slides/translates as the header collapses:

```dart
content: HeaderSlot(
  id: 'sliding_content',
  slideOnCollapse: true,  // ← SLIDE ANIMATION
  expandedOffset: Offset.zero,      // ← Starting position (expanded)
  collapsedOffset: Offset(0, -50),  // ← Ending position (collapsed)
  child: YourWidget(),
)
```

### Complete Example: Sliding Profile Card

```dart
content: HeaderSlot(
  id: 'profile_card',
  slideOnCollapse: true,
  expandedOffset: Offset.zero,
  collapsedOffset: Offset(20, -30), // ← Slides up and right
  fadeOnCollapse: true,              // ← Also fades out
  child: Card(
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                'Product Manager',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
)
```

### Multiple Animations Combined

```dart
content: HeaderSlot(
  id: 'animated_card',
  slideOnCollapse: true,
  expandedOffset: Offset.zero,
  collapsedOffset: Offset(0, -40),  // Slides up
  scaleOnCollapse: true,
  expandedScale: 1.0,
  collapsedScale: 0.8,              // Scales down
  fadeOnCollapse: true,              // Fades out
  child: YourWidget(),
)
```

---

## 4. Fade Animation

```dart
content: HeaderSlot(
  id: 'fading_content',
  fadeOnCollapse: true,  // ← FADES OUT
  child: Text('This fades out as you scroll'),
)
```

### Custom Fade with Progress

```dart
content: HeaderSlot(
  id: 'custom_fade',
  child: Builder(
    builder: (context) {
      final hp = HeaderProgress.of(context);
      return Opacity(
        opacity: 1.0 - hp.curvedProgress, // ← Manual fade control
        child: Text('Custom fade behavior'),
      );
    },
  ),
),
```

---

## 5. Scale Animation

```dart
content: HeaderSlot(
  id: 'scaling_content',
  scaleOnCollapse: true,     // ← SCALES
  expandedScale: 1.0,        // ← Full size when expanded
  collapsedScale: 0.7,       // ← 70% size when collapsed
  child: YourWidget(),
)
```

---

## 6. Hide on Collapse (Hard Hide)

```dart
content: HeaderSlot(
  id: 'hide_content',
  hideOnCollapse: true,  // ← COMPLETELY HIDES at progress >= 0.99
  child: Text('Disappears when fully collapsed'),
)
```

---

## 7. Complete Example: All Features Together

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

class AllFeaturesDemo extends StatelessWidget {
  const AllFeaturesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 400,
            collapsedHeight: 80,
            pinned: true,

            colors: const HeaderColorConfig(
              expandedBackgroundColor: Color(0xFF6C63FF),
              collapsedBackgroundColor: Color(0xFF4A44CC),
            ),

            animation: const HeaderAnimationConfig(
              curve: Curves.easeOutCubic,
              enableFade: true,
              enableScale: true,
              enableSlide: true,
              enableColorLerp: true,
              enableTextShrink: true,
            ),

            // ── Leading: Fixed back button ──
            leading: HeaderSlot(
              id: 'back',
              fixed: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ── Trailing: Fixed + fading ──
            trailing: [
              HeaderSlot(
                id: 'search',
                fixed: true,  // ← Always visible
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
              ),
              HeaderSlot(
                id: 'favorite',
                fixed: false,  // ← Fades out
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],

            // ── Search bar: Pins when collapsed ──
            flexibleSpace: HeaderSlot(
              id: 'search_bar',
              pinnedOnCollapse: true,  // ← PIN ON SCROLL
              child: Builder(
                builder: (context) {
                  final hp = HeaderProgress.of(context);
                  return Container(
                    height: 44.h,
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 14.w),
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Opacity(
                            opacity: hp.curvedProgress, // ← Fades IN when collapsed
                            child: Text(
                              'Search products...',
                              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Content: All animations combined ──
            content: HeaderSlot(
              id: 'hero_content',
              pinnedOnCollapse: false,
              fadeOnCollapse: true,      // ← FADES OUT
              scaleOnCollapse: true,      // ← SCALES DOWN
              slideOnCollapse: true,      // ← SLIDES UP
              expandedScale: 1.0,
              collapsedScale: 0.8,
              expandedOffset: Offset.zero,
              collapsedOffset: Offset(0, -30),
              child: Builder(
                builder: (context) {
                  final hp = HeaderProgress.of(context);
                  return Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Image with gradient ──
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.network(
                                'https://picsum.photos/seed/demo/800/400',
                                height: 200.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 200.h,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 80.h,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // ── Shrinking Title ──
                        ShrinkingText(
                          text: 'This is a long product title that shrinks from multiple lines to a single line with ellipsis',
                          progress: hp.curvedProgress,
                          config: const HeaderTextConfig(
                            expandedFontSize: 28,
                            collapsedFontSize: 18,
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
                        SizedBox(height: 8.h),

                        // ── Description: Fades out ──
                        Opacity(
                          opacity: (1.0 - hp.curvedProgress * 2).clamp(0.0, 1.0),
                          child: Text(
                            'This description fades out as the header collapses. It has a smooth transition.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Rating: Slides and fades ──
                        Opacity(
                          opacity: 1.0 - hp.curvedProgress,
                          child: Transform.translate(
                            offset: Offset(0, hp.curvedProgress * 20),
                            child: Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (_) => Icon(
                                    Icons.star,
                                    size: 20.r,
                                    color: Colors.amber,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '4.9 (128 reviews)',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // ── List content ──
          SliverList.builder(
            itemCount: 30,
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: i.isEven ? Colors.purple[100] : Colors.grey[100],
                child: Text('${i + 1}'),
              ),
              title: Text('Item ${i + 1}'),
              subtitle: Text('Description for item ${i + 1}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Summary Table

| Feature | Property/Method | Example |
|---|---|---|
| **Text Shrinking** | `ShrinkingText` | `ShrinkingText(text: '...', config: HeaderTextConfig(...))` |
| **Pin on Scroll** | `pinnedOnCollapse: true` | `flexibleSpace: HeaderSlot(pinnedOnCollapse: true, ...)` |
| **Slide/Translate** | `slideOnCollapse: true` | `HeaderSlot(slideOnCollapse: true, expandedOffset: ..., collapsedOffset: ...)` |
| **Fade** | `fadeOnCollapse: true` | `HeaderSlot(fadeOnCollapse: true, ...)` |
| **Scale** | `scaleOnCollapse: true` | `HeaderSlot(scaleOnCollapse: true, expandedScale: 1.0, collapsedScale: 0.8)` |
| **Hide** | `hideOnCollapse: true` | `HeaderSlot(hideOnCollapse: true, ...)` |
| **Color Lerp** | `enableColorLerp: true` | `HeaderAnimationConfig(enableColorLerp: true)` |
| **Background Image** | `backgroundImage` | `backgroundImage: NetworkImage('...')` |
| **Live Progress** | `HeaderProgress.of(context)` | `final hp = HeaderProgress.of(context);` |

---

## Presets That Use These Features

| Preset | Features Used |
|---|---|
| `LocationSliverHeader` | Fade, Pin on Scroll |
| `RalphsSliverHeader` | Fade, Scale, Pin on Scroll |
| `TextShrinkSliverHeader` | Text Shrink, Pin on Scroll, Fade |

