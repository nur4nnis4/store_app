import 'package:flutter/cupertino.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService productService;

  ProductProvider({required this.productService});

  List<ProductModel> _products = [];
  List<ProductModel> _popularProducts = [];

  List<ProductModel> get products => _products;

  List<ProductModel> get popularProducts => _popularProducts;

  ProductModel findById(String id) =>
      _products.firstWhere((element) => element.id == id);

  List<ProductModel> findByCategory(String categoryTitle) => _products
      .where((element) =>
          element.category.toLowerCase().contains(categoryTitle.toLowerCase()))
      .toList();

  List<ProductModel> searchQuery(String query) => _products
      .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  Future<void> uploadProduct(ProductModel productModel) async {
    final product = await productService.createProduct(productModel);

    _products.add(product);

    notifyListeners();
  }

  Future<void> fetchProductsProvider() async {
    _products = await productService.fetchProducts();
  }

  Future<void> fetchPopularProductsProvider() async {
    _popularProducts = await productService.fetchPopularProducts();
  }
}
