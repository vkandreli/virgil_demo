import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/post.dart';
import 'package:logger/logger.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/screens/add_to_pack.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/comment_screen.dart';
import 'package:virgil_demo/screens/others_profile_screen.dart';
import 'package:virgil_demo/screens/own_profile_screen.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final User currentUser;
  final bool isInOwnProfile;
  PostWidget({required this.post, required this.currentUser, required this.isInOwnProfile});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;
  bool isShared = false;
  late bool isInReadingList;
  TextEditingController _commentController = TextEditingController(); // Controller for comment input
  final Logger logger = Logger();

  late Book postsBook= Book.empty();
  late User originalPoster, reblogger = User.empty();

  Future<void> _getResources() async {
  postsBook = await SQLService().getBooksForPost(widget.post.id);
  originalPoster = await SQLService().getPosterForPost(widget.post.id); 
  reblogger = await SQLService().getRebloggerForPost(widget.post.id); 

 }

  Future<void> _reblog(Post post, int? userId) async {
    await  SQLService().ReblogPost(post, userId);
  }


  @override
  void initState() {
    super.initState();
    _getResources();
        isInReadingList = widget.currentUser.readingList.contains(postsBook);

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, //AppColors.darkBrown,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Poster and Reblogger (conditionally show reblogger)
            Row(
              children: [
                IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                      originalPoster.profileImage ??
                          User.defaultProfileImage,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherProfileScreen(
                          user: originalPoster,
                          currentUser: widget.currentUser,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 4),
                Text(originalPoster.username,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // Conditionally display the reblogger's information
                if (reblogger != User.empty()) ...[
                  SizedBox(width: 4),
                  Icon(Icons.replay), // Reblog icon
                  IconButton(
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(
                        reblogger.profileImage ??
                            User.defaultProfileImage,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherProfileScreen(
                            user: reblogger ?? widget.currentUser,
                            currentUser: widget.currentUser,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 4),
                  Text(reblogger.username ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                ],
              ],
            ),
            SizedBox(height: 12),

            // Conditionally show Image if it exists
            if (widget.post.imageUrl != null &&
                widget.post.imageUrl!.isNotEmpty)
              Image.network(
                widget.post.imageUrl!,
                width: double.infinity,
                height: 250, // Maximum height without clipping
                fit: BoxFit
                    .contain, // Ensure the image scales correctly without clipping
              ),

            // Conditionally show Quote if it exists
            if (widget.post.quote != null && widget.post.quote!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "\"${widget.post.quote}\"",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontSize: 22),
                ),
              ),

            SizedBox(height: 12),

            // If the post has a book, show the book title and make it clickable
            GestureDetector(
              onTap: () {
                // Navigate to the BookDetailScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookDetailScreen(
                            book: postsBook,
                            currentUser: widget.currentUser,
                          )),
                );
              },
              child: Text(
                postsBook.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown),
              ),
            ),

            SizedBox(height: 12),

            // Buttons for actions and their counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked
                            ? Colors.red
                            : Colors
                                .black, // Toggle color between red and black
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle like state
                          if (isLiked) {
                            widget.post.likes--;
                          } else {
                            widget.post.likes++;
                          }
                          isLiked = !isLiked; // Toggle the like state
                        });
                        logger.i(
                            "Liked/unliked post by ${originalPoster.username}");
                      },
                    ),
                    // Display like count
                    Text(widget.post.likes.toString(),
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: isShared ? Colors.green : Colors.black,
                      ),
                      onPressed: () {
                      _reblog(widget.post, widget.currentUser.id);
                        setState(() {
                          isShared = true;
                          if (widget.isInOwnProfile){
                            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OwnProfileScreen(
                            currentUser: widget.currentUser,
                          )),
                );
                          }
                        });
                        logger.i(
                            "Reblogged post by ${originalPoster.username}");
                      },
                    ),
                    // Display reblog count
                    Text(widget.post.reblogs.toString(),
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        // Show comments in a Bottom Sheet
                        _showCommentBottomSheet(context);
                      },
                    ),
                    // Display comment count
                    Text(widget.post.comments.length.toString(),
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        logger.i("Adding to pack");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddToPack(
                                    currentUser: widget.currentUser,
                                    selectedBook: postsBook,
                                  )), //book: postsBook,
                        );
                      },
                    ),
                    Text("", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.save_alt,
                        color: isInReadingList
                            ? Colors.green
                            : Colors.black, // Change color based on readingList
                      ),
                      onPressed: () {
                        setState(() {
                          if (isInReadingList) {
                            widget.currentUser.readingList
                                .remove(postsBook);
                            logger.i(
                                "Removed book from reading list: ${postsBook.title}");
                          } else {
                            widget.currentUser.readingList
                                .add(postsBook);
                            logger.i(
                                "Saved book to reading list: ${postsBook.title}");
                          }
                          // Update the state to reflect the change
                          isInReadingList = !isInReadingList;
                        });
                      },
                    ),
                    Text("", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show comment bottom sheet
  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display existing comments
              Expanded(
                child: ListView.builder(
                  itemCount: widget.post.comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget.post.comments[index]),
                      leading: CircleAvatar(child: Icon(Icons.person)),
                    );
                  },
                ),
              ),
              SizedBox(height: 12),
              // TextField for new comment
              TextField(
                  textInputAction: TextInputAction.done, 
  onSubmitted: (value) {
    FocusScope.of(context).unfocus();
  },
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: "Add a comment",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      widget.post.comments
                          .add(_commentController.text); // Add the new comment
                      _commentController.clear(); // Clear the text field
                    });
                    Navigator.pop(context); // Close the bottom sheet
                  }
                },
                child: Text("Submit Comment"),
              ),
            ],
          ),
        );
      },
    );
  }
}