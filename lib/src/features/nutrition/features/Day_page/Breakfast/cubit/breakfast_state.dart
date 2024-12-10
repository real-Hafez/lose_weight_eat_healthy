import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Breakfast/cubit/breakfast_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Nutrition_Info_Card.dart';

class Breakfast extends StatelessWidget {
  const Breakfast({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BreakfastCubit()..loadClosestMeal(),
      child: BlocBuilder<BreakfastCubit, BreakfastState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.closestMeal == null) {
            return const Center(child: Text('No suitable breakfast found'));
          } else {
            var meal = state.closestMeal!;
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
              onTap: () => context.read<BreakfastCubit>().markAsCompleted(),
              child: NutritionInfoCard(
                tips: tips,
                steps: steps,
                Ingredients: ingredients,
                foodName: meal['food_Name_Arabic'] ?? 'Unknown',
                foodImage:
                    meal['food_Image'] ?? 'https://via.placeholder.com/150',
                calories: (meal['calories'] as num?)?.toDouble() ?? 0.0,
                weight: (meal['weight'] as num?)?.toDouble() ?? 0.0,
                fat: (meal['fat'] as num?)?.toDouble() ?? 0.0,
                carbs: (meal['carbs'] as num?)?.toDouble() ?? 0.0,
                protein: (meal['protein'] as num?)?.toDouble() ?? 0.0,
                isCompleted: state.isCompleted,
                animationController: AnimationController(
                    vsync: AnimatedGridState()), // Update animation logic here
                meal_id: meal['id'],
              ),
            );
          }
        },
      ),
    );
  }
}
