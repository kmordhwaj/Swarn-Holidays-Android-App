import 'dart:async';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/components/nothingtoshow_container.dart';
import 'package:new_swarn_holidays/ecom/components/product_short_detail_card.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/screens/edit_product/edit_product_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/product_details_screen.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/users_products_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:new_swarn_holidays/ecom/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

import '../../../utils.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final UsersProductsStream usersProductsStream = UsersProductsStream();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
    usersProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    usersProductsStream.dispose();
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
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text("Your Products", style: headingStyle),
                  const Text(
                    "Swipe LEFT to Edit, Swipe RIGHT to Delete",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.7,
                    child: StreamBuilder<List<String>?>(
                      stream:
                          usersProductsStream.stream as Stream<List<String>?>?,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final productsIds = snapshot.data!;
                          if (productsIds.isEmpty) {
                            return const Center(
                              child: NothingToShowContainer(
                                secondaryMessage:
                                    "Add your first Product to Sell",
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: productsIds.length,
                            itemBuilder: (context, index) {
                              return buildProductsCard(productsIds[index]);
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
                          child: NothingToShowContainer(
                            iconPath: "assets/icons/network_error.svg",
                            primaryMessage: "Something went wrong",
                            secondaryMessage: "Unable to connect to Database",
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(60)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    usersProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildProductsCard(String productId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FutureBuilder<Product?>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data!;
            return buildProductDismissible(product);
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
    );
  }

  Widget buildProductDismissible(Product product) {
    return Dismissible(
      key: Key(product.id!),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: ProductShortDetailCard(
        productId: product.id,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: product.id,
                currentUserId: currentUserId,
              ),
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
              context, "Are you sure to Delete Product?");
          if (confirmation) {
            for (int i = 0; i < product.images!.length; i++) {
              String path =
                  ProductDatabaseHelper().getPathForProductImage(product.id, i);
              final deletionFuture =
                  FirestoreFilesAccess().deleteFileFromPath(path);
              await showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    deletionFuture,
                    message: Text(
                        "Deleting Product Images ${i + 1}/${product.images!.length}"),
                  );
                },
              );
            }

            bool? productInfoDeleted = false;
            String? snackbarMessage;
            try {
              final deleteProductFuture =
                  ProductDatabaseHelper().deleteUserProduct(product.id);
              productInfoDeleted = await (showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    deleteProductFuture,
                    message: const Text("Deleting Product"),
                  );
                },
              ) as FutureOr<bool>);
              if (productInfoDeleted == true) {
                snackbarMessage = "Product deleted successfully";
              } else {
                throw "Coulnd't delete product, please retry";
              }
            } on FirebaseException catch (e) {
              Logger().w("Firebase Exception: $e");
              snackbarMessage = "Something went wrong";
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
          return confirmation;
        } else if (direction == DismissDirection.endToStart) {
          final confirmation = await showConfirmationDialog(
              context, "Are you sure to Edit Product?");
          if (confirmation) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  productToEdit: product,
                ),
              ),
            );
          }
          await refreshPage();
          return false;
        }
        return false;
      },
      onDismissed: (direction) async {
        await refreshPage();
      },
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
