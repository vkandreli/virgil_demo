// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'screens/bottom_navigation.dart';
import 'models/user.dart';
import 'models/userProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),  // Create UserProvider instance
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //final User self = placeholderSelf;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virgil',
      theme: ThemeData(
        primarySwatch: Colors.brown, // Matching primary color
        scaffoldBackgroundColor:  Color(0xFFAB886D), // Set default background color to white
        textTheme: TextTheme(
          bodyLarge:  TextStyle(color: Colors.black),
          bodyMedium:  TextStyle(color: Colors.black),
          bodySmall:  TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black), 
          headlineSmall: TextStyle(color: Colors.black), 

        ),
      ),
      home: BottomNavWrapper(),
    );
  }
}

