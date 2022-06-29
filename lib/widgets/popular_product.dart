import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/app_consntants.dart';
import 'package:store_app/constants/route_name.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/utils/ui/my_snackbar.dart';
import 'package:store_app/widgets/my_badge.dart';
import 'package:store_app/widgets/my_button.dart';

class PopularProduct extends StatelessWidget {
  const PopularProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _popularProduct = Provider.of<ProductModel>(context, listen: false);

    return Card(
      elevation: 0.6,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, RouteName.productDetailScreen,
            arguments: _popularProduct.id),
        child: Container(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(_popularProduct.imageUrl),
                            fit: BoxFit.contain,
                          )),
                    ),
                    MyBadge.quarterCircle('Top', context)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _popularProduct.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'Sales ${_popularProduct.sales.toString()}',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<CartProvider>(
                            builder: (_, cartProvider, __) =>
                                MyButton.smallIcon(
                              context: context,
                              icon: cartProvider.isInCart(_popularProduct.id)
                                  ? mRemoveCartIcon
                                  : mAddCartIcon,
                              color: Colors.deepPurple,
                              onPressed: cartProvider
                                      .isInCart(_popularProduct.id)
                                  ? () {
                                      cartProvider
                                          .removeFromCart(_popularProduct.id);
                                      new MySnackBar().showSnackBar(
                                          'Removed from cart', context);
                                    }
                                  : () {
                                      cartProvider.addAndRemoveItem(CartModel(
                                          id: _popularProduct.id,
                                          imageUrl: _popularProduct.imageUrl,
                                          name: _popularProduct.name,
                                          price: _popularProduct.price));
                                      new MySnackBar().showSnackBar(
                                          'Added to cart', context);
                                    },
                            ),
                          ),
                          Consumer<WishlistProvider>(
                            builder: (_, wishlistProvider, __) =>
                                MyButton.smallIcon(
                              context: context,
                              icon: wishlistProvider
                                      .isInWishList(_popularProduct.id)
                                  ? mWishListIconFill
                                  : mWishListIcon,
                              color: wishlistProvider
                                      .isInWishList(_popularProduct.id)
                                  ? Colors.redAccent
                                  : Theme.of(context).unselectedWidgetColor,
                              onPressed: () {
                                wishlistProvider.addAndRemoveItem(WishlistModel(
                                  id: _popularProduct.id,
                                  imageUrl: _popularProduct.imageUrl,
                                  name: _popularProduct.name,
                                  price: _popularProduct.price,
                                  sales: _popularProduct.sales,
                                ));
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
