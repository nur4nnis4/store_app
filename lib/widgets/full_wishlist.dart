import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/widgets/my_button.dart';

class FullWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _wishlistItem = Provider.of<WishlistModel>(context, listen: false);
    final _wishlistProvider = Provider.of<WishlistProvider>(context);

    double _cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Container(
      margin: EdgeInsets.all(10),
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteName.productDetailScreen,
              arguments: _wishlistItem.id),
          child: Container(
            width: _cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: _cardWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(_wishlistItem.imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _wishlistItem.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: 6),
                      Text(
                        '\$${_wishlistItem.price.toString()}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sales ${_wishlistItem.sales}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          MyButton.smallIcon(
                              context: context,
                              icon: Icons.favorite,
                              color: Colors.redAccent,
                              onPressed: () => _wishlistProvider
                                  .addOrRemoveItem(_wishlistItem)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
