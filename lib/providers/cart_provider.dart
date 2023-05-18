import 'package:flutter/cupertino.dart';
import 'package:store_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems => _cartItems;

  double get subTotal {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  bool isInCart(id) => _cartItems.containsKey(id);

  void addOrRemoveItem(CartModel cartModel) {
    isInCart(cartModel.id)
        ? _cartItems.remove(cartModel.id)
        : _cartItems.putIfAbsent(cartModel.id, () => cartModel);

    notifyListeners();
  }

  void increaseQuantity(CartModel cartModel) {
    _cartItems.update(
        cartModel.id,
        (cartModel) =>
            CartModel.updateQuantity(cartModel, cartModel.quantity + 1));
    notifyListeners();
  }

  void decreaseQuantity(CartModel cartModel) {
    _cartItems.update(
        cartModel.id,
        (cartModel) =>
            CartModel.updateQuantity(cartModel, cartModel.quantity - 1));
    notifyListeners();
  }

  void removeFromCart(id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void removeAll() {
    _cartItems.clear();
    notifyListeners();
  }
}
