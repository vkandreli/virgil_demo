
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
  });
}
