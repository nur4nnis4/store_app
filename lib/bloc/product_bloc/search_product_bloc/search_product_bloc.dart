import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/models/product_model.dart';

part 'search_product_event.dart';
part 'search_product_state.dart';

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  final ProductRemoteDatasource productRemoteDatasource;

  SearchProductBloc({required this.productRemoteDatasource})
      : super(SearchProductInitial()) {
    on<SearchProductEvent>(
      (event, emit) async {
        if (event.keyword.trim().isEmpty) {
          emit(SearchProductInitial());
        } else {
          try {
            emit(SearchProductLoading());

            final products = await productRemoteDatasource
                .searchProducts(event.keyword.trim().toLowerCase());
            if (products.isEmpty) {
              emit(SearchProductEmpty());
            } else {
              emit(SearchProductLoaded(products: products));
            }
          } on ServerException catch (e) {
            emit(SearchProductError(message: e.message));
          } catch (e) {
            emit(SearchProductError(message: e.toString()));
          }
        }
      },

      /** Delay search event call until the user has finished typing
       * to reduce unnecessary API calls and improve performance. */
      transformer: (events, mapper) =>
          events.debounceTime(Duration(milliseconds: 250)).asyncExpand(mapper),
    );
  }
}
