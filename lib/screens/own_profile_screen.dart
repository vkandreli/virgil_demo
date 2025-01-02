import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/widgets/profile_pane.dart';

class OwnProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample user data for the logged-in user (self)
    User self = User(
      username: "user123", 
      profileImage: "https://via.placeholder.com/150", 
      password: "000", 
      email: "user123@mail.com"
    );

    // Sample list of users being followed
    List<User> followedUsers = [
      User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com"),
      User(username: "user456", profileImage: "https://via.placeholder.com/150", password: "000", email: "user456@mail.com"),
      User(username: "user789", profileImage: "https://via.placeholder.com/150", password: "000", email: "user789@mail.com"),
    ];

    // Sample list of posts
    List<Post> allPosts = [
      Post(
        originalPoster: followedUsers[0],
        reblogger: self,  // Self is the reblogger
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is a quote",
      ),
      Post(
        originalPoster: self,
        reblogger: null, 
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is another quote",
      ),
      Post(
        originalPoster: followedUsers[1],
        reblogger: self,  // Self is the reblogger
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is a quote",
      ),
      Post(
        originalPoster: self,
        reblogger: null, 
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is another quote",
      ),
    ];

    // Filter the posts to only show those where self is the original poster or reblogger
    List<Post> userPosts = allPosts.where((post) {
      return post.originalPoster == self || post.reblogger == self;
    }).toList();

    return Scaffold(
      body: SafeArea( // Ensures no overlap with the status bar
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(user: self),  // Pass user to ProfilePane

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


