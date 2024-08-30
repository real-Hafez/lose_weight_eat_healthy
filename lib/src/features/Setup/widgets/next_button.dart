import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic>? dataToSave;
  final bool saveData;
  final String? userId;
  final String collectionName; // Added for collection name

  const NextButton({
    super.key,
    required this.onPressed,
    this.dataToSave,
    this.saveData = true,
    this.userId,
    required this.collectionName, // Added for collection name
  });

  Future<void> _saveDataToFirestore(BuildContext context) async {
    if (saveData && userId != null && dataToSave != null) {
      try {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId!);

        // Reference to the specific document within the subcollection
        final subcollectionDocRef =
            userDocRef.collection(collectionName).doc('data');

        // Use set() with merge: true to update fields without overwriting existing data
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
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          'NEXT',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
