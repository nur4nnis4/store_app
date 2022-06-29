// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    brand: json['brand'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
    category: json['category'] as String,
    quantity: json['quantity'] as int,
    sales: json['sales'] as int,
    isPopular: json['isPopular'] as bool,
    userId: json['userId'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'brand': instance.brand,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'quantity': instance.quantity,
      'sales': instance.sales,
      'isPopular': instance.isPopular,
      'userId': instance.userId,
    };
