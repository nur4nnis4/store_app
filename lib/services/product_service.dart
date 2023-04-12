import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/product_model.dart';

class ProductService {
  final Dio dio;
  final baseUrl = 'http://127.0.0.1:8080/store-app/public/api';

  ProductService({required this.dio});

  Future<List<ProductModel>> fetchProducts() async {
    dio.options.headers['Accept'] = 'application/json';
    try {
      final Response response = await dio.get('$baseUrl/products');

      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchProduct(String id) async {
    dio.options.headers['Accept'] = 'application/json';
    try {
      final Response response = await dio.get('$baseUrl/products/$id');

      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchPopularProducts() async {
    dio.options.headers['Accept'] = 'application/json';
    try {
      final Response response = await dio.get('$baseUrl/products-popular');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
