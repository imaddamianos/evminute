import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evminute/models/Store.dart';
import 'package:evminute/screens/home/components/special_offers.dart';

class StoreService {
  static Future<List<StoreData>> getStores() async {
    try {
      // Fetch store data from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();

      // Convert the query snapshot to a list of StoreData
      List<StoreData> stores = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return StoreData(
          location: data['name'],
          name: data['name'],
        );
      }).toList();

      return stores;
    } catch (e) {
      print('Error fetching stores: $e');
      throw e;
    }
  }
}
