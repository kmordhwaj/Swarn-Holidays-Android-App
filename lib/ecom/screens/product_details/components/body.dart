import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/components/product_actions_section.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/components/product_images.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'product_review_section.dart';

class Body extends StatelessWidget {
  final String? productId;
  final String? currentUserId;

  const Body({Key? key, required this.productId, required this.currentUserId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: FutureBuilder<Product?>(
            future: ProductDatabaseHelper().getProductWithID(productId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final product = snapshot.data;
                return Column(
                  children: [
                    ProductImages(product: product),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductActionsSection(
                        product: product, currentUserId: currentUserId),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ProductReviewsSection(product: product),
                    SizedBox(height: getProportionateScreenHeight(100)),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
              }
              return const Center(
                child: Icon(
                  Icons.error,
                  color: kTextColor,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
