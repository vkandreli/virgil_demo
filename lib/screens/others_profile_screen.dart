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
    // Sample posts
    // List<User> followedUsers = [
    //   User(username: "user123", profileImage: "https://via.placeholder.com/150", password: "000", email: "user123@mail.com"),
    //   User(username: "user456", profileImage: "https://via.placeholder.com/150", password: "000", email: "user456@mail.com"),
    //   User(username: "user789", profileImage: "https://via.placeholder.com/150", password: "000", email: "user789@mail.com"),
    // ];

    // // Sample list of posts
    // List<Post> posts = [
    //   Post(
    //     originalPoster: followedUsers[0],
    //     reblogger:  user,
    //     imageUrl: "https://via.placeholder.com/150",
    //     quote: "This is a quote",
    //   ),
    //   Post(
    //     originalPoster: followedUsers[2],
    //     reblogger:  followedUsers[1],
    //     imageUrl: "https://via.placeholder.com/150",
    //     quote: "This is another quote",
    //   ),
    //   Post(
    //     originalPoster: followedUsers[1],
    //     reblogger:  followedUsers[2],
    //     imageUrl: "https://via.placeholder.com/150",
    //     quote: "This is a quote",
    //   ),
    //   Post(
    //     originalPoster: followedUsers[0],
    //     reblogger:  followedUsers[1],
    //     imageUrl: "https://via.placeholder.com/150",
    //     quote: "This is another quote",
    //   ),
    // ];
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