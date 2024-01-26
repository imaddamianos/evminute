import 'dart:io';

import 'package:evminute/screens/login_success/login_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:evminute/firebaseCalls/firebase_operations.dart';
import 'package:evminute/helper/loader.dart';
import 'package:evminute/helper/secure_storage.dart';
import 'package:evminute/models/UserModel.dart';

final _secureStorage = SecureStorage();
File? _selectedImage;
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController locationController = TextEditingController();
GoogleMapController? mapController;

class UpdateProfileForm extends StatefulWidget {
  final UserModel? userInfo;

  const UpdateProfileForm({Key? key, this.userInfo}) : super(key: key);

  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstNametxt;
  String? lastNametxt;
  String? phoneNumbertxt;
  final GlobalLoader _globalLoader = GlobalLoader();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userInfo?.firstName);
    _lastNameController =
        TextEditingController(text: widget.userInfo?.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.userInfo?.phoneNumber);

    // Call FirebaseOperations().getUserInfo() to get updated user info
    _updateUserInfo();
  }

  Future<void> _updateUserInfo() async {
    UserModel? updatedUserInfo = await FirebaseOperations().getUserInfo();

    if (updatedUserInfo != null) {
      setState(() {
        // Use updatedUserInfo to update the UI or controllers
        _firstNameController.text = updatedUserInfo.firstName;
        _lastNameController.text = updatedUserInfo.lastName;
        _phoneNumberController.text = updatedUserInfo.phoneNumber;
      });
    }
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
          latitude: widget.userInfo?.latitude,
          longitude: widget.userInfo?.longitude,
          image: _selectedImage,
        );

        // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
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
          TextFormField(
            controller: _firstNameController,
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
            // ... Remaining code ...
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _lastNameController,
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
            // ... Remaining code ...
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumberController,
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
            // ... Remaining code ...
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
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
