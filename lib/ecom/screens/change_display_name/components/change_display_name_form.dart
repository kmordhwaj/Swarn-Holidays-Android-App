import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_swarn_holidays/ecom/components/default_button.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import '../../../size_config.dart';

class ChangeDisplayNameForm extends StatefulWidget {
  const ChangeDisplayNameForm({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeDisplayNameFormState createState() => _ChangeDisplayNameFormState();
}

class _ChangeDisplayNameFormState extends State<ChangeDisplayNameForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController newFirstNameController = TextEditingController();

  final TextEditingController newSecondNameController = TextEditingController();

  final TextEditingController currentDisplayNameController =
      TextEditingController();

  @override
  void dispose() {
    newFirstNameController.dispose();
    newSecondNameController.dispose();
    currentDisplayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          buildCurrentDisplayNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          buildNewDisplayNameField(),
          SizedBox(height: SizeConfig.screenHeight * 0.2),
          DefaultButton(
            text: "Change Display Name",
            press: () {
              final uploadFuture = changeDisplayNameButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureProgressDialog(
                    uploadFuture,
                    message: const Text("Updating Display Name"),
                  );
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Display Name updated")));
            },
          ),
        ],
      ),
    );

    return form;
  }

  Widget buildNewDisplayNameField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: newFirstNameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              hintText: "Enter New Display Name",
              labelText: "New Display Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (newFirstNameController.text.isEmpty) {
                return "Display Name cannot be empty";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: newSecondNameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              hintText: "Enter New Display Name",
              labelText: "New Display Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (newSecondNameController.text.isEmpty) {
                return "Display Name cannot be empty";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }

  Widget buildCurrentDisplayNameField() {
    return StreamBuilder<
        DocumentSnapshot<Object?>
        //    User?
        >(
      stream: UserDatabaseHelper().currentUserDataStream,
      //  AuthentificationService().userChanges,
      builder: (context, AsyncSnapshot snapshot) {
        //   String? displayName;
        String? firstName;
        String? secondName;
        String displayName = '$firstName $secondName';
        if (snapshot.hasData && snapshot.data != null) {
          final doc = snapshot.data!;
          firstName = doc['firstName'];
          secondName = doc['secondName'];
          displayName = '$firstName $secondName';
          final textField = TextFormField(
            controller: currentDisplayNameController,
            decoration: const InputDecoration(
              hintText: "No Display Name available",
              labelText: "Current Display Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person),
            ),
            readOnly: true,
          );
          //   if (displayName != null)
          currentDisplayNameController.text = displayName;
          return textField;
        }
        return Container();
      },
    );
  }

  Future<void> changeDisplayNameButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await AuthentificationService().updateCurrentUserDisplayName(
        updatedFirstName: newFirstNameController.text,
        updatedSecondName: newSecondNameController.text,
      );
      //   print("Display Name updated to ${newDisplayNameController.text} ...");
    }
  }
}
