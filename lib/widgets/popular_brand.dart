import 'package:flutter/material.dart';
import 'package:store_app/models/brand_model.dart';

class PopularBrand extends StatelessWidget {
  final BrandModel brand;

  PopularBrand({required this.brand});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            image: DecorationImage(
              image: NetworkImage(brand.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 4,
          child: Icon(
            Icons.star,
            color: Colors.amberAccent,
            size: 16,
          ),
        ),
      ],
    );
  }
}
