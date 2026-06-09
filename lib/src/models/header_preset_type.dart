/// Predefined preset types for the header.
enum HeaderPresetType {
  /// Location-based header (food-delivery style).
  location,

  /// Ralphs-style header (grocery store style).
  ralphs,

  /// Text-shrink header (multiline → single line).
  textShrink,

  /// Fully custom user-defined header.
  custom,
}

/// Convenience extensions on [HeaderPresetType].
extension HeaderPresetTypeExtension on HeaderPresetType {
  /// Human-readable display name.
  String get displayName {
    switch (this) {
      case HeaderPresetType.location:
        return 'Location Header';
      case HeaderPresetType.ralphs:
        return 'Ralphs Header';
      case HeaderPresetType.textShrink:
        return 'Text Shrink Header';
      case HeaderPresetType.custom:
        return 'Custom Header';
    }
  }

  /// Default expanded height for this preset.
  double get defaultExpandedHeight {
    switch (this) {
      case HeaderPresetType.location:
        return 320.0;
      case HeaderPresetType.ralphs:
        return 280.0;
      case HeaderPresetType.textShrink:
        return 250.0;
      case HeaderPresetType.custom:
        return 300.0;
    }
  }

  /// Default collapsed height for this preset.
  double get defaultCollapsedHeight {
    switch (this) {
      case HeaderPresetType.location:
        return 88.0;
      case HeaderPresetType.ralphs:
        return 88.0;
      case HeaderPresetType.textShrink:
        return 80.0;
      case HeaderPresetType.custom:
        return 90.0;
    }
  }
}
