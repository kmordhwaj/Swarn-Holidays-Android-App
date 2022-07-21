import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_swarn_holidays/ecom/screens/change_cover_picture/change_cover_picture_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/change_display_picture/change_display_picture_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/change_email/change_email_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/change_password/change_password_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/change_phone/change_phone_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:new_swarn_holidays/ecom/screens/my_orders/my_orders_screen.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:new_swarn_holidays/ecom/utils.dart';
import 'package:flutter/material.dart';
//import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:new_swarn_holidays/general/playstorepage.dart';
//import 'package:new_swarn_holidays/screens/a/mybankdetails.dart';
import '../../change_display_name/change_display_name_screen.dart';

class HomeScreenDrawer extends StatelessWidget {
  final String? currentUserId;
  const HomeScreenDrawer({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          StreamBuilder<DocumentSnapshot<Object?>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserId)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  String firstName = user['firstName'];
                  String secondName = user['secondName'];
                  String? profImg = user['profileImageUrl'];
                  String email = user['email'];
                  bool isProfImg = profImg == null;
                  return Container(
                    height: 170,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/train.jpg'),
                          fit: BoxFit.cover),
                      /*    gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.shade400.withOpacity(0.7),
                            Colors.pink.shade200
                          ]), */
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
                              isProfImg
                                  ? CircleAvatar(
                                      radius: 40,
                                      child: Center(
                                          child: Text(
                                        '${firstName[0].toUpperCase()} ${secondName[0].toUpperCase()}',
                                        style: const TextStyle(fontSize: 23),
                                      )),
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          CachedNetworkImageProvider(profImg),
                                    ),
                              const SizedBox(height: 10),
                              Text(
                                '$firstName $secondName',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber.shade200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 100.0, right: 10),
                          child: IconButton(
                              alignment: Alignment.topRight,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close_rounded)),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Icon(Icons.error),
                  );
                }
              }),
          buildEditAccountExpansionTile(context),
          ListTile(
            leading: const Icon(Icons.edit_location),
            title: const Text(
              "Manage Addresses",
              style: TextStyle(
                fontSize: 16,
                // color: Colors.black
              ),
            ),
            onTap: () async {
              /*   bool allowed = AuthentificationService().currentUserVerified;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageAddressesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.square_arrow_right),
            title: const Text(
              "My Orders",
              style: TextStyle(
                fontSize: 16,
                //color: Colors.black
              ),
            ),
            onTap: () async {
              /*   bool allowed = AuthentificationService().currentUserVerified;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyOrdersScreen(),
                ),
              );
            },
          ),
          buildSellerExpansionTile(context),
          const ListTile(
            leading: Icon(Icons.free_breakfast_outlined),
            title: Text(
              "My Wallet",
              style: TextStyle(
                fontSize: 16,
                // color: Colors.black
              ),
            ),
            /*   onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBankDetails(),
                ),
              );
            }, */
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              "Sign out",
              style: TextStyle(
                fontSize: 16,
                // color: Colors.black
              ),
            ),
            onTap: () async {
              final confirmation =
                  await showConfirmationDialog(context, "Confirm Sign out ?");
              if (confirmation) AuthentificationService().signOut();
            },
          ),
        ],
      ),
    );
  }

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.person),
      title: const Text(
        "Edit Account",
        style: TextStyle(
          fontSize: 16,
          //     color: Colors.black
        ),
      ),
      children: [
        ListTile(
          title: const Text(
            "Change Display Picture",
            style: TextStyle(
              //  color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeDisplayPictureScreen(),
                ));
          },
        ),
        ListTile(
          title: const Text(
            "Change Cover Image",
            style: TextStyle(
              //   color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeCoverPictureScreen(),
                ));
          },
        ),
        ListTile(
          title: const Text(
            "Change Display Name",
            style: TextStyle(
              //   color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeDisplayNameScreen(),
                ));
          },
        ),
        ListTile(
          title: const Text(
            "Change Phone Number",
            style: TextStyle(
              //     color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePhoneScreen(),
                ));
          },
        ),
        ListTile(
          title: const Text(
            "Change Email",
            style: TextStyle(
              //    color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeEmailScreen(),
                ));
          },
        ),
        ListTile(
          title: const Text(
            "Change Password",
            style: TextStyle(
              //   color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ));
          },
        ),
      ],
    );
  }

  Widget buildSellerExpansionTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.business),
      title: const Text(
        "I am Seller",
        style: TextStyle(
          fontSize: 16,
          //    color: Colors.black
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PlayStorePage()));
      },
    );
  }
}
