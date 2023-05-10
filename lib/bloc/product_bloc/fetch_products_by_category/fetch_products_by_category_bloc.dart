import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/models/product_model.dart';

part 'fetch_products_by_category_event.dart';
part 'fetch_products_by_category_state.dart';

class FetchProductsByCategoryBloc
    extends Bloc<FetchProductsByCategoryEvent, FetchProductsByCategoryState> {
  final ProductRemoteDatasource productRemoteDatasource;

  FetchProductsByCategoryBloc({required this.productRemoteDatasource})
      : super(FetchProductsByCategoryInitial()) {
    on<FetchProductsByCategoryEvent>((event, emit) async {
      try {
        emit(FetchProductsByCategoryLoading());
        final products = await productRemoteDatasource
            .fetchProductsByCategory(event.productCategory);
        emit(FetchProductsByCategoryLoaded(products: products));
      } on ServerException catch (e) {
        emit(FetchProductsByCategoryError(message: e.message));
      } catch (e) {
        emit(FetchProductsByCategoryError(message: e.toString()));
      }
    });
  }
}
