import 'package:flutter/material.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/pack.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';
import 'package:virgil_demo/screens/new_pack.dart';
import 'package:virgil_demo/screens/pack_presentation.dart';
import 'package:virgil_demo/screens/pack_search_scene.dart';
import 'own_profile_screen.dart';
import 'home_screen.dart';
import 'recommendations_screen.dart';
import 'package:logger/logger.dart';
//import 'package:virgil_demo/models/book.dart';
import 'package:camera/camera.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/screens/chatbot_screen.dart'; 
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class AddToPack extends StatefulWidget {
  final User currentUser;
  final Book selectedBook;
  AddToPack({required this.currentUser, required this.selectedBook});

  @override
  _AddToPackState createState() => _AddToPackState();
}

class _AddToPackState extends State<AddToPack> {
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
              child: Column(
                children: [                            
                  Text("Add ${widget.selectedBook.title} to pack", style: TextStyle(color: AppColors.darkBrown, fontSize: 24),),

                  Expanded(
                    child: 

                    ElevatedButton(
                        onPressed: () async {
                          // Open PackSearchScreen and wait for the selected pack
                          final Pack? selectedPack = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackSearchScreen(currentUser: widget.currentUser),
                            ),
                          );

                          // If a pack is selected, proceed with adding the book
                          if (selectedPack != null) {
                            // Add the selected book to the pack
                            selectedPack.addBook(widget.selectedBook);

                            // Pop the current screen and return to the previous one with the updated pack
                            Navigator.pop(context, selectedPack);  // Return the updated pack
                          }
                        },

                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(500, 40), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(340,60),
                      backgroundColor: AppColors.lightBrown,
                    ),
                    child: Text(
                      "Search for existing pack...",
                      style: TextStyle(fontSize: 14, color: AppColors.darkBrown,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ),                      
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  packScroll("Existing packs", widget.currentUser.usersPacks, currentUser: widget.currentUser, picking: true),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to CreatePackScreen and wait for it to finish
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePackScreen(currentUser: widget.currentUser),
                  ),
                );
                setState(() {
                });
              },
              child: Text('New Pack'),
            ),
          ],
        ),
      ),
    );
  }
}
