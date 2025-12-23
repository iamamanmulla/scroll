import 'package:flutter/material.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                             image: NetworkImage('https://picsum.photos/200'),
                             fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 40)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'The Round',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Roddy Roundicchi',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '1.7M videos',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border, size: 16, color: Colors.black),
                              label: const Text('Add to Favorites', style: TextStyle(color: Colors.black)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    color: Colors.grey.shade200,
                     child: Image.network(
                        'https://picsum.photos/200/300?random=$index',
                        fit: BoxFit.cover,
                     ),
                  ),
                  childCount: 20,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding for FAB
            ],
          ),
          
          // FAB
          SafeArea(
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: ElevatedButton.icon(
                 onPressed: () {},
                 icon: const Icon(Icons.videocam, color: Colors.white),
                 label: const Text('Use this sound', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFFEA4359),
                   minimumSize: const Size(double.infinity, 50),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                 ),
               ),
             ),
          ),
        ],
      ),
    );
  }
}
