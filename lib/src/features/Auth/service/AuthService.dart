import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/shared/toast_shared.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? userUID = userCredential.user?.uid;

      await _firestore.collection('users').doc(userUID).set({
        'uid': userUID,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
      });

      if (userUID != null) {
        await _secureStorage.write(key: 'userUID', value: userUID);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessage(e, context);
      ToastUtil.showToast(errorMessage);
      throw errorMessage;
    } catch (e) {
      ToastUtil.showToast(S.of(context).unknownError);
      throw S.of(context).unknownError;
    }
  }

  String _getFirebaseAuthErrorMessage(
      FirebaseAuthException e, BuildContext context) {
    switch (e.code) {
      case 'email-already-in-use':
        return S.of(context).emailAlreadyInUse;
      case 'invalid-email':
        return S.of(context).invalidEmail;
      case 'weak-password':
        return S.of(context).weakPassword;
      default:
        return S.of(context).unknownError;
    }
  }

  Future<void> saveAdditionalUserDetails({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required BuildContext context,
  }) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
        });
      }
    } catch (e) {
      ToastUtil.showToast(S.of(context).updateUserDetailsFailed);
      throw S.of(context).updateUserDetailsFailed;
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userUID = userCredential.user?.uid;
      await _secureStorage.write(key: 'userUID', value: userUID);
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessageForSignin(e, context);
      ToastUtil.showToast(errorMessage);
      throw errorMessage;
    }
  }

  String _getFirebaseAuthErrorMessageForSignin(
      FirebaseAuthException e, BuildContext context) {
    switch (e.code) {
      case 'invalid-email':
        return S.of(context).invalidEmail;
      case 'user-not-found':
        return S.of(context).userNotFound;
      case 'wrong-password':
        return S.of(context).wrongPassword;
      case 'user-disabled':
        return S.of(context).userDisabled;
      case 'too-many-requests':
        return S.of(context).tooManyRequests;
      case 'network-request-failed':
        return S.of(context).networkRequestFailed;
      case 'operation-not-allowed':
        return S.of(context).operationNotAllowed;
      default:
        return S.of(context).unknownError;
    }
  }
}
