import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

/// Demonstrates [LocationSliverHeader] dropped into a normal
/// [CustomScrollView] with a scrollable list beneath it.
class LocationDemoScreen extends StatelessWidget {
  const LocationDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          LocationSliverHeader(
            locationName: 'Home',
            locationAddress: '221B Baker Street, Ponmanai',
            onLocationTap: () => _snack(context, 'Location tapped'),
            onSearchTap: () => _snack(context, 'Search tapped'),
            onProfileTap: () => _snack(context, 'Profile tapped'),
            onFavoriteTap: () => _snack(context, 'Favourite tapped'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: const Icon(Icons.store),
                title: Text('Store #$index'),
                subtitle: const Text('15–30 min • Free delivery'),
              ),
              childCount: 30,
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
