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
import 'package:virgil_demo/screens/home_screen.dart';
import 'package:virgil_demo/screens/new_pack.dart';
import 'screens/bottom_navigation.dart';
import 'models/user.dart';
import 'screens/login_screen.dart';

class AppConfig {
  static const String apiKey = /** 'AIzaSyAFruL6TGnJ7JQl4mFKUwVYb017K_ANdTc'*/String.fromEnvironment('API_KEY');
}

class AppColors {
  static const Color darkBrown = Color(0xFF3E2723); // Example dark brown color
  static const Color mediumBrown = Color(0xFFAB886D); // Example medium brown color
  static const Color lightBrown = Color(0xFFD6C0B3); // Example light brown color
    static const Color grey = Color(0xFFD9D9D9); // Example light brown color

}


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final User currentUser = placeholderSelf;//provider for user

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Virgil',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkBrown), // Use darkBrown on focus
          ),
          labelStyle: TextStyle(color: AppColors.mediumBrown), // Light brown for labels,
        ),
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
                iconTheme: IconThemeData(
          color: AppColors.darkBrown, // Set the default icon color
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.darkBrown, // Set button background color
          textTheme: ButtonTextTheme.primary, // Set button text color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumBrown,
            iconColor: AppColors.darkBrown,
            
          ),
        ),
      ),
      home: HomeScreen(currentUser: currentUser),// CustomBottomNavBar(context: context, currentUser: currentUser,),// CreatePackScreen(currentUser: placeholderSelf,),
    );
  }
}
