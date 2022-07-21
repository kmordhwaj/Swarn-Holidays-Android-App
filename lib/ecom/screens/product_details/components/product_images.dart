import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/provider_models/ProductImageSwiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
//import 'package:swipedetector/swipedetector.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatelessWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductImageSwiper(),
      child: Consumer<ProductImageSwiper>(
        builder: (context, productImagesSwiper, child) {
          return Column(
            children: [
              /*    SwipeDetector(
                onSwipeLeft: () {
                  productImagesSwiper.currentImageIndex++;
                  productImagesSwiper.currentImageIndex %=
                      product!.images!.length;
                },
                onSwipeRight: () {
                  productImagesSwiper.currentImageIndex--;
                  productImagesSwiper.currentImageIndex +=
                      product!.images!.length;
                  productImagesSwiper.currentImageIndex %=
                      product!.images!.length;
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: SizedBox(
                    height: SizeConfig.screenHeight * 0.35,
                    width: SizeConfig.screenWidth * 0.75,
                    child: Image.network(
                      product!.images![productImagesSwiper.currentImageIndex]!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ), */
              Stack(
                children: [
                  CarouselSlider.builder(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: MediaQuery.of(context).size.height / 2.5,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1500),
                        viewportFraction: 1,
                      ),
                      itemCount: product!.images!.length,
                      itemBuilder: (sliderContext, itemIndex, realIndex) =>
                          Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                            width: MediaQuery.of(context).size.width - 20,
                            margin: const EdgeInsets.only(top: 20.0),
                            child: PhotoView(
                              imageProvider: CachedNetworkImageProvider(
                                product!.images![itemIndex
                                    //  productImagesSwiper.currentImageIndex
                                    ]!,
                              ),
                              loadingBuilder: (context, event) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorBuilder: (context, obj, stackTrace) =>
                                  Center(
                                child: Image.asset(
                                  'assets/images/error_image.jpg',
                                  width: 300,
                                ),
                              ),
                              enableRotation: false,
                              backgroundDecoration: const BoxDecoration(
                                  //        color: Colors.white,
                                  ),
                            ),
                          )),
                  Align(
                    alignment: Alignment.centerRight,
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      width: 45,
                      height: 45,
                      child: Flexible(
                        flex: 3,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/Discount.svg",
                              color: kPrimaryColor,
                            ),
                            Center(
                              child: Text(
                                "${product!.calculatePercentageDiscount()}%\nOff",
                                style: TextStyle(
                                  //      color: Colors.white,
                                  fontSize: getProportionateScreenHeight(12),
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Flexible(
                          flex: 3,
                          child: FutureBuilder(
                              future: UserDatabaseHelper()
                                  .postMediaUrlRent(product!.id),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  final mediaUrl = snapshot.data;
                                  return GestureDetector(
                                    onTap: () {
                                      // navigate to that post page
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(mediaUrl),
                                    ),
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
                                return Container();
                              })),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    product!.images!.length,
                    (index) =>
                        buildSmallPreview(productImagesSwiper, index: index),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSmallPreview(ProductImageSwiper productImagesSwiper,
      {required int index}) {
    return GestureDetector(
      onTap: () {
        productImagesSwiper.currentImageIndex = index;
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
        padding: EdgeInsets.all(getProportionateScreenHeight(8)),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: productImagesSwiper.currentImageIndex == index
                  ? kPrimaryColor
                  : Colors.transparent),
        ),
        child: Image.network(product!.images![index]!),
      ),
    );
  }
}
