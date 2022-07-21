import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/screens/change_display_picture/change_display_picture_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/edit_product/edit_product_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/my_products/my_products_screen.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:new_swarn_holidays/ecom/utils.dart';
import 'package:new_swarn_holidays/general/sellerlogin.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'package:new_swarn_holidays/widgets/common/progress.dart';

class EndScreenDrawer extends StatelessWidget {
  const EndScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    return Drawer(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(currentUserId)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              DocumentSnapshot ds = snapshot.data;
              if (snapshot.hasData) {
                return alreadySeller(context, ds);
              } else if (snapshot.hasError) {
                return circularProgress();
              }
              return newSeller(context);
            }));
  }

  Widget newSeller(context) {
    return Center(
      child: Column(
        children: [
          const Text('Are you a seller?'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SellerLogin()));
              },
              child: const Text('Join as Seller'))
        ],
      ),
    );
  }

  Widget alreadySeller(BuildContext context, user) {
    String? firstName = user['firstName'];
    String? secondName = user['secondName'];
    String? name = '$firstName $secondName';
    return ListView(
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade400.withOpacity(0.7),
                  Colors.pink.shade200
                ]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //CircleAvatar()
                    FutureBuilder(
                      future: UserDatabaseHelper().displayPictureForCurrentUser,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(snapshot.data.toString()),
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
                        return CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeDisplayPictureScreen()));
                              },
                              icon: const Icon(Icons.add_a_photo_outlined)),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      //?? "No Name",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No usernmae',
                      //  user.displayName ?? '' ,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    //        ToggleButtons(
                    //          children: [

                    //         ],
                    //        isSelected: true )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0, right: 10),
                child: IconButton(
                    alignment: Alignment.topRight,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded)),
              )
            ],
          ),
        ),
        ListTile(
          title: const Text(
            "Add New Product",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () async {
            bool allowed = AuthentificationService().currentUserVerified;
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
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProductScreen()));
          },
        ),
        ListTile(
          title: const Text(
            "Manage My Products",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () async {
            bool allowed = AuthentificationService().currentUserVerified;
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
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyProductsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
