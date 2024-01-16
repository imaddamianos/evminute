import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evminute/screens/init_screen.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const LoginSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Login Success"),
      ),
      body: Column(
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
          // Display the user's email if available
          if (user != null)
            Text(
              "${user.email}",
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
      ),
    );
  }
}
