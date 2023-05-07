import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_app/core/constants/.apiconfig.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio dio;

  ProductRemoteDatasource({required this.dio});

  Future<ProductModel> createProduct(
      ProductModel productModel, String accessToken) async {
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    try {
      FormData formData = FormData.fromMap(await productModel.toJson());
      Response response = await dio.post('$BASE_URL/products', data: formData);
      final Map<String, dynamic> map = jsonDecode(response.toString());
      final Map<String, dynamic> productMap = map['data'];
      return ProductModel.fromJson(productMap);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final Response response = await dio.get('$BASE_URL/products');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } catch (e) {
      print(e.toString());

      throw ServerException(message: e.toString());
    }
  }

  Future<ProductModel> fetchProduct(String id) async {
    try {
      final Response response = await dio.get('$BASE_URL/products/$id');

      final Map<String, dynamic> map = jsonDecode(response.toString());
      final Map<String, dynamic> productMap = map['data'];
      return ProductModel.fromJson(productMap);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchPopularProducts() async {
    try {
      final Response response = await dio.get('$BASE_URL/products-popular');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
