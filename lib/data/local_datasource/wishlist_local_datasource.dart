import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/wishlist_model.dart';

class WishlistLocalDatasource {
  static final WishlistLocalDatasource instance =
      WishlistLocalDatasource._init();
  static Database? _database;
  final _tableName = 'wishlist';

  WishlistLocalDatasource._init();

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
        image_url TEXT,
        price REAL,
        sales INT,
      )
    ''');
  }

  Future<int> insertWishlist(WishlistModel wishlist) async {
    try {
      final db = await instance.database;
      return await db!.insert(
        _tableName,
        wishlist.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<List<WishlistModel>> getWishlist() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db!.query(_tableName);

      return maps
          .map((wishlistItem) => WishlistModel.fromJson(wishlistItem))
          .toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> updateWishlist(WishlistModel wishlist) async {
    try {
      final db = await instance.database;
      return await db!.update(
        _tableName,
        wishlist.toJson(),
        where: 'id = ?',
        whereArgs: [wishlist.id],
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> deleteWishlist(String id) async {
    try {
      final db = await instance.database;
      return await db!.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> clearWishlist() async {
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
