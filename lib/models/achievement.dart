import 'package:virgil_demo/models/user.dart';
  //final bool Function(User) requirement; 
class Achievement {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String requirement; // e.g. "read 10 books"

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.requirement,
  });

  // Convert Achievement object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'requirement': requirement,
    };
  }

  // Convert Map to Achievement object
  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      requirement: map['requirement'],
    );
  }
}

class UserAchievement {
  final String userId;
  final String achievementId;
  final DateTime unlockedDate;

  UserAchievement({
    required this.userId,
    required this.achievementId,
    required this.unlockedDate,
  });

  // Convert UserAchievement object to Map for database insertion
  Map<String, dynamic> addToMap() {
    return {
      'userId': userId,
      'achievementId': achievementId,
      'unlockedDate': unlockedDate.toIso8601String(),
    };
  }

  // Convert Map to UserAchievement object
  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      userId: map['userId'],
      achievementId: map['achievementId'],
      unlockedDate: DateTime.parse(map['unlockedDate']),
    );
  }
}
