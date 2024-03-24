// special_offers.dart
import 'package:evminute/screens/home/components/special_offer_card.dart';
import 'package:flutter/material.dart';
import 'package:evminute/models/Store.dart';
import 'package:evminute/screens/products/products_screen.dart';
import 'package:evminute/firebaseCalls/get_stores.dart';

import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Stores",
            press: () {},
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder<List<StoreData>>(
          future: StoreService.getStores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No stores available');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data!.map((store) {
                    return SpecialOfferCard(
                      image: store.image,
                      name: store.name,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsScreen(store: store),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
