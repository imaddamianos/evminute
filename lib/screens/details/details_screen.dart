import 'package:evminute/constants.dart';
import 'package:flutter/material.dart';
import '../../models/Product.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = agrs.product;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: kEvMinuteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromARGB(255, 184, 184, 183),
              size: 20,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
            color: const Color.fromARGB(105, 255, 255, 255),
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),
                // TopRoundedContainer(
                //   color: const Color(0xFFF6F7F9),
                //   child: Column(
                //     children: [
                //       ColorDots(product: product),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: TopRoundedContainer(
      //   color: Colors.white,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //       child: ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, CartScreen.routeName);
      //         },
      //         child: const Text("Add To Cart"),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
