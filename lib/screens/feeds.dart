import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/widgets/product_card.dart';
import 'package:store_app/widgets/my_badge.dart';

class FeedsScreen extends StatefulWidget {
  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        BlocProvider.of<FetchProductsBloc>(context)
            .add(LoadMoreProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      body: BlocBuilder<FetchProductsBloc, FetchProductsState>(
        builder: (context, state) {
          if (state is FetchProductsError) {
            return Text('Error: ${state.message}');
          } else if (state is FetchProductsLoaded) {
            return GridView.builder(
              controller: _controller,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.width + 184),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              padding: EdgeInsets.all(8),
              itemCount: state.hasMoreProducts
                  ? state.products.length + 2
                  : state.products.length,
              itemBuilder: (context, index) {
                if (index < state.products.length) {
                  return ProductCard(product: state.products[index]);
                } else {
                  return Container(
                    color: Theme.of(context).cardColor,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
