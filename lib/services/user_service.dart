import 'package:virgil_demo/sqlbyvoulina.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  Database? _db;

  // Initialize the database
  Future<void> init() async {
    _db = await SQLService.database;
  }

  // Ensure that _db is initialized before any method that accesses it
  Future<void> _checkDbInitialized() async {
    if (_db == null) {
      await init(); // Initialize the database if not already initialized
    }
  }

  // Add a new user to the database
  Future<void> addUser(User user) async {
    await _checkDbInitialized(); // Ensure database is initialized
    await _db!.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all users from the database with their categorized books
  Future<List<User>> getAllUsers() async {
    await _checkDbInitialized(); // Ensure database is initialized

    final List<Map<String, dynamic>> userMaps = await _db!.query('users');
    List<User> users = [];

    for (var userMap in userMaps) {
      final userId = userMap['id'];
      final List<Map<String, dynamic>> userBooks = await _db!.rawQuery('''
        SELECT books.*, user_books.status
        FROM books
        JOIN user_books ON books.id = user_books.bookId
        WHERE user_books.userId = ?
      ''', [userId]);

      List<Book> readingList = [];
      List<Book> completedList = [];
      List<Book> currentList = [];

      for (var map in userBooks) {
        Book book = Book.fromMap(map);

        switch (map['status']) {
          case 'reading':
            readingList.add(book);
            break;
          case 'completed':
            completedList.add(book);
            break;
          case 'current':
            currentList.add(book);
            break;
        }
      }

      users.add(User.fromMap(userMap, readingList, completedList, currentList));
    }

    return users;
  }

  // Get a User by username with related books
  Future<User?> getUserByUsername(String username) async {
    await _checkDbInitialized(); // Ensure database is initialized

    final List<Map<String, dynamic>> userMaps = await _db!.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (userMaps.isNotEmpty) {
      final userId = userMaps.first['id'];
      final List<Map<String, dynamic>> userBooks = await _db!.rawQuery('''
        SELECT books.*, user_books.status
        FROM books
        JOIN user_books ON books.id = user_books.bookId
        WHERE user_books.userId = ?
      ''', [userId]);

      List<Book> readingList = [];
      List<Book> completedList = [];
      List<Book> currentList = [];

      for (var map in userBooks) {
        Book book = Book.fromMap(map);

        switch (map['status']) {
          case 'reading':
            readingList.add(book);
            break;
          case 'completed':
            completedList.add(book);
            break;
          case 'current':
            currentList.add(book);
            break;
        }
      }

      return User.fromMap(userMaps.first, readingList, completedList, currentList);
    }

    return null; // If no user found
  }

  // Get user with their categorized books
  Future<User?> getUserWithLists(String userId) async {
    await _checkDbInitialized(); // Ensure database is initialized

    final List<Map<String, dynamic>> userMaps = await _db!.query(
      'users',
      where: 'username = ?',
      whereArgs: [userId],
    );

    if (userMaps.isNotEmpty) {
      final userId = userMaps.first['id'];

      final List<Map<String, dynamic>> userBooks = await _db!.rawQuery('''
        SELECT books.*, user_books.status
        FROM books
        JOIN user_books ON books.id = user_books.bookId
        WHERE user_books.userId = ?
      ''', [userId]);

      List<Book> readingList = [];
      List<Book> completedList = [];
      List<Book> currentList = [];

      for (var map in userBooks) {
        Book book = Book.fromMap(map);

        switch (map['status']) {
          case 'reading':
            readingList.add(book);
            break;
          case 'completed':
            completedList.add(book);
            break;
          case 'current':
            currentList.add(book);
            break;
        }
      }

      return User.fromMap(userMaps.first, readingList, completedList, currentList);
    }

    return null; // User not found
  }
}
