import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/widgets/product_card.dart';
import 'package:store_app/widgets/my_badge.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [MyBadge.cart(context)],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: BlocBuilder<FetchProductsBloc, FetchProductsState>(
          builder: (context, state) {
            if (state is FetchProductsError) {
              return Text('Error: ${state.message}');
            } else if (state is FetchProductsLoaded) {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.width + 184),
                mainAxisSpacing: 8,
                children: List.generate(
                  state.products.length,
                  (index) => Center(
                      child: ProductCard(product: state.products[index])),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
