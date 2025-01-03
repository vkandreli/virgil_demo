import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/pack.dart';


List<Book> placeholderBooks = [
  Book(
    title: "Book 1",
    publicationDate: "21-03-2003",
    author: "D. P. Author",
    publisher: "Seals",
    posterUrl: "https://via.placeholder.com/150x225?text=Book+1",
    description: "This is a book.",
  ),
  Book(
    title: "Book 2",
    publicationDate: "01-01-2001",
    author: "A. N. Other",
    publisher: "Seals",
    posterUrl: "https://via.placeholder.com/150x225?text=Book+2",
    description: "This is another book.",
  ),
  Book(
    title: "Book 3",
    publicationDate: "15-05-2010",
    author: "J. K. Writer",
    publisher: "Seals",
    posterUrl: "https://via.placeholder.com/150x225?text=Book+3",
    description: "Description for Book 3.",
  ),
  Book(
    title: "Book 4",
    publicationDate: "12-12-2005",
    author: "L. P. Author",
    publisher: "Seals",
    posterUrl: "https://via.placeholder.com/150x225?text=Book+4",
    description: "Description for Book 4.",
  ),
  Book(
    title: "Book 5",
    publicationDate: "09-07-2015",
    author: "S. M. Writer",
    publisher: "Seals",
    posterUrl: "https://via.placeholder.com/150x225?text=Book+5",
    description: "Description for Book 5.",
  ),
];

List<User> placeholderUsers = [
  User(
    username: "user1",
    password: "password1",
    email: "user1@example.com",
    profileImage: "https://via.placeholder.com/150?text=User+1", // Custom profile image for user1
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  ),
  User(
    username: "user2",
    password: "password2",
    email: "user2@example.com",
    profileImage: "https://via.placeholder.com/150?text=User+2", // Custom profile image for user2
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  ),
  User(
    username: "user3",
    password: "password3",
    email: "user3@example.com",
    profileImage: null, // No profile image, will use the default
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  ),
  User(
    username: "user4",
    password: "password4",
    email: "user4@example.com",
    profileImage: "https://via.placeholder.com/150?text=User+4", // Custom profile image for user4
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  ),
  User(
    username: "user5",
    password: "password5",
    email: "user5@example.com",
    profileImage: null, // No profile image, will use the default
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  ),
  User(
    username: "user6",
    password: "password6",
    email: "user6@example.com",
    profileImage: "https://via.placeholder.com/150?text=User+6", // Custom profile image for user6
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  ),
];

User placeholderSelf = User(
    username: "self",
    password: "password",
    email: "self@example.com",
    profileImage: "https://via.placeholder.com/150?text=Self", // Custom profile image for user6
    followedUsers: placeholderUsers,
    usersPosts: placeholderPosts.where((post) {
      return post.originalPoster == placeholderSelf || post.reblogger == placeholderSelf;
    }).toList(),
    usersReviews: [],
  );

List<Post> placeholderPosts = [
  Post(
    originalPoster: placeholderUsers[0], // User 1 as the original poster
    reblogger: placeholderUsers[1], // User 2 reblogging
    imageUrl: "https://via.placeholder.com/500x300?text=Post+1+Image",
    quote: "This is a quote for Post 1.",
  ),
  Post(
    originalPoster: placeholderUsers[1], // User 2 as the original poster
    reblogger: placeholderSelf, // Self reblogging
    imageUrl: "https://via.placeholder.com/500x300?text=Post+2+Image",
    quote: "This is a quote for Post 2.",
  ),
  Post(
    originalPoster: placeholderUsers[2], // User 3 as the original poster
    imageUrl: "https://via.placeholder.com/500x300?text=Post+3+Image",
    quote: "This is a quote for Post 3.",
  ),
  Post(
    originalPoster: placeholderUsers[3], // User 4 as the original poster
    reblogger: placeholderUsers[4], // User 5 reblogging
    imageUrl: "https://via.placeholder.com/500x300?text=Post+4+Image",
    quote: "This is a quote for Post 4.",
  ),
  Post(
    originalPoster: placeholderUsers[4], // User 5 as the original poster
    imageUrl: "https://via.placeholder.com/500x300?text=Post+5+Image",
    quote: "This is a quote for Post 5.",
  ),
  Post(
    originalPoster: placeholderSelf, // User 6 as the original poster
    imageUrl: "https://via.placeholder.com/500x300?text=Post+6+Image",
    quote: "This is a quote for Post 6.",
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
