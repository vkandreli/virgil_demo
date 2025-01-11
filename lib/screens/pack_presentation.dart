import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
//import 'package:virgil_demo/models/pack.dart';
//import 'package:virgil_demo/models/user.dart'; 
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/others_profile_screen.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class PackDetailScreen extends StatefulWidget {
  final Pack pack;
  final User currentUser;
  const PackDetailScreen({Key? key, required this.pack, required this.currentUser}) : super(key: key);

  @override
  _PackDetailScreenState createState() => _PackDetailScreenState();
}

class _PackDetailScreenState extends State<PackDetailScreen> {
  late List<Book> packsBook= [];
  late User creator = User.empty();

  Future<void> _getResources() async {
  packsBook = await SQLService().getBooksForPack(widget.pack.id);
  creator = await SQLService().getUserForPack(widget.pack.id); 

  }



  @override
  void initState() {
    super.initState();
    _getResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Make the body scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // pack poster image
                Center(
                  child: Image.network(
                    widget.pack.packImage.isEmpty
                        ? "https://tse3.mm.bing.net/th?id=OIP.n3ng2rUJOu_ceO1NyVChkAHaHa&pid=Api"
                        : widget.pack.packImage,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                
                // pack Title
                Text(
                  widget.pack.title,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                bookScroll("Books in pack", widget.pack.books, currentUser: widget.currentUser),
                
                // Created by section with clickable username
                Row(
                  children: [
                    Text(
                      "Created by: ",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfileScreen(
                              user: creator,
                              currentUser: widget.currentUser,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        creator.username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBrown,
                        ),
                      ),
                    ),
                  ],
                ),

                // Description section
                Text(
                  "Description: ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.pack.description,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        context: context, 
        currentUser: widget.currentUser,
      ),
    );
  }
}

