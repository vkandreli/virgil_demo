import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/post.dart';

class User {
  final String username;
  final String password;
  final String email;
  String? profileImage;
  List<User>? followedUsers;
  List<Post>? usersPosts;
  List<Review>? usersReviews;
  
  static const String defaultProfileImage = "https://via.placeholder.com/150?text=Profile+Image";

  // Constructor
  User({
    required this.username,
    required this.password,
    required this.email,
    this.profileImage = defaultProfileImage, // Default profile image if not provided
    this.followedUsers,
    this.usersPosts,
    this.usersReviews,
  }) {
    followedUsers ??= []; // Initialize to empty list if not provided
    usersPosts ??= []; // Initialize to empty list if not provided
    usersReviews ??= []; // Initialize to empty list if not provided
  }
}


