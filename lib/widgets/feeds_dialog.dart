import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/app_consntants.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/widgets/my_button.dart';

class FeedsDialog extends StatelessWidget {
  final String productId;
  const FeedsDialog({Key? key, this.productId = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<ProductProvider>(context).findById(productId);
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
                            image: NetworkImage(_product.imageUrl),
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
                                wishlistProvider.addAndRemoveItem(WishlistModel(
                              id: _product.id,
                              imageUrl: _product.imageUrl,
                              name: _product.name,
                              price: _product.price,
                              sales: _product.sales,
                            )),
                            child: Center(
                              child: wishlistProvider.isInWishList(productId)
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
                            onTap: () =>
                                cartProvider.addAndRemoveItem(CartModel(
                              id: _product.id,
                              imageUrl: _product.imageUrl,
                              name: _product.name,
                              price: _product.price,
                            )),
                            child: Center(
                              child: cartProvider.isInCart(productId)
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
