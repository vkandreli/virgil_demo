import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';




class SQLService {
  // Singleton instance
  static final SQLService _instance = SQLService._internal();

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
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'user_database.db'),
      onCreate: (db, version) async {
        // Create tables when the database is first created
        await db.execute(
        '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,
         username TEXT NOT NULL, email TEXT, profileImage TEXT, status TEXT, 
         isPacksPrivate INTEGER DEFAULT 0, isReviewsPrivate INTEGER DEFAULT 0, isReadListPrivate INTEGER DEFAULT 0)''',
      );
      await  db.execute(
      '''CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, publicationDate TEXT NOT NULL,
        author TEXT NOT NULL, publisher TEXT NOT NULL,  posterUrl TEXT NOT NULL, description TEXT NOT NULL,
        dateAdded TEXT, dateCompleted TEXT, totalPages INTEGER NOT NULL, genre TEXT)
        ''',
      );
      await  db.execute(
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
       db.execute(
        '''CREATE TABLE reviews (
     id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER NOT NULL, user_id INTEGER NOT NULL,
     text TEXT NOT NULL, reviewDate TEXT NOT NULL, stars INTEGER CHECK(stars >= 0 AND stars <= 5), 
     FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)'''
   );
       db.execute(
      '''CREATE TABLE packs (
      id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, publicationDate TEXT NOT NULL, creator_id INTEGER NOT NULL, 
  packImage TEXT NOT NULL, description TEXT NOT NULL, FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE)'''
      );
       db.execute(
      '''CREATE TABLE pack_books(pack_id INTEGER,book_id INTEGER, FOREIGN KEY (pack_id) REFERENCES packs(id) ON DELETE CASCADE,
         FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE, PRIMARY KEY (pack_id, book_id)
         )
      ''',
    );
  },
    
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
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

    print('All tables dropped successfully');
  }

  Future<void> printUsername(int userId) async {
  // Get a reference to the database
  final db = await SQLService().database;

  // Query the Users table for the user with the given userId
  final List<Map<String, dynamic>> result = await db.query(
    'users',
    columns: ['username'], // Only fetch the username column
    where: 'id = ?',       // Specify the condition
    whereArgs: [userId],   // Pass the userId as an argument
    limit: 1,              // Limit the query to one result
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
  var db = await SQLService().database;  // Get the initialized database
  var tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
  print(tables);  // This will print the names of all the tables in the database
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


 /**   static Future<User> getUserByUsername(String username) async {
    final db = await database;

    // Query the user from the users table where the username matches
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
return User.fromMap(maps.first);
  }*/




Future<dynamic> takeElement(String tableName, String columnName, Map<String, dynamic> whereClause) async {
  final db = await SQLService().database; // Access the database instance
  
  // Build the WHERE clause dynamically
  String whereString = whereClause.keys.map((key) => "$key = ?").join(" AND ");
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
  
static const String defaultProfileImage = "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api";

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

 //*******       Post Setters      ********/


Future<void> insertPost(Post post) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'posts',
      post.toMap(),
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

 Future<List<Review>> getReviewsForUser(int userId) async {

    final db = await database;

   
    final List<Map<String, dynamic>> maps = await db.query(
      'reviews',
        where: 'creator_id = ?',
        whereArgs: [userId],
    );

   //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
    return Review.fromMap(maps[i]);
    });
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

 Future<List<User>> getPacksForUser(int userId) async {

    final db = await database;

   
    final List<Map<String, dynamic>> maps = await db.query(
      'packs',
        where: 'creator_id = ?',
        whereArgs: [userId],
    );

   //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
    return User.fromMap(maps[i]);
    });
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
    return UserBook.fromMap(result.first); // Convert the first result into a UserBook
}


   Future<List<Book>> getBooksCompletedForUser(int? userId) async {

    final db = await database;

    // Query to join 'user_books' and 'books' tables to get books for the user
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
        where: 'id IN (SELECT book_id FROM user_books WHERE user_id = ? AND listCategory = 2)',
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
        where: 'id IN (SELECT book_id FROM user_books WHERE user_id = ? AND listCategory = 1)',
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
        where: 'id IN (SELECT book_id FROM user_books WHERE user_id = ? AND listCategory = 3)',
        whereArgs: [userId],
    );

   //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
    return Book.fromMap(maps[i]);
    });
  }



//*************    User Following     ******************/


   Future<void> followUser(int userId, int followedId) async {
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

Future<void> unfollowUser(int userId, int followedId) async {
    final db = await database;

    await db.delete(
      'user_dolloweduser',
       where: 'user_id = ? AND followeduser_id = ?',
       whereArgs: [userId, followedId],
   );
  }

 Future<List<User>> getFollowersForUser(int userId) async {

    final db = await database;

   
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
        where: 'id IN (SELECT followeduser_id FROM user_followeduser WHERE user_id = ?)',
        whereArgs: [userId],
    );

   //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
    return User.fromMap(maps[i]);
    });
  }







//*************    Books in a Pack     ******************/



  Future<void> addBooktoPack(int packId, int bookId) async {
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

 Future<List<Book>> getBooksForPack(int packId) async {

    final db = await database;

   
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
        where: 'id IN (SELECT book_id FROM pack_books WHERE pack_id = ?)',
        whereArgs: [packId],
    );

   //Choose the form of the list that is returned by the table
    return List.generate(maps.length, (i) {
    return Book.fromMap(maps[i]);
    });
  }

Future<void> insertUserBook(UserBook userBook) async {
  final db = await database;

 
    await db.insert(
      'user_books',         
      userBook.toMap(),      
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
}
Future<void> updateUserBook(UserBook userBook) async {
  final db = await SQLService().database;

  
    await db.update(
      'user_books',                // Table name
      userBook.toMap(),             // Data to update (converted to map)
      where: 'user_id = ? AND book_id = ?',  // WHERE clause (matching user_id and book_id)
      whereArgs: [userBook.user_id, userBook.book_id], // Arguments to replace the placeholders
    );
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








}



//*************    Classes, Class Mapping     ******************/

//*********    User  **********/

class User {
  final int? id;
  final String username;
  final String? email;
  String? profileImage;
  String? status;
  bool isPacksPrivate;
  bool isReviewsPrivate;
  bool isReadListPrivate;

  // User collections
  List<User> followedUsers = [];
  List<Post> usersPosts = [];
  List<Review> usersReviews = [];
  List<Pack> usersPacks = [];
  List<Book> readingList = [];
  List<Book> currentList = [];
  List<Book> completedList = [];

  User({
    this.id,
    required this.username,
    this.email,
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
      status: map['status'],
      isPacksPrivate: map['isPacksPrivate'] == 1,
      isReviewsPrivate: map['isReviewsPrivate'] == 1,
      isReadListPrivate: map['isReadListPrivate'] == 1,
    );
  }

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
      dateAdded: map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
      dateCompleted: map['dateCompleted'] != null ? DateTime.parse(map['dateCompleted']) : null,
      totalPages: map['totalPages'],
      genre: map['genre'],
    );
  }

  factory Book.empty() {
    return Book(
      title: '',
      description: '',
      genre: '',
      posterUrl: 'https://tse3.mm.bing.net/th?id=OIP.0fb3mN86pTUI9jvsDmkqgwHaJl&pid=Api',
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
  final int originalPoster_id;
  User? reblogger_id; 
  String? imageUrl;
  String? quote;
  final int book_id;
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
    required this.book_id,
    this.likes = 0,           // Default value for likes
    this.reblogs = 0,         // Default value for reblogs
 ///   this.comments = const [], // Default empty list for comments   
  });

  Map<String, Object?> toMap(){
    return {
    'originalPosterId': originalPoster_id,  // User's ID (int)
    'rebloggerId': reblogger_id?.id,  // User's ID (nullable int)
    'imageUrl': imageUrl,  // String
    'quote': quote,  // String
    'bookId': book_id,  // Book's ID (int)
    'timePosted': timePosted,  // String representation of DateTime
    'likes': likes,  // int
    'reblogs': reblogs,  // int
 ///   'comments': comments.join(',')
    };
  }

    factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      originalPoster_id: map['originalPoster_id'],
      reblogger_id: map['reblogger_id'] != null ? User.fromMap(map['reblogger_id']) : null,
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
  final int book_id; 
  final int user_id; 
  final String text;
  final String reviewDate;
  final int stars;


  Review({
    this.id,
    required this.book_id,
    required this.user_id,
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
//*********    Pack  **********/


class Pack {
  final int? id;
  final String title;
  final String publicationDate;
  final int creator_id;
  final String packImage;
  final String description;


   Pack({
    this.id,
    required this.title,
    required this.publicationDate,
    required this.creator_id,
    required this.packImage,
    required this.description,
  });


   Map<String, dynamic> toMap() {
    return {
      'title': title,
      'publicationDate': publicationDate,
      'creator_id': creator_id, // Assuming 'id' is a property of the 'User' class
      'packImage': packImage,
      'description': description,
    };
  }
}

//*********    Userbook  **********/

class UserBook {
  final int? user_id;
  final int? book_id;
  final int? listCategory;  // e.g., 1: Reading, 2: Completed, 3: Want to Read
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
      'user_id': user_id,           // The ID of the user
      'book_id': book_id,           // The ID of the book
      'list_category': listCategory, // The category of the book (e.g., Reading, Completed, etc.)
      'current_page': currentPage,      // The number of pages the user has read in the book
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

/////////