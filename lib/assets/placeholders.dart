import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/models/post.dart';
import 'package:virgil_demo/models/review.dart';
import 'package:virgil_demo/models/pack.dart';


List<Book> placeholderMovies = [
  Book(
    title: "Movie 1",
    publicationDate: "21-03-2003",
    author: "D. P. Author",
    posterUrl: "https://via.placeholder.com/150x225?text=Movie+1",
    description: "This is a book.",
  ),
  Book(
    title: "Movie 2",
    publicationDate: "01-01-2001",
    author: "A. N. Other",
    posterUrl: "https://via.placeholder.com/150x225?text=Movie+2",
    description: "This is another book.",
  ),
  Book(
    title: "Movie 3",
    publicationDate: "15-05-2010",
    author: "J. K. Writer",
    posterUrl: "https://via.placeholder.com/150x225?text=Movie+3",
    description: "Description for Movie 3.",
  ),
  Book(
    title: "Movie 4",
    publicationDate: "12-12-2005",
    author: "L. P. Author",
    posterUrl: "https://via.placeholder.com/150x225?text=Movie+4",
    description: "Description for Movie 4.",
  ),
  Book(
    title: "Movie 5",
    publicationDate: "09-07-2015",
    author: "S. M. Writer",
    posterUrl: "https://via.placeholder.com/150x225?text=Movie+5",
    description: "Description for Movie 5.",
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
    followedUsers: [],
    usersPosts: [],
    usersReviews: [],
  );