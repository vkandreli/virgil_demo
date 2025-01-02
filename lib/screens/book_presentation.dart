import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieTitle;
  final String imageUrl;

  MovieDetailScreen({required this.movieTitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster image
              Center(
                child: Image.network(
                  imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              
              // Movie Title
              Text(
                movieTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Movie Details Section (You can expand this with more data)
              Text(
                "Movie details and description go here.",
                style: TextStyle(fontSize: 18),
              ),
              // Add more movie details like cast, plot, etc.
            ],
          ),
        ),
      ),
    );
  }
}
