import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/widgets/feeds_product.dart';
import 'package:store_app/widgets/my_badge.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        child: Consumer<ProductProvider>(
            builder: (_, productProvider, __) => GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.width) /
                      (MediaQuery.of(context).size.width + 184),
                  mainAxisSpacing: 8,
                  children: List.generate(
                    productProvider.products.length,
                    (index) => ChangeNotifierProvider.value(
                      value: productProvider.products[index],
                      child: Center(
                        child: FeedsProduct(),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
