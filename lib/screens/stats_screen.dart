import 'package:flutter/material.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/own_profile_screen.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class StatsScreen extends StatelessWidget {
  final User currentUser;

  StatsScreen({required this.currentUser});

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stats'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Search functionality for stats, to be implemented
              },
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.profileImage ?? User.defaultProfileImage),
              ),
              onPressed: () {
                // Navigate to the user's profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OwnProfileScreen(currentUser: currentUser),
                  ),
                );
              },
            ),
            SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Pages Read - Daily Steps bar
              GestureDetector(
                onTap: () {
                  // Navigate to a more detailed Pages Read Screen
                },
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Pages Read', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          height: 200,
                          child: CustomPaint(
                            painter: PagesReadBarChart(currentUser.pagesPerDay),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Books Completed Section
              GestureDetector(
                onTap: () {
                  // Navigate to Books Completed screen
                },
                child: bookScroll(
                  "Books you've finished",
                  currentUser.completedList,
                  isCompleted: true,
                  currentUser: currentUser,
                ),
              ),
              SizedBox(height: 16),

              // Goals Section
              GestureDetector(
                onTap: () {
                  // Navigate to Goals screen
                },
                child: genericScroll(
                  title: 'Goals',
                  items: currentUser.goals.take(3).toList(), // Display only up to 3 goals
                  itemBuilder: (context, goal) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(goal.name ?? 'Unnamed Goal'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Badges Section
              GestureDetector(
                onTap: () {
                  // Navigate to Badges screen
                },
                child: genericScroll(
                  title: 'Badges',
                  items: currentUser.badges,
                  itemBuilder: (context, badge) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 2.0,
                      child: Column(
                        children: [
                          Image.network(badge.image, width: 50, height: 50),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(badge.name),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class PagesReadBarChart extends CustomPainter {
  final List<Map<DateTime, int>> pagesPerDay;

  PagesReadBarChart(this.pagesPerDay);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    double barWidth = size.width / pagesPerDay.length;

    for (int i = 0; i < pagesPerDay.length; i++) {
      DateTime date = pagesPerDay[i].keys.first;
      int pages = pagesPerDay[i].values.first;

      double barHeight = pages.toDouble();

      canvas.drawRect(
        Rect.fromLTWH(i * barWidth, size.height - barHeight, barWidth - 5, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


