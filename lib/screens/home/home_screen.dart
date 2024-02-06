import 'package:evminute/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:evminute/models/UserModel.dart';
import 'package:evminute/firebaseCalls/firebase_operations.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> filteredProducts; // Declare filtered products list

  @override
  void initState() {
    super.initState();
    filteredProducts = demoProducts; // Initialize filteredProducts
  }

  @override
  Widget build(BuildContext context) {
    // Fetch user information
    return FutureBuilder<UserModel?>(
      future: FirebaseOperations().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserModel? userInfo = snapshot.data;
          // List<Product> popularProducts =
          //     demoProducts.where((product) => product.isPopular).toList();
          if (userInfo != null) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      HomeHeader(
                        onSearch: (String searchText) {
                          setState(() {
                            // Filter the products based on the search text
                            filteredProducts = demoProducts
                                .where((product) => product.title
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const DiscountBanner(),
                      const SpecialOffers(),
                      const SizedBox(height: 20),
                      // PopularProducts(
                      //   demoProducts: popularProducts,
                      //   filteredProducts: filteredProducts,
                      // ), // Pass filteredProducts
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child:
                    CircularProgressIndicator()); // Handle loading state if needed
          }
        } else {
          return const Center(
              child:
                  CircularProgressIndicator()); // Handle loading state if needed
        }
      },
    );
  }
}
