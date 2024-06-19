import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'daily_verses_db.db');

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print('Error creating directory: $e');
      }

      // Copy from assets
      ByteData data = await rootBundle.load(join('assets', 'daily_verses_db.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the bytes to the file
      await File(path).writeAsBytes(bytes, flush: true);
    }

    final db = await openDatabase(path);

    // List all tables in the database
    List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    // Print the schema of the verses table if it exists
    try {
      List<Map<String, dynamic>> schema = await db.rawQuery("PRAGMA table_info(verses)");
    } catch (e) {
      print('Error retrieving schema for verses table: $e');
    }

    return db;
  }

  Future<String?> getRandomVerse() async {
    final db = await database;
    try {
      List<Map<String, dynamic>> results = await db.query(
        'verses',
        orderBy: 'RANDOM()',
        limit: 1,
      );

      if (results.isNotEmpty) {
        Map<String, dynamic> verseInfo = results.first;
        String body = verseInfo['body'] ?? "No body available";
        String book = verseInfo['book'] ?? "No book";
        int verseNumber = verseInfo['verse_number'] ?? 0; // Assuming verse_number is an integer

        String formattedVerse = "$body ($book $verseNumber)";
        return formattedVerse;
      }
      return null; // Return null if no verses are found
    } catch (e) {
      print('Error querying the database: $e');
      return null;
    }
  }
}