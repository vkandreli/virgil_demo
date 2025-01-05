import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/user.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'recommendations_screen.dart';
import 'own_profile_screen.dart';

class BottomNavWrapper extends StatefulWidget {
  @override
  _BottomNavWrapperState createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 0;
  //User currentUser = placeholderSelf;
  // List of screens for each index
  final List<Widget> _screens = [
    HomeScreen(),
    LibraryScreen(),
    RecommendationsScreen(),
    OwnProfileScreen(currentUser: placeholderSelf,),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Change the current selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Show the screen based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the current index
        onTap: _onTabTapped, // Handle tap events
        selectedItemColor: Color.fromARGB(255, 58, 32, 8),
        unselectedItemColor: Color.fromARGB(255, 58, 32, 8),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Recommendations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
