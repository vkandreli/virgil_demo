import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:virgil_demo/models/review.dart';

class BookSearchScreen extends StatefulWidget {
  //final String query;

  //BookSearchScreen({required this.query});

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  late TextEditingController _searchController;
  late List<Book> filteredBooks;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();//text: widget.query
    filteredBooks = [];  // Initialize as empty, we will fetch after pressing "Go"
  }

  void _searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Fetch books from the API
      final books = await fetchBooksFromGoogleAPI(query);
      setState(() {
        filteredBooks = books;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Search Books')),
      body: SafeArea(
        child:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Books',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchBooks, // Trigger the search when "Go" is pressed
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return ListTile(
                    title: Text(book.title),
                    onTap: () {
                      // Return the selected book back to the previous screen
                      Navigator.pop(context, book);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

Future<List<Book>> fetchBooksFromGoogleAPI(String query) async {
  final apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=$query';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    // If the response is successful (status code 200)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // List of books retrieved from the API response
      List<Book> books = [];

      // Check if there are items in the response
      if (data['items'] != null) {
        for (var item in data['items']) {
          // Extracting the necessary information for each book
          String id = item['id'] ?? '';  // Fetching book ID
          String title = item['volumeInfo']['title'] ?? 'No Title';
          List<String> authors = item['volumeInfo']['authors'] != null
              ? List<String>.from(item['volumeInfo']['authors'])
              : ['No Author'];
          String publisher = item['volumeInfo']['publisher'] ?? 'No Publisher';
          String publicationDate = item['volumeInfo']['publishedDate'] ?? 'No Date';
          String description = item['volumeInfo']['description'] ?? 'No Description';
          String posterUrl = item['volumeInfo']['imageLinks'] != null
              ? item['volumeInfo']['imageLinks']['thumbnail']
              : 'No Image';
          String language = item['volumeInfo']['language'] ?? 'No Language';  // Language field

          // We assume some default values for dateAdded and dateCompleted for now
          DateTime? dateAdded = DateTime.now(); // Default date
          DateTime? dateCompleted;
          int totalPages = item['volumeInfo']['pageCount'] ?? 0;
          int? currentPage = 0;
          
          // Initialize an empty list of reviews (since reviews aren't part of the Google Books API)
          List<Review>? reviews = [];

          // Create a Book object from the data and add it to the list
          books.add(Book(
            id: id,
            title: title,
            publicationDate: publicationDate,
            authors: authors,
            publisher: publisher,
            posterUrl: posterUrl,
            description: description,
            language: language,
            dateAdded: dateAdded,
            dateCompleted: dateCompleted,
            totalPages: totalPages,
            currentPage: currentPage,
            genre: '', 
            reviews: reviews, 
          ));
        }
      }

      return books;
    } else {
      throw Exception('Failed to load books');
    }
  } catch (e) {
    throw Exception('Error fetching books: $e');
  }
}
