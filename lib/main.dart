import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_by_category/fetch_products_by_category_bloc.dart';
import 'package:store_app/bloc/product_bloc/search_product_bloc/search_product_bloc.dart';
import 'package:store_app/bloc/product_bloc/upload_product_bloc/upload_product_bloc.dart';
import 'package:store_app/bloc/user_bloc/user_bloc.dart';
import 'package:store_app/core/constants/theme_data.dart';
import 'package:store_app/core/routes/route_generator.dart';
import 'package:store_app/data/local_datasource/theme_preferences.dart';
import 'package:store_app/injector.dart' as Injector;
import 'package:store_app/providers/theme_change_provider.dart';

import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';

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
        BlocProvider<UserBloc>(
          create: (BuildContext context) => Injector.sLocator<UserBloc>(),
        ),
        BlocProvider<FetchProductsBloc>(
          create: (BuildContext context) =>
              Injector.sLocator<FetchProductsBloc>(),
        ),
        BlocProvider<UploadProductBloc>(
          create: (BuildContext context) =>
              Injector.sLocator<UploadProductBloc>(),
        ),
        BlocProvider<SearchProductBloc>(
          create: (BuildContext context) =>
              Injector.sLocator<SearchProductBloc>(),
        ),
        BlocProvider<FetchProductsByCategoryBloc>(
          create: (BuildContext context) =>
              Injector.sLocator<FetchProductsByCategoryBloc>(),
        )
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeChangeProvider(isDarkTheme),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => new CartProvider()),
            ChangeNotifierProvider(create: (_) => new WishlistProvider()),
          ],
          child: Consumer<ThemeChangeProvider>(
            builder: (_, themeChangeProvider, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Store App',
                theme: Styles.getThemeData(themeChangeProvider.isDarkTheme),
                onGenerateRoute: RouteGenerator.generateRoute,
              );
            },
          ),
        ),
      ),
    );
  }
}
