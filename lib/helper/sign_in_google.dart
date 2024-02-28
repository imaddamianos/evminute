import 'package:evminute/screens/login_success/login_success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with Google using Firebase
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      // Fetch additional user details like display name
      if (user != null) {
        await user.reload(); // Reload user to get updated data
        await user.getIdToken();
        user.displayName;

        // Navigate to success screen after successful sign-in
        Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      }
      await saveGoogleSignInState(true);
    } catch (e) {
      // Handle errors
      debugPrint(e.toString());
    }
  }

  Future<void> saveGoogleSignInState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGoogleLoggedIn', isLoggedIn);
  }
}
