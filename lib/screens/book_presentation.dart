import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieTitle;
  final String imageUrl;

  MovieDetailScreen({required this.movieTitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie poster image
              Center(
                child: Image.network(
                  imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              
              // Movie Title
              Text(
                movieTitle,
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
                  'Written by',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.book.authors.join(', '),
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
                if (widget.book.reviews?.isNotEmpty ?? false) ...[
                  reviewScroll("${widget.book.title}'s reviews",
                      widget.book.reviews ?? placeholderReviews,
                      currentUser: widget.currentUser),
                ],

                if (widget.book.reviews?.isEmpty ?? true) ...[
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
    );
  }
}
