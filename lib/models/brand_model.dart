import 'package:store_app/core/constants/.apiconfig.dart';

class BrandModel {
  String name;
  String imageUrl;

  BrandModel({this.name = '', this.imageUrl = ''});

  List<BrandModel> getBrands() => [
        BrandModel(
          name: 'CocaCola',
          imageUrl: '$storageUrl/brands/coca_cola.jpg',
        ),
        BrandModel(
          name: 'Cadbury',
          imageUrl: '$storageUrl/brands/cadbury.jpg',
        ),
        BrandModel(
          name: 'Fanta',
          imageUrl: '$storageUrl/brands/fanta.jpg',
        ),
        BrandModel(
          name: 'Dasani',
          imageUrl: '$storageUrl/brands/dasani.jpg',
        ),
        BrandModel(
          name: 'Lipton',
          imageUrl: '$storageUrl/brands/lipton.jpg',
        ),
        BrandModel(
          name: 'Minute Maid',
          imageUrl: '$storageUrl/brands/minute_maid.jpg',
        ),
        BrandModel(
          name: 'Lays',
          imageUrl: '$storageUrl/brands/lays.jpg',
        ),
        BrandModel(
          name: 'Oreo',
          imageUrl: '$storageUrl/brands/oreo.jpg',
        ),
      ];
}
