import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:store_app/core/routes/route_name.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/widgets/product_dialog.dart';
import 'package:store_app/widgets/my_button.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double _productImageSize = MediaQuery.of(context).size.width * 0.45;
    return Container(
      width: _productImageSize,
      height: _productImageSize + 120,
      child: Material(
        elevation: 0.4,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context, RouteName.productDetailScreen,
              arguments: product),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Hero(
                  tag: product.id,
                  child: Container(
                    height: _productImageSize,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            onError: (object, stacktrace) => {},
                            fit: BoxFit.contain)),
                  ),
                ),
                badges.Badge(
                  toAnimate: false,
                  shape: badges.BadgeShape.square,
                  badgeColor: Colors.deepPurple,
                  badgeContent:
                      Text('New', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\$ ${product.price.toString()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sales ${product.sales}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      MyButton.smallIcon(
                        context: context,
                        icon: Icons.more_vert,
                        color: Theme.of(context).colorScheme.tertiary,
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => ProductDialog(
                              product: product,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
