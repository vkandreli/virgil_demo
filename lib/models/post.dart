import 'package:virgil_demo/models/user.dart'; 

class Post {
  final User originalPoster;
  User? reblogger; 
  final String imageUrl;
  final String quote;

  // Constructor
  Post({
    required this.originalPoster,
    this.reblogger,  
    required this.imageUrl,
    required this.quote,
  });
}
