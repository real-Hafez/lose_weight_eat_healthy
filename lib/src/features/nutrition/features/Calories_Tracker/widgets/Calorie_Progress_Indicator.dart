import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/calorie_cubit.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/widgets/MealCompletionState.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Calorie_Progress_Indicator extends StatefulWidget {
  const Calorie_Progress_Indicator({
    super.key,
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

  String _convertBasedOnLanguage(String input) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ar') {
      return NumberConversionHelper.convertToArabicNumbers(input);
    }
    return input;
  }

// In Calorie_Progress_Indicator
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalorieCubit, Calorie_State>(
      builder: (context, calorieState) {
        if (calorieState is CalorieCubitLoading) {
          return const AppLoadingIndicator();
        } else if (calorieState is CalorieCubitError) {
          return Text(
            calorieState.message,
            style: const TextStyle(color: Colors.red),
          );
        } else if (calorieState is CalorieCubitSuccess) {
          return BlocBuilder<MealCompletionCubit, MealCompletionState>(
            builder: (context, mealState) {
              double completionPercentage = 0.0;
              if (mealState is MealCompletionSuccess) {
                completionPercentage = mealState.completionPercentage;
              }
              print('Progress indicator updated: $completionPercentage');
              return CircularPercentIndicator(
                radius: 120.0,
                addAutomaticKeepAlive: true,
                animateFromLastPercent: true,
                animationDuration: 2000,
                lineWidth: 15.0,
                animation: true,
                curve: Curves.easeInOut,
                percent: completionPercentage,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.8, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: MediaQuery.sizeOf(context).height * .05,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.9, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Text(
                            _convertBasedOnLanguage(
                              (completionPercentage * calorieState.calories)
                                  .toStringAsFixed(0),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.sizeOf(context).height * .04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      "${_convertBasedOnLanguage(calorieState.calories.toStringAsFixed(0))} ${S().Calories}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: MediaQuery.sizeOf(context).height * .020,
                      ),
                    ),
                  ],
                ),
                linearGradient: const LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ), // Gradient effect on progress
                // arcType: ArcType.,

                rotateLinearGradient: true,
                backgroundColor: Colors.white12,
                circularStrokeCap: CircularStrokeCap.butt,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
