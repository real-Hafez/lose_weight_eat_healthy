import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/4_onboarding_main_use_for_app/widget/maintraget_card.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/widgets/next_button.dart';

class Maintarget extends StatefulWidget {
  const Maintarget({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
  });

  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;

  @override
  _MaintargetState createState() => _MaintargetState();
}

class _MaintargetState extends State<Maintarget> {
  String? selectedGoal = 'Lose Weight'; // . ,a make the defult losing weight

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        AutoSizeText(
          S().Goal,
          minFontSize: 18,
          maxFontSize: 30,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .05,
        ),
        maintraget_card(
          card_text: S().LoseWeight,
          isSelected: selectedGoal == 'Lose Weight',
          onTap: () => setState(() => selectedGoal = 'Lose Weight'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        maintraget_card(
          card_text: S().MaintainWeight,
          isSelected: selectedGoal == 'Maintain Weight',
          onTap: () => setState(() => selectedGoal = 'Maintain Weight'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        maintraget_card(
          card_text: S().GainWeight,
          isSelected: selectedGoal == 'Gain Weight',
          onTap: () => setState(() => selectedGoal = 'Gain Weight'),
        ),
        Spacer(),
        NextButton(
          onPressed: widget.onNextButtonPressed,
          collectionName: 'user target',
          dataToSave: {'target': selectedGoal},
          saveData: true,
          userId: FirebaseAuth.instance.currentUser?.uid,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .15,
        ),
      ],
    );
  }
}
