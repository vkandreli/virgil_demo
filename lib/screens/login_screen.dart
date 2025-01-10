import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/screens/signup_screen.dart';
import 'package:virgil_demo/services/user_service.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/home_screen.dart';
import 'package:virgil_demo/assets/placeholders.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // UserService instance to access database
  final UserService userService = UserService();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    // Initialize UserService (important for setting up the DB)
    userService.init();
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Log username and password
    logger.d("Attempting to login with username: $username");

    if (username.isEmpty || password.isEmpty) {
      logger.e("Username or password is empty.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your username and password')),
      );
      return;
    }

    // Fetch all users from the database and check the credentials
    List<User> users = await userService.getAllUsers();
    logger.d("Fetched ${users.length} users from the database.");

    User? matchingUser = users.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => User.empty(),
    );

    if (matchingUser.username.isEmpty) {
      logger.e("Invalid username or password.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    } else {
      logger.i("Login Successful for username: $username");

      // Successfully logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful')),
      );

logger.i("Navigating to HomeScreen with user: ${matchingUser.username}");

await Future.delayed(Duration(seconds: 2));

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(
      currentUser: matchingUser,
    ),
  ),
);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Username",
              style: TextStyle(color: AppColors.darkBrown, fontSize: 24),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            Text(
              "Password",
              style: TextStyle(color: AppColors.darkBrown, fontSize: 24),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
