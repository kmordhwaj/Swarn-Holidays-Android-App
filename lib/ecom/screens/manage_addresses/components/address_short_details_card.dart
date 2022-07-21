import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/Address.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:new_swarn_holidays/ecom/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

class AddressShortDetailsCard extends StatelessWidget {
  final String addressId;
  final Function onTap;

  const AddressShortDetailsCard(
      {Key? key, required this.addressId, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<UserData>(context, listen: false).currentUserId;
    return InkWell(
      onTap: onTap as void Function()?,
      child: SizedBox(
        width: double.infinity,
        height: SizeConfig.screenHeight * 0.15,
        child: FutureBuilder<Address>(
          future:
              UserDatabaseHelper().getAddressFromId(uid: uid, id: addressId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final address = snapshot.data!;
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        color: kTextColor.withOpacity(0.24),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          address.title!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: kTextColor.withOpacity(0.24)),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            address.receiver!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text("City: ${address.city}"),
                          Text("Phone: ${address.phone}"),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              final error = snapshot.error.toString();
              Logger().e(error);
            }
            return const Center(
              child: Icon(
                Icons.error,
                size: 40,
                color: kTextColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
