import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lose_weight_eat_healthy/generated/l10n.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_bloc.dart';
import 'package:lose_weight_eat_healthy/src/features/water/bloc/water_state.dart';

class History extends StatefulWidget {
  final List<Map<String, dynamic>> intakeHistory;
  final String savedUnit;

  const History({
    super.key,
    required this.intakeHistory,
    required this.savedUnit,
  });

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: BlocBuilder<WaterBloc, WaterState>(
        builder: (context, state) {
          if (state is WaterLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      '${S().History}',
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.minimize : Icons.add,
                        size: screenHeight * 0.03,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                ),
                if (isExpanded)
                  widget.intakeHistory.isEmpty
                      ? Center(
                          child: AutoSizeText(
                            'No history for this day',
                            style: TextStyle(fontSize: screenHeight * 0.02),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.intakeHistory.length,
                          itemBuilder: (context, index) {
                            final entry = widget.intakeHistory[index];
                            String date =
                                "${entry['date'].day}-${entry['date'].month}-${entry['date'].year}";
                            String time =
                                "${entry['date'].hour}:${entry['date'].minute.toString().padLeft(2, '0')}";
                            DateTime entryDate = DateTime(
                              entry['date'].year,
                              entry['date'].month,
                              entry['date'].day,
                            );
                            bool? goalStatus =
                                state.goalCompletionStatus[entryDate];

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: AutoSizeText(
                                      date,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Icon(
                                    Icons.water_drop_outlined,
                                    size: screenHeight * 0.025,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Expanded(
                                    flex: 3,
                                    child: AutoSizeText(
                                      '${entry['amount'].toStringAsFixed(1)} ${widget.savedUnit}',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: AutoSizeText(
                                      time,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  _buildGoalStatusIcon(
                                      goalStatus, screenHeight),
                                ],
                              ),
                            );
                          },
                        ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildGoalStatusIcon(bool? status, double screenHeight) {
    if (status == null) {
      return Icon(
        Icons.hourglass_empty,
        color: Colors.orange,
        size: screenHeight * 0.03,
      );
    } else if (status) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
        size: screenHeight * 0.03,
      );
    } else {
      return Icon(
        Icons.close,
        color: Colors.red,
        size: screenHeight * 0.03,
      );
    }
  }
}
