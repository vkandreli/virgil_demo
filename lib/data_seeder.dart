import 'package:virgil_demo/SQLService.dart';

class DataSeeder {
  static Future<void> seedDummyData() async {
    final db = await SQLService().database; 

     await db.insert(
    'users',
    {
      'username': 'reader2056',
      'email': 'reader@hotmail.com',
      'profileImage': null,
      'status': 'Active',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 1,
      'isReadListPrivate': 0,
    });

     await db.insert(
    'users',
    {
      'username': 'user1',
      'email': 'user1@example.com',
      'profileImage': "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",
      'status': 'Offline',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 0,
    });
  
  await db.insert(
    'users',
    {
      'username': 'user2',
      'email': 'user2@example.com',
      'profileImage': "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",
      'status': 'Active',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 1,
      'isReadListPrivate': 0,
    });

  await db.insert(
    'users',
    {
      'username': 'user3',
      'email': 'user3@example.com',
      'profileImage': "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",
      'status': 'Active',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 1,
      'isReadListPrivate': 0,
    });

  await db.insert(
    'users',
    {
      'username': 'user4',
      'email': 'user4@example.com',
      'profileImage': "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",
      'status': 'Active',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 1,
      'isReadListPrivate': 0,
    });


  await db.insert(
    'users',
    {
      'username': 'user5',
      'email': 'user5@example.com',
      'profileImage': "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",
      'status': 'Active',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 1,
      'isReadListPrivate': 0,
    });


     await db.insert(
    'users',
    {
      'username': 'user6',
      'email': 'user6@example.com',
      'profileImage': "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",
      'status': 'Active',
      'isPacksPrivate': 0,
      'isReviewsPrivate': 1,
      'isReadListPrivate': 0,
    });
      

  await db.insert(
  'books',
  {
    'title': 'Book 1',
    'publicationDate': '21-03-2003',
    'author': 'D. P. Author',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.QaqDrHSrWeTxrJVVkIYl4QHaL2&pid=Api',
    'description': 'This is a book.',
    'dateAdded': null, // You can set this to the current date if needed.
    'dateCompleted': null, // You can set this to the current date if needed.
    'totalPages': 255,
    'genre': null, // Can be set to any value.
  },
);

await db.insert(
  'books',
  {
    'title': 'Book 2',
    'publicationDate': '01-01-2001',
    'author': 'A. N. Other',
    'publisher': 'Seals',
    'posterUrl': 'https://tse1.mm.bing.net/th?id=OIP.0qxWWiv5uAS-T2OK11jpawHaLZ&pid=Api',
    'description': 'This is another book.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
  
    'genre': null,
  },
);

await db.insert(
  'books',
  {
    'title': 'Book 3',
    'publicationDate': '15-05-2010',
    'author': 'J. K. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse4.mm.bing.net/th?id=OIP.su1bQjOBMuzCMUYLxrKI6QHaLH&pid=Api',
    'description': 'Description for Book 3.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);

await db.insert(
  'books',
  {
    'title': 'Book 4',
    'publicationDate': '12-12-2005',
    'author': 'L. P. Author',
    'publisher': 'Seals',
    'posterUrl': 'https://tse4.mm.bing.net/th?id=OIP._I3mUgPn2UWllDgKSswFrgHaKw&pid=Api',
    'description': 'Description for Book 4.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);

await db.insert(
  'books',
  {
    'title': 'Book 5',
    'publicationDate': '09-07-2015',
    'author': 'S. M. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api',
    'description': 'Description for Book 5.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);

await db.insert(
  'books',
  {
    'title': 'Book 6',
    'publicationDate': '09-07-2015',
    'author': 'S. M. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api',
    'description': 'Description for Book 5.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);

await db.insert(
  'books',
  {
    'title': 'Book 7',
    'publicationDate': '09-07-2015',
    'author': 'S. M. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api',
    'description': 'Description for Book 5.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);



await db.insert(
  'books',
  {
    'title': 'Book 8',
    'publicationDate': '09-07-2015',
    'author': 'S. M. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api',
    'description': 'Description for Book 5.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);



await db.insert(
  'books',
  {
    'title': 'Book 9',
    'publicationDate': '09-07-2015',
    'author': 'S. M. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api',
    'description': 'Description for Book 5.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);


await db.insert(
  'books',
  {
    'title': 'Book 10',
    'publicationDate': '09-07-2015',
    'author': 'S. M. Writer',
    'publisher': 'Seals',
    'posterUrl': 'https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api',
    'description': 'Description for Book 5.',
    'dateAdded': null,
    'dateCompleted': null,
    'totalPages': 255,
    'genre': null,
  },
);




List<UserBook> dummyUserBooks = [
  UserBook(
    userId: 1,
    bookId: 1,  // Assuming this book exists in the 'books' table with id = 1
    listCategory: 1,  // Reading
    currentPage: 50,
  ),
  UserBook(
    userId: 1,
    bookId: 2,  // Assuming this book exists in the 'books' table with id = 2
    listCategory: 2,  // Completed
    currentPage: 255,
  ),
  UserBook(
    userId: 1,
    bookId: 3,  // Assuming this book exists in the 'books' table with id = 3
    listCategory: 1,  // Reading
    currentPage: 120,
  ),
  UserBook(
    userId: 1,
    bookId: 4,  // Assuming this book exists in the 'books' table with id = 4
    listCategory: 3,  // Wishlist
    currentPage: 0,
  ),
  UserBook(
    userId: 1,
    bookId: 5,  // Assuming this book exists in the 'books' table with id = 5
    listCategory: 2,  // Completed
    currentPage: 230,
  ),
  UserBook(
    userId: 1,
    bookId: 6,  // Assuming this book exists in the 'books' table with id = 6
    listCategory: 1,  // Reading
    currentPage: 30,
  ),
  UserBook(
    userId: 1,
    bookId: 7,  // Assuming this book exists in the 'books' table with id = 7
    listCategory: 3,  // Wishlist
    currentPage: 0,
  ),
  UserBook(
    userId: 1,
    bookId: 8,  // Assuming this book exists in the 'books' table with id = 8
    listCategory: 2,  // Completed
    currentPage: 150,
  ),
  UserBook(
    userId: 1,
    bookId: 9,  // Assuming this book exists in the 'books' table with id = 9
    listCategory: 1,  // Reading
    currentPage: 75,
  ),
  UserBook(
    userId: 1,
    bookId: 10,  // Assuming this book exists in the 'books' table with id = 10
    listCategory: 3,  // Wishlist
    currentPage: 0,
  ),
];

for (var userBook in dummyUserBooks) {
  await SQLService().insertUserBook(userBook);
}







await db.insert('posts', {
  'originalPoster_id': 1,
  'reblogger_id': 2,
  'imageUrl': null,
  'quote': "This is a quote for Post 1.",
  'book_id': 1,
  'timePosted': DateTime.now().toString(),
  'likes': 0,
  'reblogs': 0
});

await db.insert('posts', {
  'originalPoster_id': 2,
  'reblogger_id': 6,
  'imageUrl': "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",
  'quote': "This is a quote for Post 2.",
  'book_id': 1,
  'timePosted': DateTime.now().toString(),
  'likes': 0,
  'reblogs': 0
});

await db.insert('posts', {
  'originalPoster_id': 3,
  'reblogger_id': null,
  'imageUrl': null,
  'quote': "This is a quote for Post 3.",
  'book_id': 1,
  'timePosted': DateTime.now().toString(),
  'likes': 0,
  'reblogs': 0
});

await db.insert('posts', {
  'originalPoster_id': 4,
  'reblogger_id': 5,
  'imageUrl': "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",
  'quote': "This is a quote for Post 4.",
  'book_id': 1,
  'timePosted': DateTime.now().toString(),
  'likes': 0,
  'reblogs': 0
});

await db.insert('posts', {
  'originalPoster_id': 5,
  'reblogger_id': null,
  'imageUrl': "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",
  'quote': "This is a quote for Post 5.",
  'book_id': 1,
  'timePosted': DateTime.now().toString(),
  'likes': 0,
  'reblogs': 0
});

await db.insert('posts', {
  'originalPoster_id': 6,
  'reblogger_id': null,
  'imageUrl': "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",
  'quote': "This is a quote for Post 6.",
  'book_id': 1,
  'timePosted': DateTime.now().toString(),
  'likes': 0,
  'reblogs': 0
});


await db.insert('reviews', {
  'book_id': 1,
  'user_id': 1,
  'text': "Amazing book, a must-read for everyone!",
  'reviewDate': "01-01-2024",
  'stars': 5,
});

await db.insert('reviews', {
  'book_id': 2,
  'user_id': 2,
  'text': "Good read, but the pacing was a bit slow in the middle.",
  'reviewDate': "15-01-2024",
  'stars': 4,
});

await db.insert('reviews', {
  'book_id': 3,
  'user_id': 6, // Assuming placeholderSelf corresponds to user 6
  'text': "Not what I expected. The ending was quite disappointing.",
  'reviewDate': "22-01-2024",
  'stars': 2,
});

await db.insert('reviews', {
  'book_id': 4,
  'user_id': 4,
  'text': "Excellent plot, captivating characters. Highly recommend!",
  'reviewDate': "05-02-2024",
  'stars': 5,
});

await db.insert('reviews', {
  'book_id': 5,
  'user_id': 5,
  'text': "An interesting concept, but the writing felt lacking in some areas.",
  'reviewDate': "10-02-2024",
  'stars': 3,
});

await db.insert('reviews', {
  'book_id': 1,
  'user_id': 6, // Assuming placeholderSelf corresponds to user 6
  'text': "Loved it from start to finish. One of the best books I've read this year.",
  'reviewDate': "20-02-2024",
  'stars': 5,
});


await db.insert('packs', {
  'title': 'Adventure Pack',
  'publicationDate': '2023-01-01',
  'creator_id': 1, // placeholderUsers[0] is User 1
  'packImage': "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",
  'description': 'A collection of thrilling adventure novels.',
});

await db.insert('packs', {
  'title': 'Mystery Collection',
  'publicationDate': '2023-02-01',
  'creator_id': 2, // placeholderUsers[1] is User 2
  'packImage': "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",
  'description': 'Unravel the mysteries with these gripping novels.',
});

await db.insert('packs', {
  'title': 'Sci-Fi Essentials',
  'publicationDate': '2023-03-01',
  'creator_id': 3, // placeholderUsers[2] is User 3
  'packImage': "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",
  'description': 'The must-read science fiction books.',
});

await db.insert('packs', {
  'title': 'Historical Insights',
  'publicationDate': '2023-04-01',
  'creator_id': 4, // placeholderUsers[3] is User 4
  'packImage': "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",
  'description': 'Explore the history with these insightful books.',
});

await db.insert('packs', {
  'title': 'Fantasy World',
  'publicationDate': '2023-05-01',
  'creator_id': 5, // placeholderUsers[4] is User 5
  'packImage': "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",
  'description': 'Dive into a world of fantasy and magic.',
});

await db.insert('packs', {
  'title': 'Dart Programming Pack',
  'publicationDate': '2023-06-01',
  'creator_id': 6, // placeholderUsers[5] is User 6
  'packImage': "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",
  'description': 'Master Dart programming with this collection.',
});

// Adventure Pack (Books 1, 2, 3)
await db.insert('pack_books', {'pack_id': 1, 'book_id': 1});
await db.insert('pack_books', {'pack_id': 1, 'book_id': 2});
await db.insert('pack_books', {'pack_id': 1, 'book_id': 3});

// Mystery Collection (Books 2, 3, 4)
await db.insert('pack_books', {'pack_id': 2, 'book_id': 2});
await db.insert('pack_books', {'pack_id': 2, 'book_id': 3});
await db.insert('pack_books', {'pack_id': 2, 'book_id': 4});

// Sci-Fi Essentials (Books 3, 4, 5)
await db.insert('pack_books', {'pack_id': 3, 'book_id': 3});
await db.insert('pack_books', {'pack_id': 3, 'book_id': 4});
await db.insert('pack_books', {'pack_id': 3, 'book_id': 5});

// Historical Insights (Books 4, 5, 6)
await db.insert('pack_books', {'pack_id': 4, 'book_id': 4});
await db.insert('pack_books', {'pack_id': 4, 'book_id': 5});
await db.insert('pack_books', {'pack_id': 4, 'book_id': 6});

// Fantasy World (Books 3, 4, 5)
await db.insert('pack_books', {'pack_id': 5, 'book_id': 3});
await db.insert('pack_books', {'pack_id': 5, 'book_id': 4});
await db.insert('pack_books', {'pack_id': 5, 'book_id': 5});

// Dart Programming Pack (Book 6)
await db.insert('pack_books', {'pack_id': 6, 'book_id': 6});



await db.insert('user_followeduser', {'user_id': 1, 'followeduser_id': 2});
await db.insert('user_followeduser', {'user_id': 1, 'followeduser_id': 3});
await db.insert('user_followeduser', {'user_id': 1, 'followeduser_id': 4});
await db.insert('user_followeduser', {'user_id': 1, 'followeduser_id': 5});
await db.insert('user_followeduser', {'user_id': 1, 'followeduser_id': 6});

await db.insert('user_followeduser', {'user_id': 2, 'followeduser_id': 1});
await db.insert('user_followeduser', {'user_id': 2, 'followeduser_id': 3});
await db.insert('user_followeduser', {'user_id': 2, 'followeduser_id': 4});
await db.insert('user_followeduser', {'user_id': 2, 'followeduser_id': 5});
await db.insert('user_followeduser', {'user_id': 2, 'followeduser_id': 6});

await db.insert('user_followeduser', {'user_id': 3, 'followeduser_id': 1});
await db.insert('user_followeduser', {'user_id': 3, 'followeduser_id': 2});
await db.insert('user_followeduser', {'user_id': 3, 'followeduser_id': 4});
await db.insert('user_followeduser', {'user_id': 3, 'followeduser_id': 5});
await db.insert('user_followeduser', {'user_id': 4, 'followeduser_id': 5});




  }
}