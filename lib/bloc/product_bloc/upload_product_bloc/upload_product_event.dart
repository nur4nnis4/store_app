part of 'upload_product_bloc.dart';

@immutable
class UploadProductEvent {
  final ProductModel product;
  final String accessToken;

  UploadProductEvent({required this.product, required this.accessToken});
}
