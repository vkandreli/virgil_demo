import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/widgets/profile_pane.dart';

class OwnProfileScreen extends StatelessWidget {
  final User currentUser;
  const OwnProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter the posts to only show those where self is the original poster or reblogger
    List<Post> userPosts = placeholderPosts.where((post) {
      return post.originalPoster == currentUser || post.reblogger == currentUser;
    }).toList();

    return Scaffold(
      body: SafeArea( // Ensures no overlap with the status bar
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(user: currentUser, currentUser: currentUser,),  // Pass user to ProfilePane

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


class UserProfileScreen extends StatefulWidget {
  final User user;  // The profile user to show
  final User currentUser;  // The logged-in user who will follow/unfollow

  UserProfileScreen({required this.user, required this.currentUser});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    // Check if the current user is following the profile user
    isFollowing = widget.currentUser.followedUsers.contains(widget.user);
  }

  void toggleFollow() {
    setState(() {
      if (isFollowing) {
        widget.currentUser.unfollow(widget.user);
      } else {
        widget.currentUser.follow(widget.user);
      }
      isFollowing = !isFollowing; // Toggle the follow state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.username)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile info and other widgets here

            // Follow button logic
            if (widget.user != widget.currentUser) ...[
              ElevatedButton(
                onPressed: toggleFollow,
                child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFAB886D),
                  foregroundColor: Colors.black,
                  minimumSize: Size(86, 31),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}