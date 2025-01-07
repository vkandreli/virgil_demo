import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/pack.dart';
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/others_profile_screen.dart';
import 'package:virgil_demo/screens/pack_presentation.dart';
import 'package:virgil_demo/screens/review_presentation.dart';

Widget genericScroll<T>({
  required String title,
  required List<T> items,
  required Widget Function(BuildContext, T) itemBuilder,  // A callback for rendering each item
  bool showProgress = false,
  bool isCompleted = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: showProgress ? 240 : 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.isEmpty ? 1 : items.length,  // Correct itemCount for empty case
          itemBuilder: (context, index) {
            if (items.isEmpty) {
              return Center(child: Text('No items available'));  // Handle empty state gracefully
            }
            return itemBuilder(context, items[index]);  // Proceed if list has items
          },
        ),
      ),
    ],
  );
}


Widget bookScroll(
  String title, 
  List<Book> books, {
  bool showProgress = false, 
  bool isCompleted = false, 
  required User currentUser,  // Add the `currentUser` parameter here
}) {
  return genericScroll<Book>(
    title: title,
    items: books,
    itemBuilder: (context, book) {
      return _BookCard(
        book: book,
        showProgress: showProgress,
        isCompleted: isCompleted,
        currentUser: currentUser,  // Pass currentUser here
      );
    },
  );
}

Widget packScroll(
  String title, 
  List<Pack> packs, {
  bool isCompleted = false,
  required User currentUser,  // Add the `currentUser` parameter here
}) {
  return genericScroll<Pack>(
    title: title,
    items: packs,
    itemBuilder: (context, pack) {
      return PackCard(
        pack: pack,
        isCompleted: isCompleted,
        currentUser: currentUser,  // Pass currentUser here
      );
    },
  );
}

Widget reviewScroll(
  String title, 
  List<Review> reviews, {
  required User currentUser,  // Add the `currentUser` parameter here
}) {
  return genericScroll<Review>(
    title: title,
    items: reviews,
    itemBuilder: (context, review) {
      return ReviewCard(
        review: review,
        currentUser: currentUser,  // Pass currentUser here
      );
    },
  );
}


class _BookCard extends StatelessWidget {
  final Book? book;
  final bool showProgress;
  final bool isCompleted;
  final User currentUser;

  const _BookCard({
    this.book,
    this.showProgress = false,
    this.isCompleted = false,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (book != null) {
          // Navigate to the BookDetailScreen with the selected book
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book!, currentUser: currentUser,),
            ),
          );
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior: Clip.none,  // Allow the progress bar to go beyond the image
          children: [
            // Image with border (only when isCompleted is true)
            Container(
              decoration: BoxDecoration(
                border: isCompleted ? Border.all(color: Color.fromARGB(255, 27, 139, 55), width: 2) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book?.posterUrl ?? 'https://via.placeholder.com/120x180',
                  height: 180, // Fixed height for image
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // If showProgress is true, add the progress indicator on top
            if (showProgress)
              Positioned(
                bottom: 0,  // Place the progress bar at the bottom of the image
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),  // Adjust padding as needed
                  child: LinearProgressIndicator(
                    value: 0.7,  // Example value, replace with dynamic value
                    color: Color.fromARGB(255, 27, 139, 55),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PackCard extends StatelessWidget {
  final Pack? pack;
  final bool isCompleted;
  final User currentUser;

  const PackCard({
    this.pack,
    this.isCompleted = false,
    required this.currentUser,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pack != null) {
          // Navigate to the BookDetailScreen with the selected book
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PackDetailScreen(pack: pack!, currentUser: currentUser,),
            ),
          );
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior: Clip.none,  // Allow the progress bar to go beyond the image
          children: [
            // Image with border (only when isCompleted is true)
            Container(
              decoration: BoxDecoration(
                border: isCompleted ? Border.all(color: Color.fromARGB(255, 27, 139, 55), width: 2) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pack?.packImage?? 'https://via.placeholder.com/120x180',
                  height: 180, // Fixed height for image
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),          
          ],
        ),
      ),
    );
  }
}


class ReviewCard extends StatelessWidget {
  final Review review;
  final User currentUser;
  const ReviewCard({
    required this.review,
    required this.currentUser
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the review detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewDetailScreen(review: review, currentUser: currentUser,),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkBrown),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Title - Clickable to navigate to BookDetailScreen
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailScreen(book: review.book, currentUser: currentUser,),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  review.book.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                ),
              ),
            ),
            // User - Clickable to navigate to OtherProfileScreen
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherProfileScreen(user: review.user, currentUser: placeholderSelf,),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'By: ${review.user.username}',
                  style: TextStyle(fontSize: 14, color: AppColors.lightBrown),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                ),
              ),
            ),
            // Stars (show stars based on rating)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: List.generate(5, (index) {
                  // This will generate 5 stars
                  if (index < review.stars) {
                    return Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.amber, // Full star
                    );
                  } else {
                    return Icon(
                      Icons.star_border,
                      size: 18,
                      color: Colors.amber, // Empty star
                    );
                  }
                }),
              ),
            ),
            // Review Text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                review.text,
                style: TextStyle(fontSize: 14),
                maxLines: 3, // Allow up to 3 lines
                overflow: TextOverflow.ellipsis, // Ellipsis for overflow
              ),
            ),
            // Review Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Reviewed on: ${review.reviewDate}',
                style: TextStyle(fontSize: 12, color: AppColors.lightBrown),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Ellipsis for overflow
              ),
            ),
          ],
        ),
      ),
    );
  }
}

