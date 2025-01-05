import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/book.dart';

class BookSearchScreen extends StatefulWidget {
  final String query;

  BookSearchScreen({required this.query});

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  late List<Book> filteredBooks;

  @override
  void initState() {
    super.initState();
    // Filter books based on the initial query
    filteredBooks = placeholderBooks
        .where((book) => book.title.toLowerCase().contains(widget.query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Books')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the filtered books as a list
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return ListTile(
                    title: Text(book.title),
                    onTap: () {
                      // Return the selected book back to the CreatePostScreen
                      Navigator.pop(context, book);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
