part of 'fetch_products_bloc.dart';

@immutable
abstract class FetchProductsEvent {}

class FirstLoadProductsEvent extends FetchProductsEvent {}

class LoadMoreProductsEvent extends FetchProductsEvent {}
