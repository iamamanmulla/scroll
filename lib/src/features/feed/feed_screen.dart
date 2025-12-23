import 'package:flutter/material.dart';
import 'widgets/video_post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  int _focusedIndex = 0;

  // Use a public test video URL (Big Buck Bunny or similar is common practice)
  final String _testVideoUrl = 
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'; 

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Following', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)),
            const SizedBox(width: 8),
            Container(width: 1, height: 12, color: Colors.white.withOpacity(0.2)),
            const SizedBox(width: 8),
            const Text('For You', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: 10, 
        itemBuilder: (context, index) {
          return VideoPost(
            index: index,
            focusedIndex: _focusedIndex,
            videoUrl: _testVideoUrl,
          );
        },
      ),
    );
  }
}
