import 'package:evminute/screens/social_media_page.dart';
import 'package:evminute/screens/update_profile/update_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/profile_menu.dart';
import 'package:evminute/screens/sign_in/sign_in_screen.dart';
import 'package:evminute/helper/secure_storage.dart';

final _secureStorage = SecureStorage();

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Profile",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Navigator.pushNamed(context, UpdateProfileScreen.routeName),
              },
            ),
            // ProfileMenu(
            //   text: "Notifications",
            //   icon: "assets/icons/Bell.svg",
            //   press: () {},
            // ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: "assets/icons/Settings.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "Social Media",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Navigator.pushNamed(context, SocialMediaPage.routeName);
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                try {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('isGoogleLoggedIn');
                  await FirebaseAuth.instance
                      .signOut(); // Use FirebaseAuth to sign out
                  _secureStorage.clearEmailAndPassword();
                  Navigator.pushNamed(context, SignInScreen.routeName);
                } catch (e) {
                  // Handle sign-out errors if any
                  print("Error signing out: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
