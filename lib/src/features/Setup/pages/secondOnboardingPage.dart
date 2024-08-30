import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class Secondonboardingpage extends StatefulWidget {
  const Secondonboardingpage(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed});
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  State<Secondonboardingpage> createState() => _SecondonboardingpageState();
}

class _SecondonboardingpageState extends State<Secondonboardingpage> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Select Your Gender',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildGenderBox('Male', Icons.male)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildGenderBox('Female', Icons.female)),
                ],
              ),
            ),
            const Spacer(),
            if (selectedGender != null)
              NextButton(
                collectionName: 'gender',
                userId: FirebaseAuth.instance.currentUser?.uid,
                // userId: widget.us,
                onPressed: widget.onNextButtonPressed,
                dataToSave: {
                  'selectedGender': selectedGender,
                },
                saveData: selectedGender !=
                    null, // Save data only if gender is selected
              ),
            const SizedBox(
                height: 20), // Spacing between the button and the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildGenderBox(String gender, IconData icon) {
    final bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
          print('Selected Gender: $selectedGender'); // Debug print
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          color: isSelected ? Colors.blue[50] : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 10),
            Text(
              gender,
              style: TextStyle(
                fontSize: 22,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
