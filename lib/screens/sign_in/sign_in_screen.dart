import 'package:evminute/helper/sign_in_google.dart';
import 'package:flutter/material.dart';
import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  final AuthService _authService = AuthService();

  SignInScreen({Key? key}) : super(key: key);
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // This widget will intercept the back button press
      onWillPop: () async {
        // Return false to prevent the back button action
        return false;
      },
      child: Scaffold(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocalCard(
                          icon: "assets/icons/google-icon.svg",
                          press: () {
                            _authService.signInWithGoogle(context);
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
                    const SignForm(),
                    const SizedBox(height: 16),
                    const NoAccountText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
