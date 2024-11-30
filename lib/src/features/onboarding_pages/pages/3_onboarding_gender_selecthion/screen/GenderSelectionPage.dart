import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/3_onboarding_gender_selecthion/cubit/GenderSelection/gender_selection_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/GenderBox.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/ProgressIndicatorWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenderSelectionPage extends StatelessWidget {
  const GenderSelectionPage({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  Future<void> _saveGenderToSharedPreferences(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGender', gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProgressIndicatorWidget(value: 0.2),
            const Spacer(),
            AutoSizeText(
              S().genderselect,
              maxLines: 1,
              minFontSize: 16,
              maxFontSize: 32,
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).height * .04,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GenderBox(
                      gender: S().man,
                      icon: Icons.male,
                      onTap: () {
                        context
                            .read<GenderSelectionCubit>()
                            .selectGender(S().man);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GenderBox(
                      gender: S().female,
                      icon: Icons.female,
                      onTap: () {
                        context
                            .read<GenderSelectionCubit>()
                            .selectGender(S().female);
                      },
                    ),
                  ),
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
                        onPressed: () async {
                          await _saveGenderToSharedPreferences(selectedGender);
                          onNextButtonPressed;
                        },
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
