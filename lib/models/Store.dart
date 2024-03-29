// store_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evminute/models/Product.dart';

class StoreData {
  final GeoPoint location;
  final String name;
  final String image;
  final String phone;
  final String website;
  final String email;
  final List<Product> products;

  StoreData({
    required this.location,
    required this.name,
    required this.image,
    required this.phone,
    required this.website,
    required this.email,
    required this.products,
  });

  get address => null;
}
