import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LiveStreamingScreen extends StatefulWidget {
  const LiveStreamingScreen({super.key});

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isMicOn = true;
  bool _isCameraOn = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Use front camera strictly as per "Selfie/Broadcaster" vibe usuallly,
        // but can default to back. Prompt image shows a user looking at camera (selfie or back).
        // Let's use back first as standard, or 1 if available for front.
        // Assuming index 1 is front usually.
        final camera = cameras.length > 1 ? cameras[1] : cameras[0];
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true, // Allow UI to push up
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Preview
          if (_isCameraInitialized && _isCameraOn)
            CameraPreview(_controller!)
          else
            Container(
              color: Colors.grey.shade900,
              child: const Center(
                child: Icon(
                  Icons.videocam_off,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),

          // 2. Top Info Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _buildBroadcasterInfo(),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: const Text(
                        '00:30',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Right Sidebar (Controls)
          Positioned(
            right: 16,
            top: 100,
            child: Column(
              children: [
                _buildSideButton(Icons.share, 'Share', onTap: () {}),
                _buildSideButton(
                  _isMicOn ? Icons.mic : Icons.mic_off,
                  'Mic',
                  onTap: () {
                    setState(() => _isMicOn = !_isMicOn);
                  },
                ),
                _buildSideButton(
                  _isCameraOn ? Icons.videocam : Icons.videocam_off,
                  'Camera',
                  onTap: () {
                    setState(() => _isCameraOn = !_isCameraOn);
                  },
                ),
                _buildSideButton(
                  Icons.flip_camera_ios,
                  'Flip',
                  onTap: () {},
                ), // Logic would require re-init camera
                _buildSideButton(
                  Icons.filter_vintage,
                  'Filters',
                  onTap: _showFilters,
                ),
              ],
            ),
          ),

          // 4. Left Sidebar (E-commerce Tools)
          Positioned(
            left: 16,
            top: 150,
            child: Column(
              children: [
                _buildToolButton(Icons.text_fields, 'Text'),
                _buildToolButton(Icons.image, 'Catalog'),
                _buildToolButton(Icons.local_offer, 'Price'),
              ],
            ),
          ),

          // 5. Bottom Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Comment List
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        reverse: true,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          final comments = [
                            {
                              'user': 'pink_lemonade',
                              'msg': 'Gonna buy this for sure!',
                            },
                            {
                              'user': 'princess_tiara',
                              'msg': 'Ohhh yess! This outfit looks awesome!!!',
                            },
                            {'user': 'jennyfar', 'msg': 'Love your outfit!'},
                            {
                              'user': 'anabelly_ju',
                              'msg': 'joined the livestream',
                            },
                          ];
                          final c = comments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=${index + 30}',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: '${c['user']}\n',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: c['msg'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Product Highlight Box
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.9,
                            ), // Slightly opaque white for contrast
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://picsum.photos/200',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Special Glasses',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '45 left',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      '\$10.00',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEA4359),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 0,
                                      ),
                                      minimumSize: const Size(0, 36),
                                    ),
                                    child: const Text(
                                      'Buy now',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: -8,
                                    top: -8,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {}, // Close product box
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Comment Input (Simulated)
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.4),
                        hintText: 'Write a comment...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(
                          Icons.home_outlined,
                          color: Colors.white,
                        ), // Home icon as placeholder for keyboard actions/emoji
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcasterInfo() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=9',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA4359),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'isahan...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '521 views',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSideButton(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 26,
              shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 26,
            shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    // Placeholder for filter sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 150,
        color: Colors.black.withOpacity(0.8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              color: Colors.grey,
              child: Center(
                child: Text(
                  'Filter $index',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
