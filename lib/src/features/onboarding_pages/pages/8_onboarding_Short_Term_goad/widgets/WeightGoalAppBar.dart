import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';

class WeightGoalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeightGoalAppBar({super.key, required this.onNextButtonPressed});
  final VoidCallback onNextButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<WeightGoalCubit, WeightGoalState>(
        builder: (context, state) {
          String modifiedGoalText;
          if (state.userGoal == 'Lose Weight') {
            modifiedGoalText = S().LoseWeight;
          } else if (state.userGoal == 'Gain Weight') {
            modifiedGoalText = S().GainWeight;
          } else {
            modifiedGoalText = 'f';
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                modifiedGoalText,
                style: const TextStyle(fontFamily: 'Indie_Flower'),
              ),
              TextButton(
                onPressed: onNextButtonPressed,
                child: Text(
                  S().skipButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Indie_Flower',
                    fontSize: MediaQuery.sizeOf(context).height * .025,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
