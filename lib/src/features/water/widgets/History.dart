import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';

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
