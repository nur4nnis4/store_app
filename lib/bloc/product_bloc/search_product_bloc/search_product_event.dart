part of 'search_product_bloc.dart';

@immutable
class SearchProductEvent {
  final String keyword;

  SearchProductEvent({required this.keyword});
}
