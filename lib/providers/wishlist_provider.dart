import 'package:flutter/foundation.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/local_datasource/wishlist_local_datasource.dart';
import 'package:store_app/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistLocalDatasource wishlistLocalDatasource;
  WishlistProvider({required this.wishlistLocalDatasource});

  Map<String, WishlistModel> _wishListItems = {};

  Map<String, WishlistModel> get getwishListItems => _wishListItems;

  Future<void> getLocalWishlist() async {
    try {
      final wishlist = await wishlistLocalDatasource.getWishlist();

      wishlist.forEach((item) {
        _wishListItems.putIfAbsent(item.id, () => item);
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void addOrRemoveItem(WishlistModel wishlistModel) async {
    if (!kIsWeb) {
      try {
        isInWishList(wishlistModel.id)
            ? await wishlistLocalDatasource.deleteWishlist(wishlistModel.id)
            : await wishlistLocalDatasource.insertWishlist(wishlistModel);
      } on CacheException catch (e) {
        print(e.message);
      }
    }
    isInWishList(wishlistModel.id)
        ? removeWishlistItem(wishlistModel.id)
        : _wishListItems.putIfAbsent(wishlistModel.id, () => wishlistModel);
    notifyListeners();
  }

  void removeWishlistItem(productId) async {
    _wishListItems.remove(productId);
    notifyListeners();

    try {
      if (!kIsWeb) {
        wishlistLocalDatasource.deleteWishlist(productId);
      }
    } on CacheException catch (e) {
      print(e.message);
    }
  }

  void clearWishlist() {
    _wishListItems.clear();
    notifyListeners();

    try {
      if (!kIsWeb) {
        wishlistLocalDatasource.clearWishlist();
      }
    } on CacheException catch (e) {
      print(e.message);
    }
  }

  bool isInWishList(productId) => _wishListItems.containsKey(productId);
}
