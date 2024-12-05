import 'package:flutter/material.dart';
import '../api_service.dart';
import 'movie_detail_screen.dart';

class AllMoviesScreen extends StatelessWidget {
  final String category;

  AllMoviesScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies: $category'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.fetchMoviesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return ListTile(
                  leading: Image.network(movie['Poster']),
                  title: Text(movie['Title']),
                  subtitle: Text(movie['Year']),
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
    );
  }
}
