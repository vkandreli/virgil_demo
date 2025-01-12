import 'package:virgil_demo/SQLService.dart';

class Goal {
  final String name;
  final bool Function(User) requirement;
  final bool Function(User) userChoseThis;
  final String Function(User) getProgress;  // Function to return the goal's progress as a string

  Goal({
    required this.name,
    required this.requirement,
    required this.userChoseThis,
    required this.getProgress,
  });
}
