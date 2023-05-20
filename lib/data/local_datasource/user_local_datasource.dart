import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/local_datasource/sqflite_handler.dart';
import 'package:store_app/models/user_model.dart';

class UserLocalDatasource extends SQFLiteHandler {
  static final UserLocalDatasource instance = UserLocalDatasource._init();
  final _tableName = 'users';

  UserLocalDatasource._init();

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
