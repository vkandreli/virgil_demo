import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
// import 'package:virgil_demo/assets/placeholders.dart';
//import 'package:virgil_demo/models/pack.dart';
//import 'package:virgil_demo/models/user.dart'; 


class PackSearchScreen extends StatefulWidget {
  final User currentUser;

  PackSearchScreen({required this.currentUser});

  @override
  _PackSearchScreenState createState() => _PackSearchScreenState();
}

class _PackSearchScreenState extends State<PackSearchScreen> {
  late TextEditingController _searchController;
  late List<Pack> filteredPacks= [];
  late List<Pack> userPacks= [];



  Future<void> getUserPacks() async {
    userPacks = await SQLService().getPacksForUser(widget.currentUser.id);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredPacks = []; 
  }

  void _searchPacks() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Fetch packs from the db
      final packs = userPacks;
      setState(() {
        filteredPacks = packs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Packs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Packs',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchPacks, // Trigger the search when "Go" is pressed
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPacks.length,
                itemBuilder: (context, index) {
                  final pack = filteredPacks[index];
                  return ListTile(
                    title: Text(pack.title),
                    onTap: () {
                      // Return the selected pack back to the previous screen
                      Navigator.pop(context, pack);
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