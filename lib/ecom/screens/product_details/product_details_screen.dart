import 'package:new_swarn_holidays/ecom/screens/product_details/provider_models/ProductActions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/fab.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String? productId;
  final String? currentUserId;

  const ProductDetailsScreen(
      {Key? key, required this.productId, required this.currentUserId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        //    backgroundColor: const Color(0xFFF5F6F9),
        appBar: AppBar(
            //  backgroundColor: const Color(0xFFF5F6F9),
            ),
        body: Body(productId: productId, currentUserId: currentUserId),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AddToCartFAB(productId: productId),
              //   SizedBox(width: 20),
              BuyProductFAB(productId: productId),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
