// water_intake_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/water_cards.dart';

class WaterIntakeWidget extends StatelessWidget {
  const WaterIntakeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(builder: (context, state) {
      if (state is WaterLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is WaterLoaded) {
        double percentage = state.currentIntake / state.waterNeeded;
        List<double> cardAmounts;
        if (state.unit == 'mL') {
          cardAmounts = [100, 200, 400, 500];
        } else if (state.unit == 'L') {
          cardAmounts = [0.1, 0.2, 0.4, 0.5];
        } else if (state.unit == 'US oz') {
          cardAmounts = [3.38, 6.76, 13.53, 16.91];
        } else {
          cardAmounts = [100, 200, 400, 500];
        }
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
                    "${(percentage * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${state.currentIntake.toStringAsFixed(1)} ${state.unit} / ${state.waterNeeded.toStringAsFixed(1)} ${state.unit}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
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
                        if (state.unit == 'mL') {
                          intakeAmount = 300.0;
                        } else if (state.unit == 'L') {
                          intakeAmount = 0.3;
                        } else if (state.unit == 'US oz') {
                          intakeAmount = 10.14;
                        } else {
                          intakeAmount = 600.0;
                        }
                        context
                            .read<WaterBloc>()
                            .add(AddWaterIntake(intakeAmount));
                      })
                ]))
              ]),
            ),
            water_cards(cardAmounts: cardAmounts),
          ],
        ));
      }
      return const SizedBox(height: 100);
    });
  }
}
