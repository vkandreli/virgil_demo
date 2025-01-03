import 'package:flutter/material.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/screens/new_post.dart';  // Import Post model
import 'own_profile_screen.dart';  // Profile screen when self is clicked
import 'others_profile_screen.dart';  // Profile screen when a user is clicked
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
// import 'package:virgil_demo/models/userProvider.dart';
// import 'package:provider/provider.dart'; 

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from the UserProvider
    User? currentUser = placeholderSelf; //.of<UserProvider>(context).currentUser;

    return Scaffold(
      body: 
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal list of followed users
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: placeholderUsers.map((user) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the selected user's profile, passing the selected user
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OtherProfileScreen(user: user), // Pass the selected user here
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            user.profileImage ?? 'https://via.placeholder.com/150?text=Profile+Image',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Search Bar with circular profile picture
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Search bar
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for a profile...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Circular profile image
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => OwnProfileScreen(),  // Navigate to OwnProfileScreen when the current user's profile is clicked
                    //     ),
                    //   );
                    // },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        currentUser?.profileImage ??
                            'https://via.placeholder.com/150?text=Profile+Image',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Vertical list of posts
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

      // Floating action button to create a new post
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
