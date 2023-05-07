import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_app/core/constants/.apiconfig.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/user_model.dart';

class UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasource({required this.dio});

  Future<UserModel> updateUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      Response response =
          await dio.patch('$BASE_URL/register', data: {'name': name});
      Map<String, dynamic> responseJson = jsonDecode(response.toString());
      return UserModel.fromJson(responseJson['user']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<UserModel> fetchUser(
      {required String id, required String accessToken}) async {
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    try {
      Response response = await dio.get('$BASE_URL/users-account/$id');
      Map<String, dynamic> responseJson = jsonDecode(response.toString());
      return UserModel.fromJson(responseJson['data']);
    } on DioError catch (e) {
      throw ServerException(
          message: jsonDecode(e.response.toString())['message']);
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
