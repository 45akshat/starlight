import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/AllShows.dart';
import 'reusable_carousel.dart';
import 'package:intl/intl.dart';
import 'package:starlight/ShowDetailScreen.dart';
import 'package:starlight/CategoryPage.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({Key? key}) : super(key: key);

  @override
  _KidsScreenState createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  String selectedCategory = 'Most Watched';

  Future<List<Map<String, dynamic>>> _fetchKidsShowsFromFirestore(String docsname) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance
        .collection('HomePage')
        .doc(docsname)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      List<dynamic> dynamicShows = snapshot.data()?['shows'] ?? [];
      List<Map<String, dynamic>> shows = dynamicShows.map((show) {
        return Map<String, dynamic>.from(show);
      }).toList();
      return shows;
    } else {
      return [
        {
          'category': "Adventure",
          'date': "2024-01-01",
          'img_link': "https://via.placeholder.com/150x200?text=Show+1",
          'ranking': 8.7,
          'stream_id': "201",
          'title': "The Great Adventure"
        }
      ];
    }
  }

  Future<List<List<Map<String, dynamic>>>> _fetchBothCollections() async {

    return await Future.wait([
      _fetchKidsShowsFromFirestore('KidsAllShows'),
      _fetchKidsShowsFromFirestore('KidsHeroCarousel'),

    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue.shade900,
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
          'Starlight Kids',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: _fetchBothCollections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error fetching data',
                    style: TextStyle(color: Colors.white)));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No shows available',
                      style: TextStyle(color: Colors.white)));
            }

            final List<Map<String, dynamic>> kidsshowsFromFirestore = snapshot.data![0];
            final List<Map<String, dynamic>> kidsheroCarouselShows = snapshot.data![1];

            return Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCarouselSlider(
                        aspectRatio: 0.7,
                        imgList: kidsheroCarouselShows
                            .map((show) => {
                          "image_url": show["img_link"],
                          "show_id": show["stream_id"],
                          "date": show["date"]
                        })
                            .toList(),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('Continue Watching',
                            style: TextStyle(fontSize: 25, color: Colors.white)),
                      ),
                      _buildHorizontalListView(kidsheroCarouselShows.sublist(0, 3)),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            const Text('All Kids Shows',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowGridScreen()),
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios_outlined),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      _buildHorizontalListView(kidsheroCarouselShows),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('Newly Added',
                            style: TextStyle(fontSize: 25, color: Colors.white)),
                      ),
                      AllShowsListView(kidsheroCarouselShows),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 70,
                left: 5,
                right: 5,
                child: SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryButton('Most Watched'),
                        SizedBox(width: 10),
                        _buildCategoryButton('Recently Added'),
                        SizedBox(width: 10),
                        _buildCategoryButton('Best Rated'),
                      ],
                    ),
                  ),
                ),
              )
            ]);
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryPage(text: text)),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:
        selectedCategory == text ? Colors.deepOrangeAccent : Colors.grey,
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShowDetailScreen(showId: movie["stream_id"], title: movie["title"]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  movie["img_link"] ?? '',
                  width: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShowDetailScreen(showId: movie["stream_id"], title: movie["title"]),
                ),
              );
            },
            child: Padding(
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
            ),
          );
        },
      ),
    );
  }
}
