import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.photoUrl,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime joinedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        phoneNumber: json["phone_number"],
        photoUrl: json["photo_url"],
        joinedAt: DateTime.parse(json["joined_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "address": address,
        "phone_number": phoneNumber,
        "photo_url": photoUrl,
        "joined_at": joinedAt.toIso8601String(),
      };
}
