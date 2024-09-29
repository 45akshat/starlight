import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class ShowDetailScreen extends StatefulWidget {
  final String showId;

  ShowDetailScreen({required this.showId});

  @override
  _ShowDetailScreenState createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  DocumentSnapshot? showData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShowDetails();
  }

  // Fetch show details from Firestore
  Future<void> _fetchShowDetails() async {
    try {
      // Fetch the show document by the showId
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Stream')
          .doc(widget.showId)
          .get();

      setState(() {
        showData = document;
        isLoading = false;

        String episodeLink = showData!['seasons']['s1'][0]['episode_link'];

        _videoPlayerController = VideoPlayerController.network(episodeLink);
        _chewieController = ChewieController(
          aspectRatio: 16 / 9,
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
        );
      });
    } catch (e) {
      print("Error fetching show details: $e");
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }


    String description = showData!['description'];
    String title = "Show ${widget.showId}";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          Container(
            width: double.infinity, // Full width
            height: 300, // Set your desired height here
            child: Chewie(controller: _chewieController),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 16, right: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                    Text('2 Seasons', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  description,
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
