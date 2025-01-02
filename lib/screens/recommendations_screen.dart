import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'recommendations_screen.dart';

class RecommendationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Profile pane
          //ProfilePane(),

          
          // Expanded space for content
          Expanded(
            child: Center(
              child: Text('Your recommendations here'),
            ),
          ),
        ],
      ),      
    );
  }
}

