import 'package:new_swarn_holidays/ecom/components/top_rounded_container.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/models/Review.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'review_box.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(320),
      child: Stack(
        children: [
          TopRoundedContainer(
            child: Column(
              children: [
                const Text(
                  "Product Reviews",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                  child: StreamBuilder<List<Review>>(
                    stream: ProductDatabaseHelper()
                        .getAllReviewsStreamForProductId(product!.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final reviewsList = snapshot.data!;
                        if (reviewsList.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/review.svg",
                                  color: kTextColor,
                                  width: 40,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "No reviews yet",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: reviewsList.length,
                          itemBuilder: (context, index) {
                            return ReviewBox(
                              review: reviewsList[index],
                            );
                          },
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        final error = snapshot.error;
                        Logger().w(error.toString());
                      }
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: kTextColor,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: buildProductRatingWidget(product!.rating),
          ),
        ],
      ),
    );
  }

  Widget buildProductRatingWidget(num? rating) {
    return Container(
      width: getProportionateScreenWidth(80),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$rating",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.star,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
