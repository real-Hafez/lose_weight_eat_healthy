import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/EditWaterGoalDialog.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/History.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/water_calendar_widget.dart';
import 'package:lose_weight_eat_healthy/src/shared/AppLoadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  bool isEditMode = false;

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
                      icon: Icon(isEditMode ? Icons.close : Icons.edit),
                      onPressed: () {
                        setState(() {
                          isEditMode = !isEditMode;
                        });
                      },
                    ),
                  ),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        WaterIntakeWidget(isEditMode: isEditMode),
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
                        if (isEditMode)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: IconButton(
                              icon: const Icon(
                                  Icons.edit), // Secondary edit button
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

                                  context
                                      .read<WaterBloc>()
                                      .add(LoadInitialData());
                                }
                              },
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
