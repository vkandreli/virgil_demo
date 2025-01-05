import 'package:flutter/material.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/pack.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/pack_presentation.dart';

Widget genericScroll<T>({
  required String title,
  required List<T> items,
  required Widget Function(BuildContext, T) itemBuilder,  // A callback for rendering each item
  bool showProgress = false,
  bool isCompleted = false,
}) {
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
          itemCount: items.isEmpty ? 1 : items.length,
          itemBuilder: (context, index) {
            if (items.isEmpty) {
              return itemBuilder(context, items[index]);
            }
            return itemBuilder(context, items[index]);
          },
        ),
      ),
    ],
  );
}

Widget bookScroll(String title, List<Book> books, {bool showProgress = false, bool isCompleted = false}) {
  return genericScroll<Book>(
    title: title,
    items: books,
    itemBuilder: (context, book) {
      return _BookCard(
        book: book,
        showProgress: showProgress,
        isCompleted: isCompleted,
      );
    },
  );
}

Widget packScroll(String title, List<Pack> packs, { bool isCompleted = false}) {
  return genericScroll<Pack>(
    title: title,
    items: packs,
    itemBuilder: (context, pack) {
      return _PackCard(
        pack: pack,
        isCompleted: isCompleted,
      );
    },
  );
}



// Widget bookScroll(String title, List<Book> books, {bool showProgress = false, bool isCompleted = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(
//           height: showProgress ? 240 : 200,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             itemCount: books.isEmpty ? 1 : books.length,
//             itemBuilder: (context, index) {
//               if (books.isEmpty) {
//                 return _BookCard(
//                   book: null,
//                   showProgress: showProgress,
//                   isCompleted: isCompleted,
//                 );
//               }
//               return _BookCard(
//                 book: books[index],
//                 showProgress: showProgress,
//                 isCompleted: isCompleted,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
  
// Widget bookScroll(String title, List<Pack> packs, {bool isCompleted = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(
//           height: showProgress ? 240 : 200,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             itemCount: books.isEmpty ? 1 : books.length,
//             itemBuilder: (context, index) {
//               if (books.isEmpty) {
//                 return _BookCard(
//                   book: null,
//                   showProgress: showProgress,
//                   isCompleted: isCompleted,
//                 );
//               }
//               return _PackCard(
//                 pack: books[index],
//                 isCompleted: isCompleted,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

class _BookCard extends StatelessWidget {
  final Book? book;
  final bool showProgress;
  final bool isCompleted;

  const _BookCard({
    this.book,
    this.showProgress = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (book != null) {
          // Navigate to the BookDetailScreen with the selected book
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book!),
            ),
          );
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior: Clip.none,  // Allow the progress bar to go beyond the image
          children: [
            // Image with border (only when isCompleted is true)
            Container(
              decoration: BoxDecoration(
                border: isCompleted ? Border.all(color: Color.fromARGB(255, 27, 139, 55), width: 2) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book?.posterUrl ?? 'https://via.placeholder.com/120x180',
                  height: 180, // Fixed height for image
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // If showProgress is true, add the progress indicator on top
            if (showProgress)
              Positioned(
                bottom: 0,  // Place the progress bar at the bottom of the image
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),  // Adjust padding as needed
                  child: LinearProgressIndicator(
                    value: 0.7,  // Example value, replace with dynamic value
                    color: Color.fromARGB(255, 27, 139, 55),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  final Pack? pack;
  final bool isCompleted;

  const _PackCard({
    this.pack,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pack != null) {
          // Navigate to the BookDetailScreen with the selected book
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PackDetailScreen(pack: pack!),
            ),
          );
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior: Clip.none,  // Allow the progress bar to go beyond the image
          children: [
            // Image with border (only when isCompleted is true)
            Container(
              decoration: BoxDecoration(
                border: isCompleted ? Border.all(color: Color.fromARGB(255, 27, 139, 55), width: 2) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pack?.packImage?? 'https://via.placeholder.com/120x180',
                  height: 180, // Fixed height for image
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),          
          ],
        ),
      ),
    );
  }
}
