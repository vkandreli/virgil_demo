import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/assets/placeholders.dart';
//import 'package:virgil_demo/models/user.dart'; 
//import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/others_profile_screen.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class ReviewDetailScreen extends StatefulWidget {
  final Review review;
  final User currentUser;
  const ReviewDetailScreen({required this.review, required this.currentUser});

  @override
  _ReviewDetailScreenState createState() => _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends State<ReviewDetailScreen> {
  late Book reviewsBook= Book.empty();
  late User reviewsUser= User.empty();

  Future<void> _getResources() async {
  reviewsBook = await SQLService().getBookForReview(widget.review.id);
reviewsUser = await SQLService().getUserForReview(widget.review.id); 

  }



  @override
  void initState() {
    super.initState();
    _getResources();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Make the entire screen scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: reviewsBook, currentUser: widget.currentUser),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          reviewsBook.posterUrl.isEmpty? "https://tse3.mm.bing.net/th?id=OIP.n3ng2rUJOu_ceO1NyVChkAHaHa&pid=Api" :reviewsBook.posterUrl,
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reviewsBook.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'By: ${reviewsBook.author}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.lightBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // User Info (Clickable)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherProfileScreen(user: reviewsUser, currentUser: placeholderSelf),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(reviewsUser.profileImage ?? 'https://via.placeholder.com/150'),
                      ),
                      SizedBox(width: 12),
                      Text(
                        reviewsUser.username,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Border around stars, review text, and review date
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkBrown),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stars (Rating)
                      Row(
                        children: List.generate(5, (index) {
                          if (index < widget.review.stars) {
                            return Icon(Icons.star, color: Colors.amber, size: 20);
                          } else {
                            return Icon(Icons.star_border, color: Colors.amber, size: 20);
                          }
                        }),
                      ),
                      SizedBox(height: 16),
                      // Review Text
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          widget.review.text,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Review Date
                      Text(
                        'Reviewed on: ${widget.review.reviewDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Reviews from the same user, same book, same author
                reviewScroll("Reviews by the same user", reviewsUser.usersReviews, currentUser: widget.currentUser),
                reviewScroll("Reviews for the same book",reviewsUser.usersReviews, currentUser: widget.currentUser),
                reviewScroll("Reviews for the same author", reviewsUser.usersReviews, currentUser: widget.currentUser),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(context: context, currentUser:  widget.currentUser),
    );
  }
}
