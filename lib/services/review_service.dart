import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/services/user_service.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';


class ReviewService {
  late Database _database;
  final UserService _userService = UserService();

    Future<void> init() async {
    _database = await SQLService.database;
  }

  // Add a review to the database
  Future<void> addReview(Review review) async {
    final db = _database;

    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all reviews for a specific book
  Future<List<Review>> getReviewsForBook(String bookId, List<Book> allBooks, List<User> allUsers) async {
    final db = _database;

    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    List<Review> reviews = [];
    for (var map in maps) {
      // Find the book and user objects by their IDs
      Book book = allBooks.firstWhere((book) => book.id == map['bookId']);
      User user = allUsers.firstWhere((user) => user.username == map['userId']);

      reviews.add(Review.fromMap(map, book, user));
    }

    return reviews;
  }

  // Get all reviews written by a specific user
Future<List<Review>> getReviewsByUser(String userId, List<Book> allBooks) async {
  final db = _database;

  // Fetch the user along with their categorized book lists
  final user = await _userService.getUserWithLists(userId);
  if (user == null) {
    // If user is not found, return an empty list
    return [];
  }

  // Fetch reviews by the user from the reviews table
  final List<Map<String, dynamic>> maps = await db.query(
    'reviews',
    where: 'userId = ?',
    whereArgs: [userId],
  );

  List<Review> reviews = [];

  for (var map in maps) {
    // Find the book object by its ID
    Book book = allBooks.firstWhere((book) => book.id == map['bookId']);

    // Create a Review object from the map and add it to the reviews list
    reviews.add(Review.fromMap(map, book, user));
  }

  return reviews;
}


  // Delete a review by its ID
  Future<void> deleteReview(int reviewId) async {
    final db = _database;

    await db.delete(
      'reviews',
      where: 'id = ?',
      whereArgs: [reviewId],
    );
  }
}
