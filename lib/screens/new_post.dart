import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virgil_demo/SQLService.dart';
// import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';  // Import the book search screen
// import 'package:virgil_demo/models/book.dart';

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

  // Save the picked image to local storage
  Future<String?> saveImageLocally(XFile imageFile) async {
    try {
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Generate a unique file name for the image
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create a file path
      final filePath = '${directory.path}/$fileName';

      // Copy the picked image to the new file path
      final File newImage = await File(imageFile.path).copy(filePath);

      return newImage.path;  // Return the local file path (not URL)
    } catch (e) {
      print("Error saving image: $e");
      return null;
    }
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

  // Add post to the database
  Future<void> addPost(Post post) async {
    if (selectedImagePath != null) {
      // Save the image to local storage and get the file path
      String? savedImagePath = await saveImageLocally(XFile(selectedImagePath!));

      if (savedImagePath != null) {
        // Set the image path in the post object
        post.imageUrl = savedImagePath;  // Store the local path
      }
    }

    // Insert the post into the database
    await SQLService().insertPost(post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Image button
              selectedImagePath == null
                  ? ElevatedButton(
                      onPressed: _pickImage,
                      child: Icon(Icons.image),
                    )
                  : Stack(
                      children: [
                        // Display the selected image
                        Image.file(
                          File(selectedImagePath!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
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

              // Quote field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quote',
                  fillColor: Colors.white,
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

              // Search bar for book title
              TextField(
                decoration: InputDecoration(
                  labelText: selectedBook?.title ?? 'Search Book',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final Book? book = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookSearchScreen(),
                    ),
                  );
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
                          originalPoster_id: widget.currentUser.id,
                          timePosted: DateTime.now().toString().split(' ')[0],
                          imageUrl: '', // Image URL will be set later
                          quote: quoteText,
                          book_id: selectedBook?.id,
                          likes: 0,
                          reblogs: 0,
                        );

                        // Add the post to the database
                        addPost(post);

                        // Navigate back
                        Navigator.pop(context);
                      }
                    : null, // Disable button if conditions are not met
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
