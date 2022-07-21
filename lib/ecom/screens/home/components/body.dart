import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/screens/cart/cart_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/category_products/category_products_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/home_header_down2.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/home_header_up.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/product_details_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/search_result2/search_result_screen2.dart';
//import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/all_products_stream.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/favourite_products_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';
//import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import '../../../utils.dart';
import 'product_type_box.dart';
import 'products_section.dart';

// ignore: constant_identifier_names
const String ICON_KEY = "icon";
// ignore: constant_identifier_names
const String TITLE_KEY = "title";
// ignore: constant_identifier_names
const String PRODUCT_TYPE_KEY = "product_type";

class Body extends StatefulWidget {
  final String? currentUserId;
  const Body({
    Key? key,
    this.currentUserId,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int activeIndex = 0;

  final productCategories = <Map>[
    <String, dynamic>{
      ICON_KEY: "assets/icons/Electronics.svg",
      TITLE_KEY: "Electronics",
      PRODUCT_TYPE_KEY: ProductType.Electronics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Books.svg",
      TITLE_KEY: "Books",
      PRODUCT_TYPE_KEY: ProductType.Books,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Fashion.svg",
      TITLE_KEY: "Fashion",
      PRODUCT_TYPE_KEY: ProductType.Fashion,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Groceries.svg",
      TITLE_KEY: "Groceries",
      PRODUCT_TYPE_KEY: ProductType.Groceries,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Art.svg",
      TITLE_KEY: "Art",
      PRODUCT_TYPE_KEY: ProductType.Art,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Others",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];

  final FavouriteProductsStream favouriteProductsStream =
      FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();

  @override
  void initState() {
    super.initState();
    favouriteProductsStream.init();
    allProductsStream.init();
  }

  @override
  void dispose() {
    favouriteProductsStream.dispose();
    allProductsStream.dispose();
    super.dispose();
  }

  final urlImages = [
    'https://amazingarchitecture.com/storage/files/1/architecture-firms/mohanad-albasha/selina-villa/selina_villa_dubai_uae_gravity_studio_mohanad_albasha-1.jpg',
    'https://samujana.com/wp-content/uploads/2022/04/slider_samujana_villa_01b.jpeg',
    'https://www.elitehavens.com/magazine/wp-content/uploads/2021/05/Header.jpg',
    'https://e8rbh6por3n.exactdn.com/sites/uploads/2020/05/villa-la-gi-thumbnail.jpg?strip=all&lossy=1&ssl=1'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: getProportionateScreenHeight(15)),
              const HomeHeaderUp(),
              const SizedBox(height: 5),
              HomeHeaderDown2(
                onSearchSubmitted: (value) async {
                  final String? query = value.toString();
                  if (query!.isEmpty) return;
                  List<String?>? searchedProductsId;
                  try {
                    searchedProductsId = await ProductDatabaseHelper()
                        .searchInProducts(query.toLowerCase());

                    if (searchedProductsId != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultScreen2(
                            searchQuery: query,
                            searchResultProductsId: searchedProductsId,
                            searchIn: "All Products",
                          ),
                        ),
                      );
                      await refreshPage();
                    } else {
                      throw "Couldn't perform search due to some unknown reason";
                    }
                  } catch (e) {
                    final String? error = e.toString();
                    Logger().e(error);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$error"),
                      ),
                    );
                  }
                },
                onCartButtonPressed: () async {
                  /*    bool allowed = AuthentificationService().currentUserVerified;
                  if (!allowed) {
                    final reverify = await showConfirmationDialog(context,
                        "You haven't verified your email address. This action is only allowed for verified users.",
                        positiveResponse: "Resend verification email",
                        negativeResponse: "Go back");
                    if (reverify) {
                      final future = AuthentificationService()
                          .sendVerificationEmailToCurrentUser();
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return FutureProgressDialog(
                            future,
                            message: const Text("Resending verification email"),
                          );
                        },
                      );
                    }
                    return;
                  } */
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                  await refreshPage();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...List.generate(
                        productCategories.length,
                        (index) {
                          return ProductTypeBox(
                            icon: productCategories[index][ICON_KEY],
                            title: productCategories[index][TITLE_KEY],
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryProductsScreen(
                                    productType: productCategories[index]
                                        [PRODUCT_TYPE_KEY],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              _autoSlider(),
              /*    SizedBox(
                height: SizeConfig.screenHeight * 0.5,
                child: ProductsSection(
                  sectionTitle: "Products You Like",
                  productsStreamController: favouriteProductsStream,
                  emptyListMessage: "Add Product to Favourites",
                  onProductCardTapped: onProductCardTapped,
                ),
              ), */
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.8,
                child: ProductsSection(
                  sectionTitle: "Explore All Products",
                  productsStreamController: allProductsStream,
                  emptyListMessage: "Looks like all Stores are closed",
                  onProductCardTapped: onProductCardTapped,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(80)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String? productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
            productId: productId, currentUserId: widget.currentUserId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }

  _autoSlider() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                autoPlay: true,
                height: 280,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                viewportFraction: 0.8,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, reason) => setState(() {
                      activeIndex = index;
                    })),
            itemCount: urlImages.length,
            itemBuilder: (context, index, realIndex) {
              final urlImage = urlImages[index];
              return buildImage(urlImage, index);
            },
          ),
          const SizedBox(height: 10),
          buildIndicator()
        ],
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.grey,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: urlImage,
        fit: BoxFit.cover,
      ));

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: urlImages.length,
      effect: WormEffect(
          dotColor: Colors.blue.shade100,
          dotHeight: 12,
          dotWidth: 16,
          activeDotColor: Colors.pink.shade400),
    );
  }
}
