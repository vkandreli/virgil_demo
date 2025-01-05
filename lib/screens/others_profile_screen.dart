import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/widgets/profile_pane.dart';


class OtherProfileScreen extends StatelessWidget {
  final User user, currentUser;
  const OtherProfileScreen({Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //User user = User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com");
    List<Post> userPosts = placeholderPosts.where((post) {
      return post.originalPoster == user || post.reblogger == user;
    }).toList();
    
    return Scaffold(
      body: SafeArea( // Ensures no overlap with the status bar
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(user: user, currentUser: currentUser,),

            // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: userPosts[index]);
                },
              ),
            ),
          ],
        ),
      ),
      
      // Floating action button for creating a new post
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to CreatePostScreen when pressed
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CreatePostScreen()),
      //     );
      //   },
      //   child: Icon(Icons.add), // Icon for the button
      //   backgroundColor: Colors.blue, // Set button color
      // ),
    );
  }
}

