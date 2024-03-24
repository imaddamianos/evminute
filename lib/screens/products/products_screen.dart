import 'package:evminute/helper/google_map_widget.dart';
import 'package:evminute/models/Product.dart';
import 'package:evminute/screens/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:evminute/components/product_card.dart';
import 'package:evminute/models/Store.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  String instagramUrl = url.startsWith('http') ? url : 'https://$url';
  try {
    if (await canLaunch(instagramUrl)) {
      await launch(instagramUrl);
    } else {
      throw 'Could not launch $instagramUrl';
    }
  } on PlatformException catch (e) {
    print('Error launching Instagram: $e');
    // Handle platform exceptions here
  } catch (e) {
    print('Error launching Instagram: $e');
    // Handle other exceptions here
  }
}

void openGmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );

  if (await canLaunch(emailLaunchUri.toString())) {
    await launch(emailLaunchUri.toString());
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

void _callNumber(String phone) async {
  final Uri callUri = Uri(scheme: 'tel', path: phone);
  if (await canLaunch(callUri.toString())) {
    await launch(callUri.toString());
  } else {
    throw 'Could not launch $callUri';
  }
}

class StoreBanner extends StatelessWidget {
  final StoreData store;

  const StoreBanner({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image.network(
        //   store.image,
        // ),
        Container(
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                height: 40,
                store.image,
              ),
              IconButton(
                onPressed: () {
                  _callNumber(store.phone);
                },
                icon: Icon(Icons.phone,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              IconButton(
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
                icon: Icon(Icons.location_on,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              IconButton(
                onPressed: () {
                  _launchUrl(store.website);
                },
                icon: Icon(Icons.language,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              IconButton(
                onPressed: () {
                  openGmail(store.email);
                },
                icon: Icon(Icons.email,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ],
          ),
        ),
      ],
      // ),
    );
  }
}

void _launchWebsite() async {
  const url = 'https://www.evminute.co'; // Replace this with your website URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
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
        onPress: () => Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: ProductDetailsArguments(product: demoProducts[index]),
        ),
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
