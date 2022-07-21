import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/components/default_button.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/models/user_data.dart';

import '../../../size_config.dart';

class ChangePhoneNumberForm extends StatefulWidget {
  const ChangePhoneNumberForm({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePhoneNumberFormState createState() => _ChangePhoneNumberFormState();
}

class _ChangePhoneNumberFormState extends State<ChangePhoneNumberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPhoneNumberController =
      TextEditingController();
  final TextEditingController currentPhoneNumberController =
      TextEditingController();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
  }

  @override
  void dispose() {
    newPhoneNumberController.dispose();
    currentPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentPhoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewPhoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Update Phone Number",
            press: () {
              final updateFuture = updatePhoneNumberButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    updateFuture,
                    message: const Text("Updating Phone Number"),
                  );
                },
              );
            },
          ),
        ],
      ),
    );

    return form;
  }

  Future<void> updatePhoneNumberButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool status = false;
      String? snackbarMessage;
      try {
        status = await UserDatabaseHelper().updatePhoneForCurrentUser(
            uid: currentUserId, phone: newPhoneNumberController.text);
        if (status == true) {
          snackbarMessage = "Phone updated successfully";
        } else {
          throw "Coulnd't update phone due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Something went wrong";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage!),
          ),
        );
      }
    }
  }

  Widget buildNewPhoneNumberField() {
    return TextFormField(
      controller: newPhoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        hintText: "Enter New Phone Number",
        labelText: "New Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (newPhoneNumberController.text.isEmpty) {
          return "Phone Number cannot be empty";
        } else if (newPhoneNumberController.text.length != 10) {
          return "Only 10 digits allowed";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPhoneNumberField() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        String? currentPhone;
        if (snapshot.hasData && snapshot.data != null) {
          currentPhone = snapshot.data![UserDatabaseHelper.PHONE_KEY];
        }
        final textField = TextFormField(
          controller: currentPhoneNumberController,
          decoration: const InputDecoration(
            hintText: "No Phone Number available",
            labelText: "Current Phone Number",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.phone),
          ),
          readOnly: true,
        );
        if (currentPhone != null) {
          currentPhoneNumberController.text = currentPhone;
        }
        return textField;
      },
    );
  }
}
