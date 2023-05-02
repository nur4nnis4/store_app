import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/upload_product.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);
    Provider.of<ProductProvider>(context, listen: false).fetchPopularProducts();
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsProvider();
    context.read<AuthBloc>().add(GetAuthStatusEvent());

    return PageView(
      controller: controller,
      children: <Widget>[UploadProductScreen(), BottomBarScreen()],
    );
  }
}
