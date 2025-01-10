import 'package:flutter/material.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/services/user_service.dart';
import 'login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController(); // New field

  // Create an instance of UserService
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    // Initialize UserService (important for setting up the DB)
    userService.init();
  }

  void _signup() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String username = _usernameController.text; // Get username

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Create a new User object
    User newUser = User(
      username: username,
      email: email,
      password: password,
      followedUsers: [],
      usersPosts: [],
      usersReviews: [],
      usersPacks: [],
      readingList: [],
      completedList: [],
      currentList: [],
      pagesPerDay: [],
      badges: [],
      goals: [],
    );

    // Store the user data in the database using the UserService instance
    await userService.addUser(newUser);

    // Perform signup, navigate to login, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup Successful')),
    );

    // Clear the form fields
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _usernameController.clear();

    await Future.delayed(Duration(seconds: 2));

    // Navigate to the Login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController, // Username input
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Signup'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
