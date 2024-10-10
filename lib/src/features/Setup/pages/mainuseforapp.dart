import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/FocusAreaWidget_woman.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/pages/FocusAreaWidgetman.dart';

class FocusAreaWidget extends StatefulWidget {
  const FocusAreaWidget(
      {super.key,
      required this.onAnimationFinished,
      required this.onNextButtonPressed,
      required this.onSelectionMade});

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final Function(List<String>)
      onSelectionMade; // Pass the selections to the parent

  @override
  State<FocusAreaWidget> createState() => _FocusAreaWidgetState();
}

class _FocusAreaWidgetState extends State<FocusAreaWidget> {
  List<bool> isSelectedList = [false, false, false];
  List<String> selectedOptions = [];

  void toggleSelection(int index) {
    setState(() {
      isSelectedList[index] = !isSelectedList[index];
      selectedOptions = _getSelectedOptions();
      widget.onSelectionMade(selectedOptions); // Pass selections back
    });
  }

  List<String> _getSelectedOptions() {
    List<String> options = [];
    for (int i = 0; i < isSelectedList.length; i++) {
      if (isSelectedList[i]) {
        options.add(_getSelectionName(i));
      }
    }
    return options;
  }

  String _getSelectionName(int index) {
    switch (index) {
      case 0:
        return 'Training';
      case 1:
        return 'Water Reminder';
      case 2:
        return 'Nutrition';
      default:
        return '';
    }
  }

  void _handleSelectionMade(List<String> selections) {
    // Handle the selections made by the user
    print('User selected: $selections');
  }

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
            return FocusAreaWidget_man(
              onSelectionMade: _handleSelectionMade,
              onAnimationFinished: widget.onAnimationFinished,
              onNextButtonPressed: widget.onNextButtonPressed,
            );
          } else if (gender == 'Female') {
            return FocusAreaWidget_woman(
              onSelectionMade: _handleSelectionMade,
              onAnimationFinished: widget.onAnimationFinished,
              onNextButtonPressed: widget.onNextButtonPressed,
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
