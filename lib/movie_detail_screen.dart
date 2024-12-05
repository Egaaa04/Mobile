import 'package:flutter/material.dart';
import 'api_service.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  MovieDetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 12, 66, 93), // Ubah warna AppBar menjadi oranye tua
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 69, 128, 158), const Color.fromARGB(255, 2, 26, 37)], // Gradasi dari oranye tua ke oranye
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService.fetchMovieDetail(movieId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Movie not found', style: TextStyle(color: Colors.white)));
            } else {
              final movie = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster Image
                      Center(
                        child: Image.network(
                          movie['Poster'] != "N/A"
                              ? movie['Poster']
                              : 'https://via.placeholder.com/300',
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      
                      // Title
                      Text(
                        movie['Title'],
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ubah warna teks menjadi putih
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),

                      // Movie Details
                      Text('Year: ${movie['Year']}', style: TextStyle(color: Colors.white)),
                      Text('Genre: ${movie['Genre']}', style: TextStyle(color: Colors.white)),
                      Text('Director: ${movie['Director']}', style: TextStyle(color: Colors.white)),
                      Text('Actors: ${movie['Actors']}', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 16.0),

                      // Plot
                      Text(
                        'Plot',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        movie['Plot'],
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
