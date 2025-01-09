import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/chatbot_screen.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart'; // Import the MovieDetailScreen
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//import 'package:virgil_demo/assets/placeholders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';  // To convert lat/lon to address

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
    User currentUser = placeholderSelf;
    String? _currentCity = 'your location';
  // late GoogleMapController mapController;
  // late LocationData currentLocation;

  // // Initialize the location package
  // Location location = Location();

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    _getLocationandPermission();
  }

  // Fetch current location of the user
  // Future<void> _getCurrentLocation() async {
  //   LocationData locationData = await location.getLocation();
  //   setState(() {
  //     currentLocation = locationData;
  //   });

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
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           decoration: InputDecoration(
              //             hintText: 'Search books...',
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //       ),
              //       IconButton(
              //         icon: Icon(Icons.camera_alt),
              //         onPressed: () async {
              //           logger.i("Camera pressed");
              //           final cameras = await availableCameras();
              //           if (cameras.isNotEmpty) {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (_) => CameraScreen(camera: cameras.first),
              //               ),
              //             );
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: ListView(
                children: [
                              // Google Map 
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     height: 300, // Height for the Google Map
            //     child: currentLocation != null
            //         ? GoogleMap(
            //             initialCameraPosition: CameraPosition(
            //               target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            //               zoom: 14.0,
            //             ),
            //             onMapCreated: (GoogleMapController controller) {
            //               mapController = controller;
            //             },
            //           )
            //         : Center(child: CircularProgressIndicator()),
            //   ),
            // ),
                  bookScroll("Popular in ${_currentCity}", placeholderBooks, currentUser: currentUser), 
                  bookScroll('What your community is reading', placeholderBooks, currentUser: currentUser),
                  reviewScroll('Hottest reviews', placeholderReviews, currentUser: currentUser), 
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          // Navigate to the chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotScreen()),
          );
        },
      ),
        bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: currentUser),    

    );
  }
}
