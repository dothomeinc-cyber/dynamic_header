import 'package:flutter/material.dart';
import 'package:dynamic_sliver_header/dynamic_sliver_header.dart';

/// Custom demo showing how to build your own header manually.
/// Pass any widget you want into each slot — the package handles animation.
class CustomDemo extends StatelessWidget {
  const CustomDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DynamicSliverHeader(
            expandedHeight: 300,
            collapsedHeight: 90,
            pinned: true,
            colors: const HeaderColorConfig(
              expandedBackgroundColor: Color(0xFF1A237E),
              collapsedBackgroundColor: Color(0xFF1A237E),
            ),
            layout: const HeaderLayoutConfig(),
            animation: const HeaderAnimationConfig(),

            // ── Leading: back button, always fixed ──────────────────────
            leading: HeaderSlot(
              id: 'back',
              fixed: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white),
                onPressed: () =>
                    Navigator.of(context).pop(),
              ),
            ),

            // ── Trailing: fixed icon + fading icon ──────────────────────
            trailing: const [
              HeaderSlot(
                id: 'search',
                fixed: true,
                child:
                    Icon(Icons.search, color: Colors.white),
              ),
              HeaderSlot(
                id: 'favorite',
                fixed: false, // fades out on collapse
                child: Icon(Icons.favorite_border,
                    color: Colors.white),
              ),
            ],

            // ── FlexibleSpace: search bar pins in bar when collapsed ─────
            flexibleSpace: HeaderSlot(
              id: 'searchbar',
              pinnedOnCollapse: true,
              child: Container(
                height: 44,
                margin:
                    const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 14),
                    Icon(Icons.search,
                        color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text('Search...',
                        style: TextStyle(
                            color: Colors.white70)),
                  ],
                ),
              ),
            ),

            // ── Content: your custom expanded content ───────────────────
            content: HeaderSlot(
              id: 'hero',
              fadeOnCollapse: true,
              scaleOnCollapse: true,
              collapsedScale: 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Read live progress inside a Builder
                    Builder(builder: (context) {
                      final hp = HeaderProgress.of(context);
                      return Text(
                        'Progress: ${(hp.progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: Colors.white70),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: 40,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: i.isEven
                    ? Colors.indigo[50]
                    : Colors.grey[100],
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
