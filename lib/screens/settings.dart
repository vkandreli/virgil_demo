import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/screens/bottom_navigation.dart';

class UserSettingsScreen extends StatefulWidget {
  final User currentUser;

  UserSettingsScreen({required this.currentUser});

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late TextEditingController statusController;
  late bool isPacksPrivate = false;
  late bool isReviewsPrivate= false;
  late bool isReadListPrivate= false;
  String? selectedImagePath;
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    statusController = TextEditingController(text: widget.currentUser.status ?? '');
    isPacksPrivate = widget.currentUser.isPacksPrivate;
    isReviewsPrivate = widget.currentUser.isReviewsPrivate;
    isReadListPrivate = widget.currentUser.isReadListPrivate;
  }

  @override
  void dispose() {
    statusController.dispose();
    super.dispose();
  }

  void _removeImage() {
    setState(() {
      selectedImagePath = null;
    });
  }

void _saveSettings() async {
  // Create a new User object with updated values
  User currentUser = User(
    id: widget.currentUser.id, // Keep the current user's ID
    username: widget.currentUser.username, // Keep the current username
    email: widget.currentUser.email, // Keep the current email
    profileImage: selectedImagePath, // Updated profile image path
    status: statusController.text, // Updated status
    currentCity: widget.currentUser.currentCity, // Keep the current city
    isPacksPrivate: isPacksPrivate, // Updated privacy setting for packs
    isReviewsPrivate: isReviewsPrivate, // Updated privacy setting for reviews
    isReadListPrivate: isReadListPrivate, // Updated privacy setting for the read list
  );

  // Update the user in the database
  await SQLService().updateUser(currentUser);

  // Optionally show a confirmation message or save data to database
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Settings saved!'),
  ));

  // Reload the updated user data after saving and pass it back to the previous screen
  User updatedUser = await SQLService().getUserById(widget.currentUser.id);

  // Pop the current screen and pass the updated user data back
  Navigator.pop(context, updatedUser);
}

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image Section
selectedImagePath == null
                  ? ElevatedButton(
                      onPressed: _pickImage,
                      child: Icon(Icons.image),
                    )
                  : Stack(
                      children: [
                        // Display the selected image (fit the width of the screen)
                        Image.file(
                          File(selectedImagePath!),
                          width: double.infinity, // Makes the image fit the width
                          height: 200, // Set a fixed height for the image
                          fit: BoxFit.cover, // Ensures the image maintains its aspect ratio
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: _removeImage,
                          ),
                        ),
                      ],
                    ),
            SizedBox(height: 16.0),

            // Status TextField
            TextFormField(
              
              controller: statusController,
              decoration: InputDecoration(
                labelText: 'Quote',
                 hintText: 'Enter a new favourite quote...',
                border: OutlineInputBorder(), labelStyle: TextStyle(color: AppColors.darkBrown),
              ),
            ),
            SizedBox(height: 16.0),

            // Privacy Settings Section
            SwitchListTile(
              title: Text('Make Packs Private'),
              value: isPacksPrivate,
              onChanged: (bool value) {
                setState(() {
                  isPacksPrivate = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Make Reviews Private'),
              value: isReviewsPrivate,
              onChanged: (bool value) {
                setState(() {
                  isReviewsPrivate = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Make Reading List Private'),
              value: isReadListPrivate,
              onChanged: (bool value) {
                setState(() {
                  isReadListPrivate = value;
                });
              },
            ),
            SizedBox(height: 32.0),

            // Save Button
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Save Changes',style: TextStyle(color: AppColors.darkBrown),),
            ),
          ],
        ),
      ),
        bottomNavigationBar: CustomBottomNavBar(context: context, currentUser: widget.currentUser),    

    );
  }
}
