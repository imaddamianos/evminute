import 'package:flutter/material.dart';
import 'package:evminute/screens/home/components/chargers_map.dart'; // Import your map screen file

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the map screen when the banner is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MapSample(), // Replace with your map screen
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 1, 126, 181),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: "Explore the world\n"),
              TextSpan(
                text: "of Electric Cars",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
