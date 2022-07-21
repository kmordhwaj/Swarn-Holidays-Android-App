// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/ecom/models/Address.dart';
import 'package:new_swarn_holidays/ecom/models/CartItem.dart';
import 'package:new_swarn_holidays/ecom/models/OrderedProduct.dart';
import 'package:new_swarn_holidays/ecom/models/commentmodal.dart';
//import 'package:new_swarn_holidays/ecom/models/lastMsgmodal.dart';
import 'package:new_swarn_holidays/ecom/models/postmodal.dart';
import 'package:new_swarn_holidays/ecom/models/replymodal.dart';
import 'package:new_swarn_holidays/ecom/models/storymodal.dart';
import 'package:new_swarn_holidays/ecom/models/videomodal.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:new_swarn_holidays/ecom/services/database/product_database_helper.dart';
import 'package:new_swarn_holidays/models/models.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";
  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "profileImageUrl";
  static const String CP_KEY = "coverImageUrl";
  static const String FAV_PRODUCTS_KEY = "favourite_products";
  static const String OWNED_PRODUCTS_KEY = 'owned_products';
  static const String FIRST_NAME = 'firstName';
  static const String SECOND_NAME = 'secondName';
  static const String DOB = 'dob';
  static const String RENT_OWNER_ID = 'rentOwnerId';
  static const String RENT_OWNER_DP = 'rentOwnerDp';
  static const String POST_ID = 'postId';
  static const String POST_MEDIA_URL = 'postMediaUrl';

  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore? get firestore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore;
  }

/*  Future<void> createNewUser(String uid) async {
    await firestore!.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
      FAV_PRODUCTS_KEY: <String>[],
      NAME: null ,
    });
  }
  */

  Future<void> deleteCurrentUserData(BuildContext context) async {
    final uid = Provider.of<UserData>(context, listen: false).currentUserId;
    AuthentificationService().currentUser!.uid;
    final docRef = firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
    final ordersCollectionRef =
        docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

    final cartDocs = await cartCollectionRef.get();
    for (final cartDoc in cartDocs.docs) {
      await cartCollectionRef.doc(cartDoc.id).delete();
    }
    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }
    final ordersDoc = await ordersCollectionRef.get();
    for (final orderDoc in ordersDoc.docs) {
      await ordersCollectionRef.doc(orderDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<bool> isProductFavourite(
      {required String? uid, required String? productId}) async {
    // String uid = AuthentificationService().currentUser!.uid;
    //  final uid = Provider.of<UserData>(context, listen: false).currentUserId;
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data()!;
    final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
    if (favList.contains(productId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List?> get usersFavouriteProductsList async {
    String uid = AuthentificationService().currentUser!.uid;
    //    final uid = Provider.of<UserData>(context, listen: false).currentUserId;
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data()!;
    final favList = userDocData[FAV_PRODUCTS_KEY];
    return favList;
  }

  Future<List?> get usersOwnedProductsList async {
    String uid = AuthentificationService().currentUser!.uid;
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data()!;
    final ownedList = userDocData[OWNED_PRODUCTS_KEY];
    return ownedList;
  }

  Future<bool> switchProductFavouriteStatus(
      {required String? productId,
      required String? uid,
      required bool newState}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
    return true;
  }

  Future<bool> addRentOwner(
      {required String? productId, required String? uid}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({
      OWNED_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
    });
    final snapshot =
        await firestore!.collection(USERS_COLLECTION_NAME).doc(uid).get();
    String? rentOwnerDp = snapshot.data()!['profileImageUrl'];
    await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection('rentedProducts')
        .doc(productId)
        .set({});
    final ownedUserDocSnapshot =
        firestore!.collection('products').doc(productId);
    await ownedUserDocSnapshot
        .update({'rentOwnerId': uid, 'rentOwnerDp': rentOwnerDp});
    return true;
  }

  Future<bool> removeRentOwner(
      {required String? productId, required String? uid}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({
      OWNED_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
    });
    await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection('rentedProducts')
        .doc(productId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    final ownedUserDocSnapshot =
        firestore!.collection('products').doc(productId);
    await ownedUserDocSnapshot
        .update({'rentOwnerId': null, 'rentOwnerDp': null});
    return true;
  }

  Future<String?> idForRentOwner(id) async {
    final snapshot = await firestore!.collection('products').doc(id).get();
    return snapshot.data()![RENT_OWNER_ID];
  }

  Future<String?> displayPictureForRentOwner(id) async {
    final snapshot = await firestore!.collection('products').doc(id).get();
    return snapshot.data()![RENT_OWNER_DP];
  }

  Future<String?> postIdRent(id) async {
    final snapshot = await firestore!.collection('products').doc(id).get();
    return snapshot.data()![POST_ID];
  }

  Future<String?> postMediaUrlRent(id) async {
    final snapshot = await firestore!.collection('products').doc(id).get();
    return snapshot.data()![POST_MEDIA_URL];
  }

  Future addRentOwnerPost(
      {required String? productId,
      required String? uid,
      required String? postId}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({
      OWNED_PRODUCTS_KEY: FieldValue.arrayUnion([productId]),
      'owned_post_id': postId
    });
    final ownedUserDocSnapshot =
        firestore!.collection('products').doc(productId);
    await ownedUserDocSnapshot
        .update({'rentOwner': uid, 'owned_post_id': postId});
  }

  Future removeRentOwnerPost(
      {required String? productId, required String? uid}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({
      OWNED_PRODUCTS_KEY: FieldValue.arrayRemove([productId]),
      'owned_post_id': null
    });
    final ownedUserDocSnapshot =
        firestore!.collection('products').doc(productId);
    await ownedUserDocSnapshot
        .update({'rentOwner': null, 'owned_post_id': null});
  }

  Future<List<String>> get addressesList async {
    String uid = AuthentificationService().currentUser!.uid;
    final snapshot = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    final addresses = <String>[];
    for (var doc in snapshot.docs) {
      addresses.add(doc.id);
    }

    return addresses;
  }

  Future<Address> getAddressFromId(
      {required String? uid, required String? id}) async {
    final doc = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id)
        .get();
    final address = Address.fromMap(doc.data()!, id: doc.id);
    return address;
  }

  Future<bool> addAddressForCurrentUser(
      {required String? uid, required Address address}) async {
    final addressesCollectionReference = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> deleteAddressForCurrentUser(
      {required String? uid, required String id}) async {
    final addressDocReference = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id);
    await addressDocReference.delete();
    return true;
  }

  Future<bool> updateAddressForCurrentUser(
      {required String? uid, required Address address}) async {
    final addressDocReference = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(address.id);
    await addressDocReference.update(address.toMap());
    return true;
  }

  Future<CartItem> getCartItemFromId(
      {required String? uid, required String id}) async {
    final cartCollectionRef = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    final cartItem = CartItem.fromMap(docSnapshot.data()!, id: docSnapshot.id);
    return cartItem;
  }

  Future<bool> addProductToCart(
      {required String? uid, required String? productId}) async {
    final cartCollectionRef = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(productId);
    final docSnapshot = await docRef.get();
    bool alreadyPresent = docSnapshot.exists;
    if (alreadyPresent == false) {
      docRef.set(CartItem(itemCount: 1).toMap());
    } else {
      docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    }
    return true;
  }

  Future<List<String>> emptyCart(uid) async {
    final cartItems = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    List orderedProductsUid = <String>[];
    for (final doc in cartItems.docs) {
      orderedProductsUid.add(doc.id);
      await doc.reference.delete();
    }
    return orderedProductsUid as FutureOr<List<String>>;
  }

  Future<num> get cartTotal async {
    String uid = AuthentificationService().currentUser!.uid;
    final cartItems = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    num total = 0.0;
    for (final doc in cartItems.docs) {
      num itemsCount = doc.data()[CartItem.ITEM_COUNT_KEY];
      final product = await (ProductDatabaseHelper().getProductWithID(doc.id));
      total += (itemsCount * product!.discountPrice!);
    }
    return total;
  }

/*
  Future<List<PostModal>> get followingsPost async {
    String uid = AuthentificationService().currentUser!.uid;
    final userFollowing = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        .get();
    List<PostModal> posts = [];
    for (final doc in userFollowing.docs) {
      final post = await firestore!
          .collection('posts')
          .doc(doc.id)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .get();
      for (final doc1 in post.docs) {
        posts.add(PostModal.fromMap(doc1.data()));
      }
    }
    return posts;
  }
  */
  Future<List<String>?> get followingsPost1 async {
    String uid = AuthentificationService().currentUser!.uid;
    final userFollowing = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        .get();
    final posts = <String>[];
    for (final doc in userFollowing.docs) {
      final post = await firestore!
          .collection('posts')
          .doc(doc.id)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .get();
      for (final doc1 in post.docs) {
        posts.add(doc1.id);
      }
    }
    return posts;
  }

  Stream<List<PostModal>?> trendingPost1() {
    return firestore!
        .collection('post')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PostModal.fromMap(doc.data())).toList());
  }

  Future<List<String>> get followingHasStory async {
    String uid = AuthentificationService().currentUser!.uid;
    final userFollowing = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        .get();
    List<String> followers = [];
    for (final doc in userFollowing.docs) {
      final query = await firestore!
          .collection('story')
          .doc(doc.id)
          //  .collection('userStories')
          //  .orderBy('timestamp', descending: true)
          .get();
      if (query.exists) {
        followers.add(doc.id);
      }
    }
    return followers;
  }

/*  Future<List<LastMsgModal>> lastMsgs(currentUserId) async {
    List<LastMsgModal> lastMsgs = [];
    final post = await firestore!
        .collection('chatRooms')
        .orderBy('lastMessageSendTs', descending: true)
        .get();
    for (final doc1 in post.docs) {
      final users = firestore!.collection('chatRooms').doc(doc1.id);
      final usersd = (await users.get()).data()!;
      final list = usersd['users'].cast<String>();
      if (list.contains(currentUserId)) {
        for (final doc in list.docs) {
          lastMsgs.add(LastMsgModal.fromMap(doc.data()));
        }
      }
    }
    return lastMsgs;
  } */

  Future<List<VideoModal>> get followingsShorts async {
    String uid = AuthentificationService().currentUser!.uid;
    final userFollowing = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        .get();
    List<VideoModal> posts = [];
    for (final doc in userFollowing.docs) {
      final post = await firestore!
          .collection('videos')
          .doc(doc.id)
          .collection('userVideos')
          .orderBy('timestamp', descending: true)
          .get();
      for (final doc1 in post.docs) {
        posts.add(VideoModal.fromMap(doc1.data()));
      }
    }
    return posts;
  }

  Future<List<VideoModal>> get trendingShorts async {
    final users = await firestore!.collection('users').get();
    List<VideoModal> shorts = [];
    for (final doc in users.docs) {
      final short = await firestore!
          .collection('videos')
          .doc(doc.id)
          .collection('userVideos')
          .orderBy('timestamp', descending: true)
          //  .where('likes', isGreaterThanOrEqualTo: 100)
          .get();
      for (final doc1 in short.docs) {
        shorts.add(VideoModal.fromMap(doc1.data()));
      }
    }
    return shorts;
  }

  Future<List<VideoModal>> get usersShorts async {
    String uid = AuthentificationService().currentUser!.uid;
    List<VideoModal> shorts = [];
    final short = await firestore!
        .collection('videos')
        .doc(uid)
        .collection('userVideos')
        .orderBy('timestamp', descending: true)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .get();
    for (final doc1 in short.docs) {
      shorts.add(VideoModal.fromMap(doc1.data()));
    }

    return shorts;
  }

  Future<List<PostModal>> get usersPosts async {
    String uid = AuthentificationService().currentUser!.uid;
    List<PostModal> posts = [];
    final post = await firestore!
        .collection('posts')
        .doc(uid)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .get();
    for (final doc1 in post.docs) {
      posts.add(PostModal.fromMap(doc1.data()));
    }

    return posts;
  }

  Stream<List<PostModal>> usersPosts1(uid) {
    return firestore!
        .collection('posts')
        .doc(uid)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PostModal.fromMap(doc.data())).toList());
  }

  Future<List<StoryModal>> usersStories(uid) async {
    List<StoryModal> stories = [];
    final story = await firestore!
        .collection('stories')
        .doc(uid)
        .collection('userStories')
        .orderBy('timestamp', descending: true)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .get();
    for (final doc1 in story.docs) {
      stories.add(StoryModal.fromMap(doc1.data()));
    }

    return stories;
  }

  Future<List<String>?> usersFollowers(uid) async {
    List<String>? followers = <String>[];
    final follower = await firestore!
        .collection('followers')
        .doc(uid)
        .collection('userFollowers')
        // .orderBy('displayName', descending: false)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .get();
    for (final doc1 in follower.docs) {
      followers.add(doc1.id);
    }

    return followers;
  }

  Future<List<String>?> usersFollowing(uid) async {
    List<String>? followings = <String>[];
    final following = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        //  .orderBy('displayName', descending: false)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .get();
    for (final doc1 in following.docs) {
      followings.add(doc1.id);
    }

    return followings;
  }

  Future<List<String>?> get usersNotFollowing async {
    String uid = AuthentificationService().currentUser!.uid;
    List<String>? notFollowings = <String>[];
    final following = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        .get();
    if (following.docs.isEmpty) {
      final allUserlist = await firestore!
          .collection('users')
          .where('id', isNotEqualTo: uid)
          .get();
      for (final doc1 in allUserlist.docs) {
        notFollowings.add(doc1.id);
      }
      return notFollowings;
    } else {
      for (final doc in following.docs) {
        final allUserlist = await firestore!
            .collection('users')
            .where('id', arrayContainsAny: [uid, doc.id]).get();
        for (final doc2 in allUserlist.docs) {
          final allUserlist1 = await firestore!
              .collection('users')
              .where('id', isNotEqualTo: doc2.id)
              .get();
          for (final doc3 in allUserlist1.docs) {
            notFollowings.add(doc3.id);
          }
        }
      }
      return notFollowings;
    }
  }

  Future<List<String>?> usersFollowingFavorite(uid) async {
    List<String>? followingFavorites = <String>[];
    final followingFavorite = await firestore!
        .collection('followingFavorites')
        .doc(uid)
        .collection('userFollowingFavorites')
        //  .orderBy('displayName', descending: false)
        //  .where('likes', isGreaterThanOrEqualTo: 100)
        .get();
    for (final doc1 in followingFavorite.docs) {
      followingFavorites.add(doc1.id);
    }
    return followingFavorites;
  }

  Future<List<String>?> followingsShortslatest(uid) async {
    final userFollowing = await firestore!
        .collection('following')
        .doc(uid)
        .collection('userFollowing')
        .get();
    List<String>? followings = <String>[];
    for (final doc in userFollowing.docs) {
      final following = await firestore!
          .collection('stories')
          //  .doc(doc.id)
          .where('uid', isEqualTo: doc.id)
          //    .doc(doc.id)
          //    .collection('userStories')
          .orderBy('timestamp', descending: true)
          .get();
      for (final doc1 in following.docs) {
        followings.add(doc1.id);
      }
    }
    return followings;
  }

  Future<List<String>?> followingsFavoritesShortslatest(uid) async {
    final userFollowing = await firestore!
        .collection('followingFavorites')
        .doc(uid)
        .collection('userFollowingFavorites')
        .get();
    List<String>? followings = <String>[];
    for (final doc in userFollowing.docs) {
      final following = await firestore!
          .collection('stories')
          .where('uid', isEqualTo: doc.id)
          //    .doc(doc.id)
          //    .collection('userStories')
          .orderBy('timestamp', descending: true)
          .get();
      for (final doc1 in following.docs) {
        followings.add(doc1.id);
      }
    }
    return followings;
  }

  Future<bool> removeProductFromCart(
      {required String? uid, required String cartItemID}) async {
    final cartCollectionReference = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    await cartCollectionReference.doc(cartItemID).delete();
    return true;
  }

  Future<bool> increaseCartItemCount(
      {required String? uid, required String cartItemID}) async {
    final cartCollectionRef = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    return true;
  }

  Future<bool> decreaseCartItemCount(
      {required String? uid, required String cartItemID}) async {
    final cartCollectionRef = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    final docSnapshot = await docRef.get();
    int currentCount = docSnapshot.data()![CartItem.ITEM_COUNT_KEY];
    if (currentCount <= 1) {
      return removeProductFromCart(uid: uid, cartItemID: cartItemID);
    } else {
      docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(-1)});
    }
    return true;
  }

  Future<List<String>> get allCartItemsList async {
    String uid = AuthentificationService().currentUser!.uid;
    final querySnapshot = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    List itemsId = <String>[];
    for (final item in querySnapshot.docs) {
      itemsId.add(item.id);
    }
    return itemsId as FutureOr<List<String>>;
  }

  Future<List<String>> get orderedProductsList async {
    String uid = AuthentificationService().currentUser!.uid;
    final orderedProductsSnapshot = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .get();
    List orderedProductsId = <String>[];
    for (final doc in orderedProductsSnapshot.docs) {
      orderedProductsId.add(doc.id);
    }
    return orderedProductsId as FutureOr<List<String>>;
  }

  Future<bool> addToMyOrders(
      {required String? uid, required List<OrderedProduct> orders}) async {
    final orderedProductsCollectionRef = firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME);
    for (final order in orders) {
      await orderedProductsCollectionRef.add(order.toMap());
    }
    return true;
  }

  Future<OrderedProduct> getOrderedProductFromId(
      {required String? uid, required String id}) async {
    final doc = await firestore!
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .doc(id)
        .get();
    final orderedProduct = OrderedProduct.fromMap(doc.data()!, id: doc.id);
    return orderedProduct;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser!.uid;
    return firestore!.collection('users').doc(uid).get().asStream();
  }

  Future<bool> updatePhoneForCurrentUser(
      {required String? uid, required String phone}) async {
    final userDocSnapshot = firestore!.collection('users').doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture(currentUserUid) {
    return "user/display_picture/$currentUserUid";
  }

  String getPathForCurrentUserCoverPicture(currentUserUid) {
    return "user/cover_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(
      {required String? uid, required String url}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> uploadCoverPictureForCurrentUser(
      {required String? uid, required String url}) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {CP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser(uid) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<bool> removeCoverPictureForCurrentUser(uid) async {
    final userDocSnapshot =
        firestore!.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        CP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String?> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser!.uid;
    final userDocSnapshot =
        await firestore!.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()![DP_KEY];
  }

  Future<String?> displayPictureForUser(uid) async {
    final userDocSnapshot =
        await firestore!.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()![DP_KEY];
  }

  Future<String?> productImage(id) async {
    final docSnapshot = await firestore!.collection('products').doc(id).get();
    return docSnapshot.data()![DP_KEY];
  }

  /* Future<String?> getLocationPost(id) async {
    final doc = await firestore!.collection('posts').doc(id).get();
    return doc.data()!['location'];
  }  

  Future<List<String>?> postCommentList(id) async {
    final doc = await firestore!.collection('posts').doc(id).get();
    return doc.data()!['comments'];
  }
  */

  Future<String?> getUserIdofComment(id) async {
    final doc = await firestore!.collection('comments').doc(id).get();
    return doc.data()!['ownerId'];
  }

  Future<String?> getUserIdofReply(id) async {
    final doc = await firestore!.collection('replies').doc(id).get();
    return doc.data()!['ownerId'];
  }

  Future<List<String>?> postCommentList(post) async {
    List<String>? commentList = <String>[];
    final doc = await firestore!
        .collection('posts')
        .doc(post.ownerId)
        .collection('userPosts')
        .doc(post.id)
        .collection('comments')
        .get();
    for (final doc1 in doc.docs) {
      commentList.add(doc1.id);
    }

    return commentList;
  }

  Future<CommentModal> getCommentModalfromId(id) async {
    final docSnapshot = await firestore!.collection('comments').doc(id).get();
    final comment =
        CommentModal.fromMap(docSnapshot.data()!, id: docSnapshot.id);
    return comment;
  }

  Future<ReplyModal> getReplyModalfromId(id) async {
    final docSnapshot = await firestore!.collection('replies').doc(id).get();
    final reply = ReplyModal.fromMap(docSnapshot.data()!, id: docSnapshot.id);
    return reply;
  }

  Future<String?> postdescription(PostModal post) async {
    final doc = await firestore!
        .collection('posts')
        .doc(post.ownerId!)
        .collection('userPosts')
        .doc(post.postId!)
        .get();
    return doc.data()!['description'];
  }

  Future<String?> postlocation(PostModal post) async {
    final doc = await firestore!
        .collection('posts')
        .doc(post.ownerId!)
        .collection('userPosts')
        .doc(post.postId!)
        .get();
    return doc.data()!['location'];
  }

  Future<String?> get coverPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser!.uid;
    final userDocSnapshot =
        await firestore!.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()![CP_KEY];
  }
}
