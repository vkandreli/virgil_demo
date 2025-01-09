import 'package:flutter/material.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/new_post.dart';  // Import Post model
import 'package:virgil_demo/screens/profile_search_scene.dart';
import 'own_profile_screen.dart';  // Profile screen when self is clicked
import 'others_profile_screen.dart';  // Profile screen when a user is clicked
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  final User currentUser = placeholderSelf;
  @override
  Widget build(BuildContext context) {
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
                  children: placeholderUsers.map((user) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the selected user's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfileScreen(user: user, currentUser: currentUser,),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.profileImage ?? 'https://via.placeholder.com/150?text=Profile+Image',)
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
              //  child: TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Search for a profile...',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     prefixIcon: Icon(Icons.search),
              //   ),
              // ),
              child: Expanded(
              child: ElevatedButton(
                    onPressed: () {                                         
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileSearchScreen(currentUser: currentUser,),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(500, 40), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(500,40),
                      backgroundColor: AppColors.lightBrown,
                    ),
                    child: Text(
                      "Search for a profile...",
                      style: TextStyle(fontSize: 14, color: AppColors.darkBrown,),
                      textAlign: TextAlign.left,
                    ),
                  ),
              ),
            ),
              
         
 
            // Vertical list of posts
                        // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: placeholderPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: placeholderPosts[index], currentUser: currentUser,);
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
            MaterialPageRoute(builder: (context) => CreatePostScreen(currentUser: currentUser,)),
          );
        },
        backgroundColor: AppColors.darkBrown,
        tooltip: 'Create New Post',
        child: Icon(Icons.add, color: AppColors.lightBrown,),
      ),

  bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: currentUser),    
  );
  }
}
