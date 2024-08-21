import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lose_weight_eat_healthy/src/features/Auth/service/UserService.dart';
import 'package:lose_weight_eat_healthy/src/shared/toast_shared.dart';

class Googleauthservice {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final UserService userService = UserService();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String? email = user.email;
        final String? displayName = user.displayName;
        final String username = email?.split('@').first ?? '';
        final List<String> nameParts = (displayName ?? '').split(' ');
        final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final String lastName = nameParts.length > 1 ? nameParts.last : '';

        await userService.saveUserDetails(
          userId: user.uid,
          email: email ?? '',
          firstName: firstName,
          lastName: lastName,
          username: username,
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Account exists with a different credential.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credential.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      ToastUtil.showToast(errorMessage);
      return null;
    } catch (e) {
      print('Error: $e');
      ToastUtil.showToast('An unexpected error occurred.');
      return null;
    }
  }
}
