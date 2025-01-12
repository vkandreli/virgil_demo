import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/screens/library_screen.dart';
import 'package:virgil_demo/screens/own_profile_screen.dart';
import 'package:virgil_demo/screens/recommendations_screen.dart';
//import 'package:virgil_demo/assets/placeholders.dart';
import 'signup_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'bottom_navigation.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'home_screen.dart';

final storage = FlutterSecureStorage();


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
late User currentUser = User.empty();
  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
     
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your username and password')),
      );
      return;
    }

    Map<String, String> allValues = await storage.readAll();  

    // Check if the entered username exists in storage
    if (allValues.containsKey('username:$username')  && 
    allValues['username:$username'] == username &&
    allValues.containsKey('password:$username') &&
    allValues['password:$username'] == password) {
      // Perform login, navigate to next screen, etc.
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Login Successful')),
      ); 
     // Wait for 2 seconds
     ///await Future.delayed(Duration(seconds: 2));
     // Navigate to the Home screen

if (mounted){
currentUser = await SQLService().getUserByUsername(username);

     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (context) => HomeScreen(currentUser: currentUser,)),
     );
}
      } else {  
        if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Invalid username or password')),

        
      );
        }
    }
    // Navigate to home screen or other pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
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
 //             keyboardType: TextInputType.emailAddress,
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
              child: Text('Login',style: TextStyle(color: AppColors.darkBrown),)
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                
                // Navigate to the signup screen
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupScreen()),
          );
              },
              child: Text('Don\'t have an account? Sign up', style: TextStyle(color: AppColors.darkBrown),)
            ),
          ],
        ),
      ),
    );
  }
}
