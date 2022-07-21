import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_swarn_holidays/ecom/components/default_button.dart';
import 'package:new_swarn_holidays/ecom/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:new_swarn_holidays/ecom/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:new_swarn_holidays/ecom/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:new_swarn_holidays/ecom/services/local_files_access/local_files_access_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import '../provider_models/body_model.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10
                //  getProportionateScreenWidth(screenPadding)
                ),
            child: SizedBox(
              width: double.infinity,
              child: Consumer<ChosenImage>(
                builder: (context, bodyState, child) {
                  return Column(
                    children: [
                      const Text("Change Avatar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.5)
                          //   headingStyle,
                          ),
                      const SizedBox(height: 35
                          // getProportionateScreenHeight(40)
                          ),
                      GestureDetector(
                        child: buildDisplayPictureAvatar(context, bodyState),
                        onTap: () {
                          getImageFromUser(context, bodyState);
                        },
                      ),
                      const SizedBox(height: 70
                          //   getProportionateScreenHeight(80)
                          ),
                      buildChosePictureButton(context, bodyState),
                      const SizedBox(height: 20
                          //    getProportionateScreenHeight(20)
                          ),
                      buildUploadPictureButton(
                          currentUserId: currentUserId,
                          context: context,
                          bodyState: bodyState),
                      const SizedBox(height: 20
                          //getProportionateScreenHeight(20)
                          ),
                      buildRemovePictureButton(
                          currentUserId: currentUserId,
                          context: context,
                          bodyState: bodyState),
                      const SizedBox(height: 80
                          // getProportionateScreenHeight(80)
                          ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        ImageProvider? backImage;
        if (bodyState.chosenImage != null) {
          backImage = MemoryImage(bodyState.chosenImage!.readAsBytesSync());
        } else if (snapshot.hasData && snapshot.data != null) {
          final doc = snapshot.data;
          final String? url = doc[UserDatabaseHelper.DP_KEY];
          if (url != null) backImage = NetworkImage(url);
        }
        return CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.3,
          //SizeConfig.screenWidth * 0.3,
          backgroundColor: Colors.blue.shade100,
          //kTextColor.withOpacity(0.5) ,
          backgroundImage: backImage,
        );
      },
    );
  }

  void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    String? path;
    String? snackbarMessage;
    try {
      path = await choseImageFromLocalFiles(context);

      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
    } on LocalFileHandlingException catch (e) {
      Logger().i("LocalFileHandlingException: $e");
      snackbarMessage = e.toString();
    } catch (e) {
      Logger().i("LocalFileHandlingException: $e");
      snackbarMessage = e.toString();
    } finally {
      if (snackbarMessage != null) {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
    if (path == null) {
      return;
    }
    bodyState.setChosenImage = File(path);
  }

  Widget buildChosePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Choose Picture",
      press: () {
        getImageFromUser(context, bodyState);
      },
    );
  }

  Widget buildUploadPictureButton(
      {required String? currentUserId,
      required BuildContext context,
      required ChosenImage bodyState}) {
    return DefaultButton(
      text: "Upload Picture",
      press: () {
        final Future uploadFuture = uploadImageToFirestorage(
            currentUserId: currentUserId,
            context: context,
            bodyState: bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: const Text("Updating Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Display Picture updated")));
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      {required String? currentUserId,
      required BuildContext context,
      required ChosenImage bodyState}) async {
    bool uploadDisplayPictureStatus = false;
    String? snackbarMessage;
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          bodyState.chosenImage!,
          UserDatabaseHelper()
              .getPathForCurrentUserDisplayPicture(currentUserId));

      uploadDisplayPictureStatus = await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(
              uid: currentUserId, url: downloadUrl);
      if (uploadDisplayPictureStatus == true) {
        snackbarMessage = "Display Picture updated successfully";
      } else {
        throw "Coulnd't update display picture due to unknown reason";
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

  Widget buildRemovePictureButton(
      {required String? currentUserId,
      required BuildContext context,
      required ChosenImage bodyState}) {
    return DefaultButton(
      text: "Remove Picture",
      press: () async {
        final Future uploadFuture = removeImageFromFirestore(
            currentUserId: currentUserId,
            context: context,
            bodyState: bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: const Text("Deleting Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Display Picture removed")));
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      {required String? currentUserId,
      required BuildContext context,
      required ChosenImage bodyState}) async {
    bool status = false;
    String? snackbarMessage;
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess()
          .deleteFileFromPath(UserDatabaseHelper()
              .getPathForCurrentUserDisplayPicture(currentUserId));
      if (fileDeletedFromFirestore == false) {
        throw "Couldn't delete file from Storage, please retry";
      }
      status = await UserDatabaseHelper()
          .removeDisplayPictureForCurrentUser(currentUserId);
      if (status == true) {
        snackbarMessage = "Picture removed successfully";
      } else {
        throw "Coulnd't removed due to unknown reason";
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
