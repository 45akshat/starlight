import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/AllShows.dart';
import 'reusable_carousel.dart';
import 'package:intl/intl.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String selectedCategory = 'Most Watched'; // Default selected category

  Future<List<Map<String, dynamic>>> _fetchShowsFromFirestore() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('HomePage').doc('AllShows').get();

    if (snapshot.exists && snapshot.data() != null) {
      List<dynamic> dynamicShows = snapshot.data()?['shows'] ?? [];
      List<Map<String, dynamic>> shows = dynamicShows.map((show) {
        return Map<String, dynamic>.from(show);
      }).toList();
      return shows;
    } else {
      return [{
        'category': "Mystery",
        'date': "2024-01-02",
        'img_link': "https://via.placeholder.com/150x200?text=Show+2",
        'ranking': 7.5,
        'stream_id': "202",
        'title': "Mystery of the Lost City"
      }];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(1),
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0),
        title: const Text(
          'Starlight',
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchShowsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data', style: TextStyle(color: Colors.white)));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No shows available', style: TextStyle(color: Colors.white)));
            }

            final shows = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Custom Carousel Slider
                    CustomCarouselSlider(
                      aspectRatio: 0.7,
                      imgList: shows.map((show) => {
                        "image_url": show["img_link"],
                        "show_id": show["stream_id"],
                        "date": show["date"]
                      }).toList(),
                    ),

                    const SizedBox(height: 30),
                    // Section with category buttons


                    const SizedBox(height: 30),

                    // Display selected category list
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        '$selectedCategory Shows',
                        style: const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    _buildHorizontalListView(shows),

                    const SizedBox(height: 30),
                    _buildCategoryButtons(),

                    // Continue Watching section
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Continue Watching', style: TextStyle(fontSize: 25, color: Colors.white)),
                    ),
                    _buildHorizontalListView(shows.sublist(0, 3)),

                    const SizedBox(height: 30),

                    // All Shows section
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          const Text('All Shows', style: TextStyle(fontSize: 25, color: Colors.white)),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ShowGridScreen()),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_ios_outlined),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    _buildHorizontalListView(shows),

                    const SizedBox(height: 30),

                    // Newly Added section
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Newly Added', style: TextStyle(fontSize: 25, color: Colors.white)),
                    ),
                    AllShowsListView(shows),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  // Category buttons
  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryButton('Most Watched'),
          _buildCategoryButton('Recently Added'),
          _buildCategoryButton('Best Rated'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Update the state when a category is selected
        setState(() {
          selectedCategory = text;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: selectedCategory == text ? Colors.blueAccent : Colors.grey,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildHorizontalListView(List<Map<String, dynamic>> movieData) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movieData.length,
        itemBuilder: (context, index) {
          final movie = movieData[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                movie["img_link"] ?? '',
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget AllShowsListView(List<Map<String, dynamic>> movieData) {
  movieData.sort((a, b) {
    DateTime dateA = DateFormat('yyyy-MM-dd').parse(a['date'] ?? '');
    DateTime dateB = DateFormat('yyyy-MM-dd').parse(b['date'] ?? '');
    return dateB.compareTo(dateA);
  });

  return SizedBox(
    height: 300,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movieData.length,
      itemBuilder: (context, index) {
        final movie = movieData[index];
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie["img_link"] ?? '',
                  width: 170,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                movie["date"] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    ),
  );
}
