import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/icons.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/widgets/custom_snackbar.dart';
import 'package:store_app/widgets/my_badge.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _bottomSheet(widget.product),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            flexibleSpace: FlexibleSpaceBar(
                background: Container(
              child: Hero(
                tag: widget.product.id,
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            )),
            actions: [MyBadge.cart(context)],
          ),
          SliverToBoxAdapter(
              child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Product Name

                          Text(
                            widget.product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          SizedBox(height: 10),

                          //Product Price

                          Text(
                            '\$ ${widget.product.price}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Product sales and Wishlist Button

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Sales ${widget.product.sales}'),
                              Consumer<WishlistProvider>(
                                builder: (_, wishlistProvider, __) =>
                                    IconButton(
                                  onPressed: () {
                                    wishlistProvider
                                        .addOrRemoveItem(WishlistModel(
                                      id: widget.product.id,
                                      imageUrl: widget.product.imageUrl,
                                      name: widget.product.name,
                                      price: widget.product.price,
                                      sales: widget.product.sales,
                                    ));
                                  },
                                  icon: wishlistProvider
                                          .isInWishList(widget.product.id)
                                      ? Icon(
                                          mWishListIconFill,
                                          color: Colors.redAccent,
                                        )
                                      : Icon(mWishListIcon),
                                  splashRadius: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Details and Description

                    _sectionContainer(
                      'Details',
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailsRow('Brand', widget.product.brand),
                            _detailsRow(
                                'Quatity', widget.product.stock.toString()),
                            _detailsRow('Category', widget.product.category),
                            _detailsRow(
                                'Popularity',
                                widget.product.isPopular
                                    ? 'Popular'
                                    : 'Not Popular'),

                            SizedBox(height: 10),

                            // Description

                            Text(widget.product.description),
                          ],
                        ),
                      ),
                    ),

                    //TODO: FIX Product Recommendations

                    // _sectionContainer(
                    //   'Recommendations',
                    //   Container(
                    //     height: MediaQuery.of(context).size.width * 0.7,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       padding: EdgeInsets.symmetric(horizontal: 6),
                    //       itemCount: _productRecommendation.length,
                    //       itemBuilder: (context, index) => Container(
                    //           margin: EdgeInsets.symmetric(horizontal: 4),
                    //           child: Recommendation(
                    //             product: _productRecommendation[index],
                    //           )),
                    //     ),
                    //   ),
                    // ),

                    _sectionContainer(
                        'Reviews',
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('No review yet'),
                        )),
                    SizedBox(height: 60),
                  ],
                )),
          )),
        ],
      ),
    );
  }

  Widget _sectionContainer(String title, Widget child) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(height: 10),
          child,
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _detailsRow(String key, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(key)),
          Expanded(flex: 2, child: Text(value)),
        ],
      ),
    );
  }

  Widget _bottomSheet(ProductModel product) {
    final _cartProvider = Provider.of<CartProvider>(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 50,
      child: Row(
        children: [
          // Add to cart button
          Expanded(
            flex: 1,
            child: Material(
              color: Theme.of(context).cardColor,
              child: InkWell(
                onTap: _cartProvider.isInCart(product.id)
                    ? () {
                        _cartProvider.removeFromCart(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbar.snackbarAlert(context,
                                content: 'Removed from cart'));
                      }
                    : () {
                        _cartProvider.addOrRemoveItem(CartModel(
                            id: product.id,
                            imageUrl: product.imageUrl,
                            name: product.name,
                            price: product.price,
                            quantity: 1));
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbar.snackbarAlert(context,
                                content: 'Added to cart'));
                      },
                child: Center(
                  child: _cartProvider.isInCart(product.id)
                      ? Icon(mRemoveCartIcon)
                      : Icon(mAddCartIcon),
                ),
              ),
            ),
          ),

          // Buy button
          Expanded(
            flex: 1,
            child: Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                  onTap: () {},
                  child: Center(
                    child: Text(
                      'Buy Now !'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
