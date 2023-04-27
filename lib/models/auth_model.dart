import 'package:flutter/cupertino.dart';
import 'package:store_app/models/user_model.dart';

class AuthModel with ChangeNotifier {
  AuthModel({
    required this.user,
    required this.token,
    required this.tokenType,
  });

  final UserModel user;
  final String token;
  final String tokenType;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        user: UserModel.fromJson(json["user"]),
        token: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "access_token": token,
        "token_type": tokenType,
      };
}
