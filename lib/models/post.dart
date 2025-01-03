import 'package:virgil_demo/models/user.dart'; 

class Post {
  final User originalPoster;
  User? reblogger; 
  String? imageUrl;
  String? quote;

  // Constructor
  Post({
    required this.originalPoster,
    this.reblogger,  
    this.imageUrl,
    this.quote,
  });

  @override
  String toString() {
    return 'Post(originalPoster: ${originalPoster.username}, reblogger: ${reblogger?.username}, imageUrl: $imageUrl, quote: $quote)';
  }
}
