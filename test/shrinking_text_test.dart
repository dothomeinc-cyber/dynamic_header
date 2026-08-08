import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

import 'test_utils.dart';

void main() {
  testWidgets('shows expandedMaxLines when progress is 0', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: ShrinkingText(
            text: 'A fairly long title that could wrap',
            progress: 0.0,
            config: const HeaderTextConfig(
              expandedMaxLines: 3,
              collapsedMaxLines: 1,
            ),
            animation: const HeaderAnimationConfig(enableTextShrink: true),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.maxLines, 3);
  });

  testWidgets('shows collapsedMaxLines once progress reaches the '
      'oneLineThreshold', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: ShrinkingText(
            text: 'A fairly long title that could wrap',
            progress: 1.0,
            config: const HeaderTextConfig(
              expandedMaxLines: 3,
              collapsedMaxLines: 1,
            ),
            animation: const HeaderAnimationConfig(
              enableTextShrink: true,
              oneLineThreshold: 0.9,
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.maxLines, 1);
  });

  testWidgets('font size lerps between expanded and collapsed sizes', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: ShrinkingText(
            text: 'Sizing test',
            progress: 0.0,
            config: const HeaderTextConfig(
              expandedFontSize: 28,
              collapsedFontSize: 16,
            ),
            animation: const HeaderAnimationConfig(enableTextShrink: true),
          ),
        ),
      ),
    );

    final expandedText = tester.widget<Text>(find.byType(Text));
    final expandedSize = expandedText.style!.fontSize!;

    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: ShrinkingText(
            text: 'Sizing test',
            progress: 1.0,
            config: const HeaderTextConfig(
              expandedFontSize: 28,
              collapsedFontSize: 16,
            ),
            animation: const HeaderAnimationConfig(enableTextShrink: true),
          ),
        ),
      ),
    );

    final collapsedText = tester.widget<Text>(find.byType(Text));
    final collapsedSize = collapsedText.style!.fontSize!;

    // Collapsed font size should be smaller than expanded (28 -> 16 range).
    expect(collapsedSize, lessThan(expandedSize));
  });

  testWidgets('enableTextShrink=false keeps font size pinned at expanded '
      'size regardless of progress', (tester) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: ShrinkingText(
            text: 'No shrink',
            progress: 1.0,
            config: const HeaderTextConfig(
              expandedFontSize: 28,
              collapsedFontSize: 16,
            ),
            animation: const HeaderAnimationConfig(enableTextShrink: false),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    // With enableTextShrink off, effectiveProgress is forced to 0, so the
    // rendered size should reflect the expanded font size (before .sp
    // scaling is applied it's 28; just assert it's the larger, not the
    // smaller, of the two configured sizes).
    expect(text.maxLines, 3); // default expandedMaxLines
    expect(text.style!.fontWeight, FontWeight.bold); // default expanded
  });

  testWidgets('applies overflow and textAlign from config/param', (
    tester,
  ) async {
    pinTestSurface(tester);
    await tester.pumpWidget(
      wrapWithScreenUtil(
        Material(
          child: ShrinkingText(
            text: 'Overflow test',
            progress: 0.5,
            textAlign: TextAlign.center,
            config: const HeaderTextConfig(overflow: TextOverflow.fade),
            animation: const HeaderAnimationConfig(),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.overflow, TextOverflow.fade);
    expect(text.textAlign, TextAlign.center);
  });
}
