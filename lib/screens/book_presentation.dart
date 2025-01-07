import 'package:flutter/material.dart';
import 'package:virgil_demo/models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(book.title),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book poster image
              Center(
                child: Image.network(
                  book.posterUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              
              // Book Title
              Text(
                book.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              Text(
                "Author: ${book.author}",
                style: TextStyle(fontSize: 18),
              ),
                            Text(
                book.description,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: null, 
    );
  }
}
