import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Poster and Reblogger
            Row(
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 8),
                Text(post.originalPoster, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.replay), // Reblog icon
                SizedBox(width: 8),
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 8),
                Text(post.reblogger, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),

            // Post Image
            Image.network(post.imageUrl), // Displays the post's image

            SizedBox(height: 12),

            // Buttons for actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.heart_broken),
                  onPressed: () {
                    // Implement like functionality
                    print("Liked post");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.repeat), // Reblog icon
                  onPressed: () {
                    // Implement reblog functionality
                    print("Reblogged post");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Implement comment functionality
                    print("Commented");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: () {
                    // Implement save functionality
                    print("Saved post");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // Implement add functionality
                    print("Added book");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
