import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String brand;
  final String description;
  final String imageUrl;
  final String category;
  final int stock;
  final int sales;
  final bool isPopular;
  final SellerModel? seller;

  ProductModel(
      {this.id = '',
      required this.name,
      required this.price,
      required this.brand,
      required this.description,
      required this.imageUrl,
      required this.category,
      required this.stock,
      this.sales = 0,
      this.isPopular = false,
      this.seller});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      brand: json['brand'],
      description: json['description'],
      imageUrl: json['image_url'],
      category: json['category'],
      stock: json['stock'] as int,
      sales: json['sales'] as int,
      isPopular: json['is_popular'],
      seller:
          json['seller'] != null ? SellerModel.fromJson(json['seller']) : null,
    );
  }
  Future<Map<String, dynamic>> toJson() async => {
        "name": name,
        "price": price,
        "brand": brand,
        "category": category,
        "description": description,
        "image_url": MultipartFile.fromBytes(
            await XFile(imageUrl).readAsBytes(),
            filename: 'image'),
        "is_popular": isPopular ? 1 : 0,
        "stock": stock,
        "sales": sales,
      };
}

class SellerModel {
  SellerModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.address,
  });

  final String id;
  final String name;
  final String photoUrl;
  final String? address;

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
        id: json["id"],
        name: json["name"],
        photoUrl: json["photo_url"],
        address: json["address"],
      );
}

 // List<ProductModel> _products = [
  //   ProductModel(
  //       id: 'Samsung Galaxy A51',
  //       name: 'Samsung Galaxy A51',
  //       description:
  //           'Samsung Galaxy A51 (128GB, 4GB) 6.5", 48MP Quad Camera, Dual SIM GSM Unlocked A515F/DS- Global 4G LTE International Model - Prism Crush Blue.',
  //       price: 50.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/61pwpYcjYlL._AC_SL1000_.jpg',
  //       brand: 'Samsung',
  //       category: 'Phones',
  //       quantity: 6423,
  //       sales: 300,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Xiaomi Mi 10T',
  //       name: 'Xiaomi Mi 10T',
  //       description:
  //           '6 GB + 128 GB, Dual Sim, Alexa Hands-Free, Grigio (Lunar Silver)',
  //       price: 900.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/710VBlX63PL._AC_SL1500_.jpg',
  //       brand: 'Xiaomi',
  //       category: 'Phones',
  //       quantity: 3,
  //       sales: 12,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'iPhone 12 Pro',
  //       name: 'iPhone 12 Pro',
  //       description:
  //           'New Apple iPhone 12 Pro (512GB, Gold) [Locked] + Carrier Subscription',
  //       price: 1100,
  //       imageUrl: 'https://m.media-amazon.com/images/I/71cSV-RTBSL.jpg',
  //       brand: 'Apple',
  //       category: 'Phones',
  //       quantity: 3,
  //       sales: 300,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'iPhone 12 Pro Max ',
  //       name: 'iPhone 12 Pro Max ',
  //       description:
  //           'New Apple iPhone 12 Pro Max (128GB, Graphite) [Locked] + Carrier Subscription',
  //       price: 50.99,
  //       imageUrl:
  //           'https://m.media-amazon.com/images/I/71XXJC7V8tL._FMwebp__.jpg',
  //       brand: 'Apple',
  //       category: 'Phones',
  //       quantity: 2654,
  //       sales: 238,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Acer Aspire 5 A515-56-36UT',
  //       name: 'Acer Aspire 5 A515-56-36UT',
  //       description:
  //           'Slim Laptop | 15.6" Full HD Display | 11th Gen Intel Core i3-1115G4 Processor | 4GB DDR4 | 128GB NVMe SSD | WiFi 6 | Amazon Alexa | Windows 10 Home (S Mode)',
  //       price: 399.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/618Vf68HW%2BL._AC_SL1212_.jpg',
  //       brand: 'Acer',
  //       category: 'Computer',
  //       quantity: 123,
  //       sales: 15,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Sony X80J 65 Inch TV',
  //       name: 'Sony X80J 65 Inch TV',
  //       description:
  //           '4K Ultra HD LED Smart Google TV with Dolby Vision HDR and Alexa Compatibility KD65X80J- 2021 Model',
  //       price: 809.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/91RfzivKmwL._AC_SL1500_.jpg',
  //       brand: 'Sony',
  //       category: 'Electronics',
  //       quantity: 20,
  //       sales: 4,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Hanes Mens ',
  //       name: 'Long Sleeve Beefy Henley Shirt',
  //       description: 'Hanes Men\'s Long Sleeve Beefy Henley Shirt ',
  //       price: 22.30,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/91YHIgoKb4L._AC_UX425_.jpg',
  //       brand: 'No brand',
  //       category: 'Clothes',
  //       quantity: 58466,
  //       sales: 1230,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Weave Jogger',
  //       name: 'Weave Jogger',
  //       description: 'Champion Mens Reverse Weave Jogger',
  //       price: 58.99,
  //       imageUrl:
  //           'https://m.media-amazon.com/images/I/71g7tHQt-sL._AC_UL320_.jpg',
  //       brand: 'H&M',
  //       category: 'Clothes',
  //       quantity: 84894,
  //       sales: 3928,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Tanjun Sneakers',
  //       name: 'Tanjun Sneakers',
  //       description:
  //           'NIKE Men\'s Tanjun Sneakers, Breathable Textile Uppers and Comfortable Lightweight Cushioning ',
  //       price: 191.89,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/71KVPm5KJdL._AC_UX500_.jpg',
  //       brand: 'Nike',
  //       category: 'Shoes',
  //       quantity: 65489,
  //       sales: 337,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Training Pant Female',
  //       name: 'Training Pant Female',
  //       description: 'Nike Epic Training Pant Female ',
  //       price: 189.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/61jvFw72OVL._AC_UX466_.jpg',
  //       brand: 'Nike',
  //       category: 'Clothes',
  //       quantity: 89741,
  //       sales: 10000,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Trefoil Tee',
  //       name: 'Trefoil Tee',
  //       description: 'Originals Women\'s Trefoil Tee ',
  //       price: 88.88,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/51KMhoElQcL._AC_UX466_.jpg',
  //       brand: 'Addidas',
  //       category: 'Clothes',
  //       quantity: 8941,
  //       sales: 3287,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Long SleeveWoman',
  //       name: 'Long Sleeve woman',
  //       description: ' Boys\' Long Sleeve Cotton Jersey Hooded T-Shirt Tee',
  //       price: 68.29,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/71lKAfQDUoL._AC_UX466_.jpg',
  //       brand: 'Addidas',
  //       category: 'Clothes',
  //       quantity: 3,
  //       sales: 2300,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Eye Cream for Wrinkles',
  //       name: 'Eye Cream for Wrinkles',
  //       description:
  //           'Olay Ultimate Eye Cream for Wrinkles, Puffy Eyes + Dark Circles, 0.4 fl oz',
  //       price: 54.98,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/61dwB-2X-6L._SL1500_.jpg',
  //       brand: 'No brand',
  //       category: 'Beauty & health',
  //       quantity: 8515,
  //       sales: 2300,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Mango Body Yogurt',
  //       name: 'Mango Body Yogurt',
  //       description:
  //           'The Body Shop Mango Body Yogurt, 48hr Moisturizer, 100% Vegan, 6.98 Fl.Oz',
  //       price: 80.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/81w9cll2RmL._SL1500_.jpg',
  //       brand: 'No brand',
  //       category: 'Beauty & health',
  //       quantity: 3,
  //       sales: 2300,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Food Intensive Skin',
  //       name: 'Food Intensive Skin',
  //       description:
  //           'Weleda Skin Food Intensive Skin Nourishment Body Butter, 5 Fl Oz',
  //       price: 50.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/71E6h0kl3ZL._SL1500_.jpg',
  //       brand: 'No Brand',
  //       category: 'Beauty & health',
  //       quantity: 38425,
  //       sales: 238,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Ultra Shea Body Cream',
  //       name: 'Ultra Shea Body Cream',
  //       description:
  //           'Bath and Body Works IN THE STARS Ultra Shea Body Cream (Limited Edition) 8 Ounce ',
  //       price: 14,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/61RkTTLRnNL._SL1134_.jpg',
  //       brand: '',
  //       category: 'Beauty & health',
  //       quantity: 384,
  //       sales: 2300,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Soft Moisturizing Crème',
  //       name: 'Soft Moisturizing Crème',
  //       description:
  //           'NIVEA Soft Moisturizing Crème- Pack of 3, All-In-One Cream For Body, Face and Dry Hands - Use After Hand Washing - 6.8 oz. Jars',
  //       price: 50.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/619pgKveCdL._SL1500_.jpg',
  //       brand: 'No Brand',
  //       category: 'Beauty & health',
  //       quantity: 45,
  //       sales: 2300,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Body Cream Cocoa Butter',
  //       name: 'Body Cream Cocoa Butter',
  //       description: 'NIVEA Cocoa Butter Body Cream 15.5 Oz',
  //       price: 84.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/61EsS5sSaCL._SL1500_.jpg',
  //       brand: 'No brand',
  //       category: 'Beauty & health',
  //       quantity: 98432,
  //       sales: 8782,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Skin Repair Body Lotion',
  //       name: 'Skin Repair Body Lotion',
  //       description:
  //           'O\'Keeffe\'s Skin Repair Body Lotion and Dry Skin Moisturizer, Pump Bottle, 12 ounce, Packaging May Vary',
  //       price: 890.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/71e7ksQ-xyL._AC_SL1500_.jpg',
  //       brand: 'No brand',
  //       category: 'Beauty & health',
  //       quantity: 3811,
  //       sales: 2300,
  //       isPopular: false),
  //   ProductModel(
  //       id: 'Indomie Mi Goreng Instant Stir Fry Noodles',
  //       name: 'Indomie Mi Goreng Instant Stir Fry Noodles',
  //       description:
  //           'INCLUDES: 30 individually wrapped packets of Indomie Mi Goreng noodles. CALORIES: 390 Calories per serving. Each serving is (1) individual packet. ALLERGEN CALLOUTS: Preservatives, Sesame, Sesame Oil, Soy, Soybean, Wheat. HALAL: Halal certified. COOKING INSTRUCTIONS: Boil noodles for 3 minutes in water. Drain noodles. Empty condiment contents into pan on medium heat. Return noodles into pan and stir fry quickly for 1 - 2 minutes, evenly coating noodles. Enjoy!',
  //       price: 13.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/71B4YNvwCtL._SL1500_.jpg',
  //       brand: 'Indomie',
  //       category: 'Food',
  //       quantity: 3811,
  //       sales: 2293,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'Coca-Cola Coke Soda',
  //       name: 'Coca-Cola Coke Soda',
  //       description: 'Made in USA.12 cans per pack',
  //       price: 20.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/51uJdR27f7L._AC_UX466_.jpg',
  //       brand: 'Coca-Cola',
  //       category: 'Drinks',
  //       quantity: 380,
  //       sales: 93,
  //       isPopular: true),
  //   ProductModel(
  //       id: 'FITFORT Jump Rope',
  //       name: 'FITFORT Jump Rope',
  //       description:
  //           'Tangle-Free Rapid Speed Jumping Rope Cable with Ball Bearings for Women',
  //       price: 9.99,
  //       imageUrl:
  //           'https://images-na.ssl-images-amazon.com/images/I/71wm42EtoNL._AC_SL1500_.jpg',
  //       brand: 'Fitfort',
  //       category: 'Sport',
  //       quantity: 373,
  //       sales: 43,
  //       isPopular: false),
  // ];