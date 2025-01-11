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
  late Book packsBook= Book.empty();
  late User packsUser= User.empty();

  Future<void> _getResources() async {
  packsBook = await SQLService().getBookForReview(widget.review.id);
packsUser = await SQLService().getUserForReview(widget.review.id); 

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
                    pack.packImage.isEmpty
                        ? "https://tse3.mm.bing.net/th?id=OIP.n3ng2rUJOu_ceO1NyVChkAHaHa&pid=Api"
                        : pack.packImage,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                
                // pack Title
                Text(
                  pack.title,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                bookScroll("Books in pack", pack.books, currentUser: currentUser),
                
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
                              user: pack.creator,
                              currentUser: currentUser,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        pack.creator.username,
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
                  pack.description,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        context: context, 
        currentUser: currentUser,
      ),
    );
  }
}

