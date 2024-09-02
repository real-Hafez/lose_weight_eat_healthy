import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/GenderBox.dart';
import 'package:lose_weight_eat_healthy/src/features/Setup/widgets/next_button.dart';

class GenderSelectionPage extends StatelessWidget {
  const GenderSelectionPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

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
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: GenderBox(gender: 'Male', icon: Icons.male)),
                  SizedBox(width: 20),
                  Expanded(
                      child: GenderBox(gender: 'Female', icon: Icons.female)),
                ],
              ),
            ),
            const Spacer(),
            BlocBuilder<GenderSelectionCubit, String?>(
              builder: (context, selectedGender) {
                return selectedGender != null
                    ? NextButton(
                        collectionName: 'gender',
                        userId: FirebaseAuth.instance.currentUser?.uid,
                        onPressed: onNextButtonPressed,
                        dataToSave: {
                          'selectedGender': selectedGender,
                        },
                        saveData: true,
                      )
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
