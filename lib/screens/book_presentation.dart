import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';
import 'package:virgil_demo/models/user.dart';  // Assuming we have the User model available

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final User currentUser;

  const BookDetailScreen({Key? key, required this.book, required this.currentUser}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late bool isInReadingList, isInCurrentList;
  final Logger logger = Logger();
  TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if the book is in the reading list of the current user
    isInReadingList = widget.currentUser.readingList.contains(widget.book);
    isInCurrentList = widget.currentUser.currentList.contains(widget.book);
  }

  // Toggle Save/Remove button logic
  void _toggleSaveRemove() {
    setState(() {
      if (isInReadingList) {
        widget.currentUser.readingList.remove(widget.book);
        logger.i("Removed book from reading list: ${widget.book.title}");
      } else {
        widget.currentUser.readingList.add(widget.book);
        logger.i("Saved book to reading list: ${widget.book.title}");
      }
      isInReadingList = !isInReadingList;
    });
  }

  // Handle Add button click
  void _addToList() {
    logger.i("Added book to the list: ${widget.book.title}");
  }

  // Handle Start Reading button click
  void _startReading() {
    widget.currentUser.addToCurrent(widget.book);
    logger.i("Started reading: ${widget.book.title}");
        isInCurrentList = widget.currentUser.currentList.contains(widget.book);
    if(isInCurrentList) logger.i("Is in current list: ${widget.book.title}");
  }

  // Method to add new page
void _addPages(int newPage) {
  // Find the book in the currentList based on the title
  Book? selected = widget.currentUser.currentList.firstWhere(
    (book) => book.title == widget.book.title,
    orElse: () => Book.empty(), // If the book is not found, return null
  );

  if (selected == Book.empty()) {
    // Handle the case where the book is not found
    logger.e("Book not found in the current list: ${widget.book.title}");
  } else {
    setState(() {
      selected.currentPage = newPage;  // Directly update the book's currentPage
    });
    logger.i("Reached page: $newPage at ${widget.book.title}");
  }
}



Widget _buildActionButtons() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      IconButton(
        icon: Icon(Icons.add_circle_outline),
        onPressed: _addToList,
      ),
      SizedBox(height: 10),
      IconButton(
        icon: Icon(
          Icons.save_alt,
          color: isInReadingList ? Colors.green : Colors.black, // Change color based on readingList
        ),
        onPressed: _toggleSaveRemove,
      ),
      SizedBox(height: 10),
      // Start Reading button / Page count (only if the book is in the reading list)
      if (isInReadingList)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isInCurrentList) ...[
              ElevatedButton(
                onPressed: (){
                  _startReading();
                  setState(() {
                      });
                      },
                child: Text('Start Reading'),
                
              ),
            ],
            if (isInCurrentList) ...[
              // Wrap TextField with ConstrainedBox or Container to avoid overflow
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 165),
                child: TextField(
                  controller: _pageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter new page',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                  },
                ),
              ),
              SizedBox(height: 10),
ElevatedButton(
  onPressed: () {
    if (_pageController.text.isNotEmpty) {
      // Parse the entered page number
      int newPage = int.tryParse(_pageController.text) ?? 0;

      // Check if the page number is valid (within the total pages of the book)
      if (newPage <= widget.book.totalPages && newPage > 0) {
        // If valid, update the page
        _addPages(newPage);

        // Find the selected book
        Book? selected = widget.currentUser.currentList.firstWhere(
          (book) => book.title == widget.book.title,
          orElse: () => Book.empty(),
        );

        logger.i("Reached page: ${selected.currentPage} at ${widget.book.title}");

        // Clear the text field
        _pageController.clear();

        // Trigger a rebuild of the widget
        setState(() {});
      } else {
        // Show an error message if the page number is invalid
        final snackBar = SnackBar(
          content: Text('Invalid page number. Please enter a number between 1 and ${widget.book.totalPages}.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  },
  child: Text('Enter current page'),
),

              Text(
                'Pages: ${widget.currentUser.pageOfBook(widget.book)} / ${widget.book.totalPages}',
              ),
            ],
          ],
        )
    ],
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView( // Make the body scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Title
                Text(
                  widget.book.title,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                // Book Cover and Action Buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.book.posterUrl,
                        height: 200,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Action Buttons
                    _buildActionButtons(),
                  ],
                ),
                SizedBox(height: 16),

                // Book Summary
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.book.description,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),

                // Book Genre
                Text(
                  'Genre: ${widget.book.genre ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                // Reviews Scrollable widget
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                reviewScroll("${widget.book.title}'s reviews", placeholderReviews, currentUser: widget.currentUser),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
