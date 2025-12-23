import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../shared/widgets/main_nav.dart'; // Ensure correct import if needed
import 'video_overlay.dart';

class VideoPost extends StatefulWidget {
  final int index;
  final int focusedIndex;
  final String videoUrl;

  const VideoPost({
    super.key,
    required this.index,
    required this.focusedIndex,
    required this.videoUrl,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        if (widget.index == widget.focusedIndex) {
          _controller.play();
          _controller.setLooping(true);
        }
      }).catchError((error) {
         debugPrint('Video initialization error: $error');
      });
  }

  @override
  void didUpdateWidget(covariant VideoPost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index == widget.focusedIndex && !_controller.value.isPlaying) {
      _controller.play();
      _controller.setLooping(true);
    } else if (widget.index != widget.focusedIndex && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Layer
        Container(
          color: Colors.black,
          child: Center(
            child: _isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
        ),
        
        // Interaction Overlay Layer
        VideoOverlay(index: widget.index),
      ],
    );
  }
}
