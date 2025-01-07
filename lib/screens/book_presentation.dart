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
  late bool isInReadingList;
  final Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    // Check if the book is in the reading list of the current user
    isInReadingList = widget.currentUser.readingList.contains(widget.book);
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
    logger.i("Started reading: ${widget.book.title}");
  }

  // Build the Action Buttons Column
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
              ElevatedButton(
                onPressed: _startReading,
                child: Text('Start Reading'),
              ),
              Text('Pages: ${widget.book.currentPage ?? 0} / ${widget.book.totalPages}'),
            ],
          ),
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
