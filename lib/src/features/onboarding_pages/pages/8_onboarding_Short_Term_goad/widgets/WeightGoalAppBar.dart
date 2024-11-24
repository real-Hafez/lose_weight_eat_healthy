import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/8_onboarding_Short_Term_goad/cubit/cubit/weight_goal_page_state.dart';

class WeightGoalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeightGoalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<WeightGoalCubit, WeightGoalState>(
        builder: (context, state) => Text(
          '${state.userGoal} Goal',
          style: const TextStyle(fontFamily: 'Indie_Flower'),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
