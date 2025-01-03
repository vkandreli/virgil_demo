import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/assets/placeholders.dart';

class OtherProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com");

    return Scaffold(
      body: SafeArea( // Ensures no overlap with the status bar
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(),

            // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: placeholderPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: placeholderPosts[index]);
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

class ProfilePane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
      Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF493628),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 47.5,
                  backgroundColor: Color(0xFFD9D9D9),
                  child: CircleAvatar(                    
                    radius: 36,
                    child: Icon(Icons.person)
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'username',
                        style: TextStyle(
                          color: Color(0xFFE4E0E1),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'A small status, favourite quote etc',
                        style: TextStyle(
                          color: Color(0xFFE4E0E1),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Follow'),
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
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('500', 'Books'),
                _buildStatColumn('50', 'This year'),
                _buildStatColumn('12', 'Packs'),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFFE4E0E1),
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFE4E0E1),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text) {
    return Container(
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17.87,
          ),
        ),
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