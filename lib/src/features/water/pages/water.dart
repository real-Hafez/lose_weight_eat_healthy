import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_event.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';
import 'package:lose_weight_eat_healthy/src/features/water/widgets/WaterIntakeWidget.dart';

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
              // Show loading spinner instantly
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Loading...')),
              );
            } else if (state is WaterLoaded) {
              // Remove any existing SnackBar when data is loaded
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } else if (state is WaterError) {
              // Show an error message if there is a failure
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<WaterBloc, WaterState>(
            builder: (context, state) {
              if (state is WaterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WaterLoaded) {
                return const SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      WaterIntakeWidget(),
                      // History(
                      //   intakeHistory: state.intakeHistory,
                      //   savedUnit: state.unit,
                      // )
                    ],
                  ),
                );
              } else if (state is WaterError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  final List<Map<String, dynamic>> intakeHistory;
  final String savedUnit;

  const History(
      {super.key, required this.intakeHistory, required this.savedUnit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        if (state is WaterLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'History',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .06,
                ),
              ),
              if (intakeHistory.isEmpty)
                const Text('No history for this day')
              else
                ...intakeHistory.map((entry) {
                  String date =
                      "${entry['date'].day}-${entry['date'].month}-${entry['date'].year}";
                  String time = "${entry['date'].hour}:${entry['date'].minute}";
                  DateTime entryDate = DateTime(entry['date'].year,
                      entry['date'].month, entry['date'].day);
                  bool? goalStatus = state.goalCompletionStatus[entryDate];

                  return Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .03,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * .02),
                      Icon(
                        Icons.water_drop_outlined,
                        size: MediaQuery.of(context).size.height * .02,
                      ),
                      Text(
                        'Water',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .02,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * .05),
                      Text(
                        '${entry['amount'].toStringAsFixed(1)} $savedUnit',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .02,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * .05),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .02,
                        ),
                      ),
                      const Spacer(),
                      _buildGoalStatusIcon(goalStatus),
                    ],
                  );
                }),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildGoalStatusIcon(bool? status) {
    if (status == null) {
      return const Icon(Icons.hourglass_empty,
          color: Colors.orange); // In-progress
    } else if (status) {
      return const Icon(Icons.check_circle,
          color: Colors.green); // Goal reached
    } else {
      return const Icon(Icons.close, color: Colors.red); // Goal missed
    }
  }
}
