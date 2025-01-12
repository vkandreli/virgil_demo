import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
// //import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/screens/add_to_pack.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/new_review.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';
//////import 'package:virgil_demo/models/user.dart';  // Assuming we have the User model available

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final User currentUser;

  const BookDetailScreen(
      {Key? key, required this.book, required this.currentUser})
      : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late bool isInReadingList = false, isInCurrentList = false, isCompleted = false;
  final Logger logger = Logger();
  TextEditingController _pageController = TextEditingController();
  late List<Book> completedList = [], currentList = [],  readingList = [];
  late List<Review> usersReviews= [], bookReviews= [];
  late int currentPage = 0;
  
  Future<void> _getResources() async {
  completedList = await SQLService().getBooksCompletedForUser(widget.currentUser.id);
  currentList = await SQLService().getBooksReadingForUser(widget.currentUser.id);
  readingList = await SQLService().getBooksWishlistForUser(widget.currentUser.id);
usersReviews = await SQLService().getReviewsForUser(widget.currentUser.id);
bookReviews = await SQLService().getReviewsForBook(widget.currentUser.id);
  }


    Future<void> addToReadList(int? bookId, int? userId) async {
    await  SQLService().addBookToReadingList(bookId, userId);
        setState(() {
          isInReadingList = true;
          });
  }


    Future<void> RemoveFromReadList(int? bookId, int? userId) async {
    await  SQLService().removeBookFromReadingList(bookId, userId);
        setState(() {
          isInReadingList = false;
          });
  }

    Future<void> addToCurrentList(int? bookId, int? userId) async {
    await  SQLService().addBookToCurrentList(bookId, userId);
    setState(() {
      isInCurrentList = true;
          });
    }

     Future<void> addToCompletedList(int? bookId, int? userId) async {
    await  SQLService().addBookToCompletedList(bookId, userId);
        setState(() {
          isCompleted = true;
          });
    }

  
  Future<void> getCurrentPage(int? userId,int? bookId) async{
    currentPage =  await SQLService().getCurrentPage(userId, bookId);

  }


  Future<void> CheckAndUpdatePagesPerDay(int? userId, int pages, String date) async {

    final exists = await SQLService().doesPagesPerDayExist(userId, date);

     if (exists) {
     int  currentPages = await SQLService().getPagesPerDay(userId, date);
     currentPages = currentPages + pages;
    SQLService().updatePagesPerDay(userId, currentPages);
  } else {
     SQLService().addPagesPerDay(userId, pages, date);
  }
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

  // Toggle Save/Remove button logic
  void _toggleSaveRemove() {
    setState(() {
      if (isInReadingList) {
       RemoveFromReadList(widget.book.id, widget.currentUser.id);
       readingList.remove(widget.book);
        logger.i("Removed book from wishlist: ${widget.book.title}");
      } else {
        addToReadList(widget.book.id, widget.currentUser.id);
        readingList.add(widget.book);
        logger.i("Saved book to wishlist: ${widget.book.title}");
      }
      isInReadingList = !isInReadingList;
    });
  }

  // Handle Start Reading button click
  void _startReading() {
    addToCurrentList(widget.book.id, widget.currentUser.id);
    logger.i("Started reading: ${widget.book.title}");
    isInCurrentList = currentList.contains(widget.book);
    if (isInCurrentList) logger.i("Is in current list: ${widget.book.title}");
  }

  // Method to add new page
  Future<void> _addPages(int newPage) async {
    // Find the book in the currentList based on the title
    Book? selected = currentList.firstWhere(
      (book) => book.title == widget.book.title,
      orElse: () => Book.empty(), // If the book is not found, return null
    );

    if (selected == Book.empty()) {
      // Handle the case where the book is not found
      logger.e("Book not found in the current list: ${widget.book.title}");
    } else {
      String today = DateTime.now().toString().split(' ')[0];

      // Check if there's already an entry for today's pages in pagesPerDay
    /**   Map<DateTime, int>? todayPagesEntry =
          widget.currentUser.pagesPerDay.firstWhere(
        (entry) => entry.containsKey(today),
        orElse: () => {},
      );

      if (todayPagesEntry.isEmpty) {
        // If no entry exists for today, create a new entry
        widget.currentUser.pagesPerDay.add({today: newPage});
      } else {
        // If there's an entry for today, update the pages
        widget.currentUser.pagesPerDay
            .remove(todayPagesEntry); // Remove the old entry
        widget.currentUser.pagesPerDay.add(
            {today: todayPagesEntry[today]! + newPage}); // Add updated value
      }*/

    CheckAndUpdatePagesPerDay(widget.currentUser.id, newPage, today);

      if (newPage == selected.totalPages) {
        setState(() {
          isCompleted = true;
          
              addToCompletedList(selected.id, widget.currentUser.id); // Directly update the book
        });
        logger.i("Finished book: ${widget.book.title}");
      } else {
        setState(() {
          SQLService().updateUserBook(widget.currentUser.id, widget.book.id, newPage);
          // SQLService.currentPage(newPage);
          // widget.currentUser.currentPage =
          //     newPage; // Directly update the book's currentPage
        });
        logger.i("Reached page: $newPage at ${widget.book.title}");
      }
    }
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddToPack(
                          currentUser: widget.currentUser,
                          selectedBook: widget.book,
                        )), 
              );
            }),
        SizedBox(height: 10),
        IconButton(
          icon: Icon(
            Icons.save_alt,
            color: isInReadingList
                ? Colors.green
                : Colors.black, // Change color based on readingList
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
                  onPressed: () {
                    _startReading();
                    setState(() {});
                  },
                  child: Text(
                    'Start Reading',
                    style: TextStyle(color: AppColors.darkBrown),
                  ),
                ),
              ],
              if (isInCurrentList && !isCompleted) ...[
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
                    onChanged: (value) {},
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
                        Book? selected =
                            currentList.firstWhere(
                          (book) => book.title == widget.book.title,
                          orElse: () => Book.empty(),
                        );

                        logger.i(
                            "Reached page: ${currentPage} at ${widget.book.title}");

                        // Clear the text field
                        _pageController.clear();

                        // Trigger a rebuild of the widget
                        setState(() {});
                      } else {
                        // Show an error message if the page number is invalid
                        final snackBar = SnackBar(
                          content: Text(
                              'Invalid page number. Please enter a number between 1 and ${widget.book.totalPages}.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text(
                    'Enter current page',
                    style: TextStyle(color: AppColors.darkBrown),
                  ),
                ),

                Text(
                  'Pages: ${currentPage} / ${widget.book.totalPages}',
                ),
              ],
            ],
          ),
        if (isCompleted)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (!usersReviews.any((review) =>
                      review.user_id == widget.currentUser.id && review.book_id == widget.book.id)) {
                    logger.i("Reviewing book: ${widget.book.title}");
                    
                    // Navigate to CreateReviewScreen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateReviewScreen(
                          currentUser: widget.currentUser,
                          selectedBook: widget.book,
                        ),
                      ),
                    );
                    
                    // Refresh the current screen after returning
                    setState(() {}); // This will cause the widget to rebuild
                  }
                },
                child: Text(
                  (!usersReviews.any((review) =>
                      review.user_id == widget.currentUser.id && review.book_id == widget.book.id)
                      ? 'Review book'
                      : "Already reviewed"),
                  style: TextStyle(color: AppColors.darkBrown),
                ),
              )

            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the body scrollable
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
                        widget.book.posterUrl.isEmpty
                            ? "https://tse3.mm.bing.net/th?id=OIP.n3ng2rUJOu_ceO1NyVChkAHaHa&pid=Api"
                            : widget.book.posterUrl,
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

                // Book Author
                Text(
                  'Author',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.book.author,
                  style: TextStyle(fontSize: 18),
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
                if (usersReviews.isNotEmpty) ...[
                  reviewScroll("${widget.book.title}'s reviews",
                      usersReviews,
                      currentUser: widget.currentUser),
                ],

                if (usersReviews.isEmpty ) ...[
                  Text(
                    " Users have not rated this book",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(context: context, currentUser: widget.currentUser),
    );
  }
}
