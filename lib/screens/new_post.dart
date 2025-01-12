import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import the image package
import 'package:virgil_demo/screens/book_search_screen.dart';
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

  Future<void> addPost(Post post) async {
    await SQLService().insertPost(post);
  }

  // Function to compress the image and convert it to Base64
  Future<String> convertImageToBase64(File image) async {
    // Read the image file as bytes
    List<int> imageBytes = await image.readAsBytes();

    // Decode the image to manipulate it
    img.Image? decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

    if (decodedImage != null) {
      // Compress the image (you can adjust the quality parameter as needed)
      img.Image compressedImage = img.copyResize(decodedImage, width: 600);  // Resize to 600px width
      List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 85);  // Compress JPEG with 85% quality

      // Convert the compressed image bytes to Base64 string
      return base64Encode(compressedBytes);
    } else {
      throw Exception("Failed to decode image.");
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
  ElevatedButton(
  onPressed: () async {
    // Navigate to the book search screen when tapped
    final Book? book = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookSearchScreen(), // query: selectedBook?.title ?? ""
      ),
    );
    // If a book is selected, update the selectedBook
    if (book != null) {
      setState(() {
        selectedBook = book;
      });
    }
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    backgroundColor: Colors.white, // Background color
  ),
  child: Align(
    alignment: Alignment.centerLeft, // Align text to the left
    child: Text(
      selectedBook?.title ?? 'Search Book',
      style: TextStyle(
        color: Colors.black, // Text color
        fontSize: 16,
      ),
    ),
  ),
),

              SizedBox(height: 16),

              ElevatedButton(
  onPressed: _canCreatePost()
      ? () async {
          // Convert the image to Base64 before creating the post
          String base64Image = selectedImagePath != null
              ? await convertImageToBase64(File(selectedImagePath!))
              : ''; // Empty string if no image

          // Create the Post object
          Post post = Post(
            originalPoster_id: widget.currentUser.id,
            timePosted: DateTime.now().toString().split(' ')[0],
            imageUrl: base64Image,  // Use the Base64 image
            quote: quoteText ?? '',
            book_id: selectedBook?.id,
            likes: 0,
            reblogs: 0,
          );

          await addPost(post); // Add the post to the database

          // Safely navigate back if the context is valid
          if (mounted) {
            setState(() {
              
            });
            Navigator.pop(context); // Navigate back
          }
        }
      : null,
  child: Text('Create Post'),
)

            ],
          ),
        ),
      ),
    );
  }
}
