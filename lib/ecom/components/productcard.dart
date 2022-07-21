import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import '../constants.dart';
import '../models/Product.dart';
import '../services/database/product_database_helper.dart';

class ProductCard1 extends StatefulWidget {
  final String? productId;
  final GestureTapCallback press;
  const ProductCard1({
    Key? key,
    required this.productId,
    required this.press,
  }) : super(key: key);

  @override
  _ProductCard1State createState() => _ProductCard1State();
}

class _ProductCard1State extends State<ProductCard1> {
  bool tapRqrd = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();

    final strng = doc.data()!['postId'];

    bool tapRqred = strng == null;
    setState(() {
      tapRqrd = tapRqred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapRqrd ? widget.press : () {},
      child: Container(
        decoration: BoxDecoration(
          color: tapRqrd
              ? Colors.black
              // Colors.white
              : Colors.orange.shade400.withOpacity(0.3),
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: FutureBuilder<Product?>(
                future:
                    ProductDatabaseHelper().getProductWithID(widget.productId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final Product product = snapshot.data!;
                    return buildProductCardItems(product);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    final String? error = snapshot.error.toString();
                    Logger().w(error);
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
            tapRqrd
                ? Container()
                : const Center(
                    child: Text(
                      'Product already used in a post, Choose any other',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.blue,
                        decorationThickness: 3,
                        //   backgroundColor: Colors.blue
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Column buildProductCardItems(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              product.images![0]!,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  "${product.title}\n",
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Text.rich(
                        TextSpan(
                          text: "₹${product.discountPrice}\n",
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: "₹${product.originalPrice}",
                              style: const TextStyle(
                                color: kTextColor,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/DiscountTag.svg",
                            color: kPrimaryColor,
                          ),
                          Center(
                            child: Text(
                              "${product.calculatePercentageDiscount()}%\nOff",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
