import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/app_consntants.dart';
import 'package:store_app/core/constants/route_name.dart';
import 'package:store_app/providers/cart_provider.dart';

class MyBadge {
  static Widget quarterCircle(String title, BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.elliptical(50, 50),
      ),
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(50, 50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  static Widget cart(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (_, cartProvider, __) => Badge(
        badgeColor: Theme.of(context).primaryColor,
        position: BadgePosition.topEnd(top: 5, end: 5),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          cartProvider.getCartItems.length.toString(),
          style: TextStyle(color: Colors.white),
        ),
        shape: BadgeShape.circle,
        showBadge: cartProvider.getCartItems.isEmpty ? false : true,
        child: IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteName.cartScreen),
            icon: Icon(
              mCartIcon,
            )),
      ),
    );
  }
}
