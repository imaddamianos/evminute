import 'package:evminute/screens/complete_profile/complete_profile_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/sign_up/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, CompleteProfileScreen.routeName),
          child: const Text(
            "Sign Up ",
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
