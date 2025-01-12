import 'package:flutter/material.dart';
// import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/main.dart';
import 'package:virgil_demo/models/goal.dart';
import 'package:virgil_demo/screens/book_presentation.dart';
import 'package:virgil_demo/screens/book_search_screen.dart';
//import 'package:virgil_demo/models/book.dart';
//import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/screens/bottom_navigation.dart';
import 'package:virgil_demo/screens/own_profile_screen.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

import '../SQLService.dart';

class StatsScreen extends StatefulWidget {
  final User currentUser;

  StatsScreen({required this.currentUser});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Helper method to get pages read this week
  /**List<Map<DateTime, int>> getPagesReadThisWeek(
      List<Map<DateTime, int>> pagesPerDay) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    // Filter pages read this week
    return pagesPerDay.where((entry) {
      final date = entry.keys.first;
      return date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          date.isBefore(endOfWeek.add(Duration(days: 1)));
    }).toList();
  }*/
  late List<Book> completedList = [], currentList = [], readingList = [];
  late List<Review> usersReviews = [], bookReviews = [];
  late List<Pack> usersPacks = [];
  late List<Badges> usersBadges = [];
  late List<User> followedUsers = [];
  late int pagesReadToday = 0;
  late List<Map<DateTime, int>> pagesReadThisWeek = [];

  Future<void> _getResources() async {
    completedList =
        await SQLService().getBooksCompletedForUser(widget.currentUser.id);
    currentList =
        await SQLService().getBooksReadingForUser(widget.currentUser.id);
    readingList =
        await SQLService().getBooksWishlistForUser(widget.currentUser.id);
    usersReviews = await SQLService().getReviewsForUser(widget.currentUser.id);
    bookReviews = await SQLService().getReviewsForBook(widget.currentUser.id);
    usersPacks = await SQLService().getPacksForUser(widget.currentUser.id);
    usersBadges = await SQLService().getBadgesForUser(widget.currentUser.id);
    followedUsers =
        await SQLService().getFollowersForUser(widget.currentUser.id);
    pagesReadToday = await SQLService().getPagesPerDay(
        widget.currentUser.id, DateTime.now.toString().split(' ')[0]);
    pagesReadThisWeek =
        await SQLService().getPagesReadThisWeek(widget.currentUser.id);

    // Fetch all available badges from the database
    final allBadges = await SQLService().getAllBadges();

    // Loop through each badge and check if the user meets the requirements
    for (var badge in allBadges) {
      bool requirementMet =
          await checkBadgeRequirement(widget.currentUser.id, badge);

      if (requirementMet) {
        // If the requirement is met, add the badge to the user
        await SQLService().addBadgeToUser(widget.currentUser.id, badge.id);
      }
    }
    setState(() {});
  }

  Future<bool> checkBadgeRequirement(int? userId, Badges badge) async {
    if (badge.name == "Master Reviewer") {
      // Check if the user has written 10 reviews
      return usersReviews.length >= 10;
    }

    if (badge.name == "Social Butterfly") {
      // Check if the user has followed 20 users
      int followedUsersCount = followedUsers.length;
      return followedUsersCount >= 1;
    }

    if (badge.name == "Page Turner") {
      // Check if the user has read 100 pages in a day
      //  int pagesReadToday = await SQLService().getPagesReadToday(userId);
      return pagesReadToday >= 100;
    }

    if (badge.name == "Book Worm") {
      return pagesReadToday >= 500;
    }

    if (badge.name == "Multilingual Reader") {
      return completedList.map((book) => book.language).toSet().length >= 3;
    }

    if (badge.name == "Polyglot Reader") {
      return completedList.map((book) => book.language).toSet().length >= 5;
    }
    return false;
  }

  String _generateGoalProgressText(User user) {
    // Define the list of goals
    List<Goal> goals = [
      Goal(
        name: 'Read 10 books',
        requirement: (User user) => completedList.length >= 10,
        userChoseThis: (User user) =>
            true, //user.selectedGoals.contains('Read 10 books'),
        getProgress: (User user) => '${completedList.length}/10',
      ),
      Goal(
        name: 'Read 5 Greek books',
        requirement: (User user) =>
            completedList
                .where((book) => book.language == 'gr')
                .toList()
                .length >=
            5,
        userChoseThis: (User user) =>
            true, //user.selectedGoals.contains('Read 5 Greek books'),
        getProgress: (User user) =>
            '${completedList.where((book) => book.language == 'gr').toList().length}/5',
      ),
      Goal(
        name: 'Read 500 pages in a day',
        requirement: (User user) => pagesReadToday >= 500,
        userChoseThis: (User user) => true,
        getProgress: (User user) => '${pagesReadToday}/500',
      ),
    ];

    // Generate the list of progress strings
    return goals
        .where((goal) =>
            goal.userChoseThis(user)) // Filter for goals the user chose
        .map((goal) =>
            '${goal.name} (${goal.getProgress(user)})') // Format the goal with progress
        .join('\n'); // Join the goals into a single string with newlines
  }

  @override
  void initState() {
    super.initState();
    _getResources();
  }

  @override
  Widget build(BuildContext context) {
    // Get pages read this week
    //   final pagesReadThisWeek =
    //       getPagesReadThisWeek(widget.currentUser.pagesPerDay);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mediumBrown, // SafeArea background color
        body: Column(
          children: [
            // Top row for search and profile navigation (Fixed header)
            Row(
              children: [
//                 IconButton(
//                   icon: Icon(Icons.search),
// onPressed: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => BookDetailScreen(
//         book: BookSearchScreen(), // This seems like it should be a book object, not the screen
//         currentUser: widget.currentUser, // Pass the currentUser directly from widget
//       ),
//     ),
//   );
// },
//                 ),
                Spacer(), // To push the profile picture to the right
                IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.currentUser.profileImage ??
                            User.defaultProfileImage),
                  ),
                  onPressed: () {
                    // Navigate to the user's profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OwnProfileScreen(currentUser: widget.currentUser),
                      ),
                    );
                  },
                ),
                SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 16),

            // Main content wrapped in SingleChildScrollView to avoid overflow
            Expanded(
              child: SingleChildScrollView(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        color: AppColors.lightBrown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pane Title
                              Container(
                                color: AppColors.darkBrown,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Text('Pages Read This Week',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 200,
                                width: double.infinity,
                                child: CustomPaint(
                                  painter: PagesReadBarChart(pagesReadThisWeek),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Books Completed Section (Should remain fixed)
                    GestureDetector(
                      onTap: () {
                        // Navigate to a more detailed Pages Read Screen
                      },
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        color: AppColors.lightBrown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pane Title
                              Container(
                                color: AppColors.darkBrown,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Text("Books You've Finished",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              SizedBox(height: 8),
                              if (completedList.isEmpty) ...[
                                //                              bookScroll(
                                //   '',
                                //   <Book> [virgil],
                                //   isCompleted: false,
                                //   widget.currentUser: widget.currentUser,
                                // ),
                                Text(
                                    "You have not finished any books yet. Try adding pages",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.darkBrown)),
                              ],
                              if (completedList.isNotEmpty) ...[
                                bookScroll(
                                  '',
                                  completedList,
                                  isCompleted: true,
                                  currentUser: widget.currentUser,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Goals Section
                    GestureDetector(
                      onTap: () {
                        // Navigate to Goals screen
                      },
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        color: AppColors.lightBrown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pane Title
                              Container(
                                color: AppColors.darkBrown,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Text("Goals",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              // Display the goals with progress
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Text(
                                  _generateGoalProgressText(widget.currentUser),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Badges Section
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        color: AppColors.lightBrown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pane Title
                              Container(
                                color: AppColors.darkBrown,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Text("Badges You've Earned",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              badgeScroll(
                                "",
                                usersBadges,
                                currentUser: widget.currentUser,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
            context: context, currentUser: widget.currentUser),
      ),
    );
  }
}

class PagesReadBarChart extends CustomPainter {
  final List<Map<DateTime, int>> pagesReadPerDay; // Data: pages read per day
  final List<int> pagesPerDayList; // A list of total pages read each day

  PagesReadBarChart(this.pagesReadPerDay)
      : pagesPerDayList = _getPagesReadThisWeek(pagesReadPerDay);

  // Helper function to calculate pages read per day
  static List<int> _getPagesReadThisWeek(
      List<Map<DateTime, int>> pagesReadPerDay) {
    List<int> pagesPerDayList = List.filled(7, 0);

    for (var dayData in pagesReadPerDay) {
      for (var entry in dayData.entries) {
        DateTime date = entry.key;
        int pages = entry.value;

        // Map the days to their index (Mon = 0, ..., Sun = 6)
        int dayIndex = date.weekday - 1; // Weekday returns 1 for Monday
        pagesPerDayList[dayIndex] += pages;
      }
    }

    return pagesPerDayList;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkBrown
      ..style = PaintingStyle.fill;

    final labelStyle = TextStyle(fontSize: 12, color: Colors.black);

    final maxPages = pagesPerDayList.isEmpty
        ? 1
        : pagesPerDayList.reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / 7; // Divide available width by 7 for each day
    final barHeightFactor =
        size.height / maxPages; // Scale bars based on max pages read

    // Draw bars
    for (int i = 0; i < pagesPerDayList.length; i++) {
      final pages = pagesPerDayList[i];
      final barHeight = pages == 0 ? 1.0 : pages * barHeightFactor;

      final xPosition = i * barWidth;
      final yPosition = size.height - barHeight;

      // Draw the number of pages read on top of the bar
      final textPainter = TextPainter(
        text: TextSpan(
          text: pages.toString(),
          style: labelStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xPosition + (barWidth - textPainter.width) / 2,
            yPosition - 20), // Center the text above the bar
      );

      // Draw the bar
      canvas.drawRect(
        Rect.fromLTWH(xPosition + (barWidth - textPainter.width) / 2, yPosition,
            barWidth * 0.3, barHeight), // Adjust width for space between bars
        paint,
      );
    }

    // Draw days of the week
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < dayNames.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: dayNames[i],
          style: labelStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(i * barWidth + (barWidth / 2) - (textPainter.width / 2),
            size.height), // Positioning below the bar
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
