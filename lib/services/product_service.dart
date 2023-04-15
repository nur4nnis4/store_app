import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_app/core/constants/apiconfig.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/models/product_model.dart';

class ProductService {
  final Dio dio;

  ProductService({required this.dio});

  Future<ProductModel> createProduct(ProductModel productModel) async {
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    try {
      FormData formData = FormData.fromMap(await productModel.toJson());
      Response response = await dio.post('$baseUrl/products', data: formData);
      final Map<String, dynamic> map = jsonDecode(response.toString());
      final Map<String, dynamic> productMap = map['data'];
      return ProductModel.fromJson(productMap);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    dio.options.headers['Accept'] = 'application/json';
    try {
      final Response response = await dio.get('$baseUrl/products');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } catch (e) {
      print(e.toString());

      throw ServerException(message: e.toString());
    }
  }

  Future<ProductModel> fetchProduct(String id) async {
    dio.options.headers['Accept'] = 'application/json';
    try {
      final Response response = await dio.get('$baseUrl/products/$id');

      final Map<String, dynamic> map = jsonDecode(response.toString());
      final Map<String, dynamic> productMap = map['data'];
      return ProductModel.fromJson(productMap);
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
