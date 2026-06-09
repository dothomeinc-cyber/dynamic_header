import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

class TextShrinkDemo extends StatelessWidget {
  const TextShrinkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const TextShrinkSliverHeader(
            title:
                'Some very long text that is multiline when expanded and one line when shrunken',
            description:
                'This subtitle fades out as the header collapses.',
            backgroundColor: Color(0xFFCDDC39),
          ),
          SliverList.builder(
            itemCount: 40,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: i.isEven
                    ? Colors.lime[100]
                    : Colors.grey[200],
                child: Text('${i + 1}'),
              ),
              title: Text('Item ${i + 1}'),
            ),
          ),
        ],
      ),
    );
  }
}
