import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/widgets/feeds_product.dart';
import 'package:store_app/widgets/my_badge.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> _productList = productProvider.products;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [MyBadge.cart(context)],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      // body: FeedsProduct(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width) /
              (MediaQuery.of(context).size.width + 184),
          mainAxisSpacing: 8,
          children: List.generate(
            _productList.length,
            (index) => ChangeNotifierProvider.value(
              value: _productList[index],
              child: Center(
                child: FeedsProduct(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
