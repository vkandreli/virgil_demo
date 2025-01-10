import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/models/book.dart';

class Pack {
  final String title;
  final String publicationDate;
  final User creator;
  final String packImage;
  final String description;
  List<Book> books;

  Pack({
    required this.title,
    required this.publicationDate,
    required this.creator,
    required this.packImage,
    required this.description,
    required this.books,
  });

    // Convert a Pack object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'publicationDate': publicationDate,
      'creatorId': creator.username,  // Assuming creator is a User, use their username
      'packImage': packImage,
      'description': description,
      'books': books.map((book) => book.id).toList(),  // Store book IDs in a list
    };
  }

  // Create a Pack object from a Map (e.g., from database data)
  factory Pack.fromMap(Map<String, dynamic> map, List<Book> allBooks, User creator) {
    return Pack(
      title: map['title'],
      publicationDate: map['publicationDate'],
      creator: creator,
      packImage: map['packImage'],
      description: map['description'],
      books: map['books'].map<Book>((bookId) => allBooks.firstWhere((book) => book.id == bookId)).toList(),
    );
  }

  void addBook(Book book){
    books.add(book);
  }

}
