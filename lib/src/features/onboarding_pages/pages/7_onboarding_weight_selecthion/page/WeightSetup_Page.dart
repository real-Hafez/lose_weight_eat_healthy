import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/cubit/cubit/weight_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/onboarding_pages/pages/7_onboarding_weight_selecthion/page/WeightSelectionView.dart';

class WeightSetup_Page extends StatelessWidget {
  final VoidCallback onAnimationFinished;
  final VoidCallback onNextButtonPressed;
  final String heightUnit;

  const WeightSetup_Page({
    super.key,
    required this.onAnimationFinished,
    required this.onNextButtonPressed,
    required this.heightUnit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeightCubit()..loadPreferences(),
      child: WeightSelectionView(onNextButtonPressed: onNextButtonPressed),
    );
  }
}
