import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/constants.dart';
import 'package:new_swarn_holidays/ecom/models/Address.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key? key,
    required this.addressId,
  }) : super(key: key);

  final String addressId;

  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<UserData>(context, listen: false).currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FutureBuilder<Address>(
                  future: UserDatabaseHelper()
                      .getAddressFromId(uid: uid, id: addressId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final address = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${address.title}",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${address.receiver}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${address.addresLine1}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${address.addressLine2}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "City: ${address.city}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "District: ${address.district}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "State: ${address.state}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Landmark: ${address.landmark}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "PIN: ${address.pincode}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Phone: ${address.phone}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      final error = snapshot.error.toString();
                      Logger().e(error);
                    }
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: kTextColor,
                        size: 60,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
