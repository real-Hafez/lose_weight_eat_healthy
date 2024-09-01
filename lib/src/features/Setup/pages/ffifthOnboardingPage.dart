import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/FifthOnboardingPageman.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/Fifthonboardingpagewoman.dart';

class FifthOnboardingPage extends StatelessWidget {
  const FifthOnboardingPage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _getUserGender(), // Fetch user's gender from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              // Show loading indicator while fetching
              );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('User gender not found')),
          );
        } else {
          final gender = snapshot.data!['selectedGender'];
          if (gender == 'Male') {
            return Fifthonboardingpageman(
              onAnimationFinished: onAnimationFinished,
              onNextButtonPressed: onNextButtonPressed,
            );
          } else if (gender == 'Female') {
            return Fifthonboardingpagewoman(
              onAnimationFinished: onAnimationFinished,
              onNextButtonPressed: onNextButtonPressed,
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('Gender not recognized')),
            );
          }
        }
      },
    );
  }

  Future<DocumentSnapshot> _getUserGender() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Reference to the user's gender document
    final genderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('gender') // Access the 'gender' subcollection
        .doc(
            'data'); // Access the 'data' document inside the 'gender' subcollection

    return genderDoc.get();
  }
}
