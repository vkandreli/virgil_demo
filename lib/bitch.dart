import 'package:virgil_demo/SQLService.dart';

Future<List<Book>> getBooksForPack(int packId) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query(
    'pack_books',
    where: 'pack_id = ?',  // Find all books related to the given packId
    whereArgs: [packId],
  );

  if (maps.isNotEmpty) {
    List<int> bookIds = maps.map((map) => map['book_id'] as int).toList();

    List<Book> books = [];
    for (int bookId in bookIds) {
      final bookMaps = await db.query(
        'books',
        where: 'id = ?',  // Retrieve book details based on book_id
        whereArgs: [bookId],
      );

      if (bookMaps.isNotEmpty) {
        books.add(Book.fromMap(bookMaps.first));
      }
    }

    return books;  // Return the list of books for the given pack
  } else {
    throw Exception("No books found for pack with ID $packId");
  }
}

Future<User> getUserForPack(int packId) async {
  final db = await database;

  // Query to find the pack with the specific packId and get its creator_id
  final List<Map<String, dynamic>> packMaps = await db.query(
    'packs',
    where: 'id = ?', 
    whereArgs: [packId], 
  );

  if (packMaps.isNotEmpty) {
    // Get the creator_id from the pack
    int creatorId = packMaps.first['creator_id'];

    // Query the users table to get the user by creator_id
    final List<Map<String, dynamic>> userMaps = await db.query(
      'users',
      where: 'id = ?', 
      whereArgs: [creatorId],
    );

    if (userMaps.isNotEmpty) {
      return User.fromMap(userMaps.first);  // Return the user
    } else {
      throw Exception("User not found with ID $creatorId");
    }
  } else {
    throw Exception("Pack not found with ID $packId");
  }
}



Future<Book> getBookForReview(int reviewId) async {
  final db = await database;

  final List<Map<String, dynamic>> reviewMaps = await db.query(
    'reviews',
    where: 'id = ?', 
    whereArgs: [reviewId], 
  );

  if (reviewMaps.isNotEmpty) {
    int bookId = reviewMaps.first['book_id'];

    final List<Map<String, dynamic>> bookMaps = await db.query(
      'books',
      where: 'id = ?', 
      whereArgs: [bookId],
    );

    if (bookMaps.isNotEmpty) {
      return Book.fromMap(bookMaps.first);  // Return the book
    } else {
      throw Exception("Book not found with ID $bookId");
    }
  } else {
    throw Exception("Review not found with ID $reviewId");
  }
}


Future<User> getUserForReview(int reviewId) async {
  final db = await database;

  // Query to find the review with the specific reviewId and get its user_id
  final List<Map<String, dynamic>> reviewMaps = await db.query(
    'reviews',
    where: 'id = ?', 
    whereArgs: [reviewId], 
  );

  if (reviewMaps.isNotEmpty) {
    // Get the user_id from the review
    int userId = reviewMaps.first['user_id'];

    // Query the users table to get the user by user_id
    final List<Map<String, dynamic>> userMaps = await db.query(
      'users',
      where: 'id = ?', 
      whereArgs: [userId],
    );

    if (userMaps.isNotEmpty) {
      return User.fromMap(userMaps.first);  // Return the user
    } else {
      throw Exception("User not found with ID $userId");
    }
  } else {
    throw Exception("Review not found with ID $reviewId");
  }
}





  static const String defaultProfileImage = "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api";//"https://via.placeholder.com/150?text=Profile+Image";
  User.empty()
      : id='',
      username = '',
        email = '',
        profileImage = '',
        status = '',
        isPacksPrivate = false,
        isReviewsPrivate = false,
        isReadListPrivate = false,
        password = "",
        followedUsers =  [],
        usersPosts = [],
       usersReviews = [],
        usersPacks = [],
        completedList = [],
        currentList = [],
        readingList = [],
       pagesPerDay= [],
        badges= [],
       goals = [];
