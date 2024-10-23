import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/calorie_cubit.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth to get the current user

class Calorie_Progress_Indicator extends StatelessWidget {
  final int age;

  const Calorie_Progress_Indicator({
    super.key,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current user's UID from FirebaseAuth
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      // Handle case where userId is not available (e.g., user is not logged in)
      return const Text(
        'Error: User not logged in',
        style: TextStyle(color: Colors.red),
      );
    }

    // Fetch calorie needs when the widget is built
    context.read<Calorie_Cubit>().fetchAndCalculateCalorieNeeds(userId, age);

    return BlocBuilder<Calorie_Cubit, Calorie_State>(
      builder: (context, state) {
        if (state is CalorieCubitLoading) {
          return const AppLoadingIndicator();
        } else if (state is CalorieCubitError) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        } else if (state is CalorieCubitSuccess) {
          // Here we're using the adjustedCalories from the state
          double adjustedCalories = state.dailyCalories; // Adjusted value
          double consumedCalories =
              3000; // Example consumed calories, update this with your logic
          double percent =
              (consumedCalories / adjustedCalories).clamp(0.0, 1.0);

          return CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 13.0,
            animation: true,
            percent: percent,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  "$consumedCalories Kcal",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/${adjustedCalories.toStringAsFixed(0)} Kcal", // Display adjusted calories
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
        return const SizedBox
            .shrink(); // Return an empty widget if none of the states match
      },
    );
  }
}
