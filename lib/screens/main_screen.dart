import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/upload_product.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);

    final _authProvider = Provider.of<AuthProvider>(context);
    _authProvider.signInAnonymously();

    final _productsProvider = Provider.of<ProductProvider>(context);
    _productsProvider.fetchProducts();

    return PageView(
      controller: controller,
      children: <Widget>[UploadProductScreen(), BottomBarScreen()],
    );
  }
}
