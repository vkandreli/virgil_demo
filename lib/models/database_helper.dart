// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static final _databaseName = "user_database.db";
//   static final _databaseVersion = 1;

//   static final table = 'user_table';
//   static final columnId = '_id';
//   static final columnName = 'name';
//   static final columnEmail = 'email';

//   // Singleton instance
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // The database object
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     // If the database is not yet initialized, initialize it
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // Open or create the database
//   _initDatabase() async {
//     var directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, _databaseName);
//     return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
//   }

//   // Create the table
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE $table (
//         $columnId INTEGER PRIMARY KEY,
//         $columnName TEXT NOT NULL,
//         $columnEmail TEXT NOT NULL
//       )
//     ''');
//   }

//   // Insert a user
//   Future<int> insert(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(table, row);
//   }

//   // Query all users
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }

//   // Query a single user by ID
//   Future<Map<String, dynamic>?> queryRow(int id) async {
//     Database db = await instance.database;
//     var result = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   // Update a user
//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row[columnId];
//     return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//   }

//   // Delete a user
//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
// }
