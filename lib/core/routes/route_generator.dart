import 'package:flutter/material.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/screens/inner_screens/cart.dart';
import 'package:store_app/screens/inner_screens/category_screen.dart';
import 'package:store_app/screens/inner_screens/forgot_password.dart';
import 'package:store_app/screens/inner_screens/product_detail.dart';
import 'package:store_app/screens/log_in.dart';
import 'package:store_app/screens/main_screen.dart';
import 'package:store_app/screens/sign_up.dart';
import 'package:store_app/screens/wishlist.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteName.mainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());

      case RouteName.productDetailScreen:
        if (args is ProductModel) {
          return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: args));
        }
        throw Exception(
            'Invalid arguments for ${RouteName.productDetailScreen} route');
      case RouteName.logInScreen:
        return MaterialPageRoute(builder: (_) => LogInScreen());
      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteName.forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case RouteName.cartScreen:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case RouteName.wishlistScreen:
        return MaterialPageRoute(builder: (_) => WishlistScreen());
      case RouteName.categoryScreen:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => CategoryScreen(productCategory: args));
        }
        throw Exception(
            'Invalid arguments for ${RouteName.categoryScreen} route');
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
