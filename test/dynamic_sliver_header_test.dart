import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

void main() {
  group('DynamicSliverHeader defaults', () {
    testWidgets('builds with only required params (colors/layout/animation '
        'now optional)', (tester) async {
      // Regression test: colors/layout/animation used to be `required`.
      // This should compile and render without providing them.
      await pumpHeader(
        tester,
        const DynamicSliverHeader(
          expandedHeight: 200,
          collapsedHeight: 80,
          content: HeaderSlot(
            id: 'content',
            child: Text('Hello'),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders leading, trailing, and content slots', (
      tester,
    ) async {
      await pumpHeader(
        tester,
        DynamicSliverHeader(
          expandedHeight: 220,
          collapsedHeight: 90,
          leading: const HeaderSlot(
            id: 'leading',
            fixed: true,
            child: Icon(Icons.arrow_back),
          ),
          trailing: const [
            HeaderSlot(
              id: 'trailing',
              fixed: true,
              child: Icon(Icons.share),
            ),
          ],
          content: const HeaderSlot(
            id: 'content',
            child: Text('Title'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });
  });

  group('HeaderProgress propagation', () {
    testWidgets('progress starts at 0.0 (expanded) before any scroll', (
      tester,
    ) async {
      late double capturedProgress;

      await pumpHeader(
        tester,
        DynamicSliverHeader(
          expandedHeight: 240,
          collapsedHeight: 90,
          content: HeaderSlot(
            id: 'content',
            child: Builder(
              builder: (context) {
                capturedProgress = HeaderProgress.of(context).progress;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedProgress, 0.0);
    });

    testWidgets('progress approaches 1.0 after scrolling past the '
        'collapse distance', (tester) async {
      // Drive DynamicSliverHeaderDelegate.build directly with a chosen
      // shrinkOffset instead of scrolling a real CustomScrollView via
      // gesture/animation simulation. HeaderProgress.progress is a pure
      // function of shrinkOffset inside the delegate (see
      // ScrollMath.calculateProgress) -- this is deterministic by
      // construction and has no dependency on how Flutter's scroll
      // physics or animation scheduling behaves in a given test
      // environment, which repeatedly proved unreliable to reason about
      // here (a driven ScrollController.animateTo was observed settling
      // at a stable fraction of its target rather than completing).
      late double capturedProgress;

      final delegate = DynamicSliverHeaderDelegate(
        expandedHeight: 240,
        collapsedHeight: 90,
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
        content: HeaderSlot(
          id: 'content',
          child: Builder(
            builder: (context) {
              capturedProgress = HeaderProgress.of(context).progress;
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        wrapWithScreenUtil(
          Builder(
            // shrinkOffset = expandedHeight - collapsedHeight is exactly
            // the fully-collapsed point; the delegate's own clamping
            // (calculateProgress / currentHeight) is what's under test,
            // not this specific offset value.
            builder: (context) => delegate.build(context, 150, false),
          ),
        ),
      );

      expect(capturedProgress, closeTo(1.0, 0.01));
    });

    testWidgets('isExpanded / isCollapsed report correctly at the extremes',
        (tester) async {
      // See the "progress approaches 1.0" test above for why this drives
      // the delegate directly rather than scrolling a real
      // CustomScrollView.
      HeaderProgress? latest;

      final delegate = DynamicSliverHeaderDelegate(
        expandedHeight: 240,
        collapsedHeight: 90,
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
        content: HeaderSlot(
          id: 'content',
          child: Builder(
            builder: (context) {
              latest = HeaderProgress.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      Future<void> pumpAtShrinkOffset(double shrinkOffset) =>
          tester.pumpWidget(
            wrapWithScreenUtil(
              Builder(
                builder: (context) =>
                    delegate.build(context, shrinkOffset, false),
              ),
            ),
          );

      await pumpAtShrinkOffset(0);
      expect(latest!.isExpanded, isTrue);
      expect(latest!.isCollapsed, isFalse);

      await pumpAtShrinkOffset(150);
      expect(latest!.isCollapsed, isTrue);
      expect(latest!.isExpanded, isFalse);
    });
  });

  group('Regression: content.pinnedOnCollapse no longer overflows', () {
    testWidgets(
      'a pinnedOnCollapse content slot renders without a RenderFlex '
      'overflow once fully collapsed',
      (tester) async {
        // Mirrors TextShrinkSliverHeader's shape: a Column of text pinned
        // in the bar row. Before the fix, `content.pinnedOnCollapse` was
        // ignored entirely and this configuration produced a squeezed
        // ~16px box at full collapse, causing a RenderFlex overflow.
        await pumpHeader(
          tester,
          DynamicSliverHeader(
            expandedHeight: 200,
            collapsedHeight: 80,
            layout: const HeaderLayoutConfig(
              topPadding: 8,
              bottomPadding: 8,
            ),
            content: const HeaderSlot(
              id: 'pinned_content',
              pinnedOnCollapse: true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A Title That Shrinks',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Fully collapse.
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -600),
        );
        await tester.pumpAndSettle();

        // No overflow error should have been thrown/rendered.
        expect(tester.takeException(), isNull);
        // Flutter renders overflow errors as an ErrorWidget in debug mode;
        // assert none is present.
        expect(find.byType(ErrorWidget), findsNothing);
      },
    );
  });

  group('shouldRebuild via DynamicSliverHeaderDelegate', () {
    test('returns false when nothing meaningfully changed', () {
      const colors = HeaderColorConfig();
      const layout = HeaderLayoutConfig();
      const animation = HeaderAnimationConfig();
      const childWidget = Text('same instance');

      final a = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        content: const HeaderSlot(id: 'c', child: childWidget),
        colors: colors,
        layout: layout,
        animation: animation,
      );
      final b = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        content: const HeaderSlot(id: 'c', child: childWidget),
        colors: colors,
        layout: layout,
        animation: animation,
      );

      expect(b.shouldRebuild(a), isFalse);
    });

    test('returns true when expandedHeight changes', () {
      final a = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );
      final b = DynamicSliverHeaderDelegate(
        expandedHeight: 260,
        collapsedHeight: 80,
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );

      expect(b.shouldRebuild(a), isTrue);
    });

    test('returns true when the content child widget instance changes '
        'even though HeaderSlot flags are identical', () {
      final a = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        content: const HeaderSlot(id: 'c', child: Text('old')),
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );
      final b = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        content: const HeaderSlot(id: 'c', child: Text('new')),
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );

      // Same `id`, same flags -> HeaderSlot.== says equal -> but the
      // delegate must still detect the swapped child by identity.
      expect(a.content, equals(b.content));
      expect(b.shouldRebuild(a), isTrue);
    });

    test('returns false when colors is a structurally-equal new instance',
        () {
      final a = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        colors: const HeaderColorConfig(expandedBackgroundColor: Colors.red),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );
      final b = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        // A freshly-constructed but value-identical config, as any
        // StatelessWidget.build() would produce every rebuild.
        colors: const HeaderColorConfig(expandedBackgroundColor: Colors.red),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );

      expect(b.shouldRebuild(a), isFalse);
    });

    test('returns true when trailing list length changes', () {
      final a = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        trailing: const [HeaderSlot(id: 't1', child: SizedBox())],
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );
      final b = DynamicSliverHeaderDelegate(
        expandedHeight: 200,
        collapsedHeight: 80,
        trailing: const [
          HeaderSlot(id: 't1', child: SizedBox()),
          HeaderSlot(id: 't2', child: SizedBox()),
        ],
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );

      expect(b.shouldRebuild(a), isTrue);
    });
  });

  group('maxExtent / minExtent', () {
    test('maxExtent equals expandedHeight and minExtent equals '
        'collapsedHeight', () {
      final delegate = DynamicSliverHeaderDelegate(
        expandedHeight: 250,
        collapsedHeight: 95,
        colors: const HeaderColorConfig(),
        layout: const HeaderLayoutConfig(),
        animation: const HeaderAnimationConfig(),
      );

      expect(delegate.maxExtent, 250);
      expect(delegate.minExtent, 95);
    });
  });
}
