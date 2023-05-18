import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  CartModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.price,
      required this.quantity});

  factory CartModel.updateQuantity(CartModel cartModel, int newQuatity) =>
      CartModel(
          id: cartModel.id,
          name: cartModel.name,
          imageUrl: cartModel.imageUrl,
          price: cartModel.price,
          quantity: newQuatity);

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        price: json['price'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'price': price,
        'quantity': quantity,
      };
}
