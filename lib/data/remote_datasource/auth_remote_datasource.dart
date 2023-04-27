import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_app/core/constants/.apiconfig.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/auth_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  Future<AuthModel> login(
      {required String email, required String password}) async {
    try {
      Response response = await dio
          .post('$baseUrl/login', data: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        return AuthModel.fromJson(jsonDecode(response.toString()));
      } else
        throw ServerException(message: response.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<AuthModel> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      Response response = await dio.post('$baseUrl/register',
          data: {'email': email, 'password': password, 'name': name});
      if (response.statusCode == 201) {
        return AuthModel.fromJson(jsonDecode(response.toString()));
      } else
        throw ServerException(message: response.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<void> signOut(String token) async {
    try {
      await dio.get(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
