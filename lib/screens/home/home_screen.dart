// home_screen.dart

import 'package:flutter/material.dart';
import 'package:evminute/models/UserModel.dart';
import 'package:evminute/firebaseCalls/firebase_operations.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch user information
    return FutureBuilder<UserModel?>(
      future: FirebaseOperations().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserModel? userInfo = snapshot.data;

          if (userInfo != null) {
            return const Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      HomeHeader(),
                      DiscountBanner(),
                      SpecialOffers(),
                      SizedBox(height: 20),
                      PopularProducts(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator(); // Handle loading state if needed
          }
        } else {
          return const CircularProgressIndicator(); // Handle loading state if needed
        }
      },
    );
  }
}
