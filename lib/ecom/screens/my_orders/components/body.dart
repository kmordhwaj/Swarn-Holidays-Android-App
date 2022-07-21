import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/components/nothingtoshow_container.dart';
import 'package:new_swarn_holidays/ecom/components/product_short_detail_card.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/OrderedProduct.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/models/Review.dart';
import 'package:new_swarn_holidays/ecom/screens/my_orders/components/product_review_dialog.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/product_details_screen.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/ordered_products_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final OrderedProductsStream orderedProductsStream = OrderedProductsStream();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
    orderedProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    orderedProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "Your Orders",
                    style: headingStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: buildOrderedProductsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    orderedProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<String>?>(
      stream: orderedProductsStream.stream as Stream<List<String>?>?,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderedProductsIds = snapshot.data!;
          if (orderedProductsIds.isEmpty) {
            return const Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: orderedProductsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<OrderedProduct>(
                future: UserDatabaseHelper().getOrderedProductFromId(
                    uid: currentUserId, id: orderedProductsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data!;
                    return buildOrderedProductItem(orderedProduct);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    final error = snapshot.error.toString();
                    Logger().e(error);
                  }
                  return const Icon(
                    Icons.error,
                    size: 60,
                    color: kTextColor,
                  );
                },
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return const Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildOrderedProductItem(OrderedProduct orderedProduct) {
    return FutureBuilder<Product?>(
      future:
          ProductDatabaseHelper().getProductWithID(orderedProduct.productUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kTextColor.withOpacity(0.12),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Ordered on:  ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: orderedProduct.orderDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: kTextColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  child: ProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                              productId: product.id,
                              currentUserId: currentUserId),
                        ),
                      ).then((_) async {
                        await refreshPage();
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      Review? prevReview;
                      try {
                        prevReview = await ProductDatabaseHelper()
                            .getProductReviewWithID(product.id, currentUserId!);
                      } on FirebaseException catch (e) {
                        Logger().w("Firebase Exception: $e");
                      } catch (e) {
                        Logger().w("Unknown Exception: $e");
                      } finally {
                        prevReview ??= Review(
                          currentUserId,
                          reviewerUid: currentUserId,
                        );
                      }

                      final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return ProductReviewDialog(
                            review: prevReview,
                          );
                        },
                      );
                      if (result is Review) {
                        bool reviewAdded = false;
                        String? snackbarMessage;
                        try {
                          reviewAdded = await ProductDatabaseHelper()
                              .addProductReview(product.id, result);
                          if (reviewAdded == true) {
                            snackbarMessage =
                                "Product review added successfully";
                          } else {
                            throw "Coulnd't add product review due to unknown reason";
                          }
                        } on FirebaseException catch (e) {
                          Logger().w("Firebase Exception: $e");
                          snackbarMessage = e.toString();
                        } catch (e) {
                          Logger().w("Unknown Exception: $e");
                          snackbarMessage = e.toString();
                        } finally {
                          Logger().i(snackbarMessage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackbarMessage!),
                            ),
                          );
                        }
                      }
                      await refreshPage();
                    },
                    child: const Text(
                      "Give Product Review",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();
          Logger().e(error);
        }
        return const Icon(
          Icons.error,
          size: 60,
          color: kTextColor,
        );
      },
    );
  }
}
