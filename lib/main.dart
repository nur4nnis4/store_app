import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/theme_data.dart';
import 'package:store_app/firebase_options.dart';
import 'package:store_app/models/theme_preferences.dart';
import 'package:store_app/providers/theme_change_provider.dart';
import 'package:store_app/screens/inner_screens/forgot_password.dart';
import 'package:store_app/screens/main_screen.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/providers/user_data_provider.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/upload_product.dart';

import 'package:store_app/constants/route_name.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final isDarkTheme = await ThemePreferences().getTheme();
  runApp(MyApp(
    isDarkTheme: isDarkTheme,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;

  const MyApp({Key? key, required this.isDarkTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChangeProvider(isDarkTheme),
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => new AuthProvider()),
                  ChangeNotifierProvider(create: (_) => new UserDataProvider()),
                  ChangeNotifierProvider(create: (_) => new ProductProvider()),
                  ChangeNotifierProvider(create: (_) => new CartProvider()),
                  ChangeNotifierProvider(create: (_) => new WishlistProvider()),
                ],
                child: Consumer<ThemeChangeProvider>(
                  builder: (_, themeChangeProvider, __) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Store App',
                      theme:
                          Styles.getThemeData(themeChangeProvider.isDarkTheme),
                      // initialRoute: RouteName.forgotPasswordScreen,
                      routes: {
                        RouteName.mainScreen: (context) => MainScreen(),
                        RouteName.bottomBarScreen: (context) =>
                            BottomBarScreen(),
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
              );
            } else if (snapshot.hasError) {
              return Consumer<ThemeChangeProvider>(
                builder: (_, themeChangeProvider, __) => MaterialApp(
                  theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                  home: Scaffold(
                    body: Center(child: Text('Something went wrong :(')),
                  ),
                ),
              );
            }
            return Consumer<ThemeChangeProvider>(
              builder: (_, themeChangeProvider, __) => MaterialApp(
                theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                home: Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )),
                ),
              ),
            );
          }),
    );
  }
}
