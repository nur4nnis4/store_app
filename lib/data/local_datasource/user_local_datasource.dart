import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/user_model.dart';

class UserLocalDatasource {
  static final UserLocalDatasource instance = UserLocalDatasource._init();
  static Database? _database;
  final _tableName = 'users';

  UserLocalDatasource._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('storeapp.db');
    return _database;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        address TEXT,
        phone_number TEXT,
        photo_url TEXT,
        joined_at TEXT
      )
    ''');
  }

  Future<int> insertOrUpdateUser(UserModel user) async {
    try {
      final db = await instance.database;
      return await db!.insert(
        _tableName,
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<UserModel> getUser() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db!.query(_tableName);
      return UserModel.fromJson(maps.first);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> updateUser(UserModel user) async {
    try {
      final db = await instance.database;
      return await db!.update(
        _tableName,
        user.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> deleteUser() async {
    try {
      final db = await instance.database;
      return await db!.delete(
        _tableName,
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
