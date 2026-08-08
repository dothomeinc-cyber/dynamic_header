import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the test surface to [designSize] (in logical pixels) so
/// `flutter_screenutil`'s `.h`/`.w`/`.r`/`.sp` scale factors come out to
/// ~1.0, matching what a real phone at that design size would render.
///
/// Without this, `flutter_test`'s default 800x600 surface is much wider
/// than the package's 360x690 design size, so ScreenUtil scales every
/// `.w`/`.r`/`.h` value up by ~2.2x — inflating icon sizes, paddings, and
/// avatar radii well past what actually fits, causing spurious
/// RenderFlex overflows that don't reflect real-device behaviour.
///
/// Callers must call `addTearDown(tester.view.reset)` (or otherwise reset
/// the view) after use so later tests in the same file aren't affected.
void pinTestSurface(WidgetTester tester, {Size designSize = const Size(360, 690)}) {
  // Set DPR first. `physicalSize` is expressed in physical pixels, so
  // setting it before changing DPR makes the resulting logical viewport
  // larger than [designSize] on high-DPI test hosts.
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = designSize;
  addTearDown(tester.view.reset);
}

/// Wraps [child] with the [MaterialApp] + [ScreenUtilInit] boilerplate every
/// widget in this package needs, since `.h`/`.w`/`.r`/`.sp` all read from
/// the `ScreenUtil()` singleton and throw/misbehave if it isn't
/// initialized first.
///
/// Mirrors the app's real screenutil designSize convention (360x690) so
/// scaled values in tests match what the app would actually render. Pair
/// this with [pinTestSurface] in any test that lays out real preset
/// content (not just isolated small widgets), or ScreenUtil's scale
/// factors won't match the designSize and layouts can overflow.
Widget wrapWithScreenUtil(Widget child, {Size designSize = const Size(360, 690)}) {
  return ScreenUtilInit(
    designSize: designSize,
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: child,
    ),
  );
}

/// Pumps a [CustomScrollView] containing [sliver] as its only sliver, with
/// [bodyExtent] worth of scrollable filler content beneath it so the sliver
/// has room to actually collapse during a drag/scroll gesture. Pass
/// [controller] to drive the scroll position deterministically via
/// `controller.jumpTo(...)` instead of simulating a drag/fling gesture --
/// gesture simulation only travels as far as its motion + release
/// velocity happen to carry it under the scroll physics' friction curve,
/// which does not reliably reach a specific target offset.
Widget wrapSliverInScrollView(
  Widget sliver, {
  double bodyExtent = 2000,
  ScrollController? controller,
}) {
  return Scaffold(
    body: CustomScrollView(
      controller: controller,
      slivers: [
        sliver,
        SliverToBoxAdapter(
          child: SizedBox(height: bodyExtent),
        ),
      ],
    ),
  );
}

/// Convenience: pins the test surface to [designSize], pumps [sliver]
/// inside a scrollable + screenutil-wrapped tree, then settles. Pass
/// [controller] through to [wrapSliverInScrollView] if the test needs to
/// drive the scroll offset directly (see its doc comment for why that's
/// preferable to `tester.drag`/`tester.fling` for reaching an exact,
/// fully-collapsed or fully-expanded state).
Future<void> pumpHeader(
  WidgetTester tester,
  Widget sliver, {
  Size designSize = const Size(360, 690),
  double bodyExtent = 2000,
  ScrollController? controller,
}) async {
  pinTestSurface(tester, designSize: designSize);
  await tester.pumpWidget(
    wrapWithScreenUtil(
      wrapSliverInScrollView(
        sliver,
        bodyExtent: bodyExtent,
        controller: controller,
      ),
      designSize: designSize,
    ),
  );
  await tester.pumpAndSettle();
}
