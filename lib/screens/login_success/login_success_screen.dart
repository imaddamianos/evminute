import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evminute/screens/init_screen.dart';
import 'package:evminute/helper/secure_storage.dart';

final _secureStorage = SecureStorage();

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";
  const LoginSuccessScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        // This widget will intercept the back button press
        onWillPop: () async {
          // Return false to prevent the back button action
          return false;
        },
        child: Center(
          child: FutureBuilder<String?>(
            // Fetch the saved email from secure storage
            future: _secureStorage.getEmail(),
            builder: (context, snapshot) {
              String? savedEmail = snapshot.data;

              // Retrieve the current user from FirebaseAuth
              User? user = FirebaseAuth.instance.currentUser;
              _secureStorage.saveEmailOnly(user?.email);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Image.asset(
                    "assets/images/success.png",
                    height: MediaQuery.of(context).size.height * 0.4, // 40%
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Login Success",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 184, 184, 183),
                    ),
                  ),
                  // Display the saved email if available
                  if (savedEmail != null && savedEmail.isNotEmpty)
                    Text(
                      savedEmail,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 184, 184, 183),
                      ),
                    ),
                  // Display the user's name if available
                  if (user != null && user.displayName != null)
                    Text(
                      "Welcome ${user.displayName}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 184, 184, 183),
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, InitScreen.routeName);
                      },
                      child: const Text("Explore"),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
