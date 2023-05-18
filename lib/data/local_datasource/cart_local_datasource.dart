import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/cart_model.dart';

class CartLocalDatasource {
  static final CartLocalDatasource instance = CartLocalDatasource._init();
  static Database? _database;
  final _tableName = 'cart';

  CartLocalDatasource._init();

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

  Future<int> insertCart(CartModel cart) async {
    try {
      final db = await instance.database;
      return await db!.insert(
        _tableName,
        cart.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<List<CartModel>> getCart() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db!.query(_tableName);
      return maps
          .map((wishlistItem) => CartModel.fromJson(wishlistItem))
          .toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> updateCart(CartModel cart) async {
    try {
      final db = await instance.database;
      return await db!.update(
        _tableName,
        cart.toJson(),
        where: 'id = ?',
        whereArgs: [cart.id],
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  Future<int> deleteCart(String id) async {
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

  Future<int> clearCart() async {
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
