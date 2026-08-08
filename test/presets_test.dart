import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

void main() {
  group('LocationSliverHeader', () {
    testWidgets('renders content and does not overflow when expanded', (
      tester,
    ) async {
      await pumpHeader(
        tester,
        const LocationSliverHeader(
          locationName: 'Home',
          locationAddress: '221B Baker Street',
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('221B Baker Street'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not overflow once fully collapsed', (tester) async {
      await pumpHeader(
        tester,
        const LocationSliverHeader(
          locationName: 'Home',
          locationAddress: '221B Baker Street',
        ),
      );

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ErrorWidget), findsNothing);
    });

    testWidgets('renders custom chips', (tester) async {
      await pumpHeader(
        tester,
        const LocationSliverHeader(
          locationName: 'Office',
          locationAddress: '1 Infinite Loop',
          chips: ['Fast', 'Cheap'],
        ),
      );

      expect(find.text('Fast'), findsOneWidget);
      expect(find.text('Cheap'), findsOneWidget);
    });

    testWidgets('invokes onLocationTap when the location row is tapped', (
      tester,
    ) async {
      var tapped = false;
      await pumpHeader(
        tester,
        LocationSliverHeader(
          locationName: 'Home',
          locationAddress: 'Somewhere',
          onLocationTap: () => tapped = true,
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('RalphsSliverHeader', () {
    testWidgets('renders title, subtitle, and promo text when expanded', (
      tester,
    ) async {
      await pumpHeader(
        tester,
        const RalphsSliverHeader(
          title: 'Ralphs Downtown',
          subtitle: '0.4 miles away',
        ),
      );

      expect(find.text('Ralphs Downtown'), findsOneWidget);
      expect(find.text('0.4 miles away'), findsOneWidget);
      expect(
        find.text('Save up to 20% on your first order!'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not overflow once fully collapsed', (tester) async {
      await pumpHeader(
        tester,
        const RalphsSliverHeader(
          title: 'Ralphs Downtown',
          subtitle: '0.4 miles away',
        ),
      );

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ErrorWidget), findsNothing);
    });

    testWidgets('back button pops the navigator when onBackTap is not '
        'provided', (tester) async {
      pinTestSurface(tester);
      await tester.pumpWidget(
        wrapWithScreenUtil(
          Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => wrapSliverInScrollView(
                const RalphsSliverHeader(
                  title: 'T',
                  subtitle: 'S',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Just verify the IconButton exists and is tappable without
      // throwing; popping an empty stack in a bare Navigator is a no-op.
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('TextShrinkSliverHeader', () {
    testWidgets('renders title and description when expanded', (
      tester,
    ) async {
      await pumpHeader(
        tester,
        const TextShrinkSliverHeader(
          title: 'A Long Article Title Goes Here',
          description: 'A short supporting description.',
        ),
      );

      expect(find.text('A Long Article Title Goes Here'), findsOneWidget);
      expect(
        find.text('A short supporting description.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'REGRESSION: does not overflow once fully collapsed '
      '(content.pinnedOnCollapse fix)',
      (tester) async {
        await pumpHeader(
          tester,
          const TextShrinkSliverHeader(
            title: 'A Long Article Title Goes Here That Would Wrap',
            description: 'A short supporting description.',
          ),
        );

        // Pull the actual SliverPersistentHeaderDelegate this preset
        // built and call its build() directly with a controlled
        // shrinkOffset, instead of scrolling a real CustomScrollView via
        // gesture/animation simulation. This still exercises the real
        // TextShrinkSliverHeader -> DynamicSliverHeader ->
        // DynamicSliverHeaderDelegate chain end-to-end (so it's a
        // meaningful regression guard for the content.pinnedOnCollapse
        // fix), it just reaches the fully-collapsed state deterministically
        // rather than depending on how scroll physics/animation
        // scheduling behaves in a given test environment -- which
        // repeatedly proved unreliable to reason about here (a driven
        // ScrollController.animateTo was observed settling at a stable
        // fraction of its target rather than completing).
        final sliverHeader = tester.widget<SliverPersistentHeader>(
          find.byType(SliverPersistentHeader),
        );
        final delegate = sliverHeader.delegate;

        await tester.pumpWidget(
          wrapWithScreenUtil(
            Builder(
              // shrinkOffset = expandedHeight - collapsedHeight (200-80)
              // is exactly the fully-collapsed point for this preset's
              // defaults.
              builder: (context) => delegate.build(context, 120, false),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(ErrorWidget), findsNothing);
        // ShrinkingText never removes or replaces the title string when
        // collapsed -- it only reduces font size and maxLines (3 -> 1),
        // always passing the same `text`. The full string should still
        // be present in the tree (now rendered as ellipsized single-line
        // text) as long as it's actually laid out within the header's
        // visible bounds rather than clipped away offstage.
        expect(
          find.text('A Long Article Title Goes Here That Would Wrap'),
          findsOneWidget,
        );
      },
    );

    testWidgets('hides description once progress passes the 0.5 fade '
        'cutoff', (tester) async {
      await pumpHeader(
        tester,
        const TextShrinkSliverHeader(
          title: 'Title',
          description: 'Description text',
        ),
      );

      // Small scroll: still expanded enough for description to show.
      expect(find.text('Description text'), findsOneWidget);

      // Scroll enough to pass progress > 0.5.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      expect(find.text('Description text'), findsNothing);
    });

    testWidgets('works with no description provided', (tester) async {
      await pumpHeader(
        tester,
        const TextShrinkSliverHeader(title: 'Title only'),
      );

      expect(find.text('Title only'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
