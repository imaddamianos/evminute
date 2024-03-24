import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Text(
          product.description,
          maxLines: 3,
        ),
        Text(
          'Price ' + product.price.toString(),
          maxLines: 3,
        ),
        Text(
          'Rating ' + product.rating.toString(),
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 184, 184, 183),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 50),

        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Container(
        //     padding: const EdgeInsets.all(16),
        //     width: 48,
        //     decoration: BoxDecoration(
        //       color: product.isFavourite
        //           ? const Color(0xFFFFE6E6)
        //           : const Color(0xFFF5F6F9),
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(20),
        //         bottomLeft: Radius.circular(20),
        //       ),
        //     ),
        //     child: SvgPicture.asset(
        //       "assets/icons/Heart Icon_2.svg",
        //       colorFilter: ColorFilter.mode(
        //           product.isFavourite
        //               ? const Color(0xFFFF4848)
        //               : const Color(0xFFDBDEE4),
        //           BlendMode.srcIn),
        //       height: 16,
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 20,
        //     vertical: 12,
        //   ),
        //   // child: GestureDetector(
        //   //   onTap: () {},
        //   //   child: const Row(
        //   //     children: [
        //   //       Text(
        //   //         "See More Detail",
        //   //         style: TextStyle(
        //   //             fontWeight: FontWeight.w600, color: kPrimaryColor),
        //   //       ),
        //   //       SizedBox(width: 5),
        //   //       Icon(
        //   //         Icons.arrow_forward_ios,
        //   //         size: 12,
        //   //         color: kPrimaryColor,
        //   //       ),
        //   //     ],
        //   //   ),
        //   // ),
        // )
      ],
    );
  }
}
