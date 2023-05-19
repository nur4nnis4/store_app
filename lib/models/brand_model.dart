import 'package:store_app/core/config/apiconfig.dart';

class BrandModel {
  final String name;
  final String imageUrl;

  BrandModel({required this.name, required this.imageUrl});

  static List<BrandModel> getBrands() => [
        BrandModel(
          name: 'CocaCola',
          imageUrl: '$STORAGE_URL/brands/coca_cola.jpg',
        ),
        BrandModel(
          name: 'Cadbury',
          imageUrl: '$STORAGE_URL/brands/cadbury.jpg',
        ),
        BrandModel(
          name: 'Fanta',
          imageUrl: '$STORAGE_URL/brands/fanta.jpg',
        ),
        BrandModel(
          name: 'Dasani',
          imageUrl: '$STORAGE_URL/brands/dasani.jpg',
        ),
        BrandModel(
          name: 'Lipton',
          imageUrl: '$STORAGE_URL/brands/lipton.jpg',
        ),
        BrandModel(
          name: 'Minute Maid',
          imageUrl: '$STORAGE_URL/brands/minute_maid.jpg',
        ),
        BrandModel(
          name: 'Lays',
          imageUrl: '$STORAGE_URL/brands/lays.jpg',
        ),
        BrandModel(
          name: 'Oreo',
          imageUrl: '$STORAGE_URL/brands/oreo.jpg',
        ),
      ];
}
