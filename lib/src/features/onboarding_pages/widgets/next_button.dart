import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic>? dataToSave;
  final bool saveData;
  final String? userId;
  final String collectionName;

  const NextButton({
    super.key,
    required this.onPressed,
    this.dataToSave,
    this.saveData = true,
    this.userId,
    this.collectionName = '',
  });

  Future<void> _saveDataToFirestore(BuildContext context) async {
    if (saveData && userId != null && dataToSave != null) {
      try {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId!);

        final subcollectionDocRef =
            userDocRef.collection(collectionName).doc('data');

        await subcollectionDocRef.set(dataToSave!, SetOptions(merge: true));

        print('User data successfully updated in $collectionName.');
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _saveDataToFirestore(context);
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          S.of(context).next,
          style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).height * .025,
              color: Colors.white),
        ),
      ),
    );
  }
}
