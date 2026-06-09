import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

class RalphsDemo extends StatelessWidget {
  const RalphsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const RalphsSliverHeader(
            title: 'Ralphs',
            subtitle: 'Fresh for Everyone',
          ),
          SliverList.builder(
            itemCount: 40,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: i.isEven
                    ? Colors.red[50]
                    : Colors.grey[100],
                child: Text('${i + 1}'),
              ),
              title: Text('Product ${i + 1}'),
              subtitle: const Text('\$4.99 • Aisle 3'),
              trailing:
                  const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
