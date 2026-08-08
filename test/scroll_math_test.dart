import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

void main() {
  group('ScrollMath.calculateProgress', () {
    test('returns 0.0 at shrinkOffset 0', () {
      expect(
        ScrollMath.calculateProgress(0, 300, 100),
        0.0,
      );
    });

    test('returns 1.0 when shrinkOffset >= scrollDistance', () {
      expect(
        ScrollMath.calculateProgress(200, 300, 100),
        1.0,
      );
    });

    test('clamps above 1.0 for overscroll', () {
      expect(
        ScrollMath.calculateProgress(500, 300, 100),
        1.0,
      );
    });

    test('clamps below 0.0 for negative shrinkOffset', () {
      expect(
        ScrollMath.calculateProgress(-50, 300, 100),
        0.0,
      );
    });

    test('returns correct fraction mid-scroll', () {
      // scrollDistance = 200, shrinkOffset = 50 -> 0.25
      expect(
        ScrollMath.calculateProgress(50, 300, 100),
        closeTo(0.25, 1e-9),
      );
    });

    test('returns 0.0 when maxExtent == minExtent (zero scroll distance)',
        () {
      expect(
        ScrollMath.calculateProgress(10, 150, 150),
        0.0,
      );
    });

    test('returns 0.0 when maxExtent < minExtent (degenerate config)', () {
      expect(
        ScrollMath.calculateProgress(10, 100, 150),
        0.0,
      );
    });
  });

  group('ScrollMath.interpolate', () {
    test('returns start at progress 0 with linear curve', () {
      expect(
        ScrollMath.interpolate(10, 50, 0.0, Curves.linear),
        10.0,
      );
    });

    test('returns end at progress 1 with linear curve', () {
      expect(
        ScrollMath.interpolate(10, 50, 1.0, Curves.linear),
        50.0,
      );
    });

    test('returns midpoint at progress 0.5 with linear curve', () {
      expect(
        ScrollMath.interpolate(10, 50, 0.5, Curves.linear),
        30.0,
      );
    });

    test('clamps progress above 1.0', () {
      expect(
        ScrollMath.interpolate(0, 100, 5.0, Curves.linear),
        100.0,
      );
    });

    test('clamps progress below 0.0', () {
      expect(
        ScrollMath.interpolate(0, 100, -5.0, Curves.linear),
        0.0,
      );
    });

    test('handles a descending start/end range', () {
      expect(
        ScrollMath.interpolate(100, 0, 0.5, Curves.linear),
        50.0,
      );
    });
  });

  group('ScrollMath.isFullyCollapsed / isFullyExpanded', () {
    test('isFullyCollapsed true at exactly 0.99', () {
      expect(ScrollMath.isFullyCollapsed(0.99), isTrue);
    });

    test('isFullyCollapsed true above 0.99', () {
      expect(ScrollMath.isFullyCollapsed(1.0), isTrue);
    });

    test('isFullyCollapsed false below 0.99', () {
      expect(ScrollMath.isFullyCollapsed(0.98), isFalse);
    });

    test('isFullyExpanded true at exactly 0.01', () {
      expect(ScrollMath.isFullyExpanded(0.01), isTrue);
    });

    test('isFullyExpanded true below 0.01', () {
      expect(ScrollMath.isFullyExpanded(0.0), isTrue);
    });

    test('isFullyExpanded false above 0.01', () {
      expect(ScrollMath.isFullyExpanded(0.02), isFalse);
    });
  });

  group('ScrollMath.currentHeight', () {
    test('returns maxExtent at shrinkOffset 0', () {
      expect(ScrollMath.currentHeight(0, 300), 300.0);
    });

    test('subtracts shrinkOffset from maxExtent', () {
      expect(ScrollMath.currentHeight(80, 300), 220.0);
    });

    test('clamps at 0 when shrinkOffset exceeds maxExtent (no minExtent '
        'given)', () {
      expect(ScrollMath.currentHeight(500, 300), 0.0);
    });

    test('clamps at maxExtent for negative shrinkOffset', () {
      expect(ScrollMath.currentHeight(-20, 300), 300.0);
    });

    test('clamps at minExtent (not 0) when shrinkOffset exceeds maxExtent '
        'and minExtent is given', () {
      expect(ScrollMath.currentHeight(500, 300, 90), 90.0);
    });

    test('minExtent has no effect when shrinkOffset stays within the '
        'normal range', () {
      expect(ScrollMath.currentHeight(80, 300, 90), 220.0);
    });
  });

  group('ScrollMath.calculateSnapProgress', () {
    test('snaps to collapsed (1.0) on fast downward velocity', () {
      expect(
        ScrollMath.calculateSnapProgress(0.3, 800, 500),
        1.0,
      );
    });

    test('snaps to expanded (0.0) on fast upward velocity', () {
      expect(
        ScrollMath.calculateSnapProgress(0.7, -800, 500),
        0.0,
      );
    });

    test('falls back to nearest-half when velocity below threshold '
        '(progress > 0.5 -> collapse)', () {
      expect(
        ScrollMath.calculateSnapProgress(0.6, 100, 500),
        1.0,
      );
    });

    test('falls back to nearest-half when velocity below threshold '
        '(progress <= 0.5 -> expand)', () {
      expect(
        ScrollMath.calculateSnapProgress(0.4, 100, 500),
        0.0,
      );
    });

    test('boundary progress of exactly 0.5 resolves to expand', () {
      expect(
        ScrollMath.calculateSnapProgress(0.5, 0, 500),
        0.0,
      );
    });
  });
}
