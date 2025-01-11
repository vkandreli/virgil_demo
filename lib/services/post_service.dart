import 'package:sqflite/sqflite.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/services/user_service.dart';
import 'package:virgil_demo/services/book_service.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';

class PostService {
  late Database _db;

  // Initialize the database
  Future<void> init() async {
    logger.d("PostService init started.");
    
    try {
      // Fetch the database instance
      _db = await SQLService.database;
      logger.d("Database initialized successfully in PostService.");
    } catch (e) {
      logger.e("Error initializing database in PostService: $e");
      throw Exception("Failed to initialize the database.");
    }
  }

  // Insert a new post into the database
  Future<void> insertPost(Post post) async {
    final db = await _db;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } 

  // Get a list of all posts
Future<List<Post>> getAllPosts() async {
  final db = await _db;
  final List<Map<String, dynamic>> maps = await db.query('posts');
  List<Post> posts = [];

  // Initialize services
  final bookService = BookService();
  await bookService.init();
  final userService = UserService();
  await userService.init();

  for (var map in maps) {
    try {
      // Log the entire map to see if the 'comments' field is present
      logger.d("Processing map: $map");

      // Retrieve the book associated with the post
      Book book = await bookService.getBookById(map['bookId']) ?? Book.empty();

      // Retrieve the original poster and reblogger
      User originalPoster = await userService.getUserByUsername(map['originalPoster']) ?? User.empty();
      User? reblogger = map['reblogger'] != null
          ? await userService.getUserByUsername(map['reblogger'])
          : null;

      // Check if the book or original poster is empty and handle accordingly
      if (book == Book.empty) {
        logger.e('Error: The "book" associated with the post is empty.');
        continue;  // Skip this post if the book is empty
      }

      if (originalPoster == User.empty) {
        logger.e('Error: The "originalPoster" associated with the post is empty.');
        continue;  // Skip this post if the original poster is empty
      }

      // Log the map again to ensure 'comments' field exists
      logger.d("Map details after user and book retrieval: $map");

      // Check if 'comments' exists and is not null
      if (map['comments'] == null) {
        logger.e('The "comments" field is null in the map!');
      }

      // Create and add the Post object to the list
      posts.add(Post.fromMap(map, book, originalPoster, reblogger));
    } catch (e) {
      logger.e("Error processing post from map: $e");
    }
  }

  return posts;
}


  




  // Get posts by a specific user
  Future<List<Post>> getPostsByUser(String username) async {
    final db = await _db;

    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'originalPoster = ?',
      whereArgs: [username],
    );

    List<Post> posts = [];

    // Initialize services
    final bookService = BookService();
    final userService = UserService();

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

  // Delete a post by ID
  Future<void> deletePost(int postId) async {
    final db = await _db;

    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [postId],
    );
  }
}
