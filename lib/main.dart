import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_by_category/fetch_products_by_category_bloc.dart';
import 'package:store_app/bloc/product_bloc/search_product_bloc/search_product_bloc.dart';
import 'package:store_app/bloc/product_bloc/upload_product_bloc/upload_product_bloc.dart';
import 'package:store_app/bloc/user_bloc/user_bloc.dart';
import 'package:store_app/core/routes/route_generator.dart';
import 'package:store_app/core/theme/theme_data.dart';
import 'package:store_app/injector.dart' as Injector;

import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Injector.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>(
                create: (_) => Injector.sLocator<CartProvider>()),
            ChangeNotifierProvider<WishlistProvider>(
                create: (_) => Injector.sLocator<WishlistProvider>()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Store App',
            darkTheme: Styles.darkTheme,
            theme: Styles.lightTheme,
            onGenerateRoute: RouteGenerator.generateRoute,
          )),
    );
  }
}
