import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:virgil_demo/SQLService.dart';

final storage = FlutterSecureStorage();


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _signup() async {
    // Implement your signup logic here (e.g., Firebase Auth)
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      await SQLService().printTable('packs');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
 
    await storage.write(key: 'email:$email', value: _emailController.text);
    await storage.write(key: 'password:$email', value: _passwordController.text);

  
    // Perform signup, navigate to login, etc.
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup Successful')),
    );
       _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    // Navigate to the login screen or home screen
    // Wait for 2 seconds
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
                // Navigate to the login screen
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
