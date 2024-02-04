// product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evminute/models/Product.dart';

class ProductService {
  static Future<List<Product>> getProductsForStore(
      CollectionReference productsCollection) async {
    try {
      QuerySnapshot<Object?> querySnapshot = await productsCollection.get();

      List<Product> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>; // Explicit casting
        return Product(
          title: data['name'],
          description: data['description'],
          price: data['price'].toDouble(),
          images: data['image'],
          id: data['id'],
        );
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      throw e;
    }
  }
}
