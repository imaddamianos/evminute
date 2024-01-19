import 'dart:io';

import 'package:evminute/screens/login_success/login_success_screen.dart';
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

final _secureStorage = SecureStorage();
File? _selectedImage;

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({Key? key}) : super(key: key);
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstNametxt;
  String? lastNametxt;
  String? phoneNumbertxt;
  String? address;
  LatLng? userLocation;
  final GlobalLoader _globalLoader = GlobalLoader();

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
    String? savedEmail = await _secureStorage.getEmail();

    if (_formKey.currentState!.validate()) {
      if (firstNametxt != null &&
          lastNametxt != null &&
          phoneNumbertxt != null) {
        await FirebaseOperations().sendUserData(
          email: savedEmail!.replaceFirst(".", ""),
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
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
