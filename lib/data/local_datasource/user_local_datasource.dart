import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
        username TEXT,
        email TEXT,
        address TEXT,
        phone_number TEXT,
        joined_at TEXT
      )
    ''');
  }

  Future<int> insertUser(UserModel user) async {
    final db = await instance.database;
    return await db!.insert(
      _tableName,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel> getUser() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(_tableName);
    return UserModel.fromJson(maps.first);
  }

  Future<int> updateUser(UserModel user) async {
    final db = await instance.database;
    return await db!.update(
      _tableName,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser() async {
    final db = await instance.database;
    return await db!.delete(
      _tableName,
    );
  }
}
