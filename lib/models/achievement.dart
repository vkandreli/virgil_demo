import 'package:virgil_demo/models/user.dart'; 

class Achievement {
  final String name;
  final String image;
  final String description;
  //final bool Function(User) requirement;  // Requirement as a function
  final bool requirement;
  
  Achievement({
    required this.name,
    required this.image,
    required this.description,
    required this.requirement,  // Takes a function that returns a boolean
  });
}
