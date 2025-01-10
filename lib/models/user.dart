import 'package:virgil_demo/models/achievement.dart';
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
  bool isPacksPrivate;
  bool isReviewsPrivate;
  bool isReadListPrivate;

  List<User> followedUsers;
  List<Post> usersPosts;
  List<Review> usersReviews;
  List<Pack> usersPacks;
  List<Book> readingList;
  List<Book> completedList;
  List<Book> currentList;
  List<Map<DateTime, int>> pagesPerDay;
  List<Achievement> badges;
  List<Goal> goals;
  
  static const String defaultProfileImage = "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api";//"https://via.placeholder.com/150?text=Profile+Image";

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
    List<Goal> goals = const [],
    List<Map<DateTime, int>> pagesPerDay = const [],
    List<Achievement> badges= const [],
    this.status = 'A small status, favourite quote etc', // Default status
    this.isPacksPrivate = true,   // Default privacy state
    this.isReviewsPrivate = false,  // Default privacy state
    this.isReadListPrivate = true,  // Default privacy state
  }) : followedUsers = followedUsers.isEmpty ? [] : followedUsers,
        usersPosts = usersPosts.isEmpty ? [] : usersPosts,
       usersReviews = usersReviews.isEmpty ? [] : usersReviews,
        usersPacks = usersPacks.isEmpty ? [] : usersPacks,
        completedList = completedList.isEmpty ? [] : completedList, // Ensures empty list if null
        currentList = currentList.isEmpty ? [] : currentList,
        readingList = readingList.isEmpty ? [] : readingList,
       pagesPerDay= pagesPerDay.isEmpty ? [] :  pagesPerDay,
        badges= badges.isEmpty ? [] : badges,
       goals = goals.isEmpty ? [] : goals; 

  User.empty()
      : username = '',
        email = '',
        profileImage = '',
        status = '',
        isPacksPrivate = false,
        isReviewsPrivate = false,
        isReadListPrivate = false,
        password = "",
        followedUsers =  [],
        usersPosts = [],
       usersReviews = [],
        usersPacks = [],
        completedList = [],
        currentList = [],
        readingList = [],
       pagesPerDay= [],
        badges= [],
       goals = [];
        
// Convert User object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'profileImage': profileImage,
      'status': status,
    };
  } 

  // Convert Map to User object
  factory User.fromMap(Map<String, dynamic> map, List<Book> readingList, List<Book> completedList, List<Book> currentList) {
    return User(
      username: map['username'],
      password: map['password'],
      email: map['email'],
      profileImage: map['profileImage'],
      status: map['status'],
      readingList: readingList,
      completedList: completedList,
      currentList: currentList,
    );
  }



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

    void addTOCurrent(Book book){

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


