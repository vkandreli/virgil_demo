
import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
//import 'package:virgil_demo/models/post.dart';  // Import Post class
////import 'package:virgil_demo/models/user.dart';  // Import User class

class CommentScreen extends StatefulWidget {
  final Post post;  // The post whose comments we are viewing/adding
  final User currentUser; // Current user adding comments

  CommentScreen({required this.post, required this.currentUser});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();

  late List<Comment> postComments = [];


   Future<void> addComment(String Text, int? postId) async {
    final newComment = Comment(
    text: Text,
    post_id: postId, 
  );
  await SQLService().addCommentToPost(newComment);
  }


   Future<void> getComments() async {
  postComments = await SQLService().getCommentsForPost(widget.post.id);
   }

  @override

 @override
  void initState() {
    super.initState();
    getComments();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display existing comments
            Expanded(
              child: ListView.builder(
                itemCount: postComments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(postComments[index].text),
                    leading: CircleAvatar(child: Icon(Icons.person)),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            // Add new comment input
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: "Add a comment",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  setState(() {
                    postComments.add(Comment (text: _commentController.text, post_id: widget.post.id)); // Add new comment
                    addComment(_commentController.text, widget.post.id);
                    _commentController.clear(); // Clear the text field
                  });
                  Navigator.pop(context); // Go back to the post page
                }
              },
              child: Text("Submit Comment"),
            ),
          ],
        ),
      ),
    );
  }
}
