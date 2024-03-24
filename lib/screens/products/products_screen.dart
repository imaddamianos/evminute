import 'package:evminute/helper/google_map_widget.dart';
import 'package:evminute/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:evminute/components/product_card.dart';
import 'package:evminute/models/Store.dart';

class StoreBanner extends StatelessWidget {
  final StoreData store;

  const StoreBanner({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: AlignmentDirectional.center,
          child: Column(
            children: [
              SizedBox(height: 5),
              Text(
                store.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Phone: ${store.phone}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              // SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Navigate to GoogleMapWidget with the provided location
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GoogleMapWidget(initialLocation: store.location),
                    ),
                  );
                },
                child: Text(
                  'Find store',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 130, 251),
                  ),
                ),
              ),
              SizedBox(height: 5),
              // Text(
              //   'Email: ${store.email}',
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              // ),
              // SizedBox(height: 8),
              // Text(
              //   'Website: ${store.website}',
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ),
        Image.network(
          store.image,
          width: 100,
          // height: 100,
          // fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}

class ProductsList extends StatelessWidget {
  final List<Product> products;

  const ProductsList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.7,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) => ProductCard(
        product: products[index],
        onPress: () {},
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  final StoreData store;

  const ProductsScreen({Key? key, required this.store}) : super(key: key);

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: Column(
        children: [
          StoreBanner(store: store),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProductsList(products: store.products),
            ),
          ),
        ],
      ),
    );
  }
}
