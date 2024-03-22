import 'dart:async';
import 'dart:io';
import 'package:evminute/screens/profile/components/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:evminute/firebaseCalls/firebase_operations.dart';
import 'package:evminute/helper/loader.dart';
import 'package:evminute/helper/secure_storage.dart';
import 'package:evminute/models/UserModel.dart';
import 'package:evminute/helper/location_helper.dart';

final _secureStorage = SecureStorage();
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
  File? _selectedImage;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _profilePicController;
  late double _longitude;
  late double _latitude;
  LatLng? userLocation;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _updateLocationOnMap();
    _updateUserInfo();
    _firstNameController =
        TextEditingController(text: widget.userInfo?.firstName);
    _lastNameController =
        TextEditingController(text: widget.userInfo?.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.userInfo?.phoneNumber);
    _profilePicController =
        TextEditingController(text: widget.userInfo?.imageUrl);
    _longitude = widget.userInfo?.longitude ?? 35.5399434;
    _latitude = widget.userInfo?.latitude ?? 33.8748934;
  }

  Future<void> _updateLocationOnMap() async {
    await _getUserLocation();
    if (userLocation != null && _mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(userLocation!.latitude, userLocation!.longitude),
          11.0,
        ),
      );
    }
  }

  Future<void> _updateUserInfo() async {
    UserModel? updatedUserInfo = await FirebaseOperations().getUserInfo();

    if (updatedUserInfo != null) {
      setState(() {
        // Use updatedUserInfo to update the UI or controllers
        _firstNameController.text = updatedUserInfo.firstName;
        _lastNameController.text = updatedUserInfo.lastName;
        _phoneNumberController.text = updatedUserInfo.phoneNumber;
        _profilePicController.text = updatedUserInfo.imageUrl;
        _longitude = updatedUserInfo.longitude ?? 0.0;
        _latitude = updatedUserInfo.latitude ?? 0.0;
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

  Future<void> _getUserLocation() async {
    LatLng? location = await LocationHelper.getUserLocation();
    if (location != null) {
      setState(() {
        userLocation = location;
        // If mapController is available, move the camera to the new location
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(location, 11.0),
          );
        }
      });
    } else {
      // Handle error or show a message to the user
      print("Failed to get user location");
    }
  }

  Future<void> _sendUserDataToFirebase() async {
    if (_formKey.currentState!.validate()) {
      String? savedEmail = await _secureStorage.getEmail();
      if (_firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty &&
          _selectedImage != null) {
        await FirebaseOperations().sendUserData(
          email: savedEmail!,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneNumberController.text,
          latitude: _latitude,
          longitude: _longitude,
          image: _selectedImage,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile successfully updated!'),
          ),
        );

        // Optionally, you can navigate to another screen after the update
        // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      } else {
        // Show a snackbar upon successful update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('something went wrong, press Update!'),
          ),
        );
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
            imageUrl: _profilePicController.text,
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
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
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
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
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
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
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          SizedBox(
            height: 200,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _latitude,
                  _longitude,
                ),
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("userLocation"),
                  position: LatLng(
                    _latitude,
                    _longitude,
                  ),
                  infoWindow: const InfoWindow(title: "User Location"),
                ),
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _updateLocationOnMap();
              _getUserLocation();
            },
            child: const Text("Get My Location"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _globalLoader.showLoader(context);

              // Update the location on the map before sending data to Firebase
              await _updateLocationOnMap();

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
