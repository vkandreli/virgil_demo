Future<Book> getBookForReview(int bookId) async {
  final db = await database;

  // Query to find the book with the specific bookId
  final List<Map<String, dynamic>> maps = await db.query(
    'books',
    where: 'id = ?',  // Filter by the book's ID
    whereArgs: [bookId],  // Pass the bookId to the query
  );

  if (maps.isNotEmpty) {
    // If a book is found, return the first book (there should only be one with the same ID)
    return Book.fromMap(maps.first);
  } else {
    // If no book is found, return a default empty book or handle the case appropriately
    throw Exception("Book not found with ID $bookId");
  }
}

Future<User> getUserForReview(int userId) async {
  final db = await database;

  // Query to find the book with the specific bookId
  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'id = ?', 
    whereArgs: [userId], 
  );

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  } else {
    throw Exception("Book not found with ID $userId");
  }
}