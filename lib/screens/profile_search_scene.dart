import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/user.dart';


class ProfileSearchScreen extends StatefulWidget {
  //final String query;

  //ProfileSearchScreen({required this.query});

  @override
  _ProfileSearchScreenState createState() => _ProfileSearchScreenState();
}

class _ProfileSearchScreenState extends State<ProfileSearchScreen> {
  late TextEditingController _searchController;
  late List<User> filteredProfiles;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredProfiles = []; 
  }

  void _searchProfiles() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Fetch users from the db
      final users = placeholderUsers;
      setState(() {
        filteredProfiles = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Profiles')),
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
              onPressed: _searchProfiles, // Trigger the search when "Go" is pressed
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) {
                  final user = filteredProfiles[index];
                  return ListTile(
                    title: Text(user.username),
                    onTap: () {
                      // Return the selected user back to the previous screen
                      Navigator.pop(context, user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}