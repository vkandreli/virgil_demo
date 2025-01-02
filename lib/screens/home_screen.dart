import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'recommendations_screen.dart';
import 'bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(        
            child: Center(
              child: Text('Your feed here'),
            ),      
      ),    
    );
  }
}
