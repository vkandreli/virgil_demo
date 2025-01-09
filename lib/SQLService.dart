import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'user_database.db'),
    // When the database is first created, create a table to store users.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
       db.execute(
        '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,
         username TEXT NOT NULL, email TEXT NOT NULL, profileImage TEXT, status TEXT, 
         isPacksPrivate INTEGER DEFAULT 0, isReviewsPrivate INTEGER DEFAULT 0, isReadListPrivate INTEGER DEFAULT 0,)''',
      );
       db.execute(
      'CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, year INTEGER)',
      );
       db.execute(
      '''CREATE TABLE user_books(user_id INTEGER,book_id INTEGER, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
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
          FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE''',
    );
       db.execute(
        '''CREATE TABLE reviews (
     id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER NOT NULL, user_id INTEGER NOT NULL,
     text TEXT NOT NULL, reviewDate TEXT NOT NULL, stars INTEGER CHECK(stars >= 0 AND stars <= 10), 
     FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE'''
   );
       db.execute(
      '''CREATE TABLE packs (
      id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, publicationDate TEXT NOT NULL, creator_id INTEGER NOT NULL, 
  packImage TEXT NOT NULL, description TEXT NOT NULL, FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE'''
      );
      return db.execute(
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



/*******     User Setters      ********/

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


}



//*************    Classes, Class Mapping     ******************/

//*********    User  **********/

class User {
  final int? id;
  final String username;
  final String email;
  String? profileImage;
  String? status;
  bool isPacksPrivate;
  bool isReviewsPrivate;
  bool isReadListPrivate;

  User({
    this.id,
    required this.username,
    required this.email,
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
  
}


//*********    Book  **********/


class Book {
  final int? id;
  final String title;
  final String author;
  final int year;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.year,
  });


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author, 
      'year': year,
    };
  }




   static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      year: map['year'],
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