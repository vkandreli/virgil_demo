import 'package:flutter/material.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/settings.dart';
import 'package:virgil_demo/screens/stats_screen.dart';  

class ProfilePane extends StatelessWidget {
  final User currentUser;
  final User user;
  ProfilePane({required this.user, required this.currentUser});  
  
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
                          user == currentUser? 
                          currentUser.profileImage ?? User.defaultProfileImage:
                          user.profileImage ?? User.defaultProfileImage,
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
                        user.username,
                        style: TextStyle(
                          color: Color(0xFFE4E0E1),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        user.status ?? 'No status available',
                        style: TextStyle(
                          color: Color(0xFFE4E0E1),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (user != currentUser) ...[
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
                if (user == currentUser) ...[
                  Column(children: [
                ElevatedButton(
                  onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatsScreen(currentUser: currentUser,),
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
                            builder: (context) => UserSettingsScreen(currentUser: currentUser,),
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
                _buildStatColumn(user.completedList.length.toString(), 'Books'),
                _buildStatColumn(
                    user.completedList
                        .where((book) {
                          return book.dateCompleted?.year == DateTime.now().year;
                        })
                        .toList()
                        .length
                        .toString(),
                    'This year'),
                _buildStatColumn(user.usersPacks.length.toString(), 'Packs'),
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

