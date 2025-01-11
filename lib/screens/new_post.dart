import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:virgil_demo/models/post.dart';
//import 'package:virgil_demo/models/user.dart'; 
//import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';  // Import the book search screen
import 'package:virgil_demo/SQLService.dart';


class CreatePostScreen extends StatefulWidget {
  final User currentUser;
  CreatePostScreen({required this.currentUser});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Book? selectedBook; // The book selected by the user
  String? selectedImagePath;
  String? quoteText;
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  Future<void> addPost() async {
   await SQLService().getBooksCompletedForUser(widget.user.id);

  }

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

  // Check if the post can be created (book is required, image or quote or both are required)
  bool _canCreatePost() {
    return selectedBook != null && (quoteText != null || selectedImagePath != null);
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

              // Quote field (background always white)
              TextField(
                  textInputAction: TextInputAction.done, 
  onSubmitted: (value) {
    FocusScope.of(context).unfocus();
  },
                decoration: InputDecoration(
                  labelText: 'Quote',
                  fillColor: Colors.white, // Set background color to white
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    quoteText = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Search bar for book title (background always white)
              TextField(
                  textInputAction: TextInputAction.done, 
  onSubmitted: (value) {
    FocusScope.of(context).unfocus();
  },
                decoration: InputDecoration(
                  labelText: selectedBook?.title ?? 'Search Book',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  // Navigate to the book search screen when tapped
                  final Book? book = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookSearchScreen(),//query: selectedBook?.title ?? ""
                    ),
                  );
                  // If a book is selected, update the selectedBook
                  if (book != null) {
                    setState(() {
                      selectedBook = book;
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              // Create Post button
              ElevatedButton(
                onPressed: _canCreatePost()
                    ? () {
                        // Create the Post object
                        Post post = Post(
                          originalPoster_id: widget.currentUser.id, // Use the current user as the poster
                          timePosted: DateTime.now(),
                          imageUrl: 'https://tse3.mm.bing.net/th?id=OIP.PgvVbyS2yPLX6TlQ4Wf-iAHaDb&pid=Api',//selectedImagePath, 
                          quote: quoteText,
                          book_id: selectedBook?.id, // Use the full Book object
                          likes: 0,
                          reblogs: 0,
                        );
// Add the post to the current user's posts



                        // Navigate back to the Profile screen
                        Navigator.pop(context);
                      }
                    : null, // Disable the button if conditions are not met
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
