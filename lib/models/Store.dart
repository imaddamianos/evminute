// store_model.dart

class StoreData {
  final String location;
  final String name;

  StoreData({
    required this.location,
    required this.name,
  });
}

class Product {
  final String name;
  final String description;
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });
}
