import 'package:virgil_demo/SQLService.dart';

// Get the book associated with a post
Future<Book?> getBooksForPost(int postId) async {
  final db = await database;

  // Query to get the book_id for the specific post
  final List<Map<String, dynamic>> maps = await db.query(
    'posts',
    where: 'id = ?',  // Find the post by its ID
    whereArgs: [postId],
  );

  if (maps.isNotEmpty) {
    final bookId = maps.first['book_id'];

    // Now query the 'books' table to get the book details
    final bookMaps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );

    if (bookMaps.isNotEmpty) {
      return Book.fromMap(bookMaps.first);
    }
  }

  return null; // Return null if no book found
}

// Get the original poster for a post
Future<User?> getPosterForPost(int postId) async {
  final db = await database;

  // Query to get the originalPoster_id for the specific post
  final List<Map<String, dynamic>> maps = await db.query(
    'posts',
    where: 'id = ?',  // Find the post by its ID
    whereArgs: [postId],
  );

  if (maps.isNotEmpty) {
    final posterId = maps.first['originalPoster_id'];

    // Now query the 'users' table to get the user details
    final userMaps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [posterId],
    );

    if (userMaps.isNotEmpty) {
      return User.fromMap(userMaps.first);
    }
  }

  return null; // Return null if no user found
}

// Get the reblogger for a post (this can be null)
Future<User?> getRebloggerForPost(int postId) async {
  final db = await database;

  // Query to get the reblogger_id for the specific post
  final List<Map<String, dynamic>> maps = await db.query(
    'posts',
    where: 'id = ?',  // Find the post by its ID
    whereArgs: [postId],
  );

  if (maps.isNotEmpty) {
    final rebloggerId = maps.first['reblogger_id'];

    if (rebloggerId != null) {
      // If there's a reblogger, query the 'users' table to get the user details
      final userMaps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [rebloggerId],
      );

      if (userMaps.isNotEmpty) {
        return User.fromMap(userMaps.first);
      }
    }
  }

  return null; // Return null if no reblogger or user found
}

