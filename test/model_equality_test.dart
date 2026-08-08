import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

void main() {
  group('HeaderColorConfig equality', () {
    test('two configs with identical fields are ==', () {
      const a = HeaderColorConfig(
        expandedBackgroundColor: Colors.red,
        collapsedBackgroundColor: Colors.blue,
        gradientOpacity: 0.8,
      );
      const b = HeaderColorConfig(
        expandedBackgroundColor: Colors.red,
        collapsedBackgroundColor: Colors.blue,
        gradientOpacity: 0.8,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differing field makes configs unequal', () {
      const a = HeaderColorConfig(expandedBackgroundColor: Colors.red);
      const b = HeaderColorConfig(expandedBackgroundColor: Colors.green);
      expect(a, isNot(equals(b)));
    });

    test('default-constructed configs are equal to each other', () {
      expect(const HeaderColorConfig(), equals(const HeaderColorConfig()));
    });

    test('null optional fields compare equal to other nulls', () {
      const a = HeaderColorConfig();
      const b = HeaderColorConfig();
      expect(a.expandedIconColor, isNull);
      expect(a, equals(b));
    });
  });

  group('HeaderLayoutConfig equality', () {
    test('two configs with identical fields are ==', () {
      const a = HeaderLayoutConfig(horizontalPadding: 20, topPadding: 10);
      const b = HeaderLayoutConfig(horizontalPadding: 20, topPadding: 10);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differing field makes configs unequal', () {
      const a = HeaderLayoutConfig(spacing: 8);
      const b = HeaderLayoutConfig(spacing: 12);
      expect(a, isNot(equals(b)));
    });

    test('copyWith preserves equality when no fields change', () {
      const a = HeaderLayoutConfig();
      final b = a.copyWith();
      expect(a, equals(b));
    });

    test('copyWith produces an unequal config when a field changes', () {
      const a = HeaderLayoutConfig();
      final b = a.copyWith(topPadding: 99);
      expect(a, isNot(equals(b)));
      expect(b.topPadding, 99);
      // Untouched fields carry over.
      expect(b.horizontalPadding, a.horizontalPadding);
    });
  });

  group('HeaderAnimationConfig equality', () {
    test('two configs with identical fields are ==', () {
      const a = HeaderAnimationConfig(enableFade: false, enableScale: true);
      const b = HeaderAnimationConfig(enableFade: false, enableScale: true);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differing curve makes configs unequal', () {
      const a = HeaderAnimationConfig(curve: Curves.linear);
      const b = HeaderAnimationConfig(curve: Curves.easeIn);
      expect(a, isNot(equals(b)));
    });

    test('HeaderAnimationConfig.none matches an explicit equivalent', () {
      const explicit = HeaderAnimationConfig(
        enableFade: false,
        enableScale: false,
        enableSlide: false,
        enableColorLerp: false,
        enableTextShrink: false,
      );
      expect(HeaderAnimationConfig.none, equals(explicit));
    });
  });

  group('HeaderSlot equality', () {
    test('same flags but different child widget instances are still equal '
        '(child excluded from ==)', () {
      final a = HeaderSlot(id: 'x', child: Container());
      final b = HeaderSlot(id: 'x', child: Container());
      expect(a, equals(b));
    });

    test('different id makes slots unequal even with identical flags', () {
      final a = HeaderSlot(id: 'a', child: const SizedBox());
      final b = HeaderSlot(id: 'b', child: const SizedBox());
      expect(a, isNot(equals(b)));
    });

    test('different fixed flag makes slots unequal', () {
      final a = HeaderSlot(id: 'x', child: const SizedBox(), fixed: true);
      final b = HeaderSlot(id: 'x', child: const SizedBox(), fixed: false);
      expect(a, isNot(equals(b)));
    });

    test('identical instance is always equal to itself', () {
      final a = HeaderSlot(id: 'x', child: const SizedBox());
      expect(a, equals(a));
    });
  });
}
