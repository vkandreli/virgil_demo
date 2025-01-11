import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
//import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/screens/users_lists.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
////import 'package:virgil_demo/models/user.dart';  
//import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/widgets/profile_pane.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';  // Import the custom bottom navigation bar

class OtherProfileScreen extends StatefulWidget {
  final User user, currentUser;
  const OtherProfileScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  _OtherProfileScreenState createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  late List<Post> userPosts;  

  Future<void> _getPosts() async {
  userPosts = await SQLService().getPostsForUser(widget.user.id);


  @override
  void initState() {
    super.initState();
    userPosts = placeholderPosts.where((post) {
      return post.originalPoster_id == widget.user || post.reblogger_id == widget.user;
    }).toList();
  }

  // Navigate to the corresponding screen (methods for privacy box navigation)
  void navigateToUserPacksScreen() {
    if (!widget.user.isPacksPrivate) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPacksScreen(user: widget.user, currentUser: widget.currentUser)),
      );
    }
  }

  void navigateToUserReviewsScreen() {
    if (!widget.user.isReviewsPrivate) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserReviewsScreen(user: widget.user, currentUser: widget.currentUser)),
      );
    }
  }

  void navigateToUserReadListScreen() {
    if (!widget.user.isReadListPrivate) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserReadListScreen(user: widget.user, currentUser: widget.currentUser)),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(user: widget.user, currentUser: widget.currentUser),

            // Horizontal Line with 3 Boxes (packs, reviews, read list)
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _privacyBox(
                    'Packs',
                    widget.user.isPacksPrivate,
                    navigateToUserPacksScreen,
                  ),
                  _privacyBox(
                    'Reviews',
                    widget.user.isReviewsPrivate,
                    navigateToUserReviewsScreen,
                  ),
                  _privacyBox(
                    'Read List',
                    widget.user.isReadListPrivate,
                    navigateToUserReadListScreen,
                  ),
                ],
              ),
            ),

            // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: userPosts[index], currentUser: widget.currentUser, isInOwnProfile: false,);
                },
              ),
            ),
          ],
        ),
      ),
  bottomNavigationBar: CustomBottomNavBar(context: context, currentUser:widget.currentUser),
    );
  }

  // Privacy box widget for navigation (using user privacy states)
  Widget _privacyBox(String label, bool isPrivate, VoidCallback onTapBox) {
    return GestureDetector(
      onTap: () {
        if (!isPrivate) {
          onTapBox(); // Only navigate if not private
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(
              isPrivate ? Icons.lock : Icons.lock_open,  // Show lock or unlocked based on privacy state
              color: isPrivate ? Colors.grey : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
