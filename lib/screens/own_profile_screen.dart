import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/widgets/profile_pane.dart';
import 'package:virgil_demo/models/userProvider.dart';
import 'package:provider/provider.dart'; 

// class OwnProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     User? currentUser = Provider.of<UserProvider>(context).currentUser;
//     // Filter the posts to only show those where self is the original poster or reblogger
//     // List<Post> userPosts = placeholderPosts.where((post) {
//     //   return post.originalPoster == placeholderSelf || post.reblogger == placeholderSelf;
//     // }).toList();

//     return Scaffold(
//       body: SafeArea( // Ensures no overlap with the status bar
//         child: Column(
//           children: [
//             // Profile Pane
//             ProfilePane(user: currentUser),  // Pass user to ProfilePane

//             // Expanded space for posts
//             Expanded(
//               child: ListView.builder(
//                 itemCount: currentUser.usersPosts.length,
//                 itemBuilder: (context, index) {
//                   return PostWidget(post: currentUser.usersPosts[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
      
//       // Floating action button for creating a new post
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to CreatePostScreen when pressed
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => CreatePostScreen()),
//           );
//         },
//         child: Icon(Icons.add), // Icon for the button
//         backgroundColor: Colors.blue, // Set button color
//       ),
//     );
//   }
// }

class OwnProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access currentUser from UserProvider
    User? currentUser = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      body: SafeArea( // Ensures no overlap with the status bar
        child: Column(
          children: [
            // Profile Pane
            if (currentUser != null) // Check if the user is available
              ProfilePane(user: currentUser),  // Pass user to ProfilePane

            // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: currentUser?.usersPosts.length ?? 0, // Make sure there are posts
                itemBuilder: (context, index) {
                  return PostWidget(post: currentUser!.usersPosts[index]);
                },
              ),
            ),
          ],
        ),
      ),

      // Floating action button for creating a new post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CreatePostScreen when pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add), // Icon for the button
        backgroundColor: Colors.blue, // Set button color
      ),
    );
  }
}