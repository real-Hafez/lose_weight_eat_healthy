import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/FifthOnboardingPageman.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/Fifthonboardingpagewoman.dart';

class BodyFatPercentagePage extends StatelessWidget {
  const BodyFatPercentagePage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _getUserGender(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
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
          if (gender == 'Male' || gender == 'ذكر') {
            return Fifthonboardingpageman(
              onAnimationFinished: onAnimationFinished,
              onNextButtonPressed: onNextButtonPressed,
            );
          } else if (gender == 'Female' || gender == 'انثي') {
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

    final genderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('gender')
        .doc('data');

    return genderDoc.get();
  }
}
