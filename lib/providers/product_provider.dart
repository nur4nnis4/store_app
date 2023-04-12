import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/product_service.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
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
    productModel.id = Uuid().v4();

    // final user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   productModel.userId = user.uid;
    //   productModel.id = Uuid().v4();
    //   if (productModel.imageUrl.isNotEmpty) {
    //     final ref = FirebaseStorage.instance
    //         .ref()
    //         .child('productimages')
    //         .child(productModel.id + '.jpg');
    //     await ref
    //         .putFile(File(productModel.imageUrl))
    //         .then((_) async => ref.getDownloadURL())
    //         .then((imageUrl) => productModel.imageUrl = imageUrl)
    //         .catchError((e) {
    //       print(e.toString());
    //     });
    //   }
    //   await FirebaseFirestore.instance
    //       .collection('products')
    //       .doc(productModel.id)
    //       .set(productModel.toJson());
  }

  Future<void> fetchProductsProvider() async {
    ProductService productService = new ProductService(dio: Dio());

    _products = await productService.fetchProducts();
  }

  Future<void> fetchPopularProductsProvider() async {
    ProductService productService = new ProductService(dio: Dio());

    _popularProducts = await productService.fetchPopularProducts();
  }
}
