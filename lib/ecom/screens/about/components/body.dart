import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/user_data.dart';
import '../../../constants.dart';
import '../../../models/AppReview.dart';
import '../../../services/database/app_review_database_helper.dart';
import '../../../services/firestore_files_access/firestore_files_access_service.dart';
import '../../../size_config.dart';
import 'app_review_dialog.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "About Developer",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                InkWell(
                  onTap: () async {
                    const String linkedInUrl =
                        "https://www.linkedin.com/in/imrb7here";
                    Uri url = Uri.parse(linkedInUrl);
                    await launchUrl1(url);
                  },
                  child: buildDeveloperAvatar(),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                const Text(
                  '" Rahul Badgujar "',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "PCCoE Pune",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/github_icon.svg",
                        color: kTextColor.withOpacity(0.75),
                      ),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 40,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        const String githubUrl = "https://github.com/imRB7here";
                        Uri url = Uri.parse(githubUrl);
                        await launchUrl1(url);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/linkedin_icon.svg",
                        color: kTextColor.withOpacity(0.75),
                      ),
                      iconSize: 40,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        const String linkedInUrl =
                            "https://www.linkedin.com/in/imrb7here";
                        Uri url = Uri.parse(linkedInUrl);
                        await launchUrl1(url);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/instagram_icon.svg",
                          color: kTextColor.withOpacity(0.75)),
                      iconSize: 40,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        const String instaUrl =
                            "https://www.instagram.com/_rahul.badgujar_";
                        Uri url = Uri.parse(instaUrl);
                        await launchUrl1(url);
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      padding: const EdgeInsets.all(16),
                      onPressed: () {
                        submitAppReview(context, liked: true);
                      },
                    ),
                    const Text(
                      "Liked the app?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      padding: const EdgeInsets.all(16),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      onPressed: () {
                        submitAppReview(context, liked: false);
                      },
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperAvatar() {
    return FutureBuilder<String>(
        future: FirestoreFilesAccess().getDeveloperImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final url = snapshot.data!;
            return CircleAvatar(
              radius: SizeConfig.screenWidth * 0.3,
              backgroundColor: kTextColor.withOpacity(0.75),
              backgroundImage: NetworkImage(url),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
          }
          return CircleAvatar(
            radius: SizeConfig.screenWidth * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
          );
        });
  }

  Future<void> launchUrl1(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Logger().i("LinkedIn URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context,
      {bool liked = true}) async {
    AppReview? prevReview;
    String? uid = Provider.of<UserData>(context, listen: false).currentUserId;
    try {
      prevReview =
          await AppReviewDatabaseHelper().getAppReviewOfCurrentUser(uid);
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
    } catch (e) {
      Logger().w("Unknown Exception: $e");
    } finally {
      prevReview ??= AppReview(
        uid,
        liked: liked,
        feedback: "",
      );
    }

    final AppReview? result = await showDialog(
      context: context,
      builder: (context) {
        return AppReviewDialog(
          appReview: prevReview,
        );
      },
    );
    if (result != null) {
      result.liked = liked;
      bool reviewAdded = false;
      String? snackbarMessage;
      try {
        reviewAdded = await AppReviewDatabaseHelper()
            .editAppReview(uid: uid, appReview: result);
        if (reviewAdded == true) {
          snackbarMessage = "Feedback submitted successfully";
        } else {
          throw "Coulnd't add feeback due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = e.toString();
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
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
}
