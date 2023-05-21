import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_app/core/config/apiconfig.dart';
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
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchProducts(
      {required int limit, int? page, String? orderBy, String? sort}) async {
    try {
      final Response response = await dio.get(
          '$BASE_URL/products?limit=$limit&page=${page ?? 1}&orderBy=${orderBy ?? 'created_at'}&sort=${sort ?? 'asc'}');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    try {
      final Response response =
          await dio.get('$BASE_URL/products/category/$category');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final Response response =
          await dio.get('$BASE_URL/products/search/$keyword');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<ProductModel> fetchProduct(String id) async {
    try {
      final Response response = await dio.get('$BASE_URL/products/$id');

      final Map<String, dynamic> map = jsonDecode(response.toString());
      final Map<String, dynamic> productMap = map['data'];
      return ProductModel.fromJson(productMap);
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<ProductModel>> fetchPopularProducts() async {
    try {
      final Response response = await dio.get('$BASE_URL/products/popular');
      final Map<String, dynamic> array = jsonDecode(response.toString());
      final List<dynamic> list = array['data'];
      return list.map((element) => ProductModel.fromJson(element)).toList();
    } on DioError catch (e) {
      final error = jsonDecode(e.response.toString());
      throw ServerException(message: error['message']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
