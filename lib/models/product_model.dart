import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel with ChangeNotifier {
  String id;
  String name;
  double price;
  String brand;
  String description;
  String imageUrl;
  String category;
  int quantity;
  int sales;
  bool isPopular;
  String userId;

  ProductModel(
      {this.id = '',
      this.name = '',
      this.price = 0,
      this.brand = '',
      this.description = '',
      this.imageUrl = '',
      this.category = '',
      this.quantity = 0,
      this.sales = 0,
      this.isPopular = false,
      this.userId = ''});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
