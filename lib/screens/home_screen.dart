import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/main.dart';
////import 'package:virgil_demo/models/user.dart';   // Import User model
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/new_post.dart';  // Import Post model
import 'package:virgil_demo/screens/profile_search_scene.dart';
import 'own_profile_screen.dart';  // Profile screen when self is clicked
import 'others_profile_screen.dart';  // Profile screen when a user is clicked
import 'package:virgil_demo/assets/placeholders.dart';
// //import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;

  HomeScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger logger = Logger();
  late List<Post> posts = []; // This will hold the list of posts
    late List<User> users = [],followedUsers = []; // This will hold the list of posts

  bool isLoading = true; // To track loading state

Future<void> _loadPosts() async {
  try { 
        List<Post> fetchedPosts = await SQLService().getAllPosts();
    if (fetchedPosts == null) {
      logger.e("Error: Fetched posts is null.");
    } else if (fetchedPosts.isEmpty) {
      logger.w("Warning: No posts found.");
    } else {
      logger.d("Fetched ${fetchedPosts.length} posts from the database.");
    }

    setState(() {
      posts = fetchedPosts;
      isLoading = false;
    });
  } catch (e, stackTrace) {
    logger.e("Error loading posts: $e");
    logger.e("Stack Trace: $stackTrace");
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _loadUsers() async {
  try { 
        List<User> fetchedUsers = await SQLService().getAllUsers();
    if (fetchedUsers == null) {
      logger.e("Error: Fetched users is null.");
    } else if (fetchedUsers.isEmpty) {
      logger.w("Warning: No users found.");
    } else {
      logger.d("Fetched ${fetchedUsers.length} users from the database.");
    }

    setState(() {
      users = fetchedUsers;
    });

  } catch (e, stackTrace) {
    logger.e("Error loading users: $e");
    logger.e("Stack Trace: $stackTrace");
  }
}

@override
void initState() {
  super.initState();
  _initializeData(); // Initialize all data at once
}

Future<void> _initializeData() async {
  setState(() {
    isLoading = true; // Set loading state to true
  });

  try {
    // Wait for all loading tasks to complete
    await Future.wait([
      _loadPosts(),
      _loadUsers(),
      _loadFollowedUsers(),
    ]);
  } catch (e, stackTrace) {
    logger.e("Error during initialization: $e");
    logger.e("Stack Trace: $stackTrace");
  } finally {
    setState(() {
      isLoading = false; // Set loading state to false after all tasks
    });
  }
}

Future<void> _loadFollowedUsers() async {
  try {
    followedUsers = await SQLService().getFollowersForUser(widget.currentUser.id);
    logger.d("Loaded ${followedUsers.length} followed users.");
  } catch (e, stackTrace) {
    logger.e("Error loading followed users: $e");
    logger.e("Stack Trace: $stackTrace");
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : Column(
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
                                builder: (context) => OtherProfileScreen(
                                  user: user,
                                  currentUser: widget.currentUser,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                user.profileImage ?? User.defaultProfileImage,
                              ),
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileSearchScreen(
                            currentUser: widget.currentUser,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(500, 40),
                      backgroundColor: AppColors.lightBrown,
                    ),
                    child: Text(
                      "Search for a profile...",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkBrown,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // Vertical list of posts
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostWidget(
                        post: posts[index],
                        currentUser: widget.currentUser,
                        isInOwnProfile: false,
                      );
                    },
                  ),
                ),
              ],
            ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostScreen(currentUser: widget.currentUser),
          ),
        );
      },
      backgroundColor: AppColors.darkBrown,
      tooltip: 'Create New Post',
      child: Icon(
        Icons.add,
        color: AppColors.lightBrown,
      ),
    ),
    bottomNavigationBar: CustomBottomNavBar(
      context: context,
      currentUser: widget.currentUser,
    ),
  );
}
}