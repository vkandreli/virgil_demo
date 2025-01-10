import 'package:flutter/material.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/others_profile_screen.dart';
import 'package:virgil_demo/services/user_service.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';

class ProfileSearchScreen extends StatefulWidget {
  final User currentUser;

  ProfileSearchScreen({required this.currentUser});

  @override
  _ProfileSearchScreenState createState() => _ProfileSearchScreenState();
}

class _ProfileSearchScreenState extends State<ProfileSearchScreen> {
  late TextEditingController _searchController;
  late List<User> filteredProfiles;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredProfiles = []; 
  }

// Fetch all users from the database
Future<List<User>> _fetchUsers() async {
  try {
    // Use the UserService to fetch all users from the database
    final userService = UserService();
    await userService.init();  // Make sure the database is initialized
    final List<User> users = await userService.getAllUsers();  // Fetch users with categorized books
    return users;
  } catch (e) {
    // Handle error (e.g., show a message or return an empty list)
    print('Error fetching users: $e');
    return [];
  }
}

  void _searchProfiles() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Fetch users from the database and filter them based on the search query
      final allUsers = await _fetchUsers();
      final results = allUsers.where((user) {
        return user.username.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredProfiles = results;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Profiles',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchProfiles,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredProfiles.length,
                      itemBuilder: (context, index) {
                        final user = filteredProfiles[index];
                        return ListTile(
                          title: Text(user.username),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtherProfileScreen(
                                  user: user,
                                  currentUser: widget.currentUser, 
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        context: context,
        currentUser: widget.currentUser,
      ),
    );
  }
}
