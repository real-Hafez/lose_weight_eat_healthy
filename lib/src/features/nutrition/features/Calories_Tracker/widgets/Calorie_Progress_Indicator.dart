import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/nutrition/features/Calories_Tracker/cubit/calorie_cubit.dart';
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
                Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: MediaQuery.sizeOf(context).height * .05,
                ),
                const SizedBox(height: 10),
                Text(
                  _convertBasedOnLanguage("0"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.sizeOf(context).height * .04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${_convertBasedOnLanguage(adjustedCalories.toStringAsFixed(0))} ${S().Calories}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: MediaQuery.sizeOf(context).height * .020,
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
