import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
// //import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/screens/home_screen.dart';
import 'package:virgil_demo/screens/library_screen.dart';
import 'package:virgil_demo/screens/recommendations_screen.dart';
import 'package:virgil_demo/screens/own_profile_screen.dart';

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'recommendations_screen.dart';
import 'own_profile_screen.dart';
// //import 'package:virgil_demo/models/user.dart'; 

class CustomBottomNavBar extends StatelessWidget {
  final BuildContext context;
  final User currentUser;

  const CustomBottomNavBar({Key? key, required this.context, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Color.fromARGB(255, 58, 32, 8),
      unselectedItemColor: Color.fromARGB(255, 58, 32, 8),
      type: BottomNavigationBarType.fixed,
      items: const [
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
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(currentUser: currentUser,)),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LibraryScreen(currentUser: currentUser)),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecommendationsScreen(currentUser: currentUser)),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OwnProfileScreen(currentUser: currentUser),
              ),
            );
            break;
          default:
            break;
        }
      },
    );
  }
}


// class BottomNavWrapper extends StatefulWidget {
//   final User currentUser;

//   const BottomNavWrapper({Key? key, required this.currentUser}) : super(key: key);

//   @override
//   _BottomNavWrapperState createState() => _BottomNavWrapperState();
// }

// class _BottomNavWrapperState extends State<BottomNavWrapper> {
//   int _currentIndex = 0; // Keeps track of the selected index

//   late final List<Widget> screens; // Declare screens as a late variable

//   @override
//   void initState() {
//     super.initState();
//     // Initialize screens list after the widget is built and currentUser is available
//     screens = [
//       HomeScreen(),
//       LibraryScreen(),
//       RecommendationsScreen(),
//       OwnProfileScreen(currentUser: widget.currentUser),
//     ];
//   }

//   // Function to handle tab taps
//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index; // Change the current selected index
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[_currentIndex], // Show the screen based on the selected index
//       bottomNavigationBar: buildBottomNavBar(context, widget.currentUser, _onTabTapped),
//     );
//   }
// }


// BottomNavigationBar buildBottomNavBar(BuildContext context, User currentUser, Function(int) onTabTapped) {
//   return BottomNavigationBar(
//     type: BottomNavigationBarType.fixed,
//     items: const [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: 'Home',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.bookmarks),
//         label: 'Library',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.dashboard),
//         label: 'Recommendations',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.account_circle),
//         label: 'Profile',
//       ),
//     ],
//     onTap: (index) {
//       onTabTapped(index); // Call the onTabTapped function to update the screen
//     },
//   );
// }