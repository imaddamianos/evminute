import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/update_profile_form.dart';

class UpdateProfileScreen extends StatelessWidget {
  static String routeName = "/update_profile";
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: const SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text("Profile", style: headingStyle),
                  Text(
                    "Update your details",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  UpdateProfileForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
