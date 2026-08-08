import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

void main() {
  testWidgets('hideOnCollapse hides the child once progress >= 0.99', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(
              id: 'x',
              hideOnCollapse: true,
              child: Text('visible?'),
            ),
            progress: 1.0,
            animation: const HeaderAnimationConfig(),
          ),
        ),
      ),
    );

    expect(find.text('visible?'), findsNothing);
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('hideOnCollapse does not hide the child below the threshold', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(
              id: 'x',
              hideOnCollapse: true,
              child: Text('visible?'),
            ),
            progress: 0.5,
            animation: const HeaderAnimationConfig(),
          ),
        ),
      ),
    );

    expect(find.text('visible?'), findsOneWidget);
  });

  testWidgets('fadeOnCollapse wraps the child in an Opacity widget', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(
              id: 'x',
              fadeOnCollapse: true,
              child: Text('fading'),
            ),
            progress: 0.3,
            animation: const HeaderAnimationConfig(enableFade: true),
          ),
        ),
      ),
    );

    final opacityFinder = find.ancestor(
      of: find.text('fading'),
      matching: find.byType(Opacity),
    );
    expect(opacityFinder, findsOneWidget);

    final opacityWidget = tester.widget<Opacity>(opacityFinder);
    // Fades out over [0, 0.6]; at progress 0.3 that's 1 - 0.5 = 0.5.
    expect(opacityWidget.opacity, closeTo(0.5, 1e-9));
  });

  testWidgets('fadeOnCollapse has no effect when animation.enableFade is '
      'false (master switch off)', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(
              id: 'x',
              fadeOnCollapse: true,
              child: Text('not fading'),
            ),
            progress: 0.9,
            animation: const HeaderAnimationConfig(enableFade: false),
          ),
        ),
      ),
    );

    final opacityFinder = find.ancestor(
      of: find.text('not fading'),
      matching: find.byType(Opacity),
    );
    expect(opacityFinder, findsNothing);
  });

  testWidgets('scaleOnCollapse applies a Transform.scale', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(
              id: 'x',
              scaleOnCollapse: true,
              expandedScale: 1.0,
              collapsedScale: 0.5,
              child: Text('scaling'),
            ),
            progress: 1.0,
            animation: const HeaderAnimationConfig(enableScale: true),
          ),
        ),
      ),
    );

    final transformFinder = find.ancestor(
      of: find.text('scaling'),
      matching: find.byType(Transform),
    );
    expect(transformFinder, findsOneWidget);
  });

  testWidgets('slideOnCollapse applies a Transform.translate', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(
              id: 'x',
              slideOnCollapse: true,
              expandedOffset: Offset.zero,
              collapsedOffset: Offset(20, 0),
              child: Text('sliding'),
            ),
            progress: 1.0,
            animation: const HeaderAnimationConfig(enableSlide: true),
          ),
        ),
      ),
    );

    final transformFinder = find.ancestor(
      of: find.text('sliding'),
      matching: find.byType(Transform),
    );
    expect(transformFinder, findsOneWidget);
  });

  testWidgets('renders the child even when no animation flags are set', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: AnimatedHeaderSlot(
            slot: const HeaderSlot(id: 'x', child: Text('plain')),
            progress: 0.5,
            animation: const HeaderAnimationConfig(),
          ),
        ),
      ),
    );

    expect(find.text('plain'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
