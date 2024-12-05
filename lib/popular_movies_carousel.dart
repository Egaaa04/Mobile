import 'package:flutter/material.dart';
import '../movie_detail_screen.dart'; // Sesuaikan dengan lokasi file Anda

class PopularMoviesCarousel extends StatelessWidget {
  final List<dynamic> movies;

  PopularMoviesCarousel({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Tinggi Carousel
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(
                    movieId: movie['imdbID'],
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: NetworkImage(
                    movie['Poster'] != "N/A"
                        ? movie['Poster']
                        : 'https://via.placeholder.com/100',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.black54,
                  child: Text(
                    movie['Title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
