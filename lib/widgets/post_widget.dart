import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:logger/logger.dart';  // Import the logger package

class PostWidget extends StatelessWidget {
  final Post post;
  final Logger logger = Logger();  // Create an instance of the Logger

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
                SizedBox(width: 4),
                Text(post.originalPoster, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.replay), // Reblog icon
                SizedBox(width: 16),
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 4),
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
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    // Log the like action instead of print
                    logger.i("Liked post by ${post.originalPoster}");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.repeat), // Reblog icon
                  onPressed: () {
                    // Log the reblog action
                    logger.i("Reblogged post by ${post.reblogger}");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Log the comment action
                    logger.i("Commented on post by ${post.originalPoster}");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: () {
                    // Log the save action
                    logger.i("Saved post by ${post.originalPoster}");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // Log the add action
                    logger.i("Added post by ${post.originalPoster} to collection");
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
