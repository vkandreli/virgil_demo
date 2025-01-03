import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/screens/book_presentation.dart'; // Import the MovieDetailScreen
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'package:virgil_demo/assets/placeholders.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late GoogleMapController mapController;
  late LocationData currentLocation;

  // Initialize the location package
  Location location = Location();

  // Sample list of movie poster URLs and movie titles
  // List<Map<String, String>> popularMovies = [
  //   {"title": "Movie 1", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+1"},
  //   {"title": "Movie 2", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+2"},
  //   {"title": "Movie 3", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+3"},
  //   {"title": "Movie 4", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+4"},
  //   {"title": "Movie 5", "imageUrl": "https://via.placeholder.com/150x225?text=Movie+5"},
  // ];

  // List<Map<String, String>> newReleases = [
  //   {"title": "New Release 1", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+1"},
  //   {"title": "New Release 2", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+2"},
  //   {"title": "New Release 3", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+3"},
  //   {"title": "New Release 4", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+4"},
  //   {"title": "New Release 5", "imageUrl": "https://via.placeholder.com/150x225?text=New+Release+5"},
  // ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fetch current location of the user
  Future<void> _getCurrentLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      currentLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // Google Map above New Releases
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300, // Height for the Google Map
                child: currentLocation != null
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                          zoom: 14.0,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),

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
                itemCount: placeholderBooks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to MovieDetailScreen when a poster is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieTitle: placeholderBooks[index].title,
                            imageUrl: placeholderBooks[index].posterUrl,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        placeholderBooks[index].posterUrl,
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
                itemCount: placeholderBooks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to MovieDetailScreen when a poster is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieTitle: placeholderBooks[index].title,
                            imageUrl: placeholderBooks[index].posterUrl,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        placeholderBooks[index].posterUrl,
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
