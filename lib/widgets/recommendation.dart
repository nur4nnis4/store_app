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
              Container(
                height: _productImageSize,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.contain)),
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
