import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'own_profile_screen.dart';
import 'home_screen.dart';
import 'recommendations_screen.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:camera/camera.dart';
import 'package:virgil_demo/models/user.dart';

class LibraryScreen extends StatelessWidget {
  User currentUser = placeholderSelf;

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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search books...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      logger.i("Camera pressed");
                      final cameras = await availableCameras();
                      if (cameras.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CameraScreen(camera: cameras.first),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildSection('Current', currentUser.currentList, showProgress: true),
                  _buildSection('To Do', currentUser.readingList),
                  _buildSection('Packs', currentUser.readingList), //currentUser.usersPacks
                  _buildSection('Completed', currentUser.completedList),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSection(String title, List<Book> books, {bool showProgress = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: showProgress ? 240 : 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.isEmpty ? 1 : books.length,
            itemBuilder: (context, index) {
              if (books.isEmpty) {
                return _BookCard(
                  book: null,
                  showProgress: showProgress,
                );
              }
              return _BookCard(
                book: books[index],
                showProgress: showProgress,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book? book;
  final bool showProgress;

  const _BookCard({
    this.book,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book?.posterUrl ?? 'https://via.placeholder.com/120x180',
                height: 180,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            if (showProgress)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[200],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// class LibraryScreen extends StatelessWidget {
//   final Logger logger = Logger();  // Create an instance of the Logger

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.camera_alt),
//                   onPressed: () {
//                     // Implement the camera functionality
//                     logger.i("Camera clicked");
//                   },
//                 ),
//               ],
//             ),       
              
//         SingleChildScrollView(
//           child: Column(
//             children: [
//               // Current Section
//               _buildBookSection("Currently reading", [
//                 _buildBookItem(Book(
//                   title: "Book 1",
//                   publicationDate: "2023-01-01",
//                   author: "Author 1",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Book 1",
//                 )),
//                 _buildBookItem(Book(
//                   title: "Book 2",
//                   publicationDate: "2023-02-01",
//                   author: "Author 2",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Book 2",
//                 )),
//                 _buildBookItem(Book(
//                   title: "Book 3",
//                   publicationDate: "2023-03-01",
//                   author: "Author 3",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Book 3",
//                 )),
//               ], true),

//               // To Do Section
//               _buildBookSection("Books in your Reading List", [
//                 _buildBookItem(Book(
//                   title: "Book 4",
//                   publicationDate: "2023-04-01",
//                   author: "Author 4",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Book 4",
//                 )),
//                 _buildBookItem(Book(
//                   title: "Book 5",
//                   publicationDate: "2023-05-01",
//                   author: "Author 5",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Book 5",
//                 )),
//               ], false),

//               // Packs Section
//               _buildBookSection("Packs in your Reading List", [
//                 _buildBookItem(Book(
//                   title: "Pack 1",
//                   publicationDate: "2023-06-01",
//                   author: "Author 6",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Pack 1",
//                 )),
//                 _buildBookItem(Book(
//                   title: "Pack 2",
//                   publicationDate: "2023-07-01",
//                   author: "Author 7",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Pack 2",
//                 )),
//               ], true),

//               // Completed Section
//               _buildBookSection("Completed", [
//                 _buildBookItem(Book(
//                   title: "Book 6",
//                   publicationDate: "2023-08-01",
//                   author: "Author 8",
//                   posterUrl: "https://via.placeholder.com/100",
//                   description: "Description of Book 6",
//                 )),
//               ], false),
//             ],
//           ),
//         ),
//       ],
//       ),
                
//         ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to chat screen
//           print("Chat button clicked");
//         },
//         child: Icon(Icons.chat),
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }

//   // Method to build each section with a title and list of books
//   Widget _buildBookSection(String sectionTitle, List<Widget> books, bool isCurrent) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             sectionTitle,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         // Scrollable area for book covers
//         Container(
//           height: 180,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: books,
//           ),
//         ),
//       ],
//     );
//   }

//   // Method to build each book item with a progress bar
//   Widget _buildBookItem(Book book) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//               // Open the details of the book when clicked
//               print("Book clicked: ${book.title}");
//             },
//             child: Container(
//               width: 100,
//               height: 150,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(book.posterUrl),
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             book.title,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 4),
//           LinearProgressIndicator(
//             value: 0.5, // This can vary depending on progress (just as an example)
//             backgroundColor: Colors.grey[200],
//             color: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   }
// }