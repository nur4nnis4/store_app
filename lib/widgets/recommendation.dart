import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/product_model.dart';

class Recommendation extends StatelessWidget {
  final ProductModel product;

  const Recommendation({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _productImageSize = MediaQuery.of(context).size.width * 0.45;

    return Container(
      width: _productImageSize,
      child: Material(
        elevation: 0.4,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteName.productDetailScreen,
              arguments: product),
          child: Container(
            color: Theme.of(context).cardColor,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: _productImageSize,
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              Container(
                margin: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '\$ ${product.price}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                    Text(
                      'Sales ${product.sales}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
