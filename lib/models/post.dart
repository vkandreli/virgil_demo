import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart'; 

class Post {
  final User originalPoster;
  User? reblogger; 
  String? imageUrl;
  String? quote;
  Book? book;
  

  // Constructor
  Post({
    required this.originalPoster,
    this.reblogger,  
    this.imageUrl,
    this.quote,
    this.book
  });

  @override
  String toString() {
    return 'Post(originalPoster: ${originalPoster.username}, reblogger: ${reblogger?.username}, imageUrl: $imageUrl, quote: $quote)';
  }
}
