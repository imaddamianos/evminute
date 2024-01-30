import 'dart:io';

import 'package:evminute/helper/loader.dart';
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
import 'package:evminute/helper/secure_storage.dart';

final _secureStorage = SecureStorage();
File? _selectedImage;
final GlobalLoader _globalLoader = GlobalLoader();

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
  // final GlobalLoader _globalLoader = GlobalLoader();

  bool get isFormValid =>
      firstNametxt != null &&
      lastNametxt != null &&
      phoneNumbertxt != null &&
      _selectedImage != null &&
      userLocation != null;

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
        _globalLoader.hideLoader();
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
          email: savedEmail!.replaceAll(RegExp(r'[.#$\[\]]'), ''),
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
            imageUrl: '',
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(color: Colors.white),
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
                _globalLoader.hideLoader();
              } else {
                _getUserLocation();
              }
            },
            child:
                Text(userLocation != null ? "Show on Map" : "Get My Location"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isFormValid
                ? () async {
                    _globalLoader.showLoader(context);
                    await _sendUserDataToFirebase();
                    _globalLoader.hideLoader();
                  }
                : null, // Disable the button if the form is not valid
            style: ElevatedButton.styleFrom(
              primary: isFormValid ? Colors.blue : Colors.grey,
            ),
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
