import 'package:flutter/material.dart';
import 'package:uas_mobile/searchscreen.dart';
import 'api_service.dart';
import 'movie_detail_screen.dart';
import 'popular_movies_carousel.dart'; // Import carousel widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  late Future<List<dynamic>> moviesByCategory;
  late Future<List<dynamic>> popularMovies;
  String selectedCategory = 'All'; // Default kategori

  @override
  void initState() {
    super.initState();
    fetchMoviesBySelectedCategory(selectedCategory);
    popularMovies =
        fetchPopularMovies(); // Fetch popular movies secara terpisah
  }

  void fetchMoviesBySelectedCategory(String category) {
    setState(() {
      if (category == 'All') {
        moviesByCategory = ApiService.fetchAllMovies();
      } else {
        moviesByCategory = ApiService.fetchMoviesByCategory(category);
      }
    });
  }

  Future<List<dynamic>> fetchPopularMovies() async {
    List<dynamic> movies = await ApiService.fetchAllMovies();
    movies.sort((a, b) {
      double ratingA = double.tryParse(a['imdbRating'] ?? '0') ?? 0;
      double ratingB = double.tryParse(b['imdbRating'] ?? '0') ?? 0;
      return ratingB
          .compareTo(ratingA); // Urutkan berdasarkan rating (descending)
    });
    return movies.take(10).toList(); // Ambil 10 film dengan rating tertinggi
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 12, 66, 93),
      title: Text('Movie Finder', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
      ],
    ),
    body: Container(
      // Menambahkan gradasi sebagai latar belakang
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color.fromARGB(255, 69, 128, 158), const Color.fromARGB(255, 2, 26, 37)], // Ganti dengan warna sesuai keinginan Anda
          stops: [0.0, 1.0], // Pengaturan posisi gradasi
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                      fetchMoviesBySelectedCategory(selectedCategory);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selectedCategory == categories[index]
                            ? Color.fromARGB(255, 12, 66, 93)
                            : Colors.grey[300],
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Popular Movies Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Popular Movies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 400,
              child: FutureBuilder<List<dynamic>>(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No movies found'));
                  } else {
                    return PopularMoviesCarousel(movies: snapshot.data!);
                  }
                },
              ),
            ),

            // Movies by Category Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Movies by Category: $selectedCategory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: moviesByCategory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No movies found'));
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
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
          ],
        ),
      ),
    ),
  );
  }
}
