import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/EditWaterGoalDialog.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/water_cards.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:lose_weight_eat_healthy/src/shared/NumberConversion_Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntakeWidget extends StatelessWidget {
  final bool isEditMode;

  const WaterIntakeWidget({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(builder: (context, state) {
      if (state is WaterLoading) {
        const AppLoadingIndicator();
      }
      if (state is WaterLoaded) {
        double percentage = state.currentIntake / state.waterNeeded;
        List<double> cardAmounts;
        if (state.unit == 'mL' || state.unit == 'مل') {
          cardAmounts = [100, 200, 400, 500];
        } else if (state.unit == 'L' || state.unit == 'لتر') {
          cardAmounts = [0.1, 0.2, 0.4, 0.5];
        } else if (state.unit == 'US oz' || state.unit == 'أونصة') {
          cardAmounts = [3.38, 6.76, 13.53, 16.91];
        } else {
          cardAmounts = [1, 2, 4, 5];
        }
        double convertWaterAmount(
            double amount, String oldUnit, String newUnit) {
          if (oldUnit == newUnit) {
            return amount;
          }

          double amountInMl;
          if (oldUnit == 'L' || oldUnit == 'لتر') {
            amountInMl = amount * 1000;
          } else if (oldUnit == 'US oz' || oldUnit == 'أونصة') {
            amountInMl = amount * 29.5735;
          } else {
            amountInMl = amount;
          }
          if (newUnit == 'L' || newUnit == 'لتر') {
            return amountInMl / 1000;
          } else if (newUnit == 'US oz' || newUnit == 'أونصة') {
            return amountInMl / 29.5735;
          } else {
            return amountInMl;
          }
        }

        // Check if the app is in Arabic language
        final bool isArabic =
            Localizations.localeOf(context).languageCode == 'ar';

        return Center(
            child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .4,
              child: Stack(children: [
                LiquidCircularProgressIndicator(
                  value: percentage,
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  backgroundColor: Colors.white,
                  borderColor: Colors.red,
                  borderWidth: 2.0,
                  direction: Axis.vertical,
                ),
                Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    isArabic
                        ? NumberConversionHelper.convertToArabicNumbers(
                            "%${(percentage * 100).toStringAsFixed(0)}")
                        : "${(percentage * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).height * .045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isArabic
                            ? "${NumberConversionHelper.convertToArabicNumbers(convertWaterAmount(state.currentIntake, 'mL', state.unit).toStringAsFixed(1))} ${state.unit == 'mL' || state.unit == 'مل' ? S().mL : (state.unit == 'L' || state.unit == 'لتر' ? S().Litres : (state.unit == 'US oz' || state.unit == 'أونصة' ? S().USoz : ''))} / ${NumberConversionHelper.convertToArabicNumbers(convertWaterAmount(state.waterNeeded, 'mL', state.unit).toStringAsFixed(1))} ${state.unit == 'mL' || state.unit == 'مل' ? S().mL : (state.unit == 'L' || state.unit == 'لتر' ? S().Litres : (state.unit == 'US oz' || state.unit == 'أونصة' ? S().USoz : ''))}"
                            : "${convertWaterAmount(state.currentIntake, 'mL', state.unit).toStringAsFixed(1)} ${state.unit} / ${convertWaterAmount(state.waterNeeded, 'mL', state.unit).toStringAsFixed(1)} ${state.unit}",
                        style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).height * .025,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      if (isEditMode)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () async {
                            final newWaterNeeded = await showDialog<double>(
                              context: context,
                              builder: (_) => EditWaterGoalDialog(
                                currentWaterGoal: state.waterNeeded,
                              ),
                            );
                            if (newWaterNeeded != null) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setDouble(
                                  'water_needed', newWaterNeeded);
                              context.read<WaterBloc>().add(LoadInitialData());
                            }
                          },
                        ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Ionicons.add,
                        weight: 100,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.height * .1,
                      ),
                      onPressed: () {
                        double intakeAmount;
                        if (state.unit == 'mL' || state.unit == 'مل') {
                          intakeAmount = 300.0;
                        } else if (state.unit == 'L' || state.unit == 'لتر') {
                          intakeAmount = 0.3;
                        } else if (state.unit == 'US oz' ||
                            state.unit == 'أونصة') {
                          intakeAmount = 10.14;
                        } else {
                          intakeAmount = 1.0;
                        }
                        context
                            .read<WaterBloc>()
                            .add(AddWaterIntake(intakeAmount));
                      })
                ]))
              ]),
            ),
            water_cards(
              cardAmounts: cardAmounts,
              isEditMode: isEditMode,
            ),
          ],
        ));
      }
      return const SizedBox(height: 100);
    });
  }
}
