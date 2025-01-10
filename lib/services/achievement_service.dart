import 'package:sqflite/sqflite.dart';
import 'package:virgil_demo/models/achievement.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';
class AchievementService {
  // Insert a universal Achievement
  static Future<void> insertAchievement(Achievement achievement) async {
    final db = await SQLService.database;
    await db.insert(
      'achievements',
      achievement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all Achievements
  static Future<List<Achievement>> getAllAchievements() async {
    final db = await SQLService.database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    
    return List.generate(maps.length, (i) {
      return Achievement.fromMap(maps[i]);
    });
  }

  // Get User's Achievements
  static Future<List<Achievement>> getUserAchievements(String userId) async {
    final db = await SQLService.database;

    // Get all the user achievements
    final List<Map<String, dynamic>> maps = await db.query(
      'user_achievements',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Get the list of achievement IDs
    List<String> achievementIds = maps.map((map) => map['achievementId'].toString()).toList();

    // Fetch all the achievements with those IDs
    final List<Map<String, dynamic>> achievementMaps = await db.query(
      'achievements',
      where: 'id IN (${achievementIds.join(",")})',
    );

    return List.generate(achievementMaps.length, (i) {
      return Achievement.fromMap(achievementMaps[i]);
    });
  }

  // Assign an achievement to a user (User unlocks the achievement)
  static Future<void> assignAchievementToUser(String userId, String achievementId) async {
    final db = await SQLService.database;

    // Insert the user achievement record
    await db.insert(
      'user_achievements',
      UserAchievement(
        userId: userId,
        achievementId: achievementId,
        unlockedDate: DateTime.now(),
      ).addToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
