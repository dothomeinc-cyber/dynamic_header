import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

void main() {
  group('HeaderPresetTypeExtension.displayName', () {
    test('returns the expected label for every preset', () {
      expect(HeaderPresetType.location.displayName, 'Location Header');
      expect(HeaderPresetType.ralphs.displayName, 'Ralphs Header');
      expect(HeaderPresetType.textShrink.displayName, 'Text Shrink Header');
      expect(HeaderPresetType.custom.displayName, 'Custom Header');
    });
  });

  group('HeaderPresetTypeExtension.defaultExpandedHeight', () {
    test('returns a positive height for every preset', () {
      for (final preset in HeaderPresetType.values) {
        expect(preset.defaultExpandedHeight, greaterThan(0));
      }
    });

    test('matches documented defaults', () {
      expect(HeaderPresetType.location.defaultExpandedHeight, 320.0);
      expect(HeaderPresetType.ralphs.defaultExpandedHeight, 280.0);
      expect(HeaderPresetType.textShrink.defaultExpandedHeight, 250.0);
      expect(HeaderPresetType.custom.defaultExpandedHeight, 300.0);
    });
  });

  group('HeaderPresetTypeExtension.defaultCollapsedHeight', () {
    test('is always smaller than defaultExpandedHeight', () {
      for (final preset in HeaderPresetType.values) {
        expect(
          preset.defaultCollapsedHeight,
          lessThan(preset.defaultExpandedHeight),
        );
      }
    });

    test('matches documented defaults', () {
      expect(HeaderPresetType.location.defaultCollapsedHeight, 88.0);
      expect(HeaderPresetType.ralphs.defaultCollapsedHeight, 88.0);
      expect(HeaderPresetType.textShrink.defaultCollapsedHeight, 80.0);
      expect(HeaderPresetType.custom.defaultCollapsedHeight, 90.0);
    });
  });
}
