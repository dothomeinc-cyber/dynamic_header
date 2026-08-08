import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

void main() {
  group('LerpUtils.lerpDouble', () {
    test('returns a at t=0', () {
      expect(LerpUtils.lerpDouble(10, 20, 0.0), 10.0);
    });

    test('returns b at t=1', () {
      expect(LerpUtils.lerpDouble(10, 20, 1.0), 20.0);
    });

    test('returns midpoint at t=0.5', () {
      expect(LerpUtils.lerpDouble(10, 20, 0.5), 15.0);
    });

    test('clamps t above 1.0', () {
      expect(LerpUtils.lerpDouble(0, 10, 3.0), 10.0);
    });

    test('clamps t below 0.0', () {
      expect(LerpUtils.lerpDouble(0, 10, -3.0), 0.0);
    });
  });

  group('LerpUtils.lerpOffset', () {
    test('interpolates both dx and dy', () {
      final result = LerpUtils.lerpOffset(
        const Offset(0, 0),
        const Offset(10, 20),
        0.5,
      );
      expect(result.dx, 5.0);
      expect(result.dy, 10.0);
    });

    test('clamps t to [0,1]', () {
      final result = LerpUtils.lerpOffset(
        const Offset(0, 0),
        const Offset(10, 20),
        2.0,
      );
      expect(result, const Offset(10, 20));
    });
  });

  group('LerpUtils.lerpAlignment', () {
    test('interpolates from center to topCenter', () {
      final result = LerpUtils.lerpAlignment(
        Alignment.center,
        Alignment.topCenter,
        0.5,
      );
      expect(result.x, 0.0);
      expect(result.y, closeTo(-0.5, 1e-9));
    });

    test('returns end alignment at t=1', () {
      final result = LerpUtils.lerpAlignment(
        Alignment.topLeft,
        Alignment.bottomRight,
        1.0,
      );
      expect(result, Alignment.bottomRight);
    });
  });

  group('LerpUtils.lerpColor', () {
    test('returns null when both inputs are null', () {
      expect(LerpUtils.lerpColor(null, null, 0.5), isNull);
    });

    test('returns b when a is null', () {
      expect(LerpUtils.lerpColor(null, Colors.red, 0.5), Colors.red);
    });

    test('returns a when b is null', () {
      expect(LerpUtils.lerpColor(Colors.blue, null, 0.5), Colors.blue);
    });

    test('interpolates between two non-null colors', () {
      final result = LerpUtils.lerpColor(Colors.black, Colors.white, 0.5)!;
      // Midpoint of black->white should be a mid-grey. Newer Color exposes
      // floating-point 0.0-1.0 channels (.r/.g/.b) rather than the
      // deprecated 0-255 integer .red/.green/.blue getters.
      expect(result.r, closeTo(0.5, 0.02));
      expect(result.g, closeTo(0.5, 0.02));
      expect(result.b, closeTo(0.5, 0.02));
    });

    test('returns exactly a at t=0', () {
      final result = LerpUtils.lerpColor(Colors.red, Colors.blue, 0.0)!;
      // Color.lerp doesn't guarantee returning the same *instance* (or
      // even the same Color subtype -- Colors.red is a MaterialColor,
      // but Color.lerp always returns a plain Color), so compare by
      // resolved channel values rather than object identity/type.
      expect(result.r, Colors.red.r);
      expect(result.g, Colors.red.g);
      expect(result.b, Colors.red.b);
      expect(result.a, Colors.red.a);
    });

    test('returns exactly b at t=1', () {
      final result = LerpUtils.lerpColor(Colors.red, Colors.blue, 1.0)!;
      expect(result.r, Colors.blue.r);
      expect(result.g, Colors.blue.g);
      expect(result.b, Colors.blue.b);
      expect(result.a, Colors.blue.a);
    });
  });

  group('LerpUtils.rangeMap', () {
    test('returns 0 at or before inStart', () {
      expect(LerpUtils.rangeMap(0.0, inStart: 0.3, inEnd: 0.6), 0.0);
      expect(LerpUtils.rangeMap(0.2, inStart: 0.3, inEnd: 0.6), 0.0);
    });

    test('returns 1 at or after inEnd', () {
      expect(LerpUtils.rangeMap(0.6, inStart: 0.3, inEnd: 0.6), 1.0);
      expect(LerpUtils.rangeMap(1.0, inStart: 0.3, inEnd: 0.6), 1.0);
    });

    test('returns proportional value inside the range', () {
      // Range [0.3, 0.6], progress 0.45 is exactly halfway.
      expect(
        LerpUtils.rangeMap(0.45, inStart: 0.3, inEnd: 0.6),
        closeTo(0.5, 1e-9),
      );
    });

    test('degenerate range (inEnd <= inStart) treats it as a step', () {
      expect(LerpUtils.rangeMap(0.5, inStart: 0.5, inEnd: 0.5), 1.0);
      expect(LerpUtils.rangeMap(0.4, inStart: 0.5, inEnd: 0.5), 0.0);
    });
  });

  group('LerpUtils.rangeMapInverted', () {
    test('is the inverse of rangeMap across the range', () {
      for (final p in [0.0, 0.2, 0.45, 0.6, 1.0]) {
        final mapped = LerpUtils.rangeMap(p, inStart: 0.2, inEnd: 0.7);
        final inverted =
            LerpUtils.rangeMapInverted(p, inStart: 0.2, inEnd: 0.7);
        expect(inverted, closeTo(1.0 - mapped, 1e-9));
      }
    });

    test('returns 1 at inStart and 0 at inEnd', () {
      expect(
        LerpUtils.rangeMapInverted(0.1, inStart: 0.1, inEnd: 0.9),
        1.0,
      );
      expect(
        LerpUtils.rangeMapInverted(0.9, inStart: 0.1, inEnd: 0.9),
        0.0,
      );
    });
  });
}
