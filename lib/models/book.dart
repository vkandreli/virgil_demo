import 'dart:convert';
import 'package:http/http.dart' as http;

class Book {
  final String title;
  final String publicationDate;
  final String author;
  final String publisher;
  final String posterUrl;
  final String description;
  DateTime? dateAdded;
  DateTime? dateCompleted;
  int totalPages;
  int? currentPage;
  String? genre;

  Book({
    required this.title,
    required this.publicationDate,
    required this.author,
    required this.publisher,
    required this.posterUrl,
    required this.description,
    required this.totalPages,
    this.currentPage = 0,
    this.dateAdded,
    this.dateCompleted,
    this.genre,
  });

   factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'],
      publicationDate: json['volumeInfo']['publishedDate'] ?? '',
      author: (json['volumeInfo']['authors'] != null && json['volumeInfo']['authors'].isNotEmpty)
          ? json['volumeInfo']['authors'][0]
          : 'Unknown',
      publisher: json['volumeInfo']['publisher'] ?? 'Unknown',
      posterUrl: json['volumeInfo']['imageLinks'] != null
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : 'https://via.placeholder.com/150', // Default image if no poster is available
      description: json['volumeInfo']['description'] ?? 'No description available',
      totalPages: json['volumeInfo']['pageCount'] ?? 0,
    );
  }

  factory Book.empty() {
    return Book(
      title: '',
      description: '',
      genre: '',
      posterUrl: '',
      totalPages: 0,
      currentPage: 0,
      publicationDate: "",
      publisher: "",
      author: "",
    );
  }
}

Future<Book> fetchBookInfo(String query) async {
  final apiKey = 'AIzaSyDf2XeiFA9pOB-PzHyvSeNQ3p3cD_Jc9mE'; // Replace with your actual API key
  final url =
      'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['items'] != null && data['items'].isNotEmpty) {
        // You can customize which book to select from the response.
        final bookJson = data['items'][0]; // Take the first item in the search result
        return Book.fromJson(bookJson);
      } else {
        throw Exception('No book found');
      }
    } else {
      throw Exception('Failed to load book data');
    }
  } catch (error) {
    throw Exception('Failed to fetch book data: $error');
  }
}