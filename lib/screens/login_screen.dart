import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'bottom_navigation.dart';


final storage = FlutterSecureStorage();


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    // Implement your login logic here (e.g., Firebase Auth or local validation)
    String email = _emailController.text;
    String password = _passwordController.text;



     
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    Map<String, String> allValues = await storage.readAll();

  

    // Check if the entered username exists in storage
    if (allValues.containsKey('email:$email')  && 
    allValues['email:$email'] == email &&
    allValues.containsKey('password:$email') &&
    allValues['password:$email'] == password) {
      // Perform login, navigate to next screen, etc.
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Login Successful')),
      ); 
     // Wait for 2 seconds
     await Future.delayed(Duration(seconds: 2));
     // Navigate to the Home screen

     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (context) => BottomNavWrapper()),
     );
      } else {  
       
       ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Invalid email or password')),

        
      );

    }
    // Navigate to home screen or other pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
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
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
