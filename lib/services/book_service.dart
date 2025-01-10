import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';

class BookService {
  late Database _database;

  // Initialize the database connection
  Future<void> init() async {
    _database = await SQLService.database;
  }

  // Insert a book into the database
  Future<void> insertBook(Book book) async {
    final db = _database;

    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get a book by its ID
  Future<Book?> getBookById(String bookId) async {
    final db = _database;

    // Query the 'books' table for a book with the provided bookId
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    } else {
      return null; // Return null if no book is found
    }
  }

  // Get all books in the database
  Future<List<Book>> getAllBooks() async {
    final db = _database;

    // Query the 'books' table to retrieve all books
    final List<Map<String, dynamic>> maps = await db.query('books');

    // Convert each map into a Book object and return the list of books
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // Update an existing book in the database
  Future<void> updateBook(Book book) async {
    final db = _database;

    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // Delete a book by its ID
  Future<void> deleteBook(String bookId) async {
    final db = _database;

    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // Fetch books by author
  Future<List<Book>> getBooksByAuthor(String author) async {
    final db = _database;

    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'authors LIKE ?',
      whereArgs: ['%$author%'], // Use the '%' wildcard to find books by the author
    );

    // Convert each map into a Book object and return the list of books
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // Fetch books by genre
  Future<List<Book>> getBooksByGenre(String genre) async {
    final db = _database;

    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'genre = ?',
      whereArgs: [genre],
    );

    // Convert each map into a Book object and return the list of books
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // Search books by title
  Future<List<Book>> searchBooksByTitle(String query) async {
    final db = _database;

    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'], // Use the '%' wildcard to find books by title
    );

    // Convert each map into a Book object and return the list of books
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // Fetch books by a specific publication date range
  Future<List<Book>> getBooksByPublicationDateRange(DateTime startDate, DateTime endDate) async {
    final db = _database;

    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'publicationDate BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    // Convert each map into a Book object and return the list of books
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }
}
