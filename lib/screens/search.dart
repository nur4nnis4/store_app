import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/bloc/product_bloc/search_product_bloc/search_product_bloc.dart';
import 'package:store_app/core/constants/assets_path.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/widgets/product_card.dart';
import 'package:store_app/widgets/my_badge.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController = new TextEditingController();

  late FocusNode _searchBarfocusNode = new FocusNode();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _searchBarfocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: _searchBar(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
            actions: [
              MyBadge.cart(context),
            ],
          ),
          body: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: BlocBuilder<SearchProductBloc, SearchProductState>(
                builder: (context, state) {
                  if (state is SearchProductError) {
                    return Text('Error: ${state.message}');
                  } else if (state is SearchProductLoaded) {
                    return _showSearchResults(products: state.products);
                  } else if (state is SearchProductLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SearchProductEmpty) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Container(
                        child: Text(
                          'No results found :(',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: SvgPicture.asset(
                        ImagePath.search,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }

  Widget _showSearchResults({required List<ProductModel> products}) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (MediaQuery.of(context).size.width) /
          (MediaQuery.of(context).size.width + 184),
      mainAxisSpacing: 8,
      children: List.generate(
        products.length,
        (index) => ProductCard(product: products[index]),
      ),
    );
  }

  Widget _searchBar() {
    return Material(
      elevation: 1,
      child: TextField(
        focusNode: _searchBarfocusNode,
        autofocus: true,
        controller: _searchController,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Theme.of(context).cardColor,
          filled: true,
          isDense: true,
          hintText: 'Search',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: _searchController.text.isEmpty
                      ? null
                      : () {
                          _searchController.clear();
                          _searchBarfocusNode.unfocus();
                        },
                  iconSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: Icon(Icons.clear),
                  padding: EdgeInsets.zero,
                  splashRadius: 14,
                ),
          suffixIconConstraints: BoxConstraints(maxHeight: 14),
        ),
        onChanged: (value) {
          BlocProvider.of<SearchProductBloc>(context)
              .add(SearchProductEvent(keyword: value));
        },
      ),
    );
  }
}
