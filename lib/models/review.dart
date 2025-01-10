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
 
  // Convert Review object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'bookId': book.id, 
      'userId': user.username,  
      'text': text,
      'reviewDate': reviewDate,
      'stars': stars,
    };
  }

  // Convert Map to Review object
  factory Review.fromMap(Map<String, dynamic> map, Book book, User user) {
    return Review(
      book: book,  
      user: user,
      text: map['text'],
      reviewDate: map['reviewDate'],
      stars: map['stars'],
    );
  }
}

