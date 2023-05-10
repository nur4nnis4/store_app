import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_app/data/remote_datasource/product_remote_datasource.dart';
import 'package:store_app/models/product_model.dart';

part 'upload_product_event.dart';
part 'upload_product_state.dart';

class UploadProductBloc extends Bloc<UploadProductEvent, UploadProductState> {
  final ProductRemoteDatasource productRemoteDatasource;

  UploadProductBloc({required this.productRemoteDatasource})
      : super(UploadProductInitial()) {
    on<UploadProductEvent>((event, emit) async {
      try {
        emit(UploadProductLoading());
        final product = await productRemoteDatasource.createProduct(
            event.product, event.accessToken);

        emit(UploadProductSuccess(product: product));
      } catch (e) {
        emit(UploadProductError(message: e.toString()));
      }
    });
  }
}
