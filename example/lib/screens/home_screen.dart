import 'package:flutter/material.dart';

import 'location_demo_screen.dart';
import 'ralphs_demo_screen.dart';
import 'text_shrink_demo_screen.dart';
import 'custom_demo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('dynamic_sliver_header')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Presets',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _DemoTile(
            title: 'LocationSliverHeader',
            subtitle: 'Food-delivery style (Blinkit / Swiggy)',
            onTap: () => _push(context, const LocationDemoScreen()),
          ),
          _DemoTile(
            title: 'RalphsSliverHeader',
            subtitle: 'Grocery-store style',
            onTap: () => _push(context, const RalphsDemoScreen()),
          ),
          _DemoTile(
            title: 'TextShrinkSliverHeader',
            subtitle: 'Multiline title that shrinks to one line',
            onTap: () => _push(context, const TextShrinkDemoScreen()),
          ),
          const SizedBox(height: 24),
          const Text(
            'Custom',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _DemoTile(
            title: 'Fully custom DynamicSliverHeader',
            subtitle: 'Hand-built slots + HeaderProgress.of(context)',
            onTap: () => _push(context, const CustomDemoScreen()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _DemoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
