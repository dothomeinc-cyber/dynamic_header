import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

void main() {
  testWidgets('fixed leading item is never wrapped in Opacity', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: FixedHeaderActions(
            leading: const HeaderSlot(
              id: 'leading',
              fixed: true,
              child: Icon(Icons.arrow_back),
            ),
            trailing: const [],
            progress: 1.0, // fully collapsed
            layout: const HeaderLayoutConfig(),
            animation: const HeaderAnimationConfig(enableFade: true),
          ),
        ),
      ),
    );

    final opacityAncestor = find.ancestor(
      of: find.byIcon(Icons.arrow_back),
      matching: find.byType(Opacity),
    );
    expect(opacityAncestor, findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('non-fixed trailing item fades out as progress increases', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: FixedHeaderActions(
            trailing: const [
              HeaderSlot(
                id: 'fav',
                fixed: false,
                child: Icon(Icons.favorite_border),
              ),
            ],
            progress: 0.5, // rangeMapInverted(0.5, 0, 0.5) -> 0
            layout: const HeaderLayoutConfig(),
            animation: const HeaderAnimationConfig(enableFade: true),
          ),
        ),
      ),
    );

    final opacityFinder = find.ancestor(
      of: find.byIcon(Icons.favorite_border),
      matching: find.byType(Opacity),
    );
    expect(opacityFinder, findsOneWidget);
    final opacity = tester.widget<Opacity>(opacityFinder);
    expect(opacity.opacity, closeTo(0.0, 1e-9));
  });

  testWidgets('non-fixed item is fully opaque at progress 0', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: FixedHeaderActions(
            trailing: const [
              HeaderSlot(
                id: 'fav',
                fixed: false,
                child: Icon(Icons.favorite_border),
              ),
            ],
            progress: 0.0,
            layout: const HeaderLayoutConfig(),
            animation: const HeaderAnimationConfig(enableFade: true),
          ),
        ),
      ),
    );

    final opacityFinder = find.ancestor(
      of: find.byIcon(Icons.favorite_border),
      matching: find.byType(Opacity),
    );
    final opacity = tester.widget<Opacity>(opacityFinder);
    expect(opacity.opacity, closeTo(1.0, 1e-9));
  });

  testWidgets('renders flexibleSpaceInBar in the centre Expanded slot when '
      'provided', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: FixedHeaderActions(
            trailing: const [],
            progress: 0.8,
            layout: const HeaderLayoutConfig(),
            animation: const HeaderAnimationConfig(),
            flexibleSpaceInBar: const Text('search bar'),
            flexibleSpaceInBarOpacity: 0.75,
          ),
        ),
      ),
    );

    expect(find.text('search bar'), findsOneWidget);
    final opacityFinder = find.ancestor(
      of: find.text('search bar'),
      matching: find.byType(Opacity),
    );
    final opacity = tester.widget<Opacity>(opacityFinder);
    expect(opacity.opacity, closeTo(0.75, 1e-9));
  });

  testWidgets('renders all trailing items in order', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: FixedHeaderActions(
            trailing: const [
              HeaderSlot(id: 't1', fixed: true, child: Icon(Icons.search)),
              HeaderSlot(
                id: 't2',
                fixed: true,
                child: Icon(Icons.shopping_cart),
              ),
            ],
            progress: 0.0,
            layout: const HeaderLayoutConfig(),
            animation: const HeaderAnimationConfig(),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
  });
}
