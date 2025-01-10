import 'package:virgil_demo/sqlbyvoulina.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  late Database _db;

  // Initialize the database
  Future<void> init() async {
    _db = await SQLService.database;
  }

  // Add a new user to the database
  Future<void> addUser(User user) async {
    await _db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all users from the database with their categorized books
Future<List<User>> getAllUsers() async {
  final db = await SQLService.database;
  
  // Fetch all users from the 'users' table
  final List<Map<String, dynamic>> userMaps = await db.query('users');
  
  // Prepare a list to store the users with their books
  List<User> users = [];

  for (var userMap in userMaps) {
    // Fetch the user's books from the 'user_books' table
    final userId = userMap['id'];
    final List<Map<String, dynamic>> userBooks = await db.rawQuery('''
      SELECT books.*, user_books.status
      FROM books
      JOIN user_books ON books.id = user_books.bookId
      WHERE user_books.userId = ?
    ''', [userId]);

    // Categorize books based on status
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

    // Create a User object with categorized books
    users.add(User.fromMap(
      userMap,
      readingList,
      completedList,
      currentList,
    ));
  }

  // Return the list of all users
  return users;
}


  // Get a User by username with related books
  Future<User?> getUserByUsername(String username) async {
    final db = await SQLService.database;
    
    // Fetch the user from the 'users' table
    final List<Map<String, dynamic>> userMaps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (userMaps.isNotEmpty) {
      // Fetch the user's books from the 'user_books' table
      final userId = userMaps.first['id'];
      final List<Map<String, dynamic>> userBooks = await db.rawQuery('''
        SELECT books.*, user_books.status
        FROM books
        JOIN user_books ON books.id = user_books.bookId
        WHERE user_books.userId = ?
      ''', [userId]);

      // Categorize books based on status
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

      // Return the user object with their categorized lists
      return User.fromMap(
        userMaps.first,
        readingList,
        completedList,
        currentList,
      );
    } else {
      return null;  // If no user found, return null
    }
  }

  Future<User?> getUserWithLists(String userId) async {
  final db = await _db;

  // Fetch the user from the 'users' table
  final List<Map<String, dynamic>> userMaps = await db.query(
    'users',
    where: 'username = ?',
    whereArgs: [userId],
  );

  if (userMaps.isNotEmpty) {
    final userId = userMaps.first['id'];

    // Fetch the user's books (categorized by status: 'reading', 'completed', 'current')
    final List<Map<String, dynamic>> userBooks = await db.rawQuery('''
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

    // Create and return the user with the lists
    return User.fromMap(
      userMaps.first,
      readingList,
      completedList,
      currentList,
    );
  } else {
    return null; // User not found
  }
}

}
