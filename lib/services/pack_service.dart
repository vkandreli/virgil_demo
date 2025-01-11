import 'package:sqflite/sqflite.dart';
import 'package:virgil_demo/models/pack.dart';
import 'package:virgil_demo/models/book.dart';
import 'package:virgil_demo/models/user.dart';
import 'package:virgil_demo/sqlbyvoulina.dart';

class PackService {
  late Database _db;

  // Initialize the database
  Future<void> init() async {
    _db = await SQLService.database;
  }

  // Add a new pack to the database
  Future<void> addPack(Pack pack) async {
    final db = await _db;

    // Insert the pack into the 'packs' table
    await db.insert(
      'packs',
      pack.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all packs from the database
  Future<List<Pack>> getAllPacks(List<Book> allBooks, List<User> allUsers) async {
    final db = await _db;
    final List<Map<String, dynamic>> packMaps = await db.query('packs');

    List<Pack> packs = [];

    for (var map in packMaps) {
      User creator = allUsers.firstWhere((user) => user.username == map['creatorId']);
    //  List<Book> packBooks = map['books'].map<Book>((bookId) => allBooks.firstWhere((book) => book.id == bookId)).toList();
      
      packs.add(Pack.fromMap(map, allBooks, creator));
    }

    return packs;
  }

  // Get a pack by its title
  Future<Pack?> getPackByTitle(String title, List<Book> allBooks, List<User> allUsers) async {
    final db = await _db;

    // Fetch the pack from the 'packs' table
    final List<Map<String, dynamic>> packMaps = await db.query(
      'packs',
      where: 'title = ?',
      whereArgs: [title],
    );

    if (packMaps.isNotEmpty) {
      Map<String, dynamic> map = packMaps.first;
      User creator = allUsers.firstWhere((user) => user.username == map['creatorId']);
    //  List<Book> packBooks = map['books'].map<Book>((bookId) => allBooks.firstWhere((book) => book.id == bookId)).toList();

      return Pack.fromMap(map, allBooks, creator);
    }

    return null; // Return null if no pack is found with that title
  }

  // Update a pack
  Future<void> updatePack(Pack pack) async {
    final db = await _db;

    // Update the pack in the 'packs' table
    await db.update(
      'packs',
      pack.toMap(),
      where: 'title = ?',
      whereArgs: [pack.title],
    );
  }

  // Delete a pack by its title
  Future<void> deletePack(String title) async {
    final db = await _db;

    // Delete the pack from the 'packs' table
    await db.delete(
      'packs',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
