import 'package:new_swarn_holidays/ecom/screens/home/components/home_header_up.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/ecom/screens/home/components/products_section.dart';
import 'package:new_swarn_holidays/ecom/screens/product_details/product_details_screen.dart';
import 'package:new_swarn_holidays/ecom/services/data_streams/favourite_products_stream.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import '../ecom/screens/change_display_picture/change_display_picture_screen.dart';
import '../ecom/screens/home/components/home_screen_drawer.dart';

class ProfileScreen extends StatefulWidget {
  final String? profileId;

  const ProfileScreen({Key? key, required this.profileId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FavouriteProductsStream favouriteProductsStream =
      FavouriteProductsStream();

  @override
  void initState() {
    super.initState();
    favouriteProductsStream.init();
  }

  @override
  void dispose() {
    favouriteProductsStream.dispose();
    super.dispose();
  }

  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: Scaffold(
            drawer: HomeScreenDrawer(currentUserId: widget.profileId),
            body: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 10),
                const HomeHeaderUp(),
                StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.profileId)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final user = snapshot.data!;
                      return profileHeader(user);
                    }),
                const SizedBox(height: 10),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  child: ProductsSection(
                    sectionTitle: "Products You Like",
                    productsStreamController: favouriteProductsStream,
                    emptyListMessage: "Add Product to Favourites",
                    onProductCardTapped: onProductCardTapped,
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            )),
      ),
    );
  }

  void onProductCardTapped(String? productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
            productId: productId, currentUserId: widget.profileId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }

  profileHeader(user) {
    return Row(
      children: [
        profileImage(user),
        const SizedBox(width: 20),
        Column(
          children: [
            Text(
              '${user['firstName']} ${user['secondName']}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${user['email']}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade200),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  profileImage(user) {
    String? profImg = user['profileImageUrl'];
    bool isProf = profImg == null;
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: CircleAvatar(
            radius: 60,
            child: isProf
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const ChangeDisplayPictureScreen()));
                    },
                    icon: const Icon(Icons.add_a_photo_outlined))
                : InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const ChangeDisplayPictureScreen()));
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: CachedNetworkImageProvider(profImg),
                    ),
                  )));
  }
}
