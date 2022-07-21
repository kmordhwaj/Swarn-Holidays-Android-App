import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/components/nothingtoshow_container.dart';
import 'package:new_swarn_holidays/ecom/components/product_card.dart';
import 'package:new_swarn_holidays/ecom/components/rounded_icon_button.dart';
import 'package:new_swarn_holidays/ecom/components/search_field2.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/product_details_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/search_result2/search_result_screen2.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/category_products_stream.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

class Body extends StatefulWidget {
  final ProductType? productType;

  const Body({
    Key? key,
    required this.productType,
  }) : super(key: key);

  @override
  _BodyState createState() =>
      // ignore: no_logic_in_create_state
      _BodyState(categoryProductsStream: CategoryProductsStream(productType));
}

class _BodyState extends State<Body> {
  final CategoryProductsStream categoryProductsStream;

  _BodyState({required this.categoryProductsStream});

  @override
  void initState() {
    super.initState();
    categoryProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    categoryProductsStream.dispose();
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
                  buildHeadBar(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.13,
                    child: buildCategoryBanner(),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.68,
                    child: StreamBuilder<List<String>?>(
                      stream: categoryProductsStream.stream
                          as Stream<List<String>?>?,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> productsId = snapshot.data!;
                          if (productsId.isEmpty) {
                            return Center(
                              child: NothingToShowContainer(
                                secondaryMessage:
                                    "No Products in ${EnumToString.convertToString(widget.productType)}",
                              ),
                            );
                          }

                          return buildProductsGrid(productsId);
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
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeadBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedIconButton(
          iconData: Icons.arrow_back_ios,
          press: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 5),
        Expanded(
          child: SearchField2(
            onSubmit: (value) async {
              final query = value.toString();
              if (query.isEmpty) return;
              List<String?>? searchedProductsId;
              try {
                searchedProductsId = await ProductDatabaseHelper()
                    .searchInProducts(query.toLowerCase(),
                        productType: widget.productType);

                if (searchedProductsId != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultScreen2(
                        searchQuery: query,
                        searchResultProductsId: searchedProductsId,
                        searchIn:
                            EnumToString.convertToString(widget.productType),
                      ),
                    ),
                  );
                  await refreshPage();
                } else {
                  throw "Couldn't perform search due to some unknown reason";
                }
              } catch (e) {
                final error = e.toString();
                Logger().e(error);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> refreshPage() {
    categoryProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildCategoryBanner() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bannerFromProductType()),
              fit: BoxFit.fill,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.hue,
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              EnumToString.convertToString(widget.productType),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductsGrid(List<String> productsId) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: productsId.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          String? currentUserId =
              Provider.of<UserData>(context, listen: false).currentUserId;
          return ProductCard(
            productId: productsId[index],
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                      productId: productsId[index],
                      currentUserId: currentUserId),
                ),
              ).then(
                (_) async {
                  await refreshPage();
                },
              );
            },
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 2,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 12,
        ),
      ),
    );
  }

  String bannerFromProductType() {
    switch (widget.productType) {
      case ProductType.Electronics:
        return "assets/images/electronics_banner.jpg";
      case ProductType.Books:
        return "assets/images/books_banner.jpg";
      case ProductType.Fashion:
        return "assets/images/fashions_banner.jpg";
      case ProductType.Groceries:
        return "assets/images/groceries_banner.jpg";
      case ProductType.Art:
        return "assets/images/arts_banner.jpg";
      case ProductType.Others:
        return "assets/images/others_banner.jpg";
      default:
        return "assets/images/others_banner.jpg";
    }
  }
}
