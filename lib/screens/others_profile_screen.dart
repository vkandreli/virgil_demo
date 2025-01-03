import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/models/user.dart';  // Import User model
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/userProvider.dart';
//import 'package:provider/provider.dart'; 
import 'package:virgil_demo/widgets/profile_pane.dart';

class OtherProfileScreen extends StatelessWidget {
  final User user; // The profile user you are viewing

  OtherProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    // Access the currentUser from the UserProvider
    User currentUser = placeholderSelf;//Provider.of<UserProvider>(context).currentUser!;

    return Scaffold(
      body: SafeArea( // Ensures no overlap with the status bar
        child: Column(
          children: [
            // Profile Pane
            ProfilePane(
              user: user,  // Pass the user (the profile being viewed)
              currentUser: currentUser,  // Pass the current user (the logged-in user)
            ),

            // Expanded space for posts
            Expanded(
              child: ListView.builder(
                itemCount: user.usersPosts.length,  // Assuming `user` has posts
                itemBuilder: (context, index) {
                  return PostWidget(post: user.usersPosts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
