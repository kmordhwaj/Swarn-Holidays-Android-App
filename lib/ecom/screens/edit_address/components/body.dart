import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/Address.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'address_details_form.dart';

class Body extends StatefulWidget {
  final String? addressIdToEdit;

  const Body({Key? key, this.addressIdToEdit}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "Fill Address Details",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                widget.addressIdToEdit == null
                    ? const AddressDetailsForm(
                        addressToEdit: null,
                      )
                    : FutureBuilder<Address>(
                        future: UserDatabaseHelper().getAddressFromId(
                            uid: currentUserId, id: widget.addressIdToEdit),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final address = snapshot.data;
                            return AddressDetailsForm(addressToEdit: address);
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return const AddressDetailsForm(
                            addressToEdit: null,
                          );
                        },
                      ),
                SizedBox(height: getProportionateScreenHeight(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
