import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/models/product_model.dart';

part 'fetch_products_event.dart';
part 'fetch_products_state.dart';

class FetchProductsBloc extends Bloc<FetchProductsEvent, FetchProductsState> {
  final ProductRemoteDatasource productRemoteDatasource;

  FetchProductsBloc({required this.productRemoteDatasource})
      : super(FetchProductsInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      try {
        emit(FetchProductsLoading());
        final products = await productRemoteDatasource.fetchProducts();
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
  }
}
