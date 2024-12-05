import 'package:flutter/material.dart'; 
import 'api_service.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> searchResults;
  String query = '';
  String selectedCategory = 'All'; // Default category

  final List<String> categories = [
    'All',
    'Action',
    'Comedy',
    'Romance',
    'Horror',
    'Thriller',
    'Animation',
    'Adventure',
    'Sci-Fi',
    'Drama',
  ];

  // Fungsi pencarian film berdasarkan kategori dan query
  void searchMovies(String query, String category) {
    setState(() {
      if (category == 'All') {
        searchResults = ApiService.searchMovies(query); // Tidak ada filter untuk kategori All
      } else {
        searchResults = ApiService.searchMoviesByCategory(query, category); // Filter berdasarkan kategori
      }
    });
  }

  @override
  void initState() {
    super.initState();
    searchResults = Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 12, 66, 93), // Ganti warna appbar menjadi purple
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 69, 128, 158), const Color.fromARGB(255, 2, 26, 37)], // Gradasi warna dari purple ke blue
          ),
        ),
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search for a movie...',
                  labelStyle: TextStyle(color: Colors.white), // Warna label putih
                  prefixIcon: Icon(Icons.search, color: Colors.white), // Warna icon putih
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                  if (query.isNotEmpty) {
                    searchMovies(query, selectedCategory); // Mulai pencarian berdasarkan kategori
                  }
                },
              ),
            ),
            
            // Categories Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                      if (query.isNotEmpty) {
                        searchMovies(query, selectedCategory); // Filter berdasarkan kategori
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selectedCategory == categories[index]
                            ? const Color.fromARGB(255, 12, 66, 93)
                            : Colors.white70,
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Display search results
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No results found', style: TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final movie = snapshot.data![index];
                        return ListTile(
                          leading: Image.network(
                            movie['Poster'] != "N/A"
                                ? movie['Poster']
                                : 'https://via.placeholder.com/100',
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(movie['Title'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(movie['Year'], style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movieId: movie['imdbID']),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
