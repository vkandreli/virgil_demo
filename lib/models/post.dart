//import 'package:virgil_demo/models/book.dart';
////import 'package:virgil_demo/models/user.dart';  

class Post {
  final User originalPoster;
  User? reblogger; 
  String? imageUrl;
  String? quote;
  final Book book;
  DateTime timePosted;
  int likes, reblogs;
  List<String> comments; 

  // Constructor
  Post({
    required this.originalPoster,
    required this.timePosted,
    this.reblogger,  
    this.imageUrl,
    this.quote,
    required this.book,
    this.likes = 0,           // Default value for likes
    this.reblogs = 0,         // Default value for reblogs
    this.comments = const [], // Default empty list for comments   
  });

void reblog(User user) {
  reblogs++; // Increment the reblog count
  
  // Create a new reblog post
  Post reblog = Post(
    originalPoster: this.originalPoster,
    reblogger: user,
    imageUrl: this.imageUrl, 
    quote: this.quote,
    book: this.book,
    timePosted: DateTime.now(),
    likes: 0,  // Start the reblog post with no likes
    reblogs: 0, // No reblogs initially
    comments: [],  // Empty comment list
  );
  
  // Add the reblogged post to the user's posts
  user.usersPosts.add(reblog);
}



  void addComment(String comment) {
    comments.add(comment);
  }

  void like() {
    likes++;  
  }

  void removeLike() {
    likes--;  
  }

  @override
  String toString() {
    return 'Post(originalPoster: ${originalPoster.username}, reblogger: ${reblogger?.username}, imageUrl: $imageUrl, quote: $quote)';
  }
}
