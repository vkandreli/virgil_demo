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
import 'package:logger/logger.dart'; // Import logger package
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Create a logger instance
final logger = Logger();

class SQLService {
  static Database? _database;

  // Singleton pattern to get the database instance
  static Future<Database> get database async {
    if (_database != null) {
      logger.d('Returning existing database instance');
      return _database!;
    }

    // Delete the old database every time before opening a new one
    logger.d('Initializing fresh database');
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
      logger.i('Database deleted at path: $path');
    } catch (e) {
      logger.e('Error deleting database: $e');
    }
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'app.db');
      logger.d('Opening database at path: $path');
    
      // Open the database and call onCreate if it's a new database
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      logger.e('Error initializing database: $e');
      rethrow;
    }
  }

  // Create tables when the DB is first created
  static Future<void> _onCreate(Database db, int version) async {
    logger.d('Creating tables in the database');
    try {
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
logger.i('Users table created');
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
logger.i('Books table created');
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
logger.i('Posts table created');
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
logger.i('Reviews table created');
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
logger.i('user_books table created');
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
logger.i('packs table created');

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
logger.i('achievements table created');

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
logger.i('user_achievements table created');

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
logger.i('followed_users table created');

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
logger.i('user_posts table created');

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
logger.i('user_reviews table created');

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
logger.i('user_packs table created');

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
logger.i('pages table created');

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
logger.i('bades table created');

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
    logger.i('goals table created');

        await _populateDatabaseWithPlaceholderData(db);
  
      
    } catch (e) {
      logger.e('Error creating tables: $e');
    }
  }
 
 // Populate the database with some placeholder data (users, books, posts, etc.)
  static Future<void> _populateDatabaseWithPlaceholderData(Database db) async {
    try {
      // Insert placeholder users
      await db.insert('users', {
        'username': 'john_doe',
        'password': 'password123',
        'email': 'john.doe@example.com',
        'profileImage': 'https://tse1.mm.bing.net/th?id=OIP.qbGUIKPMpi5kfUsaFS9_QQHaFb&pid=Api',
        'status': 'active',
        'isPacksPrivate': 0,
        'isReviewsPrivate': 0,
        'isReadListPrivate': 0,
      });

      await db.insert('users', {
        'username': 'jane_smith',
        'password': 'password456',
        'email': 'jane.smith@example.com',
        'profileImage': 'https://tse1.mm.bing.net/th?id=OIP.qbGUIKPMpi5kfUsaFS9_QQHaFb&pid=Api',
        'status': 'active',
        'isPacksPrivate': 1,
        'isReviewsPrivate': 0,
        'isReadListPrivate': 1,
      });

      // Insert placeholder books
      await db.insert('books', {
        'id': 'book1',
        'title': 'The Great Adventure',
        'publicationDate': '2025-01-01',
        'authors': 'John Doe',
        'publisher': 'FictionHouse',
        'posterUrl': 'https://tse3.mm.bing.net/th?id=OIP.14V5hQxRbt9aRYag58fEKAHaLG&pid=Api',
        'description': 'A thrilling adventure story.',
        'language': 'English',
        'dateAdded': '2025-01-10',
        'dateCompleted': '',
        'totalPages': 300,
        'currentPage': 1,
        'genre': 'Adventure',
        'reviews': '[]',
      });

      // Insert placeholder posts
      await db.insert('posts', {
        'username': 'john_doe',
        'reblogger': '',
        'imageUrl': 'https://tse2.mm.bing.net/th?id=OIP.bbQY0YPgSSvAxVQ4dp_dnwHaFj&pid=Api',
        'quote': 'An inspiring quote.',
        'bookId': 'book1',
        'timePosted': '2025-01-10T12:00:00',
        'likes': 10,
        'reblogs': 5,
        'comments': '[]',
      });

      await db.insert('posts', {
        'username': 'jane_smith',
        'reblogger': 'john_doe',
        'imageUrl': 'https://tse2.mm.bing.net/th?id=OIP.bbQY0YPgSSvAxVQ4dp_dnwHaFj&pid=Api',
        'quote': 'Another inspiring quote.',
        'bookId': 'book1',
        'timePosted': '2025-01-10T12:30:00',
        'likes': 15,
        'reblogs': 7,
        'comments': '[]',
      });

      print('Placeholder data inserted.');
    } catch (e) {
      print('Error inserting placeholder data: $e');
    }
  }
  
  // Handle database version upgrades
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new tables or make other schema changes as needed
    }
  }

  Future<List<User>> getAllUsers() async {
      final userService = UserService();
return userService.getAllUsers();
    // await _checkDbInitialized(); // Ensure database is initialized

    // final List<Map<String, dynamic>> userMaps = await _db!.query('users');
    // List<User> users = [];

    // for (var userMap in userMaps) {
    //   final userId = userMap['id'];
    //   final List<Map<String, dynamic>> userBooks = await _db!.rawQuery('''
    //     SELECT books.*, user_books.status
    //     FROM books
    //     JOIN user_books ON books.id = user_books.bookId
    //     WHERE user_books.userId = ?
    //   ''', [userId]);

    //   List<Book> readingList = [];
    //   List<Book> completedList = [];
    //   List<Book> currentList = [];

    //   for (var map in userBooks) {
    //     Book book = Book.fromMap(map);

    //     switch (map['status']) {
    //       case 'reading':
    //         readingList.add(book);
    //         break;
    //       case 'completed':
    //         completedList.add(book);
    //         break;
    //       case 'current':
    //         currentList.add(book);
    //         break;
    //     }
    //   }

    //   users.add(User.fromMap(userMap, readingList, completedList, currentList));
    // }

    // return users;
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
