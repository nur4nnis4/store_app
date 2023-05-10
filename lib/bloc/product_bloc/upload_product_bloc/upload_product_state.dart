part of 'upload_product_bloc.dart';

@immutable
abstract class UploadProductState {}

class UploadProductInitial extends UploadProductState {}

class UploadProductLoading extends UploadProductState {}

class UploadProductSuccess extends UploadProductState {
  final ProductModel product;

  UploadProductSuccess({required this.product});
}

class UploadProductError extends UploadProductState {
  final String message;

  UploadProductError({required this.message});
}
