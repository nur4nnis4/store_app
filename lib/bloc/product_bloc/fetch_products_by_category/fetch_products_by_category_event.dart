part of 'fetch_products_by_category_bloc.dart';

@immutable
class FetchProductsByCategoryEvent {
  final String productCategory;

  FetchProductsByCategoryEvent({required this.productCategory});
}
