import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/components/nothingtoshow_container.dart';
import 'package:new_swarn_holidays/ecom/components/product_card.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/product_details_screen.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

class Body extends StatelessWidget {
  final String searchQuery;
  final List<String?>? searchResultUsersId;
  final String searchIn;

  const Body({
    Key? key,
    required this.searchQuery,
    required this.searchResultUsersId,
    required this.searchIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "Search Result",
                  style: headingStyle,
                ),
                Text.rich(
                  TextSpan(
                    text: searchQuery,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      const TextSpan(
                        text: " in ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TextSpan(
                        text: searchIn,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.75,
                  child: buildUsersGrid(),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUsersGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Builder(
        builder: (context) {
          if (searchResultUsersId!.isNotEmpty) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: searchResultUsersId!.length,
              itemBuilder: (context, index) {
                String? currentUserId =
                    Provider.of<UserData>(context, listen: false).currentUserId;
                return ProductCard(
                  productId: searchResultUsersId![index],
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                            productId: searchResultUsersId![index],
                            currentUserId: currentUserId),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/search_no_found.svg",
              secondaryMessage: "Found 0 Users",
              primaryMessage: "Try another search keyword",
            ),
          );
        },
      ),
    );
  }
}
