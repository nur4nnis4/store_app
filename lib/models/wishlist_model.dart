import 'package:flutter/cupertino.dart';

class WishlistModel with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int sales;

  WishlistModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.price,
      required this.sales});

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        price: json['price'],
        sales: json['sales'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'price': price,
        'sales': sales,
      };
}
