// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_swarn_holidays/ecom/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:new_swarn_holidays/ecom/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:new_swarn_holidays/models/user_data.dart';
import 'package:provider/provider.dart';

import '../../exceptions/firebaseauth/credential_actions_exceptions.dart';
import '../../exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import '../../exceptions/firebaseauth/reauth_exceptions.dart';

//import 'package:new_swarn_holidays/models/user_data.dart';

class AuthentificationService {
  static const String USER_NOT_FOUND_EXCEPTION_CODE = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION_CODE = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION_CODE =
      "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION_CODE =
      "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION_CODE = "weak-password";
  static const String USER_MISMATCH_EXCEPTION_CODE = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION_CODE = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION_CODE = "invalid-email";
  static const String USER_DISABLED_EXCEPTION_CODE = "user-disabled";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION_CODE =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION_CODE =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION_CODE =
      "requires-recent-login";

  static const String DP_KEY = "profileImageUrl";
  static const String CP_KEY = "coverImageUrl";
  static const String PHONE_KEY = 'phone';
  static const String FAV_PRODUCTS_KEY = "favourite_products";
  static const String OWNED_PRODUCTS_KEY = 'owned_products';
  static const String DOB = 'dob';
  static const String EMAIL = 'email';
  bool? isBanned;
  bool? isVerified;
  String role = 'user';

  FirebaseAuth? _firebaseAuth;

  AuthentificationService._privateConstructor();
  static final AuthentificationService _instance =
      AuthentificationService._privateConstructor();

  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore? get firestore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore;
  }

  FirebaseAuth? get firebaseAuth {
    _firebaseAuth ??= FirebaseAuth.instance;
    return _firebaseAuth;
  }

  factory AuthentificationService() {
    return _instance;
  }

  Stream<User?> get authStateChanges => firebaseAuth!.authStateChanges();

  Stream<User?> get userChanges => firebaseAuth!.userChanges();

  Future<void> deleteUserAccount() async {
    await currentUser!.delete();
    await signOut();
  }

  Future<bool> reauthCurrentUser(password) async {
    try {
      UserCredential userCredential = await firebaseAuth!
          .signInWithEmailAndPassword(
              email: currentUser!.email!, password: password);
      userCredential = await currentUser!
          .reauthenticateWithCredential(userCredential.credential!);
    } on FirebaseAuthException catch (e) {
      if (e.code == WRONG_PASSWORD_EXCEPTION_CODE) {
        throw FirebaseSignInAuthWrongPasswordException();
      } else {
        throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      throw FirebaseReauthUnknownReasonFailureException(message: e.toString());
    }
    return true;
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.emailVerified) {
        return true;
      } else {
        await userCredential.user!.sendEmailVerification();
        throw FirebaseSignInAuthUserNotVerifiedException();
      }
    } /* on 
    //Messaged
    FirebaseAuthException {
      rethrow;
    } */
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case INVALID_EMAIL_EXCEPTION_CODE:
          throw FirebaseSignInAuthInvalidEmailException();

        case USER_DISABLED_EXCEPTION_CODE:
          throw FirebaseSignInAuthUserDisabledException();

        case USER_NOT_FOUND_EXCEPTION_CODE:
          throw FirebaseSignInAuthUserNotFoundException();

        case WRONG_PASSWORD_EXCEPTION_CODE:
          throw FirebaseSignInAuthWrongPasswordException();

        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String secondName,
      required BuildContext context}) async {
    try {
      final UserCredential userCredential = await firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
      final String id = userCredential.user!.uid;
      //   Provider.of<UserData>(context, listen: false).cameFromRegisterScreen =
      //    true;
      final DateTime dateNow = DateTime.now();
      final Timestamp timeNow = Timestamp.fromDate(dateNow);
      if (userCredential.user!.emailVerified == false) {
        await userCredential.user!.sendEmailVerification();
      }
      await firestore!.collection('users').doc(id).set({
        'id': id,
        'firstName': firstName,
        'secondName': secondName,
        DP_KEY: null,
        EMAIL: email,
        'bio': null,
        'timeCreated': timeNow,
        PHONE_KEY: null,
        FAV_PRODUCTS_KEY: <String>[],
      });
      Provider.of<UserData>(context, listen: false).currentUserId = id;
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case EMAIL_ALREADY_IN_USE_EXCEPTION_CODE:
          throw FirebaseSignUpAuthEmailAlreadyInUseException();
        case INVALID_EMAIL_EXCEPTION_CODE:
          throw FirebaseSignUpAuthInvalidEmailException();
        case OPERATION_NOT_ALLOWED_EXCEPTION_CODE:
          throw FirebaseSignUpAuthOperationNotAllowedException();
        case WEAK_PASSWORD_EXCEPTION_CODE:
          throw FirebaseSignUpAuthWeakPasswordException();
        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp2(
      {required String profImg, required String? currentUserId}) async {
    await firestore!.collection('users').doc(currentUserId).update({
      DP_KEY: null,
    });
    return true;
  }

  Future<void> signOut() async {
    await firebaseAuth!.signOut();
  }

  bool get currentUserVerified {
    currentUser!.reload();
    return currentUser!.emailVerified;
  }

  Future<void> sendVerificationEmailToCurrentUser() async {
    await firebaseAuth!.currentUser!.sendEmailVerification();
  }

  User? get currentUser {
    return firebaseAuth!.currentUser;
  }

  Future<void> updateCurrentUserDisplayName(
      {required String updatedFirstName,
      required String updatedSecondName}) async {
    //  await currentUser!.updateDisplayName(updatedDisplayName);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update(
            {'firstName': updatedFirstName, 'secondName': updatedSecondName});
  }

  Future<bool> resetPasswordForEmail(String email) async {
    try {
      await firebaseAuth!.sendPasswordResetEmail(email: email);
      return true;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == USER_NOT_FOUND_EXCEPTION_CODE) {
        throw FirebaseCredentialActionAuthUserNotFoundException();
      } else {
        throw FirebaseCredentialActionAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changePasswordForCurrentUser(
      {String? oldPassword, required String newPassword}) async {
    try {
      bool isOldPasswordProvidedCorrect = true;
      if (oldPassword != null) {
        isOldPasswordProvidedCorrect =
            await verifyCurrentUserPassword(oldPassword);
      }
      if (isOldPasswordProvidedCorrect) {
        await firebaseAuth!.currentUser!.updatePassword(newPassword);

        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } /* on MessagedFirebaseAuthException {
      rethrow;
    } */
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case WEAK_PASSWORD_EXCEPTION_CODE:
          throw FirebaseCredentialActionAuthWeakPasswordException();
        case REQUIRES_RECENT_LOGIN_EXCEPTION_CODE:
          throw FirebaseCredentialActionAuthRequiresRecentLoginException();
        default:
          throw FirebaseCredentialActionAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changeEmailForCurrentUser(
      {String? password, String? newEmail}) async {
    try {
      bool isPasswordProvidedCorrect = true;
      if (password != null) {
        isPasswordProvidedCorrect = await verifyCurrentUserPassword(password);
      }
      if (isPasswordProvidedCorrect) {
        await currentUser!.verifyBeforeUpdateEmail(newEmail!);

        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } /* on MessagedFirebaseAuthException {
      rethrow;
    } */
    on FirebaseAuthException catch (e) {
      throw FirebaseCredentialActionAuthException(message: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyCurrentUserPassword(String password) async {
    try {
      final AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );

      final authCredentials =
          await currentUser!.reauthenticateWithCredential(authCredential);

      // ignore: unnecessary_null_comparison
      return authCredentials != null;
    } /* on MessagedFirebaseAuthException {
      rethrow;
    } */
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case USER_MISMATCH_EXCEPTION_CODE:
          throw FirebaseReauthUserMismatchException();
        case USER_NOT_FOUND_EXCEPTION_CODE:
          throw FirebaseReauthUserNotFoundException();
        case INVALID_CREDENTIALS_EXCEPTION_CODE:
          throw FirebaseReauthInvalidCredentialException();
        case INVALID_EMAIL_EXCEPTION_CODE:
          throw FirebaseReauthInvalidEmailException();
        case WRONG_PASSWORD_EXCEPTION_CODE:
          throw FirebaseReauthWrongPasswordException();
        case INVALID_VERIFICATION_CODE_EXCEPTION_CODE:
          throw FirebaseReauthInvalidVerificationCodeException();
        case INVALID_VERIFICATION_ID_EXCEPTION_CODE:
          throw FirebaseReauthInvalidVerificationIdException();
        default:
          throw FirebaseReauthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }
}
