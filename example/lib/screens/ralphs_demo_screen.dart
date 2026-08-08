import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

/// Demonstrates [RalphsSliverHeader] over a grid of "products".
class RalphsDemoScreen extends StatelessWidget {
  const RalphsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          RalphsSliverHeader(
            title: 'CSP Traders',
            subtitle: 'Ponmanai, Kanyakumari',
            promoText: 'Save up to 20% on cement this week!',
            onSearchTap: () => _snack(context, 'Search tapped'),
            onCartTap: () => _snack(context, 'Cart tapped'),
            // onBackTap omitted on purpose: falls back to
            // Navigator.of(context).pop() inside the preset.
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ProductCard(index: index),
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final int index;

  const _ProductCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 32),
              ),
            ),
            const SizedBox(height: 8),
            Text('Product $index', style: const TextStyle(fontWeight: FontWeight.w600)),
            const Text('₹450 / bag'),
          ],
        ),
      ),
    );
  }
}
