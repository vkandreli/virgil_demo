import 'package:flutter/material.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/add_to_pack.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/comment_screen.dart';
// class PostWidget extends StatefulWidget {
//   final Post post;
//   final Logger logger = Logger();
//   final User currentUser;
  
//   PostWidget({required this.post, required this.currentUser});

//   @override
//   _PostWidgetState createState() => _PostWidgetState();
// }

// class _PostWidgetState extends State<PostWidget> {
//   // Track whether the post is liked or not
//   bool isLiked = false;
//   bool isShared = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Original Poster and Reblogger (conditionally show reblogger)
//             Row(
//               children: [

//                 // Conditionally display the reblogger's information
//                 if (widget.post.reblogger != null) ...[
//                   SizedBox(width: 4),

//                   CircleAvatar(child: Icon(Icons.person)),
//                   SizedBox(width: 4),
//                   Text("${widget.post.reblogger?.username ?? ""}", style: TextStyle(fontWeight: FontWeight.bold)),
//                   SizedBox(width: 4),                  
//                   Icon(Icons.replay), // Reblog icon
//                 ],

//                 CircleAvatar(child: Icon(Icons.person)),
//                 SizedBox(width: 4),
//                 Text(widget.post.originalPoster.username, style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Conditionally show Image if it exists
//             if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) 
//               Image.network(
//                 widget.post.imageUrl!,
//                 width: double.infinity, // Make image take full width
//                 height: MediaQuery.of(context).size.height * 0.4, // Make image height responsive to screen size
//                 fit: BoxFit.contain, // Ensure the entire image is contained without clipping
//               ),

//             // Conditionally show Quote if it exists
//             if (widget.post.quote != null && widget.post.quote!.isNotEmpty) 
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Text(
//                   "\"${widget.post.quote}\"",
//                   style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
//                 ),
//               ),

//             SizedBox(height: 12),

//             // If the post has a book, show the book title and make it clickable
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to the BookDetailScreen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => BookDetailScreen(book: widget.post.book!)),
//                   );
//                 },
//                 child: Text(
//                   widget.post.book.title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
//                 ),
//               ),

//             SizedBox(height: 12),

//             // Buttons for actions and their counts
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.favorite,
//                         color: isLiked ? Colors.red : Colors.black, // Toggle color between red and black
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           // Toggle like state
//                           if (isLiked) {
//                             widget.post.removeLike();
//                           } else {
//                             widget.post.like();
//                           }
//                           isLiked = !isLiked;  // Toggle the like state
//                         });
//                         logger.i("Liked/unliked post by ${widget.post.originalPoster.username}");
//                       },
//                     ),
//                     // Display like count
//                     Text(widget.post.likes.toString(), style: TextStyle(fontSize: 14)),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                    IconButton(
//                     icon: Icon(
//                       Icons.repeat,
//                       color: isShared ? Colors.green : Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         widget.post.reblog(widget.currentUser); // Reblog the post
//                         isShared = true;  // Update the shared state
//                       });
//                       logger.i("Reblogged post by ${widget.post.originalPoster.username}. Users posts: ${widget.currentUser.usersPosts.length}");
//                     },
//                   ),
//                                       // Display reblog count
//                     Text(widget.post.reblogs.toString(), style: TextStyle(fontSize: 14)),
//                   ],
//                 ),

// Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.comment),
//                       onPressed: () {
//                         // Navigate to the CommentScreen
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CommentScreen(post: widget.post, currentUser: widget.currentUser),
//                           ),
//                         );
//                       },
//                     ),
//                     // Display comment count
//                     Text(widget.post.comments.length.toString(), style: TextStyle(fontSize: 14)),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.add_circle_outline),
//                       onPressed: () {
//                         logger.i("Added post by ${widget.post.originalPoster.username} to collection");
//                       },
//                     ),
//                     // Optionally display any add-to-collection count (if relevant)
//                     //Text('0', style: TextStyle(fontSize: 14)), // Placeholder for add-to-collection count
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.save_alt),
//                       onPressed: () {
//                         logger.i("Saved post by ${widget.post.originalPoster.username}");
//                       },
//                     ),
//                     // Optionally display any save count (if relevant)
//                     //Text('0', style: TextStyle(fontSize: 14)), // Placeholder for save count
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  
// }

class PostWidget extends StatefulWidget {
  final Post post;
  final User currentUser;
  
  PostWidget({required this.post, required this.currentUser});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;
  bool isShared = false;
  late bool isInReadingList;
  TextEditingController _commentController = TextEditingController(); // Controller for comment input
  final Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    // Check if the book is already in the reading list
    isInReadingList = widget.currentUser.readingList.contains(widget.post.book);
  }

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
            // Original Poster and Reblogger (conditionally show reblogger)
            Row(
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 4),
                Text(widget.post.originalPoster.username, style: TextStyle(fontWeight: FontWeight.bold)),
                // Conditionally display the reblogger's information
                if (widget.post.reblogger != null) ...[
                  SizedBox(width: 16),
                  Icon(Icons.replay), // Reblog icon
                  CircleAvatar(child: Icon(Icons.person)),
                  SizedBox(width: 4),
                  Text(widget.post.reblogger?.username ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                ],
              ],
            ),
            SizedBox(height: 12),

            // Conditionally show Image if it exists
            if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) 
              Image.network(
                widget.post.imageUrl!,
                width: double.infinity,
                height: 250, // Maximum height without clipping
                fit: BoxFit.contain, // Ensure the image scales correctly without clipping
              ),
 
            // Conditionally show Quote if it exists
            if (widget.post.quote != null && widget.post.quote!.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "\"${widget.post.quote}\"",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),

            SizedBox(height: 12),

            // If the post has a book, show the book title and make it clickable
            GestureDetector(
              onTap: () {
                // Navigate to the BookDetailScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookDetailScreen(book: widget.post.book, currentUser: widget.currentUser,)),
                );
              },
              child: Text(
                widget.post.book.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
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
                        color: isLiked ? Colors.red : Colors.black, // Toggle color between red and black
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle like state
                          if (isLiked) {
                            widget.post.removeLike();
                          } else {
                            widget.post.like();
                          }
                          isLiked = !isLiked;  // Toggle the like state
                        });
                        logger.i("Liked/unliked post by ${widget.post.originalPoster.username}");
                      },
                    ),
                    // Display like count
                    Text(widget.post.likes.toString(), style: TextStyle(fontSize: 14)),
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
                        widget.post.reblog(widget.currentUser);
                        setState(() {
                          isShared = true;
                        });
                        logger.i("Reblogged post by ${widget.post.originalPoster.username}");
                      },
                    ),
                    // Display reblog count
                    Text(widget.post.reblogs.toString(), style: TextStyle(fontSize: 14)),
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
                    Text(widget.post.comments.length.toString(), style: TextStyle(fontSize: 14)),
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
                          MaterialPageRoute(builder: (context) => AddToPack(currentUser: widget.currentUser,)),//book: widget.post.book, 
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
                        color: isInReadingList ? Colors.green : Colors.black, // Change color based on readingList
                      ),
                      onPressed: () {
                        setState(() {
                          if (isInReadingList) {
                            widget.currentUser.readingList.remove(widget.post.book);
                            logger.i("Removed book from reading list: ${widget.post.book.title}");
                          } else {
                            widget.currentUser.readingList.add(widget.post.book);
                            logger.i("Saved book to reading list: ${widget.post.book.title}");
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
                      widget.post.comments.add(_commentController.text); // Add the new comment
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

  //   void _showCommentBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return GestureDetector(
  //         onTap: () {
  //           // Close the bottom sheet when tapping outside of it
  //           Navigator.of(context).pop();
  //         },
  //         child: Container(
  //           color: Colors.white,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Comment section
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Text("Comments", style: TextStyle(fontSize: 24)),
  //               ),
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: widget.post.comments.length,
  //                 itemBuilder: (context, index) {
  //                   return ListTile(
  //                     title: Text(widget.post.comments[index]),
  //                   );
  //                 },
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: TextField(
  //                   controller: _commentController,
  //                   decoration: InputDecoration(
  //                     labelText: "Add a comment",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   onSubmitted: (value) {
  //                     setState(() {
  //                       widget.post.comments.add(value);
  //                       _commentController.clear();
  //                     });
  //                   },
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     widget.post.comments.add(_commentController.text);
  //                     _commentController.clear();
  //                   });
  //                 },
  //                 child: Text("Post Comment"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

