import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_swarn_holidays/ecom/models/AppReview.dart';

class AppReviewDatabaseHelper {
  // ignore: constant_identifier_names
  static const String APP_REVIEW_COLLECTION_NAME = "app_reviews";

  AppReviewDatabaseHelper._privateConstructor();
  static final AppReviewDatabaseHelper _instance =
      AppReviewDatabaseHelper._privateConstructor();
  factory AppReviewDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore? get firestore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore;
  }

  Future<bool> editAppReview(
      {required String? uid, required AppReview appReview}) async {
    final docRef = firestore!.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final docData = await docRef.get();
    if (docData.exists) {
      docRef.update(appReview.toUpdateMap());
    } else {
      docRef.set(appReview.toMap());
    }
    return true;
  }

  Future<AppReview> getAppReviewOfCurrentUser(uid) async {
    final docRef = firestore!.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final docData = await docRef.get();
    if (docData.exists) {
      final appReview = AppReview.fromMap(docData.data()!, id: docData.id);
      return appReview;
    } else {
      final appReview = AppReview(uid, liked: true, feedback: "");
      docRef.set(appReview.toMap());
      return appReview;
    }
  }
}
