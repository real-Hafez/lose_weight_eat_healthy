import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/calorie_cubit.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calorie_Progress_Indicator extends StatefulWidget {
  final int age;

  const Calorie_Progress_Indicator({
    super.key,
    required this.age,
  });

  @override
  State<Calorie_Progress_Indicator> createState() =>
      _Calorie_Progress_IndicatorState();
}

class _Calorie_Progress_IndicatorState
    extends State<Calorie_Progress_Indicator> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        context.read<CalorieCubit>().fetchCaloriesAndMacros(
              userId,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalorieCubit, Calorie_State>(
      builder: (context, state) {
        if (state is CalorieCubitLoading) {
          return const AppLoadingIndicator();
        } else if (state is CalorieCubitError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        } else if (state is CalorieCubitSuccess) {
          int adjustedCalories = state.calories;
          return CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 15.0,
            animation: true,
            percent: 0,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 30,
                ),
                const SizedBox(height: 10),
                const Text(
                  "0",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/${adjustedCalories.toStringAsFixed(0)} cal", // Display adjusted calories
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            progressColor: Colors.orange,
            backgroundColor: Colors.white12,
            circularStrokeCap: CircularStrokeCap.round,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
