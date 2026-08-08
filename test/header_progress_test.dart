import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

void main() {
  testWidgets('of() returns the nearest HeaderProgress ancestor', (
    tester,
  ) async {
    late HeaderProgress found;

    await tester.pumpWidget(
      wrapWithScreenUtil(
        HeaderProgress(
          progress: 0.4,
          curvedProgress: 0.6,
          height: 180,
          child: Builder(
            builder: (context) {
              found = HeaderProgress.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(found.progress, 0.4);
    expect(found.curvedProgress, 0.6);
    expect(found.height, 180);
  });

  testWidgets('maybeOf() returns null when there is no ancestor', (
    tester,
  ) async {
    HeaderProgress? found;

    await tester.pumpWidget(
      wrapWithScreenUtil(
        Builder(
          builder: (context) {
            found = HeaderProgress.maybeOf(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(found, isNull);
  });

  testWidgets('of() throws (via assert) when there is no ancestor in '
      'debug mode', (tester) async {
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Builder(
          builder: (context) {
            // Wrap the call so the thrown AssertionError doesn't crash
            // pumpWidget itself.
            expect(() => HeaderProgress.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      ),
    );
  });

  test('isExpanded is true only at or below 0.01', () {
    const atZero = HeaderProgress(
      progress: 0.0,
      curvedProgress: 0.0,
      height: 100,
      child: SizedBox(),
    );
    const atThreshold = HeaderProgress(
      progress: 0.01,
      curvedProgress: 0.01,
      height: 100,
      child: SizedBox(),
    );
    const justAbove = HeaderProgress(
      progress: 0.02,
      curvedProgress: 0.02,
      height: 100,
      child: SizedBox(),
    );

    expect(atZero.isExpanded, isTrue);
    expect(atThreshold.isExpanded, isTrue);
    expect(justAbove.isExpanded, isFalse);
  });

  test('isCollapsed is true only at or above 0.99', () {
    const atOne = HeaderProgress(
      progress: 1.0,
      curvedProgress: 1.0,
      height: 80,
      child: SizedBox(),
    );
    const atThreshold = HeaderProgress(
      progress: 0.99,
      curvedProgress: 0.99,
      height: 80,
      child: SizedBox(),
    );
    const justBelow = HeaderProgress(
      progress: 0.98,
      curvedProgress: 0.98,
      height: 80,
      child: SizedBox(),
    );

    expect(atOne.isCollapsed, isTrue);
    expect(atThreshold.isCollapsed, isTrue);
    expect(justBelow.isCollapsed, isFalse);
  });

  test('updateShouldNotify is true when progress, curvedProgress, or '
      'height differ', () {
    const base = HeaderProgress(
      progress: 0.5,
      curvedProgress: 0.5,
      height: 150,
      child: SizedBox(),
    );

    expect(
      base.updateShouldNotify(
        const HeaderProgress(
          progress: 0.6,
          curvedProgress: 0.5,
          height: 150,
          child: SizedBox(),
        ),
      ),
      isTrue,
    );
    expect(
      base.updateShouldNotify(
        const HeaderProgress(
          progress: 0.5,
          curvedProgress: 0.5,
          height: 150,
          child: SizedBox(),
        ),
      ),
      isFalse,
    );
  });
}
