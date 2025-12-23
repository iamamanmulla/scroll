import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'share_sheet.dart';
import 'comment_section.dart';
import '../music_screen.dart';
import '../../profile/profile_screen.dart';

class VideoOverlay extends StatefulWidget {
  final int index;

  const VideoOverlay({super.key, required this.index});

  @override
  State<VideoOverlay> createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _diskController;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _diskController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _diskController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
       isScrollControlled: true, // Crucial for keyboard expansion
      backgroundColor: Colors.transparent,
      builder: (context) => const CommentSection(),
    );
  }

  void _showShare() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ShareSheet(),
    );
  }
  
  void _navigateToProfile() {
      // Navigating to profile. In a real app, this would take a userID.
      // Reusing the existing ProfileScreen which is hardcoded to Jacob West for now.
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void _navigateToMusic() {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MusicScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left Side: Metadata
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@craig_love',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The most satisfying Job #fyp #satisfying #roadmarking',
                        style: TextStyle(
                            color: Colors.white, 
                             shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                         children: [
                           const Icon(Icons.music_note, color: Colors.white, size: 16),
                           const SizedBox(width: 8),
                           const Text(
                             'Just Good Music 24/7 Stay',
                             style: TextStyle(color: Colors.white),
                           ),
                         ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Right Side: Action Bar
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildProfileAvatar(),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _toggleLike,
                      child: _buildAction(
                        _isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.solidHeart, // Using solid for both but changing color, or could use heart vs solidHeart
                        '328.7K', 
                        color: _isLiked ? Colors.red : Colors.white
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _showComments,
                      child: _buildAction(FontAwesomeIcons.solidCommentDots, '578')
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _showShare,
                      child: _buildAction(FontAwesomeIcons.share, 'Share')
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: _navigateToMusic,
                      child: _buildRotatingDisc()
                    ),
                  ],
                ),
              ],
            ),
             const SizedBox(height: 48), // Bottom nav clearance
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: _navigateToProfile,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
            ),
          ),
          Positioned(
            bottom: -10,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_circle, color: Color(0xFFEA4359), size: 20),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, {Color color = Colors.white}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white, 
            fontSize: 12, 
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ),
      ],
    );
  }

  Widget _buildRotatingDisc() {
    return RotationTransition(
      turns: _diskController,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
         child: Padding(
           padding: const EdgeInsets.all(12.0),
           child: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
               radius: 10,
           ),
         ),
      ),
    );
  }
}
