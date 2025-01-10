import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/services/book_service.dart';
import 'package:virgil_demo/services/user_service.dart';
class SQLService {
  static Database? _database;

  // Singleton pattern to get the database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;

    // Delete the old database every time before opening a new one
    await deleteDatabaseFile();  // Delete the old database

    _database = await _initDatabase();  // Initialize a fresh database
    return _database!;
  }

  // Delete the existing database file
  static Future<void> deleteDatabaseFile() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'app.db');
      await deleteDatabase(path);  // Delete the old database
      print('Database deleted.');
    } catch (e) {
      print('Error deleting database: $e');
    }
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app.db');
    
    // Open the database and call onCreate if it's a new database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create tables when the DB is first created
  static Future<void> _onCreate(Database db, int version) async {
    // Create Users Table
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      email TEXT NOT NULL,
      profileImage TEXT,
      status TEXT,
      isPacksPrivate INTEGER,
      isReviewsPrivate INTEGER,
      isReadListPrivate INTEGER
    );
    ''');

    // Create Books Table
    await db.execute('''
    CREATE TABLE books (
      id TEXT PRIMARY KEY,  
      title TEXT NOT NULL,
      publicationDate TEXT NOT NULL,
      authors TEXT NOT NULL,
      publisher TEXT NOT NULL,
      posterUrl TEXT NOT NULL,
      description TEXT NOT NULL,
      language TEXT NOT NULL,
      dateAdded TEXT,
      dateCompleted TEXT,
      totalPages INTEGER NOT NULL,
      currentPage INTEGER,
      genre TEXT,
      reviews TEXT
    );
    ''');

    // Create the Posts Table
    await db.execute('''
    CREATE TABLE posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      reblogger TEXT,
      imageUrl TEXT,
      quote TEXT,
      bookId TEXT,  
      timePosted TEXT NOT NULL,
      likes INTEGER,
      reblogs INTEGER,
      comments TEXT,
      FOREIGN KEY (bookId) REFERENCES books(id)
    );
    ''');

    // Create the Reviews Table
    await db.execute('''
    CREATE TABLE reviews (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bookId TEXT NOT NULL,
      username TEXT NOT NULL,
      text TEXT,
      reviewDate TEXT NOT NULL,
      stars INTEGER NOT NULL,
      FOREIGN KEY (bookId) REFERENCES books(id),
      FOREIGN KEY (username) REFERENCES users(username)
    );
    ''');

    // Create the user_books table
    await db.execute('''
    CREATE TABLE user_books (
      userId INTEGER NOT NULL,
      bookId TEXT NOT NULL,
      status TEXT NOT NULL,  -- e.g. 'reading', 'completed', 'current'
      PRIMARY KEY (userId, bookId),
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (bookId) REFERENCES books(id)
    );
    ''');

    // Create the Packs Table
    await db.execute('''
    CREATE TABLE packs (
      title TEXT PRIMARY KEY,
      publicationDate TEXT NOT NULL,
      creatorId TEXT NOT NULL,
      packImage TEXT NOT NULL,
      description TEXT NOT NULL,
      books TEXT NOT NULL,  
      FOREIGN KEY (creatorId) REFERENCES users(username)
    );
    ''');

    // Create Achievements Table
    await db.execute('''
    CREATE TABLE achievements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      imageUrl TEXT NOT NULL,
      requirement TEXT NOT NULL
    );
    ''');

    // Create User Achievements Table
    await db.execute('''
    CREATE TABLE user_achievements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT NOT NULL,
      achievementId INTEGER NOT NULL,
      unlockedDate TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (achievementId) REFERENCES achievements(id)
    );
    ''');

    // Create Followed Users Table
    await db.execute('''
    CREATE TABLE followed_users (
      userId INTEGER NOT NULL,
      followedUserId INTEGER NOT NULL,
      PRIMARY KEY (userId, followedUserId),
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (followedUserId) REFERENCES users(id)
    );
    ''');

    // Create User Posts Table
    await db.execute('''
    CREATE TABLE user_posts (
      userId INTEGER NOT NULL,
      postId INTEGER NOT NULL,
      PRIMARY KEY (userId, postId),
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (postId) REFERENCES posts(id)
    );
    ''');

    // Create User Reviews Table
    await db.execute('''
    CREATE TABLE user_reviews (
      userId INTEGER NOT NULL,
      reviewId INTEGER NOT NULL,
      PRIMARY KEY (userId, reviewId),
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (reviewId) REFERENCES reviews(id)
    );
    ''');

    // Create User Packs Table
    await db.execute('''
    CREATE TABLE user_packs (
      userId INTEGER NOT NULL,
      packId TEXT NOT NULL,
      PRIMARY KEY (userId, packId),
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (packId) REFERENCES packs(title)
    );
    ''');

    // Create Pages Per Day Table
    await db.execute('''
    CREATE TABLE pages_per_day (
      userId INTEGER NOT NULL,
      date TEXT NOT NULL,
      pagesRead INTEGER NOT NULL,
      PRIMARY KEY (userId, date),
      FOREIGN KEY (userId) REFERENCES users(id)
    );
    ''');

    // Create Badges Table
    await db.execute('''
    CREATE TABLE badges (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      badgeId INTEGER NOT NULL,
      unlockedDate TEXT NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id)
    );
    ''');

    // Create Goals Table
    await db.execute('''
    CREATE TABLE goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      goalText TEXT NOT NULL,
      target INTEGER NOT NULL,
      current INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES users(id)
    );
    ''');
  }

  // Handle database version upgrades
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new tables or make other schema changes as needed
    }
  }

  // Insert Book
  static Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Book by ID
  static Future<Book?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Insert Review
  static Future<void> insertReview(Review review) async {
    final db = await database;
    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

static Future<List<Review>> getReviewsByBookId(String bookId) async {
  final db = await database;

  final bookService = BookService();
  final userService = UserService();

  final List<Map<String, dynamic>> maps = await db.query(
    'reviews',
    where: 'bookId = ?',
    whereArgs: [bookId],
  );
  List<Review> reviews = [];

  for (var map in maps) {
    Book book = await bookService.getBookById(bookId) ?? Book.empty();
    User? user = await userService.getUserByUsername(map['userId']);

    if (user != null) {
      reviews.add(Review.fromMap(map, book, user));
    } else {
      print('User not found for userId: ${map['userId']}');
    }
  }
  return reviews;
}

  // Get Reviews by User
static Future<List<Review>> getReviewsByUsername(String id) async {
  final db = await database;

  // Instantiate UserService
  final userService = UserService();
  final bookService = BookService();

  // Fetch reviews by the id from the 'reviews' table
  final List<Map<String, dynamic>> maps = await db.query(
    'reviews',
    where: 'id = ?',
    whereArgs: [id],
  );

  // Prepare the list to hold all reviews
  List<Review> reviews = [];

  // Iterate through all the reviews and fetch corresponding book and user
  for (var map in maps) {
    // Fetch the book using bookId
    Book book = await bookService.getBookById(map['bookId']) ?? Book.empty();

    // Fetch the user using the id (this can also be the same id passed as argument)
    User user = await userService.getUserByUsername(id) ?? User.empty();

    // Create the Review object and add it to the list
    reviews.add(Review.fromMap(map, book, user));
  }

  return reviews;
}


  // Insert Post
  static Future<void> insertPost(Post post) async {
    final db = await database;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

static Future<List<Post>> getPostsByUsername(String username) async {
    final db = await SQLService.database;

    // Initialize services
    final bookService = BookService();
    final userService = UserService();

    // Fetch posts for the specific user
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'originalPoster = ?',
      whereArgs: [username],
    );

    List<Post> posts = [];

    // Loop through each post and populate the Post object
    for (var map in maps) {
      // Retrieve the book associated with the post
      Book book = await bookService.getBookById(map['bookId']) ?? Book.empty();

      // Retrieve the original poster and reblogger
      User originalPoster = await userService.getUserByUsername(map['originalPoster']) ?? User.empty();
      User? reblogger = map['reblogger'] != null
          ? await userService.getUserByUsername(map['reblogger'])
          : null;

      // Create and add the Post object to the list
      posts.add(Post.fromMap(map, book, originalPoster, reblogger));
    }

    return posts;
  }

  // Get all posts
  static Future<List<Post>> getAllPosts() async {
    final db = await SQLService.database;

    // Initialize services
    final bookService = BookService();
    final userService = UserService();

    // Fetch all posts
    final List<Map<String, dynamic>> maps = await db.query('posts');
    List<Post> posts = [];

    // Loop through each post and populate the Post object
    for (var map in maps) {
      // Retrieve the book associated with the post
      Book book = await bookService.getBookById(map['bookId']) ?? Book.empty();

      // Retrieve the original poster and reblogger
      User originalPoster = await userService.getUserByUsername(map['originalPoster']) ?? User.empty();
      User? reblogger = map['reblogger'] != null
          ? await userService.getUserByUsername(map['reblogger'])
          : null;

      // Create and add the Post object to the list
      posts.add(Post.fromMap(map, book, originalPoster, reblogger));
    }

    return posts;
  }

  // Insert User
  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // // Get User by username
  // static Future<User?> getUserByUsername(String username) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'users',
  //     where: 'username = ?',
  //     whereArgs: [username],
  //   );

  //   if (maps.isNotEmpty) {
  //     return User.fromMap(maps.first);
  //   } else {
  //     return null;
  //   }
  // }

  // Update User
  static Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'username = ?',
      whereArgs: [user.username],
    );
  }

  // Delete User
  static Future<void> deleteUser(String username) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // Delete Post
  static Future<void> deletePost(int postId) async {
    final db = await database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [postId],
    );
  }

  // Delete Book
  static Future<void> deleteBook(int bookId) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // Delete Review
  static Future<void> deleteReview(int reviewId) async {
    final db = await database;
    await db.delete(
      'reviews',
      where: 'id = ?',
      whereArgs: [reviewId],
    );
  }
}
