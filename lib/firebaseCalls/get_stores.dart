// store_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evminute/models/Store.dart';
import 'package:evminute/models/Product.dart';
import 'package:evminute/firebaseCalls/get_products.dart';

class StoreService {
  static Future<List<StoreData>> getStores() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();

      List<StoreData> stores =
          await Future.wait(querySnapshot.docs.map((doc) async {
        Map<String, dynamic> data = doc.data();
        demoProducts.clear();
        List<Product> products = await ProductService.getProductsForStore(
            doc.reference.collection('products'));

        return StoreData(
          location: data['location'],
          name: data['name'],
          image: data['image'],
          phone: data['phone'],
          website: data['website'],
          email: data['email'],
          products: products,
        );
      }).toList());

      return stores;
    } catch (e) {
      print('Error fetching stores: $e');
      throw e;
    }
  }
}
