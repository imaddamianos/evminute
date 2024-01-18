// import 'package:evminute/screens/complete_profile/complete_profile_screen.dart';
// import 'package:evminute/screens/profile/components/profile_pic.dart';
import 'dart:io';

import 'package:evminute/screens/complete_profile/complete_profile_screen.dart';
import 'package:evminute/screens/profile/components/profile_pic.dart';
import 'package:flutter/material.dart';

import 'components/profile_menu.dart';
import 'package:evminute/screens/profile/components/user_image.dart';
import 'package:evminute/screens/sign_in/sign_in_screen.dart';

File? _selectedImage;

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(
              onPickImage: (File pickedImage) {
                _selectedImage = pickedImage;
              },
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Profile",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Navigator.pushNamed(context, CompleteProfileScreen.routeName),
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Social Media",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                // try {
                // await FirebaseAuth.instance
                //     .signOut(); // Use FirebaseAuth to sign out
                Navigator.pushNamed(context, SignInScreen.routeName);
                // } catch (e) {
                //   // Handle sign-out errors if any
                //   print("Error signing out: $e");
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
