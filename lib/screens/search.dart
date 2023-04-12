import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/constants/assets_path.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/widgets/feeds_product.dart';
import 'package:store_app/widgets/my_badge.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  List<ProductModel> _searchList = [];

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();

    _searchController = new TextEditingController();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _productProvider = Provider.of<ProductProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: _searchBar(_productProvider),
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
              child: _searchController.text.isEmpty || _searchList.isEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: _searchController.text.isNotEmpty
                          ? Container(
                              child: Text(
                                'No results found :(',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                            )
                          : SvgPicture.asset(
                              ImagePath.search,
                            ),
                    )
                  : _showSearchResults()),
        ),
      ),
    );
  }

  Widget _showSearchResults() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (MediaQuery.of(context).size.width) /
          (MediaQuery.of(context).size.width + 184),
      mainAxisSpacing: 8,
      children: List.generate(
        _searchList.length,
        (index) => ChangeNotifierProvider.value(
          value: _searchList[index],
          child: Center(
            child: FeedsProduct(),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(ProductProvider productProvider) {
    return Material(
      elevation: 1,
      child: TextField(
        focusNode: _focusNode,
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
                          _focusNode.unfocus();
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
          _searchController.text.toLowerCase();
          _searchList = productProvider.searchQuery(value);
        },
      ),
    );
  }
}
