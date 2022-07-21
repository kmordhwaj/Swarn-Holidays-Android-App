import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: product!.title,
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "\n${product!.variant} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: getProportionateScreenHeight(55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text.rich(
                      TextSpan(
                        text: "₹${product!.discountPrice}   ",
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: "\n₹${product!.originalPrice}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      "${product!.calculatePercentageDiscount()}% Off",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: getProportionateScreenHeight(18),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Highlights",
              content: product!.highlights,
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Description",
              content: product!.description,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "Sold by ",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "${product!.seller}",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
