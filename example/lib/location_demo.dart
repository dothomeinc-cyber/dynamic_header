import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

class LocationDemo extends StatelessWidget {
  const LocationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const LocationSliverHeader(
            locationName: 'HOME',
            locationAddress:
                'Floor 2, Main Street, Bengaluru',
          ),
          SliverList.builder(
            itemCount: 40,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: i.isEven
                    ? Colors.orange[100]
                    : Colors.grey[200],
                child: Text('${i + 1}'),
              ),
              title: Text('Item ${i + 1}'),
              subtitle: const Text('Tap to add to cart'),
              trailing:
                  const Icon(Icons.add_circle_outline),
            ),
          ),
        ],
      ),
    );
  }
}
