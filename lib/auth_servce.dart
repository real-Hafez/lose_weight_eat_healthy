import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to sign up a new user with email and password
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
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user details to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
        // Add other fields if necessary
      });

      // Optionally navigate or perform additional actions here
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseAuthErrorMessage(e);
      _showToast(message);
    } catch (e) {
      _showToast('An unknown error occurred. Please try again.');
    }
  }

  // Method to save additional user details (for existing users)
  Future<void> saveAdditionalUserDetails({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required BuildContext context,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
        });
      }
    } catch (e) {
      _showToast('Failed to update user details. Please try again.');
    }
  }

  // Helper method to get user-friendly error messages
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

  // Helper method to show a toast message
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
