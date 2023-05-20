import 'package:sqflite/sqflite.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/local_datasource/sqflite_handler.dart';
import 'package:store_app/models/wishlist_model.dart';

class WishlistLocalDatasource extends SQFLiteHandler {
  static final WishlistLocalDatasource instance =
      WishlistLocalDatasource._init();
  final _tableName = 'wishlist';

  WishlistLocalDatasource._init();

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
