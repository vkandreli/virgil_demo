import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/user.dart';

class Book {
  final String id;
  final String title;
  final String publicationDate;
  final String publisher;
  final String posterUrl;
  final String description;
  final String language;
  DateTime? dateAdded;
  DateTime? dateCompleted;
  int totalPages;
  int? currentPage;
  String? genre;
  List< Review>? reviews;
  final List<String> authors;

  Book({ 
    required this.id,
    required this.title,
    required this.publicationDate,
    required this.authors,
    required this.publisher,
    required this.posterUrl,
    required this.description,
    required this.language,
    required this.totalPages,
    this.currentPage = 0,
    this.dateAdded,
    this.dateCompleted,
    this.genre,
    this.reviews,
  });

  void addReview(User user, Review review) {
    reviews ??= []; 
    reviews!.add(review);
    user.postReview(review);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'publicationDate': publicationDate,
      'author': authors,
      'publisher': publisher,
      'posterUrl': posterUrl,
      'description': description,
      'language': language,
      'dateAdded': dateAdded?.toIso8601String(),  // Store as string in ISO format
      'dateCompleted': dateCompleted?.toIso8601String(),
      'totalPages': totalPages,
      'currentPage': currentPage,
      'genre': genre,
      // Optionally handle reviews if you plan to store them in the same table
      // 'reviews': reviews?.map((r) => r.toMap()).toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      publicationDate: map['publicationDate'],
      authors: map['author'],
      publisher: map['publisher'],
      language: map['language'],
      posterUrl: map['posterUrl'],
      description: map['description'],
      dateAdded: map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
      dateCompleted: map['dateCompleted'] != null ? DateTime.parse(map['dateCompleted']) : null,
      totalPages: map['totalPages'],
      currentPage: map['currentPage'],
      genre: map['genre'],
      // Optionally handle reviews if you store them in the same table
      // reviews: map['reviews'] != null ? (map['reviews'] as List).map((r) => Review.fromMap(r)).toList() : [],
    );
  }


   factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title'],
      publicationDate: json['volumeInfo']['publishedDate'] ?? '',
      authors: (json['volumeInfo']['authors'] != null && json['volumeInfo']['authors'].isNotEmpty)
          ? json['volumeInfo']['authors']
          : {'Unknown'},
      publisher: json['volumeInfo']['publisher'] ?? 'Unknown',
      language: json['language'],
      posterUrl: json['volumeInfo']['imageLinks'] != null
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : 'https://via.placeholder.com/150', // Default image if no poster is available
      description: json['volumeInfo']['description'] ?? 'No description available',
      totalPages: json['volumeInfo']['pageCount'] ?? 0,
    );
  }

  factory Book.empty() {
    return Book(
      id: "",
      title: '',
      description: '',
      genre: '',
      posterUrl: 'https://tse3.mm.bing.net/th?id=OIP.0fb3mN86pTUI9jvsDmkqgwHaJl&pid=Api',
      totalPages: 0,
      currentPage: 0,
      publicationDate: "",
      publisher: "",
      authors:[ ""],
      language: ""
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