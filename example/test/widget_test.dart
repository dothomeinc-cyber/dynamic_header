import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dynamic_sliver_header_example/main.dart';
import 'package:dynamic_sliver_header_example/screens/location_demo_screen.dart';
import 'package:dynamic_sliver_header_example/screens/ralphs_demo_screen.dart';
import 'package:dynamic_sliver_header_example/screens/text_shrink_demo_screen.dart';
import 'package:dynamic_sliver_header_example/screens/custom_demo_screen.dart';

void main() {
  testWidgets('home screen lists all four demos', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('LocationSliverHeader'), findsOneWidget);
    expect(find.text('RalphsSliverHeader'), findsOneWidget);
    expect(find.text('TextShrinkSliverHeader'), findsOneWidget);
    expect(find.text('Fully custom DynamicSliverHeader'), findsOneWidget);
  });

  testWidgets('tapping the location demo tile navigates to '
      'LocationDemoScreen', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('LocationSliverHeader'));
    await tester.pumpAndSettle();

    expect(find.byType(LocationDemoScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the ralphs demo tile navigates to '
      'RalphsDemoScreen', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('RalphsSliverHeader'));
    await tester.pumpAndSettle();

    expect(find.byType(RalphsDemoScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the text-shrink demo tile navigates to '
      'TextShrinkDemoScreen and survives a full collapse scroll', (
    tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('TextShrinkSliverHeader'));
    await tester.pumpAndSettle();

    expect(find.byType(TextShrinkDemoScreen), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the custom demo tile navigates to '
      'CustomDemoScreen and survives a full collapse scroll', (
    tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fully custom DynamicSliverHeader'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomDemoScreen), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
