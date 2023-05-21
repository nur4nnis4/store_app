import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/models/product_model.dart';

part 'fetch_products_event.dart';
part 'fetch_products_state.dart';

class FetchProductsBloc extends Bloc<FetchProductsEvent, FetchProductsState> {
  final ProductRemoteDatasource productRemoteDatasource;
  final _productsLimit = 10;
  FetchProductsBloc({required this.productRemoteDatasource})
      : super(FetchProductsInitial()) {
    on<FirstLoadProductsEvent>((event, emit) async {
      try {
        emit(FetchProductsLoading());
        final products =
            await productRemoteDatasource.fetchProducts(limit: _productsLimit);
        final popularProducts =
            await productRemoteDatasource.fetchPopularProducts();
        emit(FetchProductsLoaded(
            products: products, popularProducts: popularProducts));
      } on ServerException catch (e) {
        emit(FetchProductsError(message: e.message));
      } catch (e) {
        emit(FetchProductsError(message: e.toString()));
      }
    });
    on<LoadMoreProductsEvent>((event, emit) async {
      try {
        if (state is FetchProductsLoaded) {
          final currentState = state as FetchProductsLoaded;
          if (currentState.hasMoreProducts) {
            final currentPage = currentState.productsPage + 1;

            final newProducts = await productRemoteDatasource.fetchProducts(
                limit: _productsLimit, page: currentPage);
            emit(FetchProductsLoaded(
                products: currentState.products + newProducts,
                popularProducts: currentState.popularProducts,
                productsPage: currentPage,
                hasMoreProducts: newProducts.length == _productsLimit));
          }
        }
      } on ServerException catch (e) {
        emit(FetchProductsError(message: e.message));
      } catch (e) {
        emit(FetchProductsError(message: e.toString()));
      }
    });
  }
}
