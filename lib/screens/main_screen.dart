import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/user_data_provider.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/upload_product.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);
    Provider.of<ProductProvider>(context, listen: false).fetchPopularProducts();
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsProvider();
    Provider.of<AuthProvider>(context, listen: false).getLocalToken();
    Provider.of<AuthProvider>(context, listen: false).getLocalUserId();

    return PageView(
      controller: controller,
      children: <Widget>[UploadProductScreen(), BottomBarScreen()],
    );
  }
}
