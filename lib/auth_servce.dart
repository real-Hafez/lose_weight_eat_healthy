import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/consent.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      ToastUtil.showToast(errorMessage);
      throw errorMessage; // Ensure specific error messages are propagated
    } catch (e) {
      ToastUtil.showToast('An unknown error occurred. Please try again.');
      throw 'An unknown error occurred. Please try again.';
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'An unknown error occurred. Please try again.';
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
      ToastUtil.showToast('Failed to update user details. Please try again.');
      throw 'Failed to update user details. Please try again.';
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessageForSignin(e);
      ToastUtil.showToast(errorMessage);
      throw errorMessage;
    }
  }

  String _getFirebaseAuthErrorMessageForSignin(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'operation-not-allowed':
        return 'Sign-in method not allowed. Please enable the sign-in method in Firebase console.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
