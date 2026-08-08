import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

/// Demonstrates [TextShrinkSliverHeader] over a long article body — this
/// is also the regression scenario for the `content.pinnedOnCollapse`
/// overflow bug: scroll to the very bottom of the collapse range and the
/// title should shrink to a single line and stay pinned, with no
/// RenderFlex overflow.
class TextShrinkDemoScreen extends StatelessWidget {
  const TextShrinkDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const TextShrinkSliverHeader(
            title: 'Understanding Cement Grades: OPC vs PPC vs PSC',
            description:
                'A practical guide for contractors sourcing bulk materials.',
            backgroundColor: Color(0xFF37474F),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Paragraph ${index + 1}. Lorem ipsum dolor sit amet, '
                    'consectetur adipiscing elit. Sed do eiusmod tempor '
                    'incididunt ut labore et dolore magna aliqua.',
                    style: const TextStyle(height: 1.5),
                  ),
                ),
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
