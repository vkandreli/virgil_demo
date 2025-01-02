import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:camera/camera.dart';

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
