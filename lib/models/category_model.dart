class CategoryModel {
  final String name;
  final String image;

  CategoryModel({required this.name, required this.image});

  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(name: 'Phone', image: 'assets/images/categories/phone.png'),
      CategoryModel(name: 'Shoes', image: 'assets/images/categories/shoes.png'),
      CategoryModel(
          name: 'Beauty', image: 'assets/images/categories/beauty.png'),
      CategoryModel(name: 'Food', image: 'assets/images/categories/food.png'),
      CategoryModel(
          name: 'Clothes', image: 'assets/images/categories/clothes.png'),
      CategoryModel(
          name: 'Computer', image: 'assets/images/categories/computer.png'),
      CategoryModel(
          name: 'Electronic', image: 'assets/images/categories/electronic.png'),
      CategoryModel(
          name: 'Drinks', image: 'assets/images/categories/drinks.png'),
      CategoryModel(name: 'Sport', image: 'assets/images/categories/sport.png'),
    ];
  }
}
