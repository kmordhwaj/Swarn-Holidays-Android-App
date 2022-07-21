import 'package:new_swarn_holidays/ecom/models/CartItem.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  const CartItemCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: ProductDatabaseHelper().getProductWithID(cartItem.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              SizedBox(
                width: getProportionateScreenWidth(88),
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // ignore: use_full_hex_values_for_flutter_colors
                      color: const Color(0xFFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      snapshot.data!.images![0]!,
                    ),
                  ),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                        text: "\$${snapshot.data!.originalPrice}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: "  x${cartItem.itemCount}",
                            style: const TextStyle(
                              color: kTextColor,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        } else {
          return const Center(
            child: Icon(
              Icons.error,
            ),
          );
        }
      },
    );
  }
}
