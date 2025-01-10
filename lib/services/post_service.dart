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
    _db = await SQLService.database;
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
