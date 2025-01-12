import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLService {
  // Singleton instance
  static final SQLService _instance = SQLService._internal();
final logger = Logger();

  // Factory constructor to return the singleton
  factory SQLService() => _instance;

  // Private constructor
  SQLService._internal();

  // Database instance
  static Database? _database;

  // Getter to access the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database
    _database = await _initDB();
    return _database!;
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);

  // Initialize the database
  Future<Database> _initDB() async {
    try {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'user_database.db'),
      onCreate: (db, version) async {
        // Create tables when the database is first created
        await db.execute(
          '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,
         username TEXT NOT NULL, email TEXT, profileImage TEXT, status TEXT, currentCity TEXT, 
         isPacksPrivate INTEGER DEFAULT 0, isReviewsPrivate INTEGER DEFAULT 0, isReadListPrivate INTEGER DEFAULT 0)''',
        );
        await db.execute(
          '''CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, publicationDate TEXT NOT NULL,
        author TEXT NOT NULL, publisher TEXT NOT NULL, language TEXT NOT NULL, posterUrl TEXT NOT NULL, description TEXT NOT NULL,
        dateAdded TEXT, dateCompleted TEXT, totalPages INTEGER NOT NULL, genre TEXT)
        ''',
        );
        await db.execute(
          '''CREATE TABLE user_books(user_id INTEGER,book_id INTEGER, list_category INTEGER CHECK(list_category >= 1 AND list_category <= 3),
       current_page INTEGER, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
         FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE, PRIMARY KEY (user_id, book_id)
      )
      ''',
        );
        db.execute(
          '''CREATE TABLE user_followeduser(user_id INTEGER,followeduser_id INTEGER,CHECK (user_id != followeduser_id),
       FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, FOREIGN KEY (followeduser_id) REFERENCES users(id)
        ON DELETE CASCADE, PRIMARY KEY (user_id, followeduser_id)
      )
      ''',
        );
        db.execute(
          '''CREATE TABLE posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT, originalPoster_id INTEGER, reblogger_id INTEGER, imageUrl TEXT,
          quote TEXT, book_id INTEGER, timePosted TEXT,likes INTEGER DEFAULT 0, reblogs INTEGER DEFAULT 0,
          FOREIGN KEY (originalPoster_id) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (reblogger_id) REFERENCES users(id) ON DELETE SET NULL,
          FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE)''',
        );
        db.execute('''CREATE TABLE reviews (
     id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER NOT NULL, user_id INTEGER NOT NULL,
     text TEXT NOT NULL, reviewDate TEXT NOT NULL, stars INTEGER CHECK(stars >= 0 AND stars <= 5), 
     FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)''');
        db.execute('''CREATE TABLE packs (
      id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, publicationDate TEXT NOT NULL, creator_id INTEGER NOT NULL, 
  packImage TEXT NOT NULL, description TEXT NOT NULL, FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE)''');
        db.execute(
          '''CREATE TABLE pack_books(pack_id INTEGER,book_id INTEGER, FOREIGN KEY (pack_id) REFERENCES packs(id) ON DELETE CASCADE,
         FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE, PRIMARY KEY (pack_id, book_id)
         )
      ''',
        );
        db.execute(
          '''CREATE TABLE comments(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, post_id INTEGER,
         FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE)
      ''',
        );
db.execute(
  '''CREATE TABLE pagesPerDay(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pages INTEGER,
    user_id INTEGER,
    date TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
  )'''
);

        db.execute(
          '''CREATE TABLE badges (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  name TEXT NOT NULL,
  image TEXT NOT NULL,
  description TEXT,
  requirement INTEGER NOT NULL
)''',
        );

        db.execute(
          '''CREATE TABLE user_badges (
  id INTEGER PRIMARY KEY AUTOINCREMENT, 
  user_id INTEGER NOT NULL,
  badge_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (badge_id) REFERENCES badges(id)
)''',
        );
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  } catch (e, stackTrace) {
    logger.e("Error initializing database", e, stackTrace);
    rethrow; // Rethrow exception after logging
  }
  }

//*******     User Setters      ********/

  // Define a function that inserts users into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the User into the correct table. You might also specify the
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the users from the users table.
  /**Future<List<User>> users() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the users.
     final List<Map<String, Object?>> userMaps = await db.query('users');

    // Convert the list of each user's fields into a list of `User` objects.
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in userMaps)
        User(id: id, name: name, age: age),
    ];
  }*/

  Future<void> reinitializeDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'user_database.db');

      // Delete the existing database
      await deleteDatabase(path);
      print('Database deleted successfully.');

      // Trigger the reinitialization by accessing the database getter
      final db = await database;
      print('Database reinitialized successfully.');
    } catch (e) {
      print('Error during reinitialization: $e');
    }
  }

  Future<void> dropAllTables(Database db) async {
    // Drop all existing tables
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('DROP TABLE IF EXISTS books');
    await db.execute('DROP TABLE IF EXISTS user_books');
    await db.execute('DROP TABLE IF EXISTS user_followeduser');
    await db.execute('DROP TABLE IF EXISTS pack_books');
    await db.execute('DROP TABLE IF EXISTS packs');
    await db.execute('DROP TABLE IF EXISTS posts');
    await db.execute('DROP TABLE IF EXISTS reviews');
    await db.execute('DROP TABLE IF EXISTS comments');
    await db.execute('DROP TABLE IF EXISTS badges');
    await db.execute('DROP TABLE IF EXISTS user_badges');

    print('All tables dropped successfully');
  }

  Future<void> printUsername(int userId) async {
    // Get a reference to the database
    final db = await SQLService().database;

    // Query the Users table for the user with the given userId
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['username'], // Only fetch the username column
      where: 'id = ?', // Specify the condition
      whereArgs: [userId], // Pass the userId as an argument
      limit: 1, // Limit the query to one result
    );

    // Check if a user was found
    if (result.isNotEmpty) {
      // Extract the username from the query result
      String username = result.first['username'] as String;

      // Print the username
      print('Username: $username');
    } else {
      print('No user found with id $userId');
    }
  }

  Future<void> printTables() async {
    var db = await SQLService().database; // Get the initialized database
    var tables =
        await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    print(
        tables); // This will print the names of all the tables in the database
  }

  Future<void> printTable(String tableName) async {
    // Get a reference to the database
    final db = await database;

    // Query the entire table
    final List<Map<String, dynamic>> rows = await db.query(tableName);

    // Print each row
    for (var row in rows) {
      print(row); // Prints the row as a map
    }
  }

  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given User.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the User has a matching id.
      where: 'id = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the User from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<User>> getUsersByUsername(String username) async {
    final db = await database;

    // Query the user from the users table where the username matches
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.map((map) => User.fromMap(map)).toList();
  }

Future<User> getUserById(int? id) async {
  final db = await database;

  // Query the user from the users table where the id matches
  final List<Map<String, dynamic>> maps = await db.query(
    'users',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isNotEmpty) {
    // If a user is found, return the User object created from the map
    return User.fromMap(maps.first);
  } 
  return User.empty();
}


  Future<String> getUsernameByUserId(int userId) async {
    final db = await SQLService().database;

    // Query the users table where the user_id matches
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return maps.first['username'];
    } else {
      throw Exception('User not found');
    }
  }

  Future<dynamic> takeElement(String tableName, String columnName,
      Map<String, dynamic> whereClause) async {
    final db = await SQLService().database; // Access the database instance

    // Build the WHERE clause dynamically
    String whereString =
        whereClause.keys.map((key) => "$key = ?").join(" AND ");
    List<dynamic> whereArgs = whereClause.values.toList();

    // Query the table
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: [columnName],
      where: whereString,
      whereArgs: whereArgs,
      limit: 1, // Only return one record
    );

    // If the result is empty, return null; otherwise, return the desired element
    if (result.isEmpty) {
      return null;
    } else {
      return result.first[columnName];
    }
  }

  Future<List<Book>> getBooksForPack(int? packId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'pack_books',
      where: 'pack_id = ?', // Find all books related to the given packId
      whereArgs: [packId],
    );

    if (maps.isNotEmpty) {
      List<int> bookIds = maps.map((map) => map['book_id'] as int).toList();

      List<Book> books = [];
      for (int bookId in bookIds) {
        final bookMaps = await db.query(
          'books',
          where: 'id = ?', // Retrieve book details based on book_id
          whereArgs: [bookId],
        );

        if (bookMaps.isNotEmpty) {
          books.add(Book.fromMap(bookMaps.first));
        }
      }

      return books; // Return the list of books for the given pack
    } else {
      throw Exception("No books found for pack with ID $packId");
    }
  }

  Future<User> getUserForPack(int? packId) async {
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
        return User.fromMap(userMaps.first); // Return the user
      } else {
        throw Exception("User not found with ID $creatorId");
      }
    } else {
      throw Exception("Pack not found with ID $packId");
    }
  }

  Future<Book> getBookForReview(int? reviewId) async {
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
        return Book.fromMap(bookMaps.first); // Return the book
      } else {
        throw Exception("Book not found with ID $bookId");
      }
    } else {
      throw Exception("Review not found with ID $reviewId");
    }
  }

  Future<User> getUserForReview(int? reviewId) async {
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
        return User.fromMap(userMaps.first); // Return the user
      } else {
        throw Exception("User not found with ID $userId");
      }
    } else {
      throw Exception("Review not found with ID $reviewId");
    }
  }

  Future<void> insertBadge(Badges Badges) async {
    final db = await database; // Get the database instance
    await db.insert(
      'badges',
      Badges.toMap(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Handle conflict by replacing existing records
    );
  }

  Future<List<Badges>> getBadgesForUser(int? userId) async {
    final db = await database;

    // Query the user_badges table to get badge_ids associated with the user
    final List<Map<String, dynamic>> badgeIds = await db.query(
      'user_badges',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // Now, fetch Badges details from the badges table based on the badge_ids
    List<Badges> badges = [];
    for (var badgeData in badgeIds) {
      final badgeId = badgeData['badge_id'];
      final badgeDetails = await db.query(
        'badges',
        where: 'id = ?',
        whereArgs: [badgeId],
      );

      if (badgeDetails.isNotEmpty) {
        badges.add(Badges.fromMap(badgeDetails.first)); // Now this should work
      }
    }

    return badges;
  }

  Future<void> assignBadgeToUser(UserBadge userBadge) async {
    final db = await database; // Get the database instance
    await db.insert(
      'user_badges',
      userBadge.toMap(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Handle conflict by replacing existing records
    );
  }

  Future<void> addBadgeToUser(int? userId, int? badgeId) async {
    final db = await database;

    // Insert a new row into the user_badges table
    await db.insert(
      'user_badges',
      {
        'user_id': userId,
        'badge_id': badgeId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicates
    );
  }

  Future<List<Badges>> getAllBadges() async {
    final db = await database;

    // Fetch all badges from the badges table
    final List<Map<String, dynamic>> badgeMaps = await db.query('badges');

    // Convert the result to a list of Badges objects
    return List.generate(badgeMaps.length, (i) {
      return Badges.fromMap(badgeMaps[i]); // Assuming Badges.fromMap exists
    });
  }

  Future<bool> hasUserBadge(int userId, int badgeId) async {
    final db = await database;

    // Query the user_badges table to check if the user has the specific Badges
    final List<Map<String, dynamic>> result = await db.query(
      'user_badges',
      where: 'user_id = ? AND badge_id = ?',
      whereArgs: [userId, badgeId],
    );

    // Return true if the result contains a record, otherwise false
    return result.isNotEmpty;
  }

  Future<void> removeBadgeFromUser(int userId, int badgeId) async {
    final db = await database;

    // Delete the corresponding Badges entry for the user
    await db.delete(
      'user_badges',
      where: 'user_id = ? AND badge_id = ?',
      whereArgs: [userId, badgeId],
    );
  }

  Future<Badges?> getBadgeById(int badgeId) async {
    final db = await database;

    // Query the badges table to get a Badges by its ID
    final List<Map<String, dynamic>> badgeData = await db.query(
      'badges',
      where: 'id = ?',
      whereArgs: [badgeId],
    );

    if (badgeData.isNotEmpty) {
      return Badges.fromMap(badgeData.first); // Assuming Badges.fromMap exists
    } else {
      return null;
    }
  }

  /// Create a User and add it to the users table
  /**var fido = User(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await insertUser(fido);

  // Now, use the method above to retrieve all the users.
  print(await users()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = User(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateUser(fido);

  // Print the updated results.
  print(await users()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteUser(fido.id);

  // Print the list of users (empty).
  print(await users());*/

  static const String defaultProfileImage =
      "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api";

  Future<List<User>> getAllUsers() async {
    final db = await SQLService().database;

    final List<Map<String, dynamic>> result = await db.query('users');

    return result.map((userMap) => User.fromMap(userMap)).toList();
  }

  /*******     Book Setters      ********/

  Future<void> insertBook(Book book) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBook(Book book) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Book.
    await db.update(
      'books',
      book.toMap(),
      // Ensure that the Book has a matching id.
      where: 'id = ?',
      // Pass the Book's id as a whereArg to prevent SQL injection.
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Book from the database.
    await db.delete(
      'books',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the Book's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  Future<Book> getBookForId(Book book) async {
  final db = await SQLService().database;

  // Query the database for a book with the given title, author, and totalPages
  final result = await db.query(
    'books', // Table name
    where: 'title = ? AND author = ? AND totalPages = ?', // Conditions
    whereArgs: [book.title, book.author, book.totalPages], // Parameters
  );

  // If the book exists, return it as a Book object; otherwise, return null
 
    return Book.fromMap(result.first);
  

// Return null if no book matches the query
}

  //*******       Post Setters      ********/

  Future<void> insertPost(Post post) async {
    final db = await database;

    // Insert the post into the database with the image URL
    await db.insert(
      'posts',
      {
        'originalPoster_id': post.originalPoster_id,
        'reblogger_id': post.reblogger_id,
        'imageUrl': post.imageUrl, // Store the local image path here
        'quote': post.quote,
        'book_id': post.book_id,
        'timePosted': post.timePosted,
        'likes': post.likes,
        'reblogs': post.reblogs,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePost(Post post) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Post.
    await db.update(
      'posts',
      post.toMap(),
      // Ensure that the Post has a matching id.
      where: 'id = ?',
      // Pass the Post's id as a whereArg to prevent SQL injection.
      whereArgs: [post.id],
    );
  }

  Future<void> deletePost(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Post from the database.
    await db.delete(
      'posts',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the Post's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> addCommentToPost(Comment comment) async {
    final db = await SQLService().database;

    // Insert the comment into the "comments" table
    await db.insert(
      'comments',
      comment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Comment>> getCommentsForPost(int? postId) async {
    final db = await SQLService().database;

    // Query to get comments for the specified post
    final List<Map<String, dynamic>> maps = await db.query(
      'comments',
      where: 'post_id = ?',
      whereArgs: [postId],
    );

    // Convert the list of maps into a list of Comment objects
    return List.generate(maps.length, (i) {
      return Comment.fromMap(maps[i]);
    });
  }

  Future<Post?> getPostForComment(int? commentId) async {
    final db = await SQLService().database;

    // Query to get the post for the specified comment
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT posts.* 
    FROM posts
    INNER JOIN comments ON posts.id = comments.post_id
    WHERE comments.id = ?
    ''',
      [commentId],
    );

    // Return the first post if found, otherwise null
    if (maps.isNotEmpty) {
      return Post.fromMap(maps.first);
    }
    return null;
  }

//*******     Review Setters      ********/

  Future<void> insertReview(Review review) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateReview(Review review) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Review.
    await db.update(
      'reviews',
      review.toMap(),
      // Ensure that the Review has a matching id.
      where: 'id = ?',
      // Pass the Review's id as a whereArg to prevent SQL injection.
      whereArgs: [review.id],
    );
  }

  Future<void> deleteReview(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Review from the database.
    await db.delete(
      'reviews',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the Review's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

//*******     Pack Setters      ********/

  Future<void> insertPack(Pack pack) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'packs',
      pack.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePack(Pack pack) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Pack.
    await db.update(
      'packs',
      pack.toMap(),
      // Ensure that the Pack has a matching id.
      where: 'id = ?',
      // Pass the Pack's id as a whereArg to prevent SQL injection.
      whereArgs: [pack.id],
    );
  }

  Future<void> deletePack(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Pack from the database.
    await db.delete(
      'packs',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the Pack's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<Pack>> getPacksForUser(int? userId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'packs',
      where: 'creator_id = ?',
      whereArgs: [userId],
    );

    //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
      return Pack.fromMap(maps[i]);
    });
  }

  Future<List<Review>> getReviewsForUser(int? userId) async {
    final db = await database;

    // Query to find all reviews made by the specific user
    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    // Convert the maps to a list of Review objects
    return List.generate(maps.length, (i) {
      return Review.fromMap(maps[i]);
    });
  }

Future<List<Review>> getReviewsForAuthor(String Author) async {
  final db = await database;

  // Corrected query to find all reviews made by the specific author
  final List<Map<String, dynamic>> maps = await db.rawQuery(
    '''
    SELECT reviews.* 
    FROM reviews
    INNER JOIN books ON reviews.book_id = books.id
    WHERE books.author = ?
    ''',
    [Author],
  );

  // Convert the maps to a list of Review objects
  return List.generate(maps.length, (i) {
    return Review.fromMap(maps[i]);
  });
}


  Future<List<Review>> getReviewsForBook(int? bookId) async {
    final db = await database;

    // Query to find all reviews for the specific book
    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
      where: 'book_id = ?',
      whereArgs: [bookId],
    );

    // Convert the maps to a list of Review objects
    return List.generate(maps.length, (i) {
      return Review.fromMap(maps[i]);
    });
  }

  Future<List<Review>> getReviewsByDate() async {
    final db = await SQLService().database;

    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
      orderBy: 'reviewDate DESC',
      limit: 10,
    );

    return maps.map((reviewMap) => Review.fromMap(reviewMap)).toList();
  }

//*************    User's Library     ******************/

  Future<void> associateUserWithBook(int userId, int bookId) async {
    final db = await database;

    await db.insert(
      'user_books',
      {
        'user_id': userId,
        'book_id': bookId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> disassociateUserWithBook(int userId, int bookId) async {
    final db = await database;

    await db.delete(
      'user_books',
      where: 'user_id = ? AND book_id = ?',
      whereArgs: [userId, bookId],
    );
  }

  Future<void> addBookToReadingList(int? bookId, int? userId) async {
    UserBook NewUserBook = UserBook(
      user_id: userId,
      book_id: bookId,
      listCategory: 3, //Wishlist pfff
      currentPage: 1,
    );

    await insertUserBook(NewUserBook);
  }

  Future<void> addBookToCompletedList(int? bookId, int? userId) async {
    UserBook NewUserBook = UserBook(
      user_id: userId,
      book_id: bookId,
      listCategory: 2, //Completed
      currentPage: 1,
    );

    await insertUserBook(NewUserBook);
  }

  Future<void> addBookToCurrentList(int? bookId, int? userId) async {
    UserBook NewUserBook = UserBook(
      user_id: userId,
      book_id: bookId,
      listCategory: 1, //reading rn
      currentPage: 1,
    );

    await insertUserBook(NewUserBook);
  }

  Future<void> removeBookFromReadingList(int? bookId, int? userId) async {
    final db = await SQLService().database;

    await db.delete(
      'user_books',
      where:
          'user_id = ? AND book_id = ? AND listCategory = 1', // Condition to match the correct entry
      whereArgs: [userId, bookId],
    );
  }

  Future<List<Book>> getBooksForUser(int userId) async {
    final db = await database;

    // Query to join 'user_books' and 'books' tables to get books for the user
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id IN (SELECT book_id FROM user_books WHERE user_id = ?)',
      whereArgs: [userId],
    );

    //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<UserBook?> getUserBook(int userId, int bookId) async {
    final db = await SQLService().database; // Access the database

    // Perform the query
    final List<Map<String, dynamic>> result = await db.query(
      'user_books', // Assuming your table is named 'user_books'
      where: 'user_id = ? AND book_id = ?', // Match both user_id and book_id
      whereArgs: [userId, bookId], // Provide values for the placeholders
      limit: 1, // Since only one UserBook can exist for a user-book pair
    );
    return UserBook.fromMap(
        result.first); // Convert the first result into a UserBook
  }

  Future<int> getCurrentPage(int? userId, int? bookId) async {
    final db = await SQLService().database;

    // Query the database for the specific userId and bookId
    final List<Map<String, dynamic>> result = await db.query(
      'user_books',
      columns: ['current_page'], // Only fetch the currentPage column
      where: 'user_id = ? AND book_id = ?',
      whereArgs: [userId, bookId],
    );

    if (result.isNotEmpty) {
      // Return the currentPage if the record exists
      return result.first['current_page'] as int;
    } else {
      // Return null if no record is found
      return 0;
    }
  }

  Future<List<Book>> getBooksCompletedForUser(int? userId) async {
    final db = await database;

    // Query to join 'user_books' and 'books' tables to get books for the user
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where:
          'id IN (SELECT book_id FROM user_books WHERE user_id = ? AND list_category = 2)',
      whereArgs: [userId],
    );

    //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<List<Book>> getBooksReadingForUser(int? userId) async {
    final db = await database;

    // Query to join 'user_books' and 'books' tables to get books for the user
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where:
          'id IN (SELECT book_id FROM user_books WHERE user_id = ? AND list_category = 1)',
      whereArgs: [userId],
    );

    //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<List<Book>> getBooksWishlistForUser(int? userId) async {
    final db = await database;

    // Query to join 'user_books' and 'books' tables to get books for the user
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where:
          'id IN (SELECT book_id FROM user_books WHERE user_id = ? AND list_category = 3)',
      whereArgs: [userId],
    );

    //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<List<Book>> getCommunityReading(int? currentUserId) async {
    final db = await SQLService().database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT books.*, COUNT(user_books.book_id) AS frequency
    FROM user_books
    JOIN books ON user_books.book_id = books.id
    JOIN user_followeduser ON user_books.user_id = user_followeduser.followeduser_id
    WHERE user_followeduser.user_id = ?
    GROUP BY user_books.book_id
    ORDER BY frequency DESC
    LIMIT 10;
  ''', [currentUserId]);

    return results.map((map) => Book.fromMap(map)).toList();
  }

// Get the book associated with a post
  Future<Book> getBooksForPost(int? postId) async {
    final db = await database;

    // Query to get the book_id for the specific post
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'id = ?', // Find the post by its ID
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
    return Book.empty();
  }

// Get the original poster for a post
  Future<User> getPosterForPost(int? postId) async {
    final db = await database;

    // Query to get the originalPoster_id for the specific post
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'id = ?', // Find the post by its ID
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

    return User.empty(); // Return null if no user found
  }

  Future<List<Post>> getPostsForUser(int? userId) async {
    final db = await database;

    // Query to find all posts made by the given user (originalPoster_id)
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'originalPoster_id = ?',
      whereArgs: [userId],
    );

    // If we have matching posts, map them to a list of Post objects
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

// Get the reblogger for a post (this can be null)
  Future<User> getRebloggerForPost(int? postId) async {
    final db = await database;

    // Query to get the reblogger_id for the specific post
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'id = ?', // Find the post by its ID
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

    return User.empty(); // Return null if no reblogger or user found
  }

//*************    User Following     ******************/

  Future<void> followUser(int? userId, int? followedId) async {
    final db = await database;

    await db.insert(
      'user_followeduser',
      {
        'user_id': userId,
        'followeduser_id': followedId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> unfollowUser(int? userId, int? followedId) async {
    final db = await database;

    await db.delete(
      'user_dolloweduser',
      where: 'user_id = ? AND followeduser_id = ?',
      whereArgs: [userId, followedId],
    );
  }

  Future<List<User>> getFollowersForUser(int? userId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where:
          'id IN (SELECT followeduser_id FROM user_followeduser WHERE user_id = ?)',
      whereArgs: [userId],
    );

    //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

//*************    Books in a Pack     ******************/

  Future<void> addBooktoPack(int? packId, int? bookId) async {
    final db = await database;

    await db.insert(
      'pack_books',
      {
        'pack_id': packId,
        'book_id': bookId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeBookfromPack(int packId, int bookId) async {
    final db = await database;

    await db.delete(
      'pack_books',
      where: 'pack_id = ? AND book_id = ?',
      whereArgs: [packId, bookId],
    );
  }

  Future<void> insertUserBook(UserBook userBook) async {
    final db = await database;

    await db.insert(
      'user_books',
      userBook.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserBook(
      int? userId, int? bookId, int? currentPage) async {
    final db = await SQLService().database;

    await db.update(
      'user_books',
      {'current_page': currentPage},
      where: 'user_id = ? AND book_id = ?',
      whereArgs: [userId, bookId],
    );
  }

Future<int> getPagesPerDay(int? userId, String date) async {
  final db = await SQLService().database;

  // Query the database for the specific user_id and date
  final List<Map<String, dynamic>> result = await db.query(
    'pagesPerDay',
    where: 'user_id = ? AND date = ?',
    whereArgs: [userId, date],
  );

  if (result.isEmpty) {
    return 0;
    throw Exception('No data found for user $userId on $date');
  } else {
    // Safely access the first element since we checked if the list is not empty
    return result.first['pages'] as int;
  }
}


  Future<List<Map<DateTime, int>>> getPagesReadThisWeek(int? userId) async {
    final db = await SQLService().database;

    // Get the current date and calculate the date 7 days ago
    final DateTime now = DateTime.now();
    final DateTime oneWeekAgo = now.subtract(Duration(days: 7));

    // Query the pagesPerDay table for the last 7 days for the given user
    final List<Map<String, dynamic>> result = await db.query(
      'pagesPerDay',
      columns: ['date', 'pages'], // Fetch the date and pages columns
      where: 'user_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        userId,
        oneWeekAgo.toString().split(' ')[0], // Format as YYYY-MM-DD
        now.toString().split(' ')[0], // Format as YYYY-MM-DD
      ],
      orderBy: 'date ASC', // Order by date in ascending order
    );

    // Convert the result into a list of DateTime and int pairs
    return result.map((entry) {
      return {
        DateTime.parse(entry['date']): entry['pages'] as int,
      };
    }).toList();
  }

///////// Commands that would work if anything worked

//on create post

/** 

 Post NewPost = Post(
  

)*/

  Future<void> CreatePost(Post post) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> getAllPosts() async {
    final db = await SQLService().database;

    final List<Map<String, dynamic>> result = await db.query('posts');

    return result.map((postMap) => Post.fromMap(postMap)).toList();
  }

  Future<void> ReblogPost(Post post, int? rebloggerId) async {
    final db = await database;
    post.reblogger_id = rebloggerId;
    CreatePost(post);
  }

  Future<List<Book>> topBooksByCity(String? City) async {
    final db = await SQLService().database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT books.*
    FROM books
    JOIN user_books ON books.id = user_books.book_id
    JOIN users ON user_books.user_id = users.id
    WHERE users.currentCity = ?
    GROUP BY books.id
    ORDER BY COUNT(users.id) DESC
    LIMIT 10;
  ''', [City]);

    return result.map((bookMap) => Book.fromMap(bookMap)).toList();
  }

  Future<void> addPagesPerDay(int? userId, int? Pages, String Date) async {
    final db = await SQLService().database;
    PagesPerDay pagesPerDay = PagesPerDay(
      user_id: userId,
      pages: Pages,
      date: Date,
    );

    await db.insert(
      'pagesPerDay', // Table name
      pagesPerDay.toMap(), // Convert the object to a map
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts
    );
  }

  Future<void> updatePagesPerDay(int? id, int? newPages) async {
    final db = await SQLService().database;

    await db.update(
      'pagesPerDay',
      {'pages': newPages}, //Adds new pages to current pages
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> doesPagesPerDayExist(int? userId, String date) async {
    final db = await SQLService().database;

    // Query the table for the specific user and date
    final List<Map<String, dynamic>> result = await db.query(
      'pagesPerDay',
      where: 'user_id = ? AND date = ?', // WHERE clause
      whereArgs: [userId, date], // Arguments for the placeholders
      limit: 1, // Limit to one record for efficiency
    );

    // If the result list is not empty, the record exists
    return result.isNotEmpty;
  }
}

//*************    Classes, Class Mapping     ******************/

//*********    User  **********/

class User {
  final int? id;
  final String username;
  final String? email;
  String? currentCity;
  String? profileImage;
  String? status;
  bool isPacksPrivate;
  bool isReviewsPrivate;
  bool isReadListPrivate;

  static const String defaultProfileImage =
      "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api";

  // User collections
  /**List<User> followedUsers = [];
  List<Post> usersPosts = [];
  List<Review> usersReviews = [];
  List<Pack> usersPacks = [];
  List<Book> readingList = [];
  List<Book> currentList = [];
  List<Book> completedList = []; */

  User({
    this.id,
    required this.username,
    this.email,
    this.currentCity = 'Athens',
    this.profileImage,
    this.status,
    this.isPacksPrivate = false,
    this.isReviewsPrivate = false,
    this.isReadListPrivate = false,
  });

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'currentCity': currentCity,
      'status': status,
      'isPacksPrivate': isPacksPrivate ? 1 : 0,
      'isReviewsPrivate': isReviewsPrivate ? 1 : 0,
      'isReadListPrivate': isReadListPrivate ? 1 : 0,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      profileImage: map['profileImage'],
      currentCity: map['currentCity'],
      status: map['status'],
      isPacksPrivate: map['isPacksPrivate'] == 1,
      isReviewsPrivate: map['isReviewsPrivate'] == 1,
      isReadListPrivate: map['isReadListPrivate'] == 1,
    );
  }

  User.empty()
      : id = null,
        username = '',
        email = '',
        profileImage = '',
        currentCity = '',
        status = '',
        isPacksPrivate = false,
        isReviewsPrivate = false,
        isReadListPrivate = false;

  // Method to toggle the privacy status of the packs
  /**void togglePacksPrivacy() {
    isPacksPrivate = !isPacksPrivate;
  }

  // Method to toggle the privacy status of the completed list
  void toggleReviewsPrivacy() {
    isReviewsPrivate = !isReviewsPrivate;
  }

  // Method to toggle the privacy status of the reading list
  void toggleReadlistPrivacy() {
    isReadListPrivate = !isReadListPrivate;
  }

  // Method to follow a user
  void follow(User user) {
    if (!followedUsers.contains(user)) {
      followedUsers.add(user);
    }
  }

  // Method to unfollow a user
  void unfollow(User user) {
    followedUsers.remove(user);
  }

  // Method to make a post
  void makePost(Post post) {
    usersPosts.add(post);
  }

  // Method to delete a post
  void deletePost(Post post) {
    usersPosts.remove(post);
  }

  // Method to post a review
  void postReview(Review review) {
    usersReviews.add(review);
  }

  // Method to delete a review
  void deleteReview(Review review) {
    usersReviews.remove(review);
  }

  // Method to post a pack
  void postPack(Pack pack) {
    usersPacks.add(pack);
  }

  // Method to delete a pack
  void deletePack(Pack pack) {
    usersPacks.remove(pack);
  }

  // Method to add a book to the reading list
  void addBook(Book book) {
    readingList.add(book);
    book.dateAdded = DateTime.now();
  }

  // Method to remove a book from the reading list
  void removeBook(Book book) {
    readingList.remove(book);
    book.dateAdded = null;
  }

  // Method to add a book to the current reading list
  void addToCurrent(Book book) {
    currentList.add(book);
  }

  // Method to add a book to the completed list
  void addToCompleted(Book book) {
    completedList.add(book);
    readingList.remove(book);
    book.currentPage = 0;
    book.dateCompleted = DateTime.now();
  }

  // Method to change the user's status
  void changeStatus(String newStatus) {
    status = newStatus;
  }

  // Method to add a post to the user's posts list
  void addPost(Post post) {
    usersPosts.add(post);
  }

  // Method to find the page number of a book in the current list
  int pageOfBook(Book bookSent) {
    try {
      // Find the book in the currentList based on the title
      Book selected = currentList.firstWhere(
        (book) => book.title == bookSent.title,
      );
      return selected.currentPage ?? 0;
    } catch (e) {
      // If the book is not found, return 0 or an appropriate default value
      return 0;
    }
  }*/
}

//*********    Book  **********/

class Book {
  final int? id;
  final String title;
  final String publicationDate;
  final String author;
  final String publisher;
  final String posterUrl;
  final String description;
  final String language;
  DateTime? dateAdded;
  DateTime? dateCompleted;
  int totalPages;
  String? genre;

  Book({
    this.id,
    required this.title,
    required this.publicationDate,
    required this.author,
    required this.publisher,
    required this.posterUrl,
    required this.description,
    required this.language,
    this.dateAdded,
    this.dateCompleted,
    required this.totalPages,
    this.genre,
  });

  // Convert Book instance to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'publicationDate': publicationDate,
      'author': author,
      'publisher': publisher,
      'posterUrl': posterUrl,
      'description': description,
      'language': language,
      'dateAdded': dateAdded?.toIso8601String(),
      'dateCompleted': dateCompleted?.toIso8601String(),
      'totalPages': totalPages,
      'genre': genre,
    };
  }

  // Convert a Map to a Book instance (useful for fetching data from the database)
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      publicationDate: map['publicationDate'],
      author: map['author'],
      publisher: map['publisher'],
      posterUrl: map['posterUrl'],
      description: map['description'],
      language: map['language'],
      dateAdded:
          map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
      dateCompleted: map['dateCompleted'] != null
          ? DateTime.parse(map['dateCompleted'])
          : null,
      totalPages: map['totalPages'],
      genre: map['genre'],
    );
  }

  factory Book.empty() {
    return Book(
      title: '',
      description: '',
      genre: '',
      language: '',
      posterUrl:
          'https://tse3.mm.bing.net/th?id=OIP.0fb3mN86pTUI9jvsDmkqgwHaJl&pid=Api',
      totalPages: 0,
      //     currentPage: 0,
      publicationDate: "",
      publisher: "",
      author: "",
    );
  }
}
//*********    Post  **********/

class Post {
  final int? id;
  final int? originalPoster_id;
  int? reblogger_id;
  String? imageUrl;
  String? quote;
  final int? book_id;
  String timePosted;
  int likes, reblogs;

  /// List<String> comments;

  // Constructor
  Post({
    this.id,
    required this.originalPoster_id,
    required this.timePosted,
    this.reblogger_id,
    this.imageUrl,
    this.quote,
    this.book_id,
    this.likes = 0, // Default value for likes
    this.reblogs = 0, // Default value for reblogs
    ///   this.comments = const [], // Default empty list for comments
  });

  Map<String, Object?> toMap() {
    return {
      'originalPosterId': originalPoster_id, // User's ID (int)
      'rebloggerId': reblogger_id, // User's ID (nullable int)
      'imageUrl': imageUrl, // String
      'quote': quote, // String
      'bookId': book_id, // Book's ID (int)
      'timePosted': timePosted, // String representation of DateTime
      'likes': likes, // int
      'reblogs': reblogs, // int
      ///   'comments': comments.join(',')
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      originalPoster_id: map['originalPoster_id'],
      reblogger_id: map['reblogger_id'],
      imageUrl: map['imageUrl'],
      quote: map['quote'],
      book_id: map['book_id'],
      timePosted: map['timePosted'],
      likes: map['likes'],
      reblogs: map['reblogs'],
    );
  }
}

//*********    Review  **********/

class Review {
  final int? id;
  final int? book_id;
  final int? user_id;
  final String text;
  final String reviewDate;
  final int stars;

  Review({
    this.id,
    this.book_id,
    this.user_id,
    required this.text,
    required this.reviewDate,
    required this.stars,
  });
  Map<String, dynamic> toMap() {
    return {
      'book_id': book_id,
      'user_id': user_id,
      'text': text,
      'reviewDate': reviewDate,
      'stars': stars,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as int?, // Nullable field
      book_id: map['book_id'] as int,
      user_id: map['user_id'] as int,
      text: map['text'] as String,
      reviewDate: map['reviewDate'] as String,
      stars: map['stars'] as int,
    );
  }
}
//*******       Comment      ********/

class Comment {
  final int? id;
  final String text;
  final int? post_id;

  Comment({
    this.id,
    required this.text,
    this.post_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'post_id': post_id,
    };
  }

  // Create a Comment object from a map (from database query)
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int?,
      text: map['text'] as String,
      post_id: map['post_id'] as int?,
    );
  }
}

//*********    Pack  **********/

class Pack {
  final int? id;
  final String title;
  final String publicationDate;
  final int? creator_id;
  final String packImage;
  final String description;

  Pack({
    this.id,
    required this.title,
    required this.publicationDate,
    this.creator_id,
    required this.packImage,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'publicationDate': publicationDate,
      'creator_id':
          creator_id, // Assuming 'id' is a property of the 'User' class
      'packImage': packImage,
      'description': description,
    };
  }

  factory Pack.fromMap(Map<String, dynamic> map) {
    return Pack(
      id: map['id'],
      title: map['title'],
      publicationDate: map['publicationDate'],
      creator_id: map['creator_id'],
      packImage: map['packImage'],
      description: map['description'],
    );
  }
}

//*********    Userbook  **********/

class UserBook {
  final int? user_id;
  final int? book_id;
  final int? listCategory; // e.g., 1: Reading, 2: Completed, 3: Want to Read
  final int? currentPage;

  UserBook({
    this.user_id,
    this.book_id,
    this.listCategory,
    this.currentPage,
  });

  // Convert the UserBook object to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id, // The ID of the user
      'book_id': book_id, // The ID of the book
      'list_category':
          listCategory, // The category of the book (e.g., Reading, Completed, etc.)
      'current_page':
          currentPage, // The number of pages the user has read in the book
    };
  }

  factory UserBook.fromMap(Map<String, dynamic> map) {
    return UserBook(
      user_id: map['user_id'],
      book_id: map['book_id'],
      listCategory: map['listCategory'],
      currentPage: map['currentPage'],
    );
  }
}

class PagesPerDay {
  final int? id; // Auto-incrementing primary key
  final int? pages; // Number of pages
  final int? user_id; // Foreign key for user
  final String date; // Date as a string

  PagesPerDay({
    this.id,
    this.pages,
    this.user_id,
    required this.date,
  });

  // Convert a PagesPerDay instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pages': pages,
      'user_id': user_id,
      'date': date,
    };
  }

  // Create a PagesPerDay instance from a map
  factory PagesPerDay.fromMap(Map<String, dynamic> map) {
    return PagesPerDay(
      id: map['id'] as int?,
      pages: map['pages'] as int,
      user_id: map['user_id'] as int,
      date: map['date'] as String,
    );
  }
}

//////////////////////////////////
// Badges class
class Badges {
  final int id; // Unique identifier for the Badges
  final String name;
  final String image;
  final String description;
  final bool requirement;

  Badges({
    required this.id, // Add id as a required field
    required this.name,
    required this.image,
    required this.description,
    required this.requirement,
  });

  // Convert Badges object to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'requirement': requirement,
    };
  }

  // Convert Map to Badges object
  factory Badges.fromMap(Map<String, dynamic> map) {
    return Badges(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      requirement: map['requirement']  == 1,
    );
  }
}

class UserBadge {
  final int id; // Unique identifier for the UserBadge relationship
  final int user_id;
  final int badge_id;

  UserBadge({
    required this.id, // Include the id field here as well
    required this.user_id,
    required this.badge_id,
  });

  // Convert UserBadge object to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include the id field in the map
      'user_id': user_id, // The ID of the user
      'badge_id': badge_id, // The ID of the Badges
    };
  }

  // Convert Map to UserBadge object
  factory UserBadge.fromMap(Map<String, dynamic> map) {
    return UserBadge(
      id: map['id'], // Retrieve the id from the map
      user_id: map['user_id'],
      badge_id: map['badge_id'],
    );
  }
}


/////////
///
///