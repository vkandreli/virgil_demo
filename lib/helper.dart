/**import 'package:virgil_demo/SQLService.dart';


  late List<Book> completedList, currentList, readingList;
  late List<Review> usersReviews, bookReviews;
  late List<Pack> usersPacks;
  late List<Badges> usersBadges = [];
  late List<User> followedUsers =[];
  Future<void> _getResources() async {
    completedList =
        await SQLService().getBooksCompletedForUser(widget.currentUser.id);
    currentList =
        await SQLService().getBooksReadingForUser(widget.currentUser.id);
    readingList =
        await SQLService().getBooksWishlistForUser(widget.currentUser.id);
    usersReviews = await SQLService().getReviewsForUser(widget.currentUser.id);
    bookReviews = await SQLService().getReviewsForBook(widget.currentUser.id);
    usersPacks = await SQLService().getPacksForUser(widget.currentUser.id);
    usersBadges = await SQLService().getBadgesForUser(widget.currentUser.id);
    followedUsers = await SQLService().getFollowersForUser(widget.currentUser.id);
  }



Future<bool> checkBadgeRequirement(int userId, Badges badge) async {
  if (badge.name == "Master Reviewer") {
    return usersReviews.length >= 10; // Requirement is met if the user has 10 or more reviews
  }
  if (badge.name == "Social Butterfly") {
  
    int followedUsersCount = followedUsers.length;
    return followedUsersCount >= 20;
  }
  if (badge.name == "Page Turner"){

  }
  // Add more badge requirements here as needed
  return false;
}

// Future<bool> _showBadgeRequirements(int userId) async {
//   List<Badges> badges = await SQLService().getAllBadges();

//   // Check the requirement for each badge
//   for (var badge in badges) {
//     bool requirementMet = await checkBadgeRequirement(userId, badge);

// return requirementMet;
//   }

// }


/** 
Future<List<Review>> getReviewsForUser(int userId) async {
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


Future<List<Review>> getReviewsForBook(int bookId) async {
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








////////////////////////

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

///////////////////////////
Future<List<Book>> getBooksForPack(int packId) async {
  final db = await database;

  // Query to find the book with the specific bookId
  final List<Map<String, dynamic>> maps = await db.query(
    'packs',
    where: 'id = ?',  // Filter by the book's ID
    whereArgs: [packId],  // Pass the bookId to the query
  );

  if (maps.isNotEmpty) {
    // If a book is found, return the first book (there should only be one with the same ID)
    return List.generate(maps.length, (i) {
    return Book.fromMap(maps[i]);
    });  } else {
    // If no book is found, return a default empty book or handle the case appropriately
    throw Exception("Pack not found with ID $packId");
  }
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

Future<User> getUserForPack(int packId) async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query(
    'packs',
    where: 'id = ?', 
    whereArgs: [packId], 
  );

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  } else {
    throw Exception("Pack not found with ID $packId");
  }
}

////////////////////////////////////////////


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
       goals = [];*/*/
