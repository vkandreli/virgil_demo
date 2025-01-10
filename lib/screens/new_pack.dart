import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/pack.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart'; // Import the book search screen

class CreatePackScreen extends StatefulWidget {
  final User currentUser;
  CreatePackScreen({required this.currentUser});

  @override
  _CreatePackScreenState createState() => _CreatePackScreenState();
}

class _CreatePackScreenState extends State<CreatePackScreen> {
  String? selectedImagePath;
  String? descriptionText, titleText;
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  List<Book> selectedBooks = [];
  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
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

  // Check if the pack can be created (book is required, image or quote or both are required)
  bool _canCreatePack() {
    return selectedBooks != [] &&
        descriptionText != null &&
        selectedImagePath != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Title:',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              // Title text field
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  setState(() {
                    titleText = value;
                  });
                },
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Pack image:',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              // Add Image button (now placed above the search bar)
              selectedImagePath == null
                  ? ElevatedButton(
                      onPressed: _pickImage,
                      child: Icon(Icons.image),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Display the selected image
                        Container(
                          width: double.infinity,
                          height: 200,
                          child: Image.file(
                            File(selectedImagePath!),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
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
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Description:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Description text field
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    descriptionText = value;
                  });
                },
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Navigate to the book search screen when tapped
                  final Book? book = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookSearchScreen(), //query: selectedBook?.title ?? ""
                    ),
                  );
                  // If a book is selected, update the selectedBook
                  if (book != null) {
                    setState(() {
                      selectedBooks.add(book);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  //fixedSize: Size(100, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Search for a book...",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkBrown,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // SizedBox(height: 16),

              // List of books
              ListView(
                shrinkWrap:
                    true, // Allow ListView to take only the required space
                children: [
                  bookScroll("Books in pack", selectedBooks ?? [],
                      currentUser: widget.currentUser),
                ],
              ),
              SizedBox(height: 16),

              // Create Pack button
              ElevatedButton(
                onPressed: _canCreatePack()
                    ? () {
                        Pack pack = Pack(
                          packImage: 'https://tse3.mm.bing.net/th?id=OIP.SGiCm8refU69stH376qy6QHaHU&pid=Api', //selectedImagePath ?? "https://tse3.mm.bing.net/th?id=OIP.SGiCm8refU69stH376qy6QHaHU&pid=Api",
                          publicationDate: DateTime.now().toString(),
                          title: titleText ?? "",
                          creator: widget.currentUser,
                          description: descriptionText ?? "",
                          books: selectedBooks ?? [], // Ensure non-null list
                        );
                        widget.currentUser.postPack(pack);
setState(() {
                    });
                        Navigator.pop(context);
                      }
                    : null,
                child: Text('Create Pack'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}