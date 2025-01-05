import 'dart:io';

import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/book.dart';
import 'book_search_screen.dart'; // Import the book search screen
import 'package:image_picker/image_picker.dart'; // Add this for image picking

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? selectedBookTitle;
  String? selectedImagePath;

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path;
      });
    }
  }

  // Function to remove the image
  void _removeImage() {
    setState(() {
      selectedImagePath = null;
    });
  }

  // Check if the post can be created (both image and description not empty, and book selected)
  bool _canCreatePost() {
    return selectedBookTitle != null && selectedImagePath != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: SingleChildScrollView( // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Image button (now placed above the search bar)
              selectedImagePath == null
                  ? ElevatedButton(
                      onPressed: _pickImage,
                      child: Icon(Icons.image),
                    )
                  : Stack(
                      children: [
                        // Display the selected image (fit the width of the screen)
                        Image.file(
                          File(selectedImagePath!),
                          width: double.infinity, // Makes the image fit the width
                          height: 200, // Set a fixed height for the image
                          fit: BoxFit.cover, // Ensures the image maintains its aspect ratio
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: _removeImage,
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 16),

              // Description field (background always white)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  fillColor: Colors.white, // Set background color to white
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),

              // Search bar for book title (background always white)
              TextField(
                decoration: InputDecoration(
                  labelText: selectedBookTitle ?? 'Search Book',
                  fillColor: Colors.white, // Set background color to white
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  // Navigate to the book search screen when tapped
                  final selectedBook = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookSearchScreen(query: ""),
                    ),
                  );
                  // If a book is selected, update the search bar
                  if (selectedBook != null) {
                    setState(() {
                      selectedBookTitle = selectedBook.title;
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              // Create Post button
              ElevatedButton(
                onPressed: _canCreatePost() ? () {
                  // Handle the post creation logic here
                  print('Post Created');
                  Navigator.pop(context); // Navigate back to the Profile screen
                } : null, // Disable the button if conditions are not met
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}