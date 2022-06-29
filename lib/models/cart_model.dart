import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartModel(
      {this.id = '',
      this.name = '',
      this.imageUrl = '',
      this.price = 0,
      this.quantity = 1});
}
