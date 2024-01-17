import 'package:firebase_database/firebase_database.dart';

class FirebaseOperations {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  Future<void> sendUserData({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    double? latitude,
    double? longitude,
  }) async {
    final userData = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userLocation': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };

    await _databaseReference.child('users').push().set(userData);
  }
}
