import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/History.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/water_calendar_widget.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Water extends StatelessWidget {
  const Water({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WaterBloc()..add(LoadInitialData()),
      child: Scaffold(
        body: BlocListener<WaterBloc, WaterState>(
          listener: (context, state) {
            if (state is WaterLoading) {
              const AppLoadingIndicator();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading...')),
              );
            } else if (state is WaterLoaded) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } else if (state is WaterError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<WaterBloc, WaterState>(
            builder: (context, state) {
              if (state is WaterLoading) {
                const AppLoadingIndicator();
              } else if (state is WaterLoaded) {
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () async {
                        final newWaterNeeded = await showDialog<double>(
                          context: context,
                          builder: (_) => EditWaterGoalDialog(
                            currentWaterGoal: state.waterNeeded,
                          ),
                        );
                        if (newWaterNeeded != null) {
                          // Update SharedPreferences with the new waterNeeded value
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setDouble('water_needed', newWaterNeeded);

                          // Reload the water data with the updated value
                          context.read<WaterBloc>().add(LoadInitialData());
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const WaterIntakeWidget(),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: water_calendar_widget(
                            onDaySelected: (selectedDay) {
                              context
                                  .read<WaterBloc>()
                                  .add(LoadIntakeHistory(selectedDay));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: History(
                            intakeHistory: state.intakeHistory,
                            savedUnit: state.unit,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is WaterError) {
                return const Center(
                  child: Text('Ohh there is error try to relogin '),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class EditWaterGoalDialog extends StatelessWidget {
  final double currentWaterGoal;

  const EditWaterGoalDialog({
    super.key,
    required this.currentWaterGoal,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: currentWaterGoal.toString());

    return AlertDialog(
      title: const Text("Edit Water Goal"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Enter new water goal",
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(null); // Close the dialog without changes
          },
        ),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            double? newWaterGoal = double.tryParse(controller.text);
            if (newWaterGoal != null && newWaterGoal > 0) {
              Navigator.of(context)
                  .pop(newWaterGoal); // Return the new water goal
            } else {
              // Handle invalid input (e.g., show error message)
            }
          },
        ),
      ],
    );
  }
}
