import 'package:new_swarn_holidays/ecom/components/default_button.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatelessWidget {
  final VoidCallback onCheckoutPressed;
  const CheckoutCard({
    Key? key,
    required this.onCheckoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDADADA).withOpacity(0.6),
            offset: const Offset(0, -15),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<num>(
                  future: UserDatabaseHelper().cartTotal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final cartTotal = snapshot.data;
                      return Text.rich(
                        TextSpan(text: "Total\n", children: [
                          TextSpan(
                            text: "₹$cartTotal",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Checkout",
                    press: onCheckoutPressed,
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
