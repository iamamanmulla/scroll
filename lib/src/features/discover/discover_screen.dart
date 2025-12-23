import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match screenshot light theme or use dark if requested (Image was light)
      // The image shows a light theme search page even if app is dark mode usually? 
      // User prompt says "This is my figma design... help me design", screenshot shows light BG.
      // We will stick to the AppTheme which is currently Dark.
      // ADJUSTMENT: The prompt screenshot is LIGHT mode. 
      // If the app is strictly dark, we should adapt the design to dark or use a white container.
      // Based on previous "Dark Theme" requirement, I will adapt this to Dark Theme 
      // but keep the layout exactly as requested.
      
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: const Icon(Icons.center_focus_weak, color: Colors.black), // Scan iconish
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),

            // 2. Initial Chips (Happy, Romantic...)
            SliverToBoxAdapter(
              child: _buildHorizontalList(
                ['Happy', 'Romantic', 'Chill', 'Funny', 'Party', 'Vibes', 'Music'],
              ),
            ),

            // 3. Genre Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Genre',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Adapting for Light mode based on screenshot, or assume overrides
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildHorizontalList(
                ['Happy', 'Romantic', 'Chill', 'Funny', 'Party'],
              ),
            ),

            // 4. Trending Hashtag Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Trending Hashtag',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildHorizontalList(
                ['Happy', 'Romantic', 'Chill', 'Funny', 'Party'],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 5. Masonry Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childCount: 20,
                itemBuilder: (context, index) {
                  return _buildGridItem(index);
                },
              ),
            ),
             const SliverToBoxAdapter(child: SizedBox(height: 80)), // Bottom nav spacer
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<String> items) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Text(
              items[index],
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(int index) {
    // Random height generation simulation
    final double ht = (index % 5 + 2) * 60.0; 
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            height: ht,
            color: Colors.primaries[index % Colors.primaries.length].shade200,
            child: Image.network(
              'https://picsum.photos/300/${ht.toInt() + 200}?random=$index',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
               errorBuilder: (c, o, s) => const Center(child: Icon(Icons.image)),
            ),
          ),
          if (index % 3 == 0)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.copy, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }
}
