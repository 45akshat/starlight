import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starlight/FrontScreen.dart';


class CategoryPage extends StatefulWidget {
  final String text;

  const CategoryPage({Key? key, required this.text}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}


class _CategoryPageState extends State<CategoryPage> {

  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory= widget.text;
  }

  Future<List<Map<String, dynamic>>> _fetchShowsFromFirestore() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('HomePage').doc('AllShows').get();

    if (snapshot.exists && snapshot.data() != null) {
      List<dynamic> dynamicShows = snapshot.data()?['shows'] ?? [];
      List<Map<String, dynamic>> shows = dynamicShows.map((show) {
        return Map<String, dynamic>.from(show);
      }).toList();

      shows.sort((a, b) => (a['ranking'] ?? 0).compareTo(b['ranking'] ?? 0));


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
      body: Container(
        color: const Color(0xff17181C),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '$selectedCategory Shows',
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              _buildCategoryButtons(),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchShowsFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 30,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading shows');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No shows available');
                    }
                    return _buildGridView(snapshot.data!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryButton('Most Watched'),
            const SizedBox(width: 10),
            _buildCategoryButton('Recently Added'),
            const SizedBox(width: 10),
            _buildCategoryButton('Best Rated'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return ElevatedButton(
      onPressed: () {
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

  Widget _buildGridView(List<Map<String, dynamic>> movieData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.7,
        ),
        itemCount: movieData.length,
        itemBuilder: (context, index) {
          final movie = movieData[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  movie["img_link"] ?? '',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
