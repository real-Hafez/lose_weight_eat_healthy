import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic>? dataToSave;
  final bool saveData;
  final String? userId;

  const NextButton({
    super.key,
    required this.onPressed,
    this.dataToSave,
    this.saveData = true,
    this.userId,
  });

  Future<void> _saveDataToFirestore(BuildContext context) async {
    if (saveData && dataToSave != null && userId != null) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('User not logged in');
        }

        // Convert height to string format
        final heightCm = dataToSave!['heightCm'] ?? 0;
        final heightFt = dataToSave!['heightFt'] ?? 0;
        final heightInches = dataToSave!['heightInches'] ?? 0;
        final heightString = '$heightFt\'$heightInches"';
        final gender = dataToSave!['selectedGender'];

        // Reference to the existing user document
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Reference to 'userdata/profile_data' document
        DocumentReference profileDataDocRef =
            userDocRef.collection('userdata').doc('profile_data');

        // Save or update gender in 'gender' collection
        await profileDataDocRef.collection('gender').doc('gender_data').set({
          'gender': gender,
        }, SetOptions(merge: true)); // Merge with existing data

        // Save or update height in 'height' collection
        await profileDataDocRef.collection('height').doc('height_data').set({
          'heightCm': heightCm,
          'heightString': heightString, // Save height in string format
        }, SetOptions(merge: true)); // Merge with existing data

        // Print to console for debugging
        print('User details updated successfully for ID: $userId');
        print('Data saved at paths:');
        print(
            ' - Gender: ${profileDataDocRef.collection('gender').doc('gender_data').path}');
        print(
            ' - Height: ${profileDataDocRef.collection('height').doc('height_data').path}');
        print('Updated data: ${dataToSave.toString()}');
      } catch (e) {
        print('Error updating data: $e');
        // Optionally, you can also show an error message to the user here
      }
    } else {
      print('No data to save or user ID is missing');
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
