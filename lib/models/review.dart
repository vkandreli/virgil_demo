import 'book.dart';
import 'user.dart';

class Review {
  final Book book;
  final User user;
  final String text;
  final String reviewDate;
  final int stars;

  Review({
    required this.book,
    required this.user,
    required this.text,
    required this.reviewDate,
    required this.stars,
  });
}
