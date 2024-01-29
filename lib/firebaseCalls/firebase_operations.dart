import 'dart:io';
import 'package:evminute/helper/loader.dart';
import 'package:evminute/models/UserModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:evminute/helper/secure_storage.dart';

final _secureStorage = SecureStorage();
String imageUrl = '';

class FirebaseOperations {
  // ignore: deprecated_member_use
  final _databaseReference = FirebaseDatabase.instance.reference();
  final GlobalLoader _globalLoader = GlobalLoader();

  Future<UserModel?> getUserInfo() async {
    try {
      String? savedEmail = await _secureStorage.getEmail();
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref
          .child('users')
          .child(savedEmail!.replaceAll(RegExp(r'[.#$\[\]]'), ''))
          .get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>?;

        if (userData != null) {
          UserModel userInfo = UserModel(
            email: userData['email'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            phoneNumber: userData['phoneNumber'],
            latitude: userData['userLocation']['latitude'],
            longitude: userData['userLocation']['longitude'],
            imageUrl: userData['image'],
          );

          return userInfo;
        }
      } else {
        print('No data available.');
        return null;
      }
    } catch (error) {
      print('Error getting user info: $error');
      return null;
    }
    return null;
  }

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
        .child(email.replaceAll(RegExp(r'[.#$\[\]]'), ''))
        .set(userData);

    // Upload the image to Firebase Storage
    await uploadImage(email.replaceAll(RegExp(r'[.#$\[\]]'), ''), image!);
  }
}
