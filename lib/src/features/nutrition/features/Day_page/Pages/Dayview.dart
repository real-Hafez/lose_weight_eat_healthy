import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/Calorie_Tracker_Widget.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Pages/cubit/cubit/DayViewstate.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Day_page/Pages/cubit/cubit/DayViewCubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/calender/widgets/nutrition_calender.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Breakfast.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Dinner.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Food_Card_Lunch.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/Meal_Type_Display.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/widgets/mealPlans.dart';

class Dayview extends StatelessWidget {
  const Dayview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DayViewCubit(MealPlanService()),
      child: Scaffold(
        body: BlocBuilder<DayViewCubit, DayViewState>(
          builder: (context, state) {
            final cubit = context.read<DayViewCubit>();
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Nutrition_Calendar(),
                  const SizedBox(height: 25),
                  const CalorieTrackerWidget(),
                  const SizedBox(height: 25),
                  Meal_Type_Display(
                    food: S().Breakfast,
                    minmize: state.breakfastMinimized,
                    onToggleMinimize: cubit.toggleBreakfastMinimize,
                    mealCalories:
                        (state.currentMealPlan?['breakfast']['medin'] ?? 0) *
                            state.totalCalories,
                  ),
                  if (!state.breakfastMinimized &&
                      state.currentMealPlan != null)
                    Food_Card_Breakfast(
                      remainingCalories:
                          state.totalCalories - state.breakfastCalories,
                      mincal: state.currentMealPlan!['breakfast']['mincal'],
                      maxcal: state.currentMealPlan!['breakfast']['maxcal'],
                      description: state.currentMealPlan!['breakfast']
                          ['description'],
                    ),
                  Meal_Type_Display(
                    food: S().Lunch,
                    minmize: state.lunchMinimized,
                    onToggleMinimize: cubit.toggleLunchMinimize,
                    mealCalories:
                        (state.currentMealPlan?['lunch']['medin'] ?? 0) *
                            state.totalCalories,
                  ),
                  if (!state.lunchMinimized && state.currentMealPlan != null)
                    Food_Card_Lunch(
                      remainingCalories: state.totalCalories -
                          (state.breakfastCalories + state.lunchCalories),
                      mincal: state.currentMealPlan!['lunch']['mincal'],
                      maxcal: state.currentMealPlan!['lunch']['maxcal'],
                      description: state.currentMealPlan!['lunch']
                          ['description'],
                    ),
                  Meal_Type_Display(
                    food: S().Dinner,
                    minmize: state.dinnerMinimized,
                    onToggleMinimize: cubit.toggleDinnerMinimize,
                    mealCalories:
                        (state.currentMealPlan?['dinner']['medin'] ?? 0) *
                            state.totalCalories,
                  ),
                  if (!state.dinnerMinimized && state.currentMealPlan != null)
                    Food_Card_Dinner(
                      remainingCalories: state.totalCalories -
                          (state.breakfastCalories + state.lunchCalories),
                      mincal: state.currentMealPlan!['dinner']['mincal'],
                      maxcal: state.currentMealPlan!['dinner']['maxcal'],
                      description: state.currentMealPlan!['dinner']
                          ['description'],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
// mashed rice fave