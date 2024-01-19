import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

String imageUrl = '';

class FirebaseOperations {
  // ignore: deprecated_member_use
  final _databaseReference = FirebaseDatabase.instance.reference();
  // final _secureStorage = FirebaseStorage.instance;

  Future<String> uploadImage(String user, File selectedImage) async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('user_image').child('$user.jpg');
      await storageRef.putFile(selectedImage);

      // Get the download URL of the uploaded image
      imageUrl = await storageRef
          .getDownloadURL(); // Print the URL to the console for debugging

      return imageUrl;
    } catch (error) {
      return 'no image'; // Return an empty string in case of an error
    }
  }

  Future<void> sendUserData({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    double? latitude,
    double? longitude,
    File? image,
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
      'image': imageUrl,
    };

    await _databaseReference
        .child('users')
        .child(firstName + lastName)
        .set(userData);

    // Upload the image to Firebase Storage
    await uploadImage(email, image!);
  }
}
