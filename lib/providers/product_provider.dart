import 'package:store_app/models/product_model.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/providers/custom_notifier.dart';

class ProductProvider extends CustomNotifier {
  final ProductRemoteDatasource productRemoteDatasource;

  ProductProvider({required this.productRemoteDatasource});

  final String getProductsTask = 'getProductsTask';
  final String uploadProductTask = 'uploadProductTask';
  final String getPopularProductsTask = 'getPopularProductsTask';

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

  Future<void> uploadProduct(
      ProductModel productModel, String accessToken) async {
    try {
      final product = await productRemoteDatasource.createProduct(
          productModel, accessToken);
      _products.add(product);
      setStatus(uploadProductTask, Status.Done);
    } catch (e) {
      setStatus(uploadProductTask, Status.Error);
    }
    notifyListeners();
  }

  Future<void> fetchProductsProvider() async {
    try {
      _products = await productRemoteDatasource.fetchProducts();
      setStatus(getProductsTask, Status.Done);
    } catch (e) {
      setStatus(getProductsTask, Status.Error);
    }
    notifyListeners();
  }

  Future<void> fetchPopularProducts() async {
    try {
      _popularProducts = await productRemoteDatasource.fetchPopularProducts();
      setStatus(getPopularProductsTask, Status.Done);
    } catch (e) {
      setStatus(getPopularProductsTask, Status.Error);
    }
    notifyListeners();
  }
}
