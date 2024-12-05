import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = 'fde91a54'; // Ganti dengan API Key Anda
  static const String baseUrl = 'https://www.omdbapi.com/'; // Gunakan HTTPS untuk keamanan

  /// Fetch movies by category
  static Future<List<dynamic>> fetchMoviesByCategory(String category) async {
    try {
      final url = Uri.parse('$baseUrl?s=$category&apikey=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return data['Search'] ?? []; // Return list of movies
        } else {
          throw Exception(data['Error'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception('Failed to load movies (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching movies by category: $e');
    }
  }
  
  // Fungsi untuk pencarian film berdasarkan kata kunci
  static Future<List<dynamic>> searchMovies(String query) async {
    final url = 'https://www.omdbapi.com/?s=$query&apikey=$apiKey';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['Search'] ?? [];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Fungsi untuk pencarian film berdasarkan kategori genre
  static Future<List<dynamic>> searchMoviesByCategory(String query, String category) async {
    final movies = await searchMovies(query);
    
    // Hanya filter berdasarkan kategori jika kategori selain "All"
    return movies.where((movie) {
      if (category == 'All') {
        return true; // Tidak ada filter jika kategori "All"
      }

      // Dapatkan genre film dan bagi dengan koma untuk mendapatkan daftar genre
      final Category = movie['category']?.split(', ') ?? [];
      return Category.any((genre) => category.toLowerCase() == category.toLowerCase());
    }).toList();
  }


  static Future<List<dynamic>> fetchAllMovies() async {
    // Gabungkan semua film dari berbagai kategori
    List<dynamic> allMovies = [];
    List<String> categories = [
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
    for (String category in categories) {
      List<dynamic> movies = await fetchMoviesByCategory(category);
      allMovies.addAll(movies);
    }
    return allMovies.toSet().toList(); // Hapus duplikasi
  }


  /// Fetch movies by search query
  static Future<List<dynamic>> fetchMoviesBySearch(String query) async {
    try {
      final url = Uri.parse('$baseUrl?s=$query&apikey=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return data['Search'] ?? [];
        } else {
          throw Exception(data['Error'] ?? 'No movies found for query: $query');
        }
      } else {
        throw Exception('Failed to load movies (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching movies by search: $e');
    }
  }
  Future<List<dynamic>> fetchSortedMoviesByRating(String category) async {
  List<dynamic> movies = await ApiService.fetchMoviesByCategory(category);
  
  // Check if the movies are being fetched correctly
  print(movies);  // Add this line for debugging
  
  movies.sort((a, b) {
    double ratingA = double.tryParse(a['imdbRating'] ?? '0') ?? 0;
    double ratingB = double.tryParse(b['imdbRating'] ?? '0') ?? 0;
    return ratingB.compareTo(ratingA); // Descending order
  });
  return movies;
}


  /// Fetch detailed information about a specific movie
  static Future<Map<String, dynamic>> fetchMovieDetail(String movieId) async {
    try {
      final url = Uri.parse('$baseUrl?i=$movieId&apikey=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return data;
        } else {
          throw Exception(data['Error'] ?? 'No details found for movie ID: $movieId');
        }
      } else {
        throw Exception('Failed to load movie details (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }
}
