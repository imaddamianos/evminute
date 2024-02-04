// products_screen.dart
import 'package:flutter/material.dart';
import 'package:evminute/components/product_card.dart';
import 'package:evminute/models/Store.dart';

class ProductsScreen extends StatelessWidget {
  final StoreData store;

  const ProductsScreen({Key? key, required this.store}) : super(key: key);

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products - ${store.name}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: store.products.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              product: store.products[index],
              onPress: () {},
            ),
          ),
        ),
      ),
    );
  }
}
