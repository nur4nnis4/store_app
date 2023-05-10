import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:store_app/core/config/apiconfig_example.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/auth_model.dart';

class AuthRemoteDatasource {
  final Dio dio;
  final GoogleSignIn googleSignIn;

  AuthRemoteDatasource({required this.dio, required this.googleSignIn});

  Future<AuthModel> login(
      {required String email, required String password}) async {
    try {
      Response response = await dio.post('$BASE_URL/login',
          data: {'email': email, 'password': password});
      return AuthModel.fromJson(jsonDecode(response.toString()));
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<AuthModel> continueWithGoogle() async {
    try {
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        Response response = await dio.post('$BASE_URL/google-auth',
            data: {'access_token': googleAuth.accessToken});
        return AuthModel.fromJson(jsonDecode(response.toString()));
      } else {
        throw ServerException(message: 'Oops something went wrong !');
      }
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<AuthModel> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      Response response = await dio.post('$BASE_URL/register',
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
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      }
      await dio.get(
        '$BASE_URL/logout',
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
