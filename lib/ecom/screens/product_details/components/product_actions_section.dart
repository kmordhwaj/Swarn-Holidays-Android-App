import 'package:new_swarn_holidays/ecom/components/top_rounded_container.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/messagebutton.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/components/product_description.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/provider_models/ProductActions.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import '../../../size_config.dart';

class ProductActionsSection extends StatefulWidget {
  final Product? product;
  final String? currentUserId;

  const ProductActionsSection(
      {Key? key, required this.product, required this.currentUserId})
      : super(key: key);

  @override
  _ProductActionsSectionState createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  String? currentUserId;
  String? rentOwnerId;
  String? rentOwnerDp;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        Stack(
          children: [
            TopRoundedContainer(
              child: ProductDescription(product: widget.product),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 120.0),
                child: Row(
                  children: [buildFavouriteButton(), buildProfileButton()],
                ),
              ),
            ),
          ],
        ),
      ],
    );
    UserDatabaseHelper()
        .isProductFavourite(uid: currentUserId, productId: widget.product!.id)
        .then(
      (value) {
        final productActions =
            Provider.of<ProductActions>(context, listen: false);
        productActions.productFavStatus = value;
      },
    ).catchError(
      (e) {
        Logger().w("$e");
      },
    );
    return column;
  }

  Widget buildProfileButton() {
    return Consumer<ProductActions>(builder: (context, productDetails, child) {
      return Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6E6),
            // Colors.blueGrey,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 20,
            child: Center(child: MessageButton()),
          ));
    });
  }

  Widget buildFavouriteButton() {
    return Consumer<ProductActions>(
      builder: (context, productDetails, child) {
        return InkWell(
          onTap: () async {
            bool success = false;
            final future = UserDatabaseHelper()
                .switchProductFavouriteStatus(
                    productId: widget.product!.id,
                    uid: currentUserId,
                    newState: !productDetails.productFavStatus)
                .then((status) {
              success = status;
            }).catchError((e) {
              Logger().e(e.toString());
              success = false;
            });
            await showDialog(
              context: context,
              builder: (context) {
                return FutureProgressDialog(
                  future,
                  message: Text(
                    productDetails.productFavStatus
                        ? "Removing from Favourites"
                        : "Adding to Favourites",
                  ),
                );
              },
            );
            if (success) {
              productDetails.switchProductFavStatus();
            }
          },
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            decoration: BoxDecoration(
              color: productDetails.productFavStatus
                  ? const Color(0xFFFFE6E6)
                  : const Color(0xFFF5F6F9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(8)),
              child: Icon(
                Icons.favorite,
                color: productDetails.productFavStatus
                    ? const Color(0xFFFF4848)
                    : const Color(0xFFD8DEE4),
              ),
            ),
          ),
        );
      },
    );
  }
}
