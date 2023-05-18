import 'package:flutter/foundation.dart';
import 'package:store_app/data/local_datasource/cart_local_datasource.dart';
import 'package:store_app/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final CartLocalDatasource cartLocalDatasource;
  CartProvider({required this.cartLocalDatasource});

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

  Future<void> getLocalCart() async {
    final cart = await cartLocalDatasource.getCart();

    cart.forEach((item) {
      _cartItems.putIfAbsent(item.id, () => item);
    });
  }

  void addOrRemoveItem(CartModel cartModel) async {
    isInCart(cartModel.id)
        ? _cartItems.remove(cartModel.id)
        : _cartItems.putIfAbsent(cartModel.id, () => cartModel);

    notifyListeners();

    if (!kIsWeb) {
      try {
        isInCart(cartModel.id)
            ? await cartLocalDatasource.deleteCart(cartModel.id)
            : await cartLocalDatasource.insertCart(cartModel);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void increaseQuantity(CartModel cartModel) async {
    final updatedCart =
        CartModel.updateQuantity(cartModel, cartModel.quantity + 1);
    _cartItems.update(cartModel.id, (cartModel) => updatedCart);
    notifyListeners();
    _callUpdateLocalCart(updatedCart);
  }

  void decreaseQuantity(CartModel cartModel) {
    final updatedCart =
        CartModel.updateQuantity(cartModel, cartModel.quantity - 1);
    _cartItems.update(cartModel.id, (cartModel) => updatedCart);
    notifyListeners();
    _callUpdateLocalCart(updatedCart);
  }

  Future<void> _callUpdateLocalCart(CartModel updatedCart) async {
    if (!kIsWeb) {
      try {
        await cartLocalDatasource.updateCart(updatedCart);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void removeFromCart(id) async {
    _cartItems.remove(id);
    notifyListeners();
    if (!kIsWeb) {
      try {
        await cartLocalDatasource.deleteCart(id);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void removeAll() async {
    _cartItems.clear();
    notifyListeners();

    if (!kIsWeb) {
      try {
        await cartLocalDatasource.clearCart();
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
