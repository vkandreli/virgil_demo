import 'package:flutter/material.dart';
import 'package:virgil_demo/SQLService.dart';
import 'package:virgil_demo/screens/settings.dart';
import 'package:virgil_demo/screens/stats_screen.dart';  

class ProfilePane extends StatefulWidget {
  final User currentUser;
  final User user;
  // ProfilePane({required this.user, required this.currentUser});  

  ProfilePane(
      {Key? key, required this.user, required this.currentUser}) : super(key: key);

  @override
  _ProfilePaneState createState() => _ProfilePaneState();
}

class _ProfilePaneState extends State<ProfilePane> {
    late List<Book> completedBooks;
    late List<Pack> userPacks;

  Future<void> _getCurrent() async {
  completedBooks = await SQLService().getBooksCompletedForUser(widget.user.id);
  }

    Future<void> _getPacks() async {
  userPacks = await SQLService().getPacksForUser(widget.user.id);
  }
  @override
  void initState() {
    super.initState();
    _getCurrent();  // Initialize the database first
    _getPacks();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
      Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF493628),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // CircleAvatar(
                //   radius: 47.5,
                //   backgroundColor: Color(0xFFD9D9D9),
                //   child: CircleAvatar(                    
                //     radius: 36,
                //     child: Icon(Icons.person)
                //   ),
                // ),
                    IconButton(
                      iconSize: 40,  // This controls the overall size of the IconButton widget
                      icon: CircleAvatar(
                        radius: 40,  // This controls the size of the CircleAvatar (should be half of the IconButton size)
                        backgroundImage: NetworkImage(
                          widget.user == widget.currentUser? 
                          widget.currentUser.profileImage ?? SQLService.defaultProfileImage:
                          widget.user.profileImage ?? SQLService.defaultProfileImage,
                        ),
                      ),
                      onPressed: () {

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         ChangeProfile(currentUser: widget.currentUser),
                    //   ),
                    // );
                  },
                ),
                //SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.username,
                        style: TextStyle(
                          color: Color(0xFFE4E0E1),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.user.status ?? 'No status available',
                        style: TextStyle(
                          color: Color(0xFFE4E0E1),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.user != widget.currentUser) ...[
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Follow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAB886D),
                    foregroundColor: Colors.black,
                    minimumSize: Size(86, 31),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ],
                if (widget.user == widget.currentUser) ...[
                  Column(children: [
                ElevatedButton(
                  onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatsScreen(currentUser: widget.currentUser,),
                          ),
                        );  
                    
                  },
                  child: Text('Stats'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAB886D),
                    foregroundColor: Colors.black,
                    minimumSize: Size(70, 31),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSettingsScreen(currentUser: widget.currentUser,),
                          ),
                        );                    
                  },
                  child: Text('Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAB886D),
                    foregroundColor: Colors.black,
                    minimumSize: Size(70, 31),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ],
                  ),
                ]
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(completedBooks.length.toString(), 'Books'),
                _buildStatColumn(
                completedBooks
                        .where((book) {
                          return book.dateCompleted?.year == DateTime.now().year;
                        })
                        .toList()
                        .length
                        .toString(),
                    'This year'),
                _buildStatColumn(userPacks.length.toString(), 'Packs'),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFFE4E0E1),
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFE4E0E1),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Widget _buildTab(String text) {
  //   return Container(
  //     width: 100,
  //     height: 30,
  //     decoration: BoxDecoration(
  //       color: Color(0xFFD9D9D9),
  //     ),
  //     child: Center(
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 17.87,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

