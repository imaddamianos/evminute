// store_model.dart
import 'package:evminute/models/Product.dart';

class StoreData {
  final String location;
  final String name;
  final String image;
  final List<Product> products;

  StoreData({
    required this.location,
    required this.name,
    required this.image,
    required this.products,
  });
}
