import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

import 'episodTrailer.dart';

class ShowDetailScreen extends StatefulWidget {
  final String showId;
  final String title;

  ShowDetailScreen({required this.showId, required this.title});

  @override
  _ShowDetailScreenState createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  late VideoPlayerController _videoPlayerController;
  // late ChewieController _chewieController;
  DocumentSnapshot? showData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShowDetails();
  }

  Future<void> _fetchShowDetails() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Stream')
          .doc(widget.showId)
          .get();

      setState(() {
        showData = document;
        isLoading = false;

        String episodeLink = showData!['trailer_link'];
        _videoPlayerController = VideoPlayerController.network(episodeLink);
      });
    } catch (e) {
      print("Error fetching show details: $e");
    }
  }

  @override
  void dispose() {
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
    bool isMovie = showData?["type"] == "movie";
    Map<String, dynamic>? seasons = {'movie':'sss'};
    if(showData?["type"] != "movie")
       seasons = showData?['seasons'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              // Placeholder for video player or image
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 25),

                  if (isMovie)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                  episodeLink: showData!['movie_link']),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          'Watch Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )

                  else if (seasons != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Seasons",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...seasons.entries.map((seasonEntry) {
                          String seasonKey = seasonEntry.key; // e.g., 's1', 's2'
                          List<dynamic> episodes = seasonEntry.value; // List of episodes

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Season ${seasonKey.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: episodes.length,
                                itemBuilder: (context, index) {
                                  var episode = episodes[index];
                                  return Card(
                                    color: Colors.grey[850],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 4,
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.redAccent,
                                        size: 40,
                                      ),
                                      title: Text(
                                        episode['title'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(episodeLink: episode['episode_link']),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10), // Space between seasons
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
