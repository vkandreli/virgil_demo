import 'package:virgil_demo/SQLService.dart';

class DataSeeder {
  static Future<void> seedDummyData() async {
    final db = await SQLService().database; 

  /**   await db.insert(
    'users',
    {
      'username': 'reader2056',
      'email': 'reader@hotmail.com',
      'profileImage': [],
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
    });*/
      

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
    'currentPage': 0, // Assuming the book hasn't been read.
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
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
    'currentPage': 0,
    'genre': null,
  },
);



/** 
List<UserBook> dummyUserBooks = [
  UserBook(
    userId: 1,
    bookId: 1,  // Assuming this book exists in the 'books' table with id = 1
    listCategory: 1,  // Reading
    pagesRead: 50,
  ),
  UserBook(
    userId: 1,
    bookId: 2,  // Assuming this book exists in the 'books' table with id = 2
    listCategory: 2,  // Completed
    pagesRead: 255,
  ),
  UserBook(
    userId: 1,
    bookId: 3,  // Assuming this book exists in the 'books' table with id = 3
    listCategory: 1,  // Reading
    pagesRead: 120,
  ),
  UserBook(
    userId: 1,
    bookId: 4,  // Assuming this book exists in the 'books' table with id = 4
    listCategory: 3,  // Wishlist
    pagesRead: 0,
  ),
  UserBook(
    userId: 1,
    bookId: 5,  // Assuming this book exists in the 'books' table with id = 5
    listCategory: 2,  // Completed
    pagesRead: 230,
  ),
  UserBook(
    userId: 1,
    bookId: 6,  // Assuming this book exists in the 'books' table with id = 6
    listCategory: 1,  // Reading
    pagesRead: 30,
  ),
  UserBook(
    userId: 1,
    bookId: 7,  // Assuming this book exists in the 'books' table with id = 7
    listCategory: 3,  // Wishlist
    pagesRead: 0,
  ),
  UserBook(
    userId: 1,
    bookId: 8,  // Assuming this book exists in the 'books' table with id = 8
    listCategory: 2,  // Completed
    pagesRead: 150,
  ),
  UserBook(
    userId: 1,
    bookId: 9,  // Assuming this book exists in the 'books' table with id = 9
    listCategory: 1,  // Reading
    pagesRead: 75,
  ),
  UserBook(
    userId: 1,
    bookId: 10,  // Assuming this book exists in the 'books' table with id = 10
    listCategory: 3,  // Wishlist
    pagesRead: 0,
  ),
];

for (var userBook in dummyUserBooks) {
  await SQLService().insertUserBook(userBook);
}

*/
  }
}