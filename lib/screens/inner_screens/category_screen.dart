import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_by_category/fetch_products_by_category_bloc.dart';
import 'package:store_app/widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  final String productCategory;

  const CategoryScreen({Key? key, required this.productCategory})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productCategory,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: BlocBuilder<FetchProductsByCategoryBloc,
            FetchProductsByCategoryState>(
          builder: (context, state) {
            if (state is FetchProductsByCategoryError) {
              return Text('Error: ${state.message}');
            } else if (state is FetchProductsByCategoryLoaded) {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.width + 190),
                mainAxisSpacing: 8,
                children: List.generate(
                  state.products.length,
                  (index) => ProductCard(product: state.products[index]),
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
