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
      return AuthModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      if (e is DioError) {
        if (e.response!.statusCode == 401) {
          final error = jsonDecode(e.response.toString());
          throw ServerException(message: error['message']);
        }
      }
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
      return AuthModel.fromJson(jsonDecode(response.toString()));
    } on DioError catch (e) {
      final errorResponse = json.decode(e.response.toString());
      if (e.response!.statusCode == 422) {
        Map<String, String> errors = errorResponse['errors']
            .map((key, value) => MapEntry(key, value.cast<String>().first))
            .cast<String, String>();
        throw InputException(message: errorResponse['message'], error: errors);
      } else {
        throw ServerException(message: errorResponse['message']);
      }
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
