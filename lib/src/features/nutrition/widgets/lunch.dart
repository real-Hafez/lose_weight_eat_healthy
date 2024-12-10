import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Lunch/cubit/lunch_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Lunch/cubit/lunch_state.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';

class Lunch extends StatefulWidget {
  const Lunch({super.key});

  @override
  _LunchState createState() => _LunchState();
}

class _LunchState extends State<Lunch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Lunchcubit()..loadClosestMeal(),
      child: BlocBuilder<Lunchcubit, LunchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.closestMeal == null) {
            return const Center(child: Text('No suitable lunch found'));
          } else {
            var meal = state.closestMeal!;

            final foodName = meal['food_Name_Arabic'] ?? 'Unknown';
            final foodCalories = (meal['calories'] as num?)?.toDouble() ?? 0.0;
            final foodProtein = (meal['protein'] as num?)?.toDouble() ?? 0.0;
            final foodCarbs = (meal['carbs'] as num?)?.toDouble() ?? 0.0;
            final foodFat = (meal['fat'] as num?)?.toDouble() ?? 0.0;
            final ingredients = (meal['ingredients_Ar'] as List<dynamic>? ?? [])
                .map((item) => item.toString())
                .toList();
            final steps = (meal['preparation_steps'] as List<dynamic>? ?? [])
                .map((item) => item.toString())
                .toList();
            final tips = (meal['tips'] as List<dynamic>? ?? [])
                .map((item) => item as Map<String, dynamic>)
                .toList();
            return GestureDetector(
              onTap: () {
                if (context.mounted) {
                  context.read<Lunchcubit>().markAsCompleted();
                }
              },
              child: NutritionInfoCard(
                foodName: foodName,
                foodImage:
                    meal['food_Image'] ?? 'https://via.placeholder.com/150',
                calories: foodCalories,
                weight: (meal['weight'] as num?)?.toDouble() ?? 0.0,
                fat: foodFat,
                carbs: foodCarbs,
                protein: foodProtein,
                isCompleted: state.isCompleted,
                Ingredients: ingredients,
                steps: steps,
                tips: tips,
                animationController: _controller,
                meal_id: meal['id'],
              ),
            );
          }
        },
      ),
    );
  }
}
