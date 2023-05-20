import 'package:sqflite/sqflite.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/local_datasource/sqflite_handler.dart';
import 'package:store_app/models/cart_model.dart';

class CartLocalDatasource extends SQFLiteHandler {
  static final CartLocalDatasource instance = CartLocalDatasource._init();

  final _tableName = 'cart';
  CartLocalDatasource._init();

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
      return maps.map((cartItem) => CartModel.fromJson(cartItem)).toList();
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
