import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_swarn_holidays/ecom/models/Product.dart';
import 'package:new_swarn_holidays/ecom/models/Review.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:new_swarn_holidays/widgets/common/progress.dart';

class ProductDatabaseHelper {
  // ignore: constant_identifier_names
  static const String PRODUCTS_COLLECTION_NAME = "products";
  // ignore: constant_identifier_names
  static const String REVIEWS_COLLECTOIN_NAME = "reviews";

  ProductDatabaseHelper._privateConstructor();
  static final ProductDatabaseHelper _instance =
      ProductDatabaseHelper._privateConstructor();
  factory ProductDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore? get firestore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore;
  }

  Future<List<String?>>? searchInProducts(String? query,
      {ProductType? productType}) async {
    Query queryRef;
    if (productType == null) {
      queryRef = firestore!.collection(PRODUCTS_COLLECTION_NAME);
    } else {
      final String? productTypeStr = EnumToString.convertToString(productType);
      //   print(productTypeStr);
      queryRef = firestore!
          .collection(PRODUCTS_COLLECTION_NAME)
          .where(Product.PRODUCT_TYPE_KEY, isEqualTo: productTypeStr);
    }

    Set productsId = <String?>{};
    final querySearchInTags = await queryRef
        .where(Product.SEARCH_TAGS_KEY, arrayContains: query)
        .get();
    for (final doc in querySearchInTags.docs) {
      productsId.add(doc.id);
    }
    final queryRefDocs = await queryRef.get();
    for (final doc in queryRefDocs.docs) {
      final product =
          Product.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
      if (product.title.toString().toLowerCase().contains(query!) ||
          product.description.toString().toLowerCase().contains(query) ||
          product.highlights.toString().toLowerCase().contains(query) ||
          product.variant.toString().toLowerCase().contains(query) ||
          product.seller.toString().toLowerCase().contains(query)) {
        productsId.add(product.id);
      }
    }
    return productsId.toList() as FutureOr<List<String?>>;
  }

  Future<bool> addProductReview(String? productId, Review review) async {
    final reviewesCollectionRef = firestore!
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTOIN_NAME);
    final reviewDoc = reviewesCollectionRef.doc(review.reviewerUid);
    if ((await reviewDoc.get()).exists == false) {
      reviewDoc.set(review.toMap());
      return await addUsersRatingForProduct(
        productId,
        review.rating,
      );
    } else {
      int? oldRating = 0;
      oldRating = (await reviewDoc.get()).data()![Product.RATING_KEY];
      reviewDoc.update(review.toUpdateMap());
      return await addUsersRatingForProduct(productId, review.rating,
          oldRating: oldRating);
    }
  }

  Future<bool> addUsersRatingForProduct(String? productId, int? rating,
      {int? oldRating}) async {
    final productDocRef =
        firestore!.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    final ratingsCount =
        (await productDocRef.collection(REVIEWS_COLLECTOIN_NAME).get())
            .docs
            .length;
    final productDoc = await productDocRef.get();
    final prevRating = productDoc.data()![Review.RATING_KEY];
    double? newRating;
    if (oldRating == null) {
      newRating = (prevRating * (ratingsCount - 1) + rating) / ratingsCount;
    } else {
      newRating =
          (prevRating * (ratingsCount) + rating - oldRating) / ratingsCount;
    }
    final newRatingRounded = double.parse(newRating!.toStringAsFixed(1));
    await productDocRef.update({Product.RATING_KEY: newRatingRounded});
    return true;
  }

  Future<Review?> getProductReviewWithID(
      String? productId, String reviewId) async {
    final reviewesCollectionRef = firestore!
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTOIN_NAME);
    final reviewDoc = await reviewesCollectionRef.doc(reviewId).get();
    if (reviewDoc.exists) {
      return Review.fromMap(reviewDoc.data()!, id: reviewDoc.id);
    }
    return circularProgress();
  }

  Stream<List<Review>> getAllReviewsStreamForProductId(
      String? productId) async* {
    final reviewesQuerySnapshot = firestore!
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTOIN_NAME)
        .get()
        .asStream();
    await for (final querySnapshot in reviewesQuerySnapshot) {
      List<Review> reviews = <Review>[];
      for (final reviewDoc in querySnapshot.docs) {
        Review review = Review.fromMap(reviewDoc.data(), id: reviewDoc.id);
        reviews.add(review);
      }
      yield reviews;
    }
  }

  Future<Product?> getProductWithID(String? productId) async {
    final docSnapshot = await firestore!
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .get();

    if (docSnapshot.exists) {
      return Product.fromMap(docSnapshot.data()!, id: docSnapshot.id);
    }
    return null;
  }

  Future<String> addUsersProduct(
      {required String? uid, required Product product}) async {
    final productMap = product.toMap();
    product.owner = uid;
    final productsCollectionReference =
        firestore!.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = await productsCollectionReference.add(product.toMap());
    await docRef.update({
      Product.SEARCH_TAGS_KEY: FieldValue.arrayUnion(
          [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
    });
    return docRef.id;
  }

  Future<bool> deleteUserProduct(String? productId) async {
    final productsCollectionReference =
        firestore!.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference.doc(productId).delete();
    return true;
  }

  Future<String> updateUsersProduct(
      Product product, String? rentOwnerId) async {
    final productMap = product.toUpdateMap();
    final productsCollectionReference =
        firestore!.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = productsCollectionReference.doc(product.id);
    await docRef.update(productMap);
    if (product.productType != null) {
      await docRef.update({
        Product.RENT_OWNER_ID: rentOwnerId,
        Product.SEARCH_TAGS_KEY: FieldValue.arrayUnion(
            [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
      });
    }
    return docRef.id;
  }

  Future<List<String>> getCategoryProductsList(ProductType? productType) async {
    final productsCollectionReference =
        firestore!.collection(PRODUCTS_COLLECTION_NAME);
    final queryResult = await productsCollectionReference
        .where(Product.PRODUCT_TYPE_KEY,
            isEqualTo: EnumToString.convertToString(productType))
        .get();
    List productsId = <String>[];
    for (final product in queryResult.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId as FutureOr<List<String>>;
  }

  Future<List<String>> get usersProductsList async {
    String uid = AuthentificationService().currentUser!.uid;
    final productsCollectionReference =
        firestore!.collection(PRODUCTS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference
        .where(Product.OWNER_KEY, isEqualTo: uid)
        .get();
    List usersProducts = <String>[];
    for (var doc in querySnapshot.docs) {
      usersProducts.add(doc.id);
    }
    return usersProducts as FutureOr<List<String>>;
  }

  Future<List<String>> get allProductsList async {
    final products =
        await firestore!.collection(PRODUCTS_COLLECTION_NAME).get();
    List productsId = <String>[];
    for (final product in products.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId as FutureOr<List<String>>;
  }

  Future<bool> updateProductsImages(
      String? productId, List<String?> imgUrl) async {
    final Product updateProduct = Product(null, images: imgUrl);
    final docRef =
        firestore!.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toUpdateMap());
    return true;
  }

  String getPathForProductImage(String? id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }
}
