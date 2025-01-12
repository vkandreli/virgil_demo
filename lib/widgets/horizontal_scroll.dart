import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
// import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/achievement.dart';
//import 'package:virgil_demo/models/book.dart';
//import 'package:virgil_demo/models/pack.dart';
//import 'package:virgil_demo/models/review.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/others_profile_screen.dart';
import 'package:virgil_demo/screens/pack_presentation.dart';
import 'package:virgil_demo/screens/review_presentation.dart';

Widget genericScroll<T>({
  required String title,
  required List<T> items,
  required Widget Function(BuildContext, T)
      itemBuilder, // A callback for rendering each item
  bool showProgress = false,
  bool isCompleted = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != '') ...[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      SizedBox(
        height: showProgress ? 240 : 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.isEmpty ? 1 : items.length,
          itemBuilder: (context, index) {
            if (items.isEmpty) {
              return Center(
                  child: Text(
                      'No items available')); // Handle empty state gracefully
            }
            return itemBuilder(
                context, items[index]); // Proceed if list has items
          },
        ),
      ),
    ],
  );
}

Widget bookScroll(
  String title,
  List<Book> booksToDisplay, {
  bool showProgress = false,
  bool isCompleted = false,
  bool addRemove = false,
  required User currentUser,
}) {
  //List<Book> booksToDisplay = booksToDisplay.isEmpty ? [Book.empty()] : booksToDisplay;

  return genericScroll<Book>(
    title: title,
    items: booksToDisplay,
    itemBuilder: (context, book) {
      return _BookCard(
        book: book,
        showProgress: showProgress,
        isCompleted: booksToDisplay.isEmpty ? false : isCompleted,
        currentUser: currentUser,
      );
    },
  );
}

Widget packScroll(
  String title,
  List<Pack> packs, {
  bool isCompleted = false,
  bool picking = false,
  required User currentUser,
}) {
  return genericScroll<Pack>(
    title: title,
    items: packs,
    itemBuilder: (context, pack) {
      return PackCard(
        pack: pack,
        picking: picking,
        isCompleted: isCompleted,
        currentUser: currentUser, // Pass currentUser here
      );
    },
  );
}

Widget reviewScroll(
  String title,
  List<Review> reviews, {
  required User currentUser, // Add the `currentUser` parameter here
}) {
  return genericScroll<Review>(
    title: title,
    items: reviews,
    itemBuilder: (context, review) {
      return ReviewCard(
        review: review,
        currentUser: currentUser, // Pass currentUser here
      );
    },
  );
}

Widget badgeScroll(
  String title,
  List<Badges> badges, {
  bool showProgress = false,
  bool isCompleted = false,
  required User currentUser,
}) {
  return genericScroll<Badges>(
    title: title,
    items: badges,
    itemBuilder: (context, badge) {
      return BadgeCard(
        badge: badge,
        currentUser: currentUser, // Pass currentUser here
      );
    },
  );
}

class _BookCard extends StatelessWidget {
  final Book? book;
  final bool showProgress;
  final bool isCompleted;
  final User currentUser;
  //final bool addRemove;
  const _BookCard({
    this.book,
    this.showProgress = false,
    this.isCompleted = false,
   // this.addRemove = false,
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
              builder: (context) => BookDetailScreen(
                book: book!,
                currentUser: currentUser,
              ),
            ),
          );
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior:
              Clip.none, // Allow the progress bar to go beyond the image
          children: [
            // Image with border (only when isCompleted is true)
            Container(
              decoration: BoxDecoration(
                border: isCompleted
                    ? Border.all(
                        color: Color.fromARGB(255, 27, 139, 55), width: 2)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book?.posterUrl ??
                      "https://tse3.mm.bing.net/th?id=OIP.n3ng2rUJOu_ceO1NyVChkAHaHa&pid=Api",
                  height: 180, // Fixed height for image
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // If showProgress is true, add the progress indicator on top
            if (showProgress)
              Positioned(
                bottom: 0, // Place the progress bar at the bottom of the image
                left: 0,
                right: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Adjust padding as needed
                  child: LinearProgressIndicator(
                    value: 0.7, // Example value, replace with dynamic value
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
  final bool picking;

  const PackCard({
    this.pack,
    this.isCompleted = false,
    this.picking = false,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pack != null) {
          if (!picking) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PackDetailScreen(
                  pack: pack!,
                  currentUser: currentUser,
                ),
              ),
            );
          } else {
            Navigator.pop(context, pack);
          }
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior:
              Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                border: isCompleted
                    ? Border.all(
                        color: Color.fromARGB(255, 27, 139, 55), width: 2)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://tse4.mm.bing.net/th?id=OIP.-cRUNKZI1jx5Kh2_3hzCPwHaFj&pid=Api',
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

class ReviewCard extends StatefulWidget {
  final Review review;
  final User currentUser;

  const ReviewCard({required this.review, required this.currentUser});

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late Book reviewsBook = Book.empty();
  late User reviewsUser = User.empty();
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _loadReviewData();
  }

  // Async method to load the book and user for the review
  Future<void> _loadReviewData() async {
    try {
      // Fetch book and user associated with the review
      reviewsBook = await SQLService().getBookForReview(widget.review.book_id);
      reviewsUser = await SQLService().getUserForReview(widget.review.user_id);
    } catch (e) {
      // Handle any errors, perhaps show an error message
      reviewsBook = Book.empty(); // Or handle empty state
      reviewsUser = User.empty(); // Or handle empty state
    }
    
    // After loading, set isLoading to false to trigger rebuild
    if (mounted) {
          setState(() {
      isLoading = false;
    });
    }

  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator while fetching data
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        // Navigate to the review detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewDetailScreen(
              review: widget.review,
              currentUser: widget.currentUser,
            ),
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
                    builder: (context) => BookDetailScreen(
                      book: reviewsBook,
                      currentUser: widget.currentUser,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  reviewsBook.title,
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
                    builder: (context) => OtherProfileScreen(
                      user: reviewsUser,
                      currentUser: widget.currentUser,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'By: ${reviewsUser.username}',
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
                  if (index < widget.review.stars) {
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
                widget.review.text,
                style: TextStyle(fontSize: 14),
                maxLines: 3, // Allow up to 3 lines
                overflow: TextOverflow.ellipsis, // Ellipsis for overflow
              ),
            ),
            // Review Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Reviewed on: ${widget.review.reviewDate}',
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


class BadgeCard extends StatelessWidget {
  final Badges badge;
  final User currentUser;

  BadgeCard({required this.badge, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width
      height: 160, // Fixed height
      child: Card(
        elevation: 4.0,
        color: AppColors.lightBrown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Badge image with 16 padding from the top
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0), // 16 padding from top
                child: Image.network(
                  badge.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover, // Ensures the image scales properly
                ),
              ),
              //SizedBox(height: 8),
              // Spacer to push the title up from the bottom
              Spacer(),
              // Badge name with 16 padding from the bottom of the card
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 12.0), // 16 padding at the bottom
                child: Text(
                  badge.name,
                  style: TextStyle(fontSize: 16),
                  textAlign:
                      TextAlign.center, // Centers the text below the image
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
