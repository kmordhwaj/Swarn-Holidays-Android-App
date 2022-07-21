import 'dart:io';
import 'package:new_swarn_holidays/ecom/components/default_button.dart';
import 'package:new_swarn_holidays/ecom/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:new_swarn_holidays/ecom/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:new_swarn_holidays/ecom/services/database/user_database_helper.dart';
import 'package:new_swarn_holidays/ecom/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:new_swarn_holidays/ecom/services/local_files_access/local_files_access_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import '../provider_models/body_model.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
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
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10
                //getProportionateScreenWidth(screenPadding)
                ),
            child: SizedBox(
              width: double.infinity,
              child: Consumer<ChosenImage>(
                builder: (context, bodyState, child) {
                  return Column(
                    children: [
                      const Text(
                        "Change Cover Image",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.5)
                        // headingStyle
                        ,
                      ),
                      const SizedBox(height: 35
                          //getProportionateScreenHeight(40)
                          ),
                      GestureDetector(
                        child: buildCoverPictureContainer(context, bodyState),
                        onTap: () {
                          getImageFromUser(context, bodyState);
                        },
                      ),
                      const SizedBox(height: 70
                          //  getProportionateScreenHeight(80)
                          ),
                      buildChosePictureButton(context, bodyState),
                      const SizedBox(height: 20
                          //getProportionateScreenHeight(20)
                          ),
                      buildUploadPictureButton(context, bodyState),
                      const SizedBox(height: 20
                          //getProportionateScreenHeight(20)
                          ),
                      buildRemovePictureButton(context, bodyState),
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

  Widget buildCoverPictureContainer(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder(
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
          final doc = snapshot.data!;
          final String? url = doc[UserDatabaseHelper.CP_KEY];
          if (url != null) backImage = NetworkImage(url);
        }
/*
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width - 20,
          child: Image(image: ),
        );
        */
        return CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.3,
          //SizeConfig.screenWidth * 0.3,
          backgroundColor: Colors.blue.shade100,
          //kTextColor.withOpacity(0.5),
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

  Widget buildUploadPictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Upload Picture",
      press: () {
        final Future uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: const Text("Updating Cover Image"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cover Image updated")));
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage bodyState) async {
    bool uploadCoverPictureStatus = false;
    String? snackbarMessage;
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          bodyState.chosenImage!,
          UserDatabaseHelper()
              .getPathForCurrentUserCoverPicture(currentUserId));

      uploadCoverPictureStatus = await UserDatabaseHelper()
          .uploadCoverPictureForCurrentUser(
              uid: currentUserId, url: downloadUrl);
      if (uploadCoverPictureStatus == true) {
        snackbarMessage = "Cover Image updated successfully";
      } else {
        throw "Coulnd't update Cover Image due to unknown reason";
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

  Widget buildRemovePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Remove Picture",
      press: () async {
        final Future uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: const Text("Deleting Cover Image"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cover Image removed")));
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, ChosenImage bodyState) async {
    bool status = false;
    String? snackbarMessage;
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess()
          .deleteFileFromPath(UserDatabaseHelper()
              .getPathForCurrentUserCoverPicture(currentUserId));
      if (fileDeletedFromFirestore == false) {
        throw "Couldn't delete file from Storage, please retry";
      }
      status = await UserDatabaseHelper()
          .removeCoverPictureForCurrentUser(currentUserId);
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
