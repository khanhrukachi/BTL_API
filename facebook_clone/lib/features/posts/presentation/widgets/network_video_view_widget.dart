import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NetworkVideoViewWidget extends StatefulWidget {
  const NetworkVideoViewWidget({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<NetworkVideoViewWidget> createState() => _NetworkVideoViewState();
}

class _NetworkVideoViewState extends State<NetworkVideoViewWidget> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _showPlayButton = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _showPlayButton = true;
      } else {
        _videoController.play();
        _showPlayButton = false;
      }
    });
  }

  void _togglePlayButtonVisibility() {
    setState(() {
      _showPlayButton = !_showPlayButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: _togglePlayButtonVisibility,
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_videoController),
            if (_showPlayButton)
              Center(
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _videoController.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
