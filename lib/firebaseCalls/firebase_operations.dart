import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:evminute/helper/secure_storage.dart';

final _databaseReference = FirebaseDatabase.instance.reference();
final _storage = FirebaseStorage.instance;
final _secureStorage = SecureStorage();

Future<void> sendUserData({
  String? email,
  String? firstName,
  String? lastName,
  String? phoneNumber,
  double? latitude,
  double? longitude,
  File? image, // Make the image parameter nullable
}) async {
  // Check if the image file is not null before attempting to upload
  if (image != null) {
    // Upload the image to Firebase Storage
    String? savedEmail = await _secureStorage.getEmail();
    final storageRef = _storage.ref('user_images').child('$savedEmail.jpg');
    await storageRef.putFile(image);

    // Get the download URL of the uploaded image
    final imageUrl = await storageRef.getDownloadURL();

    // Prepare user data with the image URL
    final userData = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userLocation': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'imageUrl': imageUrl,
    };

    // Save user data to the Firebase Realtime Database
    await _databaseReference.child('users').push().set(userData);
  } else {
    // Handle the case where the image is null (not provided)
    print('Image not provided. Skipping upload.');
  }
}
