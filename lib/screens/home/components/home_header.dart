import 'package:flutter/material.dart';

import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int notificationNum = 1;

  // Function to show the greeting alert
  void showGreetingAlert(BuildContext context) {
    setState(() {
      notificationNum = 0; // Update notificationNum and trigger a rebuild
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Welcome to EVMINUTE"),
          content: const Text(
              "Enjoy our Application and stay updated to know everything about Electric Vehicle."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
          const SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: notificationNum,
            press: () {
              showGreetingAlert(
                  context); // Call the function to show the greeting alert
            },
          ),
        ],
      ),
    );
  }
}

 


//  title: const Text("Welcome to EVMINUTE"),
//           content: const Text(
//               "Enjoy our Application and stay updated to know everything about Electric Vehicle.")