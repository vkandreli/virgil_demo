import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/screens/users_lists.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/widgets/profile_pane.dart';


// class OtherProfileScreen extends StatelessWidget {
//   final User user, currentUser;
//   const OtherProfileScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //User user = User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com");
//     List<Post> userPosts = placeholderPosts.where((post) {
//       return post.originalPoster == user || post.reblogger == user;
//     }).toList();
    
//     return Scaffold(
//       body: SafeArea( // Ensures no overlap with the status bar
//         child: Column(
//           children: [
//             // Profile Pane
//             ProfilePane(user: user, currentUser: currentUser,),
// Container(
//               padding: EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _privacyBox(
//                     'Packs',
//                     isPacksPrivate,
//                     () => togglePrivacy('packs'),  // Toggle privacy
//                     navigateToUserPacksScreen,      // Navigate to UserPacksScreen
//                   ),
//                   _privacyBox(
//                     'Reviews',
//                     isReviewsPrivate,
//                     () => togglePrivacy('reviews'), // Toggle privacy
//                     navigateToUserReviewsScreen,     // Navigate to UserReviewsScreen
//                   ),
//                   _privacyBox(
//                     'Read List',
//                     isReadListPrivate,
//                     () => togglePrivacy('read list'), // Toggle privacy
//                     navigateToUserReadListScreen,      // Navigate to UserReadListScreen
//                   ),
//                 ],
//               ),
//             ),
//             // Expanded space for posts
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userPosts.length,
//                 itemBuilder: (context, index) {
//                   return PostWidget(post: userPosts[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
      
//       // Floating action button for creating a new post
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     // Navigate to CreatePostScreen when pressed
//       //     Navigator.push(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => CreatePostScreen()),
//       //     );
//       //   },
//       //   child: Icon(Icons.add), // Icon for the button
//       //   backgroundColor: Colors.blue, // Set button color
//       // ),
//     );
//   }
// }

class OtherProfileScreen extends StatelessWidget {
  final User user, currentUser;
  const OtherProfileScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtered posts list based on the user
    List<Post> userPosts = placeholderPosts.where((post) {
      return post.originalPoster == user || post.reblogger == user;
    }).toList();

    // Navigate to the corresponding screen
    void navigateToUserPacksScreen() {
      if (!user.isPacksPrivate) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPacksScreen(user: currentUser)),
        );
      }
    }

    void navigateToUserReviewsScreen() {
      if (!user.isReviewsPrivate) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserReviewsScreen(user: currentUser)),
        );
      }
    }

    void navigateToUserReadListScreen() {
      if (!user.isReadListPrivate) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserReadListScreen(user: currentUser)),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(user: user, currentUser: currentUser),

            // Horizontal Line with 3 Boxes (packs, reviews, read list)
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _privacyBox(
                    'Packs',
                    user.isPacksPrivate,
                    navigateToUserPacksScreen,      // Navigate to UserPacksScreen
                  ),
                  _privacyBox(
                    'Reviews',
                    user.isReviewsPrivate,
                    navigateToUserReviewsScreen,     // Navigate to UserReviewsScreen
                  ),
                  _privacyBox(
                    'Read List',
                    user.isReadListPrivate,
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
                  return PostWidget(post: userPosts[index], currentUser: currentUser,);
                },
              ),
            ),
          ],
        ),
      ),    
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
