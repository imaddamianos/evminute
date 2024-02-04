import 'package:evminute/screens/login_success/login_success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  SignInScreen({super.key});
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

      // Fetch additional user details likfshowe display name
      if (user != null) {
        await user.reload(); // Reload user to get updated data
        await user.getIdToken();
        user.displayName;

        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      }
    } catch (e) {
      // Handle errors
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/splash_1.png",
                    width: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Color.fromARGB(255, 184, 184, 183),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SignForm(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () {
                          signInWithGoogle(context);
                        },
                      ),
                      const Text(
                        "Sign in with Google",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
