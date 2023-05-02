import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/app_consntants.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/authenticate.dart';
import 'package:store_app/widgets/empty_cart.dart';
import 'package:store_app/widgets/full_cart.dart';
import 'package:store_app/utils/ui/my_alert_dialog.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    final _cartItems = _cartProvider.getCartItems;

    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            if (_cartItems.isNotEmpty)
              IconButton(
                onPressed: () => MyAlertDialog().clearCart(context, () {
                  _cartProvider.removeAll();
                  Navigator.pop(context);
                }),
                icon: Icon(mTrashIcon),
                splashRadius: 18,
              ),
          ],
        ),
        bottomSheet:
            _cartItems.isNotEmpty ? checkoutSection(_cartProvider) : null,
        body: _cartItems.isEmpty
            ? EmptyCart()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) => ChangeNotifierProvider.value(
                      value: _cartItems.values.toList()[index],
                      child: FullCart()),
                ),
              ),
      ),
    );
  }

  Widget checkoutSection(CartProvider _cartProvider) {
    return Container(
      color: Theme.of(context).cardColor,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SubTotal
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('SubTotal ', style: Theme.of(context).textTheme.caption),
                  Flexible(
                    child: Text(
                      '\$${_cartProvider.subTotal.toString()}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Checkout Button
          Expanded(
            flex: 1,
            child: Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
