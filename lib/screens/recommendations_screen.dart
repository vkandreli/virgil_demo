import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/chatbot_screen.dart';
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
    late List<Review> hotReviews;
    late List<Book> communityReads;

Future<void> _getHotReviews() async {
    hotReviews = await SQLService().getReviewsByDate();
    }

Future<void> _getCommunityReads() async {
  communityReads = await SQLService().getCommunityReading( widget.currentUser.id);
}


  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    _getLocationandPermission();
    _getHotReviews(); 
    _getCommunityReads(); }

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
  

  @override
  Widget build(BuildContext context) {
  final Logger logger = Logger(); 
  return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                children: [
                  bookScroll("Popular in ${_currentCity}", placeholderBooks, currentUser: widget.currentUser), 
                  bookScroll('What your community is reading', communityReads, currentUser: widget.currentUser),
                  reviewScroll('Hottest reviews', hotReviews, currentUser: widget.currentUser), 
                  SizedBox(height: 12),
                ],
              ),
            ),
                      
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
         backgroundColor: AppColors.darkBrown,
        child: Icon(Icons.chat, color: AppColors.lightBrown,),
        onPressed: () {
          // Navigate to the chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotScreen()),
          );
        },
      ),
        bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: widget.currentUser),    

    );
  }
}
