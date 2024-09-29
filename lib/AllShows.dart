import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowGridScreen extends StatelessWidget {
  // Example JSON data structure with dates
  final List<Map<String, String>> shows = [
    {
      "image_url":
      "https://image.tmdb.org/t/p/w500/jeGvNOVMs5QIU1VaoGvnd3gSv0G.jpg",
      "title": "Top Gun",
      "date": "2024-01-01"
    },
    {
      "image_url":
      "https://image.tmdb.org/t/p/w500/8Y43POKjjKDGI9MH89NW0NAzzp8.jpg",
      "title": "Mission Impossible",
      "date": "2024-01-05"
    },
    {
      "image_url":
      "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
      "title": "Interstellar",
      "date": "2023-12-30"
    },
    {
      "image_url":
      "https://image.tmdb.org/t/p/w500/xlKKD1TXJvh0YYlVPqqQ3g3ZUjM.jpg",
      "title": "Infiesto",
      "date": "2023-12-28"
    },
    {
      "image_url":
      "https://image.tmdb.org/t/p/w500/2mtQwJKVKQrZgTz49Dizb25eOQQ.jpg",
      "title": "Tunnel",
      "date": "2023-12-25"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Sort shows by date in descending order
    shows.sort((a, b) {
      DateTime dateA = DateFormat('yyyy-MM-dd').parse(a['date'] ?? '');
      DateTime dateB = DateFormat('yyyy-MM-dd').parse(b['date'] ?? '');
      return dateB.compareTo(dateA); // Sort from newest to oldest
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('All Shows', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: shows.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  // Number of columns
            crossAxisSpacing: 5.0,  // Space between items horizontally
            mainAxisSpacing: 15.0,   // Space between items vertically
            childAspectRatio: 0.65,  // Aspect ratio for the grid items
          ),
          itemBuilder: (context, index) {
            final show = shows[index];
            return GridTile(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      show['image_url'] ?? '',
                      fit: BoxFit.fitHeight,
                      height: 250,
                      width: double.infinity,
                    ),
                    // SizedBox(height: 5),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: Text(
                    //     show['title'] ?? '',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: Text(
                    //     'Release Date: ${show['date'] ?? ''}',
                    //     style: TextStyle(fontSize: 14, color: Colors.white70),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
