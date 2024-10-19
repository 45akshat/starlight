import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

class VideoPlayerScreen extends StatefulWidget {
  final String episodeLink;
  final String streamId;
  final String seasonId;
  final String episodeId;

  VideoPlayerScreen({
    required this.episodeLink,
    required this.streamId,
    required this.seasonId,
    required this.episodeId,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.network(widget.episodeLink);

    // Retrieve the saved timestamp if available
    String? savedTimestamp = await _storage.read(
      key: "${widget.streamId}_${widget.seasonId}_${widget.episodeId}_timestamp",
    );

    _videoPlayerController.addListener(() async {
      // Save current playback position every time it changes
      if (_videoPlayerController.value.isPlaying) {
        int currentPosition = _videoPlayerController.value.position.inSeconds;
        await _storage.write(
          key: "${widget.streamId}_${widget.seasonId}_${widget.episodeId}_timestamp",
          value: currentPosition.toString(),
        );
      }
    });

    // Once the video is initialized, check if there's a saved timestamp to seek to
    _videoPlayerController.initialize().then((_) {
      setState(() {
        isInitialized = true;
      });

      if (savedTimestamp != null) {
        // Seek to the saved position if it exists
        _videoPlayerController.seekTo(Duration(seconds: int.parse(savedTimestamp)));
      }

      _videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    // Save the current timestamp before the video is disposed (on exit)
    _storage.write(
      key: "${widget.streamId}_${widget.seasonId}_${widget.episodeId}_timestamp",
      value: _videoPlayerController.value.position.inSeconds.toString(),
    );

    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isInitialized
          ? AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
