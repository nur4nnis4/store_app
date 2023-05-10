part of 'search_product_bloc.dart';

@immutable
abstract class SearchProductState {}

class SearchProductInitial extends SearchProductState {}

class SearchProductEmpty extends SearchProductState {}

class SearchProductLoading extends SearchProductState {}

class SearchProductLoaded extends SearchProductState {
  final List<ProductModel> products;

  SearchProductLoaded({required this.products});
}

class SearchProductError extends SearchProductState {
  final String message;

  SearchProductError({required this.message});
}
