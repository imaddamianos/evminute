import 'package:flutter/material.dart';
import 'package:evminute/models/Product.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'popular_product.dart'; // Import the PopularProducts widget

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
    required Null Function(String searchText) onSearch,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int notificationNum = 1;
  String? selectedProduct;
  late List<Product> filteredProducts; // Declare filtered products list

  @override
  void initState() {
    super.initState();
    filteredProducts =
        demoProducts.where((product) => product.isPopular).toList();
  }

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
    List<Product> popularProducts =
        demoProducts.where((product) => product.isPopular).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchField(
                  onSearch: (String searchText) {
                    setState(() {
                      // Filter the popular products based on the search text
                      filteredProducts = demoProducts
                          .where((product) => product.title
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              const SizedBox(
                  width:
                      16), // Add spacing between search field and icon button
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
          const SizedBox(
              height:
                  8), // Add spacing between search field and popular products
          Column(
            children: [
              PopularProducts(
                filteredProducts: filteredProducts,
                demoProducts: popularProducts,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
