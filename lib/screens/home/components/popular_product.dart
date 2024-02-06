import 'package:flutter/material.dart';
import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  final List<Product> demoProducts; // Pass the demoProducts list
  final List<Product> filteredProducts;

  const PopularProducts({
    Key? key,
    required this.filteredProducts,
    required this.demoProducts,
  }) : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late List<Product> popularProducts;

  @override
  void initState() {
    super.initState();
    // Initialize popularProducts with all demoProducts initially
    popularProducts =
        widget.demoProducts.where((product) => product.isPopular).toList();
  }

  @override
  void didUpdateWidget(covariant PopularProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update popularProducts when filteredProducts change
    setState(() {
      popularProducts = widget.filteredProducts
          .where((product) => product.isPopular)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Products",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...popularProducts.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ProductCard(
                    product: product,
                    onPress: () => Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments: ProductDetailsArguments(product: product),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
