import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/consent.dart';
import 'package:lose_weight_eat_healthy/home.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign up user and save additional details to Firestore
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

      // Save additional user details to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
      });

      // Optionally navigate to a new screen or show a confirmation message
      ToastUtil.showToast('Account created successfully');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      ToastUtil.showToast(errorMessage);
      throw errorMessage;
    } catch (e) {
      // Handle general exceptions
      ToastUtil.showToast('An unknown error occurred. Please try again.');
      throw 'An unknown error occurred. Please try again.';
    }
  }

  // Update additional user details in Firestore
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

  // Get error messages for Firebase Auth exceptions
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

  // Sign in user
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

      ToastUtil.showToast('Sign in successful');
      // Navigate to the home screen or another desired screen
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Sign-in method not allowed. Please enable the sign-in method in Firebase console.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }

      ToastUtil.showToast(errorMessage);
      throw errorMessage;
    }
  }
}
