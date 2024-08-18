import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lose_weight_eat_healthy/UserService.dart';
import 'package:lose_weight_eat_healthy/consent.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final UserService userService = UserService(); // Create an instance of UserService

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;

        // Retrieve additional user information
        String? email = user?.email;
        String? displayName = user?.displayName;
        String? firstName;
        String? lastName;
        String username = email?.split('@').first ?? ''; // Generate username from email if not available

        if (displayName != null) {
          // Split display name into first and last name
          var nameParts = displayName.split(' ');
          firstName = nameParts.isNotEmpty ? nameParts.first : '';
          lastName = nameParts.length > 1 ? nameParts.last : '';
        }

        // Print user details
        print('User Email: $email');
        print('User First Name: $firstName');
        print('User Last Name: $lastName');
        print('User Username: $username');

        // Save user details to Firestore
        if (email != null && firstName != null && lastName != null && user != null) {
          await userService.saveUserDetails(
            userId: user.uid, // Use user ID from Firebase Authentication
            email: email,
            firstName: firstName,
            lastName: lastName,
            username: username, // Save username to Firestore
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      String errorMessage;
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'Account exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid credential.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }
      // Show a toast message
      ToastUtil.showToast(errorMessage);
    } catch (e) {
      // Handle general errors
      print('Error: $e');
      ToastUtil.showToast('An unexpected error occurred.');
    }

    return user;
  }
}
