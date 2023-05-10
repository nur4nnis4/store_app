part of 'fetch_products_by_category_bloc.dart';

@immutable
abstract class FetchProductsByCategoryState {}

class FetchProductsByCategoryInitial extends FetchProductsByCategoryState {}

class FetchProductsByCategoryLoading extends FetchProductsByCategoryState {}

class FetchProductsByCategoryLoaded extends FetchProductsByCategoryState {
  final List<ProductModel> products;

  FetchProductsByCategoryLoaded({required this.products});
}

class FetchProductsByCategoryError extends FetchProductsByCategoryState {
  final String message;

  FetchProductsByCategoryError({required this.message});
}
