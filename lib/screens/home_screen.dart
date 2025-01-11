import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/new_post.dart';
import 'package:virgil_demo/screens/profile_search_scene.dart';
import 'package:virgil_demo/services/post_service.dart';
import 'package:virgil_demo/services/user_service.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';
import 'own_profile_screen.dart';
import 'others_profile_screen.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/post.dart';
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
  bool isLoading = true; // To track loading state

  // Add an instance of UserService
  //final UserService userService = UserService(); 

  @override
  void initState() {
    super.initState();
    _initializeDatabase();  // Initialize the database first
  }
  Future<void> _initializeDatabase() async {
    try {

      // Now that the database is initialized, load posts
      await _loadPosts();  
    } catch (e) {
      logger.e("Error initializing database: $e");
      setState(() {
        isLoading = false;  // Set loading to false if there is an error initializing
      });
    }
  }

Future<void> _loadPosts() async {
  try {
    PostService postService = PostService();
    logger.d("PostService instance created.");
    
    await postService.init();
    logger.d("Database initialization started.");
    logger.d("Database initialization complete.");

    List<Post> fetchedPosts = await postService.getAllPosts();
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



  // // Fetch posts from the database
  // Future<void> _loadPosts() async {
  //   try {
  //     List<Post> fetchedPosts = await SQLService.getAllPosts();
  //     setState(() {
  //       posts = fetchedPosts;
  //       isLoading = false; // Set loading to false once the posts are fetched
  //     });
  //   } catch (e) {
  //     logger.e("Error loading posts: $e");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    logger.i("HomeScreen built for user: ${widget.currentUser.username}");

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
                  children: [
                    if (widget.currentUser.followedUsers.isNotEmpty)
                      ...widget.currentUser.followedUsers.map((user) {
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
                                user.profileImage ??
                                    'https://via.placeholder.com/150?text=Profile+Image',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    if (widget.currentUser.followedUsers.isEmpty)
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          'Try following some users',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                  ],
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
                  style: TextStyle(fontSize: 14, color: AppColors.darkBrown),
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            // Loading Indicator if posts are still being fetched
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
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
          // Navigate to the screen to create a new post
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(currentUser: widget.currentUser),
            ),
          );
        },
        backgroundColor: AppColors.darkBrown,
        tooltip: 'Create New Post',
        child: Icon(Icons.add, color: AppColors.lightBrown),
      ),
      bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: widget.currentUser),
    );
  }
}
