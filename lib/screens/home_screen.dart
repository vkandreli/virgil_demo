import 'package:flutter/material.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/screens/new_post.dart';  // Import Post model
import 'own_profile_screen.dart';  // Profile screen when self is clicked
import 'others_profile_screen.dart';  // Profile screen when a user is clicked

import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  final User currentUser = User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com");
  @override
  Widget build(BuildContext context) {
    // Sample list of followed users
    List<User> followedUsers = [
      User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com"),
      User(username: "user456", profileImage: "https://via.placeholder.com/150", password: "000", email: "user456@mail.com"),
      User(username: "user789", profileImage: "https://via.placeholder.com/150", password: "000", email: "user789@mail.com"),
    ];

    // Sample list of posts
    List<Post> posts = [
      Post(
        originalPoster: followedUsers[0],
        reblogger:  followedUsers[2],
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is a quote",
      ),
      Post(
        originalPoster: followedUsers[2],
        reblogger:  followedUsers[1],
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is another quote",
      ),
      Post(
        originalPoster: followedUsers[1],
        reblogger:  followedUsers[2],
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is a quote",
      ),
      Post(
        originalPoster: followedUsers[0],
        reblogger:  followedUsers[1],
        imageUrl: "https://via.placeholder.com/150",
        quote: "This is another quote",
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal list of followed users
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: followedUsers.map((user) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the selected user's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfileScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.profileImage),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Vertical list of posts
                        // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: posts[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to create a new post
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create New Post',
      ),
    );
  }
}
