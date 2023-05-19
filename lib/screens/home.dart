import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_bloc/fetch_products_bloc.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/brand_model.dart';
import 'package:store_app/models/carousel_model.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/widgets/category.dart';
import 'package:store_app/widgets/my_badge.dart';
import 'package:store_app/widgets/my_carousel.dart';
import 'package:store_app/widgets/popular_brand.dart';
import 'package:store_app/widgets/popular_product_card.dart';
import 'package:store_app/widgets/recommendation.dart';

class HomeScreen extends StatelessWidget {
  final List<CarouselModel> carouselImages = CarouselModel.getCarouselImages();

  final List<CategoryModel> categories = CategoryModel.getCategories();

  final List<BrandModel> popularBrands = BrandModel.getBrands();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          pinned: true,
          actions: [MyBadge.cart(context)],
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: MyCarousel(
              imageList: carouselImages,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories section

                _sectionTitle(context, 'CATEGORIES', () {}),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) =>
                        Category(category: categories[index]),
                  ),
                ),

                // Popular Brands Section

                _sectionTitle(context, 'POPULAR BRANDS', () {}),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 2,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    children: List.generate(
                      popularBrands.length,
                      (index) => Center(
                        child: PopularBrand(
                          brand: popularBrands[index],
                        ),
                      ),
                    ),
                  ),
                ),

                // Popular Product Section

                _sectionTitle(
                    context,
                    'POPULAR PRODUCTS',
                    () => Navigator.pushNamed(context, RouteName.categoryScreen,
                        arguments: 'Popular Products ')),

                BlocBuilder<FetchProductsBloc, FetchProductsState>(
                  builder: (context, state) {
                    if (state is FetchProductsError) {
                      return Text('Error: ${state.message}');
                    } else if (state is FetchProductsLoaded) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          itemCount: state.popularProducts.length,
                          itemBuilder: (_, index) => PopularProductCard(
                              popularProduct: state.popularProducts[index]),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                // Recommendations Section

                _sectionTitle(context, 'RECOMMENDATIONS', () {}),

                BlocBuilder<FetchProductsBloc, FetchProductsState>(
                  builder: (context, state) {
                    if (state is FetchProductsError) {
                      return Text('Error: ${state.message}');
                    } else if (state is FetchProductsLoaded) {
                      return GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (MediaQuery.of(context).size.width) /
                            (MediaQuery.of(context).size.width + 130),
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        children: List.generate(
                          state.products.length,
                          (index) => Center(
                              child: Recommendation(
                                  product: state.products[index])),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget _sectionTitle(
      BuildContext context, String title, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 26, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              'More>',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).unselectedWidgetColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
