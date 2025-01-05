import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/pack.dart';
import 'book.dart';

class User {
  final String username;
  final String password;
  final String email;
  String? profileImage;
  String? status;
  List<User> followedUsers;
  List<Post> usersPosts;
  List<Review> usersReviews;
  List<Pack> usersPacks;
  List<Book> readingList;
  List<Book> completedList;
  List<Book> currentList;

  bool isPacksPrivate;
  bool isReviewsPrivate;
  bool isReadListPrivate;

  static const String defaultProfileImage = "https://via.placeholder.com/150?text=Profile+Image";

  // Constructor
  User({
    required this.username,
    required this.password,
    required this.email,
    this.profileImage = defaultProfileImage,
    List<User> followedUsers = const [], // Default empty list
    List<Post> usersPosts = const [],    // Default empty list
    List<Review> usersReviews = const [],  // Default empty list
    List<Pack> usersPacks = const [],    // Default empty list
    List<Book> completedList = const [], // Default empty list
    List<Book> currentList = const [],   // Default empty list
    List<Book> readingList = const [],   // Default empty list
    this.status = 'A small status, favourite quote etc', // Default status
    this.isPacksPrivate = true,   // Default privacy state
    this.isReviewsPrivate = true,  // Default privacy state
    this.isReadListPrivate = true,  // Default privacy state
  }) : followedUsers = followedUsers.isEmpty ? [] : followedUsers,
        usersPosts = usersPosts.isEmpty ? [] : usersPosts,
        usersReviews = usersReviews.isEmpty ? [] : usersReviews,
        usersPacks = usersPacks.isEmpty ? [] : usersPacks,
        completedList = completedList.isEmpty ? [] : completedList, // Ensures empty list if null
        currentList = currentList.isEmpty ? [] : currentList,
        readingList = readingList.isEmpty ? [] : readingList;


  // Method to toggle the privacy status of the current list
  void togglePacksPrivacy() {
    isPacksPrivate = !isPacksPrivate;
  }

  // Method to toggle the privacy status of the completed list
  void toggleReviewsPrivacy() {
    isReviewsPrivate = !isReviewsPrivate;
  }

  // Method to toggle the privacy status of the reading list
  void toggleReadlistPrivacy() {
    isReadListPrivate = !isReadListPrivate;
  }

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

    void addToCurrent(Book book){
        currentList.add(book);
    }


    void addToCompleted(Book book) {
      completedList.add(book);
      readingList.remove(book);
      book.dateCompleted = DateTime.now();
    }

    void changeStatus(String string) {
      status = string;
    }
}

