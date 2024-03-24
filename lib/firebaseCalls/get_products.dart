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
          rating: data['rating'].toDouble(),
          images: data['image'],
          id: data['id'],
          isPopular: data['isPopular'],
        );
      }).toList();
      demoProducts.addAll(products);

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      throw e;
    }
  }

  Future<List<Product>> getAllProductsFromAllStores() async {
    List<Product> allProducts = [];

    try {
      CollectionReference storesCollection =
          FirebaseFirestore.instance.collection('stores');
      QuerySnapshot storeSnapshot = await storesCollection.get();
      for (QueryDocumentSnapshot storeDoc in storeSnapshot.docs) {
        CollectionReference productsCollection =
            storeDoc.reference.collection('products');
        List<Product> storeProducts =
            await ProductService.getProductsForStore(productsCollection);
        allProducts.addAll(storeProducts);
      }
    } catch (e) {
      print('Error fetching products from all stores: $e');
      throw e;
    }

    return allProducts;
  }
}
