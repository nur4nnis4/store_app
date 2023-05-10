import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/bloc/product_bloc/fetch_products_by_category/fetch_products_by_category_bloc.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/category_model.dart';

class Category extends StatelessWidget {
  final CategoryModel category;
  Category({required this.category});
  @override
  Widget build(BuildContext context) {
    double _imageSize = 50;
    return InkWell(
      onTap: () {
        BlocProvider.of<FetchProductsByCategoryBloc>(context)
            .add(FetchProductsByCategoryEvent(productCategory: category.name));
        Navigator.pushNamed(context, RouteName.categoryScreen,
            arguments: category.name);
      },
      child: Container(
        width: _imageSize + 15,
        child: Column(
          children: [
            Container(
              height: _imageSize,
              width: _imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.deepPurple[50],
              ),
              child: Center(
                child: Image.asset(
                  category.image,
                  width: _imageSize * 0.65,
                  height: _imageSize * 0.65,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              category.name,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
