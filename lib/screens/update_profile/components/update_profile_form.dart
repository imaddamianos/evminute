import 'dart:io';

import 'package:evminute/screens/login_success/login_success_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:evminute/screens/profile/components/profile_pic.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:evminute/helper/location_helper.dart';
import 'package:evminute/helper/google_map_widget.dart';
import 'package:evminute/firebaseCalls/firebase_operations.dart';
import 'package:evminute/helper/loader.dart';
import 'package:evminute/helper/secure_storage.dart';
import 'package:evminute/models/UserModel.dart';

final _secureStorage = SecureStorage();
File? _selectedImage;
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();

class UpdateProfileForm extends StatefulWidget {
  const UpdateProfileForm({Key? key}) : super(key: key);

  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstNametxt;
  String? lastNametxt;
  String? phoneNumbertxt;
  String? address;
  LatLng? userLocation;
  final GlobalLoader _globalLoader = GlobalLoader();
  UserModel? _userInfo;
  String? savedEmail;

  @override
  void initState() {
    super.initState();
    // Call a method to retrieve user information
    _getUserInfo();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> _getUserLocation() async {
    LatLng? location = await LocationHelper.getUserLocation();
    if (location != null) {
      setState(() {
        userLocation = location;
      });
    } else {
      // Handle error or show a message to the user
      print("Failed to get user location");
    }
  }

  Future<void> _sendUserDataToFirebase() async {
    if (_formKey.currentState!.validate()) {
      String? savedEmail = await _secureStorage.getEmail();
      if (firstNametxt != null &&
          lastNametxt != null &&
          phoneNumbertxt != null) {
        await FirebaseOperations().sendUserData(
          email: savedEmail!,
          firstName: firstNametxt!,
          lastName: lastNametxt!,
          phoneNumber: phoneNumbertxt!,
          latitude: userLocation?.latitude,
          longitude: userLocation?.longitude,
          image: _selectedImage, // Pass the selected image
        );

        Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      } else {
        print("Error: One or more required fields are null");
      }
    }
  }

  Future<void> _getUserInfo() async {
    try {
      String? savedEmail = await _secureStorage.getEmail();
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref
          .child('users')
          .child(savedEmail!.replaceFirst(".", ""))
          .get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>?;

        if (userData != null) {
          setState(() {
            _userInfo = UserModel(
              email: userData['email'],
              firstName: userData['firstName'],
              lastName: userData['lastName'],
              phoneNumber: userData['phoneNumber'],
              latitude: userData['userLocation']['latitude'],
              longitude: userData['userLocation']['longitude'],
            );
          });
          // Set the retrieved user info to the controllers
          firstNameController.text = _userInfo!.firstName ?? '';
          lastNameController.text = _userInfo!.lastName ?? '';
          phoneNumberController.text = _userInfo!.phoneNumber ?? '';
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error getting user info: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProfilePic(
            onPickImage: (File pickedImage) {
              _selectedImage = pickedImage;
            },
          ),
          TextFormField(
            controller: firstNameController,
            // initialValue: firstNametxt,
            onSaved: (newValue) => firstNametxt = newValue,
            onChanged: (value) {
              setState(() {
                firstNametxt = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: lastNameController,
            // initialValue: lastNametxt,
            onSaved: (newValue) => lastNametxt = newValue,
            onChanged: (value) {
              setState(() {
                lastNametxt = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kLastNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your last name",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: phoneNumberController,
            // initialValue: phoneNumbertxt,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumbertxt = newValue,
            onChanged: (value) {
              setState(() {
                phoneNumbertxt = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          ElevatedButton(
            onPressed: () {
              _globalLoader.showLoader(context);
              if (userLocation != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GoogleMapWidget(userLocation: userLocation!),
                  ),
                );
              } else {
                _getUserLocation();
                _globalLoader.hideLoader();
              }
            },
            child:
                Text(userLocation != null ? "Show on Map" : "Get My Location"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _globalLoader.showLoader(context);
              if (_formKey.currentState!.validate()) {
                await _sendUserDataToFirebase();
              }
              _globalLoader.hideLoader();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
