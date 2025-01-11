import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/users_lists.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
////import 'package:virgil_demo/models/user.dart';   // Import User model
import 'package:virgil_demo/widgets/profile_pane.dart';

class OwnProfileScreen extends StatefulWidget {
  final User currentUser;
  const OwnProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _OwnProfileScreenState createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends State<OwnProfileScreen> {
  // Privacy states for each section
  bool isPacksPrivate = true;
  bool isReviewsPrivate = true;
  bool isReadListPrivate = true;

  // Filtered posts list
  List<Post> userPosts = [];

  @override
  void initState() {
    super.initState();
    // Initialize userPosts after widget is fully initialized
    userPosts = placeholderPosts.where((post) {
      return post.originalPoster == widget.currentUser || post.reblogger == widget.currentUser;
    }).toList();

    userPosts =  (widget.currentUser.usersPosts)+userPosts ;
  }

  void togglePrivacy(String section) {
    setState(() {
      if (section == 'packs') {
        isPacksPrivate = !isPacksPrivate;
      } else if (section == 'reviews') {
        isReviewsPrivate = !isReviewsPrivate;
      } else if (section == 'read list') {
        isReadListPrivate = !isReadListPrivate;
      }
    });
  }

  void navigateToUserPacksScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserPacksScreen(user: widget.currentUser, currentUser: widget.currentUser,)),
    );
  }

  void navigateToUserReviewsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserReviewsScreen(user: widget.currentUser, currentUser: widget.currentUser,)),
    );
  }

  void navigateToUserReadListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserReadListScreen(user: widget.currentUser,  currentUser: widget.currentUser,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(user: widget.currentUser, currentUser: widget.currentUser),

            // Horizontal Line with 3 Boxes (packs, reviews, read list)
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _privacyBox(
                    'Packs',
                    isPacksPrivate,
                    () => togglePrivacy('packs'),  // Toggle privacy
                    navigateToUserPacksScreen,      // Navigate to UserPacksScreen
                  ),
                  _privacyBox(
                    'Reviews',
                    isReviewsPrivate,
                    () => togglePrivacy('reviews'), // Toggle privacy
                    navigateToUserReviewsScreen,     // Navigate to UserReviewsScreen
                  ),
                  _privacyBox(
                    'Read List',
                    isReadListPrivate,
                    () => togglePrivacy('read list'), // Toggle privacy
                    navigateToUserReadListScreen,      // Navigate to UserReadListScreen
                  ),
                ],
              ),
            ),

            // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: userPosts[index], currentUser: widget.currentUser, isInOwnProfile: true,);
                },
              ),
            ),
          ],
        ),
      ),
      
      // Floating action button for creating a new post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen(currentUser: widget.currentUser,)),
          );
        },
        backgroundColor: AppColors.darkBrown,
        child: Icon(Icons.add, color: AppColors.lightBrown,),
        
      ),
        bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: widget.currentUser),    

    );
  }
}


Widget _privacyBox(String label, bool isPrivate, VoidCallback onTapIcon, VoidCallback onTapBox) {
  return GestureDetector(
    onTap: onTapBox,  // Navigate to the corresponding screen when the box is tapped
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
          GestureDetector(
            onTap: onTapIcon,  // Toggle privacy when the icon is tapped
            child: Icon(
              isPrivate ? Icons.lock : Icons.lock_open,
              color: isPrivate ? Colors.grey : Colors.green,
            ),
          ),
        ],
      ),
    ),
  );
}

