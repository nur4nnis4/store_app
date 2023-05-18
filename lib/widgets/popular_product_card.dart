import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/icons.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/widgets/custom_snackbar.dart';
import 'package:store_app/widgets/my_badge.dart';
import 'package:store_app/widgets/my_button.dart';

class PopularProductCard extends StatelessWidget {
  final ProductModel popularProduct;
  const PopularProductCard({Key? key, required this.popularProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.6,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, RouteName.productDetailScreen,
            arguments: popularProduct),
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
                            image: NetworkImage(popularProduct.imageUrl),
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
                        popularProduct.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'Sales ${popularProduct.sales.toString()}',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<CartProvider>(
                            builder: (_, cartProvider, __) =>
                                MyButton.smallIcon(
                              context: context,
                              icon: cartProvider.isInCart(popularProduct.id)
                                  ? mRemoveCartIcon
                                  : mAddCartIcon,
                              color: Colors.deepPurple,
                              onPressed: cartProvider
                                      .isInCart(popularProduct.id)
                                  ? () {
                                      cartProvider
                                          .removeFromCart(popularProduct.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              CustomSnackbar.snackbarAlert(
                                                  context,
                                                  content:
                                                      'Removed from cart'));
                                    }
                                  : () {
                                      cartProvider.addOrRemoveItem(CartModel(
                                          id: popularProduct.id,
                                          imageUrl: popularProduct.imageUrl,
                                          name: popularProduct.name,
                                          price: popularProduct.price,
                                          quantity: 1));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              CustomSnackbar.snackbarAlert(
                                                  context,
                                                  content: 'Added to cart'));
                                    },
                            ),
                          ),
                          Consumer<WishlistProvider>(
                            builder: (_, wishlistProvider, __) =>
                                MyButton.smallIcon(
                              context: context,
                              icon: wishlistProvider
                                      .isInWishList(popularProduct.id)
                                  ? mWishListIconFill
                                  : mWishListIcon,
                              color: wishlistProvider
                                      .isInWishList(popularProduct.id)
                                  ? Colors.redAccent
                                  : Theme.of(context).unselectedWidgetColor,
                              onPressed: () {
                                wishlistProvider.addOrRemoveItem(WishlistModel(
                                  id: popularProduct.id,
                                  imageUrl: popularProduct.imageUrl,
                                  name: popularProduct.name,
                                  price: popularProduct.price,
                                  sales: popularProduct.sales,
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
