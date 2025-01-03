import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/pack.dart';
import 'book.dart';

class User {
  final String username;
  final String password;
  final String email;
  String profileImage;
  List<User> followedUsers;
  List<Post> usersPosts;
  List<Review> usersReviews;
  List<Pack> usersPacks;
  List<Book> readingList;
  List<Book> completedList;

  static const String defaultProfileImage = "https://via.placeholder.com/150?text=Profile+Image";

  // Constructor
  User({
    required this.username,
    required this.password,
    required this.email,
    this.profileImage = defaultProfileImage, // Default profile image if not provided
    this.followedUsers = const [],
    this.usersPosts = const [],
    this.usersReviews = const [],
    this.usersPacks = const [],
    this.completedList = const [],
    this.readingList = const [],
  }) ;


    void follow(User user) {
    if (!followedUsers.contains(user)) {
      followedUsers.add(user);
    }
  }

    void unfollow(User user) {
      followedUsers.remove(user);
    }

    void makePost(Post post) {
      usersPosts.add(post);
    }

    void deletePost(Post post) {
      usersPosts.remove(post);
    }

    void postReview(Review review) {
      usersReviews.add(review);
    }

    void deleteReview(Review review) {
      usersReviews.remove(review);
    }

    void postPack(Pack pack) {
      usersPacks.add(pack);
    }

    void deletePack(Pack pack) {
      usersPacks.remove(pack);
    }

    void addBook(Book book) {
      readingList.add(book);
      book.dateAdded = DateTime.now();
    }

    void removeBook(Book book) {
      readingList.remove(book);
      book.dateAdded = null;
    }

    void addToCompleted(Book book) {
      completedList.add(book);
      readingList.remove(book);
      book.dateCompleted = DateTime.now();
    }

}


