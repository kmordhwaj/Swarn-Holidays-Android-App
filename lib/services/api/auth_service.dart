import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'package:new_swarn_holidays/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:new_swarn_holidays/models/models.dart' as m;

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> signUpUser(BuildContext context, String name,
      String email, String password, String dob) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      late m.UserModal signedInUser = authResult.user as m.UserModal;

      // ignore: unnecessary_null_comparison
      if (signedInUser != null) {
        String? token = await _messaging.getToken();
        _firestore.collection('users').doc(signedInUser.id).set({
          'name': name,
          'email': email,
          'profileImageUrl': '',
          'coverImageUrl': '',
          'bio': '',
          'workProfile': '',
          'isBanned': '',
          'website': '',
          'token': token,
          'isVerified': false,
          'role': 'user',
          'timeCreated': Timestamp.now(),
          'dob': dob,
          'phone': null,
          'favourite_products': <String>[],
        });
      }
      Provider.of<UserData>(context, listen: false).currentUserId =
          signedInUser.id;

      Navigator.pop(context);
    } on PlatformException catch (err) {
      // ignore: use_rethrow_when_possible
      throw (err);
    }
  }

  static Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ignore: unused_local_variable
      m.UserModal? signedInUser = authResult.user as m.UserModal?;
    } on PlatformException catch (err) {
      // ignore: use_rethrow_when_possible
      throw (err);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (err) {
      // ignore: use_rethrow_when_possible
      throw (err);
    }
  }

  static Future<void> removeToken() async {
    final currentUser = _auth.currentUser!;
    await usersRef.doc(currentUser.uid).set(
      {'token': ''},
    );
  }

  static Future<void> updateToken() async {
    final currentUser = _auth.currentUser!;
    final token = await _messaging.getToken();
    final userDoc = await usersRef.doc(currentUser.uid).get();
    if (userDoc.exists) {
      m.UserModal user = m.UserModal.fromDocument(userDoc);
      if (token != user.token) {
        usersRef.doc(currentUser.uid).set(
          {'token': token},
        );
      }
    }
  }

  static Future<void> updateTokenWithUser(m.UserModal user) async {
    final token = await _messaging.getToken();
    if (token != user.token) {
      await usersRef.doc(user.id).update({'token': token});
    }
  }

  static Future<void> logout() async {
    await removeToken();
    Future.wait([
      _auth.signOut(),
    ]);
  }
}
