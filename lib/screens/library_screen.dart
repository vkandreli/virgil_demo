import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/camera_screen.dart';
import 'own_profile_screen.dart';
import 'home_screen.dart';
import 'recommendations_screen.dart';
import 'package:logger/logger.dart';
//import 'package:virgil_demo/models/book.dart';
import 'package:camera/camera.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/screens/chatbot_screen.dart'; 
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class LibraryScreen extends StatefulWidget {
final User currentUser;
  LibraryScreen({Key? key, required this.currentUser}) : super(key: key); 
  final TextEditingController _searchController = TextEditingController(); // Controller for TextField
    @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late bool isInReadingList, isInCurrentList, isCompleted;
  final Logger logger = Logger();
  TextEditingController _pageController = TextEditingController();
  late List<Book> completedList, currentList, readingList;
  late List<Review> usersReviews, bookReviews;
  
  Future<void> _getResources() async {
  completedList = await SQLService().getBooksCompletedForUser(widget.currentUser.id);
  currentList = await SQLService().getBooksReadingForUser(widget.currentUser.id);
  readingList = await SQLService().getBooksWishlistForUser(widget.currentUser.id);
usersReviews = await SQLService().getReviewsForUser(widget.currentUser.id);
bookReviews = await SQLService().getReviewsForBook(widget.currentUser.id); 
  }



  @override
  void initState() {
    super.initState();
    _getResources();
    // Check if the book is in the reading list of the current user
    isInReadingList = readingList.contains(widget.book); //.readingList.contains(widget.book);
    isInCurrentList = currentList.contains(widget.book);
    isCompleted = completedList.contains(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();  // Create an instance of the Logger

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                       child: ElevatedButton(
                        onPressed: () async {
                          // Navigate to BookSearchScreen and await the result
                          final Book? selectedBook = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookSearchScreen(),
                            ),
                          );

                          // If a Book was returned, navigate to BookDetailScreen
                          if (selectedBook != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailScreen(
                                  book: selectedBook,
                                  currentUser: currentUser,
                                ),
                              ),
                            );
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(500, 40), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(340,60),
                      backgroundColor: AppColors.lightBrown,
                    ),
                    child: Text(
                      "Search for a book...",
                      style: TextStyle(fontSize: 14, color: AppColors.darkBrown,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ),

                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      logger.i("Camera pressed");
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => CameraScreen(camera: cameras.first),
                        //   ),
                        // );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  bookScroll("Books you're reading", currentList, showProgress: true, currentUser: currentUser),//currentUser.currentList
                  bookScroll('Your personal Read List',readingList, currentUser: currentUser ),//currentUser.readingList
                  packScroll('Packs on your Read List', usersPacks, currentUser: currentUser,), //currentUser.usersPacks
                  bookScroll("Books you've finished", completedList, isCompleted: true, currentUser: currentUser),//currentUser.completedList
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
         backgroundColor: AppColors.darkBrown,
        child: Icon(Icons.chat, color: AppColors.lightBrown,),
        onPressed: () {
          // Navigate to the chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotScreen()),
          );
        },
        
      ),
        bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: currentUser),    

    );
  }

}


// class CameraScreen extends StatefulWidget {
//   final CameraDescription camera;

//   const CameraScreen({required this.camera});

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
