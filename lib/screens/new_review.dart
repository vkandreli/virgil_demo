import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/review.dart';
//import 'package:virgil_demo/models/user.dart'; 
//import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/screens/book_presentation.dart';

class CreateReviewScreen extends StatefulWidget {
  final User currentUser;
  final Book selectedBook;

  const CreateReviewScreen(
      {required this.currentUser, required this.selectedBook});

  @override
  _CreateReviewScreenState createState() =>
      _CreateReviewScreenState(selectedBook: selectedBook);
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  Book selectedBook; // The book selected by the user
  String? text;
  int? stars;

  _CreateReviewScreenState({required this.selectedBook});

  // Check if the review can be created (book is required, text is required, and stars are selected)
  bool _canCreateReview() {
    return text != null && stars != null;
  }


    Future<void> addReview(Review review) async {
   await SQLService().insertReview(review);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Create Review')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                            SizedBox(height: 40),
        Text("Write a review for ${widget.selectedBook.title}", style: TextStyle(color: AppColors.darkBrown, fontSize: 24),),
              // Star Rating Picker
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < (stars ?? 0) ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        stars = index + 1; // Select the star rating
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),

              // Text field (background always white)
              TextField(
                  textInputAction: TextInputAction.done, 
  onSubmitted: (value) {
    FocusScope.of(context).unfocus();
  },
                decoration: InputDecoration(
                  labelText: 'Write some words',
                  fillColor: Colors.white, // Set background color to white
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => BookDetailScreen(
                  //       book: selectedBook,
                  //       currentUser: widget.currentUser,
                  //     ),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBrown),
                child: Text(
                  selectedBook.title,
                  style: TextStyle(color: AppColors.darkBrown),
                ),
              ),
              SizedBox(height: 16),

              // Create Review button
              ElevatedButton(
                onPressed: _canCreateReview()
                    ? () {
                      if (widget.currentUser.id == null) {
  throw Exception("Current user ID cannot be null");
}

                        // Create the Review object
                        Review review = Review(
                          user_id: widget.currentUser.id ?? 1, // Use the current user as the reviewer
                          reviewDate: DateTime.now().toString().split(' ')[0],
                          text: text ?? "No text",
                          book_id: selectedBook.id,
                          stars: stars ?? 0,
                        );

                        // Add the review to the current user's reviews
                        addReview(review);
                        setState(() {});
                        // Navigate back to the Profile screen
                        Navigator.pop(context);
                      }
                    : null, // Disable the button if conditions are not met
                    style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBrown),
                child: Text('Create Review',
                  style: TextStyle(color: AppColors.lightBrown),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
