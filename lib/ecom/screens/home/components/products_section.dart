import 'package:new_swarn_holidays/ecom/components/nothingtoshow_container.dart';
import 'package:new_swarn_holidays/ecom/components/productcard.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/section_tile.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/data_stream.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../size_config.dart';

class ProductsSection extends StatelessWidget {
  final String sectionTitle;
  final DataStream productsStreamController;
  final String emptyListMessage;
  final String? postId;
  final Function onProductCardTapped;
  const ProductsSection(
      {Key? key,
      required this.sectionTitle,
      required this.productsStreamController,
      this.emptyListMessage = "No Products to show here",
      required this.onProductCardTapped,
      this.postId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Colors.blue,
          //.shade300,
          Colors.purple
          // .shade300
        ]),
        // const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SectionTile(
            title: sectionTitle,
            press: () {},
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Expanded(
            child: buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<String>?>(
      stream: productsStreamController.stream as Stream<List<String>?>?,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Center(
              child: NothingToShowContainer(
                secondaryMessage: emptyListMessage,
              ),
            );
          }
          return buildProductGrid(snapshot.data!);
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

  Widget buildProductGrid(List<String> productsId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: productsId.length,
      itemBuilder: (context, index) {
        return Stack(children: [
          ProductCard1(
            productId: productsId[index],
            press: () {
              onProductCardTapped.call(productsId[index]);
            },
          ),
          /*     Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(currentUserId)
                    .collection('userPosts')
                    .doc(postId)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  DocumentSnapshot ds = snapshot.data;
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          CachedNetworkImageProvider(ds['mediaUrl']),
                    );
                  }
                  return ElevatedButton(
                      onPressed: () async {
                        UserDatabaseHelper()
                            .addRentOwnerPost(productsId[index], postId);
                      },
                      child: Text('Add to Rent in a post'));
                }),
          )
        */
        ]);
      },
    );
  }
}
