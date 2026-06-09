# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [2.0.6] - 2024-06-09

## Added
 - Added Adiitional info in eg

## [2.0.5] - 2024-06-09


## Added
 - updated the reame md

## [1.0.0] - 2024-06-09

### Added
- Full `flutter_screenutil` integration for responsive design
- `HeaderProgress` InheritedWidget for live scroll progress access
- `ShrinkingText` widget for animated font size transitions
- Background image support with color overlay and gradient scrim
- `HeaderPresetType` enum with default height values
- Complete example app with 5 demonstration tabs
- Support for `snap` parameter to snap header on scroll release
- `onExpanded`, `onCollapsed`, and `onProgressChanged` callbacks
- `bottom` widget support for sticky tabs (e.g., TabBar)

### Changed
- All dimensions now use `.w`, `.h`, `.r`, `.sp` from flutter_screenutil
- `HeaderLayoutConfig` now properly scales all measurements
- `HeaderTextConfig` font sizes now scale with `.sp`
- Improved animation timing with `rangeMap` and `rangeMapInverted`
- Better handling of safe area insets

### Fixed
- Fixed issue with flexibleSpace opacity during collapse
- Fixed content height calculation when bottom widget is present
- Fixed alignment interpolation during scroll
- Removed unused `zIndex` property from HeaderSlot

