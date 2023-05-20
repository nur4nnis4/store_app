import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteHandler {
  static const String _databasePath = 'storeapp.db';

  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databasePath);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> deleteStoreAppDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databasePath);
    await closeDatabaseIfExist();
    await deleteDatabase(path);
  }

  Future<void> closeDatabaseIfExist() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        address TEXT,
        phone_number TEXT,
        photo_url TEXT,
        joined_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        id TEXT PRIMARY KEY,
        name TEXT,
        image_url TEXT,
        price REAL,
        quantity INT
      )
    ''');

    await db.execute('''
      CREATE TABLE wishlist (
        id TEXT PRIMARY KEY,
        name TEXT,
        image_url TEXT,
        price REAL,
        sales INT
      )
    ''');
  }
}
