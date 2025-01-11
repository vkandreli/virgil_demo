import 'package:virgil_demo/models/achievement.dart';
//import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/goal.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/pack.dart';


List<Book> placeholderBooks = [
  Book(
    title: "Book 1",
    publicationDate: "21-03-2003",
    author: "D. P. Author",
    publisher: "Seals",
    posterUrl: "https://tse2.mm.bing.net/th?id=OIP.QaqDrHSrWeTxrJVVkIYl4QHaL2&pid=Api",//"https://via.placeholder.com/150x225?text=Book+1",
    description: "This is a book.",
    totalPages: 255,
  ),
  Book(
    title: "Book 2",
    publicationDate: "01-01-2001",
    author: "A. N. Other",
    publisher: "Seals",
    posterUrl: "https://tse1.mm.bing.net/th?id=OIP.0qxWWiv5uAS-T2OK11jpawHaLZ&pid=Api",//"https://via.placeholder.com/150x225?text=Book+2",
    description: "This is another book.",
    totalPages: 255,
  ),
  Book(
    title: "Book 3",
    publicationDate: "15-05-2010",
    author: "J. K. Writer",
    publisher: "Seals",
    posterUrl: "https://tse4.mm.bing.net/th?id=OIP.su1bQjOBMuzCMUYLxrKI6QHaLH&pid=Api",//"https://via.placeholder.com/150x225?text=Book+3",
    description: "Description for Book 3.",
    totalPages: 255,
  ),
  Book(
    title: "Book 4",
    publicationDate: "12-12-2005",
    author: "L. P. Author",
    publisher: "Seals",
    posterUrl: "https://tse4.mm.bing.net/th?id=OIP._I3mUgPn2UWllDgKSswFrgHaKw&pid=Api",// "https://via.placeholder.com/150x225?text=Book+4",
    description: "Description for Book 4.",
    totalPages: 255,
  ),
  Book(
    title: "Book 5",
    publicationDate: "09-07-2015",
    author: "S. M. Writer",
    publisher: "Seals",
    posterUrl: "https://tse2.mm.bing.net/th?id=OIP.Uo3jYD4LXSfyXc4RqVpmvQHaLH&pid=Api",//"https://via.placeholder.com/150x225?text=Book+5",
    description: "Description for Book 5.",
    totalPages: 255,
  ),
];

List<User> placeholderUsers = [
  User(
    username: "user1",
    password: "password1",
    email: "user1@example.com",
    profileImage: "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",//"https://via.placeholder.com/150?text=User+1", // Custom profile image for user1
    followedUsers: [],
    usersPosts: [],
    //usersReviews: [],
  ),
  User(
    username: "user2",
    password: "password2",
    email: "user2@example.com",
    profileImage:"https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",// "https://via.placeholder.com/150?text=User+2", // Custom profile image for user2
    followedUsers: [],
    usersPosts: [],
    //usersReviews: [],
  ),
  User(
    username: "user3",
    password: "password3",
    email: "user3@example.com",
    profileImage: "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",//null, // No profile image, will use the default
    followedUsers: [],
    usersPosts: [],
    //usersReviews: [],
  ),
  User(
    username: "user4",
    password: "password4",
    email: "user4@example.com",
    profileImage: "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",//"https://via.placeholder.com/150?text=User+4", // Custom profile image for user4
    followedUsers: [],
    usersPosts: [],
    //usersReviews: [],
  ),
  User(
    username: "user5",
    password: "password5",
    email: "user5@example.com",
    profileImage: "https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",//null, // No profile image, will use the default
    followedUsers: [],
    usersPosts: [],
    //usersReviews: [],
  ),
  User(
    username: "user6",
    password: "password6",
    email: "user6@example.com",
    profileImage:"https://tse1.mm.bing.net/th?id=OIP.PKlD9uuBX0m4S8cViqXZHAHaHa&pid=Api",// "https://via.placeholder.com/150?text=User+6", // Custom profile image for user6
    followedUsers: [],
    usersPosts: [],
   // usersReviews: [],
  ),
];

User placeholderSelf = User(
    username: "self",
    password: "password",
    email: "self@example.com",
    profileImage: "https://tse1.mm.bing.net/th?id=OIP.qbGUIKPMpi5kfUsaFS9_QQHaFb&pid=Api",//"https://via.placeholder.com/150?text=Self", // Custom profile image for user6
    followedUsers: [],
    usersPosts: [],
    //usersReviews: [],
    isPacksPrivate: false,
    isReadListPrivate: true,
    isReviewsPrivate: false,
    goals: [
    Goal(name: "Read 10 books this year", isCompleted: false),
    Goal(name: "Complete a book challenge", isCompleted: false),
    Goal(name: "Review 5 books", isCompleted: true),
  ],
  badges: placeholderAchievements,
  );

List<Post> placeholderPosts = [
  Post(
    originalPoster: placeholderUsers[0], // User 1 as the original poster
    reblogger: placeholderUsers[1], // User 2 reblogging
    //imageUrl: "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",//"https://via.placeholder.com/500x300?text=Post+1+Image",
    quote: "This is a quote for Post 1.",
    timePosted: DateTime.now(),
    book: placeholderBooks[0],
      comments: [
        "This book kept me on the edge of my seat!",
        "I figured out the mystery halfway through, but it was still fun!"
      ],
  ),
  Post(
    originalPoster: placeholderUsers[1], // User 2 as the original poster
    reblogger: placeholderSelf, // Self reblogging
    imageUrl: "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",//"https://via.placeholder.com/500x300?text=Post+2+Image",
    quote: "This is a quote for Post 2.",
    timePosted: DateTime.now(),
    book: placeholderBooks[0],      
    comments: [
        "I love this book! The plot twists are amazing.",
        "Totally agree! The ending was unexpected."
      ],
  ),
  Post(
    originalPoster: placeholderUsers[2], // User 3 as the original poster
    //imageUrl: "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",//"https://via.placeholder.com/500x300?text=Post+3+Image",
    quote: "This is a quote for Post 3.",
    timePosted: DateTime.now(),
    book: placeholderBooks[0],
  ),
  Post(
    originalPoster: placeholderUsers[3], // User 4 as the original poster
    reblogger: placeholderUsers[4], // User 5 reblogging
    imageUrl: "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",//"https://via.placeholder.com/500x300?text=Post+4+Image",
    quote: "This is a quote for Post 4.",
    timePosted: DateTime.now(),
    book: placeholderBooks[0],
  ),
  Post(
    originalPoster: placeholderUsers[4], // User 5 as the original poster
    imageUrl:"https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",// "https://via.placeholder.com/500x300?text=Post+5+Image",
    quote: "This is a quote for Post 5.",
    timePosted: DateTime.now(),
    book: placeholderBooks[0],
  ),
  Post(
    originalPoster: placeholderSelf, // User 6 as the original poster
    imageUrl: "https://tse4.mm.bing.net/th?id=OIP.9Fyq76VnYYseoZr8dCayTgHaFO&pid=Api",//"https://via.placeholder.com/500x300?text=Post+6+Image",
    quote: "This is a quote for Post 6.",
    timePosted: DateTime.now(),
    book: placeholderBooks[0],
  ),
];

List<Review> placeholderReviews = [
  Review(
    book: placeholderBooks[0], // Book 1 as the reviewed book
    user: placeholderUsers[0], // User 1 wrote the review
    text: "Amazing book, a must-read for everyone!",
    reviewDate: "01-01-2024",
    stars: 5,
  ),
  Review(
    book: placeholderBooks[1], // Book 2 as the reviewed book
    user: placeholderUsers[1], // User 2 wrote the review
    text: "Good read, but the pacing was a bit slow in the middle.",
    reviewDate: "15-01-2024",
    stars: 4,
  ),
  Review(
    book: placeholderBooks[2], // Book 3 as the reviewed book
    user: placeholderSelf, // User 3 wrote the review
    text: "Not what I expected. The ending was quite disappointing.",
    reviewDate: "22-01-2024",
    stars: 2,
  ),
  Review(
    book: placeholderBooks[3], // Book 4 as the reviewed book
    user: placeholderUsers[3], // User 4 wrote the review
    text: "Excellent plot, captivating characters. Highly recommend!",
    reviewDate: "05-02-2024",
    stars: 5,
  ),
  Review(
    book: placeholderBooks[4], // Book 5 as the reviewed book
    user: placeholderUsers[4], // User 5 wrote the review
    text: "An interesting concept, but the writing felt lacking in some areas.",
    reviewDate: "10-02-2024",
    stars: 3,
  ),
  Review(
    book: placeholderBooks[0], // Book 1 as the reviewed book
    user: placeholderSelf, // Self wrote the review
    text: "Loved it from start to finish. One of the best books I've read this year.",
    reviewDate: "20-02-2024",
    stars: 5,
  ),
];

List<Pack> placeholderPacks = [
  Pack(
    title: 'Adventure Pack',
    publicationDate: '2023-01-01',
    creator: placeholderUsers[0],
    packImage: "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",//'https://via.placeholder.com/200x200',
    description: 'A collection of thrilling adventure novels.',
    books: placeholderBooks.sublist(0, 3), // First 3 books
  ),
  Pack(
    title: 'Mystery Collection',
    publicationDate: '2023-02-01',
    creator: placeholderUsers[1],
    packImage: "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",//'https://via.placeholder.com/200x200',
    description: 'Unravel the mysteries with these gripping novels.',
    books: placeholderBooks.sublist(1, 4), // Books from index 1 to 3
  ),
  Pack(
    title: 'Sci-Fi Essentials',
    publicationDate: '2023-03-01',
    creator: placeholderUsers[2],
    packImage: "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",//'https://via.placeholder.com/200x200',
    description: 'The must-read science fiction books.',
    books: placeholderBooks.sublist(2, 5), // Books from index 2 to 4
  ),
  Pack(
    title: 'Historical Insights',
    publicationDate: '2023-04-01',
    creator: placeholderUsers[3],
    packImage: "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",//'https://via.placeholder.com/200x200',
    description: 'Explore the history with these insightful books.',
    books: placeholderBooks.sublist(3, 5), // Books from index 3 to 5
  ),
  Pack(
    title: 'Fantasy World',
    publicationDate: '2023-05-01',
    creator: placeholderUsers[4],
    packImage: "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",//'https://via.placeholder.com/200x200',
    description: 'Dive into a world of fantasy and magic.',
    books: placeholderBooks.sublist(2, 5), // Last 2 books
  ),
  Pack(
    title: 'Dart Programming Pack',
    publicationDate: '2023-06-01',
    creator: placeholderUsers[5],
    packImage: "https://tse2.mm.bing.net/th?id=OIP.WxuBpk2j4-ugqYvjLb1CLQHaLU&pid=Api",//'https://via.placeholder.com/200x200',
    description: 'Master Dart programming with this collection.',
    books: [placeholderBooks.last], // Only the last book 
  ),
];

List<Achievement> placeholderAchievements = [
  // Achievement(
  //   name: "Bookworm",
  //   image: "https://tse4.mm.bing.net/th?id=OIP.eiLocwrWbByic5SUdjGzuwHaFG&pid=Api",
  //   description: "Read 50 books in your lifetime.",
  //   requirement: (User user) => user.completedList.length >= 50,  // Check if user completed 50 books
  // ),
  // Achievement(
  //   name: "Master Reviewer",
  //   image: "https://tse4.mm.bing.net/th?id=OIP.ZLe41HS2w6xHvOVpIo872AHaHa&pid=Api",
  //   description: "Write 10 thoughtful book reviews.",
  //   requirement: (User user) => user.usersReviews.length >= 10,  // Check if user has 10 reviews
  // ),
  // Achievement(
  //   name: "Social Butterfly",
  //   image: "https://tse3.mm.bing.net/th?id=OIP.DFtDWy0uR7EIRkqvefasXAHaE8&pid=Api",
  //   description: "Follow 20 different users on the platform.",
  //   requirement: (User user) => user.followedUsers.length >= 20,  // Check if user follows 20 users
  // ),
  // Achievement(
  //   name: "Night Owl",
  //   image: "https://via.placeholder.com/150?text=Night+Owl",
  //   description: "Read for 5 hours straight at night.",
  //   requirement: (User user) {
  //     // Check if the user has read 5+ hours in a day between 9 PM and 6 AM
  //     bool hasReadAtNight = user.pagesPerDay.any((entry) {
  //       DateTime date = entry.keys.first;
  //       int pages = entry.values.first;
  //       return date.hour >= 21 || date.hour < 6;  // Between 9 PM and 6 AM
  //     });
  //     return hasReadAtNight && user.pagesPerDay.any((entry) => entry.values.first >= 300);  // 5 hours = 300 pages
  //   },
  // ),
  // Achievement(
  //   name: "Page Turner",
  //   image: "https://via.placeholder.com/150?text=Page+Turner",
  //   description: "Read 100 pages in a day.",
  //   requirement: (User user) {
  //     // Check if the user has read 100 or more pages in a single day
  //     return user.pagesPerDay.any((entry) => entry.values.first >= 100);
  //   },
  // ),
  Achievement(
    name: "Master Reviewer",
    image: "https://tse3.mm.bing.net/th?id=OIP.DFtDWy0uR7EIRkqvefasXAHaE8&pid=Api",
    description: "Write 10 thoughtful book reviews.",
    requirement: true,
  ),
  Achievement(
    name: "Social Butterfly",
    image: "https://tse3.mm.bing.net/th?id=OIP.DFtDWy0uR7EIRkqvefasXAHaE8&pid=Api",
    description: "Follow 20 different users on the platform.",
    requirement: true,
  ),
  Achievement(
    name: "Night Owl",
    image: "https://tse3.mm.bing.net/th?id=OIP.DFtDWy0uR7EIRkqvefasXAHaE8&pid=Api",
    description: "Read for 5 hours straight at night.",
    requirement: true,
  ),
  Achievement(
    name: "Page Turner",
    image: "https://tse3.mm.bing.net/th?id=OIP.DFtDWy0uR7EIRkqvefasXAHaE8&pid=Api",
    description: "Read 100 pages in a day.",
    requirement: true,
  ),

];

Book virgil =  Book(
    title: "Virgil tutorial",
    publicationDate: "01-01-2025",
    author: "Dev Team",
    publisher: "Dev Team",
    posterUrl: "https://tse2.mm.bing.net/th?id=OIP.QaqDrHSrWeTxrJVVkIYl4QHaL2&pid=Api",//"https://via.placeholder.com/150x225?text=Book+1",
    description: "You're only getting started.",
    totalPages: 1,
  );

    List<Map<DateTime, int>> placeholderPagesRead = [
  {DateTime(2025, 1, 8): 50},  // 50 pages read on Jan 1st
  {DateTime(2025, 1, 9): 30},  // 30 pages read on Jan 2nd
  {DateTime(2025, 1, 3): 45},  // 45 pages read on Jan 3rd
  {DateTime(2025, 1, 4): 60},  // 60 pages read on Jan 4th
  {DateTime(2025, 1, 5): 20},  // 20 pages read on Jan 5th
  {DateTime(2025, 1, 6): 80},  // 80 pages read on Jan 6th
  {DateTime(2025, 1, 7): 40},  // 40 pages read on Jan 7th
];