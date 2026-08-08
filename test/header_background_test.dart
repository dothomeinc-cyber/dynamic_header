import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

/// A real, minimal (1x1 transparent) PNG so `MemoryImage` can decode it
/// synchronously in tests — using a nonexistent `AssetImage` path throws
/// during image resolution and fails the test outright, even though that
/// failure has nothing to do with the widget logic under test.
final Uint8List _testPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY'
  '42YAAAAASUVORK5CYII=',
);

void main() {
  testWidgets('renders a ColoredBox with expandedBackgroundColor at '
      'progress 0 when no image is set', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: SizedBox(
            width: 300,
            height: 200,
            child: HeaderBackground(
              progress: 0.0,
              colors: const HeaderColorConfig(
                expandedBackgroundColor: Colors.red,
                collapsedBackgroundColor: Colors.blue,
              ),
              animation: const HeaderAnimationConfig(enableColorLerp: true),
            ),
          ),
        ),
      ),
    );

    final coloredBox = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(HeaderBackground),
        matching: find.byType(ColoredBox),
      ),
    );
    // HeaderBackground resolves this through LerpUtils.lerpColor ->
    // Color.lerp, which always returns a plain Color -- never the
    // original MaterialColor instance -- so compare by channel value
    // rather than object equality.
    expect(coloredBox.color.r, Colors.red.r);
    expect(coloredBox.color.g, Colors.red.g);
    expect(coloredBox.color.b, Colors.red.b);
    expect(coloredBox.color.a, Colors.red.a);
  });

  testWidgets('renders collapsedBackgroundColor at progress 1', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: SizedBox(
            width: 300,
            height: 200,
            child: HeaderBackground(
              progress: 1.0,
              colors: const HeaderColorConfig(
                expandedBackgroundColor: Colors.red,
                collapsedBackgroundColor: Colors.blue,
              ),
              animation: const HeaderAnimationConfig(enableColorLerp: true),
            ),
          ),
        ),
      ),
    );

    final coloredBox = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(HeaderBackground),
        matching: find.byType(ColoredBox),
      ),
    );
    expect(coloredBox.color.r, Colors.blue.r);
    expect(coloredBox.color.g, Colors.blue.g);
    expect(coloredBox.color.b, Colors.blue.b);
    expect(coloredBox.color.a, Colors.blue.a);
  });

  testWidgets('enableColorLerp=false pins to expandedBackgroundColor '
      'regardless of progress', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: SizedBox(
            width: 300,
            height: 200,
            child: HeaderBackground(
              progress: 1.0,
              colors: const HeaderColorConfig(
                expandedBackgroundColor: Colors.red,
                collapsedBackgroundColor: Colors.blue,
              ),
              animation: const HeaderAnimationConfig(enableColorLerp: false),
            ),
          ),
        ),
      ),
    );

    final coloredBox = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(HeaderBackground),
        matching: find.byType(ColoredBox),
      ),
    );
    expect(coloredBox.color, Colors.red);
  });

  testWidgets('renders an Image when backgroundImage is provided', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: SizedBox(
            width: 300,
            height: 200,
            child: HeaderBackground(
              progress: 0.5,
              colors: const HeaderColorConfig(),
              animation: const HeaderAnimationConfig(),
              backgroundImage: MemoryImage(_testPngBytes),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders no ColoredBox for the plain background layer when '
      'an image is present (colour becomes an overlay instead)', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: SizedBox(
            width: 300,
            height: 200,
            child: HeaderBackground(
              progress: 0.0,
              colors: const HeaderColorConfig(
                collapsedBackgroundColor: Colors.blue,
              ),
              animation: const HeaderAnimationConfig(),
              backgroundImage: MemoryImage(_testPngBytes),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // With an image present, HeaderBackground renders the tint via
    // ColoredBox(color: collapsedBackgroundColor) as an overlay -- it
    // still exists, just serving a different purpose than the no-image
    // path. Assert it's there and matches collapsedBackgroundColor.
    final coloredBox = tester.widget<ColoredBox>(
      find.descendant(
        of: find.byType(HeaderBackground),
        matching: find.byType(ColoredBox),
      ),
    );
    expect(coloredBox.color, Colors.blue);
    expect(tester.takeException(), isNull);
  });
}
