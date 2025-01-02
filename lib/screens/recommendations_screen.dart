import 'package:flutter/material.dart';
import 'package:virgil_demo/screens/book_presentation.dart'; // Import the MovieDetailScreen

class RecommendationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample list of movie poster URLs and movie titles
    List<Map<String, String>> popularMovies = [
      {"title": "Movie 1", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+1"},
      {"title": "Movie 2", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+2"},
      {"title": "Movie 3", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+3"},
      {"title": "Movie 4", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+4"},
      {"title": "Movie 5", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+5"},
    ];

    List<Map<String, String>> newReleases = [
      {"title": "New Release 1", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+1"},
      {"title": "New Release 2", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+2"},
      {"title": "New Release 3", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+3"},
      {"title": "New Release 4", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+4"},
      {"title": "New Release 5", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+5"},
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // Popular Right Now Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Popular Right Now",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            
            // Horizontal Scrollable Popular Movies
            Container(
              height: 225, // Height of the movie posters row
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularMovies.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to MovieDetailScreen when a poster is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieTitle: popularMovies[index]["title"]!,
                            imageUrl: popularMovies[index]["imageUrl"]!,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        popularMovies[index]["imageUrl"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // New Releases Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "New Releases",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            
            // Horizontal Scrollable New Releases Movies
            Container(
              height: 225, // Height of the movie posters row
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newReleases.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to MovieDetailScreen when a poster is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieTitle: newReleases[index]["title"]!,
                            imageUrl: newReleases[index]["imageUrl"]!,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        newReleases[index]["imageUrl"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
