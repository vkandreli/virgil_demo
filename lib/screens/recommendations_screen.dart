import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/chatbot_screen.dart';
import 'package:virgil_demo/services/book_service.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';  // To convert lat/lon to address

class RecommendationsScreen extends StatefulWidget {
final User currentUser;
  const RecommendationsScreen({Key? key, required this.currentUser}) : super(key: key); 

  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
    String? _currentCity = 'your location';
    Logger logger = Logger();
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    _getLocationandPermission();  
        booksFuture = _fetchBooks();
}

      Future<void> _getLocationandPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentCity = 'Location services are disabled.';
      });
      return;
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        _currentCity = 'Location permission denied.';
      });
      return;
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Get the city name from the latitude and longitude
    _getCityFromCoordinates(position.latitude, position.longitude);
  }

  // Get the city name from latitude and longitude using geocoding
  Future<void> _getCityFromCoordinates(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    setState(() {
      logger.i("I'm finding your location");
      _currentCity = place.locality;  // This gives the city name
    });
  }
  

  // Fetch books from the database
  Future<List<Book>> _fetchBooks() async {
    try {
      final bookService = BookService();
      await bookService.init(); // Ensure database is initialized
      final books = await bookService.getAllBooks();
      return books;
    } catch (e) {
      // Handle error (e.g., show a message or return an empty list)
      print('Error fetching books: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Use FutureBuilder to display books from the database
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: booksFuture,  // Fetch books from the database
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No books available.'));
                  } else {
                    final books = snapshot.data!;
                    return ListView(
                      children: [
                        bookScroll("Popular in ${_currentCity}", books, currentUser: widget.currentUser),
                        bookScroll('What your community is reading', books, currentUser: widget.currentUser),
                        reviewScroll('Hottest reviews', placeholderReviews, currentUser: widget.currentUser),
                        SizedBox(height: 12),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
        bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: widget.currentUser),    

    );
  }
}