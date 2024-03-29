part of 'fetch_products_bloc.dart';

@immutable
abstract class FetchProductsState {}

class FetchProductsInitial extends FetchProductsState {}

class FetchProductsLoading extends FetchProductsState {}

class FetchProductsLoaded extends FetchProductsState {
  final List<ProductModel> products;
  final List<ProductModel> popularProducts;
  final int productsPage;
  final bool hasMoreProducts;

  FetchProductsLoaded({
    required this.products,
    required this.popularProducts,
    this.productsPage = 1,
    this.hasMoreProducts = true,
  });
}

class FetchProductsError extends FetchProductsState {
  final String message;

  FetchProductsError({required this.message});
}
