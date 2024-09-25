// water_intake_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:lose_weight_eat_healthy/src/features/Home/widgets/calender_for_training_water.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/pages/water.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/respontiveRow.dart';

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

        return Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.height * .4,
                child: Stack(
                  children: [
                    LiquidCircularProgressIndicator(
                      value: percentage,
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      backgroundColor: Colors.white,
                      borderColor: Colors.red,
                      borderWidth: 2.0,
                      direction: Axis.vertical,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                              // Adjust the intake amount dynamically based on the unit
                              double intakeAmount;
                              if (state.unit == 'mL') {
                                intakeAmount = 300.0; // 300 mL
                              } else if (state.unit == 'L') {
                                intakeAmount =
                                    0.3; // 0.3 L (equivalent to 300 mL)
                              } else if (state.unit == 'US oz') {
                                intakeAmount =
                                    10.14; // 10.14 oz (equivalent to 300 mL)
                              } else {
                                intakeAmount =
                                    300.0; // Fallback to mL if unit is unrecognized
                              }

                              context
                                  .read<WaterBloc>()
                                  .add(AddWaterIntake(intakeAmount));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ResponsiveRow(
                      children: [
                        WaterIntakeCard(
                          onTap: (amount) => context
                              .read<WaterBloc>()
                              .add(const AddWaterIntake(100)),
                          icon: Icons.water_drop,
                          backgroundColor: Colors.blueAccent,
                          amount: 100,
                        ),
                        WaterIntakeCard(
                          onTap: (amount) => context
                              .read<WaterBloc>()
                              .add(const AddWaterIntake(200)),
                          icon: Icons.local_drink,
                          backgroundColor: Colors.lightBlue,
                          amount: 200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ResponsiveRow(
                      children: [
                        WaterIntakeCard(
                          onTap: (amount) => context
                              .read<WaterBloc>()
                              .add(const AddWaterIntake(400)),
                          icon: Icons.local_cafe,
                          backgroundColor: Colors.orangeAccent,
                          amount: 400,
                        ),
                        WaterIntakeCard(
                          onTap: (amount) => context
                              .read<WaterBloc>()
                              .add(const AddWaterIntake(500)),
                          icon: Icons.local_bar,
                          backgroundColor: Colors.purpleAccent,
                          amount: 500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Calendar to show goal completion status
              Padding(
                padding: const EdgeInsets.all(12),
                child: calender_for_training_water(
                  goalCompletionStatus: state.goalCompletionStatus,
                  onDaySelected: (selectedDay) {
                    context
                        .read<WaterBloc>()
                        .add(LoadIntakeHistory(selectedDay));
                  },
                ),
              ),

              // History section to display daily intake history
              Padding(
                padding: const EdgeInsets.all(12),
                child: History(
                  intakeHistory: state.intakeHistory,
                  savedUnit: state.unit,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox(
        height: 100,
      );
    });
  }
}
