import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/bloc/user_bloc/user_bloc.dart';
import 'package:store_app/screens/bottom_bar.dart';
import 'package:store_app/screens/upload_product.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);
    context.read<FetchProductsBloc>().add(FetchProductsEvent());
    context.read<AuthBloc>().add(GetAuthStatusEvent());

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<UserBloc>().add(FetchUserEvent(
              userId: state.userId, accessToken: state.authToken));
        }
      },
      child: PageView(
        controller: controller,
        children: <Widget>[UploadProductScreen(), BottomBarScreen()],
      ),
    );
  }
}
