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

  void addBook(Book book){
    books.add(book);
  }
}
