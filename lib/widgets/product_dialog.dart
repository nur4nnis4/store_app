import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/icons.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/widgets/my_button.dart';

class ProductDialog extends StatelessWidget {
  final ProductModel product;
  const ProductDialog({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.contain)),
                  ),
                  Positioned(
                    right: 2,
                    child: MyButton.smallIcon(
                      context: context,
                      icon: mCloseIcon,
                      onPressed: () => Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null,
                    ),
                  )
                ],
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Material(
                        child: Consumer<WishlistProvider>(
                          builder: (_, wishlistProvider, __) => InkWell(
                            onTap: () =>
                                wishlistProvider.addOrRemoveItem(WishlistModel(
                              id: product.id,
                              imageUrl: product.imageUrl,
                              name: product.name,
                              price: product.price,
                              sales: product.sales,
                            )),
                            child: Center(
                              child: wishlistProvider.isInWishList(product.id)
                                  ? Icon(mWishListIconFill,
                                      color: Colors.redAccent)
                                  : Icon(mWishListIcon),
                            ),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(width: 1, thickness: 1),
                    Expanded(
                      flex: 1,
                      child: Material(
                        child: Consumer<CartProvider>(
                          builder: (_, cartProvider, __) => InkWell(
                            onTap: () => cartProvider.addOrRemoveItem(CartModel(
                                id: product.id,
                                imageUrl: product.imageUrl,
                                name: product.name,
                                price: product.price,
                                quantity: 1)),
                            child: Center(
                              child: cartProvider.isInCart(product.id)
                                  ? Icon(mRemoveCartIcon,
                                      color: Theme.of(context).primaryColor)
                                  : Icon(mAddCartIcon),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
