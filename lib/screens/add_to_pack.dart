import 'package:flutter/material.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';
import 'package:virgil_demo/screens/new_pack.dart';
import 'package:virgil_demo/screens/pack_search_scene.dart';
import 'own_profile_screen.dart';
import 'home_screen.dart';
import 'recommendations_screen.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:camera/camera.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/screens/chatbot_screen.dart'; 
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class AddToPack extends StatelessWidget {
  User currentUser;
  AddToPack({required this.currentUser});

  final TextEditingController _searchController = TextEditingController(); // Controller for TextField
  
  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();  // Create an instance of the Logger

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackSearchScreen(currentUser: currentUser),//query: query
                          ),
                        );
                      },
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for existing pack...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.search),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => PackSearchScreen(currentUser: currentUser,),//query: query
                  //       ),
                  //     );
                  //   },
                  // ),                
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  packScroll("Existing packs", currentUser.usersPacks, currentUser: currentUser),
                  ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                    await   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePackScreen(currentUser: currentUser,),
                        ),
                      );
                      },
                child: Text('New Pack'),
              ),
          ],
        ),
      ),

    );
  }

}
