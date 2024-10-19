import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ViewStream extends StatefulWidget {
  @override
  _ViewStreamState createState() => _ViewStreamState();
}

class _ViewStreamState extends State<ViewStream> {
  late VideoPlayerController _videoPlayerController;
  // late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      'https://video.wixstatic.com/video/11062b_20125b6ebe434abd96c4d7773634d1db/480p/mp4/file.mp4?fileUsed=false',
    );

    // _chewieController = ChewieController(
    //   aspectRatio: 16/9,
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,
    //   looping: true,
    //   showControls: true,
    //   showControlsOnInitialize: true,
    //   materialProgressColors: ChewieProgressColors(
    //     playedColor: Color.fromARGB(255, 113, 214, 18),
    //     handleColor: Color.fromARGB(255, 101, 196, 12),
    //     backgroundColor: Colors.grey,
    //     bufferedColor: const Color.fromARGB(255, 174, 174, 174),
    //   ),
    // );
  }

  @override
  void dispose() {
    // _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Container to set the height of the video player
          Container(
            
            width: double.infinity, // Full width
            height: 300, // Set your desired height here
            // child: Chewie(
            //   controller: _chewieController,
            // ),
          ),
          // Movie Details (Title, Genre, Description)
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 16, right: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avatar: The Way of Water',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(' 7.5', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Text('|', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text('Action, Adventure, Fantasy', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text('|', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text('3h 12m', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Jake Sully lives with his newfound family formed on the planet of Pandora. '
                  'Once a familiar threat returns to finish what was previously started, '
                  'Jake must work with Neytiri and the army of the Na\'vi race to protect their home.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}