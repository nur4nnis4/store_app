import 'package:flutter/foundation.dart';
import 'package:store_app/data/local_datasource/wishlist_local_datasource.dart';
import 'package:store_app/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistLocalDatasource wishlistLocalDatasource;
  WishlistProvider({required this.wishlistLocalDatasource});

  Map<String, WishlistModel> _wishListItems = {};

  Map<String, WishlistModel> get getwishListItems => _wishListItems;

  Future<void> getLocalWishlist() async {
    final wishlist = await wishlistLocalDatasource.getWishlist();

    wishlist.forEach((item) {
      _wishListItems.putIfAbsent(item.id, () => item);
    });
  }

  void addOrRemoveItem(WishlistModel wishlistModel) async {
    isInWishList(wishlistModel.id)
        ? removeWishlistItem(wishlistModel.id)
        : _wishListItems.putIfAbsent(wishlistModel.id, () => wishlistModel);
    notifyListeners();

    if (!kIsWeb) {
      try {
        isInWishList(wishlistModel.id)
            ? await wishlistLocalDatasource.deleteWishlist(wishlistModel.id)
            : await wishlistLocalDatasource.insertWishlist(wishlistModel);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void removeWishlistItem(productId) async {
    _wishListItems.remove(productId);
    notifyListeners();

    try {
      if (!kIsWeb) {
        wishlistLocalDatasource.deleteWishlist(productId);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void clearWishlist() {
    _wishListItems.clear();
    notifyListeners();

    try {
      if (!kIsWeb) {
        wishlistLocalDatasource.clearWishlist();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool isInWishList(productId) => _wishListItems.containsKey(productId);
}
