import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/core/constants/theme_data.dart';
import 'package:store_app/data/local_datasource/theme_preferences.dart';
import 'package:store_app/injector.dart' as Injector;
import 'package:store_app/providers/theme_change_provider.dart';
import 'package:store_app/screens/inner_screens/forgot_password.dart';
import 'package:store_app/screens/main_screen.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/providers/user_data_provider.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/upload_product.dart';

import 'package:store_app/core/constants/route_name.dart';
import 'package:store_app/screens/inner_screens/category_screen.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';
import 'package:store_app/screens/inner_screens/cart.dart';
import 'package:store_app/screens/inner_screens/product_detail.dart';
import 'package:store_app/screens/feeds.dart';
import 'package:store_app/screens/log_in.dart';
import 'package:store_app/screens/sign_up.dart';
import 'package:store_app/screens/wishlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDarkTheme = await ThemePreferences().getTheme();
  Injector.init();
  runApp(MyApp(
    isDarkTheme: isDarkTheme,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  const MyApp({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => Injector.sLocator<AuthBloc>(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeChangeProvider(isDarkTheme),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) => Injector.sLocator<AuthProvider>()),
            ChangeNotifierProvider(
                create: (_) => Injector.sLocator<UserDataProvider>()),
            ChangeNotifierProvider(
                create: (_) => Injector.sLocator<ProductProvider>()),
            ChangeNotifierProvider(create: (_) => new CartProvider()),
            ChangeNotifierProvider(create: (_) => new WishlistProvider()),
          ],
          child: Consumer<ThemeChangeProvider>(
            builder: (_, themeChangeProvider, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Store App',
                theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                // initialRoute: RouteName.forgotPasswordScreen,
                routes: {
                  RouteName.mainScreen: (context) => MainScreen(),
                  RouteName.bottomBarScreen: (context) => BottomBarScreen(),
                  RouteName.logInScreen: (contex) => LogInScreen(),
                  RouteName.signUpScreen: (context) => SignUpScreen(),
                  RouteName.forgotPasswordScreen: (context) =>
                      ForgotPasswordScreen(),
                  RouteName.productDetailScreen: (context) =>
                      ProductDetailScreen(),
                  RouteName.feedsScreen: (context) => FeedsScreen(),
                  RouteName.cartScreen: (context) => CartScreen(),
                  RouteName.wishlistScreen: (context) => WishlistScreen(),
                  RouteName.categoryScreen: (context) => CategoryScreen(),
                  RouteName.uploadProductScreen: (context) =>
                      UploadProductScreen(),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
