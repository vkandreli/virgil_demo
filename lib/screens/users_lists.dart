import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';
import 'package:virgil_demo/screens/library_screen.dart';
import 'package:virgil_demo/screens/review_presentation.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';
import 'package:camera/camera.dart';

class UserPacksScreen extends StatelessWidget {
  final User user, currentUser;
  
  const UserPacksScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child:
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                  user == currentUser
                      ? 'Your Packs' 
                      : '${user.username}\'s Packs',              
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,  // 4 items per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: user.usersPacks.length, // Assuming user.usersPacks contains the list of packs
              itemBuilder: (context, index) {
                var pack = user.usersPacks[index];
                return PackCard(
                  pack: pack,
                  currentUser: currentUser,
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}


class UserReviewsScreen extends StatelessWidget {
  final User user, currentUser;

  const UserReviewsScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Ensures no content overlaps with the status bar or system UI
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
                child: Text(
                  user == currentUser
                      ? 'Your Reviews' 
                      : '${user.username}\'s Reviews',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,  // Maximum width for each item, can be adjusted
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: placeholderReviews.length, // Use user.usersReviews.length if available
                itemBuilder: (context, index) {
                  var review = placeholderReviews[index]; // Use the actual reviews data
                  return GestureDetector(
                    onTap: () {
                      // Navigate to ReviewDetailScreen when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewDetailScreen(review: review, currentUser: currentUser,),
                        ),
                      );
                    },
                    child: ReviewCard(review: review, currentUser: currentUser,), // Custom card for the review
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class UserReadListScreen extends StatelessWidget {
  final User user, currentUser;

  const UserReadListScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Ensures no content overlaps with system UI
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child:  ElevatedButton(
                    onPressed: () {                                         
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookSearchScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(100, 40), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Search for a book...",
                      style: TextStyle(fontSize: 14, color: AppColors.darkBrown,),
                      textAlign: TextAlign.left,
                    ),
                  ),                    
                  ),                  
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CameraScreen(camera: cameras.first),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),          
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                user == currentUser
                      ? 'Your Reading List' 
                      : '${user.username}\'s Reading List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,  
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: user.readingList.length, 
                itemBuilder: (context, index) {
                  var book = user.readingList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to BookDetailScreen when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(book: book, currentUser: currentUser,),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      clipBehavior: Clip.none, // Don't clip the image to allow natural stretching
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          book.posterUrl, // Assuming book has cover image URL
                          fit: BoxFit.cover, // This will ensure the image fills the entire area of the card
                          width: double.infinity, // Ensure the image stretches to fill the width of the card
                          height: double.infinity, // Ensure the image stretches to fill the height of the card
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
